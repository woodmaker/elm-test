module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html.Styled exposing (..)
import Models exposing (Model, Msg(..), Route(..))
import Router exposing (routeByString, routeByUrl)
import Task
import Themer exposing (initTheme, updateTheme)
import Time
import Url
import View exposing (view)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- INIT


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model
        key
        (routeByUrl url)
        initTheme
        Time.utc
        (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE
-- TODO: move to Controller.elm


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( { model | route = routeByUrl url }
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( { model | route = routeByString href }
                    , Nav.load href
                    )

        UrlChanged url ->
            ( { model | route = routeByUrl url }
            , Cmd.none
            )

        Tick now ->
            ( { model
                | theme = updateTheme model.zone now
                , time = now
              }
            , Cmd.none
            )

        AdjustTimeZone zone ->
            ( { model
                | zone = zone
              }
            , Task.perform Tick Time.now
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick



-- VIEW


type alias StyledDocument =
    { title : String
    , body : Html Msg
    }
