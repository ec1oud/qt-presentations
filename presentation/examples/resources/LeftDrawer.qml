import QtQuick 2.14
import QtGraphicalEffects 1.14

Rectangle {
    id: root
    width: 100
    height: 400
    property real stickout: 40
    property real xOpen: radius * -2
    property real xClosed: stickout - width - radius
    x: xClosed
    y: 10
    color: "#333"
    border.color: "cyan"
    border.width: 2
    radius: 10
    antialiasing: true

    function close() { closeAnimation.start() }
    function open() { openAnimation.start() }

    DragHandler {
        id: dragHandler
        yAxis.enabled: false
        xAxis.minimum: -10000
        margin: 20
        onActiveChanged: if (!active) {
            if (translation.x > 0)
                open()
            if (translation.x < 0)
                close()
        }
    }

    BoundaryRule on x {
        id: xbr
        minimum: xClosed
        maximum: xOpen
        minimumOvershoot: 40
        maximumOvershoot: root.radius
    }

    NumberAnimation on x {
        id: closeAnimation
        to: root.xClosed
        duration: 300
        easing {type: Easing.OutBounce; overshoot: 5}
    }

    NumberAnimation on x {
        id: openAnimation
        to: root.xOpen
        duration: 300
        easing {type: Easing.OutBounce; overshoot: 5}
    }
}
