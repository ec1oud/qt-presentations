import QtQuick

Flickable {
    id: flick
    property url source

    contentWidth: Math.max(markdownText.contentWidth, flick.width)
    contentHeight: Math.max(markdownText.contentHeight, flick.height)
    onWidthChanged: autoScale()
    onHeightChanged: autoScale()
    Component.onCompleted: autoScale()

    function autoScale() {
        const idealW = width - 200
        const idealH = height - topMargin - 100
        markdownText.scale = Math.min(idealW / markdownText.implicitWidth,
                                      idealH / markdownText.implicitHeight)
        // console.log(idealW, idealH, markdownText.implicitWidth, markdownText.implicitHeight)
    }

    TextEdit {
        id: markdownText
        readOnly: true
        anchors.centerIn: parent
        textFormat: Text.MarkdownText
        textDocument.source: flick.source
        baseUrl: flick.source
        font.pixelSize: fontSize // from Slides.qml
        font.family: fontFamily

        // Rectangle {
        //     anchors.fill: parent
        //     color: "transparent"
        //     border.color: "green"
        // }
    }
}
