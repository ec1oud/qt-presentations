/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QML Presentation System.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/


import QtQuick 2.1
import Qt.labs.presentation.helper 1.0

import QtQuick.Controls 1.0
import QtQuick.Window 2.1

Rectangle {
    id: slide;
    property bool isSlide: true
    anchors.centerIn: parent
    x: parent.width * 0.1
    width: parent.width * 0.8
    y: parent.height * 0.025
    height: parent.height * 0.95
    property string title
    visible: false

    // Either set an example file
    property string sourceFile;
    // or directly set the code here
    property string code: helper.content;
    property string notes


    property real fontSize: parent.height * 0.05
    property real fontScale: 1

    property real baseFontSize: fontSize * fontScale
    property real titleFontSize: fontSize * 1.2 * fontScale


    property color titleColor: parent.titleColor;
    property color textColor: parent.textColor;
    property string fontFamily: parent.fontFamily;

    property string codeFontFamily: parent.codeFontFamily;
    property real codeFontSize: baseFontSize * 0.6;


    Text {
        id: titleText
        font.pixelSize: titleFontSize
        text: title;
        anchors.right: background.right
        anchors.top: background.top
        anchors.topMargin: 10
        anchors.rightMargin: 15
        font.bold: true;
        font.family: slide.fontFamily
        color: slide.titleColor
//        horizontalAlignment: Text.Center
        z: 1
    }

    Rectangle {
        id: background
        border.color: slide.textColor;
        border.width: 1
        width: parent.width
        height: Math.min(codeLineHeight * listModel.count, parent.height)
        anchors.verticalCenter: parent.verticalCenter
        color: "#eee"
    }

    Text {
        id: fontMetrics
        visible: false
        text: "X"
        font.pixelSize: (parent && parent.codeFontSize > 0)? slide.codeFontSize : 10
        font.family: slide.codeFontFamily
    }
    property int codeLineHeight: fontMetrics.height

    onCodeChanged: {
        listModel.clear();
        var codeLines = slide.code.split("\n");
        for (var i=0; i<codeLines.length; ++i) {
            listModel.append({
                                line: i,
                                code: codeLines[i]
                             });
        }
    }

    ListModel {
        id: listModel
    }

    onVisibleChanged: {
        listView.focus = slide.visible;
        listView.currentIndex = -1;
    }

    ListView {
        id: listView;

        anchors.fill: background;
        clip: true

        model: listModel;
        focus: true;

        MouseArea {
            anchors.fill: parent
            onClicked: {
                listView.focus = true;
                listView.currentIndex = listView.indexAt(mouse.x, mouse.y + listView.contentY);
            }
        }

        delegate: Item {

            id: itemDelegate

            height: codeLineHeight
            width: parent.width

//            Rectangle {
//                id: lineLabelBackground
//                width: lineLabel.height * 3;
//                height: lineLabel.height;
//                color: slide.textColor;
//                opacity: 0.1;
//            }

//            Text {
//                id: lineLabel
//                anchors.right: lineLabelBackground.right;
//                text: (line+1) + ":"
//                color: slide.textColor;
//                font.family: slide.codeFontFamily
//                font.pixelSize: slide.codeFontSize
//                font.bold: itemDelegate.ListView.isCurrentItem;
//                opacity: itemDelegate.ListView.isCurrentItem ? 1 : 0.9;
//            }

            Rectangle {
                id: lineContentBackground
                anchors.fill: lineContent;
                anchors.leftMargin: -height / 2;
                color: slide.textColor
                opacity: 0.2
                visible: itemDelegate.ListView.isCurrentItem;
            }
            Text {
                id: lineContent
                anchors.left: parent.left // lineLabelBackground.right
                anchors.leftMargin: 6 // lineContent.height;
                anchors.right: parent.right;
                color: slide.textColor;
                text: code;
                font.family: slide.codeFontFamily
                font.pixelSize: slide.codeFontSize
                font.bold: itemDelegate.ListView.isCurrentItem;
                opacity: itemDelegate.ListView.isCurrentItem ? 1 : 0.9;
            }
        }
    }

//    Button {
//        id: b
//        text: "Run"
//        anchors.right: parent.right
//        anchors.bottom: parent.bottom
//        visible: helper.source.length > 0

//        onClicked: {
//            ex.visible = true
//            loader.source = "" // force reload
//            loader.source = helper.sourcePath
//        }
//    }

    Action {
        enabled: slide.visible
        shortcut: "x"
        onTriggered: {
            ex.visible = true
            loader.source = "" // force reload
            loader.source = helper.sourcePath
        }
    }
    Action {
        enabled: slide.visible
        shortcut: "r"
        onTriggered: {
            ex.visible = true
            loader.source = "" // force reload
            loader.source = helper.sourcePath
        }
    }

    ExampleHelper {
        id: helper
        source: slide.visible ? sourceFile : ""
    }

    Window {
        id: ex
        width: loader.width
        height: loader.height

        Loader {
            id: loader
            focus: true
        }
    }
}
