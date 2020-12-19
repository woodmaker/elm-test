module Router exposing (routeByUrl, routeByString)

import Url
import Url.Parser

import Models exposing (Route(..))





routeParser : Url.Parser.Parser ( Route -> a ) a
routeParser =
    Url.Parser.oneOf
        [ Url.Parser.map Home   ( Url.Parser.s "home" )
        , Url.Parser.map About  ( Url.Parser.s "about" )
        ]

-- TODO: remove Home, Author from here a put on common place (to models)

--type alias Path =
--    (String, Maybe Path)
--docsParser : Parser (Route -> a) a
--docsParser =
--  map Tuple.pair (string </> fragment identity)


routeByUrl : Url.Url -> Route
routeByUrl url =
    case ( Url.Parser.parse routeParser url ) of
        Nothing -> E404
        Just val -> val

routeByString : String -> Route
routeByString url =
    case ( Url.fromString url ) of
        Nothing -> E404
        Just val -> routeByUrl val