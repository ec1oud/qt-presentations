/****************************************************************************
**
** Copyright (C) 2015 Shawn Rutledge
**
** This file is part of the Grefsen (Wayland componsitor) project.
**
** This file is free software; you can redistribute it and/or
** modify it under the terms of the GNU Lesser General Public
** License version 3 as published by the Free Software Foundation
** and appearing in the file LICENSE included in the packaging
** of this file.
**
** This code is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
** GNU Lesser General Public License for more details.
**
****************************************************************************/

import QtQuick 2.8
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import MeeGo.Connman 0.2

Rectangle {
    SwipeView {
        ListView {
            id: techList
            spacing: 2
            delegate: SwitchDelegate {
                property NetworkTechnology tech: manager.getTechnology(modelData)
                width: parent.width
                text: tech.name
                checked: tech.powered; onCheckedChanged: tech.powered = checked
                onClicked: swipeView.currentIndex = 1
            }
        }
        ListView {
            id: wifiList
            spacing: 2
            model: TechnologyModel { id: techModel; name: "wifi" }
            delegate: ItemDelegate {
                text: networkService.name
                onClicked: networkService.requestConnect()
                enabled: !networkService.connected
                width: parent.width
                Text {
                    anchors { right: parent.right; margins: 6; verticalCenter: parent.verticalCenter }
                    color: Material.foreground; font.pixelSize: 30
                    text: networkService.connected ? "✔" : ""
                }
            }
        }
        Item {
            id: wifiConfigPage
            // TODO
        }

        id: swipeView; currentIndex: 0; anchors.fill: parent; font.pointSize: 18
    }

    PageIndicator {
        count: swipeView.count
        currentIndex: swipeView.currentIndex
        anchors.bottom: swipeView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    width: 320
    height: 480
    color: Material.background
    clip: true
    Material.theme: Material.Dark

    NetworkManager {
        id: manager
        function checkTechnologies() {
            var tl = manager.technologiesList()
            if (tl.length > 0)
                techList.model = tl
            console.log("state " + state + " available? " + available + " enabled svcs " + servicesEnabled + " techs " + technologiesEnabled)
            console.log("   list " + tl)
        }

        onAvailabilityChanged: checkTechnologies()
        onStateChanged: checkTechnologies()
        onOfflineModeChanged: checkTechnologies()
        onTechnologiesChanged: checkTechnologies()
        onTechnologiesEnabledChanged: checkTechnologies()
    }
}
