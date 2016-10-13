import QtQuick 2.7
import QtQuick.Controls 2.0

Column {
    width: 200; height: 480; spacing: 20
    Button {
        text: "Button"
        enabled: checkbox.checked
    }

    CheckBox {
        id: checkbox
        text: "enable"
        checked: true
    }
}
