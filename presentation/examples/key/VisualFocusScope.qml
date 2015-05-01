import QtQuick 2.1
import QtQuick.Layouts 1.0

FocusScope {
    id: scope
    property string title

    Layout.fillWidth: true
    Layout.fillHeight: true

    Rectangle {
        id: rect

        anchors.fill: parent

        color: scope.activeFocus ? "#888" : "#CCCCCC"
        border.color: "black"
        border.width: scope.focus ? 3 : 1

        Text {
            x: 4; y: 4;
            text: "FocusScope " + scope.title + " focus: " + scope.focus + " activeFocus: " + scope.activeFocus
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: scope.forceActiveFocus()
    }
}