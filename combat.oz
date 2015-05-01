%Combat entre trainer ou trainer contre pokemoz sauvage
functor
   
import
   Module
   OS
   ListPokemoz at 'list_pokemoz.ozf'
export
   CombatVSTrainer
   CombatVSWild
   InitializeCombatWindow
define 
   IsFinished  %0 if the player winned the combat and 1 if he lost, 2 if the player or the wild pokemoz fled
   Player  %Player port
   Opponent  %Opponent port
   Window %window on which we add graphical elements
   OpponentType %1 for trainer 2 for wild pokemoz
   
   TextHandle  %To change the text on screen
   PlayerNamePokemozHandle
   PlayerHpPokemozHandle
   OpponentNamePokemozHandle
   OpponentHpPokemozHandle
   
   TimeDelay = 1000

   %Texts to be displayed when in combat
   proc{IntroductionText}
      local Text in
	 if OpponentType == 1 then Text = "A trainer challenged you"
	 else Text = "A wild pokemoz attacked you"
	 end
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
	 Text = " is going to fight"
	 {Window.changeMessageText TextHandle {Append PokemozName Text}}
      end
   end

   proc{AttackText}
      local Text in
	 Text = "A Pokemoz attack"
	 {Window.changeMessageText TextHandle Text}
      end
   end
   
   
   proc{UpdateDisplayNamePokemoz IsPlayer Type Name} %update the name of the pokemon fighting on the window
      local Color in
	 Color = {ListPokemoz.colorByType Type}
	 if IsPlayer == true then {Window.changeMessageText PlayerNamePokemozHandle Name}
	    {Window.changeMessageColor PlayerNamePokemozHandle Color}
	    
	 else  {Window.changeMessageText OpponentNamePokemozHandle Name}
	    {Window.changeMessageColor OpponentNamePokemozHandle Color}
	 end
      end
   end
   
   proc{DisplayNamePokemoz IsPlayer Type Name} %display the name of the pokemoz, isPlayer is there to indicate if it's the player pokemoz
      local Color in
	 Color = {ListPokemoz.colorByType Type}
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

   proc{CleanWindowCombat} %destroy all elements on the window (blank screen)
      {Window.cleanWindow}
   end
   
   proc{CombatFinished} %check if the combat is finished
      local X Y in
	 {Send Player defeated(X)} %check if the Player is defeated
	 {Send Opponent defeated(Y)}%check if the Opponent is defeated
	 
	 if X == true then IsFinished=1 {CleanWindowCombat} %if the combat is finished, then we make the screen blank
	 elseif Y == true then IsFinished=0 {CleanWindowCombat}
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

	 {ChooseActionText}
      end
   end

   proc{ActionSwitch}%when selecting the button "switch"
      local Switched SwitchPokemoz X in
	 %switch pokemoz
	 [SwitchPokemoz] = {Module.link ['switch_pokemoz.ozf']}
	 {SwitchPokemoz.initializeSwitchWindow Window Player}
	 Switched = {SwitchPokemoz.displaySwitchWindow}
	 %update the screen to display the new pokemoz
	 {Send Player get(X)}
	 {UpdateDisplayNamePokemoz true X.p1.t X.p1.n}
	 {UpdateDisplayHpPokemoz true Player}
      end
   end

   proc {MessageFlee IsPlayer} %message when someone flee, IsPlayer is there to see if it's the player that flee or the the wild pokemoz
      local Text in
	 if IsPlayer == true then Text="You flee"
	 else Text = "The pokemoz flee"
	 end
	 {Window.changeMessageText TextHandle Text}
      end
   end
   
   proc{ActionFlee}
      if OpponentType == 2 then {MessageFlee true} {Delay TimeDelay} {Window.cleanWindow} IsFinished=2 end
   end

   fun{CaptureSuccess} %return true if the capture succeeded, else false
      local Probability Random X in
	 {Send Opponent get(X)}
	 Probability = (X.hp.m - X.hp.r)*5 %probability to capture the pokemoz
	 Random = {OS.rand} mod 100

	 if Random < Probability then true
	 else false
	 end
      end
   end

   proc {MessageCapture Success} %message when capturing a pokemoz
      local Text in
	 if Success = true then Text = "You captured the pokemoz"
	 else Text = "You failed to capture the pokemoz"
	 end
	 {Window.changeMessageText TextHandle Text}
      end
   end

   fun{FindSpace} %return the empty space for the trainer
      local X in
	 {Send Player get(X)}
	 if X.p2 \= nil then 2
	 elseif X.p3 \= nil then 3
	 else 0
	 end
      end
   end
      
   proc{FullPokemozMessage}%message when having already 3 pokemoz and trying to capture one
      local Text in
	 Text = "You have already 3 Pokemoz"
	 {Window.changeMessageText TextHandle Text}
      end
   end
   
   proc{AddPokemoz}%add pokemoz for the player
      local Space Y in
	 Space = {FindSpace}
	 if Space == 0 then {FullPokemozMessage} {Delay TimeDelay}
	 else {Send Opponent get(Y)} {Send Player add(id:Space p:Y.p1)} 
	 end
      end
   end
   
   proc{ActionCapture}%when clicking on the button capture
      local Success  in
	 Success = {CaptureSuccess}
	 if Success == true then {MessageCapture true} {Delay TimeDelay} {AddPokemoz} {Window.cleanWindow} IsFinished=3
	 else {MessageCapture false}
	 end
      end
   end
   
   proc{DisplaySelectionAction} %Display the menu selection to choose an action between attack, switch pokemoz or flee
      local Select Grid in
	 
	 Select=grid(button(text:"Attack" action:proc{$} {ActionAttack} end) button(text:"Switch" action:proc{$} {ActionSwitch} end) newline %Grid for selecting an action to do when in battle (attack, switch pokemoz or flee)
		     button(text:"Flee" action:proc{$} {ActionFlee} end) button(text:"Capture" action:proc{$} {ActionCapture} end)  newline
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
      OpponentType = 1
      
      {DisplayCombat}
      
      IsFinished
   end
   
   fun{CombatVSWild P O}%combat between one trainer and a wild pokemoz where P is the current player and O is the wild pokemoz
      Player = P
      Opponent = O
      OpponentType = 2
      
      {DisplayCombat}

      IsFinished
   end
   
   proc{InitializeCombatWindow W}
      Window = W
   end
   
end
