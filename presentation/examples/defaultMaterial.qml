import QtQuick
import QtQuick3D

View3D {
    width: 1024; height: 480

    DirectionalLight { eulerRotation.y: 90 }
    DirectionalLight { eulerRotation.y: -45 }
    PerspectiveCamera { z: 600 }

    Node {
        objectName: "left object"
        x: -120; z: 400
        eulerRotation.x: -15
        eulerRotation.y: 10
        Model {
            source: "#Cube"
            pickable: true // <-- important!
            materials: DefaultMaterial {
                diffuseMap: Texture {
                    sourceItem: BusyBox {
                        id: leftBusybox
                        x: 20 - width
                        layer.enabled: true // to make a Texture available
                        layer.textureSize: Qt.size(512, 512) // <-- suitable resolution
                    }
                }
            }
        }
    }

    Node {
        objectName: "right object"
        x: 120; z: 400
        eulerRotation: "35, 5, 0"
        Model {
            source: "#Cube"
            pickable: true
            materials: DefaultMaterial {
                diffuseMap: Texture {
                    sourceItem: leftBusybox // <-- shared source
                }
            }
        }
    }
}
