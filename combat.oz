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
   
   TextHandle  %To change the text on screen
   PlayerNamePokemozHandle
   PlayerHpPokemozHandle
   OpponentNamePokemozHandle
   OpponentHpPokemozHandle
   
   TimeDelay = 1000

   %Texts to be displayed when in combat
   proc{IntroductionText}
      local Text in
	 Text = "A trainer challenged you"
	 TextHandle={Window.addMessage ({Window.getWidth} div 6)*2 ({Window.getHeight} div 6)*5 Text}
      end
   end

   proc{ChooseActionText}
      local Text in
	 Text = "Choose an action"
	 {Window.changeMessageText TextHandle Text}
      end
   end

   proc{LaunchPokemozText PokemozName}
      local Text in
	 Text = "Trainer send "
	 {Window.changeMessageText TextHandle {Append Text PokemozName}}
      end
   end

   proc{AttackText}
      local Text in
	 Text = "A Pokemoz attack"
	 {Window.changeMessageText TextHandle Text}
      end
   end
   
   fun{ColorByType Type}%return the color corresponding to a type of Pokemoz
      if Type=="grass" then green
      elseif Type=="fire" then red
      elseif Type=="water" then blue
      else white
      end
   end
   
   proc{DisplayNamePokemoz IsPlayer Type Name} %display the name of the pokemoz, isPlayer is there to indicate if it's the player pokemoz
      local Color in
	 Color = {ColorByType Type}
	 if IsPlayer == true then PlayerNamePokemozHandle={Window.addColoredMessage ({Window.getWidth} div 6)*3 ({Window.getHeight} div 6)*4  Name Color}
	 else  OpponentNamePokemozHandle={Window.addColoredMessage ({Window.getWidth} div 6)*3 ({Window.getHeight} div 6)*2 Name Color}
	 end
      end
   end

   proc{DisplayHpPokemoz IsPlayer Remaining}%display the remaining hp of the pokemoz, IsPlayer is there to indicate if it's the player pokemoz
      if IsPlayer == true then PlayerHpPokemozHandle={Window.addMessage ({Window.getWidth} div 6)*4 ({Window.getHeight} div 6)*4  Remaining}
      else OpponentHpPokemozHandle={Window.addMessage ({Window.getWidth} div 6)*4 ({Window.getHeight} div 6)*2 Remaining}
      end
   end

   proc{UpdateDisplayHpPokemoz IsPlayer TrainerPort} %update on the screen the remaining hp of the pokemoz, IsPlayer is there to indicate if it's the player pokemoz
      local X Remaining in
	 {Send TrainerPort get(X)}
	 Remaining = X.p1.hp.r
	 if IsPlayer == true then {Window.changeMessageText PlayerHpPokemozHandle Remaining}
	 else {Window.changeMessageText OpponentHpPokemozHandle Remaining}
	 end
      end
   end
   
   proc{DisplayPokemOz} %display the pokemoz status on the screen
      local X Y PlayerP OpponentP in
	 {Send Player get(X)}
	 {Send Opponent get(Y)}
	 PlayerP = X.p1
	 OpponentP = Y.p1

	 {LaunchPokemozText PlayerP.n}%Indicates which pokemoz is sent
	 {Delay TimeDelay}
	 {DisplayNamePokemoz true PlayerP.t PlayerP.n}
	 {DisplayHpPokemoz true PlayerP.hp.r}
	 {Delay TimeDelay}
	 
	 

	 {LaunchPokemozText OpponentP.n}
	 {Delay TimeDelay}
	 {DisplayNamePokemoz false OpponentP.t OpponentP.n}
	 {DisplayHpPokemoz false OpponentP.hp.r}

      end
   end
   
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

   proc{Attack Attacker Defender}%attack by the attacker on the defender, IsPlayer is there to indicate if it's the player pokemoz that attacks
      local X in
	 {Send Attacker get(X)} %get attacker record
	 {Send Defender attack(X.p1)}%send an attack message to the defender
	 {AttackText}
      end
   end
   
   proc{IAReactionAttack} %IA reaction when being attacked
      {Attack Opponent Player}
      {UpdateDisplayHpPokemoz true Player}
   end

   proc{ActionAttack} %when the player attack the opponent pokemoz
      local Coin in
	 Coin={OS.rand} mod 2 %generate 0 or 1
	 if Coin==0 then %the player attacks first
	    {Attack Player Opponent}
	    {UpdateDisplayHpPokemoz false Opponent}
	    if {IsKo Opponent} == false then {IAReactionAttack} end %if the attack received didn't koed the opponent's pokemoz
	    
	 else %the opponent attacks first 
	    {IAReactionAttack}
	    if {IsKo Player} == false then {Attack Player Opponent} {UpdateDisplayHpPokemoz false Opponent} end
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
      {IntroductionText}
      {Delay TimeDelay}
      
      {DisplayPokemOz}
      
      {ChooseActionText}
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
