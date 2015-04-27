%Selection of the starter for the game

functor

import
   Window at 'window.ozf'
   ListPokemOz at 'list_pokemoz.ozf'
export
   SelectionScreen
define
   Starter = ListPokemOz.listStarter
   %RadioButton for selecting the starter
   RadioButton=td(radiobutton(text:Starter.1.name
			      init:true
			      group:radio1)
		  radiobutton(text:Starter.2.name
			      group:radio1)
		  radiobutton(text:Starter.3.name
			      group:radio1)
		 )

   proc{SelectionScreen} %Display the screen for selecting a pokemoz starter
      {Window.createWindow}
      {Window.showWindow}
      {Window.addRadioButton ({Window.getWidth} div 2) 0 RadioButton}
   end
   
end

  
