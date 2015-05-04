import QtQuick 2.0
import Qt.labs.presentation 1.0

import "examples"

Presentation {
    id: presentation
    anchors.fill: parent
    mouseNavigation: false

//    width: 1280
//    height: 720

    SlideCounter {}
    Clock {}

    Image {
        anchors.fill: parent
        source: "images/template.png"
        visible: title.visible
    }

    Slide {
        id: title
        titleColor: "white"
        title: "Input and Qt Quick"
        centeredText: "
Touch-oriented application development in Qt Quick

Open Source Developers Conference 2015

Shawn Rutledge
shawn.rutledge@theqtcompany.com"
    }

    Slide {
        title: "About me"
        content: [
            "Qt user since ~2004",
            "The Qt Company - Oslo",
            "Pointing devices: touch, Wacom tablets",
            "Linux/X11 and OS X",
            "Qt Quick Controls and Dialogs",
        ]
    }

    Slide {
        title: "Contents"
        content: [
            "Demo: Taborca",
            "MouseArea",
            "Flickable",
            "PinchArea",
            "MultiPointTouchArea"
        ]
    }

    CodeSlideInteractive {
        title: "MouseArea"
        sourceFile: "examples/Mouse.qml"
    }

    Slide {
        title: "MouseArea"
        content: [
            "non-visual QQuickItem",
            "geometry",
            "handlers for mouse events",
            "stacking possible",
            'hover',
            "grab",
            "steal",
        ]
    }

    CodeSlideInteractive {
        title: "Hover"
        sourceFile: "examples/MouseHover.qml"
    }

    Slide {
        title: "MouseArea - geometry"
        content: [
            "anchors.fill: parent",
            "can be made custom shaped by not accepting events",
            "inverse paint order when stacked",
        ]
    }

    CodeSlideInteractive {
        title: "Round MouseArea"
        sourceFile: "examples/MouseCustomShape.qml"
    }

    Slide {
        title: "MouseArea"
        content: [
            "clicked, pressed, mouseX, mouseY, released",
            "doubleClicked, wheel",
            "drag.target",
            "canceled",
            "QQuickMouseEvent (in QML: mouse)",
            "events by default accepted",
        ]
    }

    Slide {
        title: "MouseArea"
        Row {
            spacing: 50
            Image {
                source: "images/mouse_event.png"
            }
            MousePropagationDemo {
                acc: true
                Text {
                    anchors.top: parent.bottom
                    text: "Event accepted"
                    font.pixelSize: 22
                }
            }
            MousePropagationDemo {
                acc: false
                Text {
                    anchors.top: parent.bottom
                    text: "Event not accepted\nby top\nMouseArea"
                    font.pixelSize: 22
                }
            }
        }
    }

//    CodeSlideInteractive {
//        title: "Two MouseAreas"
//        sourceFile: "examples/MouseStack.qml"
//    }

    CodeSlideInteractive {
        title: "Events, Pressed and Hover"
        sourceFile: "examples/MouseStack2.qml"
    }

    CodeSlideInteractive {
        title: "Dragging: Slider"
        sourceFile: "examples/slider.qml"
    }

    CodeSlideInteractive {
        title: "Slide panel with MouseArea"
        sourceFile: "examples/DraggableSlidePanel.qml"
    }

    CodeSlideInteractive {
        title: "Flickable"
        sourceFile: "examples/Flick.qml"
    }

    Slide {
        title: "Flickable"
        content: [
            "mouse grabber",
            "filtersChildMouseEvents",
            "stealing",
            "prevent grab",
        ]
    }

    CodeSlideInteractive {
        title: "Prevent Stealing"
        sourceFile: "examples/Flickable2.qml"
    }

    CodeSlideInteractive {
        title: "Slide panel with Flickable"
        sourceFile: "examples/FlickableSlidePanel.qml"
    }

    Slide {
        title: "PinchArea"
        content: [
            "two finger gestures",
            "rotate",
            "scale",
            "drag",
        ]
    }

    Slide {
        title: "MultiPointTouchArea"
        content: [
            "choice of # points",
            "low level events",
        ]
    }

    CodeSlideInteractive {
        title: "MultiPointTouchArea"
        sourceFile: "examples/multiparticles.qml"
    }

    Slide {
        title: "Touch and Mouse Event Delivery"
        content: [
            "each item gets a touch event offered",
            "if not accepted, a mouse event",
            "continue with next item if not accepted"
        ]
        Image {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: "images/touch_mouse_event.png"
        }
    }

    Slide {
        title: "Questions?"
        centeredText: "Shawn Rutledge\nshawn.rutledge@theqtcompany.com\n\necloud on #qt-labs (freenode irc)"
    }
}
