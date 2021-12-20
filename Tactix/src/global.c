//M3TIOR 2015

#include <X11/Xlib.h>
#include <stdio.h>
#include <stdlib.h>

#include "global.h"

//In case it isn't obvious, I denote just about all my code.
//So in case you're still wondering this contains all the global data of the game.

Display *xlink; //xserver link
Window window;  //interfaceable window
GC drawsurface; //graphics context

