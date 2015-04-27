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
   ButtonOk=button(text:'Ok') %Button ok to pushed on when having decided the starter
   StringChoose='Choose a PokemOz' 

   proc{SelectionScreen} %Display the screen for selecting a pokemoz starter
      {Window.createWindow}
      {Window.showWindow}
      {Window.addText ({Window.getWidth} div 2) 0 StringChoose} 
      {Window.addRadioButton ({Window.getWidth} div 2) ({Window.getHeight} div 3) RadioButton}
      {Window.addButton ({Window.getWidth} div 2) ({Window.getHeight} div 2) ButtonOk} 
   end
   
end

  
