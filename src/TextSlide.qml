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

import QtQuick.Controls 1.0
import QtQuick.Window 2.1
import QtGraphicalEffects 1.0

Item {
    id: slide;

    // Either set a file
    property string sourceFile;
    // or directly set the text here
    property alias text: text.text;

    property real textFontSize: 18;

    property bool isSlide: true;

    property string title;
    property variant content: []
    property string centeredText
    property string writeInText;
    property string notes;

    property real fontSize: parent.height * 0.05
    property real fontScale: 1

    property real baseFontSize: fontSize * fontScale
    property real titleFontSize: fontSize * 1.2 * fontScale
    property real bulletSpacing: 1

    property real contentWidth: width
    property bool expandContent: false

    // Define the slide to be the "content area"
    x: parent.width * 0.01
    y: parent.height * 0.1
    property real horizontalMargin: 6
    width: parent.width - horizontalMargin * 2
    height: parent.height * 0.89

    property real masterWidth: parent.width
    property real masterHeight: parent.height

    property color titleColor: parent.titleColor;
    property color textColor: parent.textColor;
    property string fontFamily: parent.fontFamily;

    visible: false

    Text {
        id: titleText
        font.pixelSize: titleFontSize
        text: title;
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: parent.fontSize * 0.5
        font.bold: true;
        font.family: slide.fontFamily
        color: slide.titleColor
        horizontalAlignment: Text.Center
        z: 1
    }

    Flickable {
        id: flick
        anchors.fill: parent
        anchors.margins: 6
        contentWidth: width
        contentHeight: text.implicitHeight
        Text {
            id: text
            wrapMode: Text.WordWrap
            font.pointSize: textFontSize
            text: "foo bar"
            width: parent.width
        }
    }

    Rectangle {
        id: verticalScrollDecorator
        anchors.right: parent.right
        anchors.margins: 2
        color: "grey"
        border.color: "black"
        border.width: 1
        width: 5
        radius: 2
        antialiasing: true
        height: flick.height * (flick.height / flick.contentHeight) - (width - anchors.margins) * 2
        y:  flick.contentY * (flick.height / flick.contentHeight)
    }

    // http://rschroll.github.io/beru/2013/08/12/opening-a-file-in-qml.html
    Component.onCompleted: {
        var request = new XMLHttpRequest()
        request.open('GET', slide.sourceFile)
        request.onreadystatechange = function(event) {
            if (request.readyState === XMLHttpRequest.DONE)
                text.text = request.responseText
        }
        request.send()
    }
}
