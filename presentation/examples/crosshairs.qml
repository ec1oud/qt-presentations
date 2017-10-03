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

import QtQuick 2.10
import Qt.labs.handlers 1.0

Item {
    id: root
    width: 480
    height: 480

    Instantiator {
        model: 10
        defaultParent: root // TODO not added yet in 5.10 but mandatory for this

        PointHandler {
            id: handler
            objectName: "point " + index
            target: Item {
                id: crosshairs
                x: handler.point.x - width / 2
                y: handler.point.y - height / 2
                width: 300; height: 300
                visible: handler.pressed
                rotation: handler.point.rotation

                Rectangle {
                    color: blob.color
                    anchors.centerIn: parent
                    width: 2; height: parent.height
                    antialiasing: true
                }
                Rectangle {
                    color: blob.color
                    anchors.centerIn: parent
                    width: parent.width; height: 2
                    antialiasing: true
                }
                Rectangle {
                    id: blob
                    color: Qt.rgba(Qt.random(), Qt.random(), Qt.random(), 1)
                    implicitWidth: label.implicitWidth + 8
                    implicitHeight: label.implicitHeight + 16
                    radius: width / 2
                    anchors.centerIn: parent
                    antialiasing: true
                    Rectangle {
                        color: "black"
                        opacity: 0.35
                        width: (parent.width - 8) * handler.point.pressure
                        height: width
                        radius: width / 2
                        anchors.centerIn: parent
                        antialiasing: true
                    }
                    Rectangle {
                        color: "transparent"
                        border.color: "white"
                        border.width: 2
                        opacity: 0.75
                        visible: width > 0
                        width: handler.point.ellipseDiameters.width
                        height: handler.point.ellipseDiameters.height
                        radius: Math.min(width, height) / 2
                        anchors.centerIn: parent
                        antialiasing: true
                    }
                    Text {
                        id: label
                        anchors.centerIn: parent
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        property string uid: handler.point.uniqueId === undefined || handler.point.uniqueId.numericId === -1 ?
                                                 "" : "\nUID " + handler.point.uniqueId.numericId
                        text: "x " + handler.point.x.toFixed(1) +
                              "\ny " + handler.point.y.toFixed(1) + uid +
                              "\nID " + handler.point.pointId.toString(16) +
                              "\n∡" + handler.point.rotation.toFixed(1) + "°"
                    }
                }
                Rectangle {
                    id: velocityVector
                    visible: width > 0
                    width: handler.point.velocity.length()
                    height: 4
                    Behavior on width { SmoothedAnimation { duration: 200 } }
                    radius: height / 2
                    antialiasing: true
                    color: "gray"
                    x: crosshairs.width / 2
                    y: crosshairs.height / 2
                    rotation: width > 0 ? Math.atan2(handler.point.velocity.y, handler.point.velocity.x) * 180 / Math.PI - crosshairs.rotation : 0
                    Behavior on rotation { SmoothedAnimation { duration: 20 } }
                    transformOrigin: Item.BottomLeft
                }

                Component.onCompleted: handler.point = mpta.handler.points[index]
            }
        }
    }
}
