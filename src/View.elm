module View exposing (view)

import Browser
import Css exposing (..)
import CssMediaDarkMode exposing (cssDark)
import Html.Lazy exposing (lazy)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
import Model exposing (Article, Model, Msg, Route(..))
import Themer exposing (Theme)


type alias Props =
    { route : Route
    , theme : Theme
    , content : Maybe String
    , article : Article
    }


view : Model -> Browser.Document Msg
view model =
    browserApp
        { route = model.route
        , theme = model.theme
        , content = model.content
        , article = model.article
        }


browserApp : Props -> Browser.Document Msg
browserApp props =
    { title = "@micka"
    , body =
        [ lazy (bodyLayout >> toUnstyled) props ]
    }


bodyLayout : Props -> Html Msg
bodyLayout props =
    div
        [ css
            [ color props.theme.fg
            , backgroundColor props.theme.bg
            , padding (px 7)
            , maxWidth (px 800)
            , marginLeft auto
            , marginRight auto
            , cssDark
                [ color props.theme.fgDark
                , backgroundColor props.theme.bgDark
                ]
            ]
        ]
        [ menu props
        , sectionContent props
        ]


linkStyle : Themer.Theme -> Style
linkStyle theme =
    Css.batch
        [ color theme.primary
        , cssDark [ color theme.primaryDark ]
        , textDecoration none
        , hover [ textDecoration underline ]
        ]


linkSelectedStyle : Themer.Theme -> Style
linkSelectedStyle theme =
    Css.batch
        [ linkStyle theme
        , textDecoration underline
        ]


menu : Props -> Html Msg
menu { route, theme } =
    let
        link =
            linkStyle theme

        selectedLink =
            linkSelectedStyle theme
    in
    p []
        [ b []
            [ text "u micky" ]
        , text " - "
        , a
            [ href "/articles"
            , css
                [ if route == Articles then
                    selectedLink

                  else
                    link
                ]
            ]
            [ text "věci" ]
        , text ", "
        , a
            [ href "/about"
            , css
                [ if route == About then
                    selectedLink

                  else
                    link
                ]
            ]
            [ text "o mně" ]
        ]


sectionContent : Props -> Html Msg
sectionContent props =
    p []
        [ case props.route of
            Articles ->
                articleView props.article

            Article a ->
                text a

            About ->
                text "Jsem micka a jsem linej pouzivat diakritiku."

            E404 ->
                text "404 ... asi nevim kde jsem"
        ]


articleView : Article -> Html Msg
articleView article =
    div []
        [ p []
            [ text
                (case article of
                    Model.Loading resource ->
                        "Loading: " ++ resource

                    Model.Ready content ->
                        content

                    Model.Error ->
                        "Nepovedlo se mi nacist prispevek. Sorry O.O"
                )
            ]
        ]
