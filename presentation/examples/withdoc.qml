/****************************************************************************
**
** Copyright (C) 2020 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
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
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Pdf 5.15
import QtQuick.Shapes 1.15

Rectangle {
    id: root
    width: 600; height: 600
    color: "lightgrey"
    clip: true

    PdfDocument {
        id: doc
        source: "test.pdf"
    }

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 6; spacing: 6
        Text { text: "title: " + doc.title; visible: doc.title !== "" }
        Text { text: "author: " + doc.author; visible: doc.author !== "" }
        Text { text: "subject: " + doc.subject; visible: doc.subject !== "" }
        Text { text: "creationDate: " + doc.creationDate; visible: doc.creationDate !== "" }
        Text { text: "source size: " + image.sourceSize.width + "x" + image.sourceSize.height }

        Flickable { // reacts to mouse wheel and to touch
            Layout.fillWidth: true; Layout.fillHeight: true
            contentWidth: paper.width; contentHeight: paper.height; z: -1
            Rectangle {
                id: paper
                width: image.width; height: image.height
                Image {
                    id: image
                    currentFrame: 1
                    source: doc.status === PdfDocument.Ready ? doc.source : ""

                    DragHandler { // intercepts mouse drag (Flickable won't get it)
                        id: dragHandler
                        acceptedDevices: DragHandler.Mouse
                        target: null
                    }
                }

                Shape {
                    anchors.fill: parent
                    opacity: 0.25
                    ShapePath {
                        scale: Qt.size(selection.renderScale, selection.renderScale)
                        fillColor: "cyan"
                        PathMultiline {
                            id: selectionBoundaries
                            paths: selection.geometry
                        }
                    }
                }
            }
        }
    }

    PdfSelection {
        id: selection
        document: doc
        page: image.currentFrame
        fromPoint: dragHandler.centroid.pressPosition
        toPoint: dragHandler.centroid.position
        hold: !dragHandler.active
        Shortcut { sequence: StandardKey.Copy; onActivated: selection.copyToClipboard() }
    }

    Text {
        anchors.bottom: parent.bottom; anchors.right: parent.right
        text: "page " + (image.currentFrame + 1) + " of " + doc.pageCount
    }

    Shortcut { sequence: StandardKey.ZoomIn; onActivated: zoom(1) }
    Shortcut { sequence: StandardKey.ZoomOut; onActivated: zoom(-1) }
    Shortcut { sequence: "Ctrl+0"; onActivated: zoom(0) }
    property real zoomFactor: Math.sqrt(2)
    function zoom(step) {
        if (step > 0) {
            image.sourceSize.width = image.implicitWidth * zoomFactor
            image.sourceSize.height = image.implicitHeight * zoomFactor
            selection.renderScale *= zoomFactor
        } else if (step < 0) {
            image.sourceSize.width = image.implicitWidth / zoomFactor
            image.sourceSize.height = image.implicitHeight / zoomFactor
            selection.renderScale /= zoomFactor
        } else {
            image.sourceSize = undefined
            selection.renderScale = 1
        }
    }
}
