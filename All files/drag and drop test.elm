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
                | MouseMoved (Float, Float)
                | Clicked
                | CreateNew

--========================
--global vars
myModel =   {
            instKey = 0,
            dragging = False,
            instList = [instanceVars],
            test = Dict.fromList [(0, instanceVars)]
            }
--instance vars
instanceVars =  {
                shapeSize = 25,
                pos = (0,0),
                dragging = False
                }

--========================
--SHAPES
aBox model = group 
            [
            square model.shapeSize
            |> filled red
            |> move model.pos
            |> notifyMouseDownAt MouseMoved,
            square 10
            |> filled green
            |> move model.pos
            |> notifyTap Clicked
            ]
createBox model = group 
            [
            square 25
            |> filled blue
            |> move (-100, -100)
            |> notifyTap CreateNew
            ]

--========================
--draws the shapes
myView model = collage 750 500
                [
                group (List.map aBox model.instList),
                createBox model
                ]

--========================
--updates the screen
update msg model = case msg of
    Tick t (getKeyState,p1,p2) -> model
    --MAKE THIS GET THE DICT KEY FIRST, THEN APPLY CHANGES TO WHATEVER IT GETS
    MouseMoved (x,y) -> model --{model | pos = (x,y)}
    CreateNew -> {model | test = Dict.insert model.instKey instanceVars model.test} --{model | instList = (instanceVars :: model.instList)}
    Clicked -> model