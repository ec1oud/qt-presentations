import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Item { // typically ApplicationWindow
    id: window
    width: 640
    height: 1280
    visible: true

    Material.accent: Material.Green

    Column {
        anchors.right: parent.right
        RadioButton {
            checked: true
            text: "Option 1"
        }
        RadioButton {
            text: "Option 2"
        }
        RadioButton {
            text: "Option 3"
        }
    }

    Drawer {
        id: drawer
        width: window.width * 0.33
        height: window.height

//        Material.accent: Material.Green
        Material.theme: Material.Dark

        ListView {
            model: 100
            anchors.fill: parent
            header: SwitchDelegate {
                text: "Option"
                checked: true
                width: parent.width
            }
            delegate: ItemDelegate {
                width: parent.width
                text: "Item " + (index + 1)
                onClicked: drawer.close()
            }
            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }
}
