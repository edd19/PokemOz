%To switch pokemoz in combat or in the map
functor
import
   ListPokemoz at 'list_pokemoz.ozf'
   Browser
   Window at 'window.ozf'
export
   InitializeSwitchWindow
   DisplaySwitchWindow
   
define
   Window %window on which we display the graphical things
   Player %port for the player trainer
   Finish %1 if the player switched pokemoz and 0 otherwise
   Tag
   
   proc{InitializeSwitchWindow W P}%intialize the variables for the functor
      {Window.createWindow}
      {Window.showWindow}
      Player = P
      Tag = {Window.createNewTag}
   end

   proc{CleanWindow} %clean the window so that it becomes blank
      {Window.cleanWindowT Tag}
   end

   proc{DisplayActualPokemoz Pokemoz}%display the pokemoz that is in combat
      local Name Color Temp in
	 Name = Pokemoz.n
	 Color = {ListPokemoz.colorByType Pokemoz.t}
	 Temp = {Window.addColoredMessageT ({Window.getWidth} div 6)*3 ({Window.getHeight} div 6)*1 Name Color Tag}
      end
   end

   fun{CheckIfKO Id}%check if the pokemoz is Ko, Id indicates which pokemoz
      local X in
	 {Send Player get(X)}
	 if Id == 1 then if X.p1.hp.r == 0 then true
			 else false end
	 elseif Id == 2 then if X.p2.hp.r == 0 then true
			 else false end
	 elseif Id == 3 then if X.p3.hp.r == 0 then true
			     else false end

	 end
      end
   end

   proc{ActionButtonSwitch Id} %action when clicking on the button
      local IsKo in
	 IsKo = {CheckIfKO Id}
	 if IsKo == false then %cannot switch with a Ko'ed pokemoz
	    {Send Player switch(Id)}
	    {CleanWindow}
	    Finish=1
	 else skip end
      end
   end
   
   proc {DisplayButtonPokemoz Pokemoz Id}%display the button for choosing a pokemoz, id is there to indicate which pokemoz
      if Pokemoz \= nil then local Desc Color Text in
				Color = {ListPokemoz.colorByType Pokemoz.t}
				Text=Pokemoz.n
				Desc=button(text:Text bg:Color action:proc{$} {Browser.browse Text} {ActionButtonSwitch Id} end)
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
      local X IsKo in
	 {Send Player get(X)}
	 
	 {DisplayActualPokemoz X.p1} %display the pokemoz that is currently fighting
	 {DisplayOtherPokemoz X.p2 X.p3}%display the other pokemoz that can be switched with

	 IsKo = {CheckIfKO 1} %has to switch if the first pokemoz is KO
	 if IsKo == false then {DisplayReturnButton} end %display the return button if the trainer don't want to switch pokemoz finally end
	 Finish %return 1 if the trainer switched pokemoz and 0 otherwise
      end
   end
   
end