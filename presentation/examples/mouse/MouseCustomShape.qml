import QtQuick 2.1

Rectangle {
    width: 600; height: 600
    color: parentMouse.pressed ? "green" : "yellow"
    MouseArea { id: parentMouse; anchors.fill: parent }

    Rectangle {
        id: rect
        anchors.centerIn: parent
        width: 400; height: 400; radius: 200
        color: mouse.pressed ? "green" : "blue"

        MouseArea {
            id: mouse
            anchors.fill: parent
            property int radius: parent.width/2
            onPressed: {
                var distance = Math.sqrt(Math.pow(mouse.x - radius, 2)
                                       + Math.pow(mouse.y - radius, 2))
                if (distance > radius)
                    mouse.accepted = false
            }
        }
    }
}
