
import QtQuick 2.0
import QtMultimedia 5
import Qt.labs.presentation 1.0

Rectangle {
    anchors.fill: parent
    property bool isSlide: true
    id: slide
    visible: false

    Camera {
         id: camera
         Component.onCompleted: camera.stop();
     }

     VideoOutput {
         id: videoOut
         anchors.fill: parent
         source: camera
         layer.enabled: true;
     }

     onVisibleChanged: {
         if (slide.visible)
             camera.start();
         else
             camera.stop();
     }
}

