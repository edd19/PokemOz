%List of pokemoz
functor
   
export
   ListPokemOz
   ListStarter

define
   ListPokemOz=listpokemoz(bulbasoz:pokemoz(name:"Bulbasoz" type:"grass")
			   oztirtle:pokemoz(name:"Oztirtle" type:"water")
			   charmandoz:pokemoz(name:"Charmandoz" type:"fire")
			  )
   ListStarter=liststarter(1:ListPokemOz.bulbasoz
			   2:ListPokemOz.oztirtle
			   3:ListPokemOz.charmandoz)
end
