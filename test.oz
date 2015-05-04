declare
[Combat] = {Module.link ['combat.ozf']}
[Pokemoz] = {Module.link ['list_pokemoz.ozf']}
[Agent] = {Module.link ['agent.ozf']}
[Map]= {Module.link ['map.ozf']}

Temp1={Pokemoz.createPokemOz 5}
Temp2={Pokemoz.createPokemOz 5}
T1 = trainer(c:({OS.rand} mod 7)+1 r:({OS.rand} mod 7)+1 isDefeated:false p1:Temp1 p2:Temp2 p3:nil)
T2 = trainer(c:({OS.rand} mod 7)+1 r:({OS.rand} mod 7)+1 isDefeated:false p1:Temp2 p2:nil p3:nil)
P O
P = {Agent.newIA T1 1} %"port contenant le premier joueur"

O = {Agent.newIA T2 2} %"port contenant le second joueur"
XM



{Send P get(XM)}%Recuperation du premier record Trainer
%{Browse XM} %Affichage du premier record Trainer
%{Send PM T1#3} %Deplace le premier trainer vers le bas
%{Send PM listMoves(player:0 1:1 2:0 3:0 4:0 5:0 6:0 7:0 8:0 9:0 10:0)}
%Deplace le premier rectangle vers la droite
%{Send PM listMoves(player:0 1:3 2:0 3:0 4:0 5:0 6:0 7:0 8:0 9:0 10:0)}
%Deplace le premier rectangle vers le bas
{Map.mapScreen P}




X

Y

Z



