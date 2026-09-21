import QtQuick

Flickable {
    id: flick
    property url source

    contentWidth: Math.max(textEdit.contentWidth, flick.width)
    contentHeight: Math.max(textEdit.contentHeight, flick.height)

    TextEdit {
        id: textEdit
        readOnly: true
        anchors.centerIn: parent
        textFormat: TextEdit.RichText
        textDocument.source: flick.source
        baseUrl: flick.source
        font.pixelSize: fontSize // from Slides.qml
        font.family: fontFamily

        Rectangle {
            // anchors.fill: parent
            width: 10; height: 10
            color: "transparent"
            border.color: "green"
        }
    }
}
