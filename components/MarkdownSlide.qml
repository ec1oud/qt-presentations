import QtQuick

Flickable {
    id: flick
    property url source

    contentWidth: markdownText.contentWidth
    contentHeight: markdownText.contentHeight

    TextEdit {
        id: markdownText
        readOnly: true
        width: flick.width
        // TODO: font, color
        wrapMode: Text.Wrap
        textFormat: Text.MarkdownText
        textDocument.source: flick.source
    }
}
