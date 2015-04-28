%List of pokemoz and additional methods for pokemoz
functor

import
   OS
   
export
   ListPokemOz
   ListStarter
   CreatePokemOz

define
   Number = 3 %Total number of PokemOz
   ListPokemOz=listpokemoz(1:pokemoz(name:"Bulbasoz" type:"grass")
			   2:pokemoz(name:"Oztirtle" type:"water")
			   3:pokemoz(name:"Charmandoz" type:"fire")
			  )
   ListStarter=liststarter(1:ListPokemOz.1
			   2:ListPokemOz.2
			   3:ListPokemOz.3)


   fun{RandomPokemOz} %Return a random PokemOz
      local N in
	 N = ({OS.rand} mod Number) + 1 %generates a number between 1 and Number
	                                %where Number is the total numbre of PokemOz
	 ListPokemOz.N %returns the Nth PokemOz in the list
      end
   end

   fun{RandomLvl Lvl} %Return a random level depending of the max level of the player's pokemoz
      local MinusOrPlus N Rlvl in
	 MinusOrPlus = {OS.rand} mod 2 %generates 0 or 1, if 0 we increase the lvl, if 1 we decrease it
	 N={OS.rand} mod 11 %generates a number between 0 and 10

	 if N < 2 then Rlvl=Lvl
	 elseif N < 5 then Rlvl=(Lvl + 1 - (MinusOrPlus*2))
	 elseif N < 8 then Rlvl=(Lvl + 2 -(MinusOrPlus*4))
	 else  Rlvl=(Lvl + 3 -(MinusOrPlus*6))
	 end
	 
	 if Rlvl < 5 then 5
	 else Rlvl
	 end
	 
      end
   end

   fun{GetMaxHealth Lvl} %Return the max health corresponding to a level
      local BaseHealth BaseLevel ActualHealth in
	 BaseHealth=20 %base health at level 5
	 BaseLevel=5 %level of base (minimum level possible in the game
	 ActualHealth = BaseHealth + 2 * (Lvl-BaseLevel) %Max health upgrades by 2 at each level
	 ActualHealth
      end
   end

   fun{CreatePokemOz Lvl} %Create a new pokemoz, Lvl is the max Lvl of the PokemOz of the player
      local Pokemoz in
	 Pokemoz={RandomPokemOz}
      end
   end
end
