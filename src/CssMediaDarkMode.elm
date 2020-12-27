module CssMediaDarkMode exposing
    ( cssDark
    , dark, light, prefersColorScheme
    )

{-| ['prefers-color-scheme'](https://www.w3.org/TR/mediaqueries-5/#prefers-color-scheme) extension of Css.Media for dark mode support.

@docs PrefersColorScheme Dark Light
@docs prefersColorScheme dark light
@docs cssDark


# Basic Usage

    import Css exposing (backgroundColor, color, css, rgb)
    import Css.Media exposing (only, screen, withMedia)
    import CssMediaDarkMode exposing (dark, prefersColorScheme)
    import Html.Styled exposing (div, text)

    content : Html Msg
    content =
        div
            [ css
                [ color (rgb 0 0 255)
                , backgroundColor (rgb 255 255 255)
                , withMedia
                    [ only
                        screen
                        [ prefersColorScheme dark ]
                    ]
                    [ color (rgb 255 255 0)
                    , backgroundColor (rgb 0 0 0)
                    ]
                ]
            ]
            [ text "I am yellow in dark mode and blue in light mode" ]


# Usage with cssDark function

    import Css exposing (backgroundColor, color, css, rgb)
    import CssMediaDarkMode exposing (cssDark)
    import Html.Styled exposing (div, text)

    content : Html Msg
    content =
        div
            [ css
                [ color (rgb 0 0 255)
                , backgroundColor (rgb 255 255 255)
                , cssDark
                    [ color (rgb 255 255 0)
                    , backgroundColor (rgb 0 0 0)
                    ]
                ]
            ]
            [ text "I am yellow in dark mode and blue in light mode" ]

-}

import Css
import Css.Media exposing (Expression, withMedia)


type alias PrefersColorScheme a =
    { a | value : String, prefersColorScheme : Compatible }


type alias Light =
    { value : String, prefersColorScheme : Compatible }


type alias Dark =
    { value : String, prefersColorScheme : Compatible }


{-| CSS value [`light`](https://www.w3.org/TR/mediaqueries-5/#valdef-media-prefers-color-scheme-light)
-}
light : Light
light =
    { value = "light", prefersColorScheme = Compatible }


{-| CSS value [`dark`](https://www.w3.org/TR/mediaqueries-5/#valdef-media-prefers-color-scheme-dark)
-}
dark : Dark
dark =
    { value = "dark", prefersColorScheme = Compatible }


{-| Media feature [`prefers-color-scheme`](https://www.w3.org/TR/mediaqueries-5/#descdef-media-prefers-color-scheme).
Accepts `light` or `dark`.
-}
prefersColorScheme : PrefersColorScheme a -> Expression
prefersColorScheme value =
    feature "prefers-color-scheme" value


{-| helper function for applying dark mode

See example on top of this file.

-}
cssDark : List Css.Style -> Css.Style
cssDark styles =
    withMedia
        [ Css.Media.only
            Css.Media.screen
            [ prefersColorScheme dark ]
        ]
        styles



{- Copy of not exported helper functions from Css.Media -}


type Compatible
    = Compatible


feature : String -> Css.Value a -> Expression
feature key { value } =
    { feature = key, value = Just value }
