module Main exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model, initialModel)
import Update exposing (update)
import View exposing (view)
import Commands exposing (fetchPlayers)
import Routing
import Navigation exposing (Location)


init : Location -> ( Model, Cmd Msg )
init location =
    ( initialModel <| Routing.parseLocation location, fetchPlayers )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
