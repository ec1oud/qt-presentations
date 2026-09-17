import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtRos2.GeometryMsgs

ColumnLayout {
    id: root
    width: 200; height: 540

    Node { // in QtRos2.Core, not QQ3D
        id: rosNode
        nodeName: "simplePublisher"

        PoseStampedPublisher {
            id: posePublisher
            topic: "/dogzilla/body_pose/command"
            header.frameId: "base_link"
        }
    }

    Label { text: `Subscribers: ${posePublisher.subscriberCount}` }

    Button {
        text: rosNode.initialized ? "Publish Random Pose" : "Waiting for ROS..."
        enabled: rosNode.initialized
        onClicked: posePublisher.pose.orientation.eulerAngles = root.randomAngles()
    }

    TextArea {
        Layout.columnSpan: 2
        Layout.fillWidth: true
        Layout.fillHeight: true
        readOnly: true
        text: JSON.stringify(posePublisher.pose.orientation, null, 2)
    }

    function randomBetween(min, max) {
        return min + Math.random() * (max - min)
    }

    function randomAngles() {
        return {
            "x": randomBetween(-10, 10),
            "y": randomBetween(-10, 10),
            "z": randomBetween(-10, 10)
        }
    }
}
