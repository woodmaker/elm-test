module View exposing (view)

import Browser
import Css exposing (..)
import CssMediaDarkMode exposing (cssDark)
import Html.Lazy exposing (lazy)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
import Model exposing (Article, Model, Msg, Route(..))
import String exposing (join, lines)
import Themer exposing (Theme)


type alias Props =
    { route : Route
    , theme : Theme
    , article : Article
    }


view : Model -> Browser.Document Msg
view model =
    browserApp
        { route = model.route
        , theme = model.theme
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
                articleView props.article props.theme

            Article a ->
                text a

            About ->
                text "Jsem micka a jsem linej pouzivat diakritiku."

            E404 ->
                text "404 ... asi nevim kde jsem"
        ]


articleView : Article -> Theme -> Html Msg
articleView article theme =
    div []
        [ p []
            (case article of
                Model.Loading resource ->
                    [ text ("Loading: " ++ resource) ]

                Model.Ready content ->
                    mdToElements content theme

                Model.Error ->
                    [ text ("Nepovedlo se mi nacist prispevek. Sorry O.O") ]

            )
        ]

mdToElements : String -> Theme -> List (Html Msg)
mdToElements markdownText theme =
    List.map strlToP (mdElements markdownText)

strlToP : List(String) -> Html Msg
strlToP lines =
    p [] [ text (join " " lines) ]


--- we read md file line by line
--- mdElement is list of lines with empty line around

mdElements : String -> List(List(String))
mdElements markdownText =
    mdElementsX (lines markdownText) []


mdElementsX : List(String) -> List(String) -> List(List(String))
mdElementsX unparsedLines currentLines =
    case unparsedLines of
        line :: restOfLines ->
            case line of
                "" ->
                    case currentLines of
                        [] ->
                            mdElementsX restOfLines []
                        _ ->
                            currentLines :: mdElementsX restOfLines []

                _ ->
                    mdElementsX restOfLines (currentLines ++ [line])
        [] ->
                    case currentLines of
                        [] ->
                            []
                        _ ->
                            [currentLines]

