declare [QTk]={Module.link ["x-oz://system/wp/QTk.ozf"]}

local
   Canvas
   Grid
   W=600	%width of the screen
   H=600	%height of the screen
   Desc = td(canvas(bg:white	%description of the canvas representing the screen
		    width:W
		    height:H
		    handle:Canvas))
 
   Window={QTk.build Desc}
   
   proc {DisplaySelectAction X Y Canvas} %Show the select action menu.
      local Select Width Height
      in
	 Width=14 %Number of characters
	 Height=2 %Nulber of line
	 Select=grid(button(text:"Attack" height:Height width:Width) button(text:"Change" height:Height width:Width)  newline
		     button(text:"Flee" height:Height width:Width) empty  newline
		     handle:Grid)
	 {Canvas create(window X Y window:Select anchor:nw) }
      end
      
   end

   proc {DisplayBattleMessage X Y Canvas} %Display the message of the combat
      local Message Width Height
      in
	 Width=43 %Nulber of characters per line
	 Height=5 %Number of line
	 Message=label(init:"Choose an action" height:Height width:Width)
	 {Canvas create(window X Y window:Message anchor:nw)}
      end
   end

   proc{DisplayFrames X Y Canvas} %Display the frames of the combat screen
      {Canvas create(line 0 500 X 500)}
      {Canvas create(line 350 500 350 Y)}
   end
   
   
in
   {Window show} %show the map
   {DisplaySelectAction 351 501 Canvas}
   {DisplayBattleMessage 1 501 Canvas}
   {DisplayFrames W H Canvas}
end
