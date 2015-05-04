import QtQuick 2.0

Flickable {
    width: 400; height: parent.height; contentHeight: col.implicitHeight * 2
    Column {
        id: col; spacing: 50
        Rectangle {
            width: 300; height: 200
            color: mouse1.pressed ? "yellow" : "goldenrod"
            MouseArea { id: mouse1; anchors.fill: parent }
        }
        Rectangle {
            width: 300; height: 200
            color: mouse2.pressed ? "green" : "aquamarine"
            MouseArea {
                id: mouse2; anchors.fill: parent;
                onPressed: mouse.accepted = false
            }
        }
        Rectangle {
            width: 300; height: 200
            color: mouse3.pressed ? "blue" : "lightsteelblue"
            MouseArea {
                id: mouse3; anchors.fill: parent
                preventStealing: true
            }
        }
    }
}
