module Themer exposing (..)

import Css exposing (Color, Compatible, Style, Value, rgb)
import Css.Media exposing (Expression, withMedia)
import Time


type alias Theme =
    { fg : Color
    , bg : Color
    , primary : Color
    , fgDark : Color
    , bgDark : Color
    , primaryDark : Color
    }


initTheme : Theme
initTheme =
    { fg = rgb 64 64 64
    , bg = rgb 255 255 255
    , primary = rgb 64 192 255
    , fgDark = rgb 191 191 191
    , bgDark = rgb 31 31 31
    , primaryDark = rgb 31 192 223
    }


offset =
    { red = 16
    , green = 8
    , blue = 0
    }


offsetHour : Int -> Int -> Int
offsetHour colourOffset hour =
    modBy 24 (hour + (24 - colourOffset))


colourChange : Int -> Time.Zone -> Time.Posix -> Int
colourChange timeOffset zone time =
    let
        hour =
            offsetHour timeOffset (Time.toHour zone time)

        am =
            hour < 12

        h =
            if am then
                hour

            else
                hour - 12

        m =
            Time.toMinute zone time

        s =
            Time.toSecond zone time
    in
    if h > 7 then
        if am then
            63

        else
            0

    else
        8 * (h + 1) + (m * 60 + s + 1) // 450 - 1


themeUpdate : Time.Zone -> Time.Posix -> Theme
themeUpdate zone time =
    let
        rd =
            colourChange offset.red zone time

        gd =
            colourChange offset.green zone time

        bd =
            colourChange offset.blue zone time
    in
    { fg = rgb 64 64 64
    , bg = rgb 255 255 255
    , primary = rgb 64 192 255
    , fgDark = rgb (192 + rd) (192 + gd) (192 + bd)
    , bgDark = rgb (32 + rd) (32 + gd) (32 + bd)
    , primaryDark = rgb (32 + rd) (192 + gd) (224 + bd)
    }


cssDark : List Style -> Style
cssDark styles =
    withMedia
        [ Css.Media.only
            Css.Media.screen
            [ prefersColorScheme dark ]
        ]
        styles


{-| Css.Media -like implementation of dark mode
-}
type Compatible
    = Compatible


type alias PrefersColorScheme a =
    { a | value : String, prefersColorScheme : Compatible }


{-| -}
type alias Dark =
    { value : String, prefersColorScheme : Compatible }


{-| -}
type alias Light =
    { value : String, prefersColorScheme : Compatible }


{-| CSS value [`landscape`](https://drafts.csswg.org/mediaqueries/#valdef-media-orientation-portrait)
-}
dark : Dark
dark =
    { value = "dark", prefersColorScheme = Compatible }


{-| CSS value [`portrait`](https://drafts.csswg.org/mediaqueries/#valdef-media-orientation-portrait)
-}
light : Light
light =
    { value = "light", prefersColorScheme = Compatible }


{-| Media feature [`prefers-color-scheme`](https://drafts.csswg.org/mediaqueries/#orientation).
Accepts `portrait` or `landscape`.
-}
prefersColorScheme : PrefersColorScheme a -> Expression
prefersColorScheme value =
    feature "prefers-color-scheme" value


feature : String -> Value a -> Expression
feature key { value } =
    { feature = key, value = Just value }
