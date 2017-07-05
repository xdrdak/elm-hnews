module Components.ArticleList exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias ArticleMeta =
    { points : Int
    , author : String
    , commentCount : Int
    }


type alias Article =
    { id : Int
    , score : Int
    , title : String
    }


articleMeta : ArticleMeta -> Html msg
articleMeta meta =
    div []
        [ p [ class "meta" ]
            [ text (toString meta.points ++ " points by ")
            , a [ href "#0" ] [ text meta.author ]
            , text " | "
            , a [ href "#0" ] [ text (toString meta.commentCount ++ " comments") ]
            ]
        ]


articleTitle : String -> Html msg
articleTitle title =
    div []
        [ a [ href "#0", class "article-title" ]
            [ text title ]
        ]


article : Article -> Html msg
article a =
    div [ class "news-article" ]
        [ div [ class "news-article__id" ]
            [ p [] [ text <| toString a.id ]
            ]
        , div [ class "news-article__content" ]
            [ articleTitle a.title
            , articleMeta { points = 21, author = "Author", commentCount = 100 }
            ]
        ]


viewArticleList : List Article -> Html msg
viewArticleList articles =
    articles
        |> List.map article
        |> div [ class "container" ]
