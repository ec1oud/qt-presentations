import QtQuick
import QtQuick.Particles
import QtQuick3D
import QtQuick3D.Helpers

View3D {
    property alias maximize: maximizeButton.checked // workaround for QTBUG-96973
    width: 1024; height: 480
    PerspectiveCamera { id: camera; z: 600 }

    DirectionalLight { }

    WasdController { z: -1; controlledObject: camera } // broken in 6.2.0 (QTBUG-96457); ok in 6.2.1

    Node {
        x: -150; y: 128; z: 380
        eulerRotation.y: (bb.sliderValue - 0.4) * 40
        BusyBox { // Root of a 2D subscene!
            id: bb
            rawSliderValue: 72
            ParticleSystem {
                anchors.fill: parent

                ItemParticle {
                    delegate: Rectangle {
                        color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
                        radius: 3; width: radius * 2; height: width
                    }
                }
                Emitter {
                    anchors.centerIn: parent
                    enabled: bb.topButtonPressed
                    emitRate: 500; lifeSpan: 2000
                    velocity: PointDirection{ yVariation: 360; xVariation: 360}
                }
            }
        }
    }

    Model {
        source: "#Cube"
        x: 100
        z: 310
        scale: Qt.vector3d(0.4, 0.4, 0.4)
        materials: DefaultMaterial {
            diffuseColor: "tomato"
        }
        pickable: true
        eulerRotation.z: 20
        PropertyAnimation on eulerRotation.y {
            from: 0
            to: 360
            duration: 5000
            running: true
            loops: Animation.Infinite
        }
    }

    Text {
        id: maximizeButton
        anchors.right: parent.right
        text: "⛶"; font.pixelSize: 32
        property bool checked: false
        color: checked ? "red" : "grey"
        TapHandler { onTapped: target.checked = !target.checked }
    }
}
