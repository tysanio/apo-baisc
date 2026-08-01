ini_GetValue(szParse[], szValueName[], szDest[], iDestLen) { // brian!!1

	new iPos = strfind(szParse, "=", false),iLength = strlen(szParse);	
	while(iLength-- && szParse[iLength] <= ' ') {
		szParse[iLength] = 0;
	}
	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		strmid(szDest, szParse, iPos + 1, iLength + 1, iDestLen);
		return 1;
	}
	return 0;
}
stock mysql_Init()
{
	new host[64], db[64], user[32], pass[128];
	new fileString[128], File: fileHandle = fopen("mysql.cfg", io_read);
	while(fread(fileHandle, fileString, sizeof(fileString))) {
		if(ini_GetValue(fileString, "HOST", host, sizeof(host))) continue;
		if(ini_GetValue(fileString, "DB", db, sizeof(db))) continue;
		if(ini_GetValue(fileString, "USER", user, sizeof(user))) continue;
		if(ini_GetValue(fileString, "PASS", pass, sizeof(pass))) continue;
		if(ini_GetValue(fileString, "Dadmin1", Dadmin1, sizeof(Dadmin1))) continue;
		if(ini_GetValue(fileString, "Dverifier", Dverifier, sizeof(Dverifier))) continue;
		if(ini_GetValue(fileString, "DLeader", DLeader, sizeof(DLeader))) continue;
		if(ini_GetValue(fileString, "DMember", DMember, sizeof(DMember))) continue;
		if(ini_GetValue(fileString, "Ddiscord", Ddiscord, sizeof(Ddiscord))) continue;
		if(ini_GetValue(fileString, "Dchat", Dchat, sizeof(Dchat))) continue;
		if(ini_GetValue(fileString, "Achat", Achat, sizeof(Achat))) continue;
		if(ini_GetValue(fileString, "ooc", ooc, sizeof(ooc))) continue;
	}
	fclose(fileHandle);
	mysql = mysql_connect(host, user, db, pass);
	if(mysql_errno(mysql) != 0) 
	{ 
		printf("[MySQL] (mysql) Fatal Error! Could not connect to MySQL: Host %s - DB: %s - User: %s", host, db, user);
		printf("[MySQL] Error number: %d", mysql_errno(mysql));
	}
	else {printf("Successfully connected on DB %s",db);}
	mysql_log(LOG_ALL);
}
stock IsNearChest(playerid)
{
	new id = clans[pData[playerid][idclan]][idclan];
	if (id == -1)
	    return 0;
	if (IsPlayerInRangeOfPoint(playerid, 3.0, clans[id][chestpos][0], clans[id][chestpos][1], clans[id][chestpos][2]))
	    return 1;
	return 0;
}
ClanEnter_Nearest(playerid, Float:radius = 1.5)
{
    for (new i = 0; i != MAX_CLANS; i ++) if (IsPlayerInRangeOfPoint(playerid, radius, clans[i][enterpos][0], clans[i][enterpos][1], clans[i][enterpos][2]))
	{
		if (GetPlayerInterior(playerid) == clans[i][enterinterior] && GetPlayerVirtualWorld(playerid) == clans[i][entervw])
			return i;
	}
	return -1;
}
ClanExit_Nearest(playerid, Float:radius = 1.5)
{
    for (new i = 0; i != MAX_CLANS; i ++) if (IsPlayerInRangeOfPoint(playerid, radius, clans[i][exitpos][0], clans[i][exitpos][1], clans[i][exitpos][2]))
	{
		if (GetPlayerInterior(playerid) == clans[i][exitinterior] && GetPlayerVirtualWorld(playerid) == clans[i][exitvw])
			return i;
	}
	return -1;
}
stock GetClanByID(sqlid)
{
	for (new i = 0; i != MAX_CLANS; i ++) if (clans[i][clanexists] && clans[i][idclan] == sqlid)
	    return i;

	return -1;
}
//clan ressource
stock ConvertZoneResource(playerid, resourceIndex, give, take)
{
	new idd = pData[playerid][idclan];
	new id = clans[pData[playerid][idclan]][idclan];
	for (new i = 0; i < TotalGZ; i++)
	{
		if (IsPlayerInZone(playerid, GangZones[i][gMinX], GangZones[i][gMinY], GangZones[i][gMaxX], GangZones[i][gMaxY]))
		{
			if (GangZones[i][gTeamID] != idd) return SendServerMessage(playerid, "This zone does not belong to your clan.");
			if (GangZones[i][gressources] <= take) return SendServerMessage(playerid, "Not enough resources in this zone.");
			if (clans[id][inv][resourceIndex] + take > GetClanCapacity(id)) return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			clans[id][inv][resourceIndex] += give;
			GangZones[i][gressources] -= take;
			SendServerMessage(playerid,"Ressources converted!"); 
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv%d` = '%d' WHERE `idclan` = '%d'",resourceIndex, clans[id][inv][resourceIndex], clans[id][idclan]);
			mysql_tquery(mysql, query);
			mysql_format(mysql, query, sizeof(query), "UPDATE gang_zones SET ressources = %d WHERE id = %d",GangZones[i][gressources],GangZones[i][gID]);
			mysql_tquery(mysql, query);
			cmd_clanres(playerid, "");
		}
	}
	return 1;
}
stock SetPlayerPosEx(playerid, Float:x, Float:y, Float:z, time = 1500)
{
	if (pData[playerid][pFreeze])
	{
	    KillTimer(pData[playerid][pFreezeTimer]);
	    pData[playerid][pFreeze] = 0;
	    TogglePlayerControllable(playerid, 1);
	}
	SetPlayerPos(playerid, x, y, z + 0.5);
	TogglePlayerControllable(playerid, 0);
	pData[playerid][pFreeze] = 1;
	pData[playerid][pFreezeTimer] = SetTimerEx("SetPlayerToUnfreeze", time, false, "dfff", playerid, x, y, z);
	return 1;
}
stock bool:IsMeleeWeapon(weaponid)
{
    return (weaponid >= 0 && weaponid <= 9);
}
stock ResetAllowedWeapons(playerid)
{
    for (new i = 0; i < MAX_WEAPONS; i++)
    {
        AllowedWeapons[playerid][i] = 0;
        AllowedAmmo[playerid][i] = 0;
    }
}
stock AllowWeapon(playerid, weaponid, ammo)
{
    for (new i = 0; i < MAX_WEAPONS; i++)
    {
        if (AllowedWeapons[playerid][i] == 0)
        {
            AllowedWeapons[playerid][i] = weaponid;
            AllowedAmmo[playerid][i] = ammo;
            return;
        }
    }
}
stock CheckPlayerWeapons(playerid)
{
    new weapon = GetPlayerWeapon(playerid);
    if (weapon == 0 || IsMeleeWeapon(weapon)) return;

    new ammo = GetPlayerAmmo(playerid),bool:found = false;

    for (new i = 0; i < MAX_WEAPONS; i++)
    {
        if (AllowedWeapons[playerid][i] == weapon)
        {
            if (ammo <= AllowedAmmo[playerid][i] + 500)
            {
                found = true;
                break;
            }
        }
    }
    if (!found)
    {
        new name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, sizeof(name));
        printf("[ANTI-CHEAT] %s has illegal weapon or ammo: %d (ammo: %d)", name, weapon, ammo);
        SendServerMessage(playerid,"Kicked: Illegal weapon or ammo detected.");
        ResetAllowedWeapons(playerid);
        KickEx(playerid);
    }
}
stock LoadWeaponDrops()
{
    new Cache:result = mysql_query(mysql, "SELECT * FROM weapon_drops"),rows = cache_num_rows(),weaponid, ammo,string[48],Float:x, Float:y, Float:z;
    for (new i = 0; i < rows; i++)
    {
        cache_get_row(i,1, string); weaponid = strval(string);
        cache_get_row(i,2, string); ammo = strval(string);
        cache_get_row(i,3, string); x = strval(string);
        cache_get_row(i,4, string); y = strval(string);
        cache_get_row(i,5, string); z = strval(string);
    	dGunData[i][ObjData][0] = weaponid;
		dGunData[i][ObjData][1] = ammo;
		dGunData[i][ObjPos][0] = x;
		dGunData[i][ObjPos][1] = y;
		dGunData[i][ObjPos][2] = z;
		dGunData[i][ObjID] = CreateObject(GunObjects[weaponid], x, y, z-0.85, 93.7, 120.0, random(360));
    }
    cache_delete(result);
}
stock CreateDroppedGun(GunID, GunAmmo, Float:gPosX, Float:gPosY, Float:gPosZ)//a refaire
{
	new f = MAX_OBJ+1;
    for(new a = 0; a < MAX_OBJ; a++)
    {
        if(dGunData[a][ObjPos][0] == 0.0)
        {
            f = a;
            break;
        }
    }
    if(f > MAX_OBJ) return;
    dGunData[f][ObjData][0] = GunID;
	dGunData[f][ObjData][1] = GunAmmo;
	dGunData[f][ObjPos][0] = gPosX;
	dGunData[f][ObjPos][1] = gPosY;
	dGunData[f][ObjPos][2] = gPosZ;
	dGunData[f][ObjID] = CreateObject(GunObjects[GunID], gPosX, gPosY, gPosZ-1, 93.7, 120.0, random(360));
	format(query, sizeof(query),"INSERT INTO weapon_drops (weaponid, ammo, pos_x, pos_y, pos_z) VALUES (%d, %d, %f, %f, %f)",
	GunID,GunAmmo,gPosX,gPosY,gPosZ);
    mysql_tquery(mysql, query,"","");
	return;
}
stock RemovePlayerWeapon(playerid, weaponid)
{
	new plyWeapons[12] = 0,plyAmmo[12] = 0,wep, ammo;
	for(new sslot = 0; sslot != 12; sslot++)
	{
		GetPlayerWeaponData(playerid, sslot, wep, ammo);
		if(wep != weaponid && ammo != 0) GetPlayerWeaponData(playerid, sslot, plyWeapons[sslot], plyAmmo[sslot]);
	}
	ResetPlayerWeapons(playerid);
	for(new sslot = 0; sslot != 12; sslot++) if(plyAmmo[sslot] != 0) GivePlayerWeapon(playerid, plyWeapons[sslot], plyAmmo[sslot]);
	return 1;
}
stock GetName(playerid)
{
	new PlayerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	return PlayerName;
}
stock AnimationCheck(playerid) {return (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT);}
stock ApplyAnimationEx(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
	ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
	return 1;
}
stock SQL_ReturnEscaped(const string[])
{
	new entry[256];
	mysql_real_escape_string(string, entry, mysql);
	return entry;
}
stock GetDistance(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2) {return floatround(floatsqroot(((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)) + ((z1 - z2) * (z1 - z2))));}
stock IsAVelo(vehicleid)
{
	switch (GetVehicleModel(vehicleid)) {
		case 481, 509, 510,6677,6678,25500,25501,25502,25503,25504,25505,25506,25507,25508,25509,25510: return 1;
	}
	return 0;
}
stock Float:frandom(Float:max, Float:m2 = 0.0, dp = 3)
{
    new Float:mn = m2;
    if(m2 > max) {
        mn = max,
        max = m2;
    }
    m2 = floatpower(10.0, dp); 
    return floatadd(floatdiv(float(random(floatround(floatmul(floatsub(max, mn), m2)))), m2), mn);
}
stock IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	static Float:fX,Float:fY,Float:fZ;
	GetPlayerPos(targetid, fX, fY, fZ);
	return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}
Entrance_Delete(entranceid)
{
	if (entranceid != -1 && EntranceData[entranceid][entranceExists])
	{
	    new string[64];
		format(string, sizeof(string), "DELETE FROM `entrances` WHERE `entranceID` = '%d'", EntranceData[entranceid][entranceID]);
		mysql_tquery(mysql, string);
        if (IsValidDynamic3DTextLabel(EntranceData[entranceid][entranceText3D]))
		    DestroyDynamic3DTextLabel(EntranceData[entranceid][entranceText3D]);
		if (IsValidDynamicPickup(EntranceData[entranceid][entrancePickup]))
		    DestroyDynamicPickup(EntranceData[entranceid][entrancePickup]);
	    EntranceData[entranceid][entranceExists] = false;
	    EntranceData[entranceid][entranceID] = 0;
	}
	return 1;
}
Entrance_Save(entranceid)
{
	format(query, sizeof(query), "UPDATE `entrances` SET `entranceName` = '%s',`entranceLocked` = '%d', `entrancePosX` = '%.4f', `entrancePosY` = '%.4f', `entrancePosZ` = '%.4f', `entrancePosA` = '%.4f', `entranceIntX` = '%.4f', `entranceIntY` = '%.4f', `entranceIntZ` = '%.4f', `entranceIntA` = '%.4f', `entranceInterior` = '%d', `entranceExterior` = '%d', `entranceExteriorVW` = '%d', `entranceWorld` = '%d'  WHERE `entranceID` = '%d'",
	    SQL_ReturnEscaped(EntranceData[entranceid][entranceName]),
	    EntranceData[entranceid][entranceLocked],
	    EntranceData[entranceid][entrancePos][0],
	    EntranceData[entranceid][entrancePos][1],
	    EntranceData[entranceid][entrancePos][2],
	    EntranceData[entranceid][entrancePos][3],
	    EntranceData[entranceid][entranceInt][0],
	    EntranceData[entranceid][entranceInt][1],
	    EntranceData[entranceid][entranceInt][2],
	    EntranceData[entranceid][entranceInt][3],
	    EntranceData[entranceid][entranceInterior],
	    EntranceData[entranceid][entranceExterior],
	    EntranceData[entranceid][entranceExteriorVW],
	    EntranceData[entranceid][entranceWorld],
	    EntranceData[entranceid][entranceID]
	);
	return mysql_tquery(mysql, query);
}
Entrance_Nearest(playerid)
{
    for (new i = 0; i != MAX_OBJECTSC; i ++) if (EntranceData[i][entranceExists] && IsPlayerInRangeOfPoint(playerid, 1.5, EntranceData[i][entrancePos][0], EntranceData[i][entrancePos][1], EntranceData[i][entrancePos][2]))
	{
		if (GetPlayerInterior(playerid) == EntranceData[i][entranceExterior] && GetPlayerVirtualWorld(playerid) == EntranceData[i][entranceExteriorVW])
			return i;
	}
	return -1;
}
EntranceExit_Nearest(playerid)
{
    for (new i = 0; i != MAX_OBJECTSC; i ++) if (EntranceData[i][entranceExists] && IsPlayerInRangeOfPoint(playerid, 1.5, EntranceData[i][entranceInt][0], EntranceData[i][entranceInt][1], EntranceData[i][entranceInt][2]))
	{
		if (GetPlayerInterior(playerid) == EntranceData[i][entranceInterior] && GetPlayerVirtualWorld(playerid) == EntranceData[i][entranceWorld])
			return i;
	}
	return -1;
}
Entrance_Refresh(entranceid)
{
	if (entranceid != -1 && EntranceData[entranceid][entranceExists])
	{
		if (IsValidDynamicPickup(EntranceData[entranceid][entrancePickup]))
		    DestroyDynamicPickup(EntranceData[entranceid][entrancePickup]);
		EntranceData[entranceid][entranceText3D] = CreateDynamic3DTextLabel(EntranceData[entranceid][entranceName], COLOR_BLUE, EntranceData[entranceid][entrancePos][0], EntranceData[entranceid][entrancePos][1], EntranceData[entranceid][entrancePos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, EntranceData[entranceid][entranceExteriorVW], EntranceData[entranceid][entranceExterior]);
        EntranceData[entranceid][entrancePickup] = CreateDynamicPickup(1559, 23, EntranceData[entranceid][entrancePos][0], EntranceData[entranceid][entrancePos][1], EntranceData[entranceid][entrancePos][2] + 0.7, EntranceData[entranceid][entranceExteriorVW], EntranceData[entranceid][entranceExterior]);
	}
	return 1;
}
Entrance_Create(playerid, name[])
{
	static Float:x,Float:y,Float:z,Float:angle;
    if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i != MAX_OBJECTSC; i ++)
		{
	    	if (!EntranceData[i][entranceExists])
		    {
    	        EntranceData[i][entranceExists] = true;
        	    EntranceData[i][entranceLocked] = 0;
				format(EntranceData[i][entranceName], 32, name);
    	        EntranceData[i][entrancePos][0] = x;
    	        EntranceData[i][entrancePos][1] = y;
    	        EntranceData[i][entrancePos][2] = z;
    	        EntranceData[i][entrancePos][3] = angle;
                EntranceData[i][entranceInt][0] = x;
                EntranceData[i][entranceInt][1] = y;
                EntranceData[i][entranceInt][2] = z + 10000;
                EntranceData[i][entranceInt][3] = 0.0000;
				EntranceData[i][entranceInterior] = 0;
				EntranceData[i][entranceExterior] = GetPlayerInterior(playerid);
				EntranceData[i][entranceExteriorVW] = GetPlayerVirtualWorld(playerid);
				Entrance_Refresh(i);
				mysql_tquery(mysql, "INSERT INTO `entrances` (`entranceLocked`) VALUES(0)", "OnEntranceCreated", "d", i);
				return i;
			}
		}
	}
	return -1;
}
stock GetEntranceByID(sqlid)
{
	for (new i = 0; i != MAX_DYNAMIC_OBJ; i ++) if (EntranceData[i][entranceExists] && EntranceData[i][entranceID] == sqlid)
	    return i;

	return -1;
}
//backpack setting
stock GetBackpackCapacity(playerid)
{
    new backpackLevel = pData[playerid][Score] / 5;

    if (backpackLevel > 5)
        backpackLevel = 5;

    return 8 << backpackLevel; // 8,16,32,64,128,256
}
stock GetStorageCapacity(i)
{
    new storagesInv1 = storageData[i][storagesInv][0] / 5;

    if (storagesInv1 > 5)
        storagesInv1 = 5;

    return 10 << storagesInv1; // 10,20,40,80,160,320
}
stock GetClanCapacity(i)
{
    new ClanInv1 = clans[i][inv][0] / 5;

    if (ClanInv1 > 5)
        ClanInv1 = 5;

    return 100 << ClanInv1; // 100,200,400,800,1600,3200
}
//lockpick
stock StartLockpick(playerid, speed, pins, zone)
{
    if(Lockpick[playerid][lpActive]) return 0;
    Lockpick[playerid][lpActive] = true;
    Lockpick[playerid][lpStep] = 0;
    Lockpick[playerid][lpRequiredPins] = pins;
    Lockpick[playerid][lpZoneSize] = zone;
    Lockpick[playerid][lpSpeed] = speed;
    Lockpick[playerid][lpPos] = 0;
    Lockpick[playerid][lpDir] = 1;
    Lockpick[playerid][lpZoneStart] = random(14) + 3;
    Lockpick[playerid][lpZoneEnd] = Lockpick[playerid][lpZoneStart] + zone;
    Lockpick[playerid][lpTimer] = SetTimerEx("LockpickUpdate", speed, true, "d", playerid);
	SendServerMessage(playerid,"Lockpick started! Press ~k~~VEHICLE_ENTER_EXIT~ inside the zone.");
    return 1;
}
//change weapons
stock ReplaceWeapon(playerid, oldWeapon, newWeapon)
{
    new weapon, ammo,weapons[13], ammos[13];
    for(new slot = 0; slot < 13; slot++)
    {
        GetPlayerWeaponData(playerid, slot, weapon, ammo);
        weapons[slot] = weapon;
        ammos[slot] = ammo;
    }
    ResetPlayerWeapons(playerid);
    for(new slot = 0; slot < 13; slot++)
    {
        if(!weapons[slot] || ammos[slot] <= 0) continue;
		AllowWeapon(playerid, weapons[slot],ammos[slot]);
        if(weapons[slot] == oldWeapon) GivePlayerWeapon(playerid, newWeapon, ammos[slot]);
        else GivePlayerWeapon(playerid, weapons[slot], ammos[slot]);
    }

    return 1;
}
stock GiveWeaponWithReplace(playerid, weaponid, ammo)
{
    new current = GetPlayerWeapon(playerid);
    if(weaponid == 4 || weaponid == 3 || weaponid == 6)
    {
        if(current == 4 || current == 3 || current == 6)
        {
            if(current != weaponid)
            {
                ChangeWeaponOld[playerid] = current;
                ChangeWeaponNew[playerid] = weaponid;
                Dialog_Show(playerid,CHANGEWEAPON, DIALOG_STYLE_MSGBOX,"Replace Weapon","You already have a melee weapon.\n\nReplace it?\n(Current ammo will be kept.)","Yes","No");
                return 0;
            }
        }
    }
    if(weaponid == 22 || weaponid == 23 || weaponid == 24)
    {
        if(current == 22 || current == 23 || current == 24)
        {
            if(current != weaponid)
            {
                ChangeWeaponOld[playerid] = current;
                ChangeWeaponNew[playerid] = weaponid;
                Dialog_Show(playerid,CHANGEWEAPON, DIALOG_STYLE_MSGBOX,"Replace Weapon","You already have a pistol.\n\nReplace it?\n(Current ammo will be kept.)","Yes","No");
                return 0;
            }
        }
    }
    if(weaponid == 25 || weaponid == 26 || weaponid == 27)
    {
        if((current == 25 || current == 26 || current == 27) && current != weaponid)
        {
            ChangeWeaponOld[playerid] = current;
            ChangeWeaponNew[playerid] = weaponid;
            Dialog_Show(playerid,CHANGEWEAPON, DIALOG_STYLE_MSGBOX,"Replace Weapon","You already have a shotgun.\n\nReplace it?\n(Current ammo will be kept.)","Yes","No");
            return 0;
        }
    }
    if(weaponid == 33 || weaponid == 34)
    {
        if((current == 33 || current == 34) && current != weaponid)
        {
            ChangeWeaponOld[playerid] = current;
            ChangeWeaponNew[playerid] = weaponid;
            Dialog_Show(playerid,CHANGEWEAPON, DIALOG_STYLE_MSGBOX,"Replace Weapon","You already have a rifle.\n\nReplace it?\n(Current ammo will be kept.)","Yes","No");
            return 0;
        }
    }
    if(weaponid == 16 || weaponid == 18)
    {
        if((current == 16 || current == 18) && current != weaponid)
        {
            ChangeWeaponOld[playerid] = current;
            ChangeWeaponNew[playerid] = weaponid;
            Dialog_Show(playerid,CHANGEWEAPON, DIALOG_STYLE_MSGBOX,"Replace Weapon","You already have a throwable.\n\nReplace it?\n(Current ammo will be kept.)","Yes","No");
            return 0;
        }
    }
    // Doesn't have another weapons of the group
	AllowWeapon(playerid, weaponid,ammo);
    GivePlayerWeapon(playerid, weaponid, ammo);
    return 1;
}
//anetenna
stock SaveAntenna(id)
{
    mysql_format(mysql,query,sizeof(query),"UPDATE antennas SET health='%.2f',fuel='%d',powered='%d' WHERE id='%d'",
	Antenna[id][aHealth],
    Antenna[id][aFuel],
    Antenna[id][aPowered],
    Antenna[id][aSQLID]);
    mysql_tquery(mysql,query);
    return 1;
}
stock CreateAntennaVisual(id)
{
    if(!Antenna[id][aExists]) return 0;
    if(IsValidDynamic3DTextLabel(Antenna[id][aLabel])) DestroyDynamic3DTextLabel(Antenna[id][aLabel]);
    new string[128],status[16];
    if(Antenna[id][aPowered] == 1)  format(status, sizeof(status), "ONLINE");
    else format(status, sizeof(status), "OFFLINE");
    format(string, sizeof(string), "Radio Tower\nStatus: %s",status);
    Antenna[id][aLabel] = CreateDynamic3DTextLabel(string,0x00FF00FF,Antenna[id][aPosX],Antenna[id][aPosY],Antenna[id][aPosZ] + 2.0,15.0);
    return 1;
}
stock UpdateAntennaVisual(id)
{
    if(!Antenna[id][aExists]) return 0;
    if(IsValidDynamic3DTextLabel(Antenna[id][aLabel])) DestroyDynamic3DTextLabel(Antenna[id][aLabel]);
    new string[128],status[16];
    if(Antenna[id][aPowered] == 1)  format(status, sizeof(status), "ONLINE");
    else format(status, sizeof(status), "OFFLINE");
    format(string, sizeof(string), "Radio Tower\nStatus: %s",status);
    Antenna[id][aLabel] = CreateDynamic3DTextLabel(string,0x00FF00FF,Antenna[id][aPosX],Antenna[id][aPosY],Antenna[id][aPosZ] + 2.0,15.0);
    return 1;
}
stock GetNearestAntenna(playerid)
{
    new id=-1,Float:dist=999999.0,Float:px,Float:py,Float:pz;
    GetPlayerPos(playerid,px,py,pz);
    for(new i;i<MAX_ANTENNAS;i++)
    {
        if(!Antenna[i][aExists]) continue;

        new Float:d=GetPlayerDistanceFromPoint(playerid,Antenna[i][aPosX],Antenna[i][aPosY],Antenna[i][aPosZ]);
        if(d<dist)
        {
            dist=d;
            id=i;
        }
    }
    return id;
}
stock CorruptRadioMessage(text[], quality)
{
    new len = strlen(text);
    switch(quality)
    {
        case SIGNAL_PERFECT: return 1;
        case SIGNAL_GOOD: { for(new i=0;i<len;i++)  if(random(18)==0) text[i]='-'; }
        case SIGNAL_MEDIUM: {for(new i=0;i<len;i++) if(random(6)==0) text[i]='-';}
        case SIGNAL_POOR: {for(new i=0;i<len;i++) if(random(2)==0) text[i]='-';}
    }
    return 1;
}
stock GetSignalQuality(playerid)
{
    new antenna = GetNearestAntenna(playerid),Float:health = Antenna[antenna][aHealth];
    if(antenna == -1) return SIGNAL_NONE;
    if(!Antenna[antenna][aPowered]) return SIGNAL_NONE;
    if(Antenna[antenna][aHealth] <= 0.0) return SIGNAL_NONE;
    new Float:distance = GetPlayerDistanceFromPoint(playerid,Antenna[antenna][aPosX],Antenna[antenna][aPosY],Antenna[antenna][aPosZ]);
	
    if(distance > Antenna[antenna][aRange]) return SIGNAL_NONE;
    if(health <= 20) return SIGNAL_POOR;
    if(health <= 45) return SIGNAL_MEDIUM;
    if(health <= 75) return SIGNAL_GOOD;

    return SIGNAL_PERFECT;
}
stock IsAntennaWorking(id)
{
    if(id < 0 || id >= MAX_ANTENNAS) return 0;
    if(!Antenna[id][aExists]) return 0;
    if(!Antenna[id][aPowered]) return 0;
    if(Antenna[id][aHealth] <= 0.0) return 0;
    if(Antenna[id][aFuel] <= 0) return 0;
    return 1;
}
stock GetNearestWorkingAntenna(playerid)
{
    new antenna = -1;
    new Float:best = 999999.0;
    for(new i; i < MAX_ANTENNAS; i++)
    {
        if(!IsAntennaWorking(i)) continue;
        new Float:d =  GetPlayerDistanceFromPoint(playerid,Antenna[i][aPosX],Antenna[i][aPosY], Antenna[i][aPosZ]);
        if(d < best)
        {
            best = d;
            antenna = i;
			SendRadioMessage(playerid, "Health: %.2f",Antenna[i][aHealth]);
			SendRadioMessage(playerid, "Range: %.0fm",Antenna[i][aRange]);
			SendRadioMessage(playerid, "Fuel: %d",Antenna[i][aFuel]);
        }
    }
    return antenna;
}
stock CanRelayTo(from,to)
{
    if(!IsAntennaWorking(from)) return 0;
    if(!IsAntennaWorking(to)) return 0;
    new Float:distance =
        floatsqroot(floatpower(Antenna[from][aPosX]-Antenna[to][aPosX],2.0)+ floatpower(Antenna[from][aPosY]-Antenna[to][aPosY],2.0)+ floatpower(Antenna[from][aPosZ]-Antenna[to][aPosZ],2.0));
    if(distance <= Antenna[from][aRange])return 1;
    return 0;
}
stock RadioCanReach(sender,receiver)
{
    new a1 = GetNearestWorkingAntenna(sender);
    new a2 = GetNearestWorkingAntenna(receiver);
    if(a1 == -1) return 0;
    if(a2 == -1) return 0;
    if(a1 == a2) return 1;
    if(CanRelayTo(a1,a2)) return 1;

    for(new i; i < MAX_ANTENNAS; i++)
    {
        if(!IsAntennaWorking(i))  continue;
        if(CanRelayTo(a1,i) && CanRelayTo(i,a2)) return 1;
    }
    return 0;
}
stock GetLowestHealthAntenna()
{
    new id = -1,Float:lowest = 101.0;
    for(new i; i < MAX_ANTENNAS; i++)
    {
        if(!Antenna[i][aExists]) continue;
        if(!Antenna[i][aPowered]) continue;
        if(Antenna[i][aHealth] >= 100.0) continue;
        if(Antenna[i][aHealth] < lowest)
        {
            lowest = Antenna[i][aHealth];
            id = i;
        }
    }
    return id;
}
stock GetHighestHealthAntenna()
{
    new id = -1,Float:highest = -1.0;
    for(new i; i < MAX_ANTENNAS; i++)
    {
        if(!Antenna[i][aExists]) continue;
        if(!Antenna[i][aPowered]) continue;
        if(Antenna[i][aHealth] > highest)
        {
            highest = Antenna[i][aHealth];
            id = i;
        }
    }
    return id;
}
stock SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
	static args,str[144];
	if ((args = numargs()) == 3)
	{
	    SendClientMessage(playerid, color, text);
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return 1;
}
stock SendNearbyMessage(playerid, Float:radius, color, const str[], {Float,_}:...)
{
	static args,start,end,string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args
	if (args > 16)
	{
		#emit ADDR.pri str
		#emit STOR.pri start
	    for (end = start + (args - 16); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit LOAD.S.pri 8
		#emit CONST.alt 4
		#emit SUB
		#emit PUSH.pri
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
        foreach (new i : Player)
		{
			if (IsPlayerNearPlayer(i, playerid, radius)) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (IsPlayerNearPlayer(i, playerid, radius)) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}
stock SendAdminAlert(color, const str[], {Float,_}:...)
{
	static args,start,end,string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args
	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start
	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
        foreach (new i : Player)
		{
			if (pData[i][Admin] >= 1){
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (pData[i][Admin] >= 1) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}
//plant
stock GetFreePlantSlot()
{
    for(new i; i < MAX_PLANTS; i++)
    {
        if(!Plant[i][plantExists])
            return i;
    }
    return -1;
}
stock GetNearestPlant(playerid)
{
    new id = -1,Float:dist = 99999.0;
    for(new i; i < MAX_PLANTS; i++)
    {
        if(!Plant[i][plantExists])  continue;
        new Float:d = GetPlayerDistanceFromPoint(playerid,  Plant[i][plantX],Plant[i][plantY],Plant[i][plantZ]);
        if(d < dist)
        {
            dist = d;
            id = i;
        }
    }
    return id;
}
stock IsNearAnotherPlant(Float:x,Float:y,Float:z)
{
    for(new i; i < MAX_PLANTS; i++)
    {
        if(!Plant[i][plantExists]) continue;
        if(GetDistance(x,y,z, Plant[i][plantX], Plant[i][plantY], Plant[i][plantZ]) < 3.0)
        {
            return 1;
        }
    }
    return 0;
}
stock GetPlantName(type)
{
    static name[16];
    switch(type)
    {
        case PLANT_POTATO: format(name,sizeof(name),"Potato");
        case PLANT_TOMATO: format(name,sizeof(name),"Tomato");
        default: format(name,sizeof(name),"Unknown");
    }
    return name;
}
stock IsPlantReady(id)
{
    if(gettime() - Plant[id][plantTime] >= PLANT_GROW_TIME)  return 1;
    return 0;
}
stock GetPlantRemaining(id)
{
    new remain = PLANT_GROW_TIME - (gettime() - Plant[id][plantTime]);
    if(remain < 0) remain = 0;
    return remain;
}
stock UpdatePlantLabel(id)
{
    if(!Plant[id][plantExists])
        return 0;
    if(IsValidDynamic3DTextLabel(Plant[id][plantLabel]))
        DestroyDynamic3DTextLabel(Plant[id][plantLabel]);
    new string[128];
    if(IsPlantReady(id))
    {
        format(string,sizeof(string),"%s Plant\n{00FF00}READY TO HARVEST", GetPlantName(Plant[id][plantType]));
    }
    else
    {
        new remain = GetPlantRemaining(id);
        format(string,sizeof(string),"%s Plant\nGrowing...\n%d hour(s)",GetPlantName(Plant[id][plantType]),remain / 3600);
    }
    Plant[id][plantLabel] =
    CreateDynamic3DTextLabel(string,-1,Plant[id][plantX], Plant[id][plantY],Plant[id][plantZ]+1.0,20.0);
    return 1;
}
stock GetPlantModel(type)
{
    switch(type)
    {
        case PLANT_POTATO: return 804;
        case PLANT_TOMATO: return 806;
    }
    return 806;
}
stock CreatePlant(id)
{
    Plant[id][plantObject] = CreateDynamicObject(GetPlantModel(Plant[id][plantType]),Plant[id][plantX],Plant[id][plantY], Plant[id][plantZ],0.0,0.0,random(360),Plant[id][plantVW],Plant[id][plantInterior]);
    UpdatePlantLabel(id);
    return 1;
}
stock DestroyPlant(id)
{
    if(!Plant[id][plantExists]) return 0;
    if(IsValidDynamicObject(Plant[id][plantObject])) DestroyDynamicObject(Plant[id][plantObject]);
    if(IsValidDynamic3DTextLabel(Plant[id][plantLabel])) DestroyDynamic3DTextLabel(Plant[id][plantLabel]);
    Plant[id][plantExists] = false;
    Plant[id][plantSQLID] = 0;
    Plant[id][plantOwner] = 0;
    Plant[id][plantType] = 0;
    return 1;
}