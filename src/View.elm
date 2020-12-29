module View exposing (view)


import Browser
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
import CssMediaDarkMode exposing (cssDark)
import Models exposing (Model, Msg, Route(..))
import Themer
import Time



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


menuLinkSelected : Themer.Theme -> Style
menuLinkSelected theme =
    Css.batch
        [ textDecoration2 underline dashed ]


menu : Model -> Html Msg
menu model =
    let
        link =
            menuLink model.theme
        selected =
            menuLinkSelected model.theme
    in
    p []
        [ b []
            [ text "at micka" ]
        , text " - "
        , a
            [ href "articles", css [ link ] ]
            [ text "articles" ]
        , text ", "
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
