import QtQuick 2.0
import QtQuick.Window 2.1

Rectangle {
    width: 1280
    height: 720
    visible: true

    Repeater {
        model: pointingFilter.touchPoints.length
        AnimatedSprite {
            source: "images/fingersprite.png"
            width: frameWidth
            height: frameHeight
            frameWidth: 43
            frameHeight: 64
            frameCount: 3
            frameRate: 5
            x: pointingFilter.touchPoints[index].x - 19
            y: pointingFilter.touchPoints[index].y - 12
            z: 10000
        }
    }

    Slides {}
}
