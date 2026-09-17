import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtRos2.GeometryMsgs

ColumnLayout {
    width: 200; height: 560

    Node { // in QtRos2.Core, not QQ3D
        id: rosNoded
        nodeName: "simpleSubscriber"

        PoseStampedSubscriber {
            id: sub
            property int receivedCount: 0
            topic: "/dogzilla/body_pose/state"
            onMessageReceived: ++receivedCount
        }
    }

    Label { text: `connected: ${sub.connected} received: ${sub.receivedCount}` }

    Label { text: `**roll** ${sub.pose.orientation.rpyDegrees.x.toFixed(2)}° ` +
                 `**pitch** ${sub.pose.orientation.rpyDegrees.y.toFixed(2)}° ` +
                   `**yaw** ${sub.pose.orientation.rpyDegrees.z.toFixed(2)}°`
            textFormat: Label.MarkdownText }

    TextArea {
        text: JSON.stringify(sub.pose, null, 2)
        Layout.columnSpan: 2; Layout.fillWidth: true; Layout.fillHeight: true
        readOnly: true
    }
}
