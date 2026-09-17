import QtQuick
import QtQuick.Controls

Flickable {
    id: flick
    property url source
    property string language
    property alias diagnosticsEnabled: highlighterLoader.diagnosticsWanted

    contentWidth: codeText.contentWidth
    contentHeight: codeText.contentHeight
    leftMargin: 40
    rightMargin: 40
    topMargin: 40
    bottomMargin: 40

    TextEdit {
        id: codeText
        readOnly: true
        width: flick.width
        wrapMode: Text.Wrap
        textDocument.source: flick.source
        font.family: "monospace"
        font.pixelSize: fontSize // from Slides.qml

        Loader {
            id: highlighterLoader
            // missing or unbuilt gq submodule is non-fatal
            source: "CodeHighlighter.qml"
            // Loader is the creation context for what it loads: make these available
            property var targetDocument: codeText.textDocument
            property bool diagnosticsWanted: false

            onStatusChanged: if (status === Loader.Error)
                console.warn("CodeSlide: syntax highlighting unavailable (is the gq submodule checked out and built?)")
        }
    }

    ScrollBar.vertical: ScrollBar { id: scrollBar; width: 24 }
}
