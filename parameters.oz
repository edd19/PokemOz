functor

import
   Window at 'window.ozf'
export
   Probability
   Speed
   Autofight
   ParametersScreen
   
define
   Probability
   ProbHandle
   ProbP
   SpeedP
   Speed
   SpeedHandle
   AutoP
   Autofight
   AutoHandle

   proc{ShowSpeed}%choose speed for the delay of the movements of the player
      local Desc in
	 Desc = numberentry(min:0 max:10 handle:SpeedHandle action:proc{$} {Send SpeedP set({SpeedHandle get($)})} end)
	 {Window.addText (Window.width div 6) (Window.height div 6)*2 "Speed"}
	 {Window.addNumberEntry (Window.width div 2) (Window.height div 6)*2 Desc}
      end
   end

   proc{ShowAuto}%choose if the game is in automode or manual
      local Desc in
	 Desc = checkbutton(text:"Autofight" handle:AutoHandle action:proc{$} {Send AutoP set({AutoHandle get($)})} end)
	 {Window.addText (Window.width div 6) (Window.height div 6)*3 "Auto Fight"}
	 {Window.addCheckButton (Window.width div 2) (Window.height div 6)*3 Desc}
      end
   end

   proc{ShowProbability} %choose the probability of encounter of wild pokemoz
      local Desc in
	 {Window.addText (Window.width div 6) (Window.height div 6)*4 "Probability"}
	 Desc = numberentry(min:0 max:100 handle:ProbHandle action:proc{$} {Send ProbP set({ProbHandle get($)})} end)
	 {Window.addNumberEntry (Window.width div 2) (Window.height div 6)*4 Desc}
      end
   end

   proc{ShowOkButton} %Ok button when finished with setting the parameters
      local Desc in
	 Desc = button(text:"OK" action:proc{$}{Send SpeedP get(Speed)} {Send AutoP get(Autofight)} {Send ProbP get(Probability)} {Window.cleanWindow}{Window.closeWindow} end)
	 {Window.addButton (Window.width div 2) (Window.height div 6)*5 Desc}
      end
   end
   
   fun{NewAgent}
      proc{Loop S State}
	 case S
	 of H|T then
	    case H
	    of get(X) then X=State {Loop T State}
	    [] set(X) then {Loop T X}
	    else {Loop T State}
	    end
	 end
      end
      S P
   in
      P = {NewPort S}
      thread {Loop S 0} end
      P
   end
   
   proc{ParametersScreen}
      {Window.createWindow}
      {Window.showWindow}
      {Window.addText (Window.width div 2) 0 "Parameters"}
      ProbP = {NewAgent}
      SpeedP = {NewAgent}
      AutoP = {NewAgent}
      {Send AutoP set(false)}
      {ShowSpeed}
      {ShowAuto}
      {ShowProbability}
      {ShowOkButton}
   end
   
end


% declare
% [Prototyper] = {Module.link ['x-oz://system/wp/Prototyper.ozf']}
% {Prototyper.run}
   