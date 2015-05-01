declare
[Combat] = {Module.link ['combat.ozf']}
[Pokemoz] = {Module.link ['list_pokemoz.ozf']}
[Agent] = {Module.link ['agent.ozf']}
[Window] = {Module.link ['window.ozf']}
{Window.createWindow}
{Window.showWindow}
Temp1={Pokemoz.createPokemOz 5}
Temp2={Pokemoz.createPokemOz 5}
T1 = trainer(c:0 r:0 isDefeated:false p1:Temp1 p2:Temp2 p3:nil)
T2 = trainer(c:0 r:0 isDefeated:false p1:Temp2 p2:Temp1 p3:nil)
P O
P = {Agent.newIA T1 1} 
O = {Agent.newIA T2 2}
{Combat.initializeCombatWindow Window}
T={Combat.combatVSTrainer P O}


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


