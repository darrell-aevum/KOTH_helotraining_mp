//diag_log format["paradropSquad called, _this: %1", _this];

private _vehicle = _this select 0;
private _squad = _this select 1;
        
private ["_paras", "_chuteHeight","_dir","_loadout"];
_paras = units _squad;

_chuteheight = 60;
_vehicle allowDamage false; 
_dir = direction _vehicle;
//_loadout = [];

paraLandSafe =
			{
				private ["_unit"];
				_unit = _this select 0;
				_chuteheight = _this select 1;
				//_loadout = _this select 2;
				(vehicle _unit) allowDamage false;
				if (isPlayer _unit) then {[_unit,_chuteheight] spawn OpenPlayerchute};
				waitUntil { isTouchingGround _unit || (position _unit select 2) < 1 };
				_unit action ["eject", vehicle _unit];
				sleep (random 4);
				_inv = name _unit;
				[_unit, [missionNamespace, format["%1%2", "Inventory",_inv]]] call BIS_fnc_loadInventory;// Reload Loadout.
				//_unit setUnitLoadout _loadout;// Reload Loadout.
				_unit allowdamage true;// Now you can take damage.
			};

OpenPlayerChute =
			{
				private ["_paraPlayer"];
				_paraPlayer = _this select 0;
				_chuteheight = _this select 1;
				waitUntil {(position _paraPlayer select 2) <= _chuteheight};
				_paraPlayer action ["openParachute", _paraPlayer];
			};

	{
		_inv = name _x;// Get Unique name for Unit's loadout.
		[_x, [missionNamespace, format["%1%2", "Inventory",_inv]]] call BIS_fnc_saveInventory;// Save Loadout
		//_loadout = getUnitLoadout _x;// Save Loadout
		removeBackpack _x;
		_x disableCollisionWith _vehicle;// Sometimes units take damage when being ejected.
		_x allowdamage false;// Trying to prevent damage.
		_x addBackPack "B_parachute";
		unassignvehicle _x;
		moveout _x;
		_x setDir (_dir + 90);// Exit the chopper at right angles.
		sleep 0.5;
	} forEach _paras;

	_vehicle allowDamage true;

	{
		[_x,_chuteheight] spawn paraLandSafe;
	} forEach _paras;