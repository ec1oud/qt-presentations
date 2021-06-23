import QtQuick
import QtQuick3D

View3D {

    Node {
        id: sphere
        x: dh.persistentTranslation.x - 120
        y: -dh.persistentTranslation.y
        z: 400
        Model {
            source: "#Sphere"
            pickable: true
            materials: DefaultMaterial {
                diffuseColor: sth.pressed ? "blue" : shh.hovered ? "lightsteelblue" : "beige"
            }
            TapHandler { id: sth }
            HoverHandler { id: shh }
            DragHandler { id: dh }
        }
    }

    Node {
        position: shh.point.worldPosition // <-- new HandlerPoint property
        visible: !dh.active
        Model {
            source: "#Sphere"
            materials: DefaultMaterial { diffuseColor: "blue" }
            scale: "0.1, 0.1, 0.1"
        }
    }

    Model {
        x: 120; z: 400
        source: "#Cube"
        pickable: true
        scale: Qt.vector3d(ph.scale, ph.scale, ph.scale)
        eulerRotation: Qt.vector3d(ph.translation.y - 25, ph.rotation + 5, 15 - ph.translation.x)
        materials: DefaultMaterial { diffuseColor: cth.pressed ? "tomato" : chh.hovered ? "goldenrod" : "wheat" }
        TapHandler { id: cth }
        HoverHandler { id: chh }
        PinchHandler {
            id: ph
            minimumScale: 0.5
            maximumScale: 2.5
        }
        Model {
            position: chh.point.modelPosition // <-- new HandlerPoint property
            source: "#Sphere"
            materials: DefaultMaterial { diffuseColor: "green" }
            scale: "0.1, 0.1, 0.1"
        }
    }

    Text {
        id: sphereLabel
        anchors.bottom: parent.bottom
        text: "model " + shh.point.modelPosition + "\nworld " + shh.point.worldPosition +
              "\ndrag " + dh.translation + "\nsphere @" + sphere.position
    }
    Text {
        id: cubeLabel
        anchors.bottom: parent.bottom
        x: parent.width / 2 + 3
        text: "UV " + chh.point.position + "\nmodel " + chh.point.modelPosition + "\nworld " + chh.point.worldPosition +
              "\npinch " + ph.scale.toFixed(2) + "x, " + ph.rotation.toFixed(1) + "°"
    }

    width: 1024; height: 480
    PerspectiveCamera { z: 600 }
    DirectionalLight { }
}
