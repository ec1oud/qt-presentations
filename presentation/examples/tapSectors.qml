import QtQuick 2.10
import QtQuick.Shapes 1.0
import Qt.labs.handlers 1.0

Item {
    layer { enabled: true; samples: 16 } // Antialiasing
    Shape {
        containsMode: Shape.FillContains // Qt 5.11
        TapHandler { id: urTap }
        ShapePath {
            fillColor: urTap.pressed ? "steelblue" : "lightgray"
            PathSvg { path: "M75,50 l 25,0 a50,50 0 0,0 -50,-50 l 0,25 a25,25 0 0,1 25,25" }
        }
    }
    Shape {
        containsMode: Shape.FillContains
        TapHandler { id: ulTap }
        ShapePath {
            fillColor: ulTap.pressed ? "steelblue" : "lightgray"
            PathSvg { path: "M50,25 l 0,-25 a50,50 0 0,0 -50,50 l 25,0 a25,25 0 0,1 25,-25" }
        }
    }
    Shape {
        containsMode: Shape.FillContains
        TapHandler { id: lrTap }
        ShapePath {
            fillColor: lrTap.pressed ? "steelblue" : "lightgray"
            PathSvg { path: "M75,50 l 25,0 a50,50 0 0,1 -50,50 l 0,-25 a25,25 0 0,0 25,-25" }
        }
    }
    Shape {
        containsMode: Shape.FillContains
        TapHandler { id: llTap }
        ShapePath {
            fillColor: llTap.pressed ? "steelblue" : "lightgray"
            PathSvg { path: "M50,75 l 0,25 a50,50 0 0,1 -50,-50 l 25,0 a25,25 0 0,0 25,25" }
        }
    }
    width: 240; height: 200; y: 20; scale: 2; transformOrigin: Item.TopLeft
}
