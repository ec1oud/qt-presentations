import QtQuick 2.1

Rectangle {
    Rectangle {
        anchors.centerIn: parent
        width: 200
        height: 200
        color: mouse.containsMouse ? "blue" : "green"

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
        }
    }
}
