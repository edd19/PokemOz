declare
[Combat] = {Module.link ['combat.ozf']}
[Pokemoz] = {Module.link ['list_pokemoz.ozf']}
[Agent] = {Module.link ['agent.ozf']}
[Map]= {Module.link ['map.ozf']}
[MapCreator] = {Module.link['MapCreator.ozf']}
[SelectStarter] = {Module.link ['select_starter.ozf']}

Select = {SelectStarter.selectionScreen} %choose a pokemoz for starter
Player = SelectStarter.player %create a player port depending of the choice for starter pokemoz

{MapCreator.load} %load the map from the file map.txt

{Map.initializeMyMap @(MapCreator.theMap) @(MapCreator.nbRows) @(MapCreator.nbCols)}

{Map.mapScreen Player}%show the map



