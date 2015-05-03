import QtQuick 2.0

Flickable {
    width: 400; height: 600; contentHeight: 900
    Rectangle {
        x: 50; y: 100;
        width: 300; height: 300;
        color: mouse1.pressed ? "green" : "aquamarine"
        MouseArea {
            id: mouse1; anchors.fill: parent;
            onPressed: mouse.accepted = false
        }
    }
    Rectangle {
        x: 50; y: 500;
        width: 300; height: 300;
        color: mouse2.pressed ? "blue" : "lightsteelblue"
        MouseArea {
            id: mouse2; anchors.fill: parent
            preventStealing: true
        }
    }
}
