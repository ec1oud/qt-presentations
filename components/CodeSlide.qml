import QtQuick
import QtQuick.Controls
import Lsp

Flickable {
    id: flick
    property url source
    property string language
    property bool diagnosticsEnabled: false

    contentWidth: codeText.contentWidth
    contentHeight: codeText.contentHeight

    TextEdit {
        id: codeText
        readOnly: true
        width: flick.width
        wrapMode: Text.Wrap
        textDocument.source: flick.source
        font.family: "monospace"
        font.pixelSize: fontSize // from Slides.qml

        DocumentLSClient {
            document: codeText.textDocument
            diagnosticsEnabled: flick.diagnosticsEnabled
        }
    }

    ScrollBar.vertical: ScrollBar { id: scrollBar; width: 24 }
}
