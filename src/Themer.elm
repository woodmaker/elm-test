module Themer exposing (Theme, initTheme, updateTheme)

{-| Manage color theme of the web app.

Theme is a set of colors which change during the day.


# Type, initial value, update function

@docs Theme, initTheme, updateTheme

-}

import Css exposing (Color, Compatible, Style, Value, rgb)
import Time


type alias Theme =
    { fg : Color
    , bg : Color
    , primary : Color
    , fgDark : Color
    , bgDark : Color
    , primaryDark : Color
    }


{-| Initial Theme is gray.
-}
initTheme : Theme
initTheme =
    { fg = rgb 64 64 64
    , bg = rgb 255 255 255
    , primary = rgb 64 192 255
    , fgDark = rgb 191 191 191
    , bgDark = rgb 31 31 31
    , primaryDark = rgb 31 192 223
    }


{-| Update theme with the current time. Product theme has a color of the moment.

At 10:00 it is blue,
at 14:00 it is teal (blue-green),
at 18:00 it is green,
at 22:00 it is brown (green-red),
and so on.

There are 3 color channels - R (red), G (green) and B (blue).

As time goes during day, these channels change their values:

     h  R     G     B     RGB
     2  ...|  ./    .\    63 21 21  red
     6  ../   |     ..\   42  0 42  purple
    10  ./    .\    ...|  21 21 63  blue
    14  |     ..\   ../    0 42 42  teal
    18  .\    ...|  ./    21 63 21  green
    22  ..\   ../   |     42 42  0  brown
     2  ...|  ./    .\    63 21 21  red

The difference of color value is then used to adjust theme colors.

-}
updateTheme : Time.Zone -> Time.Posix -> Theme
updateTheme zone time =
    let
        rd =
            colorChange offset.red zone time

        gd =
            colorChange offset.green zone time

        bd =
            colorChange offset.blue zone time

        primDarkBase =
            64
    in
    { fg = rgb 64 64 64
    , bg = rgb 255 255 255
    , primary = rgb (rd * 4) (gd * 2) (bd * 4)
    , fgDark = rgb 224 224 224
    , bgDark = rgb 48 48 48
    , primaryDark =
        rgb
            (63 + (rd + 1) * 3)
            (63 + (gd + 1) * 3)
            (63 + (bd + 1) * 3)
    }



-- Internal logic


{-| Blue is 0 at 0:00, green at 8:00 and red at 16:00
-}
offset =
    { red = 16
    , green = 8
    , blue = 0
    }


{-| value of Red at 18:00 == Blue at 2:00

offsetHour 16 18 = 2

-}
offsetHour : Int -> Int -> Int
offsetHour colourOffset hour =
    modBy 24 (hour + 24 - colourOffset)


{-| Transforms time+offset into a color value.

We change color with offset to be able to apply the same color value formula.

    hour  Value
       2  .\..  21
       6  ..\.  42
    8-12  ...|  63
      14  ../.  42
      18  ./..  21
    20-0  |...  0
       2  .\..  21

  - 0:00 - 7:59 am it's raising.
  - 8:00 - 11:59 am it's up on 63.
  - 12:00 - 19:59 pm it's decreasing.
  - 20:00 - 23:59 pm its down on 0.

There are 64 color values. For 0:00-7:59 there are 8 hours, so 8 values for every hour. If we separate hours, it's new color value every 450 seconds.

-}
colorChange : Int -> Time.Zone -> Time.Posix -> Int
colorChange timeOffset zone time =
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

    else if am then
        8 * h + (m * 60 + s) // 450

    else
        8 * (7 - h) + (7 - (m * 60 + s) // 450)



-- I really hope there will not ever be 23:60
