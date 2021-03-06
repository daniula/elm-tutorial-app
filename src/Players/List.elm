module Players.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, colspan)
import Html.Events exposing (onClick)
import Msgs exposing (Msg)
import Models exposing (Player)
import RemoteData exposing (WebData)
import Routing exposing (playerPath)


view : WebData (List Player) -> Html Msg
view response =
    div []
        [ nav
        , maybeList response
        ]


maybeList : WebData (List Player) -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success players ->
            list players

        RemoteData.Failure error ->
            text <| toString <| error


nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Players" ] ]


list : List Player -> Html Msg
list players =
    div [ class "p2" ]
        [ table []
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , th [] [ text "Name" ]
                    , th [] [ text "Level" ]
                    , th [] [ text "Actions" ]
                    ]
                ]
            , tbody [] (List.map playerRow players)
            , tfoot []
                [ td [ colspan 4 ]
                    [ createBtn ]
                ]
            ]
        ]


playerRow : Player -> Html Msg
playerRow player =
    tr []
        [ td [] [ text player.id ]
        , td [] [ text player.name ]
        , td [] [ text <| toString <| player.level ]
        , td [] [ editBtn player, deleteBtn player ]
        ]


editBtn : Player -> Html Msg
editBtn player =
    a [ class "btn regular", href (playerPath player.id) ]
        [ i [ class "fa fa-pencil mr1" ] []
        , text "Edit"
        ]


deleteBtn : Player -> Html Msg
deleteBtn player =
    button [ class "btn regular", onClick (Msgs.Delete player.id) ]
        [ i [ class "fa fa-trash mr1" ] []
        , text "Delete"
        ]


createBtn : Html Msg
createBtn =
    a [ href (playerPath "") ] [ text "Add new player" ]
