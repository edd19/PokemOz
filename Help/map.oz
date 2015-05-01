%Class correspondant a la map

functor
import
   QTk at 'x-oz://system/wp/QTk.ozf'
   
export
   GenerateGrid
   GenerateGameMap
   CreateRectangle
define
   %Hardcoded Map
   Map=map(r(1 1 1 0 0 0 0)
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
   TmpL %height (and width) of a box
   
   Desc = td(canvas(bg:white	%create a canvas representing the map
		    width:W
		    height:H
		    handle:Canvas))
   Window={QTk.build Desc}
   TmpL=H div NbLines
   proc{GenerateGrid ActL}
      if ActL=<0 then skip %%
      else
	 {Canvas create(line 0 ActL W ActL)}
	 {Canvas create(line ActL 0 ActL H)}
	 %{Canvas create(rect W-TmpL H-TmpL W H fill:blue outline:red)}
	 {GenerateGrid ActL-TmpL}
      end
   end
   proc {GenerateGameMap M}
      for I in 1..NbLines do
	 for J in 1..NbLines do
	    if M.J.I==1 then %Grass Cell 
	       {Canvas create(rect (I-1)*TmpL (J-1)*TmpL (I)*(TmpL) (J)*(TmpL) fill:green)}
	    end
	 end
      end
   end
   proc{CreateRectangle X Y ListTrainers}	%procedure that creates a rectangle and moves it
      
      Tag={Canvas newTag($)}
      {Canvas create(rect X+10 Y+10 X+90 Y+90 fill:blue tags:Tag)}
   in
      %ListTrainers a modifier en generant aleatoirement les deplacements
      {Window bind(event:"<Up>" action:proc{$} {Tag delete} {CreateRectangle X {Max 0 Y-TmpL} ListTrainers } end)}
      %move the rectangle by deleting the current one
      {Window bind(event:"<Down>" action:proc{$} {Tag delete} {CreateRectangle X {Min H-TmpL Y+TmpL} ListTrainers} end)}
      % and creating a new one in the direction indicated
      {Window bind(event:"<Left>" action:proc{$} {Tag delete} {CreateRectangle {Max 0 X-TmpL} Y ListTrainers} end)}
      {Window bind(event:"<Right>" action:proc{$} {Tag delete} {CreateRectangle {Min H-TmpL X+TmpL} Y ListTrainers} end)}
   end
   proc{selectionScreen}
      {Window show} %show the map
      {GenerateGrid H}
      {GenerateGameMap Map}
      {CreateRectangle W-TmpL H-TmpL nil}
   end
   
end
