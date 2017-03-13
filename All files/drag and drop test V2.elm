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
                | Clicked Int
                | CreateNew
                --temp stuff:
                | MouseMoved2 (Float, Float)

--========================
--global vars
myModel =   {
            inFocus = 0,
            instList = [instanceVars],
            temp = instanceVars,
            --temp stuff:
            pos = (100,100)
            }
--instance vars
instanceVars =  {
                pos = (0,0),
                instanceNumber = 0,
                shapeSize = 25
                }

--========================
--SHAPES
aBox model = group 
            [
            square model.shapeSize
            |> filled red
            |> move model.pos
            |> notifyMouseDownAt MouseMoved2
            |> notifyTap (Clicked model.instanceNumber)
{-            square 10
            |> filled green
            |> move model.pos
            |> notifyTap (Clicked model.instanceNumber)-}
            ]
createBox model = group 
            [
            square 25
            |> filled blue
            |> move (-100, -100)
            |> notifyTap CreateNew
            ]

testBox model = group 
        [
        square 75
        |> filled orange
        |> move model.pos
        ]

dragArea = group
            [
            square 500
            |> filled white
            |> move (0,0)
            |> notifyMouseDownAt MouseMoved2
            |> notifyMouseUpAt MouseMoved2
            ]

--========================
--draws the shapes
myView model = collage 750 500
                [
                dragArea,
                group (List.map aBox model.instList)
                --testBox model
                ]

--========================
--updates the screen
update msg model = case msg of
    Tick t (getKeyState,p1,p2) -> model
    --{model | pos = (x,y)}
    --FIGURE OUT WHY THIS ISN'T WORKING
    MouseMoved (x,y) -> if (model.inFocus == (Maybe.withDefault {pos = (0,0), instanceNumber = 0,shapeSize = 25} (get model.instList model.inFocus)).instanceNumber) then
                            {model | temp = (
                                let myMod = (Maybe.withDefault {pos = (0,0), instanceNumber = 0,shapeSize = 25} (get model.instList model.inFocus)) 
                                in {myMod | pos = (x,y)})}
                        else
                            model


                        {-{model | temp = (
                                let myMod = (Maybe.withDefault {pos = (0,0), instanceNumber = 0,shapeSize = 25} (get model.instList model.inFocus)) 
                                in {myMod | pos = (x,y)}
                                )}-}
    MouseMoved2 (x,y) -> {model | pos = (x,y)}
    --FIGURE OUT WHY THIS ISN'T WORKING EITHER
    --WHAT IS THIS LANGUAGE DOOOOOOIIIIIING
    CreateNew -> model --{model | instList = (instanceVars :: model.instList)}
    Clicked i -> {model | inFocus = i}


--========================
--auxilliary functions
--used to get a desired element from a list given an index
get: List a -> Int -> Maybe a
get list num =
  case num of 
  0 -> List.head list
  otherwise -> List.head (List.drop (num - 1) list)

--used to convert an item (such as instanceVars) to a list, so that it can be
--appened onto the back of a list
convertToList: a -> List a
convertToList listElem =
    [listElem]