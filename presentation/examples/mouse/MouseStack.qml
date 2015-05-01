import QtQuick 2.0

Rectangle {
    width: 600; height: 600;
    Rectangle {
        x: 100; y: 100; width: 300; height: 300;
        color: mouse.containsMouse ? "blue" : "lightsteelblue"
        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
        }
    }
    Rectangle {
        x: 200; y: 200; width: 300; height: 300;
        color: mouse2.containsMouse ? "green" : "aquamarine"

        MouseArea {
            id: mouse2
            anchors.fill: parent
            hoverEnabled: true

        }
    }
}
