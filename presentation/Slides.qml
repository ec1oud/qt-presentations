import Qt.labs.presentation 1.0
import QtQuick 2.15

import "examples"

Presentation {
    id: presentation
    anchors.fill: parent
    mouseNavigation: false
    fontFamily: "TitilliumWeb"
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
        source: "resources/template.pdf"
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
<H1>Editing Markdown with QTextDocument</H1>
<H2>Widgets and Qt Quick</H2>
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


    QmlSlide {
        title: "Text in QML"
        sourceFile: "examples/text-inline.qml"
    }

    Slide {
        title: "Motivations"
        content: [
            "QTD supports little of HTML, but all of Markdown",
            "Good default text format",
            "WYSIWYG and text-editing approaches equally good",
            "Applications:",
            " documentation",
            " notes, TODO lists",
            " email viewing and composition",
            " blogging, writing, micro-publishing",
            " <your idea here>"
        ]
    }

    Slide {
        title: "Markdown Features"
        bulletSpacing: 0.6
        content: [
            "QTextDocument::setMarkdown(), toMarkdown()",
            "GitHub dialect by default",
            " tables, checkboxes, strikethrough, permissive autolinks",
            "CommonMark, NoHTML (restricted features)",
            " QTextDocument::setMarkdown(MarkdownDialectCommonMark | MarkdownNoHTML)",
            "Thanks to Martin Mitáš for md4c",
            " https://github.com/mity/md4c v0.4.3 currently"
        ]
    }

    CustomCodeSlide {
        title: "Demo: Controls 2 example"
        sourceFile: "examples/textarea-markdown.qml"
    }

    Slide {
        title: "Demo: Nettebook"
    }

    Slide {
        title: "Stuff left to work on"
        textFormat: Text.StyledText
        bulletSpacing: 0.6
        content: [
            "another BlockMarker to decorate block quotes",
            "CSS (no promises!)",
            "keep fixing bugs"
        ]
    }

    Slide {
        id: lastSlide
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Editing Markdown with QTextDocument</H1>
<H2>Widgets and Qt Quick</H2>
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
