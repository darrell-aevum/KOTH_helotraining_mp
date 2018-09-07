// Config constant globals
DROPOFFLZCOUNT = 8;
PICKUPLZCOUNT = 1;

STARTPRIORITY = 1000;
EXLUDESPAWNLZS = [];//(missionNamespace getVariable "pickup")]; // Exclude the airport location near spawn marker

// Precompile code
execVM "precompile.sqf";

// We can't run this before
if (isServer) then
{
    // Keep track of how many LZ we have created, used to give tasks unique names and priorities
    lzCounter = 0;
    publicVariable "lzCounter";
    taskIds = [];
    publicVariable "taskIds";

    //Handle MP parameters
    _handle = execVM "readparams.sqf";
    waitUntil {isNull _handle};
    if (autoSpawnTasks) then
    {
        [EXLUDESPAWNLZS] spawn taskSpawner;
    };
    [] call createRandomEnemy;
};

// Flag init complete
missionInitComplete = true;
publicVariable "missionInitComplete";
