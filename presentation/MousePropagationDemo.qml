import QtQuick 2.1

Rectangle {

    property bool acc: true

    width: 220
    border.color: "black"
    height: 220
    Rectangle {
        color: rm1.pressed ? "blue" : "lightsteelblue"
        x: 20; y: 20; width: 140; height: 140;
        MouseArea {
            id: rm1
            anchors.fill: parent
        }
        border.color: "black"
    }
    Rectangle {
        color: rm2.pressed ? "blue" : "lightsteelblue"
        x: 60; y: 60; width: 140; height: 140;
        MouseArea {
            id: rm2
            anchors.fill: parent
            onPressed: mouse.accepted = acc
        }
        border.color: "black"
    }
}
