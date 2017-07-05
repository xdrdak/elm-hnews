module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events
import Mock.ArticleList
import Components.HeaderMenu
import Components.ArticleList
import Http
import Json.Decode
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


-- MODELS


type alias Model =
    { value : Int
    , articles : List Components.ArticleList.Article
    , fetchedArticles : List Int
    , tempStory : Story
    }


emptyStoryRecord =
    { by = "yyy"
    , descendants = 1
    , id = 1
    , kids = []
    , score = 1
    , time = 1
    , title = "aaa"
    , typeOf = "bbb"
    , url = "ccc"
    }


init : String -> ( Model, Cmd Msg )
init topic =
    ( { value = 0
      , articles = Mock.ArticleList.mockArticles
      , fetchedArticles = []
      , tempStory = emptyStoryRecord
      }
    , getStoriesIds topic
    )



-- UPDATE


type Msg
    = Stories (Result Http.Error (List Int))
    | TryGetOneStory (Result Http.Error Story)
    | TryThis


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Stories (Ok fetchedArticles) ->
            ( { model | fetchedArticles = fetchedArticles }, Cmd.none )

        Stories (Err _) ->
            ( model, Cmd.none )

        TryGetOneStory (Ok story) ->
            ( { model | tempStory = story }, Cmd.none )

        TryGetOneStory (Err _) ->
            ( model, Cmd.none )

        TryThis ->
            ( model, getStory "8863" )



-- VIEWS
-- TODO: Move this to a seperate `.elm` file.
-- TODO: Use chevrons instead of `<` or `>`


viewPageSelector =
    div [ class "page-selector" ]
        [ div [] [ text "< prev" ]
        , div [] [ text "0/25" ]
        , div [] [ text "next >" ]
        , button [ Html.Events.onClick TryThis ] [ text "Try get 1 story" ]
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


buildStoriesIdFetchUrl : String -> String
buildStoriesIdFetchUrl t =
    "https://hacker-news.firebaseio.com/v0/" ++ t ++ "stories.json?print=pretty"


validFilters : List String
validFilters =
    [ "top", "new", "best" ]


decodeStoriesIds : Json.Decode.Decoder (List Int)
decodeStoriesIds =
    (Json.Decode.list Json.Decode.int)


getStoriesIds : a -> Cmd Msg
getStoriesIds filterType =
    let
        url =
            "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"
    in
        Http.send Stories (Http.get url decodeStoriesIds)


type alias Story =
    { by : String
    , descendants : Int
    , id : Int
    , kids : List Int
    , score : Int
    , time : Int
    , title : String
    , typeOf : String
    , url : String
    }


storyDecoder : Json.Decode.Decoder Story
storyDecoder =
    decode Story
        |> Json.Decode.Pipeline.required "by" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "descendants" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "kids" (Json.Decode.list Json.Decode.int)
        |> Json.Decode.Pipeline.required "score" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "time" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "title" (Json.Decode.string)
        |> Json.Decode.Pipeline.optional "typeOf" (Json.Decode.string) "---"
        |> Json.Decode.Pipeline.required "url" (Json.Decode.string)


getStory : String -> Cmd Msg
getStory id =
    let
        url =
            ("https://hacker-news.firebaseio.com/v0/item/" ++ id ++ ".json?print=pretty")
    in
        Http.send TryGetOneStory (Http.get url storyDecoder)
