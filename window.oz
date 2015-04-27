%Class to create a window and modify it by adding shapes on it.
functor
import
   QTk at 'x-oz://system/wp/QTk.ozf'

export
   CreateWindow
   ShowWindow
   AddRadioButton
   GetWidth
   GetHeight
define
   Canvas %Handler of the window
   Window
   Width = 600 %Width of the window
   Height = 600 %Height of the window
   
   proc{CreateWindow} %Creates a window (white by default)
      Desc = td(width:Width
		height:Height
		bg:white
		handle:Canvas)
   in
      Window = {QTk.build Desc}
   end

   proc{ShowWindow} %Swho the window created
      {Window show}
   end

   %Add methods
   proc{AddRadioButton X Y Desc} %Add a radio button on the window
      %Add the radio button on the window with the top left edge of the
      %radio button situated at point (X,Y)
      %Desc is the radio button description
      {Canvas create(window X Y window:Desc anchor:n)}
   end
      
   %Get methods
   fun{GetWidth}
      Width
   end

   fun{GetHeight}
      Height
   end
   
end

   
   
      