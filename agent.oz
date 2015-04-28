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
      if {ListPokemOz.attackSuccess Pa.lx Pd.lx}==true  %of attack succeed
      then local Damage in Damage={ListPokemOz.attackDamage Pa.t Pd.t} %we compute the damage received based on the attacker and defender's type
	      pokemoz(t:Pd.t n:Pd.n hp:health(r:((Pd.r)-Damage) m:Pd.m) lx:Pd.lx xp:Pd.xp)
	   end
	 
      else Pd
      end
   end
   
   fun{TrainerEvent Msg State} %trainer event caused by message received
      case Msg
      of get(T) then T=State State %to get the trainer record
      []starter(P) then local PokemOz in      %to set the starter pokemoz for the trainer
			   PokemOz=pokemoz(t:P.type n:P.name hp:health(r:20 m:20) lx:5 xp:0)
			   trainer(c:State.c r:State.r isDefeated:State.isDefeated p1:PokemOz p2:State.p2 p3:State.p3)  
			end
	 []attack(P) then {CaseAttack P State.p1}
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

   fun{NewIA R} %Creates a new IA and adds it to the list of IA, R is the record representing the new Trainer
      fun {Loop R N}
	 if ListTrainers.N == unit then {Loop R N+1} 	 
	 elseif N == 10 then ~1 
	 else {NewTrainer R}
	 end
      end
   in
      {Loop R 0}
   end
      

   %Get methods
   fun{GetPlayer}
      Player
   end

   fun{GetListTrainers}
      ListTrainers
   end
   
end