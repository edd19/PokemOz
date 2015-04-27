declare [QTk]={Module.link ["x-oz://system/wp/QTk.ozf"]}

local
   ListPokemOz=listpokemoz(bulbasoz:pokemoz(name:"Bulbasoz" type:"grass") %List of all pokemoz
			   oztirtle:pokemoz(name:"Oztirtle" type:"water")
			   charmandoz:pokemoz(name:"Charmandoz" type:"fire"))
   Canvas
   W=600 %width of the screen
   H=600 %height of the screen
   Desc = td(canvas(bg:white
		    width:W
		    height:H
		    handle:Canvas))
   Window={QTk.build Desc}

   proc{SelectStarter X Y Canvas}
      local
	 RadioButton=td(radiobutton(text:ListPokemOz.bulbasoz.name  %RadioButton representing each starter pokemoz
				    init:true
				   group:radio1)
			radiobutton(text:ListPokemOz.oztirtle.name
				   group:radio1)
			radiobutton(text:ListPokemOz.charmandoz.name
				   group:radio1))
      in
	 {Canvas create(window X 0 window:RadioButton anchor:n)}
      end
      
   end
in
   {Window show}
   {SelectStarter (W div 2) 0 Canvas}
end

