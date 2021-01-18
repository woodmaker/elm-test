module Model exposing (..)

import Browser
import Browser.Navigation
import Http
import Themer exposing (Theme)
import Time
import Url


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Tick Time.Posix
    | SetTimeZone Time.Zone
    | SetArticle (Result Http.Error String)


type alias Model =
    { key : Browser.Navigation.Key
    , route : Route
    , theme : Theme
    , article : Article
    , zone : Time.Zone
    , time : Time.Posix
    }


type Article
    = Loading String
    | Ready String
    | Error


type Route
    = Articles
    | Article String
    | About
    | E404
