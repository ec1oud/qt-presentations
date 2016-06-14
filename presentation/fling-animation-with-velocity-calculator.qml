VelocityCalculator:

class Q_AUTOTEST_EXPORT QQuickVelocityCalculator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QPointF tracking READ tracking WRITE setTracking NOTIFY trackingChanged)
    Q_PROPERTY(QVector2D velocity READ velocity NOTIFY velocityChanged)
    Q_PROPERTY(int bufferSize READ bufferSize WRITE setBufferSize NOTIFY bufferSizeChanged)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
... }

---------------------------------------------------
MomentumAnimation:

ParallelAnimation {
    id: root
    property Item target
    property int duration: 100
    property alias velocity: __vel.velocity

    onStarted: __vel.invalidate()
    property VelocityCalculator __vel: VelocityCalculator {
        id: __vel
        tracking: Qt.point(target.x, target.y)
    }
    NumberAnimation {
        id: xAnim
        target: root.target
        property: "x"
        to: target.x + __vel.velocity.x / duration
        duration: root.duration
        easing.type: Easing.OutQuad
    }
    NumberAnimation {
        id: yAnim
        target: root.target
        property: "y"
        to: target.y + __vel.velocity.y / duration
        duration: root.duration
        easing.type: Easing.OutQuad
    }
}

---------------------------------------------------
usage:

Rectangle {
    id: root
    width: 640
    height: 480
    color: "black"

    Image {
        id: ball
        source: "resources/redball.png"
        width: 80; height: 80; x: 200 + index * 200; y: 200

        MomentumAnimation { id: anim; target: ball }

        DragHandler {
            onReleased: anim.start()
        }
    }
}
