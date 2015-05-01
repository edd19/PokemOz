%Creates a new trainer agent and a new pokemoz agent.
%A trainer is of the form trainer(c:column r:row isDefeated:b p1:pokemoz p2:pokemoz p3:pokemoz)
%A pokemoz is of the form pokemoz(t:type n:name hp:health(r:remaining m:max) lx:level xp:experience)

functor

import
   ListPokemOz at 'list_pokemoz.ozf'
export
   NewPlayer
   NewIA
   NewPokemOz
   GetPlayer
   GetListTrainers

define
   Player
   Ia1 Ia2 Ia3 Ia4 Ia5 Ia6 Ia7 Ia8 Ia9 Ia10 %Maximum of 10 trainers (IA) by map 
   ListTrainers=listtrainers(player:Player 1:Ia1 2:Ia2 3:Ia3 4:Ia4 5:Ia5 6:Ia6 7:Ia7 8:Ia8 9:Ia9 10:Ia10)

   fun{CaseAttack Pa Pd} %attack routine when a pokemoz (Pa) attack another one (Pd), return the new state of the defender pokemoz (Pd)
      if {ListPokemOz.attackSuccess Pa.lx Pd.lx} == true  %of attack succeed
      then local Damage Remaining in Damage={ListPokemOz.attackDamage Pa.t Pd.t} %we compute the damage received based on the attacker and defender's type
	      if Pd.hp.r > Damage then Remaining = ((Pd.hp.r)-Damage) %so that the hp are never inferior than 0
	      else Remaining = 0
	      end
	      pokemoz(t:Pd.t n:Pd.n hp:health(r:Remaining m:Pd.hp.m) lx:Pd.lx xp:Pd.xp)
	   end
	 
      else Pd
      end
   end

   fun{IsKo Pokemoz} %check if the pokemoz is ko
      if Pokemoz == nil then true
      else if Pokemoz.hp.r == 0 then true
	   else false end
      end
   end
   
   fun{IsDefeated Trainer}%check if the trainer is defeated and update the trainer record in need
      local R in
	 if {IsKo Trainer.p1} == true then
	    if {IsKo Trainer.p2}==true then
	       if {IsKo Trainer.p3} == true then
		 R= trainer(c:Trainer.c r:Trainer.r isDefeated:true p1:Trainer.p1 p2:Trainer.p2 p3:Trainer.p3) %set the vaule isDefeated to true
	       else R= Trainer
	       end
	    else R=Trainer
	    end
	 else R= Trainer
	 end
	 R
      end
   end

   fun{LevelManagement Pokemoz} %Check if the pokemoz levels up with it's current xp
      local Lvl Exp Remaining Maximum  in
	 Exp = Pokemoz.xp
	 if Exp > 49 then Lvl = 10
	 elseif Exp > 29 then Lvl = 9
	 elseif Exp > 19 then Lvl = 8
	 elseif Exp > 11 then Lvl = 7
	 elseif Exp > 4 then Lvl = 6
	 else Lvl = 5
	 end

	 Maximum = {ListPokemOz.getMaxHealth Lvl}%set a new maximum health if leveled up
	 
	 if Lvl == Pokemoz.lx then Remaining = Pokemoz.hp.r %if the pokemoz leveled up then his health is restore to it's maximum
	 else Remaining = Maximum
	 end
	 pokemoz(t:Pokemoz.t n:Pokemoz.n hp:health(r:Remaining m:Maximum) lx:Lvl xp:Pokemoz.xp)
      end
   end
   
   fun{TrainerEvent Msg State} %trainer event caused by message received
      case Msg
      of get(T) then T=State State %to get the trainer record
      []starter(P) then local PokemOz in      %to set the starter pokemoz for the trainer
			   PokemOz=pokemoz(t:P.type n:P.name hp:health(r:20 m:20) lx:5 xp:0)
			   trainer(c:State.c r:State.r isDefeated:State.isDefeated p1:PokemOz p2:State.p2 p3:State.p3)  
			end
	 
      []attack(P) then {IsDefeated trainer(c:State.c r:State.r isDefeated:State.isDefeated p1:{CaseAttack P State.p1} p2:State.p2 p3:State.p3)} %when receiving an attack
	 
      []ko(B) then B={IsKo State.p1} State %to check if the pokemoz fighting is ko

      []defeated(B) then B=State.isDefeated State %to check if the trainer is defeated

      []exp(E) then local PokemOz in    %to increase your pokemoz experience
		       PokemOz = {LevelManagement pokemoz(t:State.p1.t n:State.p1.n hp:State.p1.hp lx:State.p1.lx xp:((State.p1.xp)+E))}
		       trainer(c:State.c r:State.r isDefeated:State.isDefeated p1:PokemOz p2:State.p2 p3:State.p3)
		    end

      []switch(Id) then if Id==2 then  trainer(c:State.c r:State.r isDefeated:State.isDefeated p1:State.p2 p2:State.p1 p3:State.p3) %to switch pokemoz
			elseif Id==3 then  trainer(c:State.c r:State.r isDefeated:State.isDefeated p1:State.p3 p2:State.p2 p3:State.p1)
			else  State
			end

      []add(id:Id p:Pokemoz) then if id == 2 then trainer(c:State.c r:State.r isDefeated:State.isDefeated p1:State.p1 p2:Pokemoz p3:State.p3) %to add a pokemoz
				  elseif id == 3 then trainer(c:State.c r:State.r isDefeated:State.isDefeated p1:State.p1 p2:State.p2 p3:Pokemoz)
				  else State
				  end
	 
      else State
      end
   end

   fun{NewTrainer R} %creates a new trainer agent, R is the record representing the trainer
      proc{Loop S R}
	 case S of Msg|S2 then
	    {Loop S2 {TrainerEvent Msg R}}
	 end
      end
      P S
   in
      P={NewPort S}
      thread {Loop S R} end
      P % return the port corresponding to the trainer
   end

   fun{PokemOzEvent Msg R} %pokemoz event caused by message received
      case Msg
      of get(P) then P=R  R end
   end
   
   fun{NewPokemOz R} %creates a new pokemoz agent, R is the record reprensenting the pokemoz
      proc{Loop S R}
	 case S of Msg|S2 then
	    {Loop S2 {PokemOzEvent Msg R}}
	 end
      end      
      P S
   in
      P= {NewPort S}
      thread {Loop S R} end
      P
   end

   fun{NewPlayer } %Creates a new player
      Player={NewTrainer trainer(c:0 r:0 isDefeated:false p1:nil p2:nil p3:nil)}
      Player
   end

   fun{NewIA R Id} %Creates a new IA and adds it to the list of IA, R is the record representing the new Trainer and Id is the number of the trainer
      ListTrainers.Id={NewTrainer R}
      ListTrainers.Id
   end
      

   %Get methods
   fun{GetPlayer}
      Player
   end

   fun{GetListTrainers}
      ListTrainers
   end
   
end