declare

% import  %need to import Application
% Application


proc{GameOver}%quit the game
   {Application.exit 0}
end

proc{MapReload}%reload the map after a combat
   %TODO reload the map
end

proc{AfterCombat ResultCombat} %Lauch the game over screen or reload the map depending of the result of the combat
   if ResultCombat == 1 then {GameOver} %the player lose the game
      else {MapReload} %the player winned the combat or fled
end

fun{IsAttackedByWild}%return true if a wild pokemoz attack the player, false otherwise
   local Probability in
      Probability = {OS.rand} mod 3
      if Probability = 1 then true
      else false end
   end
end

fun{CreateTrainer Number}%create a trainer where Number is the number of pokemoz that the trainer have and Lx is the level of the player
   fun{Loop N R Init}
      local Pokemoz X in
	 {Send Player get(X)}
	 Pokemoz = {Pokemoz.createPokemOz X.lx}%generates a pokemoz
	 if R == 1 then {Loop N R+1 trainer(c:0 r:0 isDefeated:false p1:Pokemoz p2:nil p3:nil)}
	 elseif R == 2 then if R > N then Init
			    else  {Loop N R+1 trainer(c:0 r:0 isDefeated:false p1:Init.p1 p2:Pokemoz p3:nil)}
			    end
	 elseif R==3 then if R > N then Init
			  else   {Loop N R+1 trainer(c:0 r:0 isDefeated:false p1:Init.p1 p2:Init.p2 p3:Pokemoz)}
			  end
	 else Init
	 end
      end
   end
in
   {Loop Number 1  trainer(c:0 r:0 isDefeated:false p1:nil p2:nil p3:nil)}
end

proc{LaunchCombatVsWild} %launch the combat vs a wild pokemoz
   local WildPokemoz Opponent Trainer ResultCombat Combat Agent in
      [Combat] = {Module.link ['combat.ozf']} %load the module for the combat
      [Agent] = {Module.link ['agent.ozf']} %load the module for the agent creation
      
      Trainer = {CreateTrainer 1} 
      Opponent = {Agent.newIA Trainer 1}
      
      ResultCombat = {Combat.combatVSWild Player Opponent}
      {AfterCombat ResultCombat}
   end
end

proc{InGrass} %If the player is in grass, there is possibility that a wild pokemoz attack the player
      if {IsAttackedByWild} == true then {LaunchCombatVsWild}
      end
end


proc{LaunchCombatVsTrainer} %launch a combat vs a trainer
   local WildPokemoz Opponent Trainer ResultCombat Combat Agent Number in
      [Combat] = {Module.link ['combat.ozf']} %load the module for the combat
      [Agent] = {Module.link ['agent.ozf']} %load the module for the agent creation

      Number = ({OS.rand} mod 3) + 1 %generates a number between 1 and 3, it's the number of pokemoz that the trainer held 
      Trainer = {CreateTrainer Number} 
      Opponent = {Agent.newIA Trainer 1}
      
      ResultCombat = {Combat.combatVSTrainer Player Opponent}
      {AfterCombat ResultCombat}
   end
end