import QtQuick 2.0

Rectangle {
    width: 260; height: width
    color: parentMouse.pressed ? "green" : "yellow"
    MouseArea { id: parentMouse; anchors.fill: parent }

    Rectangle {
        id: rect
        anchors.centerIn: parent
        width: 300; height: width; radius: width / 2
        color: mouse.pressed ? "blue" : "lightsteelblue"

        MouseArea {
            id: mouse
            anchors.fill: parent
            property int radius: parent.width/2
            onPressed: {
                note.text = ""
                var distance = Math.sqrt(Math.pow(mouse.x - radius, 2)
                                       + Math.pow(mouse.y - radius, 2))
                if (distance > radius)
                    mouse.accepted = false
            }
            onCanceled: note.text = "canceled"
        }

        Text {
            id: note
            anchors.centerIn: parent
            font.pointSize: 24
        }
    }
}
