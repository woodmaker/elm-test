module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
import Url
import Url.Parser exposing ((</>))



-- MODEL


type Route
    = Home
    | Author
    | Idk


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , route : Route
    }



-- INIT


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url ( routeByUrl url ), Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


routeParser : Url.Parser.Parser ( Route -> a ) a
routeParser =
    Url.Parser.oneOf
        [ Url.Parser.map Home   ( Url.Parser.s "home" )
        , Url.Parser.map Author ( Url.Parser.s "author" )
        ]


routeByUrl : Url.Url -> Route
routeByUrl url =
    case ( Url.Parser.parse routeParser url ) of
        Nothing -> Idk
        Just val -> val

routeByString : String -> Route
routeByString url =
    case ( Url.fromString url ) of
        Nothing -> Idk
        Just val -> routeByUrl val


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
            ( { model | url = url, route = routeByUrl url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "URL Interceptor"
    , body =
        [ (content >> toUnstyled) model
        ]
    }


content : Model -> Html Msg
content model =
    div
        [ css
            [ backgroundColor (hex "ffffff")
            , padding (px 7)
            ]
        ]
        [ div []
            [ div [] [ text (Url.toString model.url) ]
            , a [ href "author" ] [ text "about me" ]
            , text " "
            , a [ href "home" ] [ text "go home" ]
            , text " "
            , case model.route of
                Home -> text "at home"
                Author -> text "at author"
                Idk -> text "at idk"
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
