import QtQuick 2.1

Rectangle {
    width: 400; height: 600
    Flickable {
        anchors.fill: parent; contentHeight: 900
        Rectangle {
            x: 50; y: 100;
            width: 300; height: 300;
            color: mouse1.pressed ? "green" : "red"
            MouseArea {
                id: mouse1; anchors.fill: parent;
                onPressed: mouse.accepted = false
            }
        }
        Rectangle {
            x: 50; y: 500;
            width: 300; height: 300;
            color: mouse2.pressed ? "red" : "blue"
            MouseArea {
                id: mouse2; anchors.fill: parent
                preventStealing: true
            }
        }
    }
}
