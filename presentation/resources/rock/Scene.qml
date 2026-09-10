import QtQuick
import QtQuick3D

Node {
    id: root
    objectName: "Root"

    // Resources
    Texture {
        id: textures_DefaultMaterial_baseColor_jpeg_texture
        objectName: "textures/DefaultMaterial_baseColor.jpeg"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/DefaultMaterial_baseColor.jpeg"
    }
    Texture {
        id: textures_DefaultMaterial_metallicRoughness_png_texture
        objectName: "textures/DefaultMaterial_metallicRoughness.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/DefaultMaterial_metallicRoughness.png"
    }
    Texture {
        id: textures_DefaultMaterial_normal_jpeg_texture
        objectName: "textures/DefaultMaterial_normal.jpeg"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/DefaultMaterial_normal.jpeg"
    }
    PrincipledMaterial {
        id: defaultMaterial_material
        objectName: "DefaultMaterial"
        baseColorMap: textures_DefaultMaterial_baseColor_jpeg_texture
        metalnessMap: textures_DefaultMaterial_metallicRoughness_png_texture
        roughnessMap: textures_DefaultMaterial_metallicRoughness_png_texture
        metalness: 1
        roughness: 1
        normalMap: textures_DefaultMaterial_normal_jpeg_texture
        occlusionMap: textures_DefaultMaterial_metallicRoughness_png_texture
        alphaMode: PrincipledMaterial.Opaque
    }

    // Nodes:
    Node {
        id: sketchfab_model
        objectName: "Sketchfab_model"
        rotation: Qt.quaternion(0.707107, -0.707107, 0, 0)
        Node {
            id: collada_visual_scene_group
            objectName: "Collada visual scene group"
            rotation: Qt.quaternion(0.707107, 0.707107, 0, 0)
            Node {
                id: kup_low
                objectName: "kup_low"
                Model {
                    id: defaultMaterial
                    objectName: "defaultMaterial"
                    source: "meshes/defaultMaterial_mesh.mesh"
                    materials: [
                        defaultMaterial_material
                    ]
                }
            }
        }
    }

    // Animations:
}
