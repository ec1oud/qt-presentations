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
<H1>Pointer Handlers Tech Preview in Qt Quick</H1>
Shawn Rutledge<br/>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.
</html>"
    }

    Slide {
        title: "About me"
        content: [
            "Qt user since ~2004",
            "The Qt Company - Oslo since 2011",
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

    Slide {
        title: "What's wrong with MouseArea"
        content: [
            "handles touch via emulated mouse events only",
            "you can only press one at a time",
            "clumsiness with event accept/reject, preventStealing etc.",
            "a full-blown Item with nothing to render",
            "large, monolithic, can't change behavior"
        ]
    }

    Slide {
        title: "What's wrong with MultiPointTouchArea"
        content: [
            "not a good MouseArea replacement: nested-object verbosity",
            "a full-blown Item with nothing to render",
            "difficult to implement custom gesture recognition",
        ]

        Text {
            text: "
Rectangle {
    property alias pressed: touch1.pressed
    signal tapped
    MultiPointTouchArea {
        anchors.fill: parent
        touchPoints: [
            TouchPoint {
                id: touch1
                onPressedChanged: if (!pressed) root.tapped
            } ]
    }
}
"
            color: "SaddleBrown"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height - rule.y
            font.family: "Inconsolata"
            font.pointSize: parent.baseFontSize * 0.7
        }
    }

//    CustomCodeSlide {
//        title: "Flickable and MouseArea: hover and grab"
//        sourceFile: "examples/Flick.qml"
//    }

//    CustomCodeSlide {
//        title: "Flickable: filter, grab, steal or prevent"
//        sourceFile: "examples/Flickable2.qml"
//    }

//    ImageSlide {
//        title: "Many parallel event delivery paths (and some missing)"
//        source: "resources/event-delivery-before.png"
//    }

    Slide {
        title: "Goals for Pointer Handlers"
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
            ' Rectangle { TapHandler { id: th } color: th.pressed ? "red" : "blue" }',
            ' Rectangle { DragHandler { } }',
            ' Image { PinchHandler { } }'
        ]
    }

    Slide {
        title: "Features"
        content: [
            "declarative handlers for gestures (tap, drag, pinch etc.)",
            "easy stuff is easy",
            "plain QObject 'child' is lighter than Item or attached",
            "multiple small, lightweight, understandable handlers",
            "default target, use its bounds",
            "actual multi-touch support",
        ]
    }

    Slide {
        title: "Features"
        content: [
            "filter events by:",
            " device type",
            " pointer type",
            " button",
            " keyboard modifiers",
            "subclass Handlers in C++ for the less-mainstream cases",
            "it's completely different, so minimizes compatibility risks"
        ]
    }

    QmlSlide {
        title: "DragHandler"
        sourceFile: "examples/flingAnimation.qml"
    }

    QmlSlide {
        title: "DragHandler"
        sourceFile: "examples/joystick.qml"
    }

    QmlSlide {
        title: "TapHandler"
        sourceFile: "examples/tapHandler.qml"
    }

    QmlSlide {
        title: "TapHandler - multiple instances"
        sourceFile: "examples/multiTapHandler.qml"
    }

    QmlSlide {
        title: "TapHandler - non-rectangular areas"
        sourceFile: "examples/tapSectors.qml"
    }

    QmlSlide {
        title: "PinchHandler"
        sourceFile: "examples/pinchHandler.qml"
    }

    QmlSlide {
        title: "PinchHandler on a map"
        sourceFile: "examples/map.qml"
    }

    CustomCodeSlide {
        title: "DragHandler and TapHandler together"
        sourceFile: "examples/Slider.qml"
        Loader {
            anchors.right: parent.right
            anchors.rightMargin: 0
            source: "examples/sliders.qml"
        }
    }

//    QmlSlide {
//        title: "MouseHandler"
//        sourceFile: "examples/mouseHandler.qml"
//    }

    Slide {
        title: "Conceptual Changes: Handlers vs. Areas"
        textFormat: Text.StyledText
//        bulletSpacing: 0.6
        content: [
            "either an Handler or an Item can be the exclusive grabber",
            "any number of Handlers can be passive grabbers",
            "if number of touchpoints changes: ignore the grab,<br/>start over with event delivery",
            "Handler gives up exclusive grab when constraints aren't satisfied",
            "mouse event -> QQuickPointerEvent with one point inside",
            "PointerHandler receives the complete event",
            "PointerHandler accepts event: stop propagation",
            "grab/ungrab are independent"
        ]
    }

    Slide {
        title: "Wanting vs. grabbing"
        textFormat: Text.StyledText
//        bulletSpacing: 0.6
        content: [
            "an Item must grab a press to be able to get an update<br/>this leads us to monolithic Areas and childMouseEventFilter and grab-stealing",
            "PointerHandlers: we want to mostly let events propagate; exclusive grab should be less common",
            "virtual bool wantsEventPoint(QQuickEventPoint *)",
            "if wantsPointerEvent() returns true, virtual handlePointerEventImpl() will be called",
        ]
    }

    ImageSlide {
        title: "Existing QEvent hierarchy"
        source: "resources/event-hierarchy-before.png"
    }

    ImageSlide {
        title: "Event hierarchy for PointerHandlers Tech Preview"
        source: "resources/event-hierarchy-qt5.8.png"
    }

    ImageSlide {
        title: "Handler hierarchy so far"
        source: "resources/pointer-handlers-classes.png"
    }

    CustomCodeSlide {
        title: "Pressing Multiple Buttons"
        sourceFile: "examples/MultiButton.qml"
//        live: false
//        sourceFile: "examples/multibuttons.qml"
        Loader {
            anchors.right: parent.right
            anchors.rightMargin: 0
            source: "examples/multibuttons.qml"
        }
    }

    QmlSlide {
        title: "PointHandler"
        sourceFile: "examples/crosshairs.qml"
    }

    Slide {
        title: "Stuff left to work on"
        textFormat: Text.StyledText
        bulletSpacing: 0.6
        content: [
            "PointHandler",
            "FlickHandler",
            "scroll & wheel events",
            "finish defining the passive grab concept",
            "monitor without grabbing?",
            "get ready for public C++ API (create private-impl classes etc.)",
            "how to manipulate inner Handlers? attached properties?",
            "possible renaming",
            "focus on native gestures?"
        ]
    }

    Slide {
        id: lastSlide
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Pointer Handlers in Qt Quick</H1>
status: Tech Preview in Qt 5.10<br/><br/>
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
