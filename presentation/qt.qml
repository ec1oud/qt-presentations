import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal
import QtQuick.Layouts
import QtQuick3D
import QtQuick3D.Helpers
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
  * containers, network, ...
  * improvement on Xt, Athena, Motif etc.
- cross-platform (all the platforms)
- single-rooted C++ inheritance (QObject base)
- properties with accessors and notifier signals; connect()
- more recently: exploit the GPU, move beyond C++
- QML, Qt Quick, 3D, Physics, ...
"
    }

    RowLayout {
        anchors { fill: parent; margins: 50; topMargin: parent.height / 2 }

        View3D {
            Layout.fillWidth: true; Layout.fillHeight: true
            Node {
                id: camorg
                PerspectiveCamera { id: cam; position: Qt.vector3d(0, 200, 300); eulerRotation.x: -30 }
            }
            DirectionalLight { eulerRotation.x: -70 }

            OrbitCameraController {
                anchors.fill: parent
                origin: camorg; camera: cam
            }

            Rock.Scene {
                scale: Qt.vector3d(100, 100, 100)
                Vector3dAnimation on eulerRotation {
                    loops: Animation.Infinite
                    duration: 15000
                    from: Qt.vector3d(0, 0, 0)
                    to: Qt.vector3d(360, 0, 360)
                    paused: !sw1.checked
                }
                Model {
                    source: "#Cube"
                    position: Qt.vector3d(0, 0, sl1.value / 10)
                    scale: Qt.vector3d(0.015, 0.01, 0.01)
                    materials: PrincipledMaterial {
                        baseColorMap: Texture {
                            sourceItem: Rectangle {
                                id: cubeFace
                                width: 480; height: 480
                                color: "black"
                                Image {
                                    anchors.fill: parent
                                    anchors.margins: 20
                                    fillMode: Image.PreserveAspectFit
                                    source: "resources/qt_logo.svg"
                                }
                            }
                        }
                        emissiveFactor: Qt.vector3d(0, 0.5, 0)
                        emissiveMap: Texture {
                            sourceItem: cubeFace
                        }
                    }
                }
            }
        }

        Column {
            spacing: 20
            Slider {
                id: sl1
                orientation: Qt.Vertical
                from: 4; to: 10; value: 4.7
            }
            Switch {
                id: sw1
                checked: true
            }
        }
    }
}

// TODO show source
