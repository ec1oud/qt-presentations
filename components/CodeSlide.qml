import QtQuick
import QtQuick.Controls

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

        Component.onCompleted: {
            // missing or unbuilt gq submodule is non-fatal
            const component = Qt.createComponent(Qt.resolvedUrl("CodeHighlighter.qml"))
            if (component.status === Component.Error) {
                console.warn("CodeSlide: syntax highlighting unavailable (is the gq submodule checked out and built?):",
                             component.errorString())
                return
            }
            component.createObject(codeText, {
                document: codeText.textDocument,
                diagnosticsEnabled: Qt.binding(() => flick.diagnosticsEnabled)
            })
        }
    }

    ScrollBar.vertical: ScrollBar { id: scrollBar; width: 24 }
}
