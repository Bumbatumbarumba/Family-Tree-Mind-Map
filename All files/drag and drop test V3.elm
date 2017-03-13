import GraphicSVG exposing (..) 
import List exposing (..)
import Char exposing (toCode, fromCode)
import String exposing (..)
import Dict exposing (Dict)

main =
     gameApp Tick { model = myModel,    --model describes the state of your program
                    view = myView,      --view displays your visuals to the screen
                    update = update     --update is fairly self-descriptive; it updates your function every tick
                  }

--type delcaration
type MyWindow = Tick Float GetKeyState
                | MouseMoved Int (Float, Float)
                | CreateNew

--========================
--global vars
myModel =   {
            inFocus = 0,
            instKey = 1,
            dragging = False,
            instDict = Dict.insert 0 instanceVars Dict.empty
            }
--instance vars
instanceVars =  {
                shapeSize = 50,
                pos = (0,0),
                dragging = False
                }

--========================
--SHAPES
aBox (id,record) = group 
            [
            square record.shapeSize
            |> filled red
            |> move record.pos
            |> notifyMouseDownAt (MouseMoved id),
            text (toString (id))
            |> size 20
            |> filled black
            |> move record.pos
            ]
createBox model = group 
            [
            square 25
            |> filled blue
            |> move (-100, -100)
            |> notifyTap CreateNew,
            text (toString (model.inFocus))
            |> size 20
            |> filled black
            |> move (-110,-110)
            ]

--========================
--draws the shapes
myView model = collage 750 500
                [
                group (List.map aBox (Dict.toList model.instDict)),
                createBox model
                ]

--========================
--updates the screen
update msg model = case msg of
    Tick t (getKeyState,p1,p2) -> model
    MouseMoved id (x,y) -> {model | instDict = (Dict.update id (check (x,y)) model.instDict)}
    CreateNew -> {model | instDict = Dict.insert model.instKey instanceVars model.instDict, instKey = model.instKey + 1}

--auxiliary functions
check aPos anInst =
    case anInst of
        Just anInst -> Just {anInst | pos = aPos}
        Nothing -> Nothing