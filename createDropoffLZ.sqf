//diag_log format["createDropoffLZ called, _this: %1", _this];
private _lzLocation = _this select 0;
private _bindToVehicle = _this select 1;
private _bindToSquad = _this select 2;
private _fromTaskId = _this select 3;
private _assignToPlayer = driver _bindToVehicle;

private _enemies = [];
private _lzhot = false;
//Make the LZ hot if the roll demands it
 
 _lzhot = true;
 
private _lzAA = false;
if ((random 1) < AAChance) then
{
    _lzhot = true;
    _lzAA = true;
};
private _taskType = "move";
 

lzCounter = lzCounter + 1;
publicVariable "lzCounter";

private _shortestDesc = format["LZ %1", lzCounter];
private _longdesc = format["%1 wants to fly to this location", _bindToSquad];
private _shortdesc = format["Drop off %1", _bindToSquad];
if (_lzAA and _lzhot) then
{
    _longdesc = _longdesc + "<br/><strong>Be advised:</strong> Intel reports heavy enemy activity with AA assets at the location";
};
if (!_lzAA and _lzhot) then
{
    _longdesc = _longdesc + "<br/><strong>Be advised:</strong> Intel reports enemy activity at the location";
};

_longdesc = _longdesc + format["<br/>Created for %1", _assignToPlayer];
private _assignTo = [_assignToPlayer, west];

private _taskid = format["dropoff_%1", lzCounter];
// Create the task for everyone
[_assignTo,[_taskid],[_longdesc, _shortdesc, _shortestDesc],getPos _lzLocation,"CREATED",(STARTPRIORITY-lzCounter),true, _taskType, true] call BIS_fnc_taskCreate;
// Assign to the player
[_taskid,[_assignToPlayer],[_longdesc, _shortdesc, _shortestDesc],getPos _lzLocation,"ASSIGNED"] call BIS_fnc_setTask;
taskIds pushBackUnique _taskid;
publicVariable "taskIds";

private _trg1 = createTrigger["EmptyDetector",getPos _lzLocation, false];
_trg1 setTriggerArea[lzSize,lzSize,0,false];
_trg1 setTriggerActivation["WEST","PRESENT",false];
_trg1 setTriggerTimeout [2.5, 2.5, 2.5, true];
private _trg1Cond = format["((%1 in thisList) && ([%1] call isLanded))", _bindToVehicle];
//diag_log format["createDropoffLZ: _trg1Cond %s", _trg1Cond];
_trg1 setTriggerStatements[_trg1Cond , "", ""];


private _trg2 = createTrigger["EmptyDetector",getPos _lzLocation, false];
_trg2 setTriggerArea[ParaDropSize,ParaDropSize,0,false];
_trg2 setTriggerActivation["WEST","PRESENT",false];
_trg2 setTriggerTimeout [2.5, 2.5, 2.5, true];
private _trg2Cond = format["((%1 in thisList) && ([%1] call isParaHeight))", _bindToVehicle];
//diag_log format["createDropoffLZ: _trg2Cond %s", _trg2Cond];
_trg2 setTriggerStatements[_trg2Cond , "", ""];


// TODO: implement deadline so the task doesn't linger forever
scopeName "main";
while {true} do
{
    scopeName "mainloop";
    //diag_log format["createDropoffLZ: ticking %1", _this];

    if (( _taskid call BIS_fnc_taskCompleted)) then
    {
        diag_log format["createPickupLZ: task %1 was marked complete", _taskid];
        breakOut "mainloop";
    };

    private _squadAliveCount = {alive _x} count units _bindToSquad;
    if ((_squadAliveCount < 1)) then
    {
        diag_log format["createDropoffLZ: Everyone from %1 is dead!", _bindToSquad];
        // Everybody died before getting there :(
        [_taskid, "FAILED" ,true] spawn BIS_fnc_taskSetState;
        breakOut "mainloop";
    };

    if (triggerActivated _trg1) then
    {
        diag_log format["createDropoffLZ: triggered, unloading %1", _bindToSquad];
        private _veh = [list _trg1] call playerVehicleInList;
        if(!alive  _assignToPlayer) then {
           _veh = _bindToVehicle;
        };
        private _handle = [_lzLocation, _veh, _bindToSquad, _taskid] spawn ejectSquad;
        waitUntil {isNull _handle};
        breakOut "mainloop";
    };

    if (triggerActivated _trg2) then
    {
        diag_log format["createDropoffLZ: triggered, unloading %1", _bindToSquad];
        private _veh = [list _trg2] call playerVehicleInList;
        if(!alive  _assignToPlayer) then {
           _veh = _bindToVehicle;
        };        
        private _handle = [_lzLocation, _veh, _bindToSquad, _taskid] spawn ejectSquad;
        waitUntil {isNull _handle};
        breakOut "mainloop";
    };

	sleep 1;
};

deleteVehicle _trg1;

sleep squadsLinger;
// Make sure there are no lingering enemy or own units
[_enemies + [_bindToSquad]] call deleteSquads;
