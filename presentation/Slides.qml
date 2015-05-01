import QtQuick 2.0
import Qt.labs.presentation 1.0

import "examples/mouse"

Presentation {
    id: presentation
    anchors.fill: parent

//    width: 1280
//    height: 720

    SlideCounter {}
    Clock{}

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
            "Touch",
            "X11 and OS X",
            "Qt Quick Controls and Dialogs",
        ]
    }

    Slide {
        title: "Contents"
        content: [
            "",
            "Mouse",
            "Touch"
        ]
    }

    Slide {
        centeredText: "Mouse"
        fontScale: 2
    }

    Slide {
        title: "Mouse"
        content: [
            "MouseArea",
            "Flickable",
            "custom component inheriting QQuickItem",
        ]
    }
    CodeSlide {
        id: mouseAreaSlide
        title: "MouseArea"
        sourceFile: "examples/mouse/Mouse.qml"
    }
    Mouse { visible: mouseAreaSlide.visible
        anchors.right: presentation.right; anchors.top: presentation.top; border.color: "black";
        width: 300; height: 300
    }

//    Slide {
//        title: "MouseArea"
//        content: [
//            "non-visual QQuickItem",
//            "geometry",
//            "handlers for mouse events",
//            "stacking possible",
//            'hover',
//            "grab",
//            "steal",
//        ]
//    }
    CodeSlide {
        id: mouseHoverSlide
        title: "Hover"
        sourceFile: "examples/mouse/MouseHover.qml"
    }
    MouseHover {
        visible: mouseHoverSlide.visible
               anchors.right: presentation.right; anchors.top: presentation.top; border.color: "black";
               width: 300; height: 300
    }
//    Slide {
//        title: "MouseArea - geometry"
//        content: [
//            "anchors.fill: parent",
//            "can be made custom shaped by not accepting events",
//            "inverse paint order when stacked",
//        ]
//    }
    CodeSlideLong {
        id: roundMouseAreaSlide
        title: "Round MouseArea"
        sourceFile: "examples/mouse/MouseCustomShape.qml"
    }
    MouseCustomShape {
        visible: roundMouseAreaSlide.visible
               anchors.right: presentation.right; anchors.top: presentation.top; border.color: "black";
               width: 300; height: 300
    }

    Slide {
        title: "MouseArea"
        content: [
            "clicked, pressed, mouseX, mouseY, released",
            "doubleClicked, wheel",
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
    CodeSlideLong {
        title: "Two MouseAreas"
        sourceFile: "examples/mouse/MouseStack.qml"
    }
    CodeSlideLong {
        title: "Events, Pressed and Hover"
        sourceFile: "examples/mouse/MouseStack2.qml"
    }

    CodeSlideLong {
        title: "Flickable"
        sourceFile: "examples/mouse/Flickable.qml"
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
    CodeSlideLong {
        title: "Prevent Stealing"
        sourceFile: "examples/mouse/Flickable2.qml"
    }

    Slide {
        centeredText: "Touch"
        fontScale: 2
    }

    Slide {
        title: "Touch Items"
        content: [
            "MouseArea",
            "Flickable",
            "PinchArea",
            "MultiPointTouchArea",
            "Custom C++",
        ]
    }
//    Slide {
//        title: "Touch"
//        content: [
//            "synth mouse",
//            "propagation",
//            "stealing",
//        ]
//    }

    CodeSlide {
        id: flickableSlide
        title: "Flickable"
        sourceFile: "examples/mouse/Flickable.qml"
    }
    Flick {
        visible: flickableSlide.visible
               anchors.right: presentation.right; anchors.top: presentation.top; border.color: "black";
               width: 300; height: 300
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
