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

Rectangle {
    property alias text: title.text
    property alias secondaryText: title2.text
    property real contentOpacity: 1.0
    property int contentMargins: 0

    width: parent ? parent.width : 0
    height: screen.currentOrientation == Screen.Portrait ? UI.HEADER_DEFAULT_HEIGHT_PORTRAIT : UI.HEADER_DEFAULT_HEIGHT_LANDSCAPE
    anchors.horizontalCenter: parent.horizontalCenter
    color: "transparent"

    Column {
        anchors.left: parent.left
        anchors.leftMargin: contentMargins
        anchors.right: parent.right
        anchors.rightMargin: contentMargins
        anchors.verticalCenter: parent.verticalCenter

        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            id: title
            verticalAlignment: Text.AlignVCenter
            color: theme.inverted ? UI.COLOR_INVERTED_FOREGROUND : UI.COLOR_FOREGROUND
            font.pixelSize: UI.FONT_LARGE
            font.family: UI.FONT_FAMILY_LIGHT
            elide: Text.ElideRight
            opacity: contentOpacity
        }
        Label {
            id: title2
            anchors.left: text.length > 0 ? parent.left : undefined
            anchors.right: text.length > 0 ? parent.right : undefined
            verticalAlignment: Text.AlignVCenter
            color: theme.inverted ? UI.COLOR_INVERTED_SECONDARY_FOREGROUND : UI.LIST_SUBTITLE_COLOR
            font.pixelSize: UI.FONT_SMALL
            elide: Text.ElideRight
            opacity: contentOpacity
        }
    }

    Separator {
        anchors.left: parent.left
        anchors.leftMargin: contentMargins
        anchors.right: parent.right
        anchors.rightMargin: contentMargins
        anchors.bottom: parent.bottom
    }
}
