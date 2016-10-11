/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the manual tests of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.8
import Qt.labs.handlers 1.0
import QtQuick.Controls 2.0

Item {
    width: 480
    height: 320

    Rectangle {
        TapHandler {
            acceptedButtons: Qt.LeftButton
            enabled: leftAllowedCB.checked
            onTapped: {
                if (tapCount > 1) {
                    tapCountLabel.text = tapCount
                    flashAnimation.start()
                } else {
                    borderBlink.blinkColor = "green"
                    borderBlink.start()
                }
            }
        }

        TapHandler {
            acceptedButtons: Qt.MiddleButton
            enabled: middleAllowedCB.checked
            onTapped: {
                if (tapCount > 1) {
                    tapCountLabel.text = tapCount
                    flashAnimation.start()
                } else {
                    borderBlink.blinkColor = "orange"
                    borderBlink.start()
                }
            }
        }

        TapHandler {
            acceptedButtons: Qt.RightButton
            enabled: rightAllowedCB.checked
            onTapped: {
                if (tapCount > 1) {
                    tapCountLabel.text = tapCount
                    flashAnimation.start()
                } else {
                    borderBlink.blinkColor = "magenta"
                    borderBlink.start()
                }
            }
        }

        Text {
            id: tapCountLabel
            anchors.centerIn: parent
            font.pixelSize: 72
            font.weight: Font.Black
            SequentialAnimation {
                id: flashAnimation
                PropertyAction { target: tapCountLabel; property: "visible"; value: true }
                PropertyAction { target: tapCountLabel; property: "opacity"; value: 1.0 }
                PropertyAction { target: tapCountLabel; property: "scale"; value: 1.0 }
                ParallelAnimation {
                    NumberAnimation {
                        target: tapCountLabel
                        property: "opacity"
                        to: 0
                        duration: 500
                    }
                    NumberAnimation {
                        target: tapCountLabel
                        property: "scale"
                        to: 1.5
                        duration: 500
                    }
                }
            }
        }

        id: rect
        anchors.fill: parent; anchors.margins: 40
        border.width: 3; border.color: "transparent"; color: "lightgrey"

        SequentialAnimation {
            id: borderBlink
            property color blinkColor: "blue"
            loops: 3
            ScriptAction { script: rect.border.color = borderBlink.blinkColor }
            PauseAnimation { duration: 100 }
            ScriptAction { script: rect.border.color = "transparent" }
            PauseAnimation { duration: 100 }
        }
    }

    Row {
        spacing: 6
        Text { text: "accepted mouse clicks:"; anchors.verticalCenter: leftAllowedCB.verticalCenter }
        CheckBox {
            id: leftAllowedCB
            checked: true
            text: "left click"
        }
        CheckBox {
            id: middleAllowedCB
            text: "middle click"
        }
        CheckBox {
            id: rightAllowedCB
            text: "right click"
        }
    }
}
