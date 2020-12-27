module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Css exposing (..)
import CssMediaDarkMode exposing (cssDark)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
import Models exposing (Model, Route(..))
import Router exposing (routeByString, routeByUrl)
import Task
import Themer exposing (initTheme, themeUpdate)
import Time
import Url



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


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Tick Time.Posix
    | AdjustTimeZone Time.Zone


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
                | theme = themeUpdate model.zone now
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


view : Model -> Browser.Document Msg
view model =
    { title = "@micka"
    , body =
        [ (content >> toUnstyled) model ]
    }


content : Model -> Html Msg
content model =
    div
        [ css
            [ color model.theme.fg
            , backgroundColor model.theme.bg
            , padding (px 7)
            , cssDark
                [ color model.theme.fgDark
                , backgroundColor model.theme.bgDark
                ]
            ]
        ]
        [ menu model
        , siteContent model
        ]


menuLink : Themer.Theme -> Style
menuLink theme =
    Css.batch
        [ color theme.primary
        , cssDark [ color theme.primaryDark ]
        , textDecoration none
        , hover [ textDecoration underline ]
        ]


menu : Model -> Html Msg
menu model =
    let
        link =
            menuLink model.theme
    in
    p []
        [ b []
            [ text "at micka" ]
        , text " "
        , a
            [ href "articles", css [ link ] ]
            [ text "articles" ]
        , text " "
        , a
            [ href "about", css [ link ] ]
            [ text "about" ]
        ]


siteContent : Model -> Html Msg
siteContent model =
    p []
        [ case model.route of
            Home ->
                text "at home"

            About ->
                text "at about"

            E404 ->
                text "at idk"
        , text
            (String.fromInt (Time.toHour model.zone model.time)
                ++ ":"
                ++ String.fromInt (Time.toMinute model.zone model.time)
            )
        , div []
            [ text (String.fromInt model.theme.fgDark.red)
            , text " "
            , text (String.fromInt model.theme.fgDark.green)
            , text " "
            , text (String.fromInt model.theme.fgDark.blue)
            ]
        ]



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
