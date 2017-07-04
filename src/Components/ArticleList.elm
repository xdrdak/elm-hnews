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


viewArticleMeta : ArticleMeta -> Html msg
viewArticleMeta meta =
    div []
        [ p [ class "meta" ]
            [ text (toString meta.points ++ " points by ")
            , a [ href "#0" ] [ text meta.author ]
            , text " | "
            , a [ href "#0" ] [ text (toString meta.commentCount ++ " comments") ]
            ]
        ]


viewArticleTitle title =
    div []
        [ a [ href "#0", class "article-title" ]
            [ text <| title ]
        ]


viewArticle : Article -> Html msg
viewArticle article =
    div [ class "news-article" ]
        [ div [ class "news-article__id" ]
            [ p [] [ text <| toString article.id ]
            ]
        , div [ class "news-article__content" ]
            [ viewArticleTitle article.title
            , viewArticleMeta { points = 21, author = "Author", commentCount = 100 }
            ]
        ]


viewArticleList : List Article -> Html msg
viewArticleList articles =
    articles
        |> List.map viewArticle
        |> div [ class "container" ]
