import QtQuick

Rectangle {
    id: background
    width: 1920
    height: 1080
    property list<string> filenames: listEdit.text.split("\n")
    property int current: 0
    property string currentFilename: filenames[current]
    property string currentType: currentFilename.length ? currentFilename.split(".")[1] : ""

    Shortcut {
        sequence: StandardKey.MoveToPreviousPage
        enabled: current > 0
        onActivated: --current
    }

    Shortcut {
        sequence: StandardKey.MoveToNextPage
        enabled: current < filenames.length - 1
        onActivated: ++current
    }

    Loader {
        anchors.fill: parent

        source:
            switch (currentType) {
            case "qml":
                "presentation/" + currentFilename
                break
            case "md":
                "components/MarkdownSlide.qml"
                break
            default:
                ""
            }

        initialProperties: // https://codereview.qt-project.org/c/qt/qtdeclarative/+/750155
            switch (currentType) {
            case "md":
                return { "source" : "../presentation/" + currentFilename }
                break
            default:
                ""
            }
    }

    Image {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 2
        source: "images/pencil.png"
        TapHandler {
            onTapped: slideSorter.visible = !slideSorter.visible
        }
    }

    Window {
        id: slideSorter
        // invisible by default
        TextEdit {
            id: listEdit
            width: parent.width
            height: parent.height / 2

            selectByMouse: false        // we drive selection ourselves
            persistentSelection: true
            wrapMode: TextEdit.NoWrap
            textFormat: TextEdit.PlainText
            textDocument.source: "presentation/slides.txt"

            property bool includeLineBreak: false

            // Which gesture is in progress: 0 = none, 1 = select, 2 = move.
            property int dragMode: 0

            // Start/end of the whole-line selection being moved.
            property int srcStart: -1
            property int srcEnd: -1

            // ---- geometry helpers, all in TextEdit-local coordinates ----

            function selectLineAt(y) {
                var pos = positionAt(width / 2, y);
                var lineStart = text.lastIndexOf("\n", pos - 1) + 1;
                var lineEnd = text.indexOf("\n", pos);
                if (lineEnd < 0)
                    lineEnd = text.length;
                else if (includeLineBreak)
                    lineEnd = lineEnd + 1;
                srcStart = lineStart;
                srcEnd = lineEnd;
                select(lineStart, lineEnd);
            }

            function targetGapFor(y) {
                var pos = positionAt(width / 2, y);
                var lineIdx = text.substring(0, pos).split("\n").length - 1;
                var r = positionToRectangle(pos);
                return (y < r.y + r.height / 2) ? lineIdx : lineIdx + 1;
            }

            function gapYFor(y) {
                var pos = positionAt(width / 2, y);
                var r = positionToRectangle(pos);
                return (y < r.y + r.height / 2) ? r.y : r.y + r.height;
            }

            function moveSelectedLineTo(y) {
                if (srcStart < 0)
                    return;

                var lines = text.split("\n");
                var srcIndex = text.substring(0, srcStart).split("\n").length - 1;
                var gap = targetGapFor(y);

                var item = lines[srcIndex];
                lines.splice(srcIndex, 1);
                // Removing the source shifts everything after it left by one.
                var insertAt = gap > srcIndex ? gap - 1 : gap;
                insertAt = Math.max(0, Math.min(lines.length, insertAt));
                lines.splice(insertAt, 0, item);

                text = lines.join("\n");

                // Re-select the moved line at its new home.
                var newStart = lines.slice(0, insertAt).join("\n").length
                               + (insertAt > 0 ? 1 : 0);
                var newEnd = newStart + item.length
                             + (insertAt < lines.length - 1 && includeLineBreak ? 1 : 0);
                select(newStart, newEnd);
            }

            // ---- the one gesture, split by initial direction ----

            function dragBegin(press, cur) {
                var dx = Math.abs(cur.x - press.x);
                var dy = Math.abs(cur.y - press.y);
                dragMode = (dx > dy) ? 1 : 2;
                if (dragMode === 1)
                    select(positionAt(press.x, press.y), positionAt(cur.x, cur.y));
                else
                    selectLineAt(press.y);
            }

            function dragUpdate(press, cur) {
                // Only select mode needs live updates; the move visuals are
                // bound to the handler's centroid below.
                if (dragMode === 1)
                    select(positionAt(press.x, press.y), positionAt(cur.x, cur.y));
            }

            function dragEnd(cur) {
                if (dragMode === 2)
                    moveSelectedLineTo(cur.y);
                dragMode = 0;
            }

            DragHandler {
                id: mover
                target: null            // we drive selection and visuals ourselves
                cursorShape: listEdit.dragMode === 2 ? Qt.ClosedHandCursor : Qt.IBeamCursor
                onActiveChanged: {
                    if (active)
                        listEdit.dragBegin(centroid.pressPosition, centroid.position);
                    else
                        listEdit.dragEnd(centroid.position);
                }
            }

            // Live drag updates: react to every centroid move.
            property point moverPos: mover.centroid.position
            onMoverPosChanged: if (mover.active)
                                   dragUpdate(mover.centroid.pressPosition, moverPos)

            // Drop marker: where the line will land (move mode only).
            Rectangle {
                visible: mover.active && listEdit.dragMode === 2
                x: 0
                width: listEdit.width
                height: 2
                color: "#4ec9b0"
                y: visible ? listEdit.gapYFor(mover.centroid.position.y) : 0
            }

            // Ghost: a floating copy of the line being dragged (move mode only).
            Rectangle {
                id: ghost
                visible: mover.active && listEdit.dragMode === 2
                x: 8
                width: Math.min(listEdit.width - 16, ghostText.implicitWidth + 16)
                height: ghostText.implicitHeight + 8
                radius: 4
                color: "#264f78"
                opacity: 0.9
                y: visible ? mover.centroid.position.y - height / 2 : 0

                Text {
                    id: ghostText
                    anchors.centerIn: parent
                    color: "#ffffff"
                    font: listEdit.font
                    text: listEdit.srcStart >= 0
                          ? listEdit.getText(listEdit.srcStart, listEdit.srcEnd).replace(/\n/g, "")
                          : ""
                }
            }
        }
    }

}

