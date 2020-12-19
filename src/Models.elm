module Models exposing (..)
import Browser.Navigation



type alias Model =
    { key : Browser.Navigation.Key
    , route : Route
    }



type Route
    = Home
    | About
    | E404


