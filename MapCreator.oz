functor
import
   Application
   Open
   Pickle
   QTk at 'x-oz://system/wp/QTk.ozf'
   System
   Browser
export
   CreateMap
   Load % a retirer
   NbRows
   NbCols
   TheMap
   
define
   V = 'v1.0'
   Win
   Saved = 'Map.txt'
   Map % handle to the map
   NbRows = {NewCell 7}
   NbCols = {NewCell 7}
   HNRows % Handler for the nb of rows
   HNCols % Handler for the nb of cols

   TheMap = {NewCell nil}
   
   proc {UpdateMap I J Val}
      TheMap := {AdjoinAt @TheMap I {AdjoinAt @TheMap.I J Val}}
   end
   
   proc {Save}
      {Pickle.save @TheMap Saved}
   end
   
   proc {Load}
      try
	 _ = {New Open.file init(name:Saved flags:[read])}
	 TheMap := {Pickle.load Saved}
      in
	 {SetCell NbRows {Width @TheMap} HNRows}
	 {SetCell NbCols {Width @TheMap.1} HNCols}
	 {Map set(  {CreateFrom @TheMap}  )  }
	 %
	% {Browser.browse @TheMap}
      catch _ then
	 {System.show 'No file found'}
      end
   end
   Road = c(255 255 255)
   Grass = c(146 208 80)
   Roads = button(glue:nswe text:'' bg:Road)
   Grasses = button(glue:nswe text:'' bg:Grass)

   fun{NewRoad Hand I J}
      {Adjoin Roads
       button(
	  action:
	     proc{$}
		{UpdateMap I J 1}
		{Hand set({NewGrass Hand I J})}
	     end
	  )
      }
   end
   
   fun{NewGrass Hand I J}
      {Adjoin Grasses
       button(
	  action:
	     proc {$}
		{UpdateMap I J 0}
		{Hand set({NewRoad Hand I J})}
	     end)
      }
   end

   fun{SetButton Text Proc}
      button(text:Text
	     height:2
	     width:5
	     action: Proc
	    )
   end

%%% Increase the number of rows or cols
%%% Update the value of the nb or rows or cols
%%% Update the map with the new number of rows and cols
   fun {Inc ThisCell Handler Plus}
      proc{$}
	 ThisCell:=@ThisCell+Plus
	 {Map set(  {CreateMap}  )}
	 {Handler set(text:@ThisCell)}
      end      
   end
   
   proc{SetCell ThisCell Value Handler}
      ThisCell:=Value
      {Handler set(text:Value)}
   end

   fun{Edit Value Text Handler}
      lr(
	 label(text:Text)
	 td(
	    {SetButton '+' {Inc Value Handler 1}}
	    label(bg:white handle:Handler text:@Value)
	    {SetButton '-' {Inc Value Handler ~1}}
	    )
	 )
   end

%%% Create a road
   fun{SetRoad I J Val}
      Hand
      TheRoad
   in
      if Val == 0 then
	 TheRoad = placeholder(
		      glue:nswe
		      handle:Hand
		      {NewRoad Hand I J}
		      )
      else
	 TheRoad = placeholder(
		      glue:nswe
		      handle:Hand
		      {NewGrass Hand I J}
		      )
      end
      TheRoad
   end

   fun {CreateFrom Map}
      NRows = @NbRows
      NCols = @NbCols
      Rows = {Adjoin td(glue:nswe) {MakeTuple td NRows}}
   in
      for I in 1..NRows
      do
	 Rows.I = {Adjoin lr(glue:nswe) {MakeTuple lr NCols}}
	 for J in 1..NCols
	 do
	    Rows.I.J = {SetRoad I J Map.I.J}
	 end
      end
      Rows
   end

   proc {EmptyMap}
      TheMap := {MakeTuple map @NbRows}
      for I in 1..@NbRows
      do
	 @TheMap.I = {MakeTuple r @NbCols}
	 for J in 1..@NbCols
	 do
	    @TheMap.I.J = 0
	 end
      end
   end

   %% Create the record for the map
   fun {CreateMap}
      NRows = @NbRows
      NCols = @NbCols
      Rows = {Adjoin td(glue:nswe) {MakeTuple td NRows}}
   in
      for I in 1..NRows
      do
	 Rows.I = {Adjoin lr(glue:nswe) {MakeTuple lr NCols}}
	 for J in 1..NCols
	 do
	    Rows.I.J = {SetRoad I J 0}
	 end
      end
      {EmptyMap}
      Rows
   end
in
   %% Display the windows
   Win = {QTk.build td(title:'MapCreator '#V
		       placeholder(glue:nswe handle:Map)
		       lr(
			  td(
			     {SetButton 'Save' Save}
			     {SetButton 'Load' Load}
			     )
			  {Edit NbRows 'Nb of rows: ' HNRows}
			  {Edit NbCols 'Nb of cols: ' HNCols}
			  )
		      )
	 }
 %  {Win show}  %ICI 
 %  {Delay 100}


   %% Get the Arguments
   try
      Args
      NRows
      NCols
   in
      Args = {Application.getArgs record()}
      if {Length Args.1} == 2 then
	 optRec([NRows NCols]) = Args
	 {SetCell NbRows {String.toInt NRows} HNRows}
	 {SetCell NbCols {String.toInt NCols} HNCols}
	 {Map set(
		 {CreateMap}
		 )  }
      else
	 {Load}
      end
   catch _ then 
      {System.show 'error with arguments'}
   end

end
