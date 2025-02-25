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
import "UIConstants.js" as UI
import "Utilities.js" as Utilities

Page {
    orientationLock: PageOrientation.LockPortrait
    anchors.rightMargin: UI.MARGIN_XLARGE
    anchors.leftMargin: UI.MARGIN_XLARGE
    pageStack: parent
    enabled: !spotifySession.offlineMode

    Connections {
        target: spotifySession
        onOfflineModeChanged: {
            if (spotifySession.offlineMode)
                pageStack.pop(null);
        }
        onConnectionStatusChanged: {
            if (spotifySession.connectionStatus != SpotifySession.LoggedIn)
                pageStack.pop(null);
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: spotifySession.offlineMode
        anchors.rightMargin: -UI.MARGIN_XLARGE
        anchors.leftMargin: -UI.MARGIN_XLARGE
        color: theme.inverted ? "#DD000000" : "#DDFFFFFF"
        z: 500

        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Search is not available in offline mode"
            font.pixelSize: UI.FONT_XLARGE
            font.family: UI.FONT_FAMILY_LIGHT
            font.weight: Font.Light
            wrapMode: Text.WordWrap
            width: parent.width - UI.MARGIN_XLARGE * 2
            horizontalAlignment: Text.AlignHCenter
        }
    }

    SpotifySearch {
        id: search
    }

    TrackMenu {
        id: menu
        deleteVisible: false
    }

    AlbumMenu {
        id: albumMenu
        playVisible: true
        artistVisible: true
        albumBrowse: SpotifyAlbumBrowse {
            id: menuAlbumBrowse
            onTracksChanged: albumMenu.open()
        }
    }

    Column {
        id: header
        width: parent.width
        anchors.top: parent.top
        spacing: UI.MARGIN_XLARGE

        Column {
            width: parent.width
            Selector {
                id: selector
                title: "Search"
                titleFontFamily: UI.FONT_FAMILY_LIGHT
                titleFontWeight: Font.Light
                titleFontSize: UI.FONT_LARGE
                selectedIndex: 0
                model: ListModel {
                    ListElement { name: "Tracks" }
                    ListElement { name: "Albums" }
                    ListElement { name: "Artists" }
                }
            }
            Separator {
                width: parent.width
            }
        }

        AdvancedTextField {
            id: searchField
            placeholderText: "Search"
            width: parent.width
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            showBusy: search.busy
            platformSipAttributes: SipAttributes {
                actionKeyLabel: "Close"
                actionKeyEnabled: true
            }
            onTextChanged: {
                search.query = Utilities.trim(text)
                search.search()
            }
            Keys.onReturnPressed: { results.focus = true }
        }

        Separator {
            width: parent.width
        }
    }

    Item {
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: UI.MARGIN_XLARGE
        anchors.rightMargin: -UI.MARGIN_XLARGE
        anchors.leftMargin: -UI.MARGIN_XLARGE
        clip: true

        ListView {
            id: results
            anchors.fill: parent
            anchors.rightMargin: UI.MARGIN_XLARGE
            anchors.leftMargin: UI.MARGIN_XLARGE
            onMovementStarted: results.focus = true
            cacheBuffer: 8000

            Component.onCompleted: positionViewAtBeginning()

            Component {
                id: trackComponent
                TrackDelegate {
                    name: modelData.name
                    artistAndAlbum: modelData.artists + " | " + modelData.album
                    duration: modelData.duration
                    highlighted: modelData.isCurrentPlayingTrack
                    starred: modelData.isStarred
                    available: modelData.isAvailable
                    onClicked: modelData.play()
                    onPressAndHold: { menu.track = modelData; menu.open(); }
                }
            }
            Component {
                id: albumComponent
                AlbumDelegate {
                    name: modelData.name
                    artist: modelData.artist
                    albumCover: modelData.coverId
                    onClicked: { mainPage.tabs.currentTab.push(Qt.resolvedUrl("AlbumPage.qml"), { album: modelData }) }
                    onPressAndHold: {
                        menuAlbumBrowse.album = modelData;
                        if (menuAlbumBrowse.totalDuration > 0)
                            albumMenu.open()
                    }
                }
            }
            Component {
                id: artistComponent
                ArtistDelegate {
                    name: modelData.name
                    portrait: modelData.pictureId
                    onClicked: { mainPage.tabs.currentTab.push(Qt.resolvedUrl("ArtistPage.qml"), { artist: modelData }) }
                }
            }

            Connections {
                target: selector
                onSelectedIndexChanged: results.updateResults()
            }

            Connections {
                target: search
                onResultsChanged: results.updateResults()
            }

            function updateResults() {
                results.model = 0
                results.delegate = null
                if (selector.selectedIndex === 0) {
                    results.delegate = trackComponent
                    results.model = search.tracks
                } else if (selector.selectedIndex == 1) {
                    results.delegate = albumComponent
                    results.model = search.albums
                } else if (selector.selectedIndex == 2) {
                    results.delegate = artistComponent
                    results.model = search.artists
                }
            }
        }

        Label {
            id: errorMessage
            anchors.horizontalCenter: parent.horizontalCenter
            y: 80
            visible: results.count === 0 && search.query.length > 0 && !search.busy
            font.pixelSize: UI.FONT_LARGE
            font.family: UI.FONT_FAMILY_LIGHT
            font.weight: Font.Light
            wrapMode: Text.WordWrap
            width: parent.width - UI.MARGIN_XLARGE * 2
            horizontalAlignment: Text.AlignHCenter

            text: search.didYouMean.length > 0 ? "Did you mean"
                                               : (selector.selectedIndex === 0 ? "No tracks found" :
                                                  selector.selectedIndex == 1 ? "No albums found" :
                                                  "No artists found")
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: errorMessage.bottom
            visible: results.count === 0 && search.query.length > 0 && !search.busy && search.didYouMean.length > 0
            font.pixelSize: UI.FONT_LARGE
            font.family: UI.FONT_FAMILY_LIGHT
            font.weight: Font.Light
            wrapMode: Text.WordWrap
            width: parent.width - UI.MARGIN_XLARGE * 2
            horizontalAlignment: Text.AlignHCenter

            text: "<style type=text/css> a { text-decoration: underline; color:" + UI.SPOTIFY_COLOR + "} </style><a href='didyoumean'>" + search.didYouMean + "</a> ?"

            onLinkActivated: searchField.text = search.didYouMean
        }

        Scrollbar { listView: results }
    }
}
