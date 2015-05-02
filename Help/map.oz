%Class correspondant a la map

functor
import
   Browser % Je n'arrive pas a import  ce putain de browser
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
      %INTRODUIRE NOTION DE TEMPS
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

   fun{MapPosToRect Trainer} % Take a trainer in argument and return the up-left position of trainer's rectangle
      pos(x:((Trainer.c)-1)*(TmpL) y:((Trainer.r)-1)*(TmpL)) % PE retirer le -1
   end
      
   fun{Equals A B} % A METTRE DANS CLASSE UTIL
      if A==B then 1
      else 0
      end
   end
   %Deplace (si possible) le trainer Trainer dans la direction Direction et renvoie le trainer mis a jour
   %Direction=0 pas de deplacement, 1 haut, 2 droite, 3 bas, 4 gauche
   proc{MoveTrainer Trainer Direction}
      case Trainer of trainer(c:Columns r:Row isDefeated:B p1:Pokemoz1 p2:Pokemoz2 p3:Pokemoz3) then
	 local T2 Tag in
	    T2=trainer(c:{Max {Min NbLines Columns+{Equals Direction 2}-{Equals Direction 4}} 0} % Contraint les deplacements a la map
		       r:{Max {Min NbLines Row+{Equals Direction 3}-{Equals Direction 1}} 0}
		       isDefeated:B
		       p1:Pokemoz1
		       p2:Pokemoz2
		       p3:Pokemoz3)
	    
	    %Impacter ces deplacements sur la map
	    %Verifier si aucun ennemi en meme temps sur la meme case
	    %Concurrence?
	    {Browser.browse a}
	    Tag={Canvas newTag($)}
	    %{Canvas create(window 10 10 window:button(text:"Test" bg:blue))}
	    {Canvas create(rect 10 10 100 100 fill:blue tags:Tag)}
	    {Browser.browse b}
	    {Browser.browse T2}
	    %T2
	 end
      end
   end
   %Retourne le port correspondant a la map
   fun{NewMap } %ajouter arg?
      proc{Loop S}
	 case S of (Trainer#Direction)|S2 then
	    {MoveTrainer Trainer Direction}
	    {Loop S2}
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
      {CreateRectangle W-TmpL H-TmpL nil}
   end
   
end
