%Class correspondant a la map

functor
import
   Browser
   OS
   QTk at 'x-oz://system/wp/QTk.ozf'
  
   
export
   GenerateGrid
   GenerateGameMap
   CreateRectangle
   NewMap
   MoveTrainer
   MapScreen
   %NewMap
define
   %CREE AGENTS ICI
   
   %Hardcoded Map
   PortMap % Correspond to a map agent
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
   TagTemp1
   TagTemp2
   Tag1 Tag2 Tag3 Tag4 Tag5 Tag6 Tag7 Tag8 Tag9 Tag10 TagP
   T1 T2 T3 T4 T5 T6 T7 T8 T9 T10 TP
   NbGamers=({OS.rand} mod 10)+1
   %ListTags=listTags(tagP:TP 1:T1 2:T2 3:T3 4:T4 5:T5 6:T6 7:T7 8:T8 9:T9 10:T10)
   ListTags
  % {Browser.browse ListTags}
  % Tag1={Canvas newTag($)} %Correspond au premier rectangle --> En faire une liste de tag correspondant a l'ensemble des rectangles
  % Tag2={Canvas newTag($)} %Correspond au second rectangle
 %{Canvas create(rect 10 10 100 100 fill:blue tags:Tag2)}
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
      for I in 1..NbLines do %FOR A RETIRER
	 for J in 1..NbLines do
	    if M.J.I==1 then %Grass Cell 
	       {Canvas create(rect (I-1)*TmpL (J-1)*TmpL (I)*(TmpL) (J)*(TmpL) fill:green)}
	    end
	 end
      end
   end
   
   proc {CheckInGrass X Y Ret}
      for I in 1..NbLines do
	 for J in 1..NbLines do  %PE inverser I J
	    if I == (X div TmpL) andthen J == (Y div TmpL) then % PE +1
	       if Map.J.I==1 then Ret=true else Ret=false end
	    end
	 end
      end
   end
   
   %proc{InitRectangles ListTags}
    %  case ListTags of H|T then
   %{Browser.browse H}
%	 {Canvas create(rect 0 0 0 0 fill:blue tags:H)}
%	 {InitRectangles T}
 %     else
%	 skip
 %     end
      
  % end
   fun{InitRectangles N}
      fun{InitRectangles2 LAcc N}
	 if N==0 then LAcc
	 else
	    local H in
	       
	       {Browser.browse aaaa}
	       H={Canvas newTag($)}
	       {Canvas create(rect 10 10 100 100 fill:blue tags:H)}
	       {Browser.browse bbbb}
	       {InitRectangles2 H|LAcc N-1}
	    end
	 end
      end
   in
      {InitRectangles2 nil 10} % Changer le 10
   end
   
   %IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
   
   proc{CreateRectangle X Y ListTrainers}	%procedure that creates a rectangle and moves it
      %INTRODUIRE NOTION DE TEMPS
      
      Tag={Canvas newTag($)}
      {Canvas create(rect X+10 Y+10 X+90 Y+90 fill:blue tags:Tag)}
      
      %Tag1={Canvas newTag($)}
     % {Canvas create(rect 110 110 180 180 fill:blue tags:Tag1)}
     % TagTemp1=Tag1
     % Tag2={Canvas newTag($)}
     % {Canvas create(rect 10 10 100 100 fill:blue tags:Tag2)}
     % TagTemp2=Tag2
     % {Delay 1000}
      %{Tag2 setCoords(150 150 250 250)}
     % {Tag2 delete}
     % {InitRectangles (ListTags)}%%%%
     % Tag=ListTags.1
     % {Tag setCoords(X
    %  {Tag2 setCoords(150 150 250 250)}
    %  local TEMP
%	 
%	 {Tag getCoords(TEMP)}
%	 {Browser.browse TEMP}
 %     end
      
   in

      {Window bind(event:"<Up>" action:proc{$} {Tag delete} {CreateRectangle X {Max 0 Y-TmpL} ListTrainers } end)}
      %move the rectangle by deleting the current one
      {Window bind(event:"<Down>" action:proc{$} {Tag delete} {CreateRectangle X {Min H-TmpL Y+TmpL} ListTrainers} end)}
      % and creating a new one in the direction indicated
      {Window bind(event:"<Left>" action:proc{$} {Tag delete} {CreateRectangle {Max 0 X-TmpL} Y ListTrainers} end)}
      {Window bind(event:"<Right>" action:proc{$} {Tag delete} {CreateRectangle {Min H-TmpL X+TmpL} Y ListTrainers} end)}
      
   end
   %--Obsolete
   fun{MapPosToRect Trainer} % Take a trainer in argument and return the up-left position of trainer's rectangle
      pos(x:((Trainer.c)-1)*(TmpL) y:((Trainer.r)-1)*(TmpL)) % PE retirer le -1
   end
   %--
      
   fun{Equals A B} % A METTRE DANS CLASSE UTIL
      if A==B then 1
      else 0
      end
   end
   %Deplace (si possible) le trainer Trainer dans la direction Direction et renvoie le trainer mis a jour
   %Direction=0 pas de deplacement, 1 haut, 2 droite, 3 bas, 4 gauche
   %Obsolete--------------
   proc{MoveTrainer Trainer Direction}
      case Trainer of trainer(c:Columns r:Row isDefeated:B p1:Pokemoz1 p2:Pokemoz2 p3:Pokemoz3) then
	 local T2 Tag2 in
	    T2=trainer(c:{Max {Min NbLines Columns+{Equals Direction 2}-{Equals Direction 4}} 0} % Contraint les deplacements a la map
		       r:{Max {Min NbLines Row+{Equals Direction 3}-{Equals Direction 1}} 0}
		       isDefeated:B
		       p1:Pokemoz1
		       p2:Pokemoz2
		       p3:Pokemoz3)
	    
	    %Impacter ces deplacements sur la map
	    %Verifier si aucun ennemi en meme temps sur la meme case
	    %Concurrence?
	   % {Browser.browse a}
	    Tag2={Canvas newTag($)}
	    {Canvas create(oval 10 10 100 100 fill:blue tags:Tag2)}

	   % {Browser.browse b}
	   % {Browser.browse T2}
	    %T2
	    
	 end
      end
   end
   %------------------------
   %Receive a record of type: listMoves(player:M 1:M1 2:M2 3:M3 4:M4 5:M5 6:M6 7:M7 8:M8 9:M9 10:M10)
   %And move each corresponding rectangle on the map at the correct direction
   proc{MoveTrainers ListTrainers}

      case ListTrainers of listMoves(player:M 1:M1 2:M2 3:M3 4:M4 5:M5 6:M6 7:M7 8:M8 9:M9 10:M10) then
	 local Temp1 Temp2 Temp3 Temp4 Temp5 X1 Y1 X2 Y2 X3 Y3 X4 Y4 X5 Y5 in % Pour l'instant 5 % Ces Temp contiennent les coordonnees de chacun des rectangles
	    {ListTags.1 getCoords(Temp1)}
	   % {Browser.browse Temp1} %s'affiche
	    {ListTags.1 getCoords(Temp2)}
	  %  {Browser.browse Temp2} %s'affiche
	   % {Browser.browse ListTags.1}
	    {Browser.browse M1}
	    {Browser.browse M2}
	    {Browser.browse zzzzzzzzzzz1}
	    {Browser.browse NbLines}
	    {Browser.browse TmpL}
	    {Browser.browse M1}
	    {Browser.browse {Equals M1 2}}
	    {Browser.browse {Equals M1 4}}
	    %X1={Max {Min (NbLines-1)*TmpL Temp1.1+{Equals M1 2}-{Equals M1 4}} 0} %Rappel: 1=haut, 2=droite, 3=bas,4=gauche
	    local X1 Y1 E1 E2 Z in
	       X1={Float.toInt Temp1.1}+{Equals M1 2}-{Equals M1 4}
	       {Browser.browse zzzzzzzzzzz2}
	       Y1={Max {Min (NbLines-1)*TmpL {Float.toInt Temp1.2.1}+{Equals M1 3}-{Equals M1 1}} 0} %On s'assure aussi que ces deplacements restent dans la fenetre
	     
	       {Browser.browse zzzzzzzzzzz3}
	       {Browser.browse M1}
	      
	       if M1==2 then E1=1 else E1=0 end
	       if M1==4 then E2=2 else E2=0 end
	       % BLOQUE ICI, COMPREND PAS :(
	       %...........
	       {Browser.browse X1}
	       {Browser.browse zzzzzzzzzzz4}
	       {Browser.browse Y1}
	       {Browser.browse zzzzzzzzzzz5}
	       {ListTags.1 setCoords(X1 Y1 X1+TmpL Y1+TmpL)} % MODIF ICI
	       {Browser.browse zzzzzzzzzzz6}

	    %J'ESSAIE POUR L'INSTANT QU'AVEC UN SEUL RECTANGLE A BOUGER
	    end
	    
	 end
      end
   end
   
	    
%	    {ListTags.1
			      
   %Retourne le port correspondant a la map1
   fun{NewMap } 
      proc{Loop S}
	 case S of (Trainer#Direction)|S2 then %Obsolete
	    {MoveTrainer Trainer Direction}
	    {Loop S2}
	 [] listMoves(player:M 1:M1 2:M2 3:M3 4:M4 5:M5 6:M6 7:M7 8:M8 9:M9 10:M10)|S2 then
	    {MoveTrainers listMoves(player:M 1:M1 2:M2 3:M3 4:M4 5:M5 6:M6 7:M7 8:M8 9:M9 10:M10)}
	    {Loop S2}
%%%%
	 end
      end
      P S 
   in
      P={NewPort S}
      thread {Loop S} end
      P
   end
   
   proc{MapScreen}
      {Window show} %show the map
      {GenerateGrid H}
      {GenerateGameMap Map}
      %{InitRectangles ListTags}
      ListTags={InitRectangles 10}
      {Browser.browse xxxxx}
      {MoveTrainers listMoves(player:0 1:3 2:0 3:0 4:0 5:0 6:0 7:0 8:0 9:0 10:0)}
      {Browser.browse yyyyy}
      {Browser.browse ListTags.1}
      {CreateRectangle W-TmpL H-TmpL nil}
   end
   
end
