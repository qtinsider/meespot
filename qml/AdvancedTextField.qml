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

TextField {
    id: input
    property alias showBusy: spinner.running
    platformStyle: TextFieldStyle {
        backgroundSelected: "image://theme/" + appWindow.themeColor + "-meegotouch-textedit-background-selected"
    }

    Image {
        id: editIcon
        source: input.text.length > 0 ? "image://theme/icon-m-input-clear" : "image://theme/icon-m-common-search"
        anchors.right: parent.right
        anchors.rightMargin: (parent.height - height) / 2
        anchors.verticalCenter: parent.verticalCenter
        opacity: iconMouseArea.pressed && input.text.length > 0 ? 0.5 : 1.0
        visible: !spinner.visible
    }

    BusyIndicator {
        id: spinner
        anchors.right: parent.right
        anchors.rightMargin: (parent.height - height) / 2
        anchors.verticalCenter: parent.verticalCenter
        platformStyle: BusyIndicatorStyle { size: "small"; inverted: false }
        visible: running
    }

    MouseArea {
        id: iconMouseArea
        anchors.fill: editIcon
        onClicked: { input.text = ""; input.forceActiveFocus() }
        z: 2
        enabled: !spinner.visible
    }
}
