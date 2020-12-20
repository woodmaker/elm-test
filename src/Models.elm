module Models exposing (..)
import Browser.Navigation
import Css exposing (Color)
import Time




type alias Model =
    { key : Browser.Navigation.Key
    , route : Route
    , theme : Theme
    , zone : Time.Zone
    , time : Time.Posix
    }


type alias Theme =
    { fg : Color
    , bg : Color
    }



type Route
    = Home
    | About
    | E404


