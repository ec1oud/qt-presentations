import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Shapes 1.12

Item {
    width: 600 * scale; height: 200 * scale
    scale: 2
    Shape {
        id: boundaryRuleCurve
        anchors.centerIn: parent
        width: 450
        height: 100
        ShapePath {
            strokeWidth: 2
            strokeColor: "black"
            startX: 0; startY: boundaryRuleCurve.height
            PathSvg { path: "q 50 0 100 0 l 200 0 q 50 0 150 100" }
        }
        ShapePath {
            strokeWidth: 2
            strokeColor: "green"
            strokeStyle: ShapePath.DashLine
            dashPattern: [ 1, 4 ]
            startX: 100; startY: 0
            PathLine { x: 100; y: 100 }
        }
        ShapePath {
            strokeWidth: 2
            strokeColor: "green"
            strokeStyle: ShapePath.DashLine
            dashPattern: [ 1, 4 ]
            startX: 300; startY: 0
            PathLine { x: 300; y: 100 }
        }
        ShapePath {
            strokeColor: "green"
            startX: 100; startY: 20
            PathLine { x: 300; y: 20 }
        }
    }
    Rectangle {
        width: avLabel.width + 20
        height: avLabel.height
        x: boundaryRuleCurve.x + 200 - width / 2
        y: boundaryRuleCurve.y + 20 - height / 2
        Text {
            id: avLabel
            text: "unmolested"
            anchors.centerIn: parent
        }
    }

    Ruler {
        anchors.bottom: boundaryRuleCurve.bottom
        anchors.bottomMargin: -height // TODO shouldn't be necessary: make it anchor nicely inside or outside
        anchors.left: boundaryRuleCurve.left
        width: boundaryRuleCurve.width
        height: 20
        edge: Qt.TopEdge
        labelMajorTicks: false
        tickHeights: [1, 0.6]
        tickColor: "brown"
        Text {
            anchors.top: parent.bottom
            x: 200 - width / 2
            text: "input"
        }
        Text {
            x: 25
            y: -height
            text: "overshoot"
            transformOrigin: Item.BottomLeft
            rotation: -50
            horizontalAlignment: Text.Center
        }
        Text {
            x: parent.width - width - 40
            y: -height
            text: "overshoot"
            transformOrigin: Item.BottomRight
            rotation: 38
            horizontalAlignment: Text.Center
        }
    }
    Ruler {
        anchors.right: boundaryRuleCurve.left
        anchors.top: boundaryRuleCurve.top
        width: 20
        height: boundaryRuleCurve.height
        edge: Qt.RightEdge
        labelMajorTicks: false
        tickHeights: [1, 0.6]
        tickColor: "brown"
        Text {
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.Center
            x: height * -2
            text: "correspondence\nof output"
            rotation: -90
        }
    }
}
