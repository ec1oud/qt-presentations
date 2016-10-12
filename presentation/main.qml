import QtQml 2.2
import QtQuick 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Window 2.1
import Qt.labs.presentation.helper 1.0

//ApplicationWindow {
Window {
    id: root
    width: 1280
    height: 720
    visible: true
    property alias currentSlide: slides.currentSlide
    Material.accent: Material.Green

    PointingFilter {
        id: pointingFilter
//        target: root
//        target: root.Window.window
    }
    Timer {
        interval: 2000; running: true
        onTriggered: pointingFilter.target = root
    }

    Repeater {
        model: pointingFilter.touchPoints === undefined ? 0 : pointingFilter.touchPoints.length
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

    Slides {
        id: slides
    }
}
