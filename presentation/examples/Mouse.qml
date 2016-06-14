import QtQuick 2.0

Rectangle {
    width: 200
    height: 200
    color: mouse.pressed ? "blue" : "lightsteelblue"

    MouseArea {
        id: mouse
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onClicked: note.text = "clicked " + mouse.button
        onDoubleClicked: note.text = "double-clicked"
        onPressAndHold: note.text = "long press"
        onWheel: note.text = "wheel\ndelta " + wheel.angleDelta.y + "°"
    }

    Text {
        id: note
        anchors.centerIn: parent
        font.pointSize: 18
    }
}
