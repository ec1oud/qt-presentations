import QtQuick
import QtQuick.Shapes

Item {
	width: 1920; height: 1080
    Flow {
        y: 40
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: title
            font.family: fontFamily
            font.pixelSize: headingFontSize // from Slides.qml
            font.bold: true
            text: 'ROS: Robot "Operating System"'
            textFormat: Text.MarkdownText
        }
        Timer {
            interval: 3000
            running: true
            onTriggered: title.text = "ROS: Robot ~~Operating System~~"
        }
    }

    TextEdit {
        id: markdownText
        readOnly: true
		anchors.fill: parent
		anchors.margins: 50
        anchors.topMargin: 150
        wrapMode: Text.Wrap
        textFormat: Text.MarkdownText
        font.family: fontFamily // from Slides.qml
        font.pixelSize: fontSize // from Slides.qml
        transformOrigin: Item.TopLeft
        scale: 1.5
		text: "
- communication middleware
  + ROS2: built on top of DDS (Data Distribution Service)
  + or Zenoh
  + discovery
- navigation
  + path planning
  + obstacle avoidance
  + SLAM (Simultaneous Localization and Mapping)
- motion planning / kinematics
  + converting between frames of reference
  + collision checking
- Ubuntu, Yocto, Windows, ...
"
    }

    Image {
        source: "resources/ros2_tf2_frames.png"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 30
        sourceSize.height: parent.height * 0.6
    }
}
