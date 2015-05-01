import QtQuick 2.1
import QtQuick.Layouts 1.0

Rectangle {
    id: rect
    property string title
    property bool spacePressed: false

    color: spacePressed ? "blue" : (activeFocus ? "#0099FF" : "#99CCFF")
    border.color: "black"
    border.width: focus ? 3 : 1
    Keys.onPressed:{
        if (event.key === Qt.Key_Space) {
            spacePressed = true
            event.accepted = true
        }
    }
    Keys.onReleased:{
        if (event.key === Qt.Key_Space) {
            spacePressed = false
            event.accepted = true
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: parent.forceActiveFocus()
    }
    Text {
        x: 4; y: 4;
        text: rect.title + " focus: " + rect.focus + " activeFocus: " + rect.activeFocus
        font.pointSize: 14
    }
    Layout.fillWidth: true
    Layout.fillHeight: true
}
