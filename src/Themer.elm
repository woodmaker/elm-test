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



theme : Theme
theme =
    { fg = rgb 64 64 64
    , bg = rgb 255 255 255
    , primary = rgb 64 192 255
    , fgDark = rgb 191 191 191
    , bgDark = rgb 31 31 31
    , primaryDark = rgb 31 192 223
    }



xx : Bool -> Int -> Int -> Int
xx desc hours seconds =
    let
        ad =
            if desc then
                1

            else
                -1
    in
    ad * 32 - modBy 450 (hours * 60 * 60 + seconds)


colourDiff : Int -> Time.Zone -> Time.Posix -> Int
colourDiff offset zone time =
    let
        ch =
            modBy 24 (24 - offset + Time.toHour zone time)

        cs =
            Time.toMinute zone time * 60 + Time.toSecond zone time
    in
    if List.member ch [ 0, 1, 2, 3, 4, 5, 6, 7 ] then
        xx True ch cs

    else if List.member ch [ 8, 9, 10, 11 ] then
        -32

    else if List.member ch [ 12, 13, 14, 15, 16, 17, 18, 19 ] then
        xx False (ch - 12) cs

    else
        32


themeUpdate : Time.Zone -> Time.Posix -> Theme
themeUpdate zone time =
    let
        rd =
            colourDiff 2 zone time

        gd =
            colourDiff 18 zone time

        bd =
            colourDiff 10 zone time
    in
    { fg = rgb 64 64 64
    , bg = rgb 255 255 255
    , primary = rgb 64 192 255
    , fgDark = rgb (191 + rd) (191 + gd) (191 + bd)
    , bgDark = rgb (31 + rd) (31 + gd) (31 + bd)
    , primaryDark = rgb (31 + rd) (192 + gd) (223 + bd)
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
