--Created by Bartosz Kosakowski, 2016
--Thanks to Vasav Shah for some pointers on this <3
import GraphicSVG exposing (..)
import Char exposing (toCode, fromCode)
import String exposing(..)
--===============================Testing visual keyboard/keyboard input with graphicsSVG====================================
--main method and type declaration(s)
--When creating interactive programs with animations (such as games) using the graphicSVG package, you will need to create
--a gameApp function that takes TICK as a parameter and has a record of model, view, and update. On the lefthand side, the
--names must be as they appear, however on the right the names are based off of whatever you call your corresponding items.
--For instance, in this program, I have a model "myModel", so here I wrote "model = myModel".
main =
    gameApp Tick {
                 model = myModel, --model describes the state of your program
                 view = myView, --view displays your visuals to the screen
                 update = update --update is self-descriptive; it updates your function every tick???? ===============LOOK INTO THIS
                 }

--Type delcaration; every program that uses graphicSVG and some sort of keyboard input REQUIRES
--at least Tick Float GetKeyState as types. To be frank, I have no idea what Tick does, however Float is a
--float value that can be thought of as a "timer" for your programs. When used in conjunction with update,
--it allows your program to transition between state(s). GetKeyState is a function that returns the state of
--a key that is pressed. This can be:
        --JustDown; when the key has just been pressed (lasts for 1 frame after the key is pressed; it always shows for 1 frame)
        --Down; when the key is contiuing to be held down
        --JustUp; when the key was just released (lasts for 1 frame after the key is pressed; it always shows for 1 frame)
        --Up; when the key is not being pressed.
type Msg = Tick Float GetKeyState
           


--==============================Model==============================
--myModel outlines some variables that every shape that uses myModel will have access to.
--myModel is a record of values, despite it looking like a function; records are handy for
--storing data such as variables and whatnot. You can create a record with braces {put variables here}.
--This can be thought of as the state of your program
myModel = 
        {
        t = 0,
        string  = "",
        caps=0
        }


--==============================Draw==============================
--textOutput creates text that appears on the screen.
--It takes a single parameter that is a model, which it accesses to create a desired result.
--The dot operater allows us to take stuff out of whatever model we pass into it
textOutput model = group
                [text model.string
                |> size 20
                |> filled black
                |> move (-205, 0)
                ]
--creates a textbox
textBoxDraw = group 
                [line (-210, -5) (210,-5)
                |> outlined (solid 2) black,
                line (210, -5) (210, 20)
                |> outlined (solid 2) black,
                line (210, 20) (-210, 20)
                |> outlined (solid 2) black,
                line (-210, 20) (-210, -5)
                |> outlined (solid 2) black
                ]

--draws the text to the screen
myView model = collage 500 500
        [
        textOutput model,
        text "Type stuff! Max 28 characters"
        |> size 20
        |> filled black
        |> move (-100, 50),
        textBoxDraw
        ]


--==============================Update and other functions==============================
capsKeys aNum model =
        if model.caps == 0 then
            aNum
        else
            aNum - 32

--credit to Vasav Shah for helping me make this much more concise! Appreciate ya!
--WRITE SOMETHING HERE THAT EXPLAINS HOW THIS WORKS
updateKeys getKeyState num model=   if (getKeyState(Key (fromChar(fromCode num))))==JustDown then
                                        if (length model.string) == 29 then
                                            {model|string = (dropRight 1 model.string)}
                                        else
                                            if num == 8 then
                                                {model|string = (dropRight 1 model.string)}
                                            else if num == 20 then
                                                if model.caps==0 then {model|caps=1} else {model|caps=0}
                                            else if num == 32 then
                                                {model|string = model.string++(fromChar(fromCode num))}
                                            else
                                                {model|string = model.string++(fromChar(fromCode (num - 32*(model.caps))))}
                                    {-else if (getKeyState(Key (fromChar(fromCode num))))==Down then
                                                if num == 16 then 
                                                    -}
                                    else model

--WRITE SOMETHING HERE THAT EXPLAINS HOW THIS WORKS
update msg model = case msg of 
              Tick t (getKeyState,p1,p2) -> List.foldl (updateKeys getKeyState) model (8 :: (16 :: (32 :: (20 :: [97..122]))))
            
