import QtQuick 2.5
import Qt.labs.presentation 1.0

import "examples"

Presentation {
    id: presentation
    anchors.fill: parent
    mouseNavigation: false

    width: 1280
    height: 720

    SlideCounter {}
    Clock { fontFamily: "WindsorDemi" }

    Slide {
        id: title
        titleColor: "white"
        centeredText: "
Pointer Handlers in Qt Quick

Contributors' Summit 2016

Shawn Rutledge
shawn.rutledge@qt.io
ecloud on #qt-labs, #qt-quick etc."
    }

    Slide {
        title: "Goals"
        content: [
            "make it easy to handle mouse, touch and tablet agnostically or in device-specific ways",
            "both QML and C++ APIs",
            "guarantee that events always have velocity",
            "proper support for Wacom tablets: draw paths in Qt Quick",
            "refine APIs so that they'll work for Qt 6",
            "plan on multiple seats/users and support for multiple mice etc. in Qt 6",
            "remove the need for touch -> mouse synthesis"
        ]
    }

    Slide {
        title: "Idea: handler objects"
        content: [
            "the old core idea: make mouse/touch more like the Keys attached prop",
            "but you can't have more than one attached object of a given type per Item... so let's have child objects",
            "easy stuff is easy",
            "multiple small, understandable handlers instead of monolithic MouseArea etc.",
            "preferred: declarative handlers for gestures (tap, drag, pinch etc.)",
            "but also: some for mouse only, some for touch only",
            "subclass Handlers in C++ for the less-mainstream cases",
            "it's completely different, so minimizes compatibility risks"
        ]
    }

//    CustomCodeSlide {
//        title: "Plain PointerHandler"
//        qtSourceModule: "qtdeclarative"
//        sourceFile: "tests/manual/pointer/pointerHandler.qml"
//    }

    CustomCodeSlide {
        title: "DragHandler"
        qtSourceModule: "qtdeclarative"
        sourceFile: "tests/manual/pointer/joystick.qml"
    }

    CustomCodeSlide {
        title: "TapHandler"
        qtSourceModule: "qtdeclarative"
        sourceFile: "tests/manual/pointer/tapHandler.qml"
    }

//    CustomCodeSlide {
//        title: "MouseHandler"
//        sourceFile: "examples/mouseHandler.qml"
//    }

    Slide {
        title: "Touch Event Delivery in Qt <= 5.8"
        content: [
            "each item under the touchpoint gets a touch event (and ignores by default)",
            "if not accepted, the item gets a synthetic mouse event",
            "continue with next item (in reverse paint order) if still not accepted",
            "problem: need to duplicate a massive amount of logic to handle both mouse and touch",
            "grabbing and stealing across real touch events and synth-mouse events is problematic"
//            "tablet events? fuhgetaboutit"
        ]
        Image {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: "images/touch_mouse_event.png"
        }
    }

    ImageSlide {
        title: "Existing QEvent hierarchy"
        source: "images/event-hierarchy-before.png"
    }

    ImageSlide {
        title: "Many parallel event delivery paths (and some missing)"
        source: "images/event-delivery-before.png"
    }

    ImageSlide {
        title: "WIP hierarchy for QtQuick 2.8 Tech Preview"
        source: "images/event-hierarchy-qt5.8.png"
    }

    Slide {
        title: "Simulate it for now: QPointerEvent hierarchy in QtQuick"
        content: [
            "preferred event for Items is QPointerEvent (synthetic for now)",
            "multi-touch, tablet and mouse handling are agnostic until you need to distinguish them"
        ]
        Image {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            fillMode: Image.PreserveAspectFit
            source: "images/pointerevent-delivery.png"
        }
    }

    ImageSlide {
        title: "Handler hierarchy so far"
        source: "images/pointer-handlers-classes.png"
    }

//    TextSlide {
//        title: "QQuickPointerEvent"
//        sourceFile: "src/quick/items/qquickevents_p_p.h"
//    }

//    Slide {
//        title: "Velocity"
//        content: [
//            "every event should have valid velocity values",
//            "QTouchEvent already has velocity but it is almost never valid (but TUIO has it)",
//            "should we synthesize it in the platform plugins? or cross-platform?",
//            "but QMouseEvent and QTabletEvent do not have velocity...should we add it?",
//            "or, synthesize it when creating QQuickPointerEvents",
//            "or, use a generic VelocityCalculator in QML"
//        ]
//    }

//    TextSlide {
//        title: "Fling Animation using VelocityCalculator"
//        sourceFile: "fling-animation-with-velocity-calculator.qml"
//    }

//    CustomCodeSlide {
//        title: "Events, Pressed and Hover"
//        sourceFile: "examples/MouseStack2.qml"
//    }
}
