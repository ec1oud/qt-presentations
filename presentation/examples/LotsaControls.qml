import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.0

Item {
    width: 1920; height: 1000
    visible: false
    StackView {
        id: stackView
        anchors.fill: parent
        font.pointSize: 18

        initialItem: Page {
            header: ToolBar {
                Row {
                    anchors.fill: parent

                    ToolButton {
                        text: qsTr("StackView")
                    }
                    ToolButton {
                        text: qsTr("with")
                    }
                    ToolButton {
                        text: qsTr("ToolBar")
                    }
                    ToolButton {
                        text: qsTr("and")
                    }
                    ToolButton {
                        text: qsTr("ToolButtons")
                    }
                }
            }

            footer: TabBar {
                TabButton {
                    text: qsTr("TabBar")
                }
                TabButton {
                    text: qsTr("with a TabButton")
                }
                TabButton {
                    text: qsTr("and another TabButton")
                }
            }

            GridLayout {
                id: grid
                columns: 6
                anchors.fill: parent; anchors.margins: 8

                BusyIndicator {
                    running: true
                }

                Button {
                    text: "Button"
                }

                CheckBox {
                    text: "CheckBox"
                    checked: true
                }

                ComboBox {
                    textRole: "key"
                    Layout.preferredWidth: 240
                    model: ListModel {
                        ListElement { key: "ComboBox"; value: 123 }
                        ListElement { key: "has selections"; value: 456 }
                        ListElement { key: "in a box"; value: 789 }
                    }
                }

                Dial {
                    id: dial
                    value: 0.5
                    width: 100; height: 100
                    Timer {
                        interval: 500; running: !parent.pressed; repeat: true
                        onTriggered: dial.value = Math.random(1)
                    }
                }

                Frame {
                    ColumnLayout {
                        anchors.fill: parent
                        CheckBox { text: qsTr("check"); checked: true }
                        CheckBox { text: qsTr("box") }
                    }
                }

                GroupBox {
                    title: qsTr("GroupBox")
                    ColumnLayout {
                        anchors.fill: parent
                        RadioButton { text: qsTr("KQED") }
                        RadioButton { text: qsTr("KCSM") }
                        RadioButton { text: qsTr("KREV") }
                    }
                }

                Label {
                    text: "Label"
                }

                Button {
                    id: menuButton
                    text: "Menu"
                    onClicked: menu.open()

                    Menu {
                        id: menu
                        y: menuButton.height

                        MenuItem {
                            text: "New..."
                        }
                        MenuItem {
                            text: "Open..."
                        }
                        MenuItem {
                            text: "Save"
                        }
                    }
                }

                Frame {
                    Layout.preferredWidth: 240
                    Layout.preferredHeight: 200
                    SwipeView {
                         id: view
                         clip: true

                         currentIndex: 1
                         anchors.fill: parent

                         Rectangle { color: "lightgrey" }
                         Rectangle {
                             color: "beige"
                             Label {
                                 text: "SwipeView in a Frame with a PageIndicator underneath"
                                 font.pointSize: 14
                                 horizontalAlignment: Text.AlignHCenter
                                 wrapMode: Text.WordWrap
                                 anchors.fill: parent
                             }
                         }
                         Rectangle { color: "lightsteelblue" }
                     }

                     PageIndicator {
                         id: indicator

                         count: view.count
                         currentIndex: view.currentIndex

                         anchors.bottom: view.bottom
                         anchors.horizontalCenter: parent.horizontalCenter
                     }
                }

                ProgressBar {
                    value: 0.5
                    Timer {
                        interval: 400; running: true; repeat: true
                        onTriggered: parent.value = Math.random(1)
                    }
                }

                RadioButton {
                    text: "RadioButton"
                    checked: true
                }

                RangeSlider {
                    id: rangeSlider
                    first.value: 0.25
                    second.value: 0.75
                    Timer {
                        interval: 400; running: !rangeSlider.left.pressed && !rangeSlider.right.pressed; repeat: true
                        onTriggered: {
                            parent.first.value = Math.random() * 0.25
                            parent.second.value = Math.random() * 0.25 + 0.75
                        }
                    }
                }

                Flickable {
                    clip: true
                    height: rangeSlider.height
                    width: 240
                    contentWidth: width * 1.5
                    contentHeight: height * 1.1
                    Label { text: "ScrollBar . . . . . . . . . . . . . . . . . . . . . . . . . ." }
                    ScrollBar.horizontal: ScrollBar { active: true }
                    ScrollBar.vertical: ScrollBar { active: true }
                }

                Flickable {
                    clip: true
                    height: rangeSlider.height
                    width: 240
                    contentWidth: width * 1.5
                    contentHeight: height * 1.1
                    Label { text: "ScrollIndicator . . . . . . . . . . . . . . . . . . . . . . . . . ." }
                    ScrollIndicator.horizontal: ScrollIndicator { active: true }
                    ScrollIndicator.vertical: ScrollIndicator { active: true }
                }

                Slider {
                    value: 0.25
                    Timer {
                        interval: 400; running: !parent.pressed; repeat: true
                        onTriggered: parent.value = Math.random()
                    }
                }

                SpinBox {
                    value: 50
                }

                SwipeDelegate {
                    text: "SwipeDelegate"
                    clip: true

                    swipe.left: Rectangle {
                        color: SwipeDelegate.pressed ? "#333" : "#444"
                        width: parent.width
                        height: parent.height
                        clip: true

                        Label {
                            font.pixelSize: swipeDelegate.font.pixelSize
                            text: "Left"
                            color: "white"
                            anchors.centerIn: parent
                        }
                    }

                    swipe.right: Rectangle {
                        color: SwipeDelegate.pressed ? "#333" : "#444"
                        width: parent.width
                        height: parent.height

                        Label {
                            font.pixelSize: swipeDelegate.font.pixelSize
                            text: "Right"
                            color: "white"
                            anchors.centerIn: parent
                        }
                    }
                }

                Switch {
                    text: qsTr("Switch")
                }

                TextArea {
                    text: "TextArea\nhas several\nlines"
                }

                TextField {
                    text: "TextField"
                }

                Button {
                    text: qsTr("ToolTip")
                    hoverEnabled: true

                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("A descriptive tool tip of what the button does")
                }

                Tumbler {
                    model: ["Tumbler", "drifting", "along", "with the", "tumbling"]
                    Layout.preferredWidth: 200
                }
            }
        }
    }
}
