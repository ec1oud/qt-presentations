import QtQuick 2.1

Rectangle {
    width: 100
    height: 200

    color: "#bbb"
    Keys.onSpacePressed: color = "blue"
}