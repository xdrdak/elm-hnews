module Components.HeaderMenu exposing (viewHeader)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias MenuItem =
    { href : String
    , text : String
    }


menuItems : List MenuItem
menuItems =
    [ { href = "#0", text = "top" }
    , { href = "#0", text = "new" }
    , { href = "#0", text = "show" }
    , { href = "#0", text = "ask" }
    , { href = "#0", text = "jobs" }
    ]


viewHeaderLogo : String -> Html msg
viewHeaderLogo url =
    div []
        [ img [ src url, class "logo" ] []
        ]


viewMenuItem : MenuItem -> Html msg
viewMenuItem item =
    li [ class "menu__item" ]
        [ a [ href item.href ] [ text item.text ]
        ]


viewMenu : Html msg
viewMenu =
    div []
        [ menuItems
            |> List.map viewMenuItem
            |> ul [ class "menu" ]
        ]


viewMenuAbout : Html msg
viewMenuAbout =
    div []
        [ a [ href "#0" ] [ text "About" ] ]


viewHeader : Html msg
viewHeader =
    header []
        [ viewHeaderLogo "/public/img/logo.svg"
        , viewMenu
        , viewMenuAbout
        ]
