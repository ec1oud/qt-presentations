import QtQuick 2.0
import QtQuick.Particles 2.0
import QtQuick.Layouts 1.0

Item {
    width: 800
    height: 800
    ColumnLayout {
        anchors.right: parent.right
        spacing: 20
        MultiButton {
            id: balloonsButton
            label: "Launch Balloons"
            Layout.fillWidth: true
        }
        MultiButton {
            id: missilesButton
            label: "Launch Missiles"
            Layout.fillWidth: true
        }
        MultiButton {
            id: fightersButton
            label: "Launch Fighters"
            Layout.fillWidth: true
        }
    }
    ParticleSystem {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 150
        ImageParticle { source: "images/balloon.png" }
        Emitter { anchors.bottom: parent.bottom; enabled: balloonsButton.pressed; lifeSpan: 5000; size: 64
            emitRate: 50; velocity: PointDirection { x: 10; y: -150; yVariation: 30; xVariation: 50 } } }
    ParticleSystem {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        ImageParticle { source: "images/fighter.png" }
        Emitter { anchors.bottom: parent.bottom; enabled: fightersButton.pressed; lifeSpan: 15000; size: 204
            emitRate: 3; velocity: PointDirection { x: -1000; y: -250; yVariation: 150; xVariation: 50 } } }
    ParticleSystem {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 100
        ImageParticle { source: "images/missile.png"; autoRotation: true; rotation: 90 }
        Emitter { anchors.bottom: parent.bottom; enabled: missilesButton.pressed; lifeSpan: 5000; size: 128
            emitRate: 10; velocity: PointDirection { x: -200; y: -350; yVariation: 200; xVariation: 100 } } }
}
