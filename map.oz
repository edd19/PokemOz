%Class correspondant a la map
functor

import
   OS
   QTk at 'x-oz://system/wp/QTk.ozf'
   Application
   Module
   Pokemoz at 'list_pokemoz.ozf'
export
   MapScreen
   InitializeMyMap
   W
   
define

   Map
   Canvas
   TmpL = 100 %height (and width) of a box
   W          %width of the map
   H          %height of the map
   NbLines    % number of rows and columns. 

   Desc
   Window
   Auto
   
   proc{DispW}
      Desc = td(canvas(bg:white	%create a canvas representing the map
		       width:W
		       height:H
		       handle:Canvas))
      Window={QTk.build Desc}
   end
   %Initialize Map NbLines W and H
   proc {InitializeMyMap ImportedMap NbRows NbCols}
      W=TmpL*NbRows
      H=TmpL*NbCols
      Map=ImportedMap
      NbLines=NbRows  
   end
   
   ListTags %list of rectangles representing the trainer
   Tag % TagPlayer

   MoveManager %a port for mananging the movements of the trainers

   Player %port for the player trainer


   proc{GameOver}%quit the game
      local Font in
	 Font = {QTk.newFont font(size:40)}
	 {Canvas create(window (W div 2) (H div 2) window:message(init:"You lose" font:Font))}
	 {Delay 500}
	 {Application.exit 0}
	 end
   end



   proc{AfterCombat ResultCombat} %Lauch the game over screen or reload the map depending of the result of the combat
      if ResultCombat == 1 then {GameOver} %the player lose the game
      end
   end

   fun{IsAttackedByWild}%return true if a wild pokemoz attack the player, false otherwise
      local Probability in
	 Probability = {OS.rand} mod 3
	 if Probability == 1 then true
	 else false end
      end
   end

   fun{CreateTrainer Number}%create a trainer where Number is the number of pokemoz that the trainer have and Lx is the level of the player
      fun{Loop N R Init}
	 local P X in
	    {Send Player get(X)}
	    P = {Pokemoz.createPokemOz X.p1.lx}%generates a pokemoz
	    if R == 1 then {Loop N R+1 trainer(c:0 r:0 isDefeated:false p1:P p2:nil p3:nil)}
	    elseif R == 2 then if R > N then Init
			       else  {Loop N R+1 trainer(c:0 r:0 isDefeated:false p1:Init.p1 p2:P p3:nil)}
			       end
	    elseif R==3 then if R > N then Init
			     else   {Loop N R+1 trainer(c:0 r:0 isDefeated:false p1:Init.p1 p2:Init.p2 p3:P)}
			     end
	    else Init
	    end
	 end
      end
   in
      {Loop Number 1  trainer(c:0 r:0 isDefeated:false p1:nil p2:nil p3:nil)}
   end

   proc{LaunchCombatVsWild} %launch the combat vs a wild pokemoz
      local WildPokemoz Opponent Trainer ResultCombat Combat Agent Window in
	 [Combat] = {Module.link ['combat.ozf']} %load the module for the combat
	 [Agent] = {Module.link ['agent.ozf']} %load the module for the agent creation
	 [Window] = {Module.link ['window.ozf']} %load the module for the combat
	 {Window.createWindow}
	 {Window.showWindow}
	 
	 Trainer = {CreateTrainer 1} 
	 Opponent = {Agent.newIA Trainer 1}

	 {Combat.initializeCombatWindow Window}
	 if Auto == false then
	    ResultCombat = {Combat.combatVSWild Player Opponent}
	 else ResultCombat = {Combat.automaticFight Player Opponent 2}
	 end
	 {AfterCombat ResultCombat}
      end
   end

   proc{InGrass} %If the player is in grass, there is possibility that a wild pokemoz attack the player
      if {IsAttackedByWild} == true then {LaunchCombatVsWild}
      end
   end


   proc{LaunchCombatVsTrainer} %launch a combat vs a trainer
      local WildPokemoz Opponent Trainer ResultCombat Combat Agent Number Window in
	 [Combat] = {Module.link ['combat.ozf']} %load the module for the combat
	 [Agent] = {Module.link ['agent.ozf']} %load the module for the agent creation
	 [Window] = {Module.link ['window.ozf']} %load the module for the combat
	 
	 {Window.createWindow}
	 {Window.showWindow}

	 Number = ({OS.rand} mod 3) + 1 %generates a number between 1 and 3, it's the number of pokemoz that the trainer held 
	 Trainer = {CreateTrainer Number} 
	 Opponent = {Agent.newIA Trainer 1}

	 {Combat.initializeCombatWindow Window}
	 if Auto == false then
	    ResultCombat = {Combat.combatVSTrainer Player Opponent}
	 else  ResultCombat = {Combat.automaticFight Player Opponent 1}
	 end
	 {AfterCombat ResultCombat}
      end
   end
   
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
      
   proc {CheckInGrass X Y Ret}

	    if Map.((Y div TmpL)+1).((X div TmpL)+1)==1 then Ret=true else Ret=false end % PE +1
      
   end

   fun{CheckIfEmpty X1 Y1 List} %check if this case doesn't contain an element
      fun{Loop ListTags}
	 case ListTags
	 of H|T then local Coord PlayerCoord in
			{H getCoords(Coord)}
			{Tag getCoords(PlayerCoord)}
			if X1 == {Float.toInt Coord.1} andthen Y1=={Float.toInt Coord.2.1} then false
			elseif  X1 == {Float.toInt PlayerCoord.1} andthen Y1=={Float.toInt PlayerCoord.2.1} then false
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
			 if {CheckIfEmpty X1 Y1 ListTags} == true then %of there isn't already a trainer there then we create a shape at coord X1 Y1
			    {H setCoords(X1 Y1 X1+TmpL Y1+TmpL)}
			    {Send MoveManager combatia(X1 Y1)}
			 end
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

	 {Delay 1000}
	 {RandomMoves}
      end
   end

   fun{CheckIfCombat X1 Y1 List}%check if a combat happens against a trainer
      fun{Loop X1 Y1 Acc ListTags}
	 case ListTags
	 of H|T then local Coord PlayerCoord in
			{H getCoords(Coord)}
			{Tag getCoords(PlayerCoord)}
			if X1 == {Float.toInt Coord.1} andthen Y1=={Float.toInt Coord.2.1} then Acc
			elseif  X1 == {Float.toInt PlayerCoord.1} andthen Y1=={Float.toInt PlayerCoord.2.1} then 11
			else {Loop X1 Y1 Acc+1 T}
			end
		     end
	 else 0
	 end
      end
      A B C D
   in
      A = {Loop X1+TmpL Y1 1 List}
      B = {Loop X1-TmpL Y1 1 List}
      C = {Loop X1 Y1+TmpL 1 List}
      D = {Loop X1 Y1-TmpL 1 List}
      if A \= 0 then A
      elseif B \= 0 then B
      elseif C \= 0 then C
      elseif D \= 0 then D
      else 0
      end
   end

   fun{RemoveNth List N}
      fun{Loop List Acc}
	 case List
	 of H|T then if Acc == N then {H delete} T
		     else H|{Loop T Acc+1}
		     end
	 else nil
	 end
      end
   in
      {Loop List 1}
   end

   fun{FindByCoord X Y State}
      fun{Loop List Acc}
	 case List
	 of H|T then if H.1 == X andthen H.2.1 == Y then Acc
		     else {Loop T Acc+1}
		     end
	 else 0
	 end
      end
   in
      {Loop State 1}
   end
   
   fun{MessageProcess Msg State}
      case Msg
      of move(M) then {MoveTrainers M State.l} State
      [] get(B) then B = State.b State
      []combatplayer(X Y) then local Temp in
				  Temp = {CheckIfCombat X Y State.l} 
				  if Temp == 0 then State
				  elseif Temp == 11 then State 
				  else {LaunchCombatVsTrainer} state(b:State.b l:{RemoveNth State.l Temp})
				  end
			       end
			      
      []combatia(X Y) then local Temp in
			      Temp = {CheckIfCombat X Y State.l}
			      if Temp == 0 then State
			      elseif Temp == 11 then  {LaunchCombatVsTrainer}  state(b:State.b l:{RemoveNth State.l {FindByCoord X Y State.l}})
			      else State end
			   end
      []combatgrass(X Y) then {InGrass} State
	 
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

   proc {Victory}
      local Font in
	 Font = {QTk.newFont font(size:40)}
	 {Canvas create(window (W div 2) (H div 2) window:message(init:"You win" font:Font))}
	 {Delay 500}
	 {Application.exit 0}
	 end
   end
   
   
   proc{CheckIfWin X Y}%check if the player wins the game
      if X == (NbLines-1)*TmpL andthen Y == 0 then {Victory} end
   end
   
   proc{MovePlayer X Y} %move the player and check if a combat happens
      local Var in
	 {Send MoveManager get(Var)}
	 if Var==true then
	    
	    {Tag delete}
	    {Tag setCoords(X Y X+TmpL Y+TmpL)}
	    {CreateRectangle X Y}
	    {CheckIfWin X Y}
	    {Send MoveManager combatplayer(X Y)}
	    
	    local Ret in
	       {CheckInGrass X Y Ret}
	       if Ret==true then {Send MoveManager combatgrass(X Y)}
	       else
		  skip
	       end
	    end
	    
	 end
      end
   end
      

   proc{CreateRectangle X Y}	%procedure that creates a player rectangle and moves it
   
      {Canvas create(rect X Y X+TmpL Y+TmpL fill:blue tags:Tag)} 

      {Window bind(event:"<Up>" action:proc{$}  {MovePlayer X {Max 0 Y-TmpL}} end)}
      %move the rectangle by deleting the current one
      {Window bind(event:"<Down>" action:proc{$} {MovePlayer X {Min H-TmpL Y+TmpL}} end)}
      % and creating a new one in the direction indicated
      {Window bind(event:"<Left>" action:proc{$} {MovePlayer {Max 0 X-TmpL} Y} end)}
      {Window bind(event:"<Right>" action:proc{$} {MovePlayer {Min H-TmpL X+TmpL} Y} end)}
      
   end

   proc{AutoPlayer X Y} %move the player and check if a combat happens
      local Var in
	 {Send MoveManager get(Var)}
	 if Var==true then
	    {Tag setCoords(X Y-TmpL X+TmpL Y)}
	    {CheckIfWin X Y}
	    {Send MoveManager combatplayer(X Y)}
	    
	    local Ret in
	       {CheckInGrass X Y Ret}
	       if Ret==true then {Send MoveManager combatgrass(X Y)}
	       else
		  skip
	       end
	    end
	    
	 end
      end
   end

   proc {AutoGame}
      proc {Loop X Y}
	 {Delay 300}
	 {AutoPlayer X Y-TmpL}
	 
	 {Loop X Y-TmpL}
      end
   in
      {Canvas create(rect (NbLines-1)*TmpL (NbLines-1)*TmpL (NbLines-1)*TmpL+TmpL (NbLines-1)*TmpL+TmpL fill:blue tags:Tag)}
      thread {Loop (NbLines-1)*TmpL (NbLines-1)*TmpL} end
   end
  
   proc{MapScreen P A} %draw the map on the screen and launch the movement of the trainers
      Player = P
      Auto = A
      {DispW}
      {Window show}

      {GenerateGrid H}
      {GenerateGameMap Map}

      Tag={Canvas newTag($)}

      if Auto == false then %manual game
	 {CreateRectangle (NbLines-1)*TmpL (NbLines-1)*TmpL}
      else {AutoGame}%automatic game
      end
      
      ListTags = {InitRectangles}

      {NewMoveManager}

      
      {RandomMoves}
      
   end
end
