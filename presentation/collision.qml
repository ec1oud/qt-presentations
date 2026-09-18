import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal
import QtQuick3D
import QtQuick3D.Physics
import "resources/rock" as Rock
import "resources/simplearm" as Arm

Rectangle {
    width: 280 * slideScale
    height: 640 * slideScale
    color: "#CCFFFFFF"

    View3D {
        // Generated from simple_arm.urdf: links, joints, collision volumes
        Arm.SimpleArm {
            control: Arm.SimpleArmControl {
                sendTriggerReports: true // so the rock can notice
                shoulderPanAngle: 0.5

                SequentialAnimation on shoulderLiftAngle {
                    loops: Animation.Infinite
                    NumberAnimation { from: 2; to: 2.5; duration: 1500
                                      easing.type: Easing.InOutSine }
                    NumberAnimation { from: 2.5; to: 2; duration: 1500
                                      easing.type: Easing.InOutSine }
                }
            }
        }

        TriggerBody {
            id: rock
            position: Qt.vector3d(13, 10, 20)
            collisionShapes: BoxShape { id: rockShape; extents: Qt.vector3d(16, 16, 16) }

            Rock.Scene { scale: Qt.vector3d(8, 8, 8) }

            Model {
                source: "#Cube"
                scale: rockShape.extents.times(0.01)
                opacity: rock.collisionCount > 0 ? 0.6 : 0
                materials: PrincipledMaterial {
                    baseColor: rock.collisionCount > 0 ? "tomato" : "black"
                    alphaMode: PrincipledMaterial.Blend
                }
            }
        }

        PhysicsWorld {
            scene: view.scene
            gravity: Qt.vector3d(0, 0, 0) // nothing here is supposed to fall
            forceDebugDraw: rock.collisionCount > 0
        }

        Text { x: 10; y: 10; color: "white"; text: `${rock.collisionCount} collisions}` }

        PerspectiveCamera { id: cam; position: "-70, 30, 40" ; eulerRotation: "0, -70, 0" }
        DirectionalLight { eulerRotation.x: -40; eulerRotation.y: -30 }

        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Color
            clearColor: "#202024"
            antialiasingMode: SceneEnvironment.MSAA
        }

        id: view
        height: parent.height / 2; y: height; width: parent.width
    }

    TextEdit {
        readOnly: true
        anchors.fill: parent
        wrapMode: Text.Wrap
        textFormat: Text.MarkdownText
        font.family: fontFamily // from Slides.qml
        font.pixelSize: fontSize * 0.6
        transformOrigin: Item.TopRight
        text: "
# Collision detection
- arm moves; rock notices collision
- rock's *visual* is a scanned mesh, *collision* volume is one cube
- URDF arm components have detailed `<visual>`, simplified `<collision>`
- `TriggerBody` reports overlap
"
    }
}
