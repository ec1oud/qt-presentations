import QtQuick
import QtQuick.Shapes

Rectangle {
    width: 1920
    height: 1080
    color: "black"

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
## Introduction to Qt ROS - Architecture and Demo

# Agenda

Qt, Qt Quick, declarative programming

What is ROS?

ROS API stack

ROS communication patterns

Explanation of demo

ROS communication patterns in the demo code

Generating a Digital Twin from URDF

Collision detection physics
"
    }

    Image {
        source: "resources/qt_logo.svg"
        anchors { top: parent.top; right: parent.right; margins: 50 }
        sourceSize.height: 100
    }

    Image {
        id: docsQR
        source: "resources/slides-url.png"
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 100
        }
    }
    Text {
        anchors { top: docsQR.bottom; right: docsQR.right; margins: 8 }
        color: "white"; font: markdownText.font
        text: "https://github.com/ec1oud/qt-presentations/tree/robotics"
    }
}

