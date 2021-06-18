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
<H1>Interactive UIs in Qt Quick 3D</H1>
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
            "Linux/X11, Wayland, and macOS",
            "QtPDF",
            "Qt Quick, Controls and Dialogs",
        ]
    }

    Slide {
        title: "Agenda"
        bulletSpacing: 0.6
        content: [
            "Intro",
            "Fixed content in 3D apps",
            "3D content in 2D apps",
            "2D content in 3D apps",
            "Interactive 3D apps",
            "Event delivery details",
            "Remaining work",
            "Q&A"
        ]
    }

    Slide {
        title: "Disclaimers"
        bulletSpacing: 0.6
        content: [
            "I didn't implement Qt Quick 3D, only event delivery",
            "This presentation contains features we haven't shipped"
        ]
    }

    Slide {
        title: "Intro"
        bulletSpacing: 0.6
        content: [
            "What is a 3D interactive application?",
            "What sort of applications need 3D?"
        ]
    }

    QmlSlide {
        title: "Minimal Model Viewer"
        sourceFile: "examples/modelViewer.qml"
        verticalMargin: 80
    }

    CustomCodeSlide {
        title: "Minimal Model Viewer"
        sourceFile: "examples/modelViewer.qml"
    }

//    ImageSlide {
//        title: "Design decisions"
//        autoScale: true
//        source: Qt.resolvedUrl("resources/design-decisions-flowchart.pdf")
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
        title: "Suggestions for the community"
        textFormat: Text.StyledText
        bulletSpacing: 0.6
        content: [
            "Design standard toolbar icons for 3D applications"
        ]
    }

    Slide {
        id: lastSlide
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Interactive UIs in Qt Quick 3D</H1>
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
