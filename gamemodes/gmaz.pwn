//total lines 8407
#include <a_samp>
#include <a_mysql>
#include <a_actor>
#include <a_extactor>
#include <streamer>
#include <progress2>
#include <zcmd>
#include <foreach>
#include <sscanf2>
#include <strlib>
#include <eSelection>
#include <easyDialog>
#include <discord-connector>
#include <discord-command>

#include <apo/antiairbreak>

//define blabla stuff easy
#include <apo/define>
#include <apo/newenum>
#include <apo/script>
#include <apo/dialog>
#include <apo/stock>
#include <apo/cmdplayers>
#include <apo/actorclan>
#include <apo/clan>
#include <apo/cmdadmins>
#include <apo/cmddebug>
#define discordonline
#if defined discordonline
#include <apo/dc>
#endif

main(){}

static s_TargetActor[MAX_PLAYERS] = {INVALID_ACTOR_ID, ...};   //for resaon has to be in gm

public OnGameModeInit()
{
    AntiDeAMX();
    mysql_Init();
	SetGameModeText("Apo 0.19.8407");
	SendRconCommand("ackslimit 5000");
    SendRconCommand("hostname [0.3.7] GTA-SA Apocalyptica World (Alpha release)");
	UsePlayerPedAnims();
    ManualVehicleEngineAndLights(); //vehicle on/off
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	SetWeather(0);
	SetWorldTime(10);
    ShowPlayerMarkers(0);
    SetNameTagDrawDistance(25.0);
    actorclanc();
    mapping();
    AutoCleanExpiredBans();
    LoadWeaponDrops();
    InitMenu(); //menu armory
    mysql_tquery(mysql, "SELECT * FROM `storages`", "storages_Load", "");
    mysql_tquery(mysql, "SELECT * FROM `objects`", "objects_Load", "");
    mysql_tquery(mysql, "SELECT * FROM `spawnpos`", "loadspawnpos", "");
    mysql_tquery(mysql, "SELECT * FROM `clans`", "loadclans", "");
    mysql_tquery(mysql, "SELECT * FROM `vehicles`", "OnVehiclesLoaded", "");
    mysql_tquery(mysql, "SELECT * FROM `fuel_stations`", "OnFuelStationsLoaded");
	mysql_tquery(mysql, "SELECT * FROM gang_zones", "LoadGangZones");
    mysql_tquery(mysql, "SELECT * FROM `entrances`", "Entrance_Load", "");
    FuelStationCount = 0;
    for (new i = 0; i < MAX_SERVER_VEHICLES; i++)
    {
        DB_Vehicle[i] = INVALID_VEHICLE_ID;
        DB_VehicleID[i] = 0;
    }
    #if defined discordonline
    loaddiscord();
    #endif
    SetTimer("CheckUnoccupiedVehicleTeleport", 3000, true); //antitpveh
    SetTimer("GangZoneResourceTick", GANG_RESOURCE_TIME, true);  //timer reward
	return 1;
}
public OnGameModeExit()
{
    mysql_close(mysql);
    return 1;
}
public OnPlayerConnect(playerid)
{
	// resetting player enums so old's stats wont mix to new playerid
	for(new i; DATAX:i < DATAX; i++)
	{
 		pData[playerid][DATAX:i] = 0;
	}
    Lockpick[playerid][lpActive] = false;
    TogglePlayerSpectating(playerid, 1);
    SetPlayerHealth(playerid,10);
    SetPlayerInterior(playerid,0);
	IsPlayerRegisterd[playerid] = 0;
    missioncheck = 0;
    Death[playerid] = 0;
    claninv = -1;
    ResetPlayerWeapons(playerid);
	GetPlayerName(playerid, Name[playerid], 24); //Getting player's name
	GetPlayerIp(playerid, IP[playerid], 16); //Getting layer's IP
    //vie armure
    mysql_format(mysql, query, sizeof(query),"SELECT * FROM bans WHERE player_name = '%e'", Name);
    mysql_tquery(mysql, query, "OnCheckPlayerBan", "d", playerid);
	//deer
	inJOB[playerid] = 0;
	DistanceTD[playerid] = CreatePlayerTextDraw(playerid, 87.333358, 317.573242, "Distance_xxxM");
	PlayerTextDrawLetterSize(playerid, DistanceTD[playerid], 0.363428, 1.297067);
	PlayerTextDrawTextSize(playerid, DistanceTD[playerid], 0.000000, 111.000000);
	PlayerTextDrawAlignment(playerid, DistanceTD[playerid], 2);
	PlayerTextDrawColor(playerid, DistanceTD[playerid], -1);
	PlayerTextDrawUseBox(playerid, DistanceTD[playerid], 1);
	PlayerTextDrawBoxColor(playerid, DistanceTD[playerid], 112);
	PlayerTextDrawSetShadow(playerid, DistanceTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, DistanceTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DistanceTD[playerid], 189);
	PlayerTextDrawFont(playerid, DistanceTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, DistanceTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, DistanceTD[playerid], 0);
	PlayerTextDrawHide(playerid, DistanceTD[playerid]);

    txtSpeed[playerid] = CreatePlayerTextDraw(playerid,505.0, 145.0, "Speed: 0 km/h");
    PlayerTextDrawFont(playerid, txtSpeed[playerid], 1);
    PlayerTextDrawLetterSize(playerid, txtSpeed[playerid], 0.25, 1.0);
    PlayerTextDrawColor(playerid, txtSpeed[playerid], -1);
    PlayerTextDrawSetOutline(playerid, txtSpeed[playerid], 1);

    FuelBar[playerid] = CreatePlayerProgressBar(playerid, 505.0, 125.0, 100.0, 5.0, 0xFFFF00AA, 100.0);
    HealthBar[playerid] = CreatePlayerProgressBar(playerid, 505.0, 135.0, 100.0, 5.0, 0xFF0000AA, 100.0);

    pData[playerid][Foodbar] = CreatePlayerProgressBar(playerid, 505.0, 105.0, 100.0, 5.0, 0xFFFF00AA, 100.0);
    pData[playerid][Waterbar] = CreatePlayerProgressBar(playerid, 505.0, 115.0, 100.0, 5.0, 0xFF0000AA, 100.0);

    for (new i = 0; i < TotalGZ; i++) GangZoneShowForPlayer(playerid, GangZones[i][gZoneID], GetTeamZoneColor(GangZones[i][gTeamID]));
    LoginCameraStep[playerid] = 0;
    LoginCameraTimer[playerid] = SetTimerEx("LoginCamera", 1000, false, "i", playerid);
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	PlayerTextDrawHide(playerid, txtSpeed[playerid]);
    HidePlayerProgressBar(playerid, FuelBar[playerid]);
    HidePlayerProgressBar(playerid, HealthBar[playerid]);
	if(IsPlayerRegisterd[playerid] != 0)
	{
		SavePlayerData(playerid);
	}
    for (new i = 0; i < TotalGZ; i++)
    {
        if (ZoneInWar[i])
        {
            CheckWarZoneEmpty(i);
        }
    }
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new Float:pPosX, Float:pPosY, Float:pPosZ;
	GetPlayerPos(playerid, pPosX, pPosY, pPosZ);
	PlayerTextDrawHide(playerid, txtSpeed[playerid]);
    HidePlayerProgressBar(playerid, FuelBar[playerid]);
    HidePlayerProgressBar(playerid, HealthBar[playerid]);
    for(new i_slot = 0, gun, ammo; i_slot != 12; i_slot++)
    {
        GetPlayerWeaponData(playerid, i_slot, gun, ammo);
        if(gun != 0 && ammo != 0) CreateDroppedGun(gun, ammo, pPosX+random(2)-random(2), pPosY+random(2)-random(2), pPosZ);
    }
    for (new i = 0; i < TotalGZ; i++)
    {
        if (ZoneInWar[i])
        {
            CheckWarZoneEmpty(i);
        }
    }
    ResetPlayerWeapons(playerid);
    Death[playerid] = 1;
	return 1;
}
public OnPlayerUpdate(playerid)
{
	new zping = GetPlayerPing(playerid);
	if(zping >= 500)
	{
		SendServerMessage(playerid,"[KICK] High Ping!");
		KickEx(playerid);
	}
	if (GetPlayerScore(playerid) != pData[playerid][Score])
	{
		SetPlayerScore(playerid, pData[playerid][Score]);    // 0 = 8
        if(pData[playerid][Score] == 5) pData[playerid][inv][0] = 1;   // 1 = 16
        if(pData[playerid][Score] == 10) pData[playerid][inv][0] = 2;  // 2 = 32
        if(pData[playerid][Score] == 15) pData[playerid][inv][0] = 3;  // 3 = 64
        if(pData[playerid][Score] == 20) pData[playerid][inv][0] = 4;   // 4 = 128
        if(pData[playerid][Score] == 25) pData[playerid][inv][0] = 5;   // 5 = 256
	}
	new target_actor = GetPlayerTargetActor(playerid);
	if (s_TargetActor[playerid] != target_actor)
	{
	    CallLocalFunction("OnPlayerTargetActor", "iii", playerid, target_actor, s_TargetActor[playerid]);
	    s_TargetActor[playerid] = target_actor;
	}
    new Float:health,Float:armour;
    GetPlayerHealth(playerid,health);
    GetPlayerArmour(playerid,armour);
    if (health >= 101.10)
    {
        SendAdminAlert(COLOR_RED ,"Player %s has more that 100 Health. Possibility of cheating.", GetName(playerid));
        SetPlayerHealth(playerid, 100.0);
    }
    if (armour >= 101.10)
    {
        SendAdminAlert(COLOR_RED ,"Player %s has more that 100 Armour. Possibility of cheating.", GetName(playerid));
        SetPlayerArmour(playerid, 100.0);
    }
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerInAnyVehicle(i)) continue;
        new vehicleid = GetPlayerVehicleID(i),color,Float:vX, Float:vY, Float:vZ;
        GetVehicleVelocity(vehicleid, vX, vY, vZ);
        GetVehicleHealth(vehicleid, health);
        new Float:speed = floatsqroot(vX*vX + vY*vY + vZ*vZ) * 170.0,str[64],Float:vehHP;
        format(str, sizeof(str), "Speed: %d km/h", floatround(speed));
        PlayerTextDrawSetString(i, txtSpeed[i], str);
        PlayerTextDrawShow(i, txtSpeed[i]);
        if(floatround(speed) > 0.03) gVehicleFuel[vehicleid] -= GetFuelConsumptionRate(vehicleid);
		if (gVehicleFuel[vehicleid] < 10.0)
		{
    		if (!FuelWarningVisible[playerid])
    		{
        		FuelWarningVisible[playerid] = true;
    		}
		}
		else if (FuelWarningVisible[playerid]) FuelWarningVisible[playerid] = false;
        if (gVehicleFuel[vehicleid] < 0.0)
        {
            gVehicleFuel[vehicleid] = 0.0;
            SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0); // disable engine
        }
   		if (health <= 650.0 && !FuelLeaking[vehicleid])
    	{
        	FuelLeaking[vehicleid] = true;
        	SendClientMessage(playerid, 0xFF6600FF, "[Fuel] Your vehicle has a fuel leak!");
    	}
		if (FuelLeaking[vehicleid] && gVehicleFuel[vehicleid] > 0.0 && EngineState[vehicleid] == true )
		{
    		gVehicleFuel[vehicleid] -= GetFuelConsumptionRate(vehicleid); // leak rate
    		if (gVehicleFuel[vehicleid] <= 0.0)
    		{
        		gVehicleFuel[vehicleid] = 0.0;
        		SetVehicleParamsEx(vehicleid, false, 0, 0, 0, 0, 0, 0);
        		FuelLeaking[vehicleid] = false;
        		SendClientMessage(playerid, 0xFF0000FF, "[Fuel] You've run out of fuel due to a leak.");
    		}
		}
		if (gVehicleFuel[vehicleid] >= 65.0) color = 0x00FF00AA; // Green
    	else if (gVehicleFuel[vehicleid] >= 25.0) color = 0xFFFF00AA; // Yellow
    	else color = 0xFF0000AA; // Red
		SetPlayerProgressBarColour(playerid, FuelBar[playerid], color);
        SetPlayerProgressBarValue(i, FuelBar[i], gVehicleFuel[vehicleid]);
        ShowPlayerProgressBar(i, FuelBar[i]);
        GetVehicleHealth(vehicleid, vehHP);
        new Float:hpPercent = vehHP / 10.0; // Normalize to 100 scale
        SetPlayerProgressBarValue(i, HealthBar[i], hpPercent);
        ShowPlayerProgressBar(i, HealthBar[i]);
   		if (health <= 249.0) SetVehicleHealth(vehicleid,250.0);
        if (floatround(speed) > 280)
        {
            if (GetPlayerState(playerid) != PLAYER_STATE_PASSENGER)
            {
                SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s SPEED HACK POSSIBLE.", Name[playerid]);
                KickEx(playerid);
            }
        }
    }
    CheckPlayerWeapons(playerid);
    return 1;
}
public OnPlayerText(playerid, text[])
{
	if (pData[playerid][pSpamCount] < 5)
	{
	    pData[playerid][pSpamCount]++;

	    if (pData[playerid][pSpamCount] == 5) {
	        pData[playerid][pSpamCount] = 0;

            SetTimerEx("UnMutedTimer",5000, false, "i", playerid); //60*1000 = 1 minute

	        SendServerMessage(playerid, "SPAM detected muted (5 seconds).");
	        SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has been automatic muted for spam.", Name[playerid]);
	        return 0;
		}
	}
	if (pMuted[playerid] == true)
	{
	    SendServerMessage(playerid, "You are muted by the server.");
	    return 0;
	}
    else
    {
	    SendNearbyMessage(playerid, 15.0, COLOR_WHITE, "%s say: %.64s", Name[playerid], text);
	    SendNearbyMessage(playerid, 15.0, COLOR_WHITE, "...%s", text[64]);
    }
    return 0;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
    {
		PlayerTextDrawHide(playerid, txtSpeed[playerid]);
    	HidePlayerProgressBar(playerid, FuelBar[playerid]);
    	HidePlayerProgressBar(playerid, HealthBar[playerid]);
    	FuelWarningVisible[playerid] = false;
	}
    if (newstate == PLAYER_STATE_DRIVER)
    {
        new vid = GetPlayerVehicleID(playerid);
        if(IsAVelo(GetPlayerVehicleID(playerid)))
        {
            SetVehicleParamsEx(vid, false, 0, 0, 0, 0, 0, 0); // Always off
            EngineState[vid] = false;
            SendClientMessage(playerid, 0xAAAAAAFF, "[Engine] Press Y to start the engine.");
            ShowPlayerProgressBar(playerid, FuelBar[playerid]);
            ShowPlayerProgressBar(playerid, HealthBar[playerid]);
            PlayerTextDrawShow(playerid, txtSpeed[playerid]);
        }
        else SetVehicleParamsCarWindows(vid, 1, 0, 0, 0);
    }
    return 1;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    for (new i = 0; i < MAX_SERVER_VEHICLES; i++)
    {
        if (DB_Vehicle[i] == vehicleid)
        {
            mysql_format(mysql, query, sizeof(query),"SELECT mods FROM vehicles WHERE id = %d", DB_VehicleID[i]);
            mysql_tquery(mysql, query, "OnLoadModsForVehicle", "ii", playerid, vehicleid);
            break;
        }
    }
    return 1;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
    for (new i = 0; i < MAX_SERVER_VEHICLES; i++)
    {
        if (DB_Vehicle[i] == vehicleid)
        {
            new Float:x, Float:y, Float:z;
            GetVehiclePos(vehicleid, x, y, z);
            g_LastVehiclePos[vehicleid][0] = x;
			g_LastVehiclePos[vehicleid][1] = y;
			g_LastVehiclePos[vehicleid][2] = z;
            cmd_saveveh(playerid, "0");
        }
    }
    return 1;
}
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if( hittype != BULLET_HIT_TYPE_NONE ) // Bullet Crashing uses just this hittype
	{
        if( !( -1000.0 <= fX <= 1000.0 ) || !( -1000.0 <= fY <= 1000.0 ) || !( -1000.0 <= fZ <= 1000.0 ) )
		{
			Kick(playerid);
			return 0;
		}
	}
	//deer
	if(Deer[playerid] == 1)
	{
		if(weaponid == 33)
		{
			if(hittype == BULLET_HIT_TYPE_OBJECT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 100.0, 8521.4727,13804.3506,3.8626) && Shoot_Deer[playerid] == 0)
				{
					KillTimer(Meeters_BTWDeer[playerid]);
					Meeter_Kill[playerid] = Meeters[playerid];
					Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
					if(Meeter_Kill[playerid] >= 20)
					{
						Shoot_Deer[playerid] = 1;
			  			MoveObject(Hunter_Deer[playerid], 8521.4727,13804.3506,3.8626, 3.5, -90.0000, 0.0000, 0.0000);
                        SendServerMessage(playerid,"You just kill a deer go collect his meat Press ~k~~SNEAK_ABOUT~ to take his meat");
			  			Deep_Deer[playerid] = 1;
       				}
					else
					{
			  			DestroyObject(Hunter_Deer[playerid]);
			  			SendServerMessage(playerid,"You shot too far the deer run off");
			  			DisablePlayerCheckpoint(playerid);
			  			SetTimerEx("Next_Deer", 1000, false, "i", playerid);
		  			}
		  		}
			}
		}
	}
	else if(Deer[playerid] == 2)
	{
        if(weaponid == 33)
		{
			if(hittype == BULLET_HIT_TYPE_OBJECT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 100.0, 8712.4287,14008.3896,2.0037) && Shoot_Deer[playerid] == 0) {
					KillTimer(Meeters_BTWDeer[playerid]);
					Meeter_Kill[playerid] = Meeters[playerid];
					Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
					if(Meeter_Kill[playerid] >= 20)
					{
						Shoot_Deer[playerid] = 1;
			  			MoveObject(Hunter_Deer[playerid], 8712.4287,14008.3896,2.0037, 3.5, -90.0000, 0.0000, 0.0000);
                        SendServerMessage(playerid,"You just kill a deer go collect his meat Press ~k~~SNEAK_ABOUT~ to take his meat");
			  			Deep_Deer[playerid] = 1;
					}
					else
					{
			  			DestroyObject(Hunter_Deer[playerid]);
						SendServerMessage(playerid,"You shot too far the deer run off");
			  			DisablePlayerCheckpoint(playerid);
			  			SetTimerEx("Next_Deer", 1000, false, "i", playerid);
					}
				}
			}
		}
	}
	else if(Deer[playerid] == 3)
	{
        if(weaponid == 33)
		{
			if(hittype == BULLET_HIT_TYPE_OBJECT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 100.0, 8704.8564,14117.2051,4.8480) && Shoot_Deer[playerid] == 0) {
					KillTimer(Meeters_BTWDeer[playerid]);
					Meeter_Kill[playerid] = Meeters[playerid];
					Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
					if(Meeter_Kill[playerid] >= 20)
					{
						Shoot_Deer[playerid] = 1;
			  			MoveObject(Hunter_Deer[playerid], 8704.8564,14117.2051,4.8480, 3.5, 90.00000, 0.00000, -54.66002);
                        SendServerMessage(playerid,"You just kill a deer go collect his meat Press ~k~~SNEAK_ABOUT~ to take his meat");
			  			Deep_Deer[playerid] = 1;
					}
					else
					{
						DestroyObject(Hunter_Deer[playerid]);
						SendServerMessage(playerid,"You shot too far the deer run off");
			  			DisablePlayerCheckpoint(playerid);
			  			SetTimerEx("Next_Deer", 1000, false, "i", playerid);
					}
				}
			}
		}
	}
	else if(Deer[playerid] == 4)
	{
        if(weaponid == 33)
		{
			if(hittype == BULLET_HIT_TYPE_OBJECT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 100.0, 8729.0361,14638.2578,15.9921) && Shoot_Deer[playerid] == 0) {
					KillTimer(Meeters_BTWDeer[playerid]);
					Meeter_Kill[playerid] = Meeters[playerid];
					Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
					if(Meeter_Kill[playerid] >= 20)
					{
						Shoot_Deer[playerid] = 1;
			  			MoveObject(Hunter_Deer[playerid], 8729.0361,14638.2578,15.9921, 3.5, 90.00000, 0.00000, -7.38000);
                        SendServerMessage(playerid,"You just kill a deer go collect his meat Press ~k~~SNEAK_ABOUT~ to take his meat");
			  			Deep_Deer[playerid] = 1;
					}
					else
					{
						DestroyObject(Hunter_Deer[playerid]);
						SendServerMessage(playerid,"You shot too far the deer run off");
			  			DisablePlayerCheckpoint(playerid);
			  			SetTimerEx("Next_Deer", 1000, false, "i", playerid);
					}
				}
			}
		}
	}
	else if(Deer[playerid] == 5)
	{
        if(weaponid == 33)
		{
			if(hittype == BULLET_HIT_TYPE_OBJECT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 100.0, 8597.6152,14805.4805,23.4484) && Shoot_Deer[playerid] == 0) {
					KillTimer(Meeters_BTWDeer[playerid]);
					Meeter_Kill[playerid] = Meeters[playerid];
					Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
					if(Meeter_Kill[playerid] >= 20)
					{
						Shoot_Deer[playerid] = 1;
			  			MoveObject(Hunter_Deer[playerid], 8597.6152,14805.4805,23.4484, 3.5, 90.00000, 0.00000, 0.00000);
                        SendServerMessage(playerid,"You just kill a deer go collect his meat Press ~k~~SNEAK_ABOUT~ to take his meat");
			  			Deep_Deer[playerid] = 1;
					}
					else
					{
						DestroyObject(Hunter_Deer[playerid]);
						SendServerMessage(playerid,"You shot too far the deer run off");
			  			DisablePlayerCheckpoint(playerid);
			  			SetTimerEx("Next_Deer", 1000, false, "i", playerid);
					}
				}
			}
		}
	}
	else if(Deer[playerid] == 6)
	{
        if(weaponid == 33)
		{
			if(hittype == BULLET_HIT_TYPE_OBJECT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 100.0, 8800.6748,13836.8525,2.4051) && Shoot_Deer[playerid] == 0) {
					KillTimer(Meeters_BTWDeer[playerid]);
					Meeter_Kill[playerid] = Meeters[playerid];
					Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
					if(Meeter_Kill[playerid] >= 20)
					{
						Shoot_Deer[playerid] = 1;
			  			MoveObject(Hunter_Deer[playerid], 8800.6748,13836.8525,2.4051, 3.5, 90.00000, 0.00000, -49.26000);
                        SendServerMessage(playerid,"You just kill a deer go collect his meat Press ~k~~SNEAK_ABOUT~ to take his meat");
			  			Deep_Deer[playerid] = 1;
					}
					else
					{
						DestroyObject(Hunter_Deer[playerid]);
						SendServerMessage(playerid,"You shot too far the deer run off");
			  			DisablePlayerCheckpoint(playerid);
			  			SetTimerEx("Next_Deer", 1000, false, "i", playerid);
					}
				}
			}
		}
	}
	return 1;
}
public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
    ResetAllowedWeapons(playerid);
	//skill
	SetPlayerSkillLevel(playerid,WEAPONSKILL_PISTOL,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_PISTOL_SILENCED,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_DESERT_EAGLE,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SHOTGUN,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SAWNOFF_SHOTGUN,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SPAS12_SHOTGUN,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_MICRO_UZI,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_MP5,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_AK47,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_M4,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SNIPERRIFLE,200);
    SetPlayerSkin(playerid,pData[playerid][skin]);
    //vie armure
	SetPlayerHealth(playerid,pData[playerid][Life]);
	SetPlayerArmour(playerid,pData[playerid][Armor]);
    SetPlayerSkin(playerid,pData[playerid][skin]);
    SetPlayerInterior(playerid,pData[playerid][interior]);
    SetPlayerScore(playerid, pData[playerid][Score]);
    if(Death[playerid] == 1)
	{
        SetPlayerInterior(playerid,0);
        ResetPlayerWeapons(playerid);
        switch (random(8))
        {
            case 0: SetPlayerPos(playerid,-722.1279,2582.5281,70.3687);
            case 1: SetPlayerPos(playerid,-884.5097,2761.1423,46.0000);
            case 2: SetPlayerPos(playerid,-209.0710,2771.4448,62.3780);
            case 3: SetPlayerPos(playerid,84.2828,2450.4319,16.4844);
            case 4: SetPlayerPos(playerid,413.4136,2585.2964,16.7334);
            case 5: SetPlayerPos(playerid,145.4671,2209.1653,35.5056);
            case 6: SetPlayerPos(playerid,547.4021,2273.4055,34.8501);
            case 7: SetPlayerPos(playerid,209.4851,2617.1570,16.6514);
        }
        SetPlayerHealth(playerid,10);
        SetPlayerArmour(playerid,0);
        Death[playerid] = 0;
    }
    else
    {
        SetPlayerInterior(playerid,pData[playerid][interior]);
        SetPlayerPos(playerid,pData[playerid][Pos][0],pData[playerid][Pos][1],pData[playerid][Pos][2]);
        for(new i = 0; i <= 12; i++)
        {
            GivePlayerWeapon(playerid, pData[playerid][Guns][i], pData[playerid][Ammo][i]);
            AllowWeapon(playerid, pData[playerid][Guns][i], pData[playerid][Ammo][i]);
        }
    }
    return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
    SetSpawnInfo(playerid, 0, pData[playerid][skin], pData[playerid][Pos][0], pData[playerid][Pos][0], pData[playerid][Pos][0], 0.0, 0, 0, 0, 0, 0, 0);
	SetPlayerColor(playerid, 0xFFFFFFFF);
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (newkeys & KEY_YES)
    {
        if (!IsPlayerInAnyVehicle(playerid)) return 1;
        if (GetPlayerVehicleSeat(playerid) != 0) return 1;
        new vehicleid = GetPlayerVehicleID(playerid);
        if (gVehicleFuel[vehicleid] <= 0.0 && !IsAVelo(vehicleid))
        {
            SendClientMessage(playerid, 0xFF0000FF, "[Fuel] No fuel. Refuel first!");
            return 1;
        }
        EngineState[vehicleid] = !EngineState[vehicleid];
		if (FuelLeaking[vehicleid]) SendClientMessage(playerid, 0xFF0000FF, "[Fuel] Leak detected watch out for the gaz consumption.");
        SetVehicleParamsEx(vehicleid,EngineState[vehicleid],0, 0, 0, 0, 0, 0);
    }
	if (newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK)
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
			new f = MAX_SPAWNPOS+1,chancerand = random(36),taking = random(3) + 1;
			for(new a = 0; a < MAX_SPAWNPOS; a++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.0, dspawnpos[a][Pos][0], dspawnpos[a][Pos][1], dspawnpos[a][Pos][2]) && IsValidDynamicObject(dspawnpos[a][Objects]))
				{
					f = a;
					break;
				}
			}
			if(f > MAX_SPAWNPOS) return SendClientMessage(playerid, COLOR_RED, "You are not near an object that you can pick up.");
			switch(chancerand)
			{
				//melee
				case 0: GiveWeaponWithReplace(playerid, 4,random(2)+1);
                case 1: GiveWeaponWithReplace(playerid, 3,random(2)+1);
                case 2: GiveWeaponWithReplace(playerid, 6,random(2)+1);
				//pistol
				case 3: GiveWeaponWithReplace(playerid, 22,random(5)+1);
				//shotgun
				case 4: GiveWeaponWithReplace(playerid, 25,random(10)+1);
				case 5: GiveWeaponWithReplace(playerid, 26,random(4)+1);
				//rifle
				case 6: GiveWeaponWithReplace(playerid,33,random(5)+1);
                case 35: GiveWeaponWithReplace(playerid,34,random(2)+1);
				//inventaire
                case 7 .. 31:
                {
                    new invIndex = chancerand - 6;
                    if (pData[playerid][inv][invIndex] + taking > GetBackpackCapacity(playerid))
                    {
                        DestroyDynamicObject(dspawnpos[f][Objects]);
                        return SendServerMessage(playerid, "Your backpack is full you tossed away.");
                    }
                    pData[playerid][inv][invIndex] += taking;
                }
                case 32: ShowModelSelectionMenu(playerid, "Select your new clothes", MODEL_SELECTION_SKIN, Skinsskins, sizeof(Skinsskins), -16.0, 0.0, -55.0);
                //grenade
                case 33: GiveWeaponWithReplace(playerid,16,1);
                case 34: GiveWeaponWithReplace(playerid,18,1);
			}
            AllowWeapon(playerid, 4,4);
            AllowWeapon(playerid, 3,4);
            AllowWeapon(playerid, 6,4);
			//pistol
			AllowWeapon(playerid, 22,6);
			AllowWeapon(playerid, 25,11);
			AllowWeapon(playerid, 26,5);
			AllowWeapon(playerid, 33,6);
            AllowWeapon(playerid, 16,1);
            AllowWeapon(playerid, 18,1);
            pData[playerid][clanexp][0] += random(3)+1;
			DestroyDynamicObject(dspawnpos[f][Objects]);
			SendClientMessage(playerid, COLOR_GREEN, "You have picked up an object.");
            pData[playerid][Food] -= random(2);
            pData[playerid][Water] -= random(2);
			return 1;
		}
	}
    if(!Lockpick[playerid][lpActive])
        return 1;
    if(newkeys & KEY_SECONDARY_ATTACK)
    {
        if(Lockpick[playerid][lpPos] >= Lockpick[playerid][lpZoneStart] && Lockpick[playerid][lpPos] <= Lockpick[playerid][lpZoneEnd])
        {
            Lockpick[playerid][lpStep]++;
            if(Lockpick[playerid][lpStep] >= Lockpick[playerid][lpRequiredPins])
            {
                KillTimer(Lockpick[playerid][lpTimer]);
                Lockpick[playerid][lpActive] = false;
                SendServerMessage(playerid,"Lock successfully opened!");
                TogglePlayerControllable(playerid, 1);
                new id = -1;
                if ((id = Storage_Nearest(playerid)) != -1)
                {
                    storageData[id][storagesLock] = 0;
                    storages_Save(id);
                    SendServerMessage(playerid,"The storage lock is broken, use /storage install a new lock");
                }
                return 1;
            }
            Lockpick[playerid][lpZoneStart] = random(14)+3;
            Lockpick[playerid][lpZoneEnd] = Lockpick[playerid][lpZoneStart] +Lockpick[playerid][lpZoneSize];
        }
        else
        {
            KillTimer(Lockpick[playerid][lpTimer]);
            Lockpick[playerid][lpActive] = false;
            SendServerMessage(playerid,"You failed the lockpick.");
            TogglePlayerControllable(playerid, 1);
            switch (random(8))
            {
                case 0:
                {
                    pData[playerid][inv][10] -= 1;
                    SendServerMessage(playerid,"Your lockpick has broken!");
                }
            }
        }
    }
	//deer
	if(PRESSED(KEY_WALK))
	{
	 	if(Deep_Deer[playerid] == 1)
		{
	 	    DisablePlayerCheckpoint(playerid);
		 	if(IsPlayerInRangeOfPoint(playerid, 3.5, 8521.4727,13804.3506,4.8626) && Deer[playerid] == 1)
			{
		 		TogglePlayerControllable(playerid, 0);
		 		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 1, 1, 1, 1, 0);
		 		Deep_Deer[playerid] = 0;
		 		KillTimer(Meeters_BTWDeer[playerid]);
		 		Shoot_Deer[playerid] = 0;
		 		SetTimerEx("Done_Deer", 3500, false, "d",playerid);
		 	}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 8712.4287,14008.3896,3.0037) && Deer[playerid] == 2)
			{
		 		TogglePlayerControllable(playerid, 0);
		 		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 1, 1, 1, 1, 0);
		 		Deep_Deer[playerid] = 0;
		 		KillTimer(Meeters_BTWDeer[playerid]);
				Shoot_Deer[playerid] = 0;
		 		SetTimerEx("Done_Deer", 3500, false, "d",playerid);
		 	}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 8704.8564,14117.2051,5.8480) && Deer[playerid] == 3)
			{
		 		TogglePlayerControllable(playerid, 0);
		 		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 1, 1, 1, 1, 0);
		 		Deep_Deer[playerid] = 0;
		 		KillTimer(Meeters_BTWDeer[playerid]);
				Shoot_Deer[playerid] = 0;
		 		SetTimerEx("Done_Deer", 3500, false, "d",playerid);
		 	}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 8729.0361,14638.2578,16.9921) && Deer[playerid] == 4)
			{
		 		TogglePlayerControllable(playerid, 0);
		 		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 1, 1, 1, 1, 0);
		 		Deep_Deer[playerid] = 0;
		 		KillTimer(Meeters_BTWDeer[playerid]);
				Shoot_Deer[playerid] = 0;
		 		SetTimerEx("Done_Deer", 3500, false, "d",playerid);
		 	}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 8597.6152,14805.4805,24.4484) && Deer[playerid] == 5)
			{
		 		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 1, 1, 1, 1, 0);
		 		TogglePlayerControllable(playerid, 0);
		 		Deep_Deer[playerid] = 0;
		 		KillTimer(Meeters_BTWDeer[playerid]);
				Shoot_Deer[playerid] = 0;
		 		SetTimerEx("Done_Deer", 3500, false, "d",playerid);
		 	}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 8800.6748,13836.8525,3.4051) && Deer[playerid] == 6)
			{
		 		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 1, 1, 1, 1, 0);
		 		TogglePlayerControllable(playerid, 0);
		 		Deep_Deer[playerid] = 0;
		 		KillTimer(Meeters_BTWDeer[playerid]);
				Shoot_Deer[playerid] = 0;
		 		SetTimerEx("Done_Deer", 3500, false, "d",playerid);
		 	}
		}
	}
    if(newkeys & KEY_SECONDARY_ATTACK)
    {
        static id = -1;
	    if ((id = ClanEnter_Nearest(playerid)) != -1)
	    {
			SetPlayerPosEx(playerid, clans[id][exitpos][0], clans[id][exitpos][1], clans[id][exitpos][2]);
			SetPlayerInterior(playerid, clans[id][exitinterior]);
			SetPlayerVirtualWorld(playerid, clans[id][exitvw]);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
	    if ((id = ClanExit_Nearest(playerid)) != -1)
	    {
			SetPlayerPosEx(playerid, clans[id][enterpos][0], clans[id][enterpos][1], clans[id][enterpos][2]);
			SetPlayerInterior(playerid, clans[id][enterinterior]);
			SetPlayerVirtualWorld(playerid, clans[id][entervw]);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if ((id = Entrance_Nearest(playerid)) != -1)
	    {
	        if (EntranceData[id][entranceLocked])
	            return SendServerMessage(playerid, "This entrance is locked at the moment.");
            SetPlayerPosEx(playerid, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
			SetPlayerFacingAngle(playerid, EntranceData[id][entranceInt][3]);
			SetPlayerInterior(playerid, EntranceData[id][entranceInterior]);
			SetPlayerVirtualWorld(playerid, EntranceData[id][entranceWorld]);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if ((id = EntranceExit_Nearest(playerid)) != -1 )
	    {
            SetPlayerPosEx(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2]);
			SetPlayerFacingAngle(playerid, EntranceData[id][entrancePos][3] - 180.0);
			SetPlayerInterior(playerid, EntranceData[id][entranceExterior]);
			SetPlayerVirtualWorld(playerid, EntranceData[id][entranceExteriorVW]);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
    }
    return 1;
}
public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    if (IsMeleeWeapon(weaponid)) return 1;
    // Rate-of-fire detection
    new tick = GetTickCount(),delay = WeaponFireDelay[weaponid];
    if (delay > 0 && tick - LastShotTick[playerid] < delay - 50)
    {
        new name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, sizeof(name));
        printf("[ANTI-CHEAT] %s used rapid fire with weapon %d", name, weaponid);
        SendClientMessage(playerid, -1, "Kicked: Rapid fire cheat detected.");
        Kick(playerid);
        return 1;
    }
    LastShotTick[playerid] = tick;
    // Silent aimbot detection
    new Float:px, Float:py, Float:pz, Float:fx, Float:fy, Float:fz,Float:angleToTarget = atan2(fy - py, fx - px),Float:playerFacing;
    GetPlayerPos(playerid, px, py, pz);
    GetPlayerPos(damagedid, fx, fy, fz);
    GetPlayerFacingAngle(playerid, playerFacing);
    new Float:diff = floatsub(playerFacing, angleToTarget);
    if (floatabs(diff) > 90.0)
    {
        AimbotFlags[playerid]++;
        if (AimbotFlags[playerid] >= 3)
        {
            new name[MAX_PLAYER_NAME];
            GetPlayerName(playerid, name, sizeof(name));
            printf("[ANTI-CHEAT] %s suspected of silent aimbot!", name);
            SendClientMessage(playerid, -1, "Kicked: Silent aimbot detected.");
            Kick(playerid);
        }
    }
    return 1;
}
public OnQueryError(errorid, error[], callback[], query1[], connectionHandle)
{
	printf("ERROR: %d. %s, callback: %s, query: %s", errorid, error, callback, query1);
}
public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}
public OnVehicleSpawn(vehicleid)
{
    return 1;
}
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    return 0;
}
public OnPlayerEnterCheckpoint(playerid)
{
    new index = PlayerCurrentCheckpoint[playerid];
    if (index < 0 || index >= MAX_MISSION_CHECKPOINTS)
        return 1;
    index++;
    PlayerCurrentCheckpoint[playerid] = index;

    if (index < MAX_MISSION_CHECKPOINTS)
    {
        SetPlayerCheckpoint(playerid,PlayerMissionCheckpoints[playerid][index][0],PlayerMissionCheckpoints[playerid][index][1],PlayerMissionCheckpoints[playerid][index][2],3.0);
    }
    else
    {
        DisablePlayerCheckpoint(playerid);
        if(missioncheck == 1)
        {
            SendTWMessage(playerid, "Talkie-Walkie : Go back to me now dirty meat!");
            missioncheck = 11;
        }
        if(missioncheck == 2)
        {
            SendTWMessage(playerid, "Talkie-Walkie : Go back to me to do your report civilian.");
            missioncheck = 22;
        }
        if(missioncheck == 3)
        {
            SendTWMessage(playerid, "Talkie-Walkie : Go back to me to do your report soldier.");
            missioncheck = 33;
        }
    }
    return 1;
}
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if (response == EDIT_RESPONSE_FINAL)
	{
	    if (pData[playerid][pEditobjects] != -1 && objectsData[pData[playerid][pEditobjects]][objectsExists])
	    {
	        switch (pData[playerid][pEditType])
	        {
	            case 1:
	            {
	                new id = pData[playerid][pEditobjects];
	                objectsData[pData[playerid][pEditobjects]][objectsPos][0] = x;
	                objectsData[pData[playerid][pEditobjects]][objectsPos][1] = y;
	                objectsData[pData[playerid][pEditobjects]][objectsPos][2] = z;
	                objectsData[pData[playerid][pEditobjects]][objectsPos][3] = rx;
	                objectsData[pData[playerid][pEditobjects]][objectsPos][4] = ry;
	                objectsData[pData[playerid][pEditobjects]][objectsPos][5] = rz;
	                DestroyDynamicObject(objectsData[id][objectsOb]);
					objectsData[id][objectsOb] = CreateDynamicObject(objectsData[id][objectsModel], objectsData[id][objectsPos][0], objectsData[id][objectsPos][1], objectsData[id][objectsPos][2], objectsData[id][objectsPos][3], objectsData[id][objectsPos][4], objectsData[id][objectsPos][5], objectsData[id][objectsWorld], objectsData[id][objectsInterior]);
					objects_Save(id);
                    SendServerMessage(playerid, "You have modify the position of the object ID: %d.", id);
				}
	            case 2:
	            {
	                new id = pData[playerid][pEditobjects];
	                storageData[pData[playerid][pEditobjects]][storagesPos][0] = x;
	                storageData[pData[playerid][pEditobjects]][storagesPos][1] = y;
	                storageData[pData[playerid][pEditobjects]][storagesPos][2] = z;
	                storageData[pData[playerid][pEditobjects]][storagesPos][3] = rx;
	                storageData[pData[playerid][pEditobjects]][storagesPos][4] = ry;
	                storageData[pData[playerid][pEditobjects]][storagesPos][5] = rz;
	                DestroyDynamicObject(storageData[id][storagesOb]);
                    storageData[id][storagesOb] = CreateDynamicObject(1271, storageData[id][storagesPos][0], storageData[id][storagesPos][1], storageData[id][storagesPos][2], storageData[id][storagesPos][3], storageData[id][storagesPos][4], storageData[id][storagesPos][5],-1,-1);
                    storages_Save(id);
                    SendServerMessage(playerid, "You have modify the position of the storage");
				}
			}
		}
	}
	if (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL)
	{
	    pData[playerid][pEditobjects] = -1;
	}
	return 1;
}

public OnModelSelectionResponse(playerid, extraid, index, modelid, response)
{
	if ((response) && (extraid == MODEL_SELECTION_SKIN))
	{
	    pData[playerid][skin] = modelid;
	    SetPlayerSkin(playerid, modelid);
        TogglePlayerControllable(playerid, 1);
	}
	if ((response) && (extraid == MODEL_SELECTION_POLICE))
	{
	    pData[playerid][skin] = modelid;
	    SetPlayerSkin(playerid, modelid);
        ShowMenuForPlayer(PoliceArmory, playerid);
	}
	if ((response) && (extraid == MODEL_SELECTION_CRAFT))
    {
        new Float:x,Float:y,Float:z,Float:angle;
        if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
        {
            for (new i = 0; i < MAX_OBJECTSC; i ++) if (!objectsData[i][objectsExists])
            {
                if (i == -1)
                {
                    SendServerMessage(playerid, "You have reached the maximum barricade limit of the server!");
                    return -1;
                }
                objectsData[i][objectsExists] = true;
                if(modelid == 16404 && pData[playerid][inv][2] >= 10 && pData[playerid][inv][5] >= 5)
				{
                    pData[playerid][inv][2] -= 10;
					pData[playerid][inv][5] -= 5;
                    pData[playerid][clanexp][0] += 3;
                }
                else SendServerMessage(playerid, "You don't have 10 wood(s) or/and 5 plastic(s).");
                if(modelid == 3260 && pData[playerid][inv][2] >= 5 && pData[playerid][inv][3] >= 2)
				{
                    pData[playerid][inv][2] -= 5;
					pData[playerid][inv][3] -= 2;
                    pData[playerid][clanexp][0] += 3;
                }
                else SendServerMessage(playerid, "You don't have 5 woods(s) or/and 2 metal(s).");
                if(modelid == 3302 && pData[playerid][inv][3] >= 6)
				{
					pData[playerid][inv][3] -= 6;
                    pData[playerid][clanexp][0] += 4;
                }
                else SendServerMessage(playerid, "You don't have 6 metal(s).");
                if(modelid == 19865 && pData[playerid][inv][2] >= 25 && pData[playerid][inv][3] >= 5)
				{
                    pData[playerid][inv][2] -= 25;
					pData[playerid][inv][3] -= 5;
                    pData[playerid][clanexp][0] += 10;
                }
                else SendServerMessage(playerid, "You don't have 25 woods(s) or/and 5 metal(s).");
                if(modelid == 1446 && pData[playerid][inv][2] >= 20 && pData[playerid][inv][3] >= 3)
				{
                    pData[playerid][inv][2] -= 20;
					pData[playerid][inv][3] -= 3;
                    pData[playerid][clanexp][0] += 8;
                }
                else SendServerMessage(playerid, "You don't have 20 woods(s) or/and 3 metal(s).");
                if(modelid == 18259 && pData[playerid][inv][2] >= 100 && pData[playerid][inv][3] >= 100)
				{
                    pData[playerid][inv][2] -= 100;
					pData[playerid][inv][3] -= 100;
                    pData[playerid][clanexp][0] += 150;
                }
                else SendServerMessage(playerid, "You don't have 100 woods(s) or/and 100 metal(s).");
                if(modelid == 19339 && pData[playerid][inv][2] >= 10 && pData[playerid][inv][3] >= 10)
				{
                    pData[playerid][inv][2] -= 10;
					pData[playerid][inv][3] -= 10;
                    pData[playerid][clanexp][0] += 10;
                }
                else SendServerMessage(playerid, "You don't have 10 woods(s) or/and 10 metal(s).");
                if(modelid == 1410 && pData[playerid][inv][2] >= 15 && pData[playerid][inv][3] >= 3)
				{
                    pData[playerid][inv][2] -= 15;
					pData[playerid][inv][3] -= 3;
                    pData[playerid][clanexp][0] += 11;
                }
                else SendServerMessage(playerid, "You don't have 15 woods(s) or/and 3 metal(s).");
                if(modelid == 2991 && pData[playerid][inv][2] >= 50)
				{
					pData[playerid][inv][2] -= 50;
                    pData[playerid][clanexp][0] += 50;
                }
                else SendServerMessage(playerid, "You don't have 50 wood(s).");
                if(modelid == 2319 && pData[playerid][inv][3] >= 10 && pData[playerid][inv][4] >= 10)
				{
					pData[playerid][inv][3] -= 10;
                    pData[playerid][inv][4] -= 10;
                    pData[playerid][clanexp][0] += 20;
                }
                else SendServerMessage(playerid, "You don't have 10 metal(s). or/and 10 cloth(s)");
                objectsData[i][objectsModel] = modelid;
                objectsData[i][objectsPos][0] = x + (3.0 * floatsin(-angle, degrees));
                objectsData[i][objectsPos][1] = y + (3.0 * floatcos(-angle, degrees));
                objectsData[i][objectsPos][2] = z;
                objectsData[i][objectsPos][3] = 0.0;
                objectsData[i][objectsPos][4] = 0.0;
                objectsData[i][objectsPos][5] = angle;
                objectsData[i][objectsInterior] = GetPlayerInterior(playerid);
                objectsData[i][objectsWorld] = GetPlayerVirtualWorld(playerid);
                objectsData[i][objectsOb] = CreateDynamicObject(objectsData[i][objectsModel], objectsData[i][objectsPos][0], objectsData[i][objectsPos][1], objectsData[i][objectsPos][2], objectsData[i][objectsPos][3], objectsData[i][objectsPos][4], objectsData[i][objectsPos][5], objectsData[i][objectsWorld], objectsData[i][objectsInterior]);
                ResetEditing(playerid);
                pData[playerid][pEditobjects] = i;
                EditDynamicObject(playerid, objectsData[i][objectsOb]);
                pData[playerid][Water] -= random(5)+1;
                pData[playerid][Food] -= random(5)+1;
                SendServerMessage(playerid, "You have created an barricade with (ID: %d.)", i);
                mysql_format(mysql, query, sizeof(query),"INSERT INTO `objects` (`objectsModel`) VALUES(%d)",modelid);
                mysql_tquery(mysql, query, "OnobjectsCreated", "i", i);
                return i;
            }
        }
        //do stuff here
	}
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(pData[playerid][Admin] <= 1) return 0;
    SetPlayerPos(playerid,fX,fY,fZ);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    return 1;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	SendServerMessage(playerid,"You clicked on this player %s",Name[clickedplayerid]);
	AdminTarget[playerid] = clickedplayerid;
	Dialog_Show(playerid,InfomationClickedPlayer,DIALOG_STYLE_LIST,"Action you can perfom","","Ok","");
	return 1;
}
public OnPlayerSelectedMenuRow(playerid, row)
{
    new Menu:PlayerMenu = GetPlayerMenu(playerid);
	if(PlayerMenu == Armory) {
        HideMenuForPlayer(Armory, playerid);
        switch(row)
        {
            case 0 :   //inv 15 00 buck
            {
				if (pData[playerid][inv][8] >= 1)
				{
                    if (pData[playerid][inv][15] + 1 > GetBackpackCapacity(playerid))
                    {
                        SendServerMessage(playerid, "Not enough backpack space for this item.");
                        ShowMenuForPlayer(Armory, playerid);
                        return 1;
                    }
                    pData[playerid][inv][15] += 1;
                    pData[playerid][inv][8] -= 1;
                    SendServerMessage(playerid, "Thanks for the purchase meat bag.");
                }
                else SendServerMessage(playerid, "You don't have 1 iron.");
                ShowMenuForPlayer(Armory, playerid);
            }
            case 1 :
            {
				if (pData[playerid][inv][8] >= 5)
				{
                    if (pData[playerid][inv][15] + 5 > GetBackpackCapacity(playerid))
                    {
                        SendServerMessage(playerid, "Not enough backpack space for this item.");
                        ShowMenuForPlayer(Armory, playerid);
                        return 1;
                    }
                    pData[playerid][inv][15] += 5;
                    pData[playerid][inv][8] -= 5;
                    SendServerMessage(playerid, "Thanks for the purchase meat bag.");
                }
                else SendServerMessage(playerid, "You don't have 5 irons.");
                ShowMenuForPlayer(Armory, playerid);
            }
            case 2 :
            {
				if (pData[playerid][inv][8] >= 10)
				{
                    if (pData[playerid][inv][15] + 10 > GetBackpackCapacity(playerid))
                    {
                        SendServerMessage(playerid, "Not enough backpack space for this item.");
                        ShowMenuForPlayer(Armory, playerid);
                        return 1;
                    }
                    pData[playerid][inv][15] += 10;
                    pData[playerid][inv][8] -= 10;
                    SendServerMessage(playerid, "Thanks for the purchase meat bag.");
                }
                else SendServerMessage(playerid, "You don't have 10 irons.");
                ShowMenuForPlayer(Armory, playerid);
            }
            case 3 :
            {
				if (pData[playerid][inv][9] >= 2)
				{
                    pData[playerid][inv][9] -= 2;
                    GivePlayerWeapon(playerid,25,random(2)+1);
                    GiveWeaponWithReplace(playerid,25,random(2)+1);
                    SendServerMessage(playerid, "Thanks for the purchase meat bag.");
                }
                else SendServerMessage(playerid, "You don't have 2 golds.");
                ShowMenuForPlayer(Armory, playerid);
            }
            case 4 :
            {
				if (pData[playerid][inv][9] >= 3)
				{
                    pData[playerid][inv][9] -= 3;
                    GivePlayerWeapon(playerid,26,random(3)+1);
                    SendServerMessage(playerid, "Thanks for the purchase meat bag.");
                }
                else SendServerMessage(playerid, "You don't have 3 golds.");
                ShowMenuForPlayer(Armory, playerid);
            }
            case 5 :
            {
                HideMenuForPlayer(Armory, playerid);
                TogglePlayerControllable(playerid, 1);
            }
        }
        AllowWeapon(playerid, 25,2);
        AllowWeapon(playerid, 26,3);
	}
	if(PlayerMenu == PoliceArmory) {
        HideMenuForPlayer(PoliceArmory, playerid);
        switch(row)
        {
            case 0 :   //inv 15 00 buck
            {
				if (pData[playerid][inv][4] >= 10)
				{
                    ShowModelSelectionMenu(playerid, "Select your new clothes", MODEL_SELECTION_POLICE, Skinspolice, sizeof(Skinspolice), -16.0, 0.0, -55.0);
                    pData[playerid][inv][4] -= 10;
                    SendServerMessage(playerid, "Thanks for the purchase civilian");
                }
                else SendServerMessage(playerid, "You don't have 10 cloths.");
                ShowMenuForPlayer(PoliceArmory, playerid);
            }
            case 1 :
            {
				if (pData[playerid][inv][8] >= 5)
				{
                    if (pData[playerid][inv][19] + 4 > GetBackpackCapacity(playerid))
                    {
                        SendServerMessage(playerid, "Not enough backpack space for this item.");
                        ShowMenuForPlayer(PoliceArmory, playerid);
                        return 1;
                    }
                    pData[playerid][inv][19] += 4;
                    pData[playerid][inv][8] -= 5;
                    SendServerMessage(playerid, "Thanks for the purchase civilian");
                }
                else SendServerMessage(playerid, "You don't have 5 irons.");
                ShowMenuForPlayer(PoliceArmory, playerid);
            }
            case 2 :
            {
				if (pData[playerid][inv][8] >= 3)
				{
                    if (pData[playerid][inv][15] + 1 > GetBackpackCapacity(playerid))
                    {
                        SendServerMessage(playerid, "Not enough backpack space for this item.");
                        ShowMenuForPlayer(PoliceArmory, playerid);
                        return 1;
                    }
                    pData[playerid][inv][18] += 1;
                    pData[playerid][inv][8] -= 3;
                    SendServerMessage(playerid, "Thanks for the purchase civilian");
                }
                else SendServerMessage(playerid, "You don't have 3 irons.");
                ShowMenuForPlayer(PoliceArmory, playerid);
            }
            case 3 :
            {
				if (pData[playerid][inv][8] >= 3)
				{
                    if (pData[playerid][inv][14] + 5 > GetBackpackCapacity(playerid))
                    {
                        SendServerMessage(playerid, "Not enough backpack space for this item.");
                        ShowMenuForPlayer(PoliceArmory, playerid);
                        return 1;
                    }
                    pData[playerid][inv][14] += 5;
                    pData[playerid][inv][8] -= 3;
                    SendServerMessage(playerid, "Thanks for the purchase civilian");
                }
                else SendServerMessage(playerid, "You don't have 3 irons.");
                ShowMenuForPlayer(PoliceArmory, playerid);
            }
            case 4 :
            {
				if (pData[playerid][inv][8] >= 10)
				{
                    if (pData[playerid][inv][14] + 10 > GetBackpackCapacity(playerid))
                    {
                        SendServerMessage(playerid, "Not enough backpack space for this item.");
                        ShowMenuForPlayer(PoliceArmory, playerid);
                        return 1;
                    }
                    pData[playerid][inv][14] += 10;
                    pData[playerid][inv][8] -= 10;
                    SendServerMessage(playerid, "Thanks for the purchase civilian");
                }
                else SendServerMessage(playerid, "You don't have 10 irons.");
                ShowMenuForPlayer(PoliceArmory, playerid);
            }
            case 5 :
            {
				if (pData[playerid][inv][9] >= 5)
				{
                    pData[playerid][inv][9] -= 5;
                    GivePlayerWeapon(playerid,22,1);
                    SendServerMessage(playerid, "Thanks for the purchase civilian");
                }
                else SendServerMessage(playerid, "You don't have 5 golds.");
                ShowMenuForPlayer(PoliceArmory, playerid);
            }
            case 6 :
            {
                HideMenuForPlayer(PoliceArmory, playerid);
                TogglePlayerControllable(playerid, 1);
            }
        }
        AllowWeapon(playerid, 22,2);
	}
    return 1;
}
public OnPlayerExitedMenu(playerid)
{
	new Menu:Current = GetPlayerMenu(playerid);
	if(!IsValidMenu(Current)) return 1;
	ShowMenuForPlayer(Current, playerid);
	return 1;
}
AntiDeAMX()
{
	new b;
	#emit load.s.pri b
	#emit stor.s.pri b
	#emit load.alt b
	#emit stor.alt b
	#emit load.s.alt b
	#emit stor.s.alt b
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}

    /*    if(!IsABoat(vehicleid) || !IsAPlane(vehicleid) || !IsAHelicopter(vehicleid) || !IsABike(vehicleid) || !IsAVelo(vehicleid))
		{
			if(GetVehicleSpeed(GetPlayerVehicleID(playerid)) > 230)
			{
				new Float:x, Float:y, Float:z;
                GetPlayerPos(playerid, x, y, z);
                SetPlayerPos(playerid, x, y, z+5);
                SendErrorMessage(playerid,"Suspicion de SpeedHack");
				KickEx(playerid);
				return 1;
			}
        }
        if(IsABike(vehicleid) || IsAVelo(vehicleid))
		{
			if(GetVehicleSpeed(GetPlayerVehicleID(playerid)) > 200)
			{
				new Float:x, Float:y, Float:z;
                GetPlayerPos(playerid, x, y, z);
                SetPlayerPos(playerid, x, y, z+5);
                SendErrorMessage(playerid,"Suspicion de SpeedHack");
				KickEx(playerid);
				return 1;
			}
        }    */



