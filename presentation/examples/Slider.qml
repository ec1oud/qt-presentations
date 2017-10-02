import QtQuick 2.6
import QtGraphicalEffects 1.0

Rectangle {
    id: slider
    width: 150; height: 600; color: "#ddd"
    property int value: 50
    property int minimumValue: 0
    property int maximumValue: 99
    property alias label: label.text

    Image {
        id: knob; source: "../resources/fader-knob.png"
        x: slot.x - width / 2 + slot.width / 2; z: 2
        transformOrigin: Item.Center
        MouseArea {
            id: dragArea
            anchors.fill: parent
            anchors.margins: -20
            drag.target: parent
            drag.axis: Drag.YAxis
            drag.minimumY: slot.y
            drag.maximumY: slot.height + slot.y - parent.height
            // multiPointTouchEnabled: true // Qt 5.6 - planned
        }
        property real multiplier: slider.maximumValue / (dragArea.drag.maximumY - dragArea.drag.minimumY)
        onYChanged: slider.value = slider.maximumValue - (y - dragArea.drag.minimumY) * multiplier
        Component.onCompleted: y = dragArea.drag.maximumY - slider.value / multiplier
    }

    RectangularGlow {
        anchors.fill: knob; z: 1; visible: dragArea.pressed
        glowRadius: 10; color: "cyan"; opacity: 0.7
        cornerRadius: glowRadius
    }

    Rectangle {
        id: slot
        anchors {
            top: parent.top; bottom: parent.bottom
            margins: 10; topMargin: 40; bottomMargin: 46
            horizontalCenter: parent.horizontalCenter
        }
        width: 10; radius: width / 2
        color: "black"; antialiasing: true
    }

    Text {
        font.family: "LCD"; font.pixelSize: 36; color: "red"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: slider.value
    }

    Text {
        id: label
        font.family: "LCD"
        font.pixelSize: 24
        color: "red"
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Balloons"
    }
}
