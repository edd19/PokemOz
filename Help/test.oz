declare
[Combat] = {Module.link ['combat.ozf']}
[Pokemoz] = {Module.link ['list_pokemoz.ozf']}
[Agent] = {Module.link ['agent.ozf']}
[Map]= {Module.link ['map.ozf']}

Temp1={Pokemoz.createPokemOz 5}
Temp2={Pokemoz.createPokemOz 5}
T1 = trainer(c:0 r:0 isDefeated:false p1:Temp1 p2:nil p3:nil)
T2 = trainer(c:0 r:0 isDefeated:false p1:Temp2 p2:nil p3:nil)
P O
P = {Agent.newIA T1 1} %"port contenant le premier joueur"

O = {Agent.newIA T2 2} %"port contenant le second joueur"
XM
PM={Map.newMap}
{Send P get(XM)}%Recuperation du premier record Trainer
{Browse XM} %Affichage du premier record Trainer
{Send PM T1#3} %Deplace le premier trainer vers le bas
{Map.mapScreen}


X

Y

Z

thread {Browse T}
   {Wait T}
   {Send O get(X)}
   {Send P get(Y)}
   {Browse X}
   {Browse Y}
end


