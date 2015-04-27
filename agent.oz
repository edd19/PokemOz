%Creates a new trainer agent and a new pokemoz agent.
%A trainer is of the form trainer(c:column r:row isDefeated:b p1:pokemoz p2:pokemoz p3:pokemoz)
%A pokemoz is of the form pokemoz(t:type n:name hp:health(r:remaining m:max) lx:level xp:experience)

functor
export
   NewPlayer
   NewIA
   NewPokemOz
   GetPlayer
   GetListTrainers

define
   Player
   ListTrainers=listtrainers(player:Player)
   fun{TrainerEvent Msg State} %trainer event caused by message received
      case Msg
      of get(T) then T=State State %to get the trainer record
      []starter(P) then local PokemOz in      %to set the starter pokemoz for the trainer
			   PokemOz=pokemoz(t:P.type n:P.name hp:health(r:20 m:20) lx:5 xp:0)
			   trainer(c:State.c r:State.r isDefeated:State.isDefeated p1:PokemOz p2:State.p2 p3:State.p3)  
			end
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

   fun{NewIA R} %Creates a new IA and adds it to the list of IA
      {NewTrainer R}
      %TODO add to list of IA
   end

   %Get methods
   fun{GetPlayer}
      Player
   end

   fun{GetListTrainers}
      ListTrainers
   end
   
end