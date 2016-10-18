import QtQuick 2.0
import QtQuick.Templates 2.0 as T
import QtQuick.Particles 2.0
import QtGraphicalEffects 1.0

T.Button {
    id: control
    implicitWidth: 200; implicitHeight: 100
    hoverEnabled: true

    contentItem: Text {
        text: control.text
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "black" : "charcoal"
        font { family: "WindsorDemi"; pointSize: 36 }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: RectangularGlow {
        cornerRadius: 8
        glowRadius: 20
        color: control.hovered ? "green" : "white"
        Rectangle {
            anchors.fill: parent; clip: true; antialiasing: true; radius: 4; border.width: 3
            color: "transparent"; border.color: control.down ? "black" : "transparent"
            BorderImage {
                clip: true
                anchors.fill: parent; anchors.margins: 2
                source: "images/button-fill.png"
                border { left: 5; top: 1; right: 5; bottom: 1 }
                ParticleSystem { id: bubbles }
                ImageParticle {
                    system: bubbles; source: "images/bubble.png"; opacity: 0.5
                }
                Emitter {
                    system: bubbles
                    anchors.fill: parent
                    enabled: control.down
                    size: 12; sizeVariation: 8
                    acceleration: PointDirection { y: -6; xVariation: 3 }
                    emitRate: 20; lifeSpan: 3000
                }
            }
        }
    }
}
