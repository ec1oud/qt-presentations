/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick3D.Particles3D

View3D {
    id: view
    width: 1280; height: 720; y: 100
    camera: camera

    environment: SceneEnvironment {
        backgroundMode: SceneEnvironment.SkyBox
        lightProbe: Texture { source: "maps/OpenfootageNET_lowerAustria01-1024.hdr" }
        probeExposure: 2
    }

    DirectionalLight { eulerRotation.x: -90; shadowFactor: 100 }

    Node {
        id: character
        position: "200, 300, -50"
        eulerRotation.y: -60
        SimpleSpaceship {}
        Node {
            id: ray
            property int length: 0
            property real scaleWidth: length ? 0.07 : 0.04
            scale: Qt.vector3d(scaleWidth, scaleWidth, length ? length/100 : 50.0)
            Model {
                z: -50; eulerRotation.x: -90
                source: "#Cylinder"
                materials: DefaultMaterial { diffuseColor: ray.length ? "red" : "blue" }
                opacity: 0.5
            }
        }
        function doPick() {
            var result = view.rayPick(character.position, character.forward) // <--
            view.pickedModel = result.objectHit
            ray.length = result.distance
            psystem.emitPosition = result.scenePosition
        }
        onPositionChanged: doPick()
        onRotationChanged: doPick()
    }

    WasdController { controlledObject: character  }

    Node {
        id: cameraNode
        PerspectiveCamera {
            id: camera
            position: Qt.vector3d(0, 300, 500)
            eulerRotation.x: -15
        }
    }

    PointHandler {
        acceptedButtons: Qt.MiddleButton
        onPointChanged: cameraNode.eulerRotation.y += point.velocity.x / 2000
    }

    WheelHandler { onWheel: (event)=> camera.z = Math.min(1200, Math.max(0, camera.z - event.angleDelta.y)); }

    property real sparklesStrength: 200
    property real sparkleVelocity: 50
    property Model pickedModel: null

    function randomInRange(min, max) { return Math.random() * (max - min) + min; }

    Component {
        id: doughnutComponent

        Model {
            id: thisModel
            source: "meshes/torus.mesh"
            materials: PrincipledMaterial {
                metalness: 1.0
                roughness: 0.2
                baseColor: view.pickedModel == thisModel ? "white" : baseCol
            }

            property color baseCol: Qt.hsla(randomInRange(0, 1), 0.5, 0.5, 1.0)

            eulerRotation: Qt.vector3d(randomInRange(0, 360),
                                       randomInRange(0, 360),
                                       randomInRange(0, 360))

            position: Qt.vector3d(randomInRange(-1200, 1200),
                                  randomInRange( -300, 200),
                                  randomInRange(-1200, 1200))
            property real sf: randomInRange(0.5, 1)
            scale: Qt.vector3d(sf, sf, sf)
            pickable: true
        }
    }

    Repeater3D {
        model: 400
        delegate: doughnutComponent
    }

    ParticleSystem3D {
        id: psystem

        property alias emitPosition: sparklesEmitter.position

        SpriteParticle3D {
            id: particleSparkle
            sprite: Texture { source: "maps/sphere.png" }
            colorTable: Texture { source: "maps/color_table3.png" }
            maxAmount: 400
            colorVariation: Qt.vector4d(0.0, 0.0, 0.0, 0.4)
            blendMode: SpriteParticle3D.Screen
        }

        ParticleEmitter3D {
            id: sparklesEmitter
            particle: particleSparkle
            enabled: view.pickedModel != null
            particleScale: 1
            particleEndScale: 0
            particleScaleVariation: 0.5
            particleRotationVariation: Qt.vector3d(180, 180, 0)
            particleRotationVelocityVariation: Qt.vector3d(400, 400, 0)
            velocity: VectorDirection3D {
                direction: Qt.vector3d(0, 0, 0)
                directionVariation: Qt.vector3d(sparkleVelocity, sparkleVelocity, sparkleVelocity)
            }
            emitRate: sparklesStrength * 4 //emitting ? sparklesStrength * 4 : 0
            lifeSpan: 500
            lifeSpanVariation: 500
        }

        Gravity3D {
            particles: particleSparkle
            magnitude: 20
        }
    }
}
