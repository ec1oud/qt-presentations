import QtQuick 2.0
import QtQuick.Templates 2.0 as T
import QtQuick.Particles 2.0

T.Button {
    id: control
    text: qsTr("Button")
    implicitWidth: 100
    implicitHeight: 30

    contentItem: Text {
        id: label
        text: control.text
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "black" : "#111"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        clip: true; antialiasing: true
        border.color: control.down ? "black" : "transparent"
        radius: 4
        BorderImage {
            clip: true
            anchors.fill: parent; anchors.margins: 1
            source: "images/button-fill.png"
            border.left: 5 ; border.top: 1
            border.right: 5 ; border.bottom: 1
            ParticleSystem { id: bubbles }
            ImageParticle {
                system: bubbles
                source: "images/bubble.png"
                opacity: 0.7
            }
            Emitter {
                system: bubbles
                anchors.fill: parent
                enabled: control.down
                size: 4
                sizeVariation: 4
                acceleration: PointDirection { y: -6; xVariation: 3 }
                emitRate: 100
                lifeSpan: 3000
            }
        }
    }
}
