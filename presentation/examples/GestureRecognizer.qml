import QtQuick 2.0
import QtQuick.Particles 2.0

ListView {
    id: list; model: 13
    height: 600; width: 300; clip: true
    delegate: Rectangle {
        color: index % 2 == 0 ? "lightsteelblue" : "#eee"
        width: list.width
        height: 108
        MultiPointTouchArea {
            anchors.fill: parent
            minimumTouchPoints: 1; maximumTouchPoints: 1
            property bool interested: false
            onGestureStarted: {
                var tp = gesture.touchPoints[0]
                if (Math.abs(tp.startY - tp.y) < gesture.dragThreshold)
                    interested = true
            }
            onUpdated: if (interested) {
                var tp = touchPoints[0]
                rotation.angle = 2 * (tp.startX - tp.x)
            }
            function finish() {
                if (rotation.angle > 90 || rotation.angle < -90)
                    rotation.angle = 180
                else
                    rotation.angle = 0
            }
            onReleased: finish()
            onCanceled: finish()
        }
        Flipable {
            id: flipper
            anchors { margins: 16; right: parent.right; verticalCenter: parent.verticalCenter }
            width: 61.5; height: 96
            back: Item {
                clip: true
                width: parent.width; height: parent.height
                Image {
                    source: "images/guyenne-classic.png"
                    x: -index * parent.width
                }
            }
            front: Item {
                clip: true
                width: parent.width; height: parent.height
                Image {
                    source: "images/guyenne-classic.png"
                    x: -2 * parent.width
                    y: -4 * parent.height
                }
            }
            transform: Rotation {
                id: rotation
                origin.x: flipper.width / 2
                origin.y: flipper.height / 2
                axis.x: 0; axis.y: 1; axis.z: 0
                angle: 0
                Behavior on angle { NumberAnimation { duration: 500 } }
            }
        }
    }
}
