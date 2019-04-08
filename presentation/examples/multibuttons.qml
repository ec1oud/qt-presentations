import QtQuick 2.14
import QtQuick.Particles 2.0
import QtQuick.Layouts 1.0


Item {
    width: 800
    height: 800
    ColumnLayout {
        anchors.right: parent.right
        spacing: 20
        Text { text: "protagonist"; font.pointSize: 12; font.weight: Font.Bold }
        MultiButton {
            id: balloonsButton
            label: "Launch Balloons"
            Layout.fillWidth: true
            gesturePolicy: TapHandler.WithinBounds
        }
        Text { text: "the goons"; font.pointSize: 12; font.weight: Font.Bold }
        MultiButton {
            id: missilesButton
            label: "Launch Missile"
            Layout.fillWidth: true
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: missileEmitter.burst(1)
        }
        MultiButton {
            id: fightersButton
            label: "Launch Fighters"
            Layout.fillWidth: true
            gesturePolicy: TapHandler.DragThreshold
        }
    }
    ParticleSystem {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 150
        ImageParticle { source: "resources/balloon.png"; rotation: 1 }
        Emitter { anchors.bottom: parent.bottom; enabled: balloonsButton.pressed; lifeSpan: 5000; size: 64
            maximumEmitted: 99
            emitRate: 50; velocity: PointDirection { x: 10; y: -150; yVariation: 30; xVariation: 50 } } }
    ParticleSystem {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        ImageParticle { source: "resources/fighter.png" }
        Emitter { anchors.bottom: parent.bottom; enabled: fightersButton.pressed; lifeSpan: 15000; size: 204
            emitRate: 3; velocity: PointDirection { x: -1000; y: -250; yVariation: 150; xVariation: 50 } } }
    ParticleSystem {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 100
        ImageParticle { source: "resources/missile.png"; autoRotation: true; rotation: 90 }
        Emitter { id: missileEmitter; anchors.bottom: parent.bottom; lifeSpan: 5000; size: 128;
            emitRate: 0; velocity: PointDirection { x: -200; y: -350; yVariation: 200; xVariation: 100 } } }
}
