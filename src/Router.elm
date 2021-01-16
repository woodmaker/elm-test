module Router exposing (routeByString, routeByUrl)

import Model exposing (Route(..))
import Url
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string, top)


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Article (s "articles" </> string)
        , map Articles (s "articles")
        , map About (s "about")
        , map Articles top
        ]


routeByUrl : Url.Url -> Route
routeByUrl url =
    case parse routeParser url of
        Nothing ->
            E404

        Just val ->
            val


routeByString : String -> Route
routeByString url =
    case Url.fromString url of
        Nothing ->
            E404

        Just val ->
            routeByUrl val
