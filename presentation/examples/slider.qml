import QtQuick 2.0

Rectangle {
    id: slider
    width: 150; height: 600; color: "#222222"
    property int value: 50
    property int minimumValue: 0
    property int maximumValue: 99

    Image {
        source: "../images/fader-knob.png"
        x: slot.x - width / 2 + slot.width / 2; z: 1
        transformOrigin: Item.Center
        MouseArea {
            id: dragArea
            anchors.fill: parent
            anchors.margins: -10
            drag.target: parent
            drag.axis: Drag.YAxis
            drag.minimumY: slot.y
            drag.maximumY: slot.height + slot.y - height
        }
        property real multiplier: slider.maximumValue / (dragArea.drag.maximumY - dragArea.drag.minimumY)
        onYChanged: slider.value = slider.maximumValue - (y - dragArea.drag.minimumY) * multiplier
        Component.onCompleted: y = dragArea.drag.maximumY - slider.value / multiplier
    }

    Rectangle {
        id: slot
        anchors {
            top: parent.top; bottom: parent.bottom
            margins: 10; topMargin: 30; bottomMargin: 30
            horizontalCenter: parent.horizontalCenter
        }
        width: 10; radius: width / 2
        color: "black"; antialiasing: true
    }

    Text {
        font.family: "LCD"; font.pixelSize: 16; color: "red"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: slider.value
    }

    Text {
        id: label
        font.family: "LCD"
        font.pixelSize: 12
        color: "red"
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Balloons"
    }
}
