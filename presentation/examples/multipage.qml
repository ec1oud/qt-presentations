/****************************************************************************
**
** Copyright (C) 2022 The Qt Company Ltd.
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
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Pdf

Rectangle { // ApplicationWindow IRL
    id: root; width: 600; height: 800; color: "lightgrey"

    PdfDocument {
        id: document
        source: Qt.resolvedUrl("nexus7-manual-page-numbers.pdf")
        onStatusChanged: (status) => {
            // if (status === PdfDocument.Error) errorDialog.open()
            view.document = (status === PdfDocument.Ready ? document : undefined)
        }
        // onPasswordRequired: passwordDialog.open()
    }

    SplitView {
        anchors.fill: parent; anchors.topMargin: header.height; anchors.bottomMargin: footer.height
        Item {
            SplitView.preferredWidth: sidebarOpenAction.checked ? 250 : 0
            visible: sidebarOpenAction.checked

            TabBar {
                id: sidebarTabs
                x: -width
                rotation: -90
                transformOrigin: Item.TopRight
                currentIndex: 2 // bookmarks by default
                TabButton { text: qsTr("Info") }
                TabButton { text: qsTr("Search Results") }
                TabButton { text: qsTr("Bookmarks") }
                TabButton { text: qsTr("Pages") }
            }

            GroupBox {
                anchors.fill: parent
                anchors.leftMargin: sidebarTabs.height

                StackLayout {
                    anchors.fill: parent
                    currentIndex: sidebarTabs.currentIndex
                    component InfoField: TextInput {
                        width: parent.width
                        selectByMouse: true
                        readOnly: true
                        wrapMode: Text.WordWrap
                    }
                    Column {
                        spacing: 6
                        width: parent.width - 6
                        Label { font.bold: true; text: qsTr("Title") }
                        InfoField { text: document.title }
                        Label { font.bold: true; text: qsTr("Author") }
                        InfoField { text: document.author }
                        Label { font.bold: true; text: qsTr("Subject") }
                        InfoField { text: document.subject }
                        Label { font.bold: true; text: qsTr("Keywords") }
                        InfoField { text: document.keywords }
                        Label { font.bold: true; text: qsTr("Producer") }
                        InfoField { text: document.producer }
                        Label { font.bold: true; text: qsTr("Creator") }
                        InfoField { text: document.creator }
                        Label { font.bold: true; text: qsTr("Creation date") }
                        InfoField { text: document.creationDate }
                        Label { font.bold: true; text: qsTr("Modification date") }
                        InfoField { text: document.modificationDate }
                    }
                    ListView {
                        id: searchResultsList; clip: true
                        model: view.searchModel
                        ScrollBar.vertical: ScrollBar { }
                        delegate: ItemDelegate {
                            onClicked: {
                                searchResultsList.currentIndex = index
                                view.goToLocation(page, location, 0)
                                view.searchModel.currentResult = indexOnPage
                            }
                            width: parent ? parent.width : 0
                            Label {
                                text: "Page " + (page + 1) + ": " + contextBefore.substring(contextBefore.length - 10) + "<b>" + view.searchString + "</b>" + contextAfter
                                elide: Text.ElideRight
                            }
                            highlighted: ListView.isCurrentItem
                        }
                    }
                    TreeView {
                        id: bookmarksTree
                        width: parent.width - 6
                        columnWidthProvider: function() { return width }
                        delegate: TreeViewDelegate {
                            required property int page
                            required property point location
                            required property real zoom
                            onClicked: view.goToLocation(page, location, zoom)
                        }
                        model: PdfBookmarkModel { document: document }
                        ScrollBar.vertical: ScrollBar { }
                    }
                    GridView {
                        id: thumbnailsView
                        model: document.pageModel
                        cellWidth: width / 2
                        cellHeight: cellWidth + 10
                        delegate: Item {
                            required property int index
                            required property string label
                            required property size pointSize
                            width: thumbnailsView.cellWidth
                            height: thumbnailsView.cellHeight
                            Rectangle {
                                id: paper
                                width: image.width
                                height: image.height
                                x: (parent.width - width) / 2
                                y: (parent.height - height - pageNumber.height) / 2
                                Image {
                                    id: image
                                    source: document.source
                                    currentFrame: index
                                    asynchronous: true
                                    fillMode: Image.PreserveAspectFit
                                    sourceSize { width: 64; height: 64 }
                                }
                            }
                            Text {
                                id: pageNumber
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: label
                            }
                            TapHandler { onTapped: view.goToPage(index) }
                        }
                    }
                }
            }
        }
        PdfMultiPageView {
            id: view; clip: true
            document: root.document
            searchString: searchField.text
            onCurrentPageChanged: currentPageSB.value = view.currentPage
        }
    }

    ToolBar {
        id: header
        width: parent.width; height: headerRow.implicitHeight
        RowLayout {
            id: headerRow
            anchors.fill: parent
            anchors.rightMargin: 6
            ToolButton {
                action: Action {
                    shortcut: StandardKey.ZoomIn
                    enabled: view.renderScale < 10
                    icon.source: "resources/zoom-in.pdf"
                    onTriggered: view.renderScale *= Math.sqrt(2)
                }
            }
            ToolButton {
                action: Action {
                    shortcut: StandardKey.ZoomOut
                    enabled: view.renderScale > 0.1
                    icon.source: "resources/zoom-out.pdf"
                    onTriggered: view.renderScale /= Math.sqrt(2)
                }
            }
            ToolButton {
                action: Action {
                    icon.source: "resources/zoom-fit-best.pdf"
                    onTriggered: view.scaleToPage(view.width, view.height)
                }
            }
            ToolButton {
                action: Action {
                    shortcut: "Ctrl+L"
                    icon.source: "resources/rotate-left.pdf"
                    onTriggered: view.pageRotation -= 90
                }
            }
            ToolButton {
                action: Action {
                    shortcut: "Ctrl+R"
                    icon.source: "resources/rotate-right.pdf"
                    onTriggered: view.pageRotation += 90
                }
            }
            ToolButton {
                action: Action {
                    icon.source: "resources/go-previous-view-page.pdf"
                    enabled: view.backEnbled
                    onTriggered: view.back()
                }
                ToolTip.visible: enabled && hovered
                ToolTip.delay: 2000
                ToolTip.text: "go back"
            }
            SpinBox {
                id: currentPageSB
                from: 0
                to: document.pageCount - 1
                editable: true
                onValueModified: view.goToPage(value)
                textFromValue: function(value) { return document.pageLabel(value) }
                valueFromText: function(text) {
                    for (var i = 0; i < document.pageCount; ++i) {
                        if (document.pageLabel(i).toLowerCase().indexOf(text.toLowerCase()) === 0)
                            return i
                    }
                    return spinBox.value
                }
                Shortcut {
                    sequence: "Ctrl+S" // StandardKey.MoveToPreviousPage IRL
                    onActivated: view.goToPage(currentPageSB.value - 1)
                }
                Shortcut {
                    sequence: "Ctrl+D" // StandardKey.MoveToNextPage IRL
                    onActivated: view.goToPage(currentPageSB.value + 1)
                }
            }
            ToolButton {
                action: Action {
                    icon.source: "resources/go-next-view-page.pdf"
                    enabled: view.forwardEnabled
                    onTriggered: view.forward()
                }
                ToolTip.visible: enabled && hovered
                ToolTip.delay: 2000
                ToolTip.text: "go forward"
            }
            ToolButton {
                action: Action {
                    shortcut: StandardKey.Copy
                    icon.source: "resources/edit-copy.pdf"
                    enabled: view.selectedText !== ""
                    onTriggered: view.copySelectionToClipboard()
                }
            }
        }
    }

    ToolBar {
        id: footer
        anchors.bottom: parent.bottom
        width: parent.width
        height: footerRow.implicitHeight
        RowLayout {
            id: footerRow
            anchors.fill: parent; anchors.rightMargin: 4
            ToolButton {
                action: Action {
                    id: sidebarOpenAction
                    checkable: true
                    checked: true
                    icon.source: checked ? "resources/sidebar-collapse-left.pdf" : "resources/sidebar-expand-left.pdf"
                }
                ToolTip.visible: enabled && hovered
                ToolTip.delay: 2000
                ToolTip.text: "open sidebar"
            }
            ToolButton {
                action: Action {
                    icon.source: "resources/go-up-search.pdf"
                    shortcut: StandardKey.FindPrevious
                    onTriggered: view.searchBack()
                }
                ToolTip.visible: enabled && hovered
                ToolTip.delay: 2000
                ToolTip.text: "find previous"
            }
            TextField {
                id: searchField
                placeholderText: "search"
                Layout.minimumWidth: 150
                Layout.fillWidth: true
                onAccepted: searchResultsList.SplitView.preferredWidth = 250
                Image {
                    visible: searchField.text !== ""
                    source: "resources/edit-clear.pdf"
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                        margins: 3
                        rightMargin: 5
                    }
                    TapHandler {
                        onTapped: {
                            searchField.clear()
                            searchResultsList.SplitView.preferredWidth = 0
                        }
                    }
                }
                Shortcut {
                    sequence: StandardKey.Find
                    onActivated: searchField.forceActiveFocus()
                }
            }
            ToolButton {
                action: Action {
                    icon.source: "resources/go-down-search.pdf"
                    shortcut: StandardKey.FindNext
                    onTriggered: view.searchForward()
                }
                ToolTip.visible: enabled && hovered
                ToolTip.delay: 2000
                ToolTip.text: "find next"
            }
            Label {
                id: statusLabel
                property size implicitPointSize: document.pagePointSize(view.currentPage)
                text: "page " + currentPageSB.displayText + " : " + (currentPageSB.value) + " of " + document.pageCount +
                      " scale " + view.renderScale.toFixed(2)
                visible: document.pageCount > 0
            }
        }
    }
}
