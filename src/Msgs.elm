module Msgs exposing (..)

import Http
import Models exposing (Player, PlayerId)
import RemoteData exposing (WebData)
import Navigation exposing (Location)


type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnLocationChange Location
    | ChangeLevel Player Int
    | ChangeName Player String
    | Delete PlayerId
    | OnPlayerCreate (Result Http.Error Player)
    | OnPlayerSave (Result Http.Error Player)
    | OnPlayerDelete PlayerId (Result Http.Error String)
