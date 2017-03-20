module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (Model, Player, PlayerId)
import Routing exposing (parseLocation, playerPath)
import Commands exposing (savePlayerCmd, deletePlayerCmd)
import Navigation exposing (load)
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

        Msgs.ChangeName player newName ->
            ( model, savePlayerCmd { player | name = newName } )

        Msgs.Delete playerId ->
            ( model, deletePlayerCmd playerId )

        Msgs.OnPlayerCreate (Ok player) ->
            ( addPlayer model player, load <| playerPath <| player.id )

        Msgs.OnPlayerCreate (Err error) ->
            ( model, Cmd.none )

        Msgs.OnPlayerSave (Ok player) ->
            ( updatePlayer model player, Cmd.none )

        Msgs.OnPlayerSave (Err error) ->
            ( model, Cmd.none )

        Msgs.OnPlayerDelete playerId (Ok player) ->
            ( removePlayer model playerId, Cmd.none )

        Msgs.OnPlayerDelete playerId (Err error) ->
            ( model, Cmd.none )


addPlayer : Model -> Player -> Model
addPlayer model newPlayer =
    { model | players = RemoteData.map (flip (++) [ newPlayer ]) model.players }


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


removePlayer : Model -> PlayerId -> Model
removePlayer model removePlayerId =
    let
        pick =
            .id >> (/=) removePlayerId
    in
        { model | players = RemoteData.map (List.filter pick) model.players }
