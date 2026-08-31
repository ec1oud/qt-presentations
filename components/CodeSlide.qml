import QtQuick
import QtQuick.Controls
// import org.kde.syntaxhighlighting

Flickable {
    id: flick
    property url source
    property string language

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

        // SyntaxHighlighter {
        //     textEdit: codeText
        //     definition: flick.language
        // }
    }

    ScrollBar.vertical: ScrollBar { id: scrollBar; width: 24 }
}
