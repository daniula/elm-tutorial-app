module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (Model, Player)
import Routing exposing (parseLocation)
import Commands exposing (savePlayerCmd)
import RemoteData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnFetchPlayers response ->
            ( { model | players = response }, Cmd.none )

        Msgs.OnLocationChange location ->
            ( { model | route = (parseLocation location) }, Cmd.none )

        Msgs.ChangeLevel player howMuch ->
            ( model, savePlayerCmd { player | level = player.level + howMuch } )

        Msgs.OnPlayerSave (Ok player) ->
            ( updatePlayer model player, Cmd.none )

        Msgs.OnPlayerSave (Err error) ->
            ( model, Cmd.none )


updatePlayer : Model -> Player -> Model
updatePlayer model updatePlayer =
    let
        pick player =
            if player.id == updatePlayer.id then
                updatePlayer
            else
                player
    in
        { model | players = RemoteData.map (List.map pick) model.players }
