%Selection of the starter for the game

functor

import
   Window at 'window.ozf'
   ListPokemOz at 'list_pokemoz.ozf'
   Agent at 'agent.ozf'
export
   SelectionScreen
   Player
   Agent
define
   Player={Agent.newPlayer} %Creates a new player for the game, Player is a Port
   Finish
   Starter = ListPokemOz.listStarter
   %RadioButton for selecting the starter
   RadioButton=td(radiobutton(text:Starter.1.name
			      init:true
			      group:radio1
			      action:proc{$} {Send Player starter(Starter.1)} end)
		  radiobutton(text:Starter.2.name
			      group:radio1
			      action:proc{$} {Send Player starter(Starter.2)} end)
		  radiobutton(text:Starter.3.name
			      group:radio1
			      action:proc{$} {Send Player starter(Starter.3)} end)
		  onCreation:proc{$} {Send Player starter(Starter.1)} end
		 )
   ButtonOk=button(text:'Ok'
		  action:proc{$} local X in {Send Player get(X)}  Finish=unit end end) %Button ok to pushed on when having decided the starter
   StringChoose='Choose a PokemOz'
   
   fun{SelectionScreen} %Display the screen for selecting a pokemoz starter
      {Window.createWindow}
      {Window.showWindow}
      {Window.addText ({Window.getWidth} div 2) 0 StringChoose} 
      {Window.addRadioButton ({Window.getWidth} div 2) ({Window.getHeight} div 3) RadioButton}
      {Window.addButton ({Window.getWidth} div 2) ({Window.getHeight} div 2) ButtonOk}
      if Finish == unit then
	 {Window.cleanWindow}
	 {Window.closeWindow}
      end
      Finish
   end
   
end

  
