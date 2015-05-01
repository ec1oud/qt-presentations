import QtQuick 2.1
import Qt.labs.presentation 1.0

import "examples/mouse"
import "examples/key"

Presentation {
    id: presentation
    anchors.fill: parent

//    width: 1280
//    height: 720

    SlideCounter {}
    Clock{}

    Image {
        anchors.fill: parent
        source: "images/template.png"
        visible: title.visible
    }
    Slide {
        id: title
        titleColor: "white"
        title: "Input and Qt Quick"
        centeredText: "
Mouse, Touch and Keyboard handling in Qt Quick

Qt Developer Days 2013

Frederik Gladhorn
frederik.gladhorn@digia.com"
    }

    Slide {
        title: "About me"
        Image { anchors.right: parent.right; source: "images/frederik.jpg";
            height: parent.height
            fillMode: Image.PreserveAspectFit
        }
        content: [
            "KDE since ~2005",
            "Digia - Oslo",
            "Qt Accessibility",
            "Enginio",
            "Qt Quick Controls input",
        ]
    }

    Slide {
        title: "Contents"
        content: [
            "",
            "Mouse",
            "Touch",
            "Keyboard",
        ]
    }

    Slide {
        centeredText: "Mouse"
        fontScale: 2
    }

    Slide {
        title: "Mouse"
        content: [
            "MouseArea",
            "Flickable",
            "custom component inheriting QQuickItem",
        ]
    }
    CodeSlide {
        id: mouseAreaSlide
        title: "MouseArea"
        sourceFile: "examples/mouse/Mouse.qml"
    }
    Mouse { visible: mouseAreaSlide.visible
        anchors.right: presentation.right; anchors.top: presentation.top; border.color: "black";
        width: 300; height: 300
    }

//    Slide {
//        title: "MouseArea"
//        content: [
//            "non-visual QQuickItem",
//            "geometry",
//            "handlers for mouse events",
//            "stacking possible",
//            'hover',
//            "grab",
//            "steal",
//        ]
//    }
    CodeSlideLong {
        id: mouseHoverSlide
        title: "Hover"
        sourceFile: "examples/mouse/MouseHover.qml"
    }
    MouseHover {
        visible: mouseHoverSlide.visible
               anchors.right: presentation.right; anchors.top: presentation.top; border.color: "black";
               width: 300; height: 300
    }
//    Slide {
//        title: "MouseArea - geometry"
//        content: [
//            "anchors.fill: parent",
//            "can be made custom shaped by not accepting events",
//            "inverse paint order when stacked",
//        ]
//    }
    CodeSlideLong {
        title: "Round MouseArea"
        sourceFile: "examples/mouse/MouseCustomShape.qml"
    }

    Slide {
        title: "MouseArea"
        content: [
            "clicked, pressed, mouseX, mouseY, released",
            "doubleClicked, wheel",
            "canceled",
            "QQuickMouseEvent (in QML: mouse)",
            "events by default accepted",
        ]
    }
    Slide {
        title: "MouseArea"
        Row {
            spacing: 50
            Image {
                source: "images/mouse_event.png"
            }
            MousePropagationDemo {
                acc: true
                Text {
                    anchors.top: parent.bottom
                    text: "Event accepted"
                    font.pixelSize: 22
                }
            }
            MousePropagationDemo {
                acc: false
                Text {
                    anchors.top: parent.bottom
                    text: "Event not accepted\nby top\nMouseArea"
                    font.pixelSize: 22
                }
            }
        }
    }
    CodeSlideLong {
        title: "Two MouseAreas"
        sourceFile: "examples/mouse/MouseStack.qml"
    }
    CodeSlideLong {
        title: "Events, Pressed and Hover"
        sourceFile: "examples/mouse/MouseStack2.qml"
    }

    CodeSlideLong {
        title: "Flickable"
        sourceFile: "examples/mouse/Flickable.qml"
    }
    Slide {
        title: "Flickable"
        content: [
            "mouse grabber",
            "filtersChildMouseEvents",
            "stealing",
            "prevent grab",
        ]
    }
    CodeSlideLong {
        title: "Prevent Stealing"
        sourceFile: "examples/mouse/Flickable2.qml"
    }

    Slide {
        centeredText: "Touch"
        fontScale: 2
    }

    Slide {
        title: "Touch Items"
        content: [
            "MouseArea",
            "Flickable",
            "PinchArea",
            "MultiPointTouchArea",
            "Custom C++",
        ]
    }
//    Slide {
//        title: "Touch"
//        content: [
//            "synth mouse",
//            "propagation",
//            "stealing",
//        ]
//    }
    Slide {
        title: "PinchArea"
        content: [
            "two finger gestures",
            "rotate",
            "scale",
            "drag",
        ]
    }

    Cam {}

    Slide {
        title: "MultiPointTouchArea"
        content: [
            "choice of # points",
            "low level events",
        ]
    }

    Cam {}

    Slide {
        title: "Touch and Mouse Event Delivery"
        content: [
            "each item gets a touch event offered",
            "if not accepted, a mouse event",
            "continue with next item if not accepted"
        ]
        Image {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: "images/touch_mouse_event.png"
        }
    }

    Slide {
        centeredText: "Keyboard"
        fontScale: 2
    }
//    Slide {
//        title: "Keyboard"
//        content: [
//            "Basics",
//            "Focus",
//            "Shortcuts",
//        ]
//    }
    Slide {
        title: "Attached properties"
        content: [
            "Keys.onSpacePressed",
            "Keys.onPressed (not accepted by default!)",
            "Keys.onReleased (not accepted by default!)",
            "KeyNavigation",
        ]
    }

    CodeSlide {
        title: "Press space and ..."
        sourceFile: "examples/key/Simple1.qml"
    }
    CodeSlide {
        title: "Focus"
        sourceFile: "examples/key/Simple2.qml"
    }
    Slide {
        centeredText: "What happens if two items have \"focus: true\"?"
    }

//    Slide {
//        title: "No Focus no Keys"
//        content: [
//            "active focus item",
//            "exclusive",
//            "scoping of focus"
//        ]
//    }
//    Slide {
//        title: "Focus and two Rectangles?"
//        //sourceFile: "examples/key/TwoRects.qml"
//        TwoRects { anchors.centerIn: parent; Component.onCompleted: forceActiveFocus() }
//    }

//    Slide {
//        title: "Example: Tree of items"
//        Image { anchors.centerIn: parent; source: "images/focus_tree.png"
//        }
//    }
//    CodeSlideLong {
//        title: "A tree of objects"
//        sourceFile: "examples/key/Tree.qml"
//    }
//    CodeSlideLong {
//        title: "A tree with focus scopes"
//        sourceFile: "examples/key/TreeFocusScopes.qml"
//    }

    Tree {
        property bool isSlide: true
        visible: false
        anchors.centerIn: parent
    }
    TreeFocusScopes {
        property bool isSlide: true
        visible: false
        anchors.centerIn: parent
    }

    Slide {
        title: "Settig the Focus in Qt Quick"
        content: [
            "activeFocus: the focus item",
            "forceActiveFocus(): function to set the focus to item and all it's parents",
            "focus: items that have the focus in their respective parent focus scope",
        ]
    }
    Slide {
        title: "FocusScope"
        content: [
            "partitions the hierarchy",
            "lists, loaders, tabs, stacks",
            "forwards focus to child when it gets \"focus: true\"",
        ]
    }
//    Slide {
//        title: "KeyNavigation"
//        content: [
//            "arrow keys",
//            "tab and back-tab",
//        ]
//    }
    CodeSlideLong {
        title: "KeyNavigation"
        sourceFile: "examples/key/KeyNavigation.qml"
    }
//    Slide {
//        title: "activeFocusOnTab"
//        content: [
//            "Focus chain",
//            "Like a walk in the graph, picks the next item with activeFocusOnTab set",
//            "Just works, except when the order is not order of creation, then manual override needed...",
//        ]
//    }
    CodeSlideLong {
        title: "activeFocusOnTab"
        sourceFile: "examples/key/ActiveFocusOnTab.qml"
    }

    Slide {
        title: "Action!"
        content: [
            "Qt Quick.Controls",
            "ShortcutOverride",
        ]
    }
    CodeSlideLong {
        title: "Actions (Qt Quick Controls)"
        sourceFile: "examples/key/Actions.qml"
    }
    Slide {
        title: "ShortcutOverride"
        content: [
            "event",
            "sent to active focus item/widget",
            "just before shortcut would trigger",
            "when accepted delivered as regular key event",
        ]
    }

    Slide {
        title: "Questions?"
        centeredText: "Frederik Gladhorn\nfrederik.gladhorn@digia.com\n\nfregl on #qt-labs (freenode irc)"

    }
}
