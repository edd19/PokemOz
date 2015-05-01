%List of pokemoz and additional methods for pokemoz
functor

import
   OS
   
export
   ListPokemOz
   ListStarter
   GetMaxHealth
   CreatePokemOz
   AttackSuccess
   AttackDamage
   ColorByType

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
	 
	 if Rlvl < 5 then 5 %verify that the lvl is not inferior than 5
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

   fun{ExpByLvl Lvl}%return the experience corresponding to a lvl
      if Lvl < 6 then 0
      elseif Lvl == 6 then 5
      elseif Lvl == 7 then 12
      elseif Lvl == 8 then 20
      elseif Lvl == 9 then 30
      elseif Lvl == 10 then 50
      else 50
      end
   end
   
   fun{CreatePokemOz Lvl} %Create a new pokemoz, Lvl is the max Lvl of the PokemOz of the player
      local Pokemoz LvlP Health in
	 Pokemoz={RandomPokemOz}
	 LvlP = {RandomLvl Lvl}
	 Health = {GetMaxHealth LvlP}
	 pokemoz(t:Pokemoz.type n:Pokemoz.name hp:health(r:Health m:Health) lx:LvlP xp:{ExpByLvl LvlP})
      end
   end

   fun{AttackSuccess La Ld}%return true if an attack succeed and false otherwise, La is the level of the attacker and Ld of the defender
      local Probability N in
	 Probability = (((6+La-Ld)*9)) mod 100 %probability for an attack to succed based on the difference of level of the two pokemoz
	 N = {OS.rand} mod 100 %N is a number between 0 and 99
	 if N < Probability then true
	 else false
	 end
      end
   end

   fun{AttackDamage Ta Td} %return the damage caused by a pokemoz of type Ta to a pokemoz of type Td
      if Ta == Td then 2 %same type
      elseif Ta=="grass" then if Td=="fire" then 1
			      elseif Td=="water" then 3
			      else 0 end
      elseif Ta=="fire" then if Td=="grass" then 3
			     elseif Td=="water" then 1
			     else 0 end
      elseif Ta=="water" then if Td=="grass" then 1
			      elseif Td=="fire" then 3
			      else 0 end
      else 0 end
   end

   fun{ColorByType Type}%return the color corresponding to a type of Pokemoz
      if Type=="grass" then green
      elseif Type=="fire" then red
      elseif Type=="water" then blue
      else white
      end
   end
end
