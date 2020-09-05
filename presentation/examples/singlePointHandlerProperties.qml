/****************************************************************************
**
** Copyright (C) 2020 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the manual tests of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL-EXCEPT$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation with exceptions as appearing in the file LICENSE.GPL3-EXCEPT
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 6.0

// a simplified version of qtdeclarative/tests/manual/pointer/singlePointHandlerProperties.qml
Item {
    id: root
    width: 480
    height: 480

    PointHandler {
        id: pointHandler
        target: null
        acceptedButtons: Qt.AllButtons
    }

    Item {
        id: crosshairs
        x: pointHandler.point.position.x - width / 2
        y: pointHandler.point.position.y - height / 2
        width: parent.width / 2; height: parent.height / 2
        visible: pointHandler.active
        rotation: pointHandler.point.rotation

        Rectangle {
            color: "tomato"
            anchors.centerIn: parent
            width: 2; height: parent.height
            antialiasing: true
        }
        Rectangle {
            color: "tomato"
            anchors.centerIn: parent
            width: parent.width; height: 2
            antialiasing: true
        }
        Rectangle {
            color: "tomato"
            width: Math.max(2, 75 * pointHandler.point.pressure)
            height: width
            radius: width / 2
            anchors.centerIn: parent
            antialiasing: true
            Rectangle {
                y: -56
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#66DDEEFF"
                implicitWidth: label.implicitWidth
                implicitHeight: label.implicitHeight
                Text {
                    id: label
                    text: 'seat: "' + pointHandler.point.device.seatName +
                          '"\ndevice: ' + pointHandler.point.device.name +
                          '\nid: ' + pointHandler.point.id.toString(16) +
                          ' uid: ' + pointHandler.point.uniqueId.numericId +
                          '\npos: (' + pointHandler.point.position.x.toFixed(2) +
                          ', ' + pointHandler.point.position.y.toFixed(2) + ')' +
                          '\nmodifiers: ' + pointHandler.point.modifiers.toString(16)
                }
            }
        }
        Rectangle {
            color: "transparent"
            border.color: "white"
            antialiasing: true
            width: pointHandler.point.ellipseDiameters.width
            height: pointHandler.point.ellipseDiameters.height
            radius: Math.min(width / 2, height / 2)
            anchors.centerIn: parent
        }
    }
    Rectangle {
        id: velocityVector
        visible: width > 0
        width: pointHandler.point.velocity.length() * 100
        height: 2
        x: pointHandler.point.position.x
        y: pointHandler.point.position.y
        rotation: Math.atan2(pointHandler.point.velocity.y,
                             pointHandler.point.velocity.x) * 180 / Math.PI
        transformOrigin: Item.BottomLeft
        antialiasing: true

        Image {
            source: "resources/arrowhead.png"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 16
            height: 12
            antialiasing: true
        }
    }
}
