module Commands exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Msgs exposing (Msg)
import Models exposing (PlayerId, Player)
import RemoteData


fetchPlayers : Cmd Msg
fetchPlayers =
    Http.get fetchPlayersUrl playersDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchPlayers


fetchPlayersUrl : String
fetchPlayersUrl =
    "http://localhost:4000/players"


playersDecoder : Decode.Decoder (List Player)
playersDecoder =
    Decode.list playerDecoder


playerDecoder : Decode.Decoder Player
playerDecoder =
    decode Player
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "level" Decode.int


savePlayerUrl : PlayerId -> String
savePlayerUrl playerId =
    "http://localhost:4000/players/" ++ playerId


savePlayerRequest : Player -> Http.Request Player
savePlayerRequest player =
    let
        method =
            if player.id == "" then
                "POST"
            else
                "PATCH"
    in
        Http.request
            { body = playerEncoder player |> Http.jsonBody
            , expect = Http.expectJson playerDecoder
            , headers = []
            , method = method
            , timeout = Nothing
            , url = savePlayerUrl player.id
            , withCredentials = False
            }


savePlayerCmd : Player -> Cmd Msg
savePlayerCmd player =
    let
        msg =
            if player.id == "" then
                Msgs.OnPlayerCreate
            else
                Msgs.OnPlayerSave
    in
        player |> savePlayerRequest |> Http.send msg


deletePlayerCmd : PlayerId -> Cmd Msg
deletePlayerCmd playerId =
    Http.send
        (Msgs.OnPlayerDelete playerId)
        (Http.request
            { body = Http.emptyBody
            , expect = Http.expectString
            , headers = []
            , method = "DELETE"
            , timeout = Nothing
            , url = savePlayerUrl playerId
            , withCredentials = False
            }
        )


playerEncoder : Player -> Encode.Value
playerEncoder player =
    Encode.object
        [ ( "id", Encode.string player.id )
        , ( "name", Encode.string player.name )
        , ( "level", Encode.int player.level )
        ]
