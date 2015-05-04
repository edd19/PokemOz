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

   MoveManager %a port for mananging the movements of the trainers
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


   fun{Equals A B} %return 1 if the two elements are equals and 0 otherwise
      if A==B then 1
      else 0
      end
   end
   
    %------------------------
   %Receive a record of type: listMoves(player:M 1:M1 2:M2 3:M3 4:M4 5:M5 6:M6 7:M7 8:M8 9:M9 10:M10)
   %And move each corresponding rectangle on the map at the correct direction
   proc{MoveTrainers ListMoves ListTags}
      proc{Loop Acc List}
	 case List
	 of  H|T then local Coord X1 Y1 in 
			 {H getCoords(Coord)}
			 X1={Max {Min (NbLines-1)*TmpL {Float.toInt Coord.1}+({Equals ListMoves.Acc 2}-{Equals ListMoves.Acc 4})*TmpL} 0} %generates new coordinates depending of the movement
			 Y1={Max {Min (NbLines-1)*TmpL {Float.toInt Coord.2.1}+({Equals ListMoves.Acc 3}-{Equals ListMoves.Acc 1})*TmpL} 0}
			    
			 {H setCoords(X1 Y1 X1+TmpL Y1+TmpL)}
			 {Loop Acc+1 T}
		      end
	 else skip
	 end
      end
   in
      {Loop 1 ListTags}
   end

   proc{RandomMoves} %generates random moves
      local Move in
	 {Send MoveManager get(Move)}
	 if Move == true then 
	    {Send MoveManager move(listMoves(player:0 1:({OS.rand} mod 10) 2:({OS.rand} mod 10) 3:({OS.rand} mod 10) 4:({OS.rand} mod 10) 5:({OS.rand} mod 10) 6:({OS.rand} mod 10)
				 7:({OS.rand} mod 10) 8:({OS.rand} mod 10) 9:({OS.rand} mod 10) 10:({OS.rand} mod 10)))}
	 end

	 {Delay 500}
	 {RandomMoves}
      end
   end

   fun{MessageProcess Msg State}
      case Msg
      of move(M) then {MoveTrainers M State.l} State
      [] get(B) then B = State.b State
      else State
      end
   end
   
   proc{NewMoveManager}%creates a new move manager
      proc{Loop S State}
	 case S
	 of  H|T then
	    {Loop T {MessageProcess H State}}
	 end
      end
      S
   in
      MoveManager = {NewPort S}
      thread {Loop S state(b:true l:ListTags)} end
   end
  
   proc{MapScreen}%draw the map on the screen and launch the movement of the trainers
      {Window show}

      {GenerateGrid H}
      {GenerateGameMap Map}
      ListTags = {InitRectangles}

      {NewMoveManager}

      {RandomMoves}
      
   end
end