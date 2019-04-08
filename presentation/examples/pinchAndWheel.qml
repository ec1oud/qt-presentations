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

Item {
    id: root
    width: 1024; height: 600

    Rectangle {
        id: transformable
        width: parent.width - 100; height: parent.height - 100; x: 50; y: 50
        color: "#ffe0e0e0"
        antialiasing: true

        WheelHandler {
            id: scaleWheelHandler
            objectName: "mouse wheel for scaling"
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            acceptedModifiers: Qt.NoModifier
            propertyName: "scale"
            onActiveChanged: if (!active) sbr.returnToBounds();
            onWheel: console.log(objectName + ": rotation " + event.angleDelta.y + " scaled " + rotation + " @ " + point.position + " => " + parent.scale)
        }

        BoundaryRule on scale {
            id: sbr
            minimum: 0.1
            maximum: 1000
            minimumOvershoot: 0.05
            maximumOvershoot: 0.05
        }

        WheelHandler {
            id: controlRotationWheelHandler
            objectName: "control-mouse wheel for rotation"
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            acceptedModifiers: Qt.ControlModifier
            propertyName: "rotation"
            orientation: Qt.Vertical // already the default
            onWheel: console.log(objectName + ": rotation " + event.angleDelta.y + " scaled " + rotation + " @ " + point.position + " => " + parent.rotation)
        }

        PinchHandler {
            id: parentPinch
            objectName: "parent pinch"
            minimumScale: 0.5
            maximumScale: 3
        }

        function getTransformationDetails(item, pinchhandler) {
            return "\n\npinch.scale:" + pinchhandler.scale.toFixed(2)
                    + "\npinch.rotation:" + pinchhandler.rotation.toFixed(2)
                    + "°\npinch.translation:" + "(" + pinchhandler.translation.x.toFixed(2) + "," + pinchhandler.translation.y.toFixed(2) + ")"
                    + "\nscale wheel.rotation:" + scaleWheelHandler.rotation.toFixed(2)
                    + "°\ncontrol-rotation wheel.rotation:" + controlRotationWheelHandler.rotation.toFixed(2)
                    + "°\nrect.scale: " + item.scale.toFixed(2)
                    + "\nrect.rotation: " + item.rotation.toFixed(2)
                    + "°\nrect.position: " + "(" + item.x.toFixed(2) + "," + item.y.toFixed(2) + ")"
        }

        Text {
            text: "Pinch with 2 fingers to scale, rotate and translate\nMouse wheel to scale, Ctrl+mouse wheel or horizontal wheel to rotate"
                  + transformable.getTransformationDetails(parent, parentPinch)
            horizontalAlignment: Text.Center
            anchors.centerIn: parent
        }
    }
}
