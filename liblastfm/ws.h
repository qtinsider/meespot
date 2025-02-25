/*
   Copyright 2009 Last.fm Ltd.
      - Primarily authored by Max Howell, Jono Cole and Doug Mansell

   This file is part of liblastfm.

   liblastfm is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   liblastfm is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with liblastfm.  If not, see <http://www.gnu.org/licenses/>.
*/
#ifndef LASTFM_WS_H
#define LASTFM_WS_H

#include "global.h"
#include <QDateTime>
#include <QMap>
#include <QNetworkReply>
#include <stdexcept>


namespace lastfm
{
    /** if you don't set one, we create our own, our own is pretty good
      * for instance, it auto detects proxy settings on windows and mac
      * We take ownership of the NAM, do not delete it out from underneath us!
      * So don't keep any other pointers to this around in case you accidently
      * call delete on them :P */
    void setNetworkAccessManager( QNetworkAccessManager* nam );
    QNetworkAccessManager* nam();

    namespace ws
    {
        /** both of these are provided when you register at http://last.fm/api */
        extern const char* SharedSecret;
        extern const char* ApiKey;

        /** you need to set this for scrobbling to work (for now)
          * Also the AuthenticatedUser class uses it */
        extern QString Username;

        /** Some webservices require authentication. See the following
          * documentation:
          * http://www.last.fm/api/authentication
          * http://www.last.fm/api/desktopauth
          * You have to authenticate and then assign to SessionKey, liblastfm does
          * not do that for you. Also we do not store this. You should store this!
          * You only need to authenticate once, and that key lasts forever!
          */
        extern QString SessionKey;

        enum Error
        {
            NoError = 1, // because last.fm error numbers start at 2

            /** numbers follow those at http://last.fm/api/ */
            InvalidService = 2,
            InvalidMethod,
            AuthenticationFailed,
            InvalidFormat,
            InvalidParameters,
            InvalidResourceSpecified,
            OperationFailed,
            InvalidSessionKey,
            InvalidApiKey,
            ServiceOffline,
            SubscribersOnly,

            Reserved13,
            Reserved14,
            Reserved15,

            /** Last.fm sucks.
              * There may be an error in networkError(), or this may just be some
              * internal error completing your request.
              * Advise the user to try again in a _few_minutes_.
              * For some cases, you may want to try again yourself, at this point
              * in the API you will have to. Eventually we will discourage this and
              * do it for you, as we don't want to strain Last.fm's servers
              */
            TryAgainLater = 16,

            Reserved17,
            Reserved18,
            Reserved19,

            NotEnoughContent = 20,
            NotEnoughMembers,
            NotEnoughFans,
            NotEnoughNeighbours,
            NoPeakRadio,
            RadioNotFound,
            APIKeySuspended,

            Reserved27,
            Reserved28,

            RateLimitExceeded = 29,

            /** Last.fm fucked up, or something mangled the response on its way */
            MalformedResponse = 100,

            /** call QNetworkReply::error() as it's nothing to do with us */
            UnknownError
        };

        /** the map needs a method entry, as per http://last.fm/api */
        QNetworkReply* get( QMap<QString, QString> );
        /** generates api sig, includes api key, and posts, don't add the api
          * key yourself as well--it'll break */
        QNetworkReply* post( QMap<QString, QString> );


        class ParseError : public std::runtime_error
        {
            Error e;

        public:
            explicit ParseError(Error e);
            ~ParseError() throw();

            Error enumValue() const;
        };

        /** Generally you don't use this, eg. if you called Artist::getInfo(),
          * use the Artist::getInfo( QNetworkReply* ) function to get the
          * results, you have to pass a QDomDocument because QDomElements stop
          * existing when the parent DomDocument is deleted.
          *
          * The QByteArray is basically reply->readAll(), so all this function
          * does is sanity check the response and throw if it is bad.
          *
          * Thus if you don't care about errors just do: reply->readAll()
          *
          * Not caring about errors is often fine with Qt as you just get null
          * strings and that instead, and you can handle those as you go.
          *
          * The QByteArray is an XML document. You can parse it with QDom or
          * use our much more convenient lastfm::XmlQuery.
          */
        QByteArray parse( QNetworkReply* reply ) throw( ParseError );

        /** returns the expiry date of this HTTP response */
        QDateTime expires( QNetworkReply* );
    }
}


inline QDebug operator<<( QDebug d, QNetworkReply::NetworkError e )
{
    return d << lastfm::qMetaEnumString<QNetworkReply>( e, "NetworkError" );
}

#define LASTFM_WS_HOSTNAME "ws.audioscrobbler.com"

#endif
