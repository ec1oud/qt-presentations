/****************************************************************************
**
** Copyright (C) 2019 The Qt Company Ltd.
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

import QtQuick 2.14
import "resources"

Item {
    id: root
    property int value: 50
    property int maximumValue: 99
    property alias label: label.text
    property alias tapEnabled: tap.enabled
    property alias pressed: tap.pressed
    signal tapped

    width: 100; height: 400

    DragHandler {
        id: dragHandler
        target: knob
        xAxis.enabled: false
//        yAxis.minimum: ybr.minimum // no longer necessary
//        yAxis.maximum: ybr.maximum
    }

    WheelHandler {
        id: wheelHandler
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        invertible: false   // Don't let the system "natural scrolling" setting affect this
        rotationScale: -0.5 // But make it go consistently in the same direction as the fingers or wheel, a bit slow
        target: knob
        propertyName: "y"
    }

    Rectangle {
        id: slot
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 10
        anchors.topMargin: label.height + 6
        anchors.bottomMargin: valueLabel.height + 4
        anchors.horizontalCenter: parent.horizontalCenter
        width: 10
        color: "black"
        radius: width / 2
        smooth: true
    }

    Rectangle {
        // RectangularGlow is better, but that's a different module
        id: glow
        anchors.fill: knob
        anchors.margins: -5
        anchors.leftMargin: -2
        anchors.horizontalCenterOffset: 1
        radius: 5
        color: "#4400FFFF"
        opacity: tap.pressed || tapFlash.running ? 1 : 0
        FlashAnimation on visible {
            id: tapFlash
        }
    }
    Image {
        id: knob
        source: "../resources/mixer-knob.png"
        antialiasing: true
        x: slot.x - width / 2 + slot.width / 2
        height: root.width / 2
        width: implicitWidth / implicitHeight * height
        property bool programmatic: false
        property real multiplier: root.maximumValue / (ybr.maximum - ybr.minimum)
        onYChanged: if (!programmatic) root.value = root.maximumValue - (knob.y - ybr.minimum) * multiplier
        transformOrigin: Item.Center
        function setValue(value) { knob.y = ybr.maximum - value / knob.multiplier }
        TapHandler {
            id: tap
            gesturePolicy: TapHandler.DragThreshold
            onTapped: {
                tapFlash.start()
                root.tapped
            }
        }
        BoundaryRule on y {
            id: ybr
            minimum: slot.y
            maximum: slot.height + slot.y - knob.height
        }
    }

    Text {
        id: valueLabel
        font.pointSize: 16
        color: "red"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.value
    }

    Text {
        id: label
        font.pointSize: 12
        color: "red"
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Component.onCompleted: {
        knob.programmatic = true
        knob.setValue(root.value)
        knob.programmatic = false
    }
}