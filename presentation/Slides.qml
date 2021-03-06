import Qt.labs.presentation 1.0
import QtQuick 2.15

import "examples"

Presentation {
    id: presentation
    anchors.fill: parent
    mouseNavigation: false
    fontFamily: "TitilliumWeb"
    codeFontFamily: "Source Code Pro"
    fontScale: 0.7
    titleMargin: 30

    width: 1920
    height: 1080

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }

    Image {
        anchors.fill: parent
        sourceSize.width: 1920
        fillMode: Image.PreserveAspectFit
        source: "./resources/template.pdf"
        currentFrame: Math.min(currentSlide, frameCount - 1)
//        visible: currentSlide === 0
        smooth: true
    }

    Slide {
        id: title
        textColor: "black"
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Input Handling Update</H1>
<H2>What's Coming Up in Qt 6</H2>
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
            "Qt Quick, Controls and Dialogs",
        ]
    }

    Slide {
        title: "Agenda"
        bulletSpacing: 0.6
        content: [
            "Goals",
            "API changes",
            "Qt Quick",
            "Demo",
            "Remaining work",
            "Q&A"
        ]
    }

    Slide {
        title: "Goals"
        bulletSpacing: 0.6
        content: [
            "Every QInputEvent carries a QInputDevice*",
            " Qt::MouseEventSource was not enough",
            "Widgets, Qt Quick items and handlers keep working the same",
            "Common event delivery code for all QPointerEvents",
            "Qt Quick delivery simplified: no more wrappers",
            "Flickable handles touch (including replay: QTBUG-85607)",
            "Event objects as lightweight as possible",
            "Unblock fixing some old bugs",
            "Wacom tablets supported better",
            "Multi-seat"
        ]
    }

    Slide {
        title: "Initial conditions - Qt Quick"
        content: [
            "QQuickPointerEvent is a QObject wrapper for QTouchEvent, QMouseEvent etc.",
            "QQuickEventPoint is a wrapper for QTouchEvent::TouchPoint",
            " but every QQuickSinglePointEvent has one too",
            "QQuickEventPoint stores state between events: exclusive grabber, passive grabbers",
            "QQuickEventPoint has a parent pointer (QQuickPointerEvent *event) which is stable",
            " So it can be passed alone to any function, C++ or QML, and knows its context",
            "Delivery code is simplified by these wrappers",
            "Wrappers were meant as a prototype for QInputEvent refactoring"
        ]
    }

    ImageSlide {
        title: "Delivery in Qt < 5.8"
        autoScale: true
        source: Qt.resolvedUrl("resources/event-delivery-before.png")
    }

    ImageSlide {
        title: "Qt 5: QEvent hierarchy"
        autoScale: true
        source: Qt.resolvedUrl("resources/event-hierarchy-before.pdf")
    }

    ImageSlide {
        title: "Qt 5: Qt Quick Event Hierarchy"
        autoScale: true
        source: Qt.resolvedUrl("resources/event-hierarchy-qt5.15.pdf")
    }

    ImageSlide {
        title: "Delivery to Handlers in Qt >= 5.11"
        autoScale: true
        source: Qt.resolvedUrl("resources/qt5-handler-delivery-seq.png")
    }

    ImageSlide {
        title: "Qt 6 Event Hierarchy"
        autoScale: true
//        fullScreen: true
        source: Qt.resolvedUrl("resources/event-hierarchy-qt6.pdf")
    }

    ImageSlide {
        title: "Delivery to Handlers in Qt 6"
        autoScale: true
        source: Qt.resolvedUrl("resources/qt6-handler-delivery-seq.png")
    }

    Slide {
        title: "Initial conditions - QtGUI"
        content: [
            "QTouchEvent::TouchPoint is heap-allocated and has a PIMPL in spite of being temporary",
            "QPA events (and touchpoints) are special unrelated mostly-duplicate classes",
            "QPA events are heap-allocated in spite of being temporary",
            "All QInputEvents are stack-allocated in QGuiApplication, and go out of scope after delivery",
            "QInputEvent subclasses have duplicated but incompatible API",
            "QTouchEvent can have multiple points"
        ]
    }

    ImageSlide {
        title: "Design decisions"
        autoScale: true
        source: Qt.resolvedUrl("resources/design-decisions-flowchart.pdf")
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

//    QmlSlide {
//        title: "DragHandler"
//        sourceFile: "examples/flingAnimation.qml"
//    }

    CodeSlide {
        title: "Agnosticism"
        margins: 105
        code:
"
bool event(QEvent *ev) override
{
    if (ev->isPointerEvent() && static_cast<QPointerEvent *>(event)->isPressEvent()) {
        for (QEventPoint &point : event->points()) {
            if (reactToPress(point.position()))
                point.setExclusiveGrabber(this);
        }
        return true;
    }
    return false;
}
"
    }

    CodeSlide {
        title: "Is it a synthesized mouse event?"
        margins: 105
        code:
            "
void mousePressEvent(QMouseEvent *event) override
{
    qDebug()
        // The oldest API - unusable
        << \"spontaneous\" << event->spontaneous()

        // Qt::MouseEventSource : since Qt 5.4
        << \"source\" << event->source()
        << \"actual mouse?\" << (event->source() == Qt::MouseEventNotSynthesized)
        << \"perhaps from touch or tablet?\" << (event->source() == Qt::MouseEventSynthesizedByQt)

        // Similar to the QML Pointer Handlers acceptedDevices API (since 5.10)
        << \"device type\" << event->pointingDevice()->type()
        << \"from touchscreen?\" << (event->pointingDevice()->type() == QInputDevice::DeviceType::TouchScreen)
        << \"from touchpad?\" << (event->pointingDevice()->type() == QInputDevice::DeviceType::TouchPad)

        // Similar to the QML Pointer Handlers acceptedPointerTypes API (since 5.10)
        << \"pointer type\" << event->pointingDevice()->pointerType()
        << \"from finger?\" << (event->pointingDevice()->pointerType() == QPointingDevice::PointerType::Finger)
        << \"from eraser?\" << (event->pointingDevice()->pointerType() == QPointingDevice::PointerType::Eraser);
}
"
    }

//    CustomCodeSlide {
//        title: "Pressing Multiple Buttons"
//        sourceFile: "examples/MultiButton.qml"
//        Loader {
//            anchors.right: parent.right
//            anchors.rightMargin: 0
//            source: "examples/multibuttons.qml"
//        }
//    }

    QmlSlide {
        title: "PointHandler"
        sourceFile: "examples/singlePointHandlerProperties.qml"
    }

    Slide {
        title: "Stuff left to work on"
        textFormat: Text.StyledText
        bulletSpacing: 0.6
        content: [
            "Flickable: make it flick nicer",
            "Flickable: event replay",
            "rename QPointingDevice to QPointerDevice?",
            "get rid of QPointingDevice::pointerType?"
        ]
    }

    Slide {
        id: lastSlide
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Input Handling Update</H1>
<H2>What's Coming Up in Qt 6</H2>
Shawn Rutledge<br/>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.
</html>"
    }

    SlideCounter { id: slideCounter }

    property bool bottomStuffVisible: currentSlide < 4

    Image {
        id: leftLogo
        visible: bottomStuffVisible
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: 20
        }
        height: 78 * parent.height / 1080
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "resources/bottom-logo-left.png"
    }
}
