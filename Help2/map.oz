%Class correspondant a la map
functor

import
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

   ListTags %list of rectangles representing the trainer
   
   proc{GenerateGrid ActL} %generate the grid for the map that 
      if ActL=<0 then skip 
      else
	 {Canvas create(line 0 ActL W ActL)}
	 {Canvas create(line ActL 0 ActL H)}
	 {GenerateGrid ActL-TmpL}
      end
   end

   proc {GenerateGameMap M} %colored the case if needed (green for grass for example)
      for I in 1..NbLines do %TODO boucle recusif
	 for J in 1..NbLines do
	    if M.J.I==1 then %Grass Cell 
	       {Canvas create(rect (I-1)*TmpL (J-1)*TmpL (I)*(TmpL) (J)*(TmpL) fill:green)}
	    end
	 end
      end
   end

   fun{CheckIfEmpty X1 Y1 List} %check if this case doesn't contain an element
      fun{Loop ListTags}
	 case ListTags
	 of H|T then local Coord in
			{H getCoords(Coord)}
			if X1 == {Float.toInt Coord.1} andthen Y1=={Float.toInt Coord.2.1} then false
			%add another for the player
			else {Loop T}
			end
		     end
	 else true
	 end
      end
   in
      {Loop List}
   end
   
   fun{InitRectangles} %initialize the ovals representing the trainers
      fun{InitRectangles2 LAcc N}
	 if N==0 then LAcc
	 else
	    local H X1 Y1 in
	       H={Canvas newTag($)}
	       X1 = ({OS.rand} mod NbLines) * TmpL %generates a random X1 and Y1
	       Y1 = ({OS.rand} mod NbLines) * TmpL
	       if {CheckIfEmpty X1 Y1 LAcc} == true then %of there isn't already a trainer there then we create a shape at coord X1 Y1
		  {Canvas create(oval X1 Y1 X1+TmpL Y1+TmpL fill:blue tags:H)}
		  {InitRectangles2 H|LAcc N-1}
	       else
		  {InitRectangles2 LAcc N}
	       end
	    end
	 end
      end
      Random
   in
      Random = ({OS.rand} mod 10)+1
      {InitRectangles2 nil Random}
   end
  
  
   proc{MapScreen}%draw the map on the screen and launch the movement of the trainers
      {Window show}

      {GenerateGrid H}
      {GenerateGameMap Map}
      ListTags = {InitRectangles}

      
   end
end