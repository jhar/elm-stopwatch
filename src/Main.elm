module Main exposing (..)


import Browser
import Html exposing (Html, button, div, h1, span, text)
import Html.Events exposing (onClick)
import Task
import Time


-- MAIN


main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { milliseconds: Int
  , started : Bool
  }
  
initialModel : Model
initialModel = 
  { milliseconds = 0
  , started = False
  }
  
init : () -> (Model, Cmd Msg)
init _ =
  ( initialModel
  , Cmd.none
  )



-- UPDATE


type Msg
  = Reset
  | StartStop
  | Tick Time.Posix



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Reset ->
      ( initialModel
      , Cmd.none
      )
    
    StartStop ->
      ( { model | started = not model.started }
      , Cmd.none
      )

    Tick _ ->
      ( { model | milliseconds = model.milliseconds + 17 }
      , Cmd.none
      )




-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  if model.started then
    Time.every 17 Tick
  else
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  let
    hours = String.fromInt (model.milliseconds // 3600000)
    minutes = String.fromInt (remainderBy 60 (model.milliseconds // 60000))
    seconds = String.fromInt (remainderBy 60 (model.milliseconds // 1000))
    milliseconds = String.fromInt (remainderBy 1000 model.milliseconds)
  in
  div []
    [ h1 [] [ text (hours ++ ":" ++ minutes ++ ":" ++ seconds ++ "." ++ milliseconds) ]
    , button [ onClick StartStop ] [ text (if model.started then "Stop" else "Start" ) ]
    , button [ onClick Reset ] [ text "Reset" ]
    ]
