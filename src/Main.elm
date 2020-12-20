module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
import Url

import Router exposing (routeByString, routeByUrl)
import Models exposing (Model, Route(..), Theme)


import Time
import Task










-- INIT

appTheme : Theme
appTheme =
  { fg = rgb 255 255 255
  , bg = rgb 0 0 0
  }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
  ( Model
    key
    ( routeByUrl url )
    appTheme
    Time.utc
    ( Time.millisToPosix 0 )
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
          , Nav.pushUrl model.key ( Url.toString url )
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
        | theme =
          { fg = rgb
            (64 - 24 + (Time.toHour model.zone now))
            (10*(Time.toHour model.zone now))
            (10*(Time.toHour model.zone now))
          , bg = rgb 255 255 255
          }
        , time = now
        }
      , Cmd.none
      )

    AdjustTimeZone zone ->
      ( { model
          | zone = zone
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



view : Model -> Browser.Document Msg
view model =
  { title = "@micka"
  , body =
    [ ( content >> toUnstyled ) model ]
  }

content : Model -> Html Msg
content model =
  div
    [ css
      [ backgroundColor model.theme.bg
      , color model.theme.fg
      , padding ( px 7 )
      ]
    ]
    [ menu model
    , siteContent model
    ]

menu : Model -> Html Msg
menu model =
  p []
    [ b []
      [ text "at micka" ]
    , text " "
    , a
      [ href "articles" ]
      [ text "articles" ]
    , text " "
    , a
      [ href "about" ]
      [ text "about" ]
    ]

siteContent : Model -> Html Msg
siteContent model =
  p []
    [ case model.route of
      Home -> text "at home"
      About -> text "at about"
      E404 -> text "at idk"
    , text
      ( ( String.fromInt ( Time.toHour model.zone model.time ) )
        ++ ":"
        ++ ( String.fromInt ( Time.toMinute model.zone model.time ) )
      )
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
