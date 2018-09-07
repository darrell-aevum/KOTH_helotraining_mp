
//Time of day
_time = paramsArray select 0;
if (_time != 1) then
{
	skipTime (_time - daytime + 24 ) % 24;
}
else
{
	skiptime (floor random 24);
};

//LZ size
lzSize = paramsArray select 1;
publicVariable "lzSize";
 
//Smoke setting
bSmoke = if ((paramsArray select 2) == 1) then {true} else {false};
publicVariable "bSmoke";

//Hot LZ chance
_hotLZParam = paramsArray select 3;
hotLZChance = if (_hotLZParam > 0) then {_hotLZParam / 100} else {0.0};
publicVariable "hotLZChance";

//Anti air chance
_AAParam = paramsArray select 4;
AAChance = if (_AAParam > 0) then {_AAParam / 100} else {0.0};
publicVariable "AAChance";

dropoffList = [];
{ 
	if (_x find "dropoff_" == 0) then 
	{		
		[dropoffList, (missionNamespace getVariable (_x))] call BIS_fnc_arrayPush;		
	};
}
forEach allVariables missionNamespace;

pickupList = [];
{
	if (_x find "pickup_" == 0) then 
	{
		[pickupList, (missionNamespace getVariable (_x))] call BIS_fnc_arrayPush;		
	};
}
forEach allVariables missionNamespace;
  
LZMinDistace = paramsArray select 5;
publicVariable "LZMinDistace";

squadsLinger = paramsArray select 6;
publicVariable "squadsLinger";

autoSpawnTasks = if ((paramsArray select 7) == 1) then {true} else {false};
publicVariable "autoSpawnTasks";

//Paradrop size
paraDropSize = paramsArray select 8;
publicVariable "paraDropSize";

//Enemy Size
enemyCount = paramsArray select 9;
publicVariable "enemyCount";