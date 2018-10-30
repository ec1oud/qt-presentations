import Qt.labs.presentation 1.0
import QtQuick 2.12

import "examples"

Presentation {
    id: presentation
    anchors.fill: parent
    mouseNavigation: false
    fontFamily: "TitilliumWeb"
    fontScale: 0.7
    property bool autoScaleImages: true

    width: 1920
    height: 1080

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }

    Image {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        fillMode: Image.PreserveAspectFit
        source: "resources/firstslide.jpg"
        visible: currentSlide === 0
        smooth: true
    }

    HtmlSlide {
        id: title
        htmlItem.y: parent.height * 0.2
        text: "<html>
<H1>Widgets Best Practices</H1>
<H2>AKA live-coding a QTableView with Designer</H2>
<p>Shawn Rutledge</p>
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
            "Qt Quick Input Handlers",
            "Linux/X11 and macOS",
            "QtPDF",
            "Qt Quick Controls and Dialogs",
        ]
    }

    Slide {
        title: "Agenda"
        content: [
            "Review of relevant API and collaboration",
            "qps",
            "Live-coding a process viewer"
        ]
    }

//    ImageSlide {
//        title: "Class Diagram"
//        source: "resources/model-and-view-classes.png"
//    }

    ImageSlide {
        title: "How QTableView accesses the model"
        source: "resources/model-and-view-collaboration-qtableview.png"
        autoScale: autoScaleImages
    }

    Slide {
        title: "qps"
        textFormat: Text.StyledText
        content: [
            "Qt 'top' / process explorer application (started ~1997)",
            "part of LXQt desktop now https://github.com/lxqt/qps",
            "my fork for this presentation: https://github.com/ec1oud/qps/tree/widgets-rewrite",
        ]
    }

    Slide {
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Widgets Best Practices</H1>
<H2>AKA live-coding a QTableView with Designer</H2>
<p>Shawn Rutledge</p>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.<br/>
This presentation:<br/><tt>https://github.com/ec1oud/qt-presentations/tree/widgets-QtWS2018</tt><br/>
The code:<br/><tt>https://github.com/ec1oud/qps/tree/widgets-rewrite</tt>
</html>"
    }

    ImageSlide {
        id: lastSlide
        source: "resources/lastslide.jpg"
        autoScale: autoScaleImages
        fullScreen: true
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

    property bool bottomStuffVisible: currentSlide < 3

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

//    Image {
//        id: rightLogo
//        anchors {
//            verticalCenter: slideCounter.verticalCenter
//            right: slideCounter.left
//            rightMargin: 20
//        }
//        width: 226; height: 34
//        fillMode: Image.PreserveAspectFit
//        smooth: true
//        source: "resources/bottom-logo-right.png"
//    }
}
