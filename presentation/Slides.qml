import Qt.labs.presentation 1.0
import QtQuick 2.8
import QtQuick.Controls 2.0

import "examples"

Presentation {
    id: presentation
    anchors.fill: parent
    mouseNavigation: false
    fontFamily: "TitilliumWeb"
    fontScale: 0.7

    width: 1920
    height: 1080

    Image {
        anchors {
            top: parent.top
            left: parent.left
        }
        height: parent.height / 6
        fillMode: Image.PreserveAspectFit
        source: "images/top-banner.png"
        visible: currentSlide === 0
        antialiasing: true
        smooth: true
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
        title: "Agenda"
        content: [
            "Introduction",
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
    }

//    ImageSlide {
//        title: "Handler hierarchy so far"
//        source: "images/pointer-handlers-classes.png"
//    }


//    TextSlide {
//        title: "Fling Animation using VelocityCalculator"
//        sourceFile: "fling-animation-with-velocity-calculator.qml"
//    }

    CustomCodeSlide {
        title: "Customizing Material Style"
        sourceFile: "examples/customizedMaterial.qml"
    }

    CustomCodeSlide {
        // TODO show the style definition instead
        title: "Custom Style"
        sourceFile: "examples/customStyle.qml"
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
<tt>ecloud</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.<br/><br/>

J P Nurmi<br/>
<tt>jp.nurmi@qt.io</tt><br/>
<tt>jpnurmi</tt> on <tt>#qt-labs</tt>, <tt>#qt-quick</tt> etc.<br/>

</html>"
    }

    SlideCounter { id: slideCounter }

    Clock { id: clock }

    Image {
        anchors {
            verticalCenter: slideCounter.verticalCenter
            right: slideCounter.left
            rightMargin: 20
        }
        height: slideCounter.height * 1.5
        fillMode: Image.PreserveAspectFit
        source: "images/bottom-logo.png"
        antialiasing: true
        smooth: true
    }

}
