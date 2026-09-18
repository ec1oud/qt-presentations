import QtQuick
import QtQuick.Controls

Flickable {
    id: flick
    property url source

    contentWidth: plainText.contentWidth
    contentHeight: plainText.contentHeight
    leftMargin: 40
    rightMargin: 40
    topMargin: 40
    bottomMargin: 40

    TextEdit {
        id: plainText
        readOnly: true
        width: flick.width
        wrapMode: Text.Wrap
        textFormat: Text.PlainText
        textDocument.source: flick.source
        baseUrl: flick.source
        font.family: "monospace"
        font.pixelSize: fontSize // from Slides.qml
    }

    ScrollBar.vertical: ScrollBar { id: scrollBar; width: 24 }
}
