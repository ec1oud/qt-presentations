import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D
import "rock" as Rock


View3D {
    id: view
    width: 1920
    height: 1080
    PerspectiveCamera { position: Qt.vector3d(sl1.value * 10, sl2.value * 10, sl3.value * 10); eulerRotation.x: -30 }
    DirectionalLight { eulerRotation.x: sl4.value }

    Rock.Scene {
        scale: Qt.vector3d(5, 5, 5)
    }

    Grid {
        columns: 2
        Slider {
            id: sl1
            from: 0
            to: 10
        }
        Label {
            text: sl1.value
        }

        Slider {
            id: sl2
            from: 0
            to: 10
            value: 1
        }
        Label {
            text: sl2.value
        }

        Slider {
            id: sl3
            from: 0
            to: 10
            value: 2
        }
        Label {
            text: sl3.value
        }

        Slider {
            id: sl4
            from: -300; to: 300; value: -30
        }
        Label {
            text: sl4.value
        }
    }
}
