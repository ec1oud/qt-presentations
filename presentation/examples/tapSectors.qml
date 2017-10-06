import QtQuick 2.10
import QtQuick.Shapes 1.0
import Qt.labs.handlers 1.0

Item {
    width: 120; height: 100; y: 20
    Shape {
        TapHandler { id: urTap }
        ShapePath {
            fillColor: urTap.pressed ? "steelblue" : "lightgray"
            PathSvg { path: "M75,50 l 25,0 a50,50 0 0,0 -50,-50 l 0,25 a25,25 0 0,1 25,25" }
        }
    }
    Shape {
        TapHandler { id: ulTap }
        ShapePath {
            fillColor: ulTap.pressed ? "steelblue" : "lightgray"
            PathSvg { path: "M50,25 l 0,-25 a50,50 0 0,0 -50,50 l 25,0 a25,25 0 0,1 25,-25" }
        }
    }
    Shape {
        TapHandler { id: lrTap }
        ShapePath {
            fillColor: lrTap.pressed ? "steelblue" : "lightgray"
            PathSvg { path: "M75,50 l 25,0 a50,50 0 0,1 -50,50 l 0,-25 a25,25 0 0,0 25,-25" }
        }
    }
    Shape {
        TapHandler { id: llTap }
        ShapePath {
            fillColor: llTap.pressed ? "steelblue" : "lightgray"
            PathSvg { path: "M50,75 l 0,25 a50,50 0 0,1 -50,-50 l 25,0 a25,25 0 0,0 25,25" }
        }
    }
}
