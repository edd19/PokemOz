%Class to create a window and modify it by adding shapes on it.
functor
import
   QTk at 'x-oz://system/wp/QTk.ozf'

export
   CreateWindow
   ShowWindow
   CleanWindow
   CloseWindow
   AddText
   AddButton
   AddRadioButton
   AddGrid
   AddMessage
   AddNumberEntry
   AddCheckButton
   AddColoredMessage
   ChangeMessageText
   ChangeMessageColor
   CreateNewTag
   AddColoredMessageT
   AddButtonT
   AddFillLabelT
   CleanWindowT
   GetWidth
   GetHeight
	Width	
	Height
define
   Canvas %Handler of the window
   Tag %tag for all elements created in the window
   Window
   Width = 600 %Width of the window
   Height = 600 %Height of the window
   Font = {QTk.newFont font(size:20)}
   
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

   proc{CloseWindow}
      {Window close}
   end

   proc{CleanWindow} %delete all elements in the window
      {Tag delete}
   end

   %Add methods
   proc{AddText X Y Msg} %Add text on the window
      %Add the text so that the top-center of it is situated at point (X,Y)
      %Msg is the text to be displayed
      {Canvas create(text X Y text:Msg anchor:n tags:Tag font:Font)}
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
	 {Canvas create(window X Y window:message(init:Msg handle:Handle font:Font) tags:Tag)}
	 Handle %return the handle to change the text on screen if needed
      end
   end

   proc{AddCheckButton X Y Text R}
      {Canvas create(window X Y
		     window:checkbutton(text:Text init:false  return:R))}
   end
   
   fun{AddColoredMessage X Y Msg Color}%Add a message on the window and return the handle of the newly created label
      %Add the message so that the center of it is placed at point (X,Y)
      %Msg is the text to be written on the screen.
      local Handle in
	 {Canvas create(window X Y window:message(init:Msg bg:Color handle:Handle font:Font) tags:Tag)}
	 Handle %return the handle to change the text on screen if needed
      end
   end

   proc{AddNumberEntry X Y Min Max R}
      {Canvas create(window X Y
		     window:numberentry(min:Min max:Max init:0 return:R))}
   end

   proc{ChangeMessageText Handle NewMsg}%Change the label text by the new one (NewMsg)
      {Handle set(NewMsg)}
   end

   proc{ChangeMessageColor Handle NewColor}%Cahnge the color label by a new one (Color)
      {Handle set(bg:NewColor)}
   end

   fun{CreateNewTag} %create a new tag to add items independently of other item
      local TagNew in
	 TagNew = {Canvas newTag($)}
	 TagNew
      end
   end

   fun{AddColoredMessageT X Y Msg Color NewTag}%Add a message on the window and return the handle of the newly created label
      %Add the message so that the center of it is placed at point (X,Y)
      %Msg is the text to be written on the screen.
      local Handle in
	 {Canvas create(window X Y window:message(init:Msg bg:Color handle:Handle font:Font) tags:NewTag)}
	 Handle %return the handle to change the text on screen if needed
      end
   end

    proc{AddButtonT X Y Desc NewTag} %Add a button on the window
      %Add the button so that the center of it is situated at point (X,Y)
      %Desc is the button description
      {Canvas create(window X Y window:Desc tags:NewTag)}
    end

    proc{AddFillLabelT Msg NewTag}%add a rectangle on the window
       {Canvas create(window 0 0 window:label(init:Msg bg:white)
		      height:Height width:Width anchor:nw tags:NewTag) }
    end

     proc{CleanWindowT NewTag} %delete all elements in the window
      {NewTag delete}
   end
   
   %Get methods
   fun{GetWidth}
      Width
   end

   fun{GetHeight}
      Height
   end
   
end

   
   
      
