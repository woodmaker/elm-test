module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
import Url
import Url.Parser exposing ((</>))

import Router exposing (routeByString, routeByUrl)
import Models exposing (Model, Route(..))



-- INIT


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key ( routeByUrl url ), Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


type alias StyledDocument =
    { title : String
    , body : Html Msg
    }



view : Model -> Browser.Document Msg
view model =
    { title = "URL Interceptor"
    , body =
        [ ( content >> toUnstyled ) model ]
    }

content : Model -> Html Msg
content model =
    div
        [ css
            [ backgroundColor ( hex "fff" )
            , padding ( px 7 )
            ]
        ]
        [ menu model
        , siteContent model
        ]

menu : Model -> Html Msg
menu model =
    nav []
        [ ul []
        -- TODO make this into some generated list
        -- maybe put "at micka" aside, non-clickable
            [ li []
                [ a
                    [ href "home" ]
                    [ text "at micka" ]
                ]
            , li []
                [ a
                    [ href "about" ]
                    [ text "about" ]
                ]
            ]
        ]


siteContent : Model -> Html Msg
siteContent model =
    p
        []
        [ case model.route of
            Home -> text "at home"
            About -> text "at about"
            E404 -> text "at idk"
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
