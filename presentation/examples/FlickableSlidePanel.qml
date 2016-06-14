import QtQuick 2.0
import QtGraphicalEffects 1.0

Flickable {
    id: root
    default property alias __content: rect.data

    onDraggingChanged: if (!dragging) {
       if (horizontalVelocity > 0) flick(-1000, 0)
       else flick(1000, 0)
    }
    flickableDirection: Flickable.HorizontalFlick
    rebound: Transition { NumberAnimation {
            properties: "x"
            duration: 300
            easing.type: Easing.OutBounce } }

    width: 100; height: 480
    contentWidth: width * 2; contentHeight: height

    RectangularGlow {
        x: width - 10; width: root.width; height: root.height
        glowRadius: 10; spread: 0.2; color: "cyan"
        cornerRadius: rect.radius + glowRadius

        Rectangle {
            id: rect
            anchors.fill: parent
            anchors.rightMargin: -200
            color: "black"
            radius: 10
            antialiasing: true

            MouseArea {
                width: parent.width / 4
                height: width
                y: 6
                x: y
                Rectangle {
                    anchors.fill: parent
                    color: parent.pressed ? "green" : "transparent"
                }
            }
        }
    }
}
