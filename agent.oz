%Creates a new trainer agent and a new pokemoz agent.

functor
export
   NewTrainer
   NewPokemOz

define
   fun{TrainerEvent Msg State} %trainer event caused by message received
      case Msg
      of get(T) then T=State State end
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
   
end