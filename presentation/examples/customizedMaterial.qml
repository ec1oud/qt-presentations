import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Item { // typically ApplicationWindow
    id: window
    width: 640
    height: 1280
    visible: true

    Material.accent: group.checkedButton.color //Material.Green

    Column {
        id: column; anchors.right: parent.right; width: slider.width
        RadioButton { text: "Lime";       property var color: Material.Lime }
        RadioButton { text: "DeepOrange"; property var color: Material.DeepOrange; checked: true }
        RadioButton { text: "Indigo";     property var color: Material.Indigo }
    }

    Drawer {
        id: drawer
        width: window.width * 0.33
        height: window.height

        // Material.accent is inherited from ApplicationWindow
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

    Column {
        anchors.top: column.bottom
        anchors.left: column.left
        Switch { checked: true; text: "Bluetooth"; enabled: enableCB.checked }
        Switch { text: "WiFi"; enabled: enableCB.checked }
        Slider { id: slider; value: 0.5; enabled: enableCB.checked }
        CheckBox { id: enableCB; text: "enabled"; checked: true }
    }

    ButtonGroup {
        id: group
        buttons: column.children
        // cheat: couldn't easily do this declaratively
        onCheckedButtonChanged: rootWindow.Material.accent = checkedButton.color
    }
}
