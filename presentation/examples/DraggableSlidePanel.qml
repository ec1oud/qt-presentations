import QtQuick 2.1
import QtGraphicalEffects 1.0

Item {
    id: root
    property real xOpen: xClosed - 150
    property real xClosed: 200
    x: xClosed; y: 10; width: 300; height: 480

    MouseArea {
        id: ma
        anchors.fill: parent
        property real lastWinX: 0
        property real lastMouseX: 0
        onPressed: {
            state = ""
            lastWinX = root.x
            lastMouseX = mouseX
        }
        onMouseXChanged: root.x = Math.max(xOpen, root.x + (mouseX - lastMouseX))
        onReleased: {
            if (root.x - lastWinX > 20) state = "stateClosed"
            else state = "stateOpen"
        }
        state: "stateClosed"; Component.onCompleted: state = "stateOpen"
        states: [
            State { name: "stateOpen" },
            State { name: "stateClosed" }
        ]
        transitions: [
            Transition {
                to: "stateClosed"
                NumberAnimation {
                    target: root
                    properties: "x"
                    to: root.xClosed
                    duration: 300
                    easing {type: Easing.OutBounce; overshoot: 5}
                }
            },
            Transition {
                to: "stateOpen"
                NumberAnimation {
                    target: root
                    properties: "x"
                    to: root.xOpen
                    duration: 300
                    easing {type: Easing.OutBounce; overshoot: 5}
                }
            }
        ]
    }

    RectangularGlow {
        id: effect
        anchors.fill: rect
        glowRadius: 10
        spread: 0.2
        color: "cyan"
        cornerRadius: rect.radius + glowRadius
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        anchors.leftMargin: 100
        color: "black"
        radius: 10
        antialiasing: true
    }
}
