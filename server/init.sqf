//	@file Version: 1.1
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap
//	@file Created: 20/11/2012 05:19
//	@file Description: The server init.
//	@file Args:
#include "setup.sqf"
if(!X_Server) exitWith {};

sideMissions = 1;
serverSpawning = 1;

//Execute Server Side Scripts.
[] execVM "server\admins.sqf";
[] execVM "server\functions\serverVars.sqf";
_serverCompiledScripts = [] execVM "server\functions\serverCompile.sqf";
[] execVM "server\functions\broadcaster.sqf";
[] execVM "server\functions\relations.sqf";
[] execVM "server\functions\serverTimeSync.sqf";
waitUntil{scriptDone _serverCompiledScripts};


diag_log format["WASTELAND SERVER - Server Complie Finished"];

#ifdef __DEBUG__
#else
//Execute Server Spawning.
if (serverSpawning == 1) then {
    diag_log format["WASTELAND SERVER - Initilizing Server Spawning"];
	_vehSpawn = [] ExecVM "server\functions\vehicleSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _vehSpawn};
    _objSpawn = [] ExecVM "server\functions\objectsSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _objSpawn};
    _objSpawn2 = [] ExecVM "server\functions\objectsSpawning2.sqf";
	waitUntil{sleep 0.1; scriptDone _objSpawn2};
    _boxSpawn = [] ExecVM "server\functions\boxSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _boxSpawn};
    _heliSpawn = [] ExecVM "server\functions\staticHeliSpawning.sqf";
    waitUntil{sleep 0.1; scriptDone _heliSpawn};
};
#endif
//Execute Server Missions.
if (sideMissions == 1) then {
	diag_log format["WASTELAND SERVER - Initilizing Missions"];
    [] execVM "server\missions\sideMissionController.sqf";
    sleep 5;
    [] execVM "server\missions\mainMissionController.sqf";
};

if (isDedicated) then {
	_id = [] execFSM "server\WastelandServClean.fsm";
};
