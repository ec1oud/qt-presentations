import QtQuick
import QtQuick.Dialogs

import Qt.labs.settings

import QtQuick3D
import QtQuick3D.Helpers
import QtQuick3D.AssetUtils

View3D {
    id: view3D; width: 2048; height: 2048; y: 100

//    environment: SceneEnvironment { backgroundMode: SceneEnvironment.Color; clearColor: "#333" }
    DirectionalLight { }
    DirectionalLight { eulerRotation.x: 180 }
    PerspectiveCamera { id: camera }

    RuntimeLoader {
        id: loader
        property real sf: Math.pow(1.1, wheelHandler.rotation / 15)
        scale: Qt.vector3d(sf, sf, sf)
        x: dragHandler.persistentTranslation.x
        y: dragHandler.persistentTranslation.y

        AxisHelper { id: axes; scale: Qt.vector3d(0.1, 0.1, 0.1) }

        Model {
            id: boundRP; source: "#Cube"
            materials: PrincipledMaterial { baseColor: "lightgreen" } opacity: 0.3
            visible: axes.visible && loader.status === RuntimeLoader.Success
            position: Qt.vector3d((loader.bounds.maximum.x + loader.bounds.minimum.x) / 2,
                                  (loader.bounds.maximum.y + loader.bounds.minimum.y) / 2,
                                  (loader.bounds.maximum.z + loader.bounds.minimum.z) / 2 )
            scale: Qt.vector3d((loader.bounds.maximum.x - loader.bounds.minimum.x) / 100,
                               (loader.bounds.maximum.y - loader.bounds.minimum.y) / 100,
                               (loader.bounds.maximum.z - loader.bounds.minimum.z) / 100)
        }
    }

    WheelHandler { id: wheelHandler }
    DragHandler { id: dragHandler; target: null; acceptedButtons: Qt.MiddleButton }
    WasdController { controlledObject: camera }

    function resetView() {
        camera.position = "0, 150, 400"
        camera.eulerRotation = "-15, 0, 0"
        loader.eulerRotation = "0, -45, 0"
        loader.position = Qt.vector3d(-boundRP.position.x * loader.sf, -boundRP.position.y * loader.sf, -boundRP.position.z * loader.sf)
        wheelHandler.rotation = 0
    }
    Component.onCompleted: resetView()

    Row {
        x: 6; y: 6

        Image {
            source: "resources/folder-open.png"
            TapHandler { onTapped: fileDialog.open() }
        }
        Image {
            source: "resources/view-refresh.png"
            TapHandler { onTapped: view3D.resetView() }
        }
        Image {
            width: 32; height: 32; opacity: axes.visible ? 1 : 0.5
            source: "resources/noun_3D_2353959.svg"
            TapHandler { onTapped: axes.visible = !axes.visible }
        }
    }

    FileDialog {
        id: fileDialog; title: "3D model to open"
        nameFilters: ["glTF files (*.gltf *.glb)", "STL files (*.stl)", "All files (*)"]
        onAccepted: loader.source = currentFile
        Settings {
            category: "QtQuick3D.Examples.RuntimeLoader"
            property alias folder: fileDialog.currentFolder
        }
    }
}
