import QtQuick 2.0
import QtCharts 2.1
import QtQuick.Controls 1.4 as QQC1
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Styles 1.1 as QQC1S

ChartView {
    title: "Total Object Count for One Slider"
    titleFont.pointSize: 14
    legend.alignment: Qt.AlignBottom
    legend.font.pointSize: 14
    antialiasing: true
    width: 640
    height: 480

    StackedBarSeries {
        id: mySeries
        axisX: BarCategoryAxis { categories: ["Base", "Desktop", "Default", "Universal", "Material" ]; labelsFont.pointSize: controls1Label.font.pointSize }
        axisY: ValueAxis { max: 120; labelFormat: "%d"; labelsFont.pointSize: 14 }
        BarSet { label: "Items"; values: [37, 7, 3, 5, 6] }
        BarSet { label: "Additional QObjects"; values: [114 - 37, 30 - 7, 4 - 3, 6 - 5, 8 - 6] }
    }

    Row {
        width: parent.width - x - 26
        height: 20
        x: 72
        y: parent.height - height
        spacing: 10
        Rectangle {
            id: controls1box
            width: parent.width * 0.396
            height: parent.height
            color: "lightgrey"
            Text {
                id: controls1Label
                fontSizeMode: Text.Fit; minimumPixelSize: 6; font.pixelSize: 14
                anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                text: "QtQuick Controls 1"
            }
            QQC1.Slider {
                anchors.top: parent.bottom
                anchors.topMargin: 13
                width: parent.width
                value: 0.5
                style: QQC1S.SliderStyle {
                    groove: Rectangle {
                        implicitWidth: 200
                        implicitHeight: 8
                        color: "#599d19"
                        radius: 3
                        antialiasing: true
                    }
                }
            }
        }
        Rectangle {
            width: parent.width - controls1box.width - parent.spacing
            height: parent.height
            color: "lightgrey"
            Text {
                fontSizeMode: Text.Fit; minimumPixelSize: 6; font.pixelSize: 14
                anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                text: "QtQuick Controls 2"
            }
            QQC2.Slider {
                anchors.top: parent.bottom
                width: parent.width
                value: 0.5
                Material.accent: "#ff420f"
            }
        }
    }
}
