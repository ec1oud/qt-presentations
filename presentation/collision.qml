import QtQuick
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Physics
import "resources/rock" as Rock
import "resources/simplearm" as Arm

Item {
    width: 1920
    height: 1080

    TextEdit {
        readOnly: true
        anchors.fill: parent
        anchors.margins: 50
        wrapMode: Text.Wrap
        textFormat: Text.MarkdownText
        font.family: fontFamily // from Slides.qml
        font.pixelSize: fontSize // from Slides.qml
        transformOrigin: Item.TopLeft
        scale: 1.5
        text: "
# Collision detection
- the arm sweeps into the rock; the rock just sits there and notices
- the rock's *visual* is a scanned mesh, its *collision* volume one plain cube
- URDF splits them the same way: detailed `<visual>`, simplified `<collision>`
- `TriggerBody` reports the overlap without blocking the kinematic arm
"
    }

    View3D {
        id: view
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 50 }
        height: parent.height / 2

        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Color
            clearColor: "#202024"
            antialiasingMode: SceneEnvironment.MSAA
        }

        PhysicsWorld {
            scene: view.scene
            gravity: Qt.vector3d(0, 0, 0) // nothing here is supposed to fall
            forceDebugDraw: shapesSwitch.checked
        }

        PerspectiveCamera { position: Qt.vector3d(6, 32, 88) }
        DirectionalLight { eulerRotation.x: -40; eulerRotation.y: -30 }

        // Generated from simple_arm.urdf: links, joints, and a convex hull
        // per link from its <collision> mesh.
        Arm.SimpleArm {
            control: Arm.SimpleArmControl {
                id: armControl
                sendTriggerReports: true // so the rock can notice the links
                shoulderLiftAngle: 1.0

                SequentialAnimation on shoulderPanAngle {
                    loops: Animation.Infinite
                    NumberAnimation { from: -0.7; to: 0.7; duration: 2500; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 0.7; to: -0.7; duration: 2500; easing.type: Easing.InOutSine }
                }
            }
        }

        // A detailed mesh to look at, wrapped in a cube for the solver to use.
        TriggerBody {
            id: rock
            position: Qt.vector3d(13, 51, 15.5)
            collisionShapes: BoxShape { id: rockShape; extents: Qt.vector3d(24, 24, 24) }

            Rock.Scene { scale: Qt.vector3d(8, 8, 8); eulerRotation.y: 35 }

            Model {
                source: "#Cube"
                scale: rockShape.extents.times(0.01)
                opacity: rock.collisionCount > 0 ? 0.6 : 0.25
                materials: PrincipledMaterial {
                    baseColor: rock.collisionCount > 0 ? "#e04a3a" : "#4ec9b0"
                    alphaMode: PrincipledMaterial.Blend
                }
            }
        }
    }

    Switch {
        id: shapesSwitch
        anchors { right: view.right; top: view.top; margins: 20 }
        text: "collision shapes"
        checked: true
        font.pixelSize: fontSize
        palette.windowText: "white"
    }
}
