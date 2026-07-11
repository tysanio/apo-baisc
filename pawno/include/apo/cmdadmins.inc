CMD:ahelp(playerid, params[])
{
    if(!pData[playerid][Admin]) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    SendServerMessage(playerid, "---List of commands admins  for this server---");
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "/kick, /mute, /unmute, /freeze, /unfreeze /setskin, /sethp, /setarmor, /resetweapons");
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "/goto, /zoneinfo, /addpoint, /resetintvw");
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "/banperm, /bantemp, /unban, /banlist, /editveh, /editstation /stationlist");
    SendClientMessage(playerid, COLOR_LIGHTRED, "/createobject, /editobject, /delobject");
    SendClientMessage(playerid, COLOR_LIGHTRED, "/setvip /setscore, /createspawn, /createveh, /createentrance, /delentrance, /editentrance");
    SendClientMessage(playerid, COLOR_LIGHTRED, "/deleteveh, /createstation, /delstation, /gzcreate, /gzdelete, /gzreload");
    SendClientMessage(playerid, COLOR_PURPLE, "/setadmin, /flushpoint, /flushspawn, /resetplayer");
    return 1;
}
//admin 1
CMD:kick(playerid, params[])
{
    new targetid, reason[64],lookupid;
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    if(sscanf(params, "us[64]", targetid, reason))
        return SendCommandMessage(playerid, "Usage: /kick <player> <reason>");
    SendAdminAlert(COLOR_LIGHTRED, "Admin %s has kick %s. Reason: %s", GetName(playerid), GetName(lookupid), reason);
    KickEx(targetid);
    return 1;
}
CMD:unfreeze(playerid, params[])
{
    new lookupid;
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    if(sscanf(params, "u", lookupid))
        return SendCommandMessage(playerid, "Usage: /freeze <player>");
    SendAdminAlert(COLOR_LIGHTRED, "Admin %s has unfreeze %s.", GetName(playerid), GetName(lookupid));
    TogglePlayerControllable(lookupid, 1);
    return 1;
}
CMD:freeze(playerid, params[])
{
    new lookupid;
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    if(sscanf(params, "u", lookupid))
        return SendCommandMessage(playerid, "Usage: /freeze <player>");
    SendAdminAlert(COLOR_LIGHTRED, "Admin %s has freeze %s.", GetName(playerid), GetName(lookupid));
    TogglePlayerControllable(lookupid, 0);
    return 1;
}
CMD:resetintvw(playerid, params[])
{
	new lookupid;
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	if(sscanf(params, "u",lookupid)) return SendCommandMessage(playerid, "Usage: /resetintvw <playerid/Name> ");
	if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid ,"Player is not connected");
	SendAdminAlert(COLOR_RED , "Admin %s (ID:%d) has reset %s (ID:%d) interior and virtual world to 0", GetName(playerid), playerid, GetName(lookupid),lookupid);
	SetPlayerInterior(lookupid,0);
	SetPlayerVirtualWorld(lookupid,0);
	return 1;
}
CMD:setskin(playerid, params[])
{
	new lookupid, amount;
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	if(sscanf(params, "ui",lookupid, amount)) return SendCommandMessage(playerid, "Usage: /setskin <playerid/Name> <id>");
	if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid ,"Player is not connected");
	SendAdminAlert(COLOR_RED , "Admin %s (ID:%d) has setted %s (ID:%d) skin to (%d)", GetName(playerid), playerid, GetName(lookupid),lookupid, amount);
	SetPlayerSkin(lookupid, amount);
	pData[lookupid][skin] = amount;
	return 1;
}
CMD:setarmor(playerid, params[])
{
	new lookupid, amount;
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	if(sscanf(params, "ui",lookupid, amount)) return SendCommandMessage(playerid, "Usage: /setarmor <playerid/Name> <amount>");
	if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid ,"Player is not connected");
	SendAdminAlert(COLOR_RED ,  "Admin %s (ID:%d) has setted %s (ID:%d) armor to (%d)", GetName(playerid), playerid, GetName(lookupid),lookupid, amount);
	SetPlayerArmour(lookupid, amount);
	pData[lookupid][Armor] = amount;
    if (amount >= 101.10) {SetPlayerArmour(lookupid, 100.0);}
	return 1;
}
CMD:sethp(playerid, params[])
{
	new lookupid, amount;
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	if(sscanf(params, "ui",lookupid, amount)) return SendCommandMessage(playerid, "Usage: /sethp <playerid/Name> <amount>");
	if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid ,"Player is not connected");
	SendAdminAlert(lookupid , "Admin %s (ID:%d) has setted %s (ID:%d) hp to (%d)", GetName(playerid), playerid, GetName(lookupid),lookupid, amount);
	SetPlayerHealth(lookupid, amount);
	pData[lookupid][Life] = amount;
    if (amount >= 101.10) {SetPlayerHealth(lookupid, 100.0);}
	return 1;
}
CMD:resetweapons(playerid, params[])
{
	new lookupid;
	if(pData[playerid][Admin] < 1)
	{
		if(sscanf(params, "u",lookupid)) return SendCommandMessage(playerid, "Usage: /resetweapons <playerid/Name> ");
		if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid ,"Player is not connected");
		SendServerMessage(playerid,"Player got they weapons reset.");
		SendServerMessage(lookupid,"You got your weapons reset.");
		ResetAllowedWeapons(lookupid);
		ResetPlayerWeapons(lookupid);
	}
    else return SendServerMessage(playerid, "Only admin 2+ can use this cmd");
	return 1;
}
CMD:mute(playerid, params[])
{
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	new id, mins;
	if(sscanf(params,"ui",id,mins)) return SendCommandMessage(playerid, "Usage: /mute <playerid> <minutes>");
	if (!IsPlayerConnected(id)) return 1; // invalid player
	if(pMuted[id] == true) return SendServerMessage(playerid, "This player is already muted ");
	pMuted[id] = true;
	SendAdminAlert(COLOR_LIGHTRED,"Admin %s (ID:%d) has muted %s (ID:%d) for %d min(s)",GetName(playerid), playerid, GetName(id), id, mins);
	SetTimerEx("UnMutedTimer", 60*1000*mins, false, "i", id); //60*1000 = 1 minute
	return 1;
}
CMD:unmute(playerid, params[])
{
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	new id;
	if(sscanf(params,"u",id)) return SendCommandMessage(playerid, "Usage: /mute <playerid>");
	if(!IsPlayerConnected(id)) return SendServerMessage(playerid,"target is not connected"); // invalid player id
	if(pMuted[id] == false) return SendClientMessage(playerid, COLOR_RED,"Player is not muted ");
	pMuted[id] = false;
	SendAdminAlert(COLOR_LIGHTRED,"Admin %s (ID:%d) has unmuted %s (ID:%d)",GetName(playerid), playerid, GetName(id), id);
	return 1;
}
CMD:banperm(playerid, params[])
{
    new targetid, reason[64],name[MAX_PLAYER_NAME], admin[MAX_PLAYER_NAME], ip[16];
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    if(sscanf(params, "us[64]", targetid, reason))
        return SendCommandMessage(playerid, "Usage: /banperm <player> <reason>");
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerName(playerid, admin, sizeof(admin));
    GetPlayerIp(targetid, ip, sizeof(ip));
    mysql_format(mysql, query, sizeof(query),"INSERT INTO bans (player_name, ip, admin_name, reason, ban_time, duration) VALUES ('%e', '%e', '%e', '%e', %d, 0)",name, ip, admin, reason, gettime());
    mysql_tquery(mysql, query, "", "");
    SendAdminAlert(COLOR_LIGHTRED, "Admin %s has permanently banned %s. Reason: %s", admin, name, reason);
    Kick(targetid);
    return 1;
}
CMD:bantemp(playerid, params[])
{
    new targetid, minutes, reason[64],name[MAX_PLAYER_NAME], admin[MAX_PLAYER_NAME], ip[16];
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    if(sscanf(params, "uis[64]", targetid, minutes, reason))
        return SendCommandMessage(playerid, "Usage: /bantemp <player> <minutes> <reason>");
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerName(playerid, admin, sizeof(admin));
    GetPlayerIp(targetid, ip, sizeof(ip));
    mysql_format(mysql, query, sizeof(query),"INSERT INTO bans (player_name, ip, admin_name, reason, ban_time, duration) VALUES ('%e', '%e', '%e', '%e', %d, %d)",name, ip, admin, reason, gettime(), minutes);
    mysql_tquery(mysql, query, "", "");
    SendAdminAlert(COLOR_LIGHTRED, "Admin %s has temp banned %s for %d min. Reason: %s", admin, name, minutes, reason);
    Kick(targetid);
    return 1;
}
CMD:unban(playerid, params[])
{
    new target[24],admin[MAX_PLAYER_NAME];
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    if(sscanf(params, "s[24]", target))
        return SendCommandMessage(playerid, "Usage: /unban <player name>");
    mysql_format(mysql, query, sizeof(query), "DELETE FROM bans WHERE player_name = '%e'", target);
    mysql_tquery(mysql, query, "", "");
    GetPlayerName(playerid, admin, sizeof(admin));
	SendAdminAlert(COLOR_LIGHTRED, "Admin %s has unbanned %s.", admin, target); 
    return 1;
}
CMD:banlist(playerid, params[])
{
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	AutoCleanExpiredBans();
    mysql_format(mysql, query, sizeof(query),"SELECT player_name, reason, admin_name, ban_time, duration FROM bans WHERE duration > 0 AND (ban_time + duration * 60) > UNIX_TIMESTAMP()");
    mysql_tquery(mysql, query, "OnShowBanList", "d", playerid);
    return 1;
}
CMD:goto(playerid, params[])
{
	static id,type[24],string[64];
	if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	if (sscanf(params, "s[24]S()[64]", type, string))
	{
		SendServerMessage(playerid, "[NAMES]: {FFFFFF}actor, interior, car, entrance, pos");
		return 1;
	}
	else if (!strcmp(type, "actor", true))
	{
		if (sscanf(string, "d", id))
			return SendCommandMessage(playerid, "/goto actor [ID]");
		SendPlayerToActor(playerid, id);
		return 1;
	}
	else if (!strcmp(type, "interior", true))
	{
	    static str[9000];
		str[0] = '\0';
		for (new i = 0; i < sizeof(g_arrInteriorData); i ++) {
		    strcat(str, g_arrInteriorData[i][e_InteriorName]);
		    strcat(str, "\n");
	    }
	    Dialog_Show(playerid, TeleportInterior, DIALOG_STYLE_LIST, "Teleport: List interior", str, "OK", "Return");
	    return 1;
	}
	else if (!strcmp(type, "car", true))
	{
		if (sscanf(string, "d", id))
			return SendCommandMessage(playerid, "/goto car [id]");
		if (id < 1 || id > MAX_SERVER_VEHICLES || !IsValidVehicle(id))
			return SendServerMessage(playerid, "ID invalid.");
		static Float:x,Float:y,Float:z;
		GetVehiclePos(id, x, y, z);
		SetPlayerPos(playerid, x, y - 2, z + 2);
		return 1;
	}
	else if (!strcmp(type, "entrance", true))
	{
	    if (sscanf(string, "d", id))
	        return SendCommandMessage(playerid, "/goto [entrance] [entrance ID]");
		if ((id < 0 || id >= MAX_OBJECTSC) || !EntranceData[id][entranceExists])
		    return SendServerMessage(playerid, "You have specified an invalid entrance ID.");
	    SetPlayerPos(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2]);
	    SetPlayerInterior(playerid, EntranceData[id][entranceExterior]);
		SetPlayerVirtualWorld(playerid, EntranceData[id][entranceExteriorVW]);
	    SendServerMessage(playerid, "You have teleported to entrance ID: %d.", id);
	    return 1;
	}
	else if (!strcmp(type, "pos", true))
	{
		static Float:x, Float:y, Float:z;
		if (sscanf(string, "fff", x, y, z)) return SendCommandMessage(playerid, "/goto position <x> <y> <z>");
		if (IsPlayerInAnyVehicle(playerid)) SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
		else SetPlayerPos(playerid, x, y, z + 1.0);
		return 1;
	}
	else return SendServerMessage(playerid, "Invalide name to goto.");
}
SendPlayerToActor(playerid, actorid)
{
	new Float:x,Float:y,Float:z;
	GetActorPos(actorid, x, y, z);
	if (IsPlayerInAnyVehicle(playerid))
	{
	    SetVehiclePos(GetPlayerVehicleID(playerid), x, y + 2, z);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(actorid));
	}
	else SetPlayerPos(playerid, x + 1, y, z);
}
CMD:editveh(playerid, params[])
{
	if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    new subcmd[16], vehid,index = -1,newOwner[MAX_PLAYER_NAME],color1, color2, modelid,Float:x, Float:y, Float:z, Float:a;
    if (sscanf(params, "s[16]i", subcmd, vehid))
        return SendCommandMessage(playerid, "Usage: /editveh [owner/color/modelid/paintjob/fuel] [vehid] [value(s)]");
    for (new i = 0; i < MAX_SERVER_VEHICLES; i++)
    {
        if (DB_Vehicle[i] == vehid)
        {
            index = i;
            break;
        }
    }
    if (index == -1) return SendServerMessage(playerid, "Vehicle not found.");
    if (!strcmp(subcmd, "owner", true))
    {
        if (sscanf(params, "s[16]is[24]", subcmd, vehid, newOwner))
            return SendCommandMessage(playerid, "Usage: /editveh owner [vehid] [new_owner]");
        format(VehicleOwner[index], MAX_PLAYER_NAME, "%s", newOwner);
        mysql_format(mysql, query, sizeof(query),"UPDATE vehicles SET owner = '%e' WHERE id = %d",newOwner, DB_VehicleID[index]);
        mysql_tquery(mysql, query);

        SendServerMessage(playerid, "Vehicle owner updated.");
    }
    else if (!strcmp(subcmd, "color", true))
    {
        if (sscanf(params, "s[16]iii", subcmd, vehid, color1, color2))
            return SendCommandMessage(playerid, "Usage: /editveh color [vehid] [color1] [color2]");
        ChangeVehicleColor(vehid, color1, color2);
        mysql_format(mysql, query, sizeof(query),"UPDATE vehicles SET color1 = %d, color2 = %d WHERE id = %d",color1, color2, DB_VehicleID[index]);
        mysql_tquery(mysql, query);
        SendServerMessage(playerid, "Vehicle colors updated.");
    }
    else if (!strcmp(subcmd, "modelid", true))
    {
        if (sscanf(params, "s[16]ii", subcmd, vehid, modelid))
            return SendCommandMessage(playerid, "Usage: /editveh modelid [vehid] [modelid]");
        GetVehiclePos(vehid, x, y, z);
        GetVehicleZAngle(vehid, a);
        DestroyVehicle(vehid);
        DB_Vehicle[index] = CreateVehicle(modelid, x, y, z, a, -1, -1, -1);
        mysql_format(mysql, query, sizeof(query),"UPDATE vehicles SET model = %d WHERE id = %d",modelid, DB_VehicleID[index]);
        mysql_tquery(mysql, query);
        SendServerMessage(playerid, "Vehicle model updated.");
    }
    else if (!strcmp(subcmd, "paintjob", true))
	{
        if (sscanf(params, "s[16]ii", subcmd, vehid,  color1))
        	return SendCommandMessage(playerid, "Usage: /editveh paintjob [0-2 or -1]");
        if (color1 < -1 || color1 > 2)
        	return SendServerMessage(playerid, "Invalid paintjob ID. Use -1 to clear or 0–2.");
        ChangeVehiclePaintjob(vehid, color1);
		if (color1 == -1)
        	ChangeVehiclePaintjob(vehid, 3); // 3 = remove paintjob (unofficial workaround)
		else ChangeVehiclePaintjob(vehid, color1);
		mysql_format(mysql, query, sizeof(query),"UPDATE vehicles SET paintjob = %d WHERE id = %d",color1, DB_VehicleID[index]);
        mysql_tquery(mysql, query);
		return SendServerMessage(playerid, "Vehicle paintjob updated.");
	}
    else if (!strcmp(subcmd, "fuel", true))
    {
        if (sscanf(params, "s[16]iii", subcmd, vehid, color1))
            return SendCommandMessage(playerid, "Usage: /editveh fuel [vehid] [amount]");
		gVehicleFuel[vehid] = color1;
        mysql_format(mysql, query, sizeof(query),"UPDATE vehicles SET fuel = %d WHERE id = %d",color1, DB_VehicleID[index]);
        mysql_tquery(mysql, query);
        SendServerMessage(playerid, "Vehicle fuel updated.");
    }
    else SendServerMessage(playerid, "Invalid subcommand. Use: owner, color, modelid or paintjob.");
    return 1;
}
CMD:stationlist(playerid, params[])
{
	if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    if (FuelStationCount == 0)
        return SendServerMessage(playerid,"No fuel stations loaded.");
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    SendClientMessage(playerid, 0x00FF00FF, "----- Fuel Station List -----");
    for (new i = 0; i < FuelStationCount; i++)
    {
        new Float:dist = GetDistance(px, py, pz, FuelStation[i][fsPosX], FuelStation[i][fsPosY], FuelStation[i][fsPosZ]);
        SendServerMessage(playerid,"ID: %d | Stock: %d liters | Distance: %.1fm",i, FuelStation[i][fsStock], dist);
    }
    return 1;
}
CMD:editstation(playerid, params[])
{
	if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    new subcmd[16], id, amount,Float:x, Float:y, Float:z,label[64];
    if (sscanf(params, "ds[16]D(-1)", id, subcmd, amount)) {
        return SendCommandMessage(playerid, "Usage: /editstation <id> <pos|stock> [amount]");
    }
    if (id < 0 || id >= MAX_FUEL_STATIONS || FuelStation[id][fsID] == -1)
        return SendServerMessage(playerid, "[Fuel] Invalid station ID.");
    if (!strcmp(subcmd, "pos", true)) {
        GetPlayerPos(playerid, x, y, z);
        FuelStation[id][fsPosX] = x;
        FuelStation[id][fsPosY] = y;
        FuelStation[id][fsPosZ] = z;
        mysql_format(mysql, query, sizeof(query),"UPDATE fuel_stations SET pos_x = %.3f, pos_y = %.3f, pos_z = %.3f WHERE id = %d",x, y, z, FuelStation[id][fsID]);
        mysql_query(mysql, query);
        DestroyDynamic3DTextLabel(FuelStation[id][fsLabel]);
        if (IsValidDynamic3DTextLabel(FuelStation[id][fsLabel]))
       		DestroyDynamic3DTextLabel(FuelStation[id][fsLabel]);
    	if (IsValidDynamicMapIcon(FuelStation[id][fsMapIcon]))
       		DestroyDynamicMapIcon(FuelStation[id][fsMapIcon]);
    	format(label, sizeof(label), "[ID %d] Fuel: %d liters",id,FuelStation[id][fsStock]);
    	FuelStation[id][fsLabel] = CreateDynamic3DTextLabel(label,0x00FF00FF,FuelStation[id][fsPosX],FuelStation[id][fsPosY],FuelStation[id][fsPosZ],15.0);
        FuelStation[id][fsMapIcon] = CreateDynamicMapIcon(FuelStation[id][fsPosX],FuelStation[id][fsPosY],FuelStation[id][fsPosZ],51,0,-1, -1, -1, 100.0);
        SendServerMessage(playerid,"[Fuel] Station position updated.");
    }
    else if (!strcmp(subcmd, "stock", true)) {
        if (amount < 0 || amount > 10000) return SendServerMessage(playerid,"[Fuel] Stock must be 0 to 10000.");
        FuelStation[id][fsStock] = amount;
        mysql_format(mysql, query, sizeof(query),"UPDATE fuel_stations SET stock = %d WHERE id = %d",amount, FuelStation[id][fsID]);
        mysql_query(mysql, query);
        SendServerMessage(playerid, "[Fuel] Station stock updated.");
        format(query, sizeof(query), "[ID %d] Fuel: %d liters",id,FuelStation[id][fsStock]);
    	UpdateDynamic3DTextLabelText(FuelStation[id][fsLabel], 0x00FF00FF, query);
    }
    else SendServerMessage(playerid,"[Fuel] Unknown subcommand. Use: pos / stock");
    return 1;
}
CMD:zoneinfo(playerid, params[])
{
	if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    for (new i = 0; i < TotalGZ; i++)
    {
        if (IsPlayerInZone(playerid, GangZones[i][gMinX], GangZones[i][gMinY], GangZones[i][gMaxX], GangZones[i][gMaxY]))
        {
            SendServerMessage(playerid,"Zone ID: %d | Owner Team: %d", i, GangZones[i][gTeamID]);
            if (ZoneInWar[i])
            {
                SendServerMessage(playerid,"Status: War is currently active in this zone.");
            }
            else if (gettime() < GlobalZoneCooldown)
            {
                new remaining = GlobalZoneCooldown - gettime();
                SendServerMessage(playerid,"Status: Global cooldown: %d seconds remaining.", remaining);
            }
            else
            {
                SendServerMessage(playerid,"Status: Available for war.");
            }
            return 1;
        }
    }
    SendServerMessage(playerid,"You are not standing inside any gang zone.");
    return 1;
}
CMD:addpoint(playerid, params[])
{
	if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    mysql_format(mysql, query, sizeof(query),"INSERT INTO missions (x, y, z) VALUES (%.4f, %.4f, %.4f)",x, y, z);
    mysql_tquery(mysql, query);
    SendAdminAlert(COLOR_LIGHTRED, "Admin %s has create a checkpoint for mission.",GetName(playerid));
    return 1;
}
//admin 2
CMD:setvip(playerid, params[])
{
	new lookupid, amount;
	if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
	if(sscanf(params, "ui",lookupid, amount)) return SendCommandMessage(playerid, "Usage: /setvip <playerid/Name> <amount>");
	if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid ,"Player is not connected");
    if(amount < 0 ||amount > 3) return SendServerMessage(playerid,  "0 to 3 levels"); //  you can change this to any level you want
	SendAdminAlert(COLOR_RED , "Admin %s (ID:%d) has setted %s (ID:%d) vip to (%d)", GetName(playerid), playerid, GetName(lookupid),lookupid, amount);
	SetPlayerScore(lookupid, amount);
	pData[lookupid][VIP] = amount;
    if(amount == 1)
    {
		for (new i = 1; i <= 25; i++) pData[lookupid][inv][i] += 25;
		for (new i = 0; i <= 4; i++) pData[lookupid][clanexp][i] += 25;
    }
    if(amount == 2)
    {
		for (new i = 1; i <= 25; i++) pData[lookupid][inv][i] += 50;
		for (new i = 0; i <= 4; i++) pData[lookupid][clanexp][i] += 50;
    }
    if(amount == 3)
    {
		for (new i = 1; i <= 25; i++) pData[lookupid][inv][i] += 100;
		for (new i = 0; i <= 4; i++) pData[lookupid][clanexp][i] += 100;
    }
	return 1;
}
CMD:setscore(playerid, params[])
{
	new lookupid, amount;
	if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
	if(sscanf(params, "ui",lookupid, amount)) return SendCommandMessage(playerid, "Usage: /setscore <playerid/Name> <amount>");
	if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid ,"Player is not connected");
	SendAdminAlert(COLOR_RED , "Admin %s (ID:%d) has setted %s (ID:%d) score count to (%d)", GetName(playerid), playerid, GetName(lookupid),lookupid, amount);
	SetPlayerScore(lookupid, amount);
	pData[lookupid][Score] = amount;
	return 1;
}
CMD:createspawn(playerid,params[])
{
    if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendServerMessage(playerid,"Need to be on foot.");
    new Float:x,Float:y,Float:z;
    GetPlayerPos(playerid, x, y, z);
    mysql_format(mysql, query, sizeof(query), "INSERT INTO `spawnpos` (`posx`,`posy`,`posz`) VALUES ('%.4f','%.4f','%.4f')", x, y, z);
    mysql_tquery(mysql, query, "", "");
    SendServerMessage(playerid,"Spawn object created effective next reboot.");
	return 1;
}
CMD:createveh(playerid, params[])
{
	if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
    new modelid, color1 = random(128), color2 = random(128),Float:x, Float:y, Float:z, Float:a; // random default colors
    if (sscanf(params, "i[2]", modelid, color1, color2))
        return SendCommandMessage(playerid, "Usage: /createveh [modelid] [color1] [color2]");
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    mysql_format(mysql, query, sizeof(query),"INSERT INTO vehicles (model, posX, posY, posZ, rot,  color1, color2, fuel) VALUES (%d,%f,%f,%f,%f,%d,%d,100)",modelid, x, y, z, a, color1, color2);
    mysql_tquery(mysql, query, "OnVehicleCreated", "iffffii", modelid, x, y, z, a, color1, color2);
    SendServerMessage(playerid, "Vehicle created and saved with color.");
    return 1;
}
CMD:deleteveh(playerid, params[])
{
	if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
    new vehid;
    if (sscanf(params, "i", vehid)) return SendCommandMessage(playerid, "Usage: /deleteveh [vehid]");
    for (new i = 0; i < MAX_SERVER_VEHICLES; i++)
    {
        if (DB_Vehicle[i] == vehid)
        {
            mysql_format(mysql, query, sizeof(query), "DELETE FROM vehicles WHERE id = %d", DB_VehicleID[i]);
            mysql_tquery(mysql, query);
            DestroyVehicle(vehid);
            DB_Vehicle[i] = INVALID_VEHICLE_ID;
            DB_VehicleID[i] = 0;
            VehicleOwner[i][0] = 0;
            SendServerMessage(playerid, "Vehicle deleted.");
            return 1;
        }
    }
    SendServerMessage(playerid, "Vehicle not found.");
    return 1;
}
CMD:createobject(playerid, params[])
{
	static id = -1;
    if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd");
	id = objects_Create(playerid);
	if (id == -1) return SendServerMessage(playerid, "MAX LIMITES");
    ResetEditing(playerid);
    pData[playerid][pEditobjects] = id;
	EditDynamicObject(playerid, objectsData[id][objectsOb]);
	SendServerMessage(playerid, "You have created an object with (ID: %d.)", id);
	return 1;
}
CMD:editobject(playerid, params[])
{
	static id,type[24],string[128];
    if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendCommandMessage(playerid, "/editobject [id] [name]");
	    SendServerMessage(playerid, "[NAMES]:{FFFFFF} location, model, pos");
		return 1;
	}
	if ((id < 0 || id >= MAX_OBJECTSC) || !objectsData[id][objectsExists]) return SendServerMessage(playerid, "Invalid object ID.");
    if (!strcmp(type, "location", true))
	{
		static Float:x,Float:y,Float:z,Float:angle;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		x += 3.0 * floatsin(-angle, degrees);
		y += 3.0 * floatcos(-angle, degrees);
		objectsData[id][objectsPos][0] = x;
		objectsData[id][objectsPos][1] = y;
		objectsData[id][objectsPos][2] = z;
		objectsData[id][objectsPos][3] = 0.0;
		objectsData[id][objectsPos][4] = 0.0;
		objectsData[id][objectsPos][5] = angle;
		SetDynamicObjectPos(objectsData[id][objectsOb], x, y, z);
		SetDynamicObjectRot(objectsData[id][objectsOb], 0.0, 0.0, angle);
		objects_Save(id);
		return 1;
	}
	else if (!strcmp(type, "model", true))
	{
	    static model;
		if (sscanf(string, "d", model))
		    return SendCommandMessage(playerid, "/editobject [id] [model] [objects model]");
        objectsData[id][objectsModel] = model;
		DestroyDynamicObject(objectsData[id][objectsOb]);
		objectsData[id][objectsOb] = CreateDynamicObject(objectsData[id][objectsModel], objectsData[id][objectsPos][0], objectsData[id][objectsPos][1], objectsData[id][objectsPos][2], objectsData[id][objectsPos][3], objectsData[id][objectsPos][4], objectsData[id][objectsPos][5], objectsData[id][objectsWorld], objectsData[id][objectsInterior]);
		objects_Save(id);
		return 1;
	}
    else if (!strcmp(type, "pos", true))
	{
	    ResetEditing(playerid);
	   	EditDynamicObject(playerid, objectsData[id][objectsOb]);
		pData[playerid][pEditobjects] = id;
		pData[playerid][pEditType] = 1;
		SendServerMessage(playerid, "You are now editing the object (ID: %d.) position.", id);
		return 1;
	}
	return 1;
}
CMD:delobject(playerid, params[])
{
	static id = 0;
    if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
	if (sscanf(params, "d", id))
	    return SendCommandMessage(playerid, "/delobject[object id]");
	if ((id < 0 || id >= MAX_OBJECTSC) || !objectsData[id][objectsExists])
	    return SendServerMessage(playerid, "Invalid object ID.");
	objects_Delete(id);
	SendServerMessage(playerid, "You have delete the object (ID: %d.)", id);
	return 1;
}
CMD:createentrance(playerid, params[])
{
	if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
	if (isnull(params) || strlen(params) > 32)
	    return SendCommandMessage(playerid, "/createentrance [name]");
	new id = Entrance_Create(playerid, params);
	if (id == -1)
	    return SendServerMessage(playerid, "The server has reached the limit for entrances.");
	SendServerMessage(playerid, "You have successfully created entrance ID: %d.", id);
	return 1;
}
CMD:editentrance(playerid, params[])
{
	static id,type[24],string[128];
	if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendCommandMessage(playerid, "/editentrance [id] [name]");
	    SendServerMessage(playerid, "[NAMES]:{FFFFFF} location, interior, name, lock, virtual");
		return 1;
	}
	if ((id < 0 || id >= MAX_OBJECTSC) || !EntranceData[id][entranceExists])
	    return SendServerMessage(playerid, "You have specified an invalid entrance ID.");
	if (!strcmp(type, "location", true))
	{
	    GetPlayerPos(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2]);
		GetPlayerFacingAngle(playerid, EntranceData[id][entrancePos][3]);
		EntranceData[id][entranceExterior] = GetPlayerInterior(playerid);
		EntranceData[id][entranceExteriorVW] = GetPlayerVirtualWorld(playerid);
		Entrance_Refresh(id);
		Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the location of entrance ID: %d.", Name[playerid], id);
	}
	else if (!strcmp(type, "interior", true))
	{
	    GetPlayerPos(playerid, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
		GetPlayerFacingAngle(playerid, EntranceData[id][entranceInt][3]);
		EntranceData[id][entranceInterior] = GetPlayerInterior(playerid);
		SetPlayerPosEx(playerid, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
		SetPlayerFacingAngle(playerid, EntranceData[id][entranceInt][3]);
		SetPlayerInterior(playerid, EntranceData[id][entranceInterior]);
		SetCameraBehindPlayer(playerid);
		Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the interior spawn of entrance ID: %d.", Name[playerid], id);
	}
	else if (!strcmp(type, "lock", true))
	{
	    new locked;
	    if (sscanf(string, "d", locked))
	        return SendCommandMessage(playerid, "/editentrance [id] [lock] [lock 0/1]");
		if (locked < 0 || locked > 1)
		    return SendServerMessage(playerid, "Invalid value. Use 0 for unlocked and 1 for locked.");
	    EntranceData[id][entranceLocked] = locked;
	    Entrance_Save(id);
	    if (locked) {SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has locked entrance ID: %d.", Name[playerid], id);} 
		else { SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has unlocked entrance ID: %d.", Name[playerid], id);}
	}
	else if (!strcmp(type, "name", true))
	{
	    new name[32];
	    if (sscanf(string, "s[32]", name))
	        return SendCommandMessage(playerid, "/editentrance [id] [name] [new name]");
	    format(EntranceData[id][entranceName], 32, name);
	    Entrance_Refresh(id);
	    Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the name of entrance ID: %d to \"%s\".", Name[playerid], id, name);
	}
	return 1;
}
CMD:delentrance(playerid, params[])
{
	static id = 0;
    if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
	if (sscanf(params, "d", id))
	    return SendCommandMessage(playerid, "/delentrance [entrance id]");
	if ((id < 0 || id >= MAX_OBJECTSC) || !EntranceData[id][entranceExists])
	    return SendServerMessage(playerid, "You have specified an invalid entrance ID.");
	Entrance_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed entrance ID: %d.", id);
	return 1;
}
CMD:createstation(playerid, params[])
{
	if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
    if (FuelStationCount >= MAX_FUEL_STATIONS)
        return SendServerMessage(playerid, "[Fuel] Max station limit reached.");
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    mysql_format(mysql, query, sizeof(query),"INSERT INTO fuel_stations (pos_x, pos_y, pos_z, stock, price_per_liter) VALUES (%.3f, %.3f, %.3f, 1000, 10)",x, y, z);
    mysql_query(mysql, query);
    SendServerMessage(playerid, "[Fuel] Station created.");
    mysql_tquery(mysql, "SELECT * FROM fuel_stations", "OnFuelStationsLoaded");
    return 1;
}
CMD:delstation(playerid, params[])
{
	if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
    new id;
    if (sscanf(params, "i", id)) return SendCommandMessage(playerid, "Usage: /delstation [stationid]");
    mysql_format(mysql, query, sizeof(query), "DELETE FROM fuel_stations WHERE id = %d", id);
    mysql_query(mysql, query);
    SendServerMessage(playerid, "[Fuel] Station ID %d deleted.", id);
    mysql_tquery(mysql, "SELECT * FROM fuel_stations", "OnFuelStationsLoaded");
    return 1;
}
CMD:gzcreate(playerid, params[])
{
	if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");  
	new subcmd[8];
    if (sscanf(params, "s[8]", subcmd)) {
        SendCommandMessage(playerid, "Usage: /gzcreate pointa | pointb");
        return 1;
    }
	else if (!strcmp(subcmd, "pointa", true))
	{
    	new Float:z;
    	GetPlayerPos(playerid, gZonePointA[playerid][0], gZonePointA[playerid][1], z);
    	gPointASet[playerid] = true;
    	SendClientMessage(playerid, -1, "[GangZone] Point A set. Use /gzcreate pointb at the second corner.");
	}
	else if (!strcmp(subcmd, "pointb", true))
	{
    	if (!gPointASet[playerid])
        	return SendServerMessage(playerid,"Set Point A first using /gzcreate pointa.");
    	if (TotalGZ >= MAX_GZONES)
        	return SendServerMessage(playerid,"Max gang zones reached.");
    	new Float:px, Float:py, Float:z;
    	GetPlayerPos(playerid, px, py, z);
		new Float:minx = (gZonePointA[playerid][0] < px) ? gZonePointA[playerid][0] : px,Float:maxx = (gZonePointA[playerid][0] > px) ? gZonePointA[playerid][0] : px;
    	new Float:miny = (gZonePointA[playerid][1] < py) ? gZonePointA[playerid][1] : py,Float:maxy = (gZonePointA[playerid][1] > py) ? gZonePointA[playerid][1] : py;
    	mysql_format(mysql, query, sizeof(query), "INSERT INTO gang_zones (minx, miny, maxx, maxy) VALUES (%f, %f, %f, %f)", minx, miny, maxx, maxy);
    	mysql_query(mysql, query);
    	GangZones[TotalGZ][gMinX] = minx;
    	GangZones[TotalGZ][gMinY] = miny;
    	GangZones[TotalGZ][gMaxX] = maxx;
    	GangZones[TotalGZ][gMaxY] = maxy;
    	GangZones[TotalGZ][gID] = cache_insert_id();
    	GangZones[TotalGZ][gZoneID] = GangZoneCreate(minx, miny, maxx, maxy);
    	GangZoneShowForAll(GangZones[TotalGZ][gZoneID], 0x88888888); // Show to all players with red color
    	TotalGZ++;
    	gPointASet[playerid] = false;
    	SendServerMessage(playerid,"[GangZone] Point B set. Gang zone created and saved.");
	}
    return 1;
}
CMD:gzdelete(playerid, params[])
{
	if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
    for (new i = 0; i < TotalGZ; i++)
    {
        if (IsPlayerInZone(playerid, GangZones[i][gMinX], GangZones[i][gMinY], GangZones[i][gMaxX], GangZones[i][gMaxY]))
        {
            mysql_format(mysql, query, sizeof(query), "DELETE FROM gang_zones WHERE id = %d", GangZones[i][gID]);
            mysql_tquery(mysql, query);
            GangZoneDestroy(GangZones[i][gZoneID]);
            for (new j = i; j < TotalGZ - 1; j++)
            {
                GangZones[j] = GangZones[j + 1];
            }
            TotalGZ--;
            SendServerMessage(playerid,"[GangZone] Zone deleted successfully.");
            return 1;
        }
    }
    SendClientMessage(playerid, -1, "[GangZone] You are not inside any gang zone.");
    return 1;
}
CMD:gzreload(playerid, params[])
{
	if(pData[playerid][Admin] < 2) return SendServerMessage(playerid, "Only admin level 2+ can use this cmd.");
    for (new i = 0; i < TotalGZ; i++)
        GangZoneDestroy(GangZones[i][gZoneID]);
    TotalGZ = 0;
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM gang_zones");
    mysql_tquery(mysql, query, "LoadGangZones");
    SendServerMessage(playerid,"[GangZone] Zones reloaded.");
    return 1;
}
//admin 3
CMD:resetplayer(playerid, params[])
{
	new lookupid;
	if(pData[playerid][Admin] < 3) return SendServerMessage(playerid, "Only admin level 3 can use this cmd.");
	if(sscanf(params, "u",lookupid)) return SendCommandMessage(playerid, "Usage: /resetplayer <playerid/Name>");
	if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid ,"Player is not connected");
	SendAdminAlert(COLOR_RED , "Admin %s (ID:%d) has reset %s (ID:%d)", GetName(playerid), playerid, GetName(lookupid),lookupid);
	foreach (new i : Player)
	{
		for (new p = 0; p < 3; p++)
		{
			if (IsValidDynamicPickup(clans[pData[lookupid][idclan]][pickup][p]))
			{
				DestroyDynamicPickup(clans[pData[lookupid][idclan]][pickup][p]);
				clans[pData[lookupid][idclan]][pickup][p] = INVALID_STREAMER_ID;
			}
		}
	}
	mysql_format(mysql, query, sizeof(query),"DELETE FROM clans WHERE idclan = %d",pData[lookupid][idclan]);
	mysql_tquery(mysql, query);
    pData[lookupid][Admin] = 0;
    pData[lookupid][VIP] = 0;
	pData[lookupid][Life] = 100;
	pData[lookupid][Armor] = 0;
	pData[lookupid][Pos][0] = 209.4851;
	pData[lookupid][Pos][1] = 2617.1570;
	pData[lookupid][Pos][2] = 16.6514;
	pData[lookupid][idclan] = 0;
	pData[lookupid][clanrank] =0;
	pData[lookupid][interior] = 0;
	pData[lookupid][clanexp][0] = 0;
	pData[lookupid][clanexp][1] = 0;
	pData[lookupid][clanexp][2] = 0;
	pData[lookupid][clanexp][3] = 0;
	pData[lookupid][clanexp][4] = 0;
	pData[lookupid][inv][0] = 0;
	pData[lookupid][inv][1] = 0;
	pData[lookupid][inv][2] = 0;
	pData[lookupid][inv][3] = 0;
	pData[lookupid][inv][4] = 0;
	pData[lookupid][inv][5] = 0;
	pData[lookupid][inv][6] = 0;
	pData[lookupid][inv][7] = 0;
	pData[lookupid][inv][8] = 0;
	pData[lookupid][inv][9] = 0;
	pData[lookupid][inv][10] = 0;
	pData[lookupid][inv][11] = 0;
	pData[lookupid][inv][12] = 0;
	pData[lookupid][inv][13] = 0;
	pData[lookupid][inv][14] = 0;
	pData[lookupid][inv][15] = 0;
	pData[lookupid][inv][16] = 0;
	pData[lookupid][inv][17] = 0;
	pData[lookupid][inv][18] = 0;
	pData[lookupid][inv][19] = 0;
	pData[lookupid][inv][20] = 0;
	pData[lookupid][inv][21] = 0;
	pData[lookupid][inv][22] = 0;
	pData[lookupid][inv][23] = 0;
	pData[lookupid][inv][24] = 0;
	pData[lookupid][inv][25] = 0;
	pData[lookupid][Score] = 0;
	SetPlayerSkin(lookupid,pData[lookupid][skin]);
	SetPlayerPos(lookupid, 209.4851, 2617.1570, 16.6514);
	SetPlayerInterior(lookupid,0);
	SetPlayerVirtualWorld(lookupid,0);
	ResetAllowedWeapons(lookupid);
	ResetPlayerWeapons(lookupid);
	ShowModelSelectionMenu(lookupid, "Select your new clothes", MODEL_SELECTION_SKIN, Skinsskins, sizeof(Skinsskins), -16.0, 0.0, -55.0);
	SetSpawnInfo(lookupid, 0, pData[lookupid][skin], pData[lookupid][Pos][0], pData[lookupid][Pos][0], pData[lookupid][Pos][0], 0.0, 0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:setadmin(playerid, params[])
{
	new lookupid, level;
	if(pData[playerid][Admin] == 3)
	{
		if(sscanf(params,"ud",lookupid,level)) return SendCommandMessage(playerid, "Usage: /setadmin (UserID | UserName) (level)");
		if(pData[lookupid][Admin] > pData[playerid][Admin]) return SendServerMessage(playerid, "Sorry you cant set level because his level is higher then you");
		if(level < 0 ||level > 3) return SendServerMessage(playerid, "1 to 3 levels"); //  you can change this to any level you want
		if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid, "Sorry this player isnt connected ");
		if(level < pData[lookupid][Admin])
		{
			SendAdminAlert(COLOR_LIGHTRED, "Admin %s (ID:%d) has demoted you to level %d",GetName(playerid), playerid, level);
			SendServerMessage(playerid,"You have demoted %s (ID:%d) to level %d",GetName(lookupid),lookupid,level);
            pData[lookupid][Admin] = level;
		}
		if(level > pData[lookupid][Admin])
		{
			SendAdminAlert(COLOR_LIGHTRED, "Admin %s (ID:%d) has promoted you to level %d",GetName(playerid), playerid, level);
			SendServerMessage(playerid, "You have promoted %s (ID:%d) to level %d",GetName(lookupid),lookupid,level);
            pData[lookupid][Admin] = level;
		}
	}
	else return SendServerMessage(playerid, "Only admin 3 can use this cmd");
	return 1;
}
CMD:flushspawn(playerid, params[])
{
    if (pData[playerid][Admin] < 3) return SendServerMessage(playerid, "Only admin level 3 can use this command.");
    mysql_format(mysql, query, sizeof(query), "DELETE FROM spawnpos");
    mysql_tquery(mysql, query);
    SendServerMessage(playerid, "[ADMIN] Spawn loot positions table has been flushed effective next reboot.");
    return 1;
}
CMD:flushpoint(playerid, params[])
{
	if (pData[playerid][Admin] < 3) return SendServerMessage(playerid, "Only admin level 3 can use this command.");
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    mysql_format(mysql, query, sizeof(query), "DELETE FROM missions");
    mysql_tquery(mysql, query);
    SendServerMessage(playerid, "[ADMIN] Checkpoint mission table has been flushed effective next reboot.");
    return 1;
}