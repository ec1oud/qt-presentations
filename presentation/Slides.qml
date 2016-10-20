import Qt.labs.presentation 1.0
import QtQuick 2.8
import QtQuick.Controls 2.0

import "examples"
import "diagrams"

Presentation {
    id: presentation
    anchors.fill: parent
    mouseNavigation: false
    fontFamily: "TitilliumWeb"
    fontScale: 0.7
    showNotes: true

    width: 1920
    height: 1080

    Image {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        fillMode: Image.PreserveAspectFit
        source: "images/top-banner.png"
        visible: currentSlide === 0
    }

    Slide {
        id: title
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Developing user interfaces with Qt Quick Controls 2</H1>

<H2>Qt World Summit 2016</H2>

Shawn Rutledge<br/>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.</html>"
    }

    Slide {
        title: "About me"
        content: [
            "Qt user since ~2004",
            "The Qt Company - Oslo",
            "Pointing devices: touch, Wacom tablets",
            "Linux/X11 and OS X",
            "Qt Quick Controls and Dialogs",
            "Future: maybe printing, maybe some new graphical Items, PDF, etc.",
        ]
    }

    Slide {
        title: "Agenda"
        content: [
            "Introduction",
            "Performance",
            "Behind the scenes",
            "Interesting features",
            "Styling demo",
            "Q&A"
        ]
    }

    Slide {
        title: "Introduction"
        content: [
            "What is Qt Quick?",
            " Declarative UI framework",
            " Dedicated OpenGL scenegraph",
            " Primitive building blocks"
        ]
        Image {
            source: "images/introduction-layer-cake.svg"
            anchors.right: parent.right
        }
        notes: "Qt Quick is a UI framework that enables development of user interfaces using a declarative language.

It is built on a dedicated scene graph based on OpenGL that fully utilises the GPU.

Using primitive building blocks, you can create custom, animated user interfaces with full control over every pixel.

opengl, dx12, cpu rendering"
    }

    Slide {
        title: "Introduction"
        content: [
            "What are Qt Quick Controls?",
            " High level UI building blocks such as Buttons and Sliders",
            " Use style templates or fully customize the style",
            " Rendered via the Qt Quick scene graph"
        ]
        notes: "Qt Quick Controls 2 complements Qt Quick by providing higher level templates for common UI elements such as buttons and sliders.

The template system was designed for visualising controls with a minimal amount of effort, which leads to excellent performance on any platform.

It comes with ready-made styles that fill in the templates. Examples of these styles are Google’s Material and Microsoft’s Universal designs.
"
    }

    LotsaControls {
        property bool isSlide: true
        property string notes: ""
    }

    CustomCodeSlide {
        title: "Example: network config with ConnMan"
        sourceFile: "examples/connman.qml"
    }

    Slide {
        title: "Performance comparison"
        content: [
            "Benchmarks",
            " QObject count",
            " No more Loaders, separate style objects",
            " Logic in C++, Visuals in QML",
            " QML mandatory attached objects vs C++ lazy loaded"
        ]
        Image {
            source: "images/barchart.png"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: parent.width * 0.5
            height: parent.height * 0.6
            fillMode: Image.PreserveAspectFit
        }
        BarchartObjectCount {
            width: parent.width * 0.5
            height: parent.height * 0.6
            anchors.bottom: parent.bottom
        }
        notes: "Let’s take a look at how we achieved good performance on low-end devices.

To find the bottlenecks in Qt Quick Controls 1, we wrote some benchmarks.
We saw that some controls were creating obscenely large numbers of QObjects and Items.

Slider, the amount of items and objects:
    - Qt Quick Controls 1
        - Base style: QQuickItems: 37 (total of QObjects: 114)
        - Desktop style: QQuickItems: 7 (total of QObjects: 30)
    - Qt Quick Controls 2
        - Default style: QQuickItems: 3 (total of QObjects: 4)
        - Universal style: QQuickItems: 5 (total of QObjects: 6)
        - Material style: QQuickItems: 6 (total of QObjects: 8)

Another thing that we discovered is that Loaders really ate into performance when scrolling e.g. a TableView.
We replaced the separate styling objects with a system that is much simpler and actually more flexible.
Instead of the delegates for each control being loaded dynamically, they are simply declared statically and automatically parented to the control.

We ensure that we keep the logic in C++ and the visuals in QML. Simple declarative bindings are faster than full-fledged JavaScript blocks.
In one case, we were able to reduce the creation time of a control b 30% by replacing imperative code with declarative bindings.

Controls 1 handles accessibility via attached properties, whereas Controls 2 does it in C++ conditionally, and accessibility can be disabled if appropriate.

We have used these findings to guide the development of Qt Quick Controls 2, with some of them even being enforced by CI thanks to some auto tests.
"
    }

    Slide {
        title: "Interesting features"
        content: [
            "Property inheritance/propagation",
            "Static styling system based on file selectors",
            "Run any style on any platform",
            "Possible to mix and match Controls 1 with Controls 2",
            "Custom styles have full control"
        ]
        notes: "The C++ foundation allows us to inherit style attributes from parent to children. We’ve used the same system for font and locale inheritance.

Using file selectors, we load the correct style at startup, when the first Qt Quick Controls 2 import is found by the QML engine. Besides being faster, this is not too different from Qt Quick Controls 1. However, since we add our custom selectors (material, universal) to QFileSelector, it means that you can also use these selectors in your application to provide efficiently-loaded, style-specific variants of certain parts of your UI.

Each style is 100% cross-platform. For example, you can use the Material style on an embedded Linux device like the Raspberry Pi. This also means that end users get more style options (via the -style command-line option or the env variable).

Being able to mix and match Controls 1 and 2 was one of the release/acceptance criteria. We modified the QML engine to allow importing two different major versions of the same QML namespace.

In Controls 1, the style panel (?) would determine the layout, whereas in Controls 2, you have full control over it. In Controls 1, the style object was in a separate context, which meant that you could not modify properties of the control. In Controls 2, a style for a control is the control, so it can set default values for any properties of the control.
"
    }

    CustomCodeSlide {
        title: "Customizing Material Style"
        sourceFile: "examples/customizedMaterial.qml"
    }

    CustomCodeSlide {
        title: "Custom Style"
        loaded: false
        sourceFile: "examples/customstyle/Button.qml"
        Loader {
            anchors.right: parent.right
            anchors.rightMargin: -40
            source: "examples/customStyle.qml"
        }
    }

    Slide {
        id: lastSlide
        titleColor: "white"
        centeredTextFormat: Text.RichText
        centeredText: "<html>
<H1>Developing user interfaces with Qt Quick Controls 2</H1>

<H2>Qt World Summit 2016</H2>

Shawn Rutledge<br/>
<tt>shawn.rutledge@qt.io</tt><br/>
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.<br/>
This presentation: <tt>https://github.com/ec1oud/qt-presentations/tree/controls2</tt><br/><br/>

J P Nurmi<br/>
<tt>jp.nurmi@qt.io</tt><br/>
<tt>jpnurmi</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.<br/>

</html>"
    }

    SlideCounter { id: slideCounter }

    Clock {
        anchors.top: undefined
        anchors.verticalCenter: slideCounter.verticalCenter
        anchors.right: rightLogo.left;
    }

    property bool bottomRuleVisible: currentSlide < 4 || currentSlide === presentation.slides.length - 1

    Rectangle {
        id: rule
        visible: bottomRuleVisible
        color: "#f3f3f4"; height: 5
        anchors.bottom: leftLogo.top
        anchors.left: parent.left; anchors.leftMargin: 65
        anchors.right: slideCounter.right
        anchors.bottomMargin: 16
    }

    Image {
        id: leftLogo
        visible: bottomRuleVisible
        anchors {
            verticalCenter: slideCounter.verticalCenter
            left: rule.left
            rightMargin: 20
        }
        fillMode: Image.PreserveAspectFit
        source: "images/bottom-logo-left.png"
    }

    Image {
        id: rightLogo
        anchors {
            verticalCenter: slideCounter.verticalCenter
            right: slideCounter.left
            rightMargin: 20
        }
        fillMode: Image.PreserveAspectFit
        source: "images/bottom-logo-right.png"
    }

}
