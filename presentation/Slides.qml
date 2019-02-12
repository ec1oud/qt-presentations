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
        source: "resources/firstslide.png"
        visible: currentSlide === 0
        smooth: true
    }

    HtmlSlide {
        id: title
        htmlItem.y: parent.height * 0.2
        text: "<html>
<H1>TableView and DelegateChooser</H1>
<H2>new in 5.12</H2>
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
            "Review of Qt Quick Controls 1.x TableView",
            "Introduction to Qt Quick TableView",
            "Comparison of model-view relationships",
            "Demo & walkthrough: refactoring of qps",
            "Remaining work"
        ]
    }

    HtmlSlide {
        title: "Qt Quick Controls 1.x TableView"
        text: "<html>
        <H1>Qt Quick Controls 1.x TableView</H1>
        <H2>advantages:</H2>
<li>looks native on desktop</li>
<li>TableColumn API<li>
        <H2>disadvantages:</H2>
<li>performance (too many Items and Loaders)</li>
<li>loads all columns when instantiating a row<li>
<li>depends on data roles in the model<li>
        <H2>architecture:</H2>
<li>QML declarations define the columns<li>
        </html>"

        Loader {
            x: parent.width * 0.5
            y: parent.height * 0.2
            width: parent.width - x - 20
            height: parent.height * 0.6
            source: parent.visible ? "examples/TableView1.qml" : ""
        }
    }

    HtmlSlide {
        title: "The New Qt Quick TableView"
        text: "<html>
        <H1>The New Qt Quick TableView</H1>
        <H2>advantages:</H2>
<li>instantiates only the visible delegates</li>
<li>pools and reuses delegate instances<li>
<li>suitable for models that work with QTableView<li>
        <H2>disadvantages:</H2>
<li>isn't a drop-in replacement for QQC1 TableView</li>
        <H2>architecture:</H2>
<li>like a 2-dimensional ListView<li>
<li>model (or proxy) defines columns, not data roles<li>
<li>styling is entirely up to you (as with ListView)<li>
        </html>"

//        TableView2 {
//            x: parent.width * 0.45
//            y: parent.height * 0.2
//            width: parent.width - x - 20
//            height: parent.height * 0.6
//        }
        Loader {
            x: parent.width * 0.5
            y: parent.height * 0.2
            width: parent.width - x - 20
            height: parent.height * 0.6
            clip: true
            source: parent.visible ? "examples/TableView2.qml" : ""
        }
    }

//    CustomCodeSlide {
//        title: "TableView API"
//        sourceFile: "tableview.h"
//    }

    ImageSlide {
        title: "Class Diagram"
        source: "resources/model-and-view-classes.png"
        autoScale: autoScaleImages
    }

    ImageSlide {
        title: "Three Views Sharing a Model"
        source: "resources/model-and-view-collaboration.png"
        autoScale: autoScaleImages
    }

    ImageSlide {
        title: "How QTableView accesses the model"
        source: "resources/model-and-view-collaboration-qtableview.png"
        autoScale: autoScaleImages
    }

    ImageSlide {
        title: "How ListView accesses the model"
        source: "resources/model-and-view-collaboration-listview.png"
        autoScale: autoScaleImages
    }

    ImageSlide {
        title: "How TableView accesses the model"
        source: "resources/model-and-view-collaboration-tableview.png"
        autoScale: autoScaleImages
    }

    Slide {
        title: "qps"
        textFormat: Text.StyledText
        content: [
            "Qt 'top' / process explorer application (started ~1997)",
            "part of LXQt desktop now https://github.com/lxqt/qps",
            "my fork for this presentation: https://github.com/ec1oud/qps",
        ]
    }
    Slide {
        title: "Stuff left to work on"
        textFormat: Text.StyledText
        bulletSpacing: 0.6
        content: [
            "Header view",
            "Resizing columns",
            "Selection",
            "Decorations and styling",
            "QML TableModel (QTBUG-70334)",
            "QML ProxyModel (QTPM-1327)"
        ]
    }

    Slide {
        id: lastSlide
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>TableView and DelegateChooser</H1>
<H2>new in 5.12</H2>
<p>Shawn Rutledge</p>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.<br/>
This presentation:<br/><tt>https://github.com/ec1oud/qt-presentations/tree/tableview</tt><br/>
The code:<br/><tt>https://github.com/ec1oud/qps</tt>
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
