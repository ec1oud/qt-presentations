import QtQuick 2.14
import QtQuick.Controls 2.14

ApplicationWindow {
    width: 800
    height: 600
    visible: true

    ScrollView {
        anchors.fill: parent

        TextArea {
            id: textEdit
            textFormat: Text.MarkdownText
            wrapMode: Text.WordWrap
            font.pointSize: 12
            onLinkHovered: statusText.text = link
            onLinkActivated: Qt.openUrlExternally(link)

            Component.onCompleted: {
                var request = new XMLHttpRequest()
                request.open('GET', 'example.md')
                request.onreadystatechange = function(event) {
                    if (request.readyState === XMLHttpRequest.DONE)
                        textEdit.text = request.responseText
                }
                request.send()
            }
        }
    }
    Rectangle {
        anchors.bottom: parent.bottom
        width: statusText.width + 12
        height: statusText.height + 4
        Text {
            id: statusText
            x: 6; y: 2
        }
    }
}
