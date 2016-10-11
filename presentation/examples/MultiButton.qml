import QtQuick 2.8
import Qt.labs.handlers 1.0

Rectangle {
    id: root
    width: label.implicitWidth * 1.5; height: label.implicitHeight * 2.0
    border.color: "#9f9d9a"; border.width: 1; radius: height / 4; antialiasing: true
    property alias label: label.text
    property alias pressed: tap.isPressed
    signal clicked

    gradient: Gradient {
        GradientStop { position: 0.0; color: tap.isPressed ? "#b8b5b2" : "#efebe7" }
        GradientStop { position: 1.0; color: "#b8b5b2" }
    }

    TapHandler {
        id: tap
        onIsPressedChanged: if (!isPressed) root.clicked
    }

    /* the old way:
    MultiPointTouchArea {
        anchors.fill: parent
        touchPoints: [
            TouchPoint {
                id: touch1
                onPressedChanged: if (!pressed) root.clicked
            } ]
    }
    */

    Text {
        id: label
        font.pointSize: 14
        text: "Button"
        anchors.centerIn: parent
    }
}
