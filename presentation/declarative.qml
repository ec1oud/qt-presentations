import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal

SplitView {
    orientation: Qt.Vertical
    width: 480; height: 640

    TextEdit {
        id: textEdit
        textFormat: Text.MarkdownText
        font { family: fontFamily
               pixelSize: fontSize * 0.7 } // from Slides.qml
        text: "
# Declarative Programming
- bind a property to an expression
- automatic updates
- syntax: CSS-like
- non-declarative fallback: JS signal handling
- interpreted or compiled
"
        SplitView.minimumHeight: 50
    }

    Item {
        SplitView.fillWidth: true
        SplitView.fillHeight: true

        Rectangle {
            anchors { fill: parent; margins: 50 }
            color: tapHandler.pressed ? "Green" : "LightGreen"

            Text {
                x: 10; y: 10
                text: `${textEdit.text.length} characters`
            }

            TapHandler {
                id: tapHandler
                // JS syntax for a one-shot change (not declarative):
                // onTapped: parent.color = "Green"
            }
        }
    }
}
