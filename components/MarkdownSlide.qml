import QtQuick

Flickable {
    id: flick
    property url source

    contentWidth: markdownText.contentWidth
    contentHeight: markdownText.contentHeight
    topMargin: fontSize * 2
    leftMargin: fontSize * 2
    rightMargin: fontSize * 2

    TextEdit {
        id: markdownText
        readOnly: true
        width: flick.width
        wrapMode: Text.Wrap
        textFormat: Text.MarkdownText
        textDocument.source: flick.source
        baseUrl: flick.source
        font.pixelSize: fontSize // from Slides.qml
        transformOrigin: Item.TopLeft
        scale: 1.5
    }
}
