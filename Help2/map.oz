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
   TmpL = 100 %height (and width) of a box
   
   Desc = td(canvas(bg:white	%create a canvas representing the map
		    width:W
		    height:H
		    handle:Canvas))
   Window={QTk.build Desc}
   
  proc{GenerateGrid ActL} %generate the grid for the map that 
      if ActL=<0 then skip 
      else
	 {Canvas create(line 0 ActL W ActL)}
	 {Canvas create(line ActL 0 ActL H)}
	 {GenerateGrid ActL-TmpL}
      end
   end
   
   proc{MapScreen}%draw the map on the screen and launch the movement of the trainers
      {Window show}

      {GenerateGrid H}
   end
end