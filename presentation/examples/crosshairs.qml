/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
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

import QtQuick 2.14
import QtQuick.Shapes 1.0


Item {
    id: root
    width: 480
    height: 480

    Shape {
        id: crosshairs
        x: handler.point.position.x - width / 2
        y: handler.point.position.y - height / 2
        width: 300; height: 300
        // visible: handler.pressed
        rotation: handler.point.rotation
        ShapePath {
            strokeColor: "red"
            fillColor: "transparent"
            strokeWidth: 3
            startX: crosshairs.width / 2; startY: 0
            PathLine { x: crosshairs.width / 2; y: crosshairs.height }
            PathMove { x: 0; y: crosshairs.height / 2 }
            PathLine { x: crosshairs.width; y: crosshairs.height / 2 }
        }
        ShapePath {
            strokeColor: "lightsteelblue"
            strokeWidth: 5
            startX: crosshairs.width / 2; startY: crosshairs.height / 2
            PathLine {
                relativeX: handler.point.velocity.x * 50
                relativeY: handler.point.velocity.y * 50
            }
        }
        Text {
            anchors.centerIn: parent
            text: 'seat: ' + handler.point.device.seatName + '\ndevice: ' + handler.point.device.name +
                  '\nid: ' + handler.point.id.toString(16) + " uid: " + handler.point.uniqueId.numericId +
                  '\npos: (' + handler.point.position.x.toFixed(2) + ', ' + handler.point.position.y.toFixed(2) + ')' +
                  '\nmodifiers: ' + handler.point.modifiers.toString(16)
        }
    }

    PointHandler {
        id: handler
    }
}
