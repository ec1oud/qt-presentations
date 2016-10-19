import QtQuick 2.0

Flickable {
    width: 400
    height: 800
    contentHeight: 1200
    Rectangle {
        anchors.fill: parent
        color: outerMA.containsMouse ? "wheat" : "beige"
        border.color: "black"
        MouseArea {
            id: outerMA
            anchors.fill: parent
            hoverEnabled: true
        }
    }

    Rectangle {
        x: 100; y: 100; width: 300; height: 300;
        color: mouse.pressed ? "steelblue" : "lightsteelblue"
        border.width: 2; border.color: mouse.containsMouse ? "black" : "transparent"
        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
        }
    }
    Rectangle {
        x: 200; y: 200; width: 300; height: 300;
        color: mouse2.pressed ? "mediumturquoise" : "aquamarine"
        border.width: 2; border.color: mouse2.containsMouse ? "black" : "transparent"
        MouseArea {
            id: mouse2
            anchors.fill: parent
            hoverEnabled: true
        }
    }
}
