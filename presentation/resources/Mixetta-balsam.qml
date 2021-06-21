import QtQuick
import QtQuick3D
Node {
    id: rOOT
    Node {
        id: rootNode__gltf_orientation_matrix_
        rotation: Qt.quaternion(0.707107, -0.707107, 0, 0)
        scale.y: 1
        scale.z: 1
        Node {
            id: rootNode__model_correction_matrix_
            Node {
                id: node463675e99e1740ef83f79fe666570999_fbx
                rotation: Qt.quaternion(0.707107, 0.707107, 0, 0)
                scale.y: 1
                scale.z: 1
                Node {
                    id: rootNode
                    Node {
                        id: rodec_Mixetta
                        rotation: Qt.quaternion(0.707107, -0.707107, 0, 0)
                        scale.x: 100
                        scale.y: 100
                        scale.z: 100
                        Model {
                            id: rodec_Mixetta_Rodec_Casing_0
                            source: "meshes/rodec_Mixetta_Rodec_Casing_0.mesh"

                            PrincipledMaterial {
                                id: rodec_Casing_material
                                baseColorMap: Texture {
                                    source: "maps/Rodec_Casing_Aniso_baseColor.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                opacityChannel: Material.A
                                metalnessMap: Texture {
                                    source: "maps/Rodec_Casing_Aniso_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                metalnessChannel: Material.B
                                roughnessMap: Texture {
                                    source: "maps/Rodec_Casing_Aniso_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                roughnessChannel: Material.G
                                metalness: 1
                                roughness: 1
                                normalMap: Texture {
                                    source: "maps/Rodec_Casing_Aniso_normal.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                occlusionMap: Texture {
                                    source: "maps/Rodec_Casing_Aniso_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                occlusionChannel: Material.R
                                cullMode: Material.NoCulling
                                alphaMode: PrincipledMaterial.Opaque
                            }
                            materials: [
                                rodec_Casing_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Casing_Aniso_0
                            source: "meshes/rodec_Mixetta_Rodec_Casing_Aniso_0.mesh"

                            PrincipledMaterial {
                                id: rodec_Casing_Aniso_material
                                baseColorMap: Texture {
                                    source: "maps/Rodec_Casing_Aniso_baseColor.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                opacityChannel: Material.A
                                metalnessMap: Texture {
                                    source: "maps/Rodec_Casing_Aniso_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                metalnessChannel: Material.B
                                roughnessMap: Texture {
                                    source: "maps/Rodec_Casing_Aniso_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                roughnessChannel: Material.G
                                metalness: 1
                                roughness: 1
                                normalMap: Texture {
                                    source: "maps/Rodec_Casing_Aniso_normal.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                occlusionMap: Texture {
                                    source: "maps/Rodec_Casing_Aniso_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                occlusionChannel: Material.R
                                cullMode: Material.NoCulling
                                alphaMode: PrincipledMaterial.Opaque
                            }
                            materials: [
                                rodec_Casing_Aniso_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Aniso_Level
                            x: 0.0855515
                            y: -0.0758887
                            z: 0.019
                            rotation: Qt.quaternion(0.537937, 0, 0, -0.842985)
                            scale.x: 1
                            scale.y: 1
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Aniso_Level.mesh"

                            PrincipledMaterial {
                                id: rodec_Knobs_Aniso_material
                                baseColorMap: Texture {
                                    source: "maps/Rodec_Knobs_baseColor.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                opacityChannel: Material.A
                                metalnessMap: Texture {
                                    source: "maps/Rodec_Knobs_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                metalnessChannel: Material.B
                                roughnessMap: Texture {
                                    source: "maps/Rodec_Knobs_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                roughnessChannel: Material.G
                                metalness: 1
                                roughness: 1
                                normalMap: Texture {
                                    source: "maps/Rodec_Knobs_normal.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                occlusionMap: Texture {
                                    source: "maps/Rodec_Knobs_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                occlusionChannel: Material.R
                                cullMode: Material.NoCulling
                                alphaMode: PrincipledMaterial.Opaque
                            }
                            materials: [
                                rodec_Knobs_Aniso_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Aniso_MicroBass
                            x: 0.160732
                            y: -0.0208635
                            z: 0.019
                            rotation: Qt.quaternion(0.969134, 0, 0, 0.246536)
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Aniso_MicroBass.mesh"
                            materials: [
                                rodec_Knobs_Aniso_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Aniso_MicroLine
                            x: -0.081466
                            y: 0.0231433
                            z: 0.0188349
                            rotation: Qt.quaternion(-0.225125, 0, 0, 0.97433)
                            scale.x: 1
                            scale.y: 1
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Aniso_MicroLine.mesh"
                            materials: [
                                rodec_Knobs_Aniso_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Aniso_Phono1
                            x: -0.181457
                            y: 0.0231388
                            z: 0.0188349
                            rotation: Qt.quaternion(-0.218043, 0, 0, 0.975939)
                            scale.x: 1
                            scale.y: 1
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Aniso_Phono1.mesh"
                            materials: [
                                rodec_Knobs_Aniso_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Aniso_Phono2
                            x: -0.131464
                            y: 0.0232172
                            z: 0.0188349
                            rotation: Qt.quaternion(0.61635, 0, 0, -0.787472)
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Aniso_Phono2.mesh"
                            materials: [
                                rodec_Knobs_Aniso_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Aniso_Power
                            x: 0.160396
                            y: -0.0763736
                            z: 0.019
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Aniso_Power.mesh"
                            materials: [
                                rodec_Knobs_Aniso_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Aniso_Selector
                            x: 0.085511
                            y: -0.0213978
                            z: 0.019
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Aniso_Selector.mesh"
                            materials: [
                                rodec_Knobs_Aniso_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Aniso_Tape1
                            x: -0.0313092
                            y: 0.0231196
                            z: 0.0188349
                            rotation: Qt.quaternion(0.6984, 0, 0, 0.715707)
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Aniso_Tape1.mesh"
                            materials: [
                                rodec_Knobs_Aniso_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Aniso_Tape2
                            x: 0.0185902
                            y: 0.0230919
                            z: 0.0188349
                            rotation: Qt.quaternion(0.132542, 0, 0, 0.991177)
                            scale.x: 1
                            scale.y: 1
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Aniso_Tape2.mesh"
                            materials: [
                                rodec_Knobs_Aniso_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Level
                            x: 0.0852899
                            y: -0.076235
                            z: 0.0110243
                            rotation: Qt.quaternion(0.537937, 0, 0, -0.842985)
                            scale.x: 1
                            scale.y: 1
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Level.mesh"

                            PrincipledMaterial {
                                id: rodec_Knobs_material
                                baseColorMap: Texture {
                                    source: "maps/Rodec_Knobs_baseColor.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                opacityChannel: Material.A
                                metalnessMap: Texture {
                                    source: "maps/Rodec_Knobs_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                metalnessChannel: Material.B
                                roughnessMap: Texture {
                                    source: "maps/Rodec_Knobs_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                roughnessChannel: Material.G
                                metalness: 1
                                roughness: 1
                                normalMap: Texture {
                                    source: "maps/Rodec_Knobs_normal.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                occlusionMap: Texture {
                                    source: "maps/Rodec_Knobs_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                occlusionChannel: Material.R
                                cullMode: Material.NoCulling
                                alphaMode: PrincipledMaterial.Opaque
                            }
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_MicroBass
                            x: 0.160479
                            y: -0.021216
                            z: 0.0110243
                            rotation: Qt.quaternion(0.969134, 0, 0, 0.246536)
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_MicroBass.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_MicroLine
                            x: -0.0817241
                            y: 0.0227848
                            z: 0.0112006
                            rotation: Qt.quaternion(-0.225125, 0, 0, 0.97433)
                            scale.x: 1
                            scale.y: 1
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_MicroLine.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Phono1
                            x: -0.181736
                            y: 0.0227965
                            z: 0.0112006
                            rotation: Qt.quaternion(-0.218043, 0, 0, 0.975939)
                            scale.x: 1
                            scale.y: 1
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Phono1.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Phono2
                            x: -0.131733
                            y: 0.0228667
                            z: 0.0112006
                            rotation: Qt.quaternion(0.61635, 0, 0, -0.787472)
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Phono2.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Power
                            x: 0.160562
                            y: -0.075973
                            z: 0.0110243
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Power.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Selector
                            x: 0.085519
                            y: -0.020964
                            z: 0.0110243
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Selector.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Tape1
                            x: -0.0315879
                            y: 0.0227769
                            z: 0.0112006
                            rotation: Qt.quaternion(0.6984, 0, 0, 0.715707)
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Tape1.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Knobs_Tape2
                            x: 0.0182986
                            y: 0.0227602
                            z: 0.0112006
                            rotation: Qt.quaternion(0.132542, 0, 0, 0.991177)
                            scale.x: 1
                            scale.y: 1
                            source: "meshes/rodec_Mixetta_Rodec_Knobs_Tape2.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Needle_Left
                            x: 0.0827238
                            y: 0.0295795
                            z: -0.00225275
                            source: "meshes/rodec_Mixetta_Rodec_Needle_Left.mesh"

                            PrincipledMaterial {
                                id: rodec_Needle_material
                                baseColorMap: Texture {
                                    source: "maps/Rodec_Needle_baseColor.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                opacityChannel: Material.A
                                metalnessMap: Texture {
                                    source: "maps/Rodec_Needle_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                metalnessChannel: Material.B
                                roughnessMap: Texture {
                                    source: "maps/Rodec_Needle_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                roughnessChannel: Material.G
                                metalness: 1
                                roughness: 1
                                normalMap: Texture {
                                    source: "maps/Rodec_Needle_normal.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                cullMode: Material.NoCulling
                                alphaMode: PrincipledMaterial.Mask
                                alphaCutoff: 1
                            }
                            materials: [
                                rodec_Needle_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Needle_Right
                            x: 0.162724
                            y: 0.0295795
                            z: -0.00225275
                            source: "meshes/rodec_Mixetta_Rodec_Needle_Right.mesh"
                            materials: [
                                rodec_Needle_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Parts
                            source: "meshes/rodec_Mixetta_Rodec_Parts.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Slider_MicroLine
                            y: -0.0575869
                            source: "meshes/rodec_Mixetta_Rodec_Slider_MicroLine.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Slider_Phono1
                            y: -0.0554197
                            source: "meshes/rodec_Mixetta_Rodec_Slider_Phono1.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Slider_Phono2
                            y: -0.0647678
                            source: "meshes/rodec_Mixetta_Rodec_Slider_Phono2.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Slider_Tape1
                            y: -0.0667343
                            source: "meshes/rodec_Mixetta_Rodec_Slider_Tape1.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Slider_Tape2
                            y: -0.066837
                            source: "meshes/rodec_Mixetta_Rodec_Slider_Tape2.mesh"
                            materials: [
                                rodec_Knobs_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Stereo_Switch
                            source: "meshes/rodec_Mixetta_Rodec_Stereo_Switch.mesh"
                            materials: [
                                rodec_Knobs_Aniso_material
                            ]
                        }
                        Model {
                            id: rodec_Mixetta_Rodec_Trans_0
                            source: "meshes/rodec_Mixetta_Rodec_Trans_0.mesh"

                            PrincipledMaterial {
                                id: rodec_Trans_material
                                baseColorMap: Texture {
                                    source: "maps/Rodec_Trans_baseColor.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                opacityChannel: Material.A
                                metalnessMap: Texture {
                                    source: "maps/Rodec_Trans_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                metalnessChannel: Material.B
                                roughnessMap: Texture {
                                    source: "maps/Rodec_Trans_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                roughnessChannel: Material.G
                                metalness: 1
                                roughness: 1
                                normalMap: Texture {
                                    source: "maps/Rodec_Trans_normal.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                occlusionMap: Texture {
                                    source: "maps/Rodec_Trans_metallicRoughness.png"
                                    generateMipmaps: true
                                    mipFilter: Texture.Linear
                                }
                                occlusionChannel: Material.R
                                cullMode: Material.NoCulling
                                alphaMode: PrincipledMaterial.Blend
                            }
                            materials: [
                                rodec_Trans_material
                            ]
                        }
                    }
                }
            }
        }
    }
}
