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
   Speed
   Autofight

   proc{ShowSpeed}%choose speed for the delay of the movements of the player
      {Window.addText (Window.width div 6) (Window.height div 6)*2 "Speed"}
      {Window.addNumberEntry (Window.width div 2) (Window.height div 6)*2 0 10 Speed}
   end

   proc{ShowAuto}%choose if the game is in automode or manual
      {Window.addText (Window.width div 6) (Window.height div 6)*3 "Auto Fight"}
      {Window.addCheckButton (Window.width div 2) (Window.height div 6)*3 "Autofight" Autofight}
   end

   proc{ShowProbability} %choose the probability of encounter of wild pokemoz
      {Window.addText (Window.width div 6) (Window.height div 6)*4 "Probability"}
      {Window.addNumberEntry (Window.width div 2) (Window.height div 6)*4 0 100 Probability}
   end

   proc{ShowOkButton} %Ok button when finished with setting the parameters
      local Desc in
	 Desc = button(text:"OK" action:toplevel#close)
	 {Window.addButton (Window.width div 2) (Window.height div 6)*5 Desc}
      end
   end
   
   proc{ParametersScreen}
      {Window.createWindow}
      {Window.showWindow}
      {Window.addText (Window.width div 2) 0 "Parameters"}
      {ShowSpeed}
      {ShowAuto}
      {ShowProbability}
      {ShowOkButton}
   end
   
end


% declare
% [Prototyper] = {Module.link ['x-oz://system/wp/Prototyper.ozf']}
% {Prototyper.run}
   