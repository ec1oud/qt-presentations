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
        source: "images/QtCS2022-front.pdf"
        currentFrame: 1
        visible: currentSlide === 0
        antialiasing: true
        smooth: true
    }

    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        sourceSize.width: 1920
        source: "images/green-corners.pdf"
        currentFrame: 0
        visible: currentSlide > 0
        antialiasing: true
        smooth: true
    }

    Slide {
        id: title
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
            "source is now in qtwebengine/src/pdf",
            "https://www.youtube.com/watch?v=y6-Khqrrz_U Qt Virtual Tech Con 2020",
            "Tech Preview in 6.3 (mostly the same as in 5.15)",
            "fully supported and more new features in 6.4"
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
        title: "Getting real"
        sourceFile: "examples/multipage.qml"
    }

    CustomCodeSlide {
        title: "Getting silly"
        sourceFile: "examples/borderimage.qml"
    }

    ImageSlide {
        title: "Modularity"
        source: Qt.resolvedUrl("images/item-stack.pdf")
    }

    ImageSlide {
        title: "Architecture"
        fullScreen: true
        autoScale: true
        source: Qt.resolvedUrl("images/qtpdf-classes.pdf")
    }

    Slide {
        title: "New stuff in 6.4"
        textFormat: Text.StyledText
        content: [
            "bookmarks",
            "arbitrary page numbers",
            "thumbnails",
            "sharing document instance with PDF image plugin",
            "password-protected PDFs",
            "API cleanup",
            "widget improvements (more coming in 6.5, probably)"
        ]
    }

    Slide {
        title: "Stuff left to work on"
        textFormat: Text.StyledText
        content: [
            "image cache improvements in Qt Quick",
            "Android support",
            "tiled rendering?",
            "annotations?"
        ]
    }

    Slide {
        title: "Stuff the community could help with"
        textFormat: Text.StyledText
        content: [
            "XFA?",
            "use Poppler in Qt Quick, same API?",
            "?"
        ]
    }

    CustomCodeSlide {
        title: "Primitive vector elements in the scene graph (SVG, could be PDF?)"
        sourceFile: "examples/svgview.qml"
    }

    Slide {
        id: lastSlide
        title: "Discussion"
    }

    SlideCounter { id: slideCounter }

    Clock { id: clock }
}
