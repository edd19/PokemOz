declare
[Combat] = {Module.link ['combat.ozf']}
[Pokemoz] = {Module.link ['list_pokemoz.ozf']}
[Agent] = {Module.link ['agent.ozf']}
[Map]= {Module.link ['map.ozf']}
[MapCreator] = {Module.link['MapCreator.ozf']}

{MapCreator.load}

{Map.initializeMyMap @(MapCreator.theMap) @(MapCreator.nbRows) @(MapCreator.nbCols)}

Temp1={Pokemoz.createPokemOz 5}
Temp2={Pokemoz.createPokemOz 5}
T1 = trainer(c:({OS.rand} mod 7)+1 r:({OS.rand} mod 7)+1 isDefeated:false p1:Temp1 p2:Temp2 p3:nil)
P
P = {Agent.newIA T1 1}
{Map.mapScreen P}



