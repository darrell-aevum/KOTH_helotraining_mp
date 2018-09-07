//diag_log format["createRandomEnemy called, _this: %1", _this]; 

private _groupEnemy = createGroup east;
if(enemyCount == 0) exitWith {};

// TODO: use some preconfigured fireteam setup
private _groupEnemy = createGroup east;
private _unitTypes = ["O_Soldier_F","O_Soldier_F","O_Soldier_F","O_Soldier_F","O_soldier_M_F","O_soldier_AR_F","O_soldier_M_F","O_soldier_AR_F","O_soldier_M_F"];
private _ranks = ["PRIVATE","PRIVATE","PRIVATE","PRIVATE","PRIVATE","PRIVATE", "CORPORAL","CORPORAL","CORPORAL","CORPORAL", "SERGEANT","SERGEANT","SERGEANT","SERGEANT", "LIEUTENANT","LIEUTENANT", "CAPTAIN", "COLONEL"];


for [{_i=0},{_i<=(enemyCount/2)},{_i=_i+1}] do {
    _centreCoords = getMarkerPos format["tower_%1", (_i % 4) +1]; 
    _centreCoords set [0, ((_centreCoords select 0) + 5 + (floor random 60))];
    _centreCoords set [1, ((_centreCoords select 1) + 5 + (floor random 60))];
    _enemyPosition = _centreCoords findEmptyPosition [0,100];

    if(_i % 3 == 0) then {
        _groupEnemy = createGroup east;
    };
    
    _type = _unitTypes select random((count _unitTypes) - 1);
    _rank = _ranks select random((count _ranks) - 1);

    _skill = random[0, .6, 1];

    _type createUnit [_enemyPosition, _groupEnemy,"",_skill, _rank];
};


for [{_i=0},{_i<=(enemyCount/2)},{_i=_i+1}] do {
    _centreCoords = getMarkerPos format["tower_4", (_i % 4) +1]; 
    _enemyPosition =[[[_centreCoords, 350]],[]] call BIS_fnc_randomPos;

    if(_i % 4 == 0) then {
        _groupEnemy = createGroup east;
    };
    
    _type = _unitTypes select random((count _unitTypes) - 1);
    _rank = _ranks select random((count _ranks) - 1);

    _skill = random[0, .6, 1];

    _type createUnit [_enemyPosition, _groupEnemy,"",_skill, _rank];
}; 

//diag_log format["createEnemySquad %1 positioned to %2", _groupEnemy, _enemyPosition];

[_groupEnemy]