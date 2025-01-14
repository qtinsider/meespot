/****************************************************************************
**
** Copyright (c) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Yoann Lopes (yoann.lopes@nokia.com)
**
** This file is part of the MeeSpot project.
** 
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions
** are met:
** 
** Redistributions of source code must retain the above copyright notice,
** this list of conditions and the following disclaimer.
** 
** Redistributions in binary form must reproduce the above copyright
** notice, this list of conditions and the following disclaimer in the
** documentation and/or other materials provided with the distribution.
** 
** Neither the name of Nokia Corporation and its Subsidiary(-ies) nor the names of its
** contributors may be used to endorse or promote products derived from
** this software without specific prior written permission.
** 
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
** FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
** TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
** PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
** LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
** NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/


import QtQuick 1.1
import com.nokia.meego 1.0
import "UIConstants.js" as UI

Item {
    id: selector

    property alias title: titleText.text
    property alias model: dialog.model
    property alias selectedIndex: dialog.selectedIndex

    property alias titleFontFamily: titleText.font.family
    property alias titleFontWeight: titleText.font.weight
    property alias titleFontSize: titleText.font.pixelSize
    property color titleColor: theme.inverted ? UI.LIST_TITLE_COLOR_INVERTED : UI.LIST_TITLE_COLOR
    property color subtitleColor: theme.inverted ? UI.LIST_SUBTITLE_COLOR_INVERTED : UI.LIST_SUBTITLE_COLOR

    width: parent.width
    height: UI.LIST_ITEM_HEIGHT

    SelectionDialog {
        id: dialog
        titleText: selector.title
    }

    Rectangle {
        id: background
        anchors.fill: parent
        // Fill page porders
        anchors.leftMargin: -UI.MARGIN_XLARGE
        anchors.rightMargin: -UI.MARGIN_XLARGE
        opacity: mouseArea.pressed ? 1.0 : 0.0
        color: theme.inverted ? "#22FFFFFF" : "#15000000"
        Behavior on opacity { NumberAnimation { duration: 50 } }
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: icon.left

        Label {
            id: titleText
            width: parent.width
            font.family: UI.FONT_FAMILY_BOLD
            font.weight: Font.Bold
            font.pixelSize: UI.LIST_TILE_SIZE
            elide: Text.ElideRight
            color: titleColor
        }
        Label {
            id: selectedValue
            width: parent.width
            font.family: UI.FONT_FAMILY_LIGHT
            font.pixelSize: UI.LIST_SUBTILE_SIZE
            font.weight: Font.Light
            elide: Text.ElideRight
            color: subtitleColor
            text: dialog.model.get(dialog.selectedIndex).name
        }
    }

    Image {
        id: icon
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        source: theme.inverted ? "image://theme/icon-m-textinput-combobox-arrow"
                               : "image://theme/icon-m-common-combobox-arrow"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            dialog.open()
        }
    }
}
