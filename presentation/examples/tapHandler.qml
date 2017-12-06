import QtQuick 2.10
import Qt.labs.handlers 1.0
import QtQuick.Controls 2.0
import "resources"

Item {
    Rectangle {
        color: handler.pressed ? "lightsteelblue" : "#22222222"

        TapHandler {
            id: handler
            acceptedButtons: allowedButtons.state
            gesturePolicy: cancellationPolicy.state
            longPressThreshold: 0.5 // seconds
            onLongPressed: tapCounter.flash("long\npress")
            onTapped: tapCounter.flash(tapCount)
            onCanceled: borderAnimation.blink("red")
        }

        Circle {
            id: expandingCircle
            radius: handler.timeHeld * 100
            visible: radius > 0 && handler.pressed && handler.timeHeld < handler.longPressThreshold
            x: handler.point.pressPosition.x - radius
            y: handler.point.pressPosition.y - radius
        }

        Text {
            id: tapCounter
            anchors.centerIn: parent
            font { pixelSize: 72; weight: Font.Black }
            function flash(value) { text = value; flashAnimation.start(); borderAnimation.blink("blue"); }
            SequentialAnimation {
                id: flashAnimation
                PropertyAction { target: tapCounter; property: "visible"; value: true }
                PropertyAction { target: tapCounter; property: "opacity"; value: 1.0 }
                PropertyAction { target: tapCounter; property: "scale"; value: 1.0 }
                ParallelAnimation {
                    NumberAnimation {
                        target: tapCounter
                        property: "opacity"
                        to: 0
                        duration: 500
                    }
                    NumberAnimation {
                        target: tapCounter
                        property: "scale"
                        to: 1.5
                        duration: 500
                    }
                }
            }
        }

        SequentialAnimation {
            id: borderAnimation
            property color blinkColor: "blue"
            loops: 3
            function blink(color) {
                blinkColor = color;
                restart();
            }
            ScriptAction { script: rect.border.color = borderAnimation.blinkColor }
            PauseAnimation { duration: 100 }
            ScriptAction { script: rect.border.color = "transparent" }
            PauseAnimation { duration: 100 }
        }


        id: rect
        anchors.fill: parent; anchors.margins: 40; anchors.bottomMargin: parent.height / 2
        border.width: 3; border.color: "transparent"
    }

    Column {
        anchors.right: parent.right
        anchors.top: rect.bottom
        anchors.topMargin: spacing
        anchors.rightMargin: 20
        spacing: 6
        Column {
            id: allowedButtons
            property int state: (leftAllowedCB.checked ? Qt.LeftButton : Qt.NoButton) |
                                (middleAllowedCB.checked ? Qt.MiddleButton : Qt.NoButton) |
                                (rightAllowedCB.checked ? Qt.RightButton : Qt.NoButton)
            spacing: 6
            Label { text: "acceptedButtons:" }
            CheckBox {
                id: leftAllowedCB
                checked: true
                text: "left"
            }
            CheckBox {
                id: middleAllowedCB
                text: "middle"
            }
            CheckBox {
                id: rightAllowedCB
                text: "right"
            }
        }

        Column {
            id: cancellationPolicy
            property int state: (policyDragThresholdRB.checked ? TapHandler.DragThreshold :
                                 policyWithinBoundsRB.checked ? TapHandler.WithinBounds :
                                 TapHandler.ReleaseWithinBounds)

            spacing: 6
            Label { text: "gesturePolicy:" }
            RadioButton {
                id: policyDragThresholdRB
                text: "drag threshold"
                onCheckedChanged: if (checked) {
                    policyWithinBoundsRB.checked = false;
                    policyReleaseWithinBoundsRB.checked = false;
                }
            }
            RadioButton {
                id: policyWithinBoundsRB
                text: "within bounds"
                onCheckedChanged: if (checked) {
                    policyDragThresholdRB.checked = false;
                    policyReleaseWithinBoundsRB.checked = false;
                }
            }
            RadioButton {
                id: policyReleaseWithinBoundsRB
                checked: true
                text: "release within bounds"
                onCheckedChanged: if (checked) {
                    policyDragThresholdRB.checked = false;
                    policyWithinBoundsRB.checked = false;
                }
            }
        }
    }

    width: 480
    height: 640
}
