%To switch pokemoz in combat or in the map
functor
import
   ListPokemoz at 'list_pokemoz.ozf'
export
   InitializeSwitchWindow
   DisplaySwitchWindow
   
define
   Window %window on which we display the graphical things
   Player %port for the player trainer
   Finish %1 if the player switched pokemoz and 0 otherwise
   Tag
   
   proc{InitializeSwitchWindow W P}%intialize the variables for the functor
      Window = W      
      Player = P
      Tag = {Window.createNewTag}
   end

   proc{CleanWindow} %clean the window so that the it becomes blank
      {Window.cleanWindowT Tag}
   end

   proc{DisplayActualPokemoz Pokemoz}%display the pokemoz that is in combat
      local Name Color Temp in
	 Name = Pokemoz.n
	 Color = {ListPokemoz.colorByType Pokemoz.t}
	 Temp = {Window.addColoredMessageT ({Window.getWidth} div 6)*3 ({Window.getHeight} div 6)*1 Name Color Tag}
      end
   end

   proc{ActionButtonSwitch Id} %action when clicking on the button
      {Send Player switch(Id)}
      {CleanWindow}
      Finish=1
   end
   
   proc {DisplayButtonPokemoz Pokemoz Id}%display the button for choosing a pokemoz, id is there to indicate the which pokemoz
      if Pokemoz \= nil then local Desc Color Text in
				Color = {ListPokemoz.colorByType Pokemoz.t}
				Text=Pokemoz.n
				Desc=button(text:Text bg:Color action:proc{$} {ActionButtonSwitch Id} end)
				{Window.addButtonT ({Window.getWidth} div 6)*3 ({Window.getHeight} div 6)*Id Desc Tag}
			      end
      end
   end
   
   proc{DisplayOtherPokemoz Pokemoz2 Pokemoz3}%display the other pokemoz
      {DisplayButtonPokemoz Pokemoz2 2}
      {DisplayButtonPokemoz Pokemoz3 3}
   end

   proc{ActionButtonReturn} %action when clicking on the return button
      {CleanWindow}
      Finish = 0
   end
   
   proc{DisplayReturnButton} %display a button if the trainer don't want to switch
      local Text Desc in
	 Text = "Return"
	 Desc = button(text:Text action:proc{$}  {ActionButtonReturn} end)
	 {Window.addButtonT ({Window.getWidth} div 6)*3 ({Window.getHeight} div 6)*5 Desc Tag}
      end
   end
   
   fun {DisplaySwitchWindow}%display the switch window with all the elements
      local X in
	 {Send Player get(X)}
	 {Window.addFillLabelT "Choose a pokemoz" Tag}
	 {DisplayActualPokemoz X.p1} %display the pokemoz that is currently fighting
	 {DisplayOtherPokemoz X.p2 X.p3}%display the other pokemoz that can be switched with
	 {DisplayReturnButton} %display the return button if the trainer don't want to switch pokemoz finally
	 
	 Finish %return 1 if the trainer switched pokemoz and 0 otherwise
      end
   end
   
end