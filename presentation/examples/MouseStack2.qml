import QtQuick 2.0

Item {
    x: 50; y: 200;  width: 250; height: 250;
    Rectangle {
        width: 200; height: 200;
        color: mouse.pressed ? "red" : (mouse.containsMouse ? "blue" : "lightsteelblue")
        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
        }
    }
    Rectangle {
        x: 50; y: 50; width: 200; height: 200;
        color: mouse2.containsMouse ? "green" : "aquamarine"

        MouseArea {
            id: mouse2
            anchors.fill: parent
            hoverEnabled: true
            // Should it be possible to reject hover too?
            onPressed: mouse.accepted = false
        }
    }
}
