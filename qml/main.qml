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
import QtSpotify 1.0

PageStackWindow {
    id: appWindow
    property string themeColor
    style:  PageStackWindowStyle {
        background: theme.inverted ? "image://theme/meegotouch-video-background"
                                   : "image://theme/meegotouch-applicationpage-background"
        backgroundFillMode: Image.Stretch
    }

    initialPage: spotifySession.isLoggedIn ? mainPage : loginPage

    Component {
        id: mainPage
        MainPage {
            id: mainPageItem
            onToolsChanged: appWindow.pageStack.toolBar.setTools(mainPageItem.tools, "replace")
        }
    }

    Component {
        id: loginPage
        LoginPage { }
    }

    Component.onCompleted: {
        theme.inverted = spotifySession.invertedTheme;
        themeColor = "color2"
        if (!spotifySession.isOnline && (!spotifySession.user || !spotifySession.offlineMode))
            openConnection();
    }

    function openConnection() {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "http://m.google.com"); //force opening a connection
        xhr.send();
    }

    Connections {
        target: spotifySession
        onIsOnlineChanged: {
            if (!spotifySession.isOnline && (!spotifySession.user || !spotifySession.offlineMode))
                openConnection();
        }
        onOfflineModeChanged: {
            if (!spotifySession.isOnline && (!spotifySession.user || !spotifySession.offlineMode))
                openConnection();
        }
        onPendingConnectionRequestChanged: {
            if (!spotifySession.pendingConnectionRequest && spotifySession.isLoggedIn) {
                pageStack.replace(mainPage)
            } else if (spotifySession.pendingConnectionRequest && spotifySession.isLoggedIn) {
                pageStack.replace(loginPage)
            }
        }
    }
}
