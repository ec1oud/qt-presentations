import QtQuick 2.10
import QtQuick.Window 2.3
import Qt.labs.handlers 1.0

Window {
    id: root
    width: 1280
    height: 720
    visible: true
    property alias currentSlide: slides.currentSlide

    Item {
        id: glassPane
        objectName: "glassPane"
        z: 10000
        anchors.fill: parent

        PointHandler {
            id: handler1
            objectName: "point 1"
            acceptedDevices: PointerDevice.TouchScreen | PointerDevice.TouchPad
            target: AnimatedSprite {
                objectName: "sprite 1"
                source: "resources/fingersprite.png"
                visible: handler1.active
                running: visible // workaround: running defaults to true, but we don't see it animating otherwise
                x: handler1.point.position.x
                y: handler1.point.position.y
                width: frameWidth
                height: frameHeight
                frameWidth: 43
                frameHeight: 64
                frameCount: 3
                frameRate: 5
                parent: glassPane
            }
        }

        PointHandler {
            id: handler2
            objectName: "point 2"
            acceptedDevices: PointerDevice.TouchScreen | PointerDevice.TouchPad
            target: AnimatedSprite {
                objectName: "sprite 2"
                source: "resources/fingersprite.png"
                visible: handler2.active
                running: visible // workaround: running defaults to true, but we don't see it animating otherwise
                x: handler2.point.position.x
                y: handler2.point.position.y
                width: frameWidth
                height: frameHeight
                frameWidth: 43
                frameHeight: 64
                frameCount: 3
                frameRate: 5
                parent: glassPane
            }
        }

        PointHandler {
            id: handler3
            objectName: "point 3"
            acceptedDevices: PointerDevice.TouchScreen | PointerDevice.TouchPad
            target: AnimatedSprite {
                objectName: "sprite 3"
                source: "resources/fingersprite.png"
                visible: handler3.active
                running: visible // workaround: running defaults to true, but we don't see it animating otherwise
                x: handler3.point.position.x
                y: handler3.point.position.y
                width: frameWidth
                height: frameHeight
                frameWidth: 43
                frameHeight: 64
                frameCount: 3
                frameRate: 5
                parent: glassPane
            }
        }
    }

    Slides {
        id: slides
    }

    Shortcut {
        sequence: "Ctrl+Shift+F"
        onActivated: root.visibility = (root.visibility != Window.FullScreen ? Window.FullScreen : Window.Windowed)
    }
}
