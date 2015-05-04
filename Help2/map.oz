%Class correspondant a la map
functor

import
   Browser
   OS
   QTk at 'x-oz://system/wp/QTk.ozf'
   
export
   MapScreen
   
define

   Map = map(r(1 1 1 0 0 0 0) %map of the game
	     r(1 1 1 0 0 1 1)
	     r(1 1 1 0 0 1 1)
	     r(0 0 0 0 0 1 1)
	     r(0 0 0 1 1 1 1)
	     r(0 0 0 1 1 0 0)
	     r(0 0 0 0 0 0 0))

   Canvas
   % A AJUSTER EN FONCTION DE LA TAILLE DE LA MAP
   W=700	%width of the map
   H=700	%height of the map
   NbLines = 7 % number of rows and columns
   BoxWidth = 100 %height (and width) of a box
   
   Desc = td(canvas(bg:white	%create a canvas representing the map
		    width:W
		    height:H
		    handle:Canvas))
   Window={QTk.build Desc}
   
  
   
   proc{MapScreen}%draw the map on the screen and launch the movement of the trainers
      {Window show}
   end
end