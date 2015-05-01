import QtQuick 2.1
import QtQuick.Controls 1.0
Rectangle {
    id: root
    width: 600; height: 600;
    MouseArea { anchors.fill: parent; onClicked: root.forceActiveFocus() }

    Column {
        anchors.fill: parent
        anchors.margins: 10; spacing: 10;
        Rectangle {
            id: rect
            color: "blue"
            width: 100; height: 100;
        }
        Rectangle {
            color: "#eee"; border.color: "#222";
            width: 100; height: 30;
            TextEdit { id: input; anchors.fill: parent; anchors.margins: 3 }
            MouseArea { anchors.fill: parent; onClicked: input.forceActiveFocus() }
        }
        Text { text: "Focus on background"; visible: root.focus }
    }
    Action { shortcut: "a"; onTriggered: rect.color = "red" }
    Action { shortcut: "b"; onTriggered: rect.color = "green" }
}