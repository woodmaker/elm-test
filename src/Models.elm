module Models exposing (..)

import Browser
import Browser.Navigation
import Themer exposing (Theme)
import Time
import Url



-- TODO: move to Controller.elm maybe
type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Tick Time.Posix
    | AdjustTimeZone Time.Zone


type alias Model =
    { key : Browser.Navigation.Key
    , route : Route
    , theme : Theme
    , zone : Time.Zone
    , time : Time.Posix
    }


type Route
    = Home
    | About
    | E404
