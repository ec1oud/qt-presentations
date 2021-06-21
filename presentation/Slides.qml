import Qt.labs.presentation 1.0
import QtQuick 2.15

import "examples"

Presentation {
    id: presentation
    anchors.fill: parent
    mouseNavigation: false
    fontFamily: "TitilliumWeb"
    codeFontFamily: "Source Code Pro"
    fontScale: 0.7
    titleMargin: 30

    width: 1920
    height: 1080

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }

    Image {
        anchors.fill: parent
        sourceSize.width: 1920
        fillMode: Image.PreserveAspectFit
        source: "./resources/1920x1080-akademy.png"
        currentFrame: Math.min(currentSlide, frameCount - 1)
        visible: currentSlide > 0
        smooth: true
    }

    Slide {
        id: title
        textColor: "#a2d3da"
        titleColor: "#bd9f8b"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Interactive UIs in Qt Quick 3D</H1>
Shawn Rutledge<br/>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.<br/><br/>
<tt>https://github.com/ec1oud/qtquick3d-input-demo</tt><br/>
<tt>https://github.com/ec1oud/qt-presentations : qtquick3d-interactive-ui</tt> branch<br/>
</html>"
        Rectangle {
            anchors.fill: parent
            color: "#1c1711"
            z: -1
            Image {
                source: "resources/bottom-logo-right.jpg"
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }

    Slide {
        title: "About me"
        content: [
            "Qt user since ~2004",
            "The Qt Company - Oslo since 2011",
            "Pointing devices: touch, Wacom tablets",
            "Event delivery and handlers in Qt Quick",
            "Linux/X11, Wayland, and macOS",
            "QtPDF",
            "Qt Quick, Controls and Dialogs",
        ]
    }

    Slide {
        title: "Agenda"
        bulletSpacing: 0.6
        content: [
            "Intro",
            "Fixed content in 3D apps",
            "3D content in 2D apps",
            "2D content in 3D apps",
            "Interactive 3D apps",
            "Event delivery details",
            "Remaining work",
            "Q&A"
        ]

        Image {
            source: "resources/konqi-chart.png"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 100
        }
    }

    Slide {
        title: "Disclaimers"
        bulletSpacing: 0.6
        content: [
            "I didn't implement Qt Quick 3D, only event delivery",
            "This presentation contains features we haven't shipped"
        ]
    }

    Slide {
        title: "Intro"
        bulletSpacing: 0.6
        content: [
            "What is a 3D interactive application?",
            "What sort of applications need 3D?"
        ]
    }

    QmlSlide {
        title: "Minimal Model Viewer"
        sourceFile: "examples/modelViewer.qml"
        verticalMargin: 80
    }

    ImageSlide {
        title: "Most-common QML Types"
        autoScale: true
        source: Qt.resolvedUrl("resources/qq3d-classes.png")
    }

    ImageSlide {
        title: "Design Tools Workflow"
        autoScale: true
        source: Qt.resolvedUrl("resources/qq3d-tool-workflow.svg")
    }

    QmlSlide {
        title: "2D content in a 3D app: Item2D"
        sourceFile: "examples/item2d.qml"
        verticalMargin: 80
    }

    QmlSlide {
        title: "Materials with shared Textures"
        sourceFile: "examples/defaultMaterial.qml"
        verticalMargin: 80
    }

    QmlSlide {
        title: "Virtual Screen on a Model"
        sourceFile: "examples/qtquick3d-input-demo/digital-assistant/scene.qml"
        verticalMargin: 80
    }

    QmlSlide {
        title: "Interactive 3D app"
        sourceFile: "examples/qtquick3d-input-demo/mixer/view.qml"
        verticalMargin: 80
    }

    Slide {
        title: "Preparing third-party GLTF for QQ3D"
        bulletSpacing: 0.6
        content: [
            "Download something interesting (http://skfb.ly/ etc.)",
            "Import into Blender",
            "Split meshes of interactive elements into separate objects",
            "Set origins of rotable elements to centers",
            "Set 3D cursor to origin",
            "Move/rotate interactive controls to 'zero'",
            "Re-export to gltf / glb",
            "$ balsam myfile.glb",
            "write a QML viewer and look at Myfile.qml in it"
        ]
    }

    ImageSlide {
        title: "Blender: lasso vertices, select linked vertices"
        autoScale: true
        source: Qt.resolvedUrl("resources/blender-select-linked.png")
    }

    ImageSlide {
        title: "Blender: set origin"
        autoScale: true
        source: Qt.resolvedUrl("resources/blender-set-origin.png")
    }

    ImageSlide {
        title: "Blender: rotate an object"
        autoScale: true
        source: Qt.resolvedUrl("resources/blender-rotate-object.png")
    }

    CustomCodeSlide {
        title: "Balsam output"
        sourceFile: "resources/Mixetta-balsam.qml"
    }

    Slide {
        title: "Make Balsam output interactive"
        bulletSpacing: 0.6
        content: [
            "Simplify the QML (reduce nesting etc.)",
            "Rotatable element? convert quaternion to Euler angles",
            " QQuaternion::toEulerAngles()",
            "Make Models pickable",
            "Add handlers to them",
            "Make bindings to rotate, drag etc.",
            " DragHandler.persistentTranslation",
            " WheelHandler.rotation",
            " TapHandler.pressed",
            " PinchHandler.scale",
            " PinchHandler.persistentTranslation is missing so far"
        ]
        Image {
            source: "resources/quaternion-converter.png"
            width: 447 * 2
            height: 116 * 2
            sourceSize.width: width
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 400
            anchors.topMargin: 550
        }
    }

    CustomCodeSlide {
        title: "Rigging Balsam output"
        sourceFile: "resources/mixetta.diff"
    }

    QmlSlide {
        title: "Ray Picking"
        sourceFile: "examples/rayPicking.qml"
        horizontalMargin: 100
    }

    Slide {
        title: "Stuff left to work on"
        textFormat: Text.StyledText
        bulletSpacing: 0.6
        content: [
            "Ensure that we can really use handlers in 3D",
            "Hover bugs",
            "WasdController stealing events",
            "Controls stealing events"
        ]
    }

    Slide {
        title: "Suggestions for the community"
        textFormat: Text.StyledText
        bulletSpacing: 0.6
        content: [
            "Play with it!",
            "Imagine new use cases",
            "Design standard toolbar icons for 3D applications"
        ]
    }

    Slide {
        id: lastSlide
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Interactive UIs in Qt Quick 3D</H1>
Shawn Rutledge<br/>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.<br/><br/>
<tt>https://github.com/ec1oud/qtquick3d-input-demo</tt><br/>
<tt>https://github.com/ec1oud/qt-presentations : qtquick3d-interactive-ui</tt> branch<br/>
</html>"
    }

    SlideCounter { id: slideCounter; visible: currentSlide > 0 }

    property bool bottomStuffVisible: currentSlide < 4

    Image {
        id: leftLogo
        visible: bottomStuffVisible
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: 20
        }
        height: 78 * parent.height / 1080
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "resources/bottom-logo-left.png"
    }
}
