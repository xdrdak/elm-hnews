module Main exposing (main)

import Html
import App exposing (init, update, view)


main =
    Html.program
        { init = init "Top"
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
