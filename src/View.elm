module View exposing (view)

import Browser
import Css exposing (..)
import CssMediaDarkMode exposing (cssDark)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
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
            , maxWidth (px 800)
            , marginLeft auto
            , marginRight auto
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
        [ menuLink theme
        , textDecoration underline
        ]


menu : Model -> Html Msg
menu model =
    let
        link =
            menuLink model.theme

        selectedLink =
            menuLinkSelected model.theme
    in
    p []
        [ b []
            [ text "u micky" ]
        , text " - "
        , a
            [ href "articles"
            , css
                [ if model.route == Articles then
                    selectedLink

                  else
                    link
                ]
            ]
            [ text "věci" ]
        , text ", "
        , a
            [ href "about"
            , css
                [ if model.route == About then
                    selectedLink

                  else
                    link
                ]
            ]
            [ text "o mně" ]
        ]


siteContent : Model -> Html Msg
siteContent model =
    p []
        [ case model.route of
            Articles ->
                text "at articles"

            About ->
                text "Jsem micka a jsem linej pouzivat diakritiku."

            E404 ->
                text "404 ... asi nevim kde jsem"
        ]
