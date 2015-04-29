functor
   
import
   OS
   Window at 'window.ozf'
export
   CombatVSTrainer
define 
   IsFinished  %0 if the player winned the combat and 1 if he lost, 2 if the player or the wild pokemoz fled
   Player  %Player port
   Opponent  %Opponent port

   proc{AddExp} %add exp to the winning pokemoz
      local X in
	 if {IsKo Opponent} then {Send Opponent get(X)} {Send Player exp(X.p1.lx)}
	 elseif {IsKo Player} then {Send Player get(X)} {Send Opponent exp(X.p1.lx)}
	 else skip
	 end
      end
   end      
   
   proc{CombatFinished} %check if the combat is finished
      local X Y in
	 {Send Player defeated(X)} %check if the Player is defeated
	 {Send Opponent defeated(Y)}%check if the Opponent is defeated
	 if X == true then IsFinished=1
	 elseif Y == true then IsFinished=0
	 else skip
	 end
      end
   end

   fun{IsKo Trainer} %Return true if the first pokemoz (the one fighting) of the trainer if KO
      local KO in
	 {Send Trainer ko(KO)}
	 KO
      end
   end

   proc{Attack Attacker Defender}%attack by the attacker on the defender
      local X in
	 {Send Attacker get(X)} %get attacker record
	 {Send Defender attack(X.p1)}%send an attack message to the defender
      end
   end
   
   proc{IAReactionAttack} %IA reaction when being attacked
      {Attack Opponent Player}
   end

   proc{ActionAttack} %when the player attack the opponent pokemoz
      local X  Coin in
	 Coin={OS.rand} mod 2 %generate 0 or 1
	 if Coin==0 then %the player attacks first
	    {Attack Player Opponent}
	    if {IsKo Opponent} == false then {IAReactionAttack} end %if the attack received didn't koed the opponent's pokemoz
	    
	 else %the opponent attacks first 
	    {IAReactionAttack}
	    if {IsKo Player} == false then {Attack Player Opponent} end
	 end

	 {AddExp} %add experience to the winnig pokemoz if one

	 {CombatFinished} %ends the combat if one the trainers is defeated
      end
   end

   proc{ActionFlee}
      IsFinished=2
   end
   
   proc{DisplaySelectionAction} %Display the menu selection to choose an action between attack, switch pokemoz or flee
      local Select Grid in
	 
	 Select=grid(button(text:"Attack" action:proc{$} {ActionAttack} end) button(text:"Change")  newline %Grid for selecting an action to do when in battle (attack, switch pokemoz or flee)
		     button(text:"Flee" action:proc{$} {ActionFlee} end) empty  newline
		     handle:Grid)
	 {Window.addGrid ({Window.getWidth} div 6)*5 ({Window.getHeight} div 6)*5 Select}
	 
      end
   end
   
   proc{DisplayCombat} %Display the combat between two trainers or one trainer and a wild pokemoz
      {DisplaySelectionAction}
   end
   
   fun{CombatVSTrainer P O} %combat between 2 trainers where P is the current player and O is an IA trainer
      Player = P
      Opponent = O
      
      {Window.createWindow}
      {Window.showWindow}
      {DisplayCombat}
      
      IsFinished
   end
   
   
   
end
