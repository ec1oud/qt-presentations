import QtQuick
import Qt.labs.animation

Rectangle {
    id: root
    objectName: "busybox"
    height: 256
    width: 256

    color: "#444"
    border.color: "cyan"
    border.width: 2
    antialiasing: true

    property alias topButtonPressed: upperButton.pressed
    property alias rawSliderValue: slider.value
    property real sliderValue: slider.value / 100

    component DragAnywhereSlider: Item {
        id: root
        property int value: 50
        property int maximumValue: 99
        width: 100
        height: 240

        DragHandler {
            id: dragHandler
            target: knob
            xAxis.enabled: false
            yAxis.minimum: slot.y
            yAxis.maximum: slot.height + slot.y - knob.height
        }

        WheelHandler {
            id: wheelHandler
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            invertible: false
            rotationScale: -0.5
            target: knob
            property: "y"
        }

        Rectangle {
            id: slot
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 10
            anchors.topMargin: 30
            anchors.bottomMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            width: 10
            color: "black"
            radius: width / 2
            smooth: true
        }

        Rectangle {
            id: knob
            objectName: "Slider Knob"
            width: parent.width - 2
            height: 30
            radius: 5
            color: "beige"
            border.width: 3
            border.color: hover.hovered ? "orange" : "black"
            property bool programmatic: false
            property real multiplier: root.maximumValue / (dragHandler.yAxis.maximum - dragHandler.yAxis.minimum)
            onYChanged: if (!programmatic) root.value = root.maximumValue - (knob.y - dragHandler.yAxis.minimum) * multiplier
            transformOrigin: Item.Center
            function setValue(value) { knob.y = dragHandler.yAxis.maximum - value / knob.multiplier }
            HoverHandler {
                id: hover
                objectName: "Slider"
            }
            BoundaryRule on y {
                id: ybr
                minimum: slot.y
                maximum: slot.height + slot.y - knob.height
            }
        }

        Component.onCompleted: {
            knob.programmatic = true
            knob.setValue(root.value)
            knob.programmatic = false
        }
    }


    component HoverTapButton: Rectangle {
        id: htbutton
        property string name: ""
        objectName: name + " handlers button"
        property  alias pressed: utap.pressed
        property point lastPressPos: Qt.point(-1, -1)
        property point lastReleasePos: Qt.point(-1, -1)
        property int clickedCount: 0
        onPressedChanged: {
            if (pressed)
                lastPressPos = utap.point.position;
            else
                lastReleasePos = utap.point.position;
        }
        width: 120; height: 40
        color: utap.pressed ? "tomato" : "beige"
        radius: 5
        border.width: 3
        border.color: uhover.hovered ? "orange" : "black"
        antialiasing: true
        HoverHandler {
            id: uhover
            objectName: htbutton.name + " HoverHandler"
            cursorShape: Qt.OpenHandCursor
        }
        TapHandler {
            id: utap
            objectName: htbutton.name + " TapHandler"
            onTapped: ++clickedCount
        }
        Text {
            anchors.centerIn: parent
            text: "hover & tap"
        }
    }

    HoverHandler {
        id: feedback
        objectName: root.objectName + " hover position feedback"
        target: Rectangle {
            color: "orange"
            parent: root
            x: feedback.point.position.x - width / 2
            y: feedback.point.position.y - height / 2
            width: 10; height: width; radius: width
        }
    }

    Text {
        color: "orange"
        text: "hover " + feedback.point.position.x.toFixed(1) + ", " + feedback.point.position.y.toFixed(1)
        anchors.bottom: parent.bottom
        anchors.margins: 3
        x: 3
    }

    Row {
        x: 10; y: 10; z: 1
        spacing: 10
        Column {
            spacing: 10
            HoverTapButton {
                id: upperButton
                name: root.objectName + " upper"
            }
            HoverTapButton {
                name: root.objectName + " lower"
            }
            Rectangle {
                objectName: root.objectName + " mousearea button"
                width: 120; height: 40
                color: ma.pressed ? "tomato" : "beige"
                radius: 5
                border.width: 3
                border.color: ma.containsMouse ? "orange" : "black"
                antialiasing: true
                MouseArea {
                    id: ma
                    objectName: root.objectName + " button mousearea"
                    anchors.fill: parent
                    hoverEnabled: true
                    property point lastPressPos: Qt.point(-1, -1)
                    property point lastReleasePos: Qt.point(-1, -1)
                    property int clickedCount: 0
                    onPressed: (mouse) => { lastPressPos = Qt.point(mouse.x, mouse.y) }
                    onReleased: (mouse) => { lastReleasePos = Qt.point(mouse.x, mouse.y) }
                    onClicked: ++clickedCount
                }
                Text {
                    anchors.centerIn: parent
                    text: "hover & click"
                }
            }
            TextInput {
                text: "Edible Text"
                color: "cyan"
                focus: true
            }
        }

        DragAnywhereSlider { id: slider }
    }
}
