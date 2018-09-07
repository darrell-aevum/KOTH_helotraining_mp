//diag_log format["ejectSquad called, _this: %1", _this];
private _lz = _this select 0;
private _vehicle = _this select 1;
private _squad = _this select 2;
private _fromTaskId = _this select 3;
private _side = side _squad;
private _squadCmdr = (units _squad) select 0;  

deleteWaypoint [_squad,1];
  
waitUntil { ([_vehicle] call isParaHeight) || ([_vehicle] call isLanded) };

if([_vehicle] call isLanded) then {
    [_vehicle, _squad] call  paradropSquad;    
};

if([_vehicle] call isParaHeight) then {
  {unassignVehicle _x; _x action["Eject", vehicle _x]} forEach units _squad; 
};
   
{_x enableAI "TARGET"; _x enableAI "AUTOTARGET";} foreach units _squad;

private _wp = _squad addwaypoint [_lz,5,1];
_wp setwaypointType "MOVE";

[_squadCmdr, format["Please standby as we're getting off."]] remoteExec ['sideChat', _side];

scopeName "main";
while {true} do
{
    scopeName "ejectloop";
//    diag_log format["ejectSquad: ticking %1", _this];
    if (({(_x in _vehicle) && (alive _x)} count units _squad) == 0) then
    {
        // No squad units left alive inside
        [_fromTaskId, "SUCCEEDED" ,true] spawn BIS_fnc_taskSetState;
        breakOut "ejectloop";
    };
    sleep 2;
};

[_squadCmdr, format["Everyone is out, you're clear to lift off"]] remoteExec ['sideChat', _side];

//diag_log format["ejectSquad done, _this: %1", _this];
