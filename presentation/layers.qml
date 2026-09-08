import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    width: 1920
    height: 1080

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: fontFamily
        font.pixelSize: headingFontSize // from Slides.qml
        font.bold: true
        text: "ROS client API stack"
    }

    GridLayout {
        columns: 5
        rows: 7
        anchors.fill: parent
        anchors.margins: 50
        anchors.topMargin: 150

        component Box: Rectangle {
            property alias title: titleText.text
            property alias text: descText.text
            property alias textOffset: textCol.anchors.horizontalCenterOffset
            Column {
                id: textCol
                y: 6
                spacing: 6
                anchors.horizontalCenter: parent.horizontalCenter
                // anchors.horizontalCenterOffset: 20
                Text {
                    id: titleText
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: fontFamily
                    font.pixelSize: headingFontSize / 2 // from Slides.qml
                    font.bold: true
                }

                Text {
                    id: descText
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: titleText
                    font.family: fontFamily
                    font.pixelSize: fontSize * 0.75 // from Slides.qml
                    textFormat: Text.MarkdownText
                }
            }

            Layout.horizontalStretchFactor: Layout.columnSpan
            implicitHeight: Math.max(80, textCol.implicitHeight + 12)
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Box {
            color: 'goldenrod'
            title: "QML / C++ visualization app"
            Layout.columnSpan: 2
            Image {
                x: 12; y: 12
                source: "resources/computer-laptop.svg"
                sourceSize.height: parent.height - 24
            }
        }
        Box {
            color: 'goldenrod'
            title: "QML / C++\nonboard app"
            textOffset: 60 // * root.width / 1920
            Image {
                x: 12; y: 12
                source: "resources/dogzilla.png"
                sourceSize.height: parent.height - 24
            }
        }
        Box {
            color: 'slategrey'
            title: "native C++ app"
            Layout.column: 3
            Layout.row: 1
        }
        Box {
            color: 'grey'
            title: "Python app"
            Layout.column: 4
            Layout.row: 0
        }
        Box {
            color: 'grey'
            title: "rclpy (Python API)"
            text: "- Exec. with Thread\n- Intra-process comms\n- Type adaptation"
            Layout.column: 4
            Layout.row: 1
        }

        Box {
            color: 'springgreen'
            title: "Qt Quick 3D & Physics"
            text: "- Robot model\n- LiDAR\n- environment"
            Layout.row: 1
            Layout.columnSpan: 1
        }
        Box {
            color: 'aquamarine'
            title: "Qt ROS 2 Bridge"
            text: "- Generated QML pubs, subs, servers, clients, ...\n- Generated QML value types\n- Qt event-loop integration"
            // text: "- Generated QML pubs, subs, servers, clients, ...\n- Generated QML value types\n- QRos2Node, QRos2Context\n- Qt event-loop integration"
            Layout.row: 1
            Layout.column: 1
            Layout.columnSpan: 2
        }

        Box {
            color: 'khaki'
            title: "rclcpp (C++ API)"
            text: "- Exec. with std::thread\n- Intra-process comms\n- Type adaptation"
            Layout.column: 0
            Layout.row: 2
            Layout.columnSpan: 5
        }

        Box {
            color: 'lightsteelblue'
            title: "rcp (C API / optional C++ implementation)"
            text: "- actions\n- parameters\n- names\n- time\n- node lifecycle"
            Layout.column: 0
            Layout.row: 3
            Layout.columnSpan: 5
        }

        Box {
            color: 'skyblue'
            title: "DDS implementation (choose one)"
            Layout.column: 0
            Layout.row: 4
            Layout.columnSpan: 5
            // Layout.minimumHeight: 100

            Flow {
                id: logoflow
                spacing: 24
                anchors {
                    top: parent.top
                    topMargin: fontSize + 24
                    bottom: parent.bottom
                    bottomMargin: 12
                    horizontalCenter: parent.horizontalCenter
                }
                Image {
                    source: "resources/Fast-DDS-Logo-horizontal-no-margin.png"
                    sourceSize.height: parent.height
                }
                Image {
                    source: "resources/cyclonedds-light.png"
                    sourceSize.height: parent.height
                }
                Text {
                    text: "RTI Connext"
                    color: "sienna"
                    font.pixelSize: parent.height
                }
                Text {
                    text: "... or others"
                    font.pixelSize: parent.height
                }
            }

            Image {
                x: 12; y: 12
                source: "resources/OMG_LOGO.png"
                sourceSize.height: parent.height - 24
            }
        }
    }
}