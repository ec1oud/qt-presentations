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

    Slide {
        id: title
        titleColor: "white"
        centeredText: "
Pointer Handlers in Qt Quick

Project Fair April 2016

Shawn Rutledge
shawn.rutledge@qt.io
ecloud on #qt-labs"
    }

    Slide {
        title: "Long-term Goals"
        content: [
            "make it easy to handle mouse, touch and tablet agnostically",
            "guarantee that events always have velocity",
            "plan on unified QPointingEvent delivery in Qt 6: make sure current changes are compatible",
            "plan on multiple seats/users and support for multiple mice etc. in Qt 6",
            "proper support for Wacom tablets: draw paths in Qt Quick",
            "remove the need for touch -> mouse synthesis"
        ]
    }

    Slide {
        title: "Idea: handler objects"
        content: [
            "make mouse/touch more like the Keys attached prop",
            "(but attached properties are limiting, and inefficient)",
//            "no need to bind the geometry: proxy for the attachee Item",
            "easy stuff is easy",
            "lots of small, understandable handlers instead of monolithic MouseArea etc.",
            "preferred: handlers for gestures (tap, drag, pinch etc.)",
            "but also: some for mouse only, some for touch only, just in case",
            "it's completely different, so minimizes compatibility risks"
        ]
    }

    CodeSlideInteractive {
        title: "Plain PointerHandler"
        sourceFile: "/home/rutledge/dev/qt5/qtdeclarative/tests/manual/pointer/pointer.qml"
    }

    CodeSlideInteractive {
        title: "DragHandler"
        sourceFile: "/home/rutledge/dev/qt5/qtdeclarative/tests/manual/pointer/joystick.qml"
    }

    Slide {
        title: "Touch Event Delivery in Qt <= 5.7"
        content: [
            "each item under the touchpoint gets a touch event\n(and ignores by default)",
            "if not accepted, the item gets a synthetic mouse event",
            "continue with next item (in reverse paint order)\nif still not accepted"
//            "problem: need to duplicate a massive amount of logic to handle both mouse and touch",
//            "tablet events? fuhgetaboutit"
        ]
        Image {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: "/home/rutledge/dev/presentations/projectfair-201604-pointerhandlers/presentation/images/touch_mouse_event.png"
        }
    }

    ImageSlide {
        title: "Existing QEvent hierarchy"
        source: "/home/rutledge/dev/presentations/projectfair-201604-pointerhandlers/presentation/images/event-hierarchy-before.png"
    }

    ImageSlide {
        title: "Many parallel event delivery paths (and some missing)"
        source: "/home/rutledge/dev/presentations/projectfair-201604-pointerhandlers/presentation/images/event-delivery-before.png"
    }

    ImageSlide {
        title: "Possible hierarchy for Qt 6"
        source: "/home/rutledge/dev/presentations/projectfair-201604-pointerhandlers/presentation/images/event-hierarchy-qt6.png"
    }

    Slide {
        title: "Simulate it for now: QQuickPointerEvent"
        content: [
            "preferred event for Items is QQuickPointerEvent (synthetic for now)",
            "multi-touch, tablet and mouse handling are agnostic until you need to distinguish them"
        ]
        Image {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            fillMode: Image.PreserveAspectFit
            source: "/home/rutledge/dev/presentations/projectfair-201604-pointerhandlers/presentation/images/pointerevent-delivery.png"
        }
    }

    Slide {
        title: "Handler hierarchy so far"
        content: [
        ]
        Flickable {
            contentHeight: phClassHier.implicitHeight
            anchors.fill: parent
            Image {
                id: phClassHier
                fillMode: Image.PreserveAspectFit
                source: "/home/rutledge/dev/presentations/projectfair-201604-pointerhandlers/presentation/images/pointer-handlers-classes.png"
//                source: "/home/rutledge/dev/presentations/projectfair-201604-pointerhandlers/presentation/images/class_q_quick_pointer_handler__inherit__graph.png"
            }
        }
    }

    TextSlide {
        title: "QQuickPointerEvent"
        sourceFile: "/home/rutledge/dev/qt5/qtdeclarative/src/quick/items/qquickevents_p_p.h"
    }

    Slide {
        title: "Velocity"
        content: [
            "every event should have valid velocity values",
            "QTouchEvent already has velocity but it is almost never valid (but TUIO has it)",
            "should we synthesize it in the platform plugins? or cross-platform?",
            "but QMouseEvent and QTabletEvent do not have velocity...should we add it?",
            "or, synthesize it when creating QQuickPointerEvents",
            "or, use a generic VelocityCalculator in QML"
        ]
    }

    TextSlide {
        title: "Fling Animation using VelocityCalculator"
        sourceFile: "/home/rutledge/dev/presentations/projectfair-201604-pointerhandlers/presentation/fling-animation-with-velocity-calculator.qml"
    }

//    CodeSlideInteractive {
//        title: "Events, Pressed and Hover"
//        sourceFile: "examples/MouseStack2.qml"
//    }
}
