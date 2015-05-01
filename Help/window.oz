%Class to create a window and modify it by adding shapes on it.
functor
import
   QTk at 'x-oz://system/wp/QTk.ozf'

export
   CreateWindow
   ShowWindow
   CleanWindow
   AddText
   AddButton
   AddRadioButton
   AddGrid
   AddMessage
   AddColoredMessage
   ChangeMessageText
   GetWidth
   GetHeight
define
   Canvas %Handler of the window
   Tag %tag for all elements created in the window
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
      Tag={Canvas newTag($)}
   end

   proc{ShowWindow} %Swho the window created
      {Window show}
   end

   proc{CleanWindow} %delete all elements in the window
      {Tag delete}
   end

   %Add methods
   proc{AddText X Y Msg} %Add text on the window
      %Add the text so that the top-center of it is situated at point (X,Y)
      %Msg is the text to be displayed
      {Canvas create(text X Y text:Msg anchor:n tags:Tag)}
   end

   proc{AddButton X Y Desc} %Add a button on the window
      %Add the button so that the center of it is situated at point (X,Y)
      %Desc is the button description
      {Canvas create(window X Y window:Desc tags:Tag)}
   end
      
   proc{AddRadioButton X Y Desc} %Add a radio button on the window
      %Add the radio button on the window with the top-center situated at point (X,Y)
      %Desc is the radio button description
      {Canvas create(window X Y window:Desc anchor:n tags:Tag)}
   end

   proc{AddGrid X Y Desc} %Add a grid on the window
      %Add the grid so that the center of it is placed at point (X,Y)
      %Desc is the grid description
      {Canvas create(window X Y window:Desc tags:Tag)}
   end

   fun{AddMessage X Y Msg}%Add a message on the window and return the handle of the newly created label
      %Add the message so that the center of it is placed at point (X,Y)
      %Msg is the text to be written on the screen.
      local Handle in
	 {Canvas create(window X Y window:message(init:Msg handle:Handle) tags:Tag)}
	 Handle %return the handle to change the text on screen if needed
      end
   end

   fun{AddColoredMessage X Y Msg Color}%Add a message on the window and return the handle of the newly created label
      %Add the message so that the center of it is placed at point (X,Y)
      %Msg is the text to be written on the screen.
      local Handle in
	 {Canvas create(window X Y window:message(init:Msg bg:Color handle:Handle) tags:Tag)}
	 Handle %return the handle to change the text on screen if needed
      end
   end

   proc{ChangeMessageText Handle NewMsg}%Change the label text by the new one (NewMsg)
      {Handle set(NewMsg)}
   end
      
   %Get methods
   fun{GetWidth}
      Width
   end

   fun{GetHeight}
      Height
   end
   
end

   
   
      
