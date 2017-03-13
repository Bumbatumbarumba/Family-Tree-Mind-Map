--Created by Bartosz Kosakowski, 2016
--Thanks to Vasav Shah for some pointers on this <3

-- ========================TESTING THE "Notes" FEATURE=======================
--we need List to use map in order to duplicate the sticky notes
import GraphicSVG exposing (..) 
import List exposing (..)
import Char exposing (toCode, fromCode)
import String exposing(..)

--=======================main function=======================
--main method and type declaration(s)
--When creating interactive programs with animations (such as games) using the graphicSVG package, you will need to create
--a gameApp function that takes TICK as a parameter and has a record of model, view, and update. On the lefthand side, the
--names must be as they appear, however on the right the names are based off of whatever you call your corresponding items.
--For instance, in this program, I have a model "myModel", so here I wrote "model = myModel".
main =
     gameApp Tick { model = myModel,    --model describes the state of your program
                    view = myView,      --view displays your visuals to the screen
                    update = update     --update is fairly self-descriptive; it updates your function every tick
                  }


--type delcaration
type MyWindow = Tick Float GetKeyState 
                | Clicked   --for opening and closing notes
                | Clicked2  --for duplicating notes
                | Clicked3  --for deleting notes


--=======================shape creation=======================
--For shapes, the very center of the shape is what gets moved.
--For text, the left most pixel is the "center" and so that's what determines position.
--This section creates a seperate group function, which gets put onto the collage in myShape, rather than all tossed
--directly into myShpe; this makes the program more versatile. It allows us to make changes to everything in the group
--at one time rather than each aspect of our shape needing its own modifications 

--model record, keeps track of key variables that are needed by certain shapes
myModel ={
        t = 0,              --sets the time to be zero by default
        shapeWidth = 25,    --sets the default note height to 25 pixels
        shapeHeight = 25,   --sets the default note height to 25 pixels
        isVisible = 0,      --this is used to determine when our text is visible; 0 == not visible, 1 == visible
        textPos = 0,        --used to determine where our text will be; zero by default
        increment = 1,      --used to increase the number of notes we have
        list = [instanceProperties],    --a list of properties that we want to map our future instances of the notes to
        noteNum = 0,        --counts how many instances of notes we have created; this is restricted to 3 in a lower function
        string  = "",       --the default text that appears on our notes (blank)
        caps=0              --used to determine if caps is on; 0 == off, 1 == on
        }
--hold 
instanceProperties = {x = 0}

--creates a note to be displayed
stickyNote model recList = group 
                [
                rect model.shapeWidth model.shapeHeight     -- modify this value to make the shape big or small
                |> filled stickyNoteColour2
                |> move (recList.x, 0),  --moves it to whatever position it is mapped against in the view function below    
                --|> notifyTap Clicked,   --one of the transitions for our app; checks if the shape itself has been clicked
                text model.string
                |> size 20
                |> filled black
                |> move (recList.x - 90, 0)
                |> makeTransparent model.isVisible  --makeTransparent is a function that takes a float between 0 and 1 and appropriately
                ]                                   --modifies the text's opacity; 0 is invisible, 1 is complately opaque

--creates a button that, when clicked on, creates another instance of the note box
duplicateNotes = group
                [square 25
                |> filled orange
                |> move (-150, -150)
                |> notifyTap Clicked2
                ]
--creates a button to delete button instances
deleteNotes = group
                [square 25
                |> filled blue
                |> move (150, -150)
                |> notifyTap Clicked3
                ]

--a single function that is used to display all the important tidbits of info
allHelpfulText model = group
                [
                --"title" text
                text "Click on the square and type!"
                |> size 30
                |> filled black
                |> move (-150, 150),
                --duplicate instructions
                text "Press to duplicate notes" --creates a label for duplicate button
                |> size 10
                |> filled black
                |> move (-190, -125),
                --remove instructions
                text "Press to remove notes"
                |> size 10
                |> filled black
                |> move (105, -125),
                --displays the number of notes we have created
                text (toString (model.noteNum + 1))
                |> size 10
                |> filled black
                |> move (-120, 125),
                text "Number of note objects (max 3):"
                |> size 10
                |> filled black
                |> move (-260, 125)
                ]
            
--displays items onto the screen; view function
myView model = collage 750 500
                [
                allHelpfulText model,
                duplicateNotes,
                (group (List.map (stickyNote model) model.list)) |> notifyTap Clicked, --creates new "instances" of the note box by mapping it to a list of records,
                deleteNotes                                     -- which contain a new position for each "instance"
                ]

--=======================Update function=======================
--determines whether or not caps has been pressed using it's ASCII value
capsKeys aNum model =
        if model.caps == 0 then
            aNum
        else
            aNum - 32

--a general function that is used to determine which key has been pressed; basically it makes it so that we don't have
--to use a billion if-then-else statements to check each key on the keyboard 
updateKeys getKeyState num model=   if model.isVisible == 1 then
                                        if (getKeyState(Key (fromChar(fromCode num))))==JustDown then
                                            if (String.length model.string) == 21 then
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
                                        else model
                                    else model

--Update function
update msg model = case msg of
    Tick t (getKeyState,p1,p2) -> List.foldl (updateKeys getKeyState) model (8 :: (16 :: (32 :: (20 :: [97..122]))))

    --used to open/close our notes; if a note is visibile already, then it makes text invisible, and shrinks the shape, 
    --otherwise it expands the note and makes it bigger
    Clicked -> if model.isVisible == 0 then
                    { model | shapeWidth = 200, shapeHeight = 100, isVisible = 1, textPos = -47 }
               else
                    { model | shapeWidth = 25, shapeHeight = 25, isVisible = 0, textPos = 1000 }

    --used to create a new note a fixed distance away from the center; is currently limited to creating 3 notes
    Clicked2 -> if model.noteNum < 2 then
                    {model | increment = (model.increment + 1), list = ({instanceProperties | x = (model.increment * -100) } :: model.list), noteNum = model.noteNum + 1}
                else
                    model

    --used to remove instances of notes; checks if the number of notes is not 0; if yes then it'll remove a note
    Clicked3 -> if model.increment /= 0 then
                    {model | increment = (model.increment - 1), list = (take ((List.length model.list)-1) model.list), noteNum = model.noteNum - 1}
                else
                    model


--=======================Colours=======================
--creates the white sticky note colour
stickyNoteColour1 = 
    rgb 239 242 185

--creates the yellow sticky note colour
stickyNoteColour2 = 
    rgb 255 205 90
