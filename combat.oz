% declare [QTk]={Module.link ["x-oz://system/wp/QTk.ozf"]}

% local
%    Canvas
%    Grid
%    W=600	%width of the screen
%    H=600	%height of the screen
%    Desc = td(canvas(bg:white	%description of the canvas representing the screen
% 		    width:W
% 		    height:H
% 		    handle:Canvas))
 
%    Window={QTk.build Desc}
   
%    proc {DisplaySelectAction X Y Canvas} %Show the select action menu.
%       local Select Width Height
%       in
% 	 Width=14 %Number of characters
% 	 Height=2 %Nulber of line
% 	 Select=grid(button(text:"Attack" height:Height width:Width) button(text:"Change" height:Height width:Width)  newline
% 		     button(text:"Flee" height:Height width:Width) empty  newline
% 		     handle:Grid)
% 	 {Canvas create(window X Y window:Select anchor:nw)}
%       end
      
%    end

%    proc {DisplayBattleMessage X Y Canvas} %Display the message of the combat
%       local Message Width Height
%       in
% 	 Width=43 %Nulber of characters per line
% 	 Height=5 %Number of line
% 	 Message=label(init:"Choose an action" height:Height width:Width)
% 	 {Canvas create(window X Y window:Message anchor:nw)}
%       end
%    end

%    proc{DisplayFrames X Y Canvas} %Display the frames of the combat screen
%       {Canvas create(line 0 500 X 500)}
%       {Canvas create(line 350 500 350 Y)}
%    end
   
   
% in
%    {Window show} %show the map
%    {DisplaySelectAction 351 501 Canvas}
%    {DisplayBattleMessage 1 501 Canvas}
%    {DisplayFrames W H Canvas}
% end

functor
   
import
   OS
   Window at 'window.ozf'
export
   CombatVSTrainer
define 

   proc{IAReactionAttack Player Opponent} %IA reaction when being attacked
      local X in
	 {Send Opponent get(X)} 
	 {Send Player attack(X.p1)}
      end
   end

   proc{ActionAttack Player Opponent} %when the player attack the opponent pokemoz
      local X  Coin in
	 Coin={OS.rand} mod 2 %generate 0 or 1
	 if Coin==0 then %the player attacks first
	    {Send Player get(X)} %get trainer record
	    {Send Opponent attack(X.p1)} %send an attack message
	    {IAReactionAttack Player Opponent}
	    
	 else %the opponent attacks first 
	    {IAReactionAttack Player Opponent}
	    {Send Player get(X)} 
	    {Send Opponent attack(X.p1)}
	 end
      end
   end
   
   proc{DisplaySelectionAction Player Opponent} %Display the menu selection to choose an action between attack, switch pokemoz or flee
      local Select Grid in
	 
	 Select=grid(button(text:"Attack" action:proc{$} {ActionAttack Player Opponent} end) button(text:"Change")  newline %Grid for selecting an action to do when in battle (attack, switch pokemoz or flee)
		     button(text:"Flee") empty  newline
		     handle:Grid)
	 {Window.addGrid ({Window.getWidth} div 6)*5 ({Window.getHeight} div 6)*5 Select}
	 
      end
   end
   
   proc{DisplayCombat Player Opponent} %Display the combat between two trainers or one trainer and a wild pokemoz
      {DisplaySelectionAction Player Opponent}
   end
   
   fun{CombatVSTrainer Player Opponent} %combat between 2 trainers where player is the current player and opponent is an IA trainer
      {Window.createWindow}
      {Window.showWindow}
      {DisplayCombat Player Opponent}
      true
   end
   
   
   
end
