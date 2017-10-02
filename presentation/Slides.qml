import Qt.labs.presentation 1.0
import QtQuick 2.5

import "examples"

Presentation {
    id: presentation
    anchors.fill: parent
    mouseNavigation: false
    fontFamily: "TitilliumWeb"
    fontScale: 0.7

    width: 1920
    height: 1080

    Image {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        fillMode: Image.PreserveAspectFit
        source: "resources/top-banner.png"
        visible: currentSlide === 0
        smooth: true
    }

    Slide {
        id: title
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Pointer Handlers in Qt Quick</H1>
Shawn Rutledge<br/>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.
</html>"
    }

    Slide {
        title: "About me"
        content: [
            "Qt user since ~2004",
            "The Qt Company - Oslo",
            "Pointing devices: touch, Wacom tablets",
            "Linux/X11 and macOS",
            "QtPDF",
            "Qt Quick Controls and Dialogs",
        ]
    }

    Slide {
        title: "Agenda"
        bulletSpacing: 0.6
        content: [
            "What's wrong with existing mouse & touch handling",
            "Goals",
            "Introduction to PointerHandlers",
            "Demos of several PointerHandlers",
//            "Event delivery",
            "Conceptual comparison",
            "Weak and strong grabbing",
            "Remaining work",
            "Q&A"
        ]
    }

//    Slide {
//        // TODO examples
//        title: "What's wrong with existing mouse & touch handling"
//        content: [
//        ]
//    }

    CustomCodeSlide {
        title: "Flickable and MouseArea: hover and grab"
        sourceFile: "examples/Flick.qml"
    }

    CustomCodeSlide {
        title: "Flickable: filter, grab, steal or prevent"
        sourceFile: "examples/Flickable2.qml"
    }

    ImageSlide {
        title: "Many parallel event delivery paths (and some missing)"
        source: "resources/event-delivery-before.png"
    }

    Slide {
        title: "Goals: what we need to fix"
        content: [
            "make it easy to handle mouse, touch and stylus agnostically or in device-specific ways",
            "common event delivery code for mouse and touch in QQuickWindow",
            "both QML and C++ APIs",
            "guarantee that events always have velocity",
        ]
    }

    Slide {
        title: "Forward-looking goals"
        content: [
            "proper support for Wacom tablets: draw paths in Qt Quick",
            "refine APIs so that they'll work for Qt 6",
            "plan on multiple seats/users and support for multiple mice etc. in Qt 6",
            "reduce the need for touch -> mouse synthesis"
        ]
    }

    Slide {
        title: "Idea: handler objects"
        content: [
            "the original idea: make mouse/touch more like the Keys attached prop",
            ' Keys.onLeftPressed: console.log("move left")'
//            ' so maybe color: Mouse.onLeftButtonPressed ? "red" : "blue" ?'
        ]
    }

    Slide {
        title: "Handler objects"
        content: [
            "but no more than one attached object of a given type per Item... so let's have 'child' objects",
            ' Rectangle { TapHandler { id: th } color: th.isPressed ? "red" : "blue" }',
            ' Rectangle { DragHandler { } }',
            ' Image { PinchHandler { } }'
        ]
    }

    Slide {
        title: "Features"
        content: [
            "easy stuff is easy",
            "plain QObject 'child' is lighter than Item or attached",
            "multiple small, lightweight, understandable handlers instead of monolithic MouseArea etc.",
            "default target, use its bounds"
        ]
    }

    Slide {
        title: "Features"
        content: [
            "preferred: declarative handlers for gestures (tap, drag, pinch etc.)",
            "but also: some for mouse only, some for touch only",
            "subclass Handlers in C++ for the less-mainstream cases",
            "it's completely different, so minimizes compatibility risks"
        ]
    }

    CustomCodeSlide {
        title: "DragHandler"
        sourceFile: "examples/joystick.qml"
    }

    CustomCodeSlide {
        title: "TapHandler"
        sourceFile: "examples/tapHandler.qml"
    }

    CustomCodeSlide {
        title: "TapHandler - multiple instances"
        sourceFile: "examples/multiTapHandler.qml"
    }

    CustomCodeSlide {
        title: "PinchHandler"
        sourceFile: "examples/pinchHandler.qml"
    }

    CustomCodeSlide {
        title: "PinchHandler on a map"
        sourceFile: "examples/map.qml"
    }

    // TODO photo surface

//    CustomCodeSlide {
//        title: "MouseHandler"
//        sourceFile: "examples/mouseHandler.qml"
//    }

//    Slide {
//        title: "Touch Event Delivery in Qt < 5.8"
//        textFormat: Text.StyledText
//        content: [
//            "each item under the touchpoint gets a touch event (and ignores by default)",
//            "if not accepted, the item gets a synthetic mouse event",
//            "continue with next item (in reverse paint order) if still not accepted",
//            "problem: duplicate logic for mouse and touch",
//            "grabbing and stealing across real touch events and synth-mouse events",
//            "tablet events? fuhgetaboutit"
//        ]
//        Image {
//            anchors.right: parent.right
//            anchors.verticalCenter: parent.verticalCenter
//            source: "resources/touch_mouse_event.png"
//        }
//    }

//    Slide {
//        title: "QQuickPointerEvent delivery in QtQuick"
//        textFormat: Text.StyledText
//        bulletSpacing: 0.6
//        content: [
//            "wrapper for the original event, providing uniform API",
//            "each QQuickItem->private->extra has a vector of QQuickPointerHandler objects",
//            "<i>single</i> delivery code path - but still deliver the original event to original Item virtuals"
//        ]
//        Image {
//            anchors {
//                horizontalCenter: parent.horizontalCenter
//                bottom: parent.bottom
//                bottomMargin: -30
//            }
//            fillMode: Image.PreserveAspectFit
//            source: "resources/pointerevent-delivery.png"
//        }
//    }

    Slide {
        title: "Conceptual Changes: Handlers vs. Areas"
        textFormat: Text.StyledText
//        bulletSpacing: 0.6
        content: [
            "either an Handler or an Item can be the grabber",
            "if number of touchpoints changes: ignore the grab,<br/>start over with event delivery",
//            "don't need parent-filtering: Handler gives up the grab when<br/>constraints aren't satisfied: start over with delivery",
//            "define a vector of Items in visitation-order before we start delivery",
//            "prefix the old-style child-filtering Items to that vector",
            "Handler gives up the grab when constraints aren't satisfied",
            "mouse event -> QQuickPointerEvent with one point inside",
            "PointerHandler receives the complete event",
            "PointerHandler can explicitly accept, grab/ungrab"
        ]
        /*
        Image {
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: -30
            }
            height: parent.height * 0.7
            fillMode: Image.PreserveAspectFit
            source: "resources/whiteboard-cutout.jpg"
            z: -1
        }
        */
    }

    Slide {
        title: "Wanting vs. grabbing"
        textFormat: Text.StyledText
//        bulletSpacing: 0.6
        content: [
            "so far, an Item must grab a press to be able to get an update<br/>this leads us to monolithic Areas and childMouseEventFilter and grab-stealing",
            "PointerHandlers: we want to mostly let events propagate; exclusive grab should be less common",
            "virtual bool wantsEventPoint(QQuickEventPoint *)",
            "if wantsPointerEvent() returns true, virtual handlePointerEventImpl() will be called",
            "signals press(eventPoint), update(eventPoint), release(eventPoint) might allow setting accepted to false<br/>means wantsEventPoint() will return false, ungrab if grabbed",
        ]
    }

    ImageSlide {
        title: "Existing QEvent hierarchy"
        source: "resources/event-hierarchy-before.png"
    }

    ImageSlide {
        title: "WIP event hierarchy for PointerHandlers Tech Preview"
        source: "resources/event-hierarchy-qt5.8.png"
    }

    ImageSlide {
        title: "Handler hierarchy so far"
        source: "resources/pointer-handlers-classes.png"
    }

//    TextSlide {
//        title: "QQuickPointerEvent"
//        sourceFile: "src/quick/items/qquickevents_p_p.h"
//    }

//    Slide {
//        title: "Velocity"
//        content: [
//            "every event should have valid velocity values",
//            "we plan to synthesize it when creating QQuickPointerEvents",
//            "future FlickHandler won't need to calculate it like Flickable does"
//        ]
//    }

//    TextSlide {
//        title: "Fling Animation using VelocityCalculator"
//        sourceFile: "fling-animation-with-velocity-calculator.qml"
//    }

//    CustomCodeSlide {
//        title: "Pressing Multiple Buttons"
//        sourceFile: "examples/MultiButton.qml"
//        live: false
////        sourceFile: "examples/multibuttons.qml"
//        Loader {
//            anchors.right: parent.right
//            anchors.rightMargin: -40
//            source: "examples/multibuttons.qml"
//        }
//    }

    Slide {
        title: "Stuff left to work on"
        textFormat: Text.StyledText
        bulletSpacing: 0.6
        content: [
            "FlickHandler",
            "scroll & wheel events",
            "native gestures",
            "validate the weak (non-exclusive) grab concept",
            "monitor without grabbing",
            "grab pre-emptively at any time",
            "get ready for public C++ API (create private-impl classes etc.)",
            "how to manipulate inner Handlers? attached properties?",
            "research Reactive Programming more: any good ideas? are we doing it all wrong then?"
            // TODO where did Reactive originate?  most popular frameworks now?
        ]
    }

    Slide {
        id: lastSlide
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Pointer Handlers in Qt Quick</H1>
Shawn Rutledge<br/>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.<br/>
This presentation: <tt>https://github.com/ec1oud/qt-presentations/tree/pointerhandlers</tt>
</html>"
    }

    SlideCounter { id: slideCounter }

    Clock {
        id: clock
        anchors.top: undefined
        anchors.bottom: undefined
        anchors.left: undefined
        anchors.verticalCenter: rule.verticalCenter
        anchors.right: slideCounter.right
        anchors.rightMargin: 0
        width: slideCounter.width
        horizontalAlignment: Text.AlignRight
    }

    property bool bottomStuffVisible: currentSlide < 4

    Rectangle {
        id: rule
        visible: bottomStuffVisible
        color: "#f3f3f4"; height: 5
        anchors.bottom: leftLogo.top
        anchors.left: parent.left; anchors.leftMargin: 65
        anchors.right: clock.left
        anchors.rightMargin: 12
        anchors.bottomMargin: 16
    }

    Image {
        id: leftLogo
        visible: bottomStuffVisible
        anchors {
            verticalCenter: slideCounter.verticalCenter
            left: rule.left
            rightMargin: 20
        }
        height: 78 * parent.height / 1080
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "resources/bottom-logo-left.png"
    }

    Image {
        id: rightLogo
        anchors {
            verticalCenter: slideCounter.verticalCenter
            right: slideCounter.left
            rightMargin: 20
        }
        width: 226; height: 34
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "resources/bottom-logo-right.png"
    }

}
