import QtQuick 2.14

import "resources"

Rectangle {
    color: "#444"
    width: 480
    height: 480

    FakeFlickable {
        id: ff
        anchors.fill: parent
        anchors.rightMargin: rightSB.width
        Text {
            id: text
            color: "beige"
            font.family: "mono"
            font.pointSize: 14
            onTextChanged: console.log("text geom " + width + "x" + height +
                ", parent " + parent + " geom " + parent.width + "x" + parent.height)
        }

        onFlickStarted: console.log("flick started with velocity " + velocity)
        onFlickEnded: console.log("flick ended with velocity " + velocity)

        Component.onCompleted: {
            var request = new XMLHttpRequest()
            request.open('GET', 'fakeFlickable.qml')
            request.onreadystatechange = function(event) {
                if (request.readyState === XMLHttpRequest.DONE)
                    text.text = request.responseText
            }
            request.send()
        }
    }

    ScrollBar {
        id: rightSB
        objectName: "rightSB"
        flick: ff
        height: parent.height - width
        anchors.right: parent.right
    }

    ScrollBar {
        id: bottomSB
        objectName: "bottomSB"
        flick: ff
        width: parent.width - height
        anchors.bottom: parent.bottom
    }

    Rectangle {
        id: cornerCover
        color: "lightgray"
        width: rightSB.width
        height: bottomSB.height
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
    }
}
