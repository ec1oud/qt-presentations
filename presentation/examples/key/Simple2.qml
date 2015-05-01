import QtQuick 2.1

Rectangle {
    width: 100
    height: 100

    color: "green"
    Keys.onSpacePressed: color = "blue"
    focus: true
}
