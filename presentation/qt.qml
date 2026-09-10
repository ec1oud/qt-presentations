import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D
import "resources/rock" as Rock

Item {
    width: 1920
    height: 1080

    TextEdit {
        id: markdownText
        readOnly: true
		anchors.fill: parent
		anchors.margins: 50
        anchors.topMargin: 50
        wrapMode: Text.Wrap
        textFormat: Text.MarkdownText
        font.family: fontFamily // from Slides.qml
        font.pixelSize: fontSize // from Slides.qml
        transformOrigin: Item.TopLeft
        scale: 1.5
		text: "
# What is Qt?
- in the beginning: a general-purpose C++ framework and widget toolkit
- more recently: exploit the GPU, move beyond C++, etc.
- QML, Qt Quick, Qt Quick 3D, many newer modules
"
    }

    RowLayout {
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height / 2

        View3D {
            id: view
            Layout.fillWidth: true; Layout.fillHeight: true
            PerspectiveCamera { position: Qt.vector3d(0, 10, 18); eulerRotation.x: -30 }
            DirectionalLight { eulerRotation.x: -30 }

            Rock.Scene {
                scale: Qt.vector3d(5, 5, 5)
                Vector3dAnimation on eulerRotation {
                    loops: Animation.Infinite
                    duration: 15000
                    from: Qt.vector3d(0, 0, 0)
                    to: Qt.vector3d(360, 0, 360)
                }
            }
        }
    }
}

// TODO show source
// TODO cool 3D stuff
