import Qt.labs.presentation 1.0
import QtQuick 2.15

import "examples"

Presentation {
    id: presentation
    anchors.fill: parent
    mouseNavigation: false
    fontFamily: "Titillium Web"
    fontScale: 0.7

    width: 1920
    height: 1080

    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        sourceSize.width: 1920
        source: "images/QTVTC20 Slide Master.pdf"
        visible: currentSlide === 0
        antialiasing: true
        smooth: true
    }

    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        sourceSize.width: 1920
        source: "images/QTVTC20 Slide Master.pdf"
        currentFrame: 1
        visible: currentSlide === 1
        antialiasing: true
        smooth: true
    }

    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        sourceSize.width: 1920
        source: "images/QTVTC20 Slide Master.pdf"
        currentFrame: 3
        visible: currentSlide === presentation.slides.length - 1
        antialiasing: true
        smooth: true
    }

    Slide {
        id: title
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Qt PDF</H1>

Shawn Rutledge<br/>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.<br/>
QtPDF: <tt>src/pdf in qtwebengine</tt><br/>
this presentation is on github:<br/><tt>ec1oud/qt-presentations</tt> branch qtpdf</html>"
        Image {
            anchors.bottom: parent.bottom
            source: "images/qr.png"
        }
    }

    Slide {
        title: "History"
        textFormat: Text.RichText
        content: [
            "xpdf (1995); Poppler and Qt binding (2005)",
            "hackathon in Dec 2014: Qt wrapper for PDFium (working with Qt 5.4)",
            "QtPDF available since ~ Qt 5.10 (widgets only)",
            "<tt>https://www.qt.io/blog/2017/01/30/new-qtpdf-qtlabs-module</tt>",
            "build system change (gyp to gn)",
            "source is now in qtwebengine/src/pdf"
        ]
    }

    Slide {
        title: "Goals"
        textFormat: Text.StyledText
        content: [
            "make it easy to write a QQ PDF viewer with the usual feature set",
            "license OK for commercial users",
            "up-to-date",
            "QTBUG-77503 (the 'epic' feature list)",
            "component-based: <i>not</i> a whole viewer in an Item subclass",
            "push the limits with pre-existing Qt Quick components",
            "enable use of PDF as another scalable image format"
        ]
    }

    CustomCodeSlide {
        title: "Simplest possible multi-page viewer"
        sourceFile: "examples/simplest.qml"
    }

    CustomCodeSlide {
        title: "Metadata, text selection, zoom"
        sourceFile: "examples/withdoc.qml"
    }

    CustomCodeSlide {
        title: "Getting real"
        sourceFile: "examples/multipage.qml"
    }

    CustomCodeSlide {
        title: "Getting silly"
        sourceFile: "examples/borderimage.qml"
    }

    Slide {
        title: "Stuff left to work on"
        textFormat: Text.StyledText
        content: [
            "bookmarks",
            "arbitrary page numbers",
            "thumbnails",
            "sharing document instance with PDF image plugin",
            "password-protected PDFs",
            "image cache improvements in Qt Quick",
            "tiled rendering?"
        ]
    }

    Slide {
        id: lastSlide
    }

    SlideCounter { id: slideCounter }

    Clock { id: clock }
}
