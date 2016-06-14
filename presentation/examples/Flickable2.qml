import QtQuick 2.0

Rectangle {
    width: 312; height: 800; color: "transparent"; border.width: 2
    border.color: flick.dragging ? "green" : "#ddd"
    Flickable {
        id: flick
        anchors.fill: parent
        contentHeight: col.implicitHeight * 2
        Column {
            id: col; x: 6; y: 6; spacing: 50
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
}
