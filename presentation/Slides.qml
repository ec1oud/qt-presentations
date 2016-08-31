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
        }
        height: parent.height / 6
        fillMode: Image.PreserveAspectFit
        source: "images/top-banner.png"
        visible: currentSlide === 0
        antialiasing: true
        smooth: true
    }

    Slide {
        id: title
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Pointer Handlers in Qt Quick</H1>

<H2>Contributors' Summit 2016</H2>

Shawn Rutledge<br/>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.<br/>
<tt>wip/pointerhandler</tt> branch of qtdeclarative</html>"
    }

    Slide {
        title: "Goals"
        content: [
            "make it easy to handle mouse, touch and tablet agnostically or in device-specific ways",
            "common event delivery code for mouse and touch in QQuickWindow",
            "both QML and C++ APIs",
            "guarantee that events always have velocity",
            "proper support for Wacom tablets: draw paths in Qt Quick",
            "refine APIs so that they'll work for Qt 6",
            "plan on multiple seats/users and support for multiple mice etc. in Qt 6",
            "reduce the need for touch -> mouse synthesis"
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

    CustomCodeSlide {
        title: "TapHandler - multiple instances"
        sourceFile: "examples/multiTapHandler.qml"
    }

    CustomCodeSlide {
        title: "PinchHandler"
        qtSourceModule: "qtdeclarative"
        sourceFile: "tests/manual/pointer/pinchHandler.qml"
    }

//    CustomCodeSlide {
//        title: "MouseHandler"
//        sourceFile: "examples/mouseHandler.qml"
//    }

    Slide {
        title: "Touch Event Delivery in Qt < 5.8"
        textFormat: Text.StyledText
        content: [
            "each item under the touchpoint gets a touch event (and ignores by default)",
            "if not accepted, the item gets a synthetic mouse event",
            "continue with next item (in reverse paint order) if still not accepted",
            "problem: need to duplicate a massive amount of logic<br/>to handle both mouse and touch",
            "grabbing and stealing across real touch events and synth-mouse events<br/>is problematic",
            "tablet events? fuhgetaboutit"
        ]
        Image {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: "images/touch_mouse_event.png"
        }
    }

    Slide {
        title: "QQuickPointerEvent delivery in QtQuick"
        textFormat: Text.StyledText
        bulletSpacing: 0.6
        content: [
            "wrapper for the original event, providing uniform API",
            "each QQuickItem->private->extra has a vector of QQuickPointerHandler objects",
            "<i>single</i> delivery code path - but still deliver the original event to original Item virtuals"
        ]
        Image {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: -30
            }
            fillMode: Image.PreserveAspectFit
            source: "images/pointerevent-delivery.png"
        }
    }

    Slide {
        title: "Conceptual Changes: Handlers vs. Areas"
        textFormat: Text.StyledText
        bulletSpacing: 0.6
        content: [
            "either an Handler or an Item can be the grabber",
            "if number of touchpoints changes: ignore the grab,<br/>start over with event delivery",
            "don't need parent-filtering: Handler gives up the grab when<br/>constraints aren't satisfied: start over with delivery",
            "define a vector of Items in visitation-order before we start delivery",
            "prefix the old-style child-filtering Items to that vector",
            "deliver mouse as a QQuickPointerEvent with one point inside",
            "PointerHandler receives the complete event (all points, not just those inside)",
            "PointerHandler must explicitly accept the event... or maybe must explicitly grab/ungrab"
        ]
        Image {
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: -30
            }
            height: parent.height * 0.7
            fillMode: Image.PreserveAspectFit
            source: "images/whiteboard-cutout.jpg"
            z: -1
        }
    }

    Slide {
        title: "Wanting vs. grabbing"
        textFormat: Text.StyledText
        bulletSpacing: 0.6
        content: [
            "so far, an Item must grab a press to be able to get an update<br/>this leads us to monolithic Areas and childMouseEventFilter and grab-stealing",
            "PointerHandlers: we want to mostly let events propagate; exclusive grab should be less common",
            "virtual bool wantsPointerEvent(QQuickPointerEvent *) and wantsEventPoint(QQuickEventPoint *) don't imply grabbing<br/>(but then, it won't get updates if something else does grab)",
            "signals press(eventPoint), update(eventPoint), release(eventPoint) allow setting accepted to false<br/>means wantsEventPoint() will return false, ungrab if grabbed",
            "if wantsPointerEvent() returns true, handlePointerEventImpl() will be called"
        ]
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
        title: "WIP event hierarchy for PointerHandlers Tech Preview"
        source: "images/event-hierarchy-qt5.8.png"
    }

    ImageSlide {
        title: "Handler hierarchy so far"
        source: "images/pointer-handlers-classes.png"
    }

//    TextSlide {
//        title: "QQuickPointerEvent"
//        sourceFile: "src/quick/items/qquickevents_p_p.h"
//    }

    Slide {
        title: "Velocity"
        content: [
            "every event should have valid velocity values",
            "QTouchEvent already has velocity but it is almost never valid (but TUIO has it)",
            "should we synthesize it in the platform plugins? or cross-platform?",
            "but QMouseEvent and QTabletEvent do not have velocity...should we add it?",
            "probably, synthesize it when creating QQuickPointerEvents"
//            "or, use a generic VelocityCalculator in QML"
        ]
    }

//    TextSlide {
//        title: "Fling Animation using VelocityCalculator"
//        sourceFile: "fling-animation-with-velocity-calculator.qml"
//    }

    CustomCodeSlide {
        title: "Pressing Multiple Buttons"
        sourceFile: "examples/MultiButton.qml"
//        sourceFile: "examples/multibuttons.qml"
        Loader {
            anchors.right: parent.right
            anchors.rightMargin: -40
            source: "examples/multibuttons.qml"
        }
    }

    Slide {
        title: "Stuff left to work on"
        textFormat: Text.StyledText
        bulletSpacing: 0.6
        content: [
            "FlickHandler",
            "scroll & wheel events",
            "native gestures",
            "weak (non-exclusive) grab concept?",
            "get ready for public C++ API (create private-impl classes etc.)",
            "research Reactive Programming more: any good ideas? are we doing it all wrong then?"
        ]
    }

    Slide {
        id: lastSlide
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Pointer Handlers in Qt Quick</H1>

<H2>Contributors' Summit 2016</H2>

Shawn Rutledge<br/>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.<br/>
Follow progress: wip/pointerhandler branch of qtdeclarative
</html>"
    }

    SlideCounter { id: slideCounter }

    Clock { id: clock }

    Image {
        anchors {
            verticalCenter: slideCounter.verticalCenter
            right: slideCounter.left
            rightMargin: 20
        }
        height: slideCounter.height * 1.5
        fillMode: Image.PreserveAspectFit
        source: "images/bottom-logo.png"
        antialiasing: true
        smooth: true
    }

}
