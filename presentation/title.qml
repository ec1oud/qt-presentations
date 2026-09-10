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

[URL here]
"
    }

    Image {
        source: "resources/qt_logo.svg"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 50
        sourceSize.height: 100
    }
}

// TODO nice 3D animation
