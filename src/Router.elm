module Router exposing (routeByString, routeByUrl)

import Models exposing (Route(..))
import Url
import Url.Parser


routeParser : Url.Parser.Parser (Route -> a) a
routeParser =
    Url.Parser.oneOf
        [ Url.Parser.map Home (Url.Parser.s "home")
        , Url.Parser.map About (Url.Parser.s "about")
        ]


routeByUrl : Url.Url -> Route
routeByUrl url =
    case Url.Parser.parse routeParser url of
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
