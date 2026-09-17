import QtQuick
import QtQuick.Shapes

Rectangle {
    width: 1920
    height: 1080
    color: "black"

    Image {
        source: "resources/ndctechtown-black.png"
        x: 50; y: 50
        transformOrigin: Item.TopLeft
        scale: 0.5 * parent.height / 1080
    }

    TextEdit {
        id: markdownText
        color: "palegreen"
        readOnly: true
		anchors.fill: parent
		anchors.margins: 50
        anchors.topMargin: parent.height / 4
        wrapMode: Text.Wrap
        textFormat: Text.MarkdownText
        font.family: fontFamily // from Slides.qml
        font.pixelSize: fontSize // from Slides.qml
        transformOrigin: Item.TopLeft
        scale: 1.5
		text: "
# Introduction to Qt ROS Bridge
## Architecture and Demo

shawn.rutledge @ qt.io
"
    }

    Image {
        source: "resources/qt_logo.svg"
        anchors { top: parent.top; right: parent.right; margins: 50 }
        sourceSize.height: 100
    }

    Image {
        id: docsQR
        source: "resources/docs-url.png"
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: 100
        }
    }
    Text {
        anchors { top: docsQR.bottom; left: docsQR.left; margins: 8 }
        color: "white"; font: markdownText.font
        text: "https://doc-snapshots.qt.io/qtros2/"
    }

    Image {
        id: codeQR
        source: "resources/code-url.png"
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 100
        }
    }
    Text {
        anchors { top: codeQR.bottom; right: codeQR.right; margins: 8 }
        color: "white"; font: markdownText.font
        text: "https://git.qt.io/qt-robotics"
    }
}

// TODO nice 3D animation
