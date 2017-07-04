module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Mock.ArticleList
import Components.HeaderMenu
import Components.ArticleList
import Http
import Json.Decode as Decode
import Debug exposing (..)


-- MODELS


type alias Model =
    { value : Int
    , articles : List Components.ArticleList.Article
    , fetchedArticles : List Int
    }


init : String -> ( Model, Cmd Msg )
init topic =
    ( { value = 0
      , articles = Mock.ArticleList.mockArticles
      , fetchedArticles = []
      }
    , getStories topic
    )



-- UPDATE


type Msg
    = Stories (Result Http.Error (List Int))


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Stories (Ok fetchedArticles) ->
            ( Model model.value model.articles fetchedArticles, Cmd.none )

        Stories (Err _) ->
            ( model, Cmd.none )



-- VIEWS
-- TODO: Move this to a seperate `.elm` file.
-- TODO: Use chevrons instead of `<` or `>`


viewPageSelector =
    div [ class "page-selector" ]
        [ div [] [ text "< prev" ]
        , div [] [ text "0/25" ]
        , div [] [ text "next >" ]
        ]


view model =
    div []
        [ Components.HeaderMenu.viewHeader
        , viewPageSelector
        , Components.ArticleList.viewArticleList model.articles
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


buildStoriesIdFetchUrl t =
    "https://hacker-news.firebaseio.com/v0/" ++ t ++ "stories.json?print=pretty"


validFilters =
    [ "top", "new", "best" ]


decodeStoryIds =
    (Decode.list Decode.int)


getStories filterType =
    let
        url =
            "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"
    in
        Http.send Stories <|
            Http.get url decodeStoryIds
