%Class to create a window and modify it by adding shapes on it.
functor
import
   QTk at 'x-oz://system/wp/QTk.ozf'

export
   CreateWindow
   ShowWindow
   AddText
   AddButton
   AddRadioButton
   AddGrid
   GetWidth
   GetHeight
define
   Canvas %Handler of the window
   Window
   Width = 600 %Width of the window
   Height = 600 %Height of the window
   
   proc{CreateWindow} %Creates a window (white by default)
      Desc = td(canvas(width:Width
		       height:Height
		       bg:white
		       handle:Canvas))
   in
      Window = {QTk.build Desc}
   end

   proc{ShowWindow} %Swho the window created
      {Window show}
   end

   %Add methods
   proc{AddText X Y Msg} %Add text on the window
      %Add the text so that the top-center of it is situated at point (X,Y)
      %Msg is the text to be displayed
      {Canvas create(text X Y text:Msg anchor:n)}
   end

   proc{AddButton X Y Desc} %Add a button on the window
      %Add the button so that the center of it is situated at point (X,Y)
      %Desc is the button description
      {Canvas create(window X Y window:Desc)}
   end
      
   proc{AddRadioButton X Y Desc} %Add a radio button on the window
      %Add the radio button on the window with the top-center situated at point (X,Y)
      %Desc is the radio button description
      {Canvas create(window X Y window:Desc anchor:n)}
   end

   proc{AddGrid X Y Desc} %Add a grid on the window
      %Add the grid so that the center of it is placed at point (X,Y)
      %Desc is the grid description
      {Canvas create(window X Y window:Desc)}
   end
      
   %Get methods
   fun{GetWidth}
      Width
   end

   fun{GetHeight}
      Height
   end
   
end

   
   
      
