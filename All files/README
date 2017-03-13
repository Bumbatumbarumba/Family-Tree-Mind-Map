README

This is a brief outline explaining each part of the note and keyboard. The code itself is quite detailed on the technical side,
but this is here for a more well rounded explanation. I have also included each of the individual files prior to them being linked
together to demo their functonality. The main, most detailed comments are in NOTESPlusTEXT.elm

NOTES:
The notes section demonstrates the functionality of having a little button that can be expanded to reveal more detail about
a person. While the note is closed, the text on the closed note cannot be modified unless it is opened. Once opened, a user
can enter a bit of text, limited to approximately the size of the expanded note box (limitations discussed below). Tapping any
part of the opened box will result in it shrinking and hiding the text.
There is also a button to create new instances of the note; currently it is set to create a new note a fixed distance away from
the center of collage. There is also a limit to how many notes can be created, but this is not necessary and only implemented for
testing purposes; this can be easliy changed/removed by modifying/removing the noteNum variable.
Lastly, there is a delete button to remove excess notes.

KEYBOARD:
This is a keyboard that was implemented using GraphicSVG package. Despite how well I think it turned out, there is a limitation to
how versatile it can be due to how Elm functions. Since capital and lowercase letters have different sizes, the character limit must
be based off of how many capital letters fit inside a desired text field. This leads to lowercase text being cut off some distance away
from the actual right-most end of the text box. I discussed with one of the TA's about possible resolutions to this and as far as either
of us can tell, the only possible resolution is not allow capital letters and make a character limit based on lowercase letters. But this
would not work in the context of a family tree, since names should be written with capital letters. Additionally, there was no way for me
to include a newline function inside the notes, so notes would have to be limited in size, which can be slightly rectified by making the
notes bigger in width when they expand.

OTHER THINGS:
Currently there are two things that I couldn't figure out how to work out in this program; one being dragging and dropping the notes, and
the other being linking two notes together. Another thing that I'm not happy with is that new instances of the notes all interact statically
rather than dynamically. I hope to resolve these issues over my free time, and I hope that you enjoy what is currently present.

Thank you for the semester, and the opportunity I was given to expand my knowledge and test myself with functional programming, and I hope you
and your family have a happy holidays.
