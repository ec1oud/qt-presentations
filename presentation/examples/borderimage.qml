import QtQuick 2.14

BorderImage {
    source: "resources/border.pdf"
    border.top: 37
    border.bottom: 37
    border.left: 37
    border.right: 37
    horizontalTileMode: BorderImage.Round
    verticalTileMode: BorderImage.Round

    SequentialAnimation on height {
        loops: Animation.Infinite
        NumberAnimation {
            duration: 2300
            to: 700
            easing.type: Easing.InElastic
        }
        NumberAnimation {
            duration: 2200
            to: 400
            easing.type: Easing.InElastic
        }
    }
    SequentialAnimation on width {
        loops: Animation.Infinite
        NumberAnimation {
            duration: 2000
            to: 600
            easing.type: Easing.InElastic
        }
        NumberAnimation {
            duration: 1500
            to: 300
            easing.type: Easing.InElastic
        }
    }
    height: 200
    width: 200
    opacity: 0
    SequentialAnimation on opacity {
        PauseAnimation {
            duration: 5000
        }
        NumberAnimation {
            to: 1
            duration: 2000
            easing.type: Easing.InQuad
        }
    }

}
