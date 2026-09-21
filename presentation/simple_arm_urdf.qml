import QtQuick
import QtQuick3D
import "resources/simplearm" as Arm

Item {
    Flickable {
        id: flick
        anchors.fill: parent

        contentWidth: Math.max(textEdit.contentWidth, flick.width)
        contentHeight: Math.max(textEdit.contentHeight, flick.height)

        leftMargin: 40
        topMargin: 40

        TextEdit {
            id: textEdit
            readOnly: true
            textFormat: TextEdit.RichText
            textDocument.source: "simple_arm_urdf.html"
            font.pixelSize: fontSize // from Slides.qml
            font.family: fontFamily
        }
    }

    View3D {
        // Generated from simple_arm.urdf: links, joints, collision volumes
        Arm.SimpleArm {
            control: Arm.SimpleArmControl {

                SequentialAnimation on shoulderLiftAngle {
                    // loops: Animation.Infinite
                    loops: 3
                    NumberAnimation { from: 0.5; to: 1.5; duration: 1500
                                      easing.type: Easing.InOutSine }
                    NumberAnimation { from: 1.5; to: 0.5; duration: 1500
                                      easing.type: Easing.InOutSine }
                }
                SequentialAnimation on shoulderPanAngle {
                    loops: 3
                    NumberAnimation { from: 0; to: 0.5; duration: 2000
                        easing.type: Easing.InOutSine }
                    NumberAnimation { from: 0.5; to: 0; duration: 2000
                        easing.type: Easing.InOutSine }
                }
            }
        }

        PerspectiveCamera { id: cam; position: "-70, 30, 40" ; eulerRotation: "0, -65, 0" }
        DirectionalLight { eulerRotation.x: -40; eulerRotation.y: -30 }

        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Color
            clearColor: "transparent"
            antialiasingMode: SceneEnvironment.MSAA
        }

        id: view
        anchors.right: parent.right;  anchors.margins: 40
        height: parent.height; width: parent.width / 3
    }
}
