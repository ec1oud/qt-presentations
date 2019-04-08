import QtQuick 2.14
import QtQuick.Window 2.3

import "resources"

Window {
    id: root
    width: 1280
    height: 720
    visible: true
    property alias currentSlide: slides.currentSlide

    Item {
        id: glassPane
        objectName: "glassPane"
        z: 10000
        anchors.fill: parent

        TouchpointFeedbackSprite { }
        TouchpointFeedbackSprite { }
        TouchpointFeedbackSprite { }
        TouchpointFeedbackSprite { }
        TouchpointFeedbackSprite { }
        TouchpointFeedbackSprite { }

        MouseFeedbackSprite { }
    }

    Slides {
        id: slides
    }

    Shortcut {
        sequence: "Ctrl+Shift+F"
        onActivated: root.visibility = (root.visibility != Window.FullScreen ? Window.FullScreen : Window.Windowed)
    }
}
