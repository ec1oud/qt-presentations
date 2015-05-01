import QtQuick 2.0

Rectangle {
    width: 200
    height: 200
    color: mouse.pressed ? "blue" : "lightsteelblue"

    MouseArea {
        id: mouse
        anchors.fill: parent
    }
}
