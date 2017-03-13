--Created by Bartosz Kosakowski, 2016
--Thanks to Vasav Shah for some pointers on this <3

-- ========================TESTING THE "Notes" FEATURE=======================
--we need List to use map in order to duplicate the sticky notes
import GraphicSVG exposing (..)
import List exposing (..)


--=======================main function=======================
main =
     gameApp Tick { model = myModel,
                    view = myView,
                    update = update
                  }


--type delcaration
type MyWindow = Tick Float GetKeyState 
                | Clicked
                | Clicked2
                | Clicked3

--=======================shape creation=======================
--For shapes, the very center of the shape is what gets moved.
--For text, the left most pixel is the "center" and so that's what determines position.
--This section creates a seperate group function, which gets put onto the collage in myShape, rather than all tossed
--directly into myShpe; this makes the program more versatile. It allows us to make changes to everything in the group
--at one time rather than each aspect of our shape needing its own modifications 

--model record, keeps track of key variables that are needed by certain shapes
myModel ={
        t = 0,
        shapeSize = 25,
        isVisible = 0,  
        textPos = 1000,
        increment = 1,      --fixed this
        list = [instanceProperties],
        noteNum = 0
        }

instanceProperties = {x = 0}

stickyNote model recList = group 
                [
                square model.shapeSize -- modify this value to make the shape big or small
                |> filled stickyNoteColour2
                |> move (recList.x, 0)   
                |> notifyTap Clicked,
                text "this is a test"
                |> size 20
                |> filled black
                |> move (model.textPos,0) 
                |> notifyTap Clicked
                |> makeTransparent model.isVisible --modify this value on click to either be zero or one
                ]

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


--Creates a title
allHelpfulText = group
                [
                text "Click on the square!"
                |> size 30
                |> filled black
                |> move (-120, 150),
                text "this button currently tests if it is functional"
                |> size 10
                |> filled black
                |> move (-220, -125),
                text "it will eventually make new instances of the note"
                |> size 10
                |> filled black
                |> move (-220, -175)
                ]
                
testShape y x = square 30
              |> filled black
              |> move (x,  y)
            

--displays items onto the screen; view function
myView model = collage 500 500
                [
                allHelpfulText,
                duplicateNotes,
                group (List.map (stickyNote model) model.list),
                deleteNotes
                ]

--=======================Update function=======================
--Update function
update msg model = case msg of
    Tick t (getKeyState,p1,p2) -> model

    Clicked -> if model.isVisible == 0 then
                    { model | shapeSize = 100, isVisible = 1, textPos = -47 }
               else
                    { model | shapeSize = 25, isVisible = 0, textPos = 1000 }

    Clicked2 -> {model | increment = (model.increment + 1), list = ({instanceProperties | x = (model.increment * -100) } :: model.list)}
    
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
