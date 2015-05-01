import QtQuick 2.0

Rectangle {
    width: 200
    height: 200
    color: mouse.containsMouse ? "blue" : "lightsteelblue"

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
    }
}
