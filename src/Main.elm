module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html.Styled exposing (..)
import Http
import Model exposing (Article, Model, Msg(..), Route(..))
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
    let
        route =
            routeByUrl url
    in
    ( Model
        key
        route
        initTheme
        (Model.Loading (routeToResourceName route))
        Time.utc
        (Time.millisToPosix 0)
    , Cmd.batch
        ([ Task.perform SetTimeZone Time.here
         , Task.perform Tick Time.now
         ]
            ++ routeChangedActions (routeByUrl url)
        )
    )


routeToResourceName : Route -> String
routeToResourceName route =
    case route of
        Articles ->
            "articles"

        Article a ->
            a

        About ->
            "about"

        E404 ->
            "error"



-- UPDATE


routeChangedActions : Route -> List (Cmd Msg)
routeChangedActions route =
    case route of
        Articles ->
            [ Http.get
                { url = "/articles.md"
                , expect = Http.expectString SetArticle
                }
            ]

        Article _ ->
            []

        About ->
            []

        E404 ->
            []


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
            let
                route =
                    routeByUrl url
            in
            ( { model
                | article = Model.Loading (routeToResourceName route)
                , route = route
              }
            , Cmd.batch (routeChangedActions route)
            )

        Tick now ->
            ( { model
                | theme = updateTheme model.zone now
                , time = now
              }
            , Cmd.none
            )

        SetTimeZone zone ->
            ( { model
                | zone = zone
              }
            , Cmd.none
            )

        SetArticle result ->
            ( { model
                | article =
                    case result of
                        Ok content ->
                            Model.Ready content

                        Err _ ->
                            Model.Error
              }
            , Cmd.none
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
