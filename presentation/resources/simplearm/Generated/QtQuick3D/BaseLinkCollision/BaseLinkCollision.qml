import QtQuick
import QtQuick3D

Node {
    id: root
    objectName: "Root"

    // Resources
    PrincipledMaterial {
        id: defaultMaterial_material
        objectName: "DefaultMaterial"
    }

    // Nodes:
    Node {
        id: _STL_BINARY_
        objectName: "<STL_BINARY>"
        Model {
            id: model
            objectName: "Model"
            source: "meshes/node.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
    }

    // Animations:
}
