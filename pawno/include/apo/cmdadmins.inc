CMD:ahelp(playerid, params[])
{
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    SendServerMessage(playerid, "---List of commands admins  for this server---");
    SendServerMessage(playerid, "/mute(1), /unmute(1), /setskin(1), /sethp(1), /setarmor(1), /createobject(1), /editobject(1), /delobject(1)");
    SendServerMessage(playerid, "/setvip(2), /setlevel(2), /setscore(2), /createspawn(2)");
    return 1;
}
CMD:setskin(playerid, params[])
{
	new lookupid, amount;
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	if(sscanf(params, "ui",lookupid, amount)) return SendServerMessage(playerid ,"Usage: /setskin <playerid/Name> <id>");
	if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid ,"Player is not connected");
	SendServerMessage(lookupid , "Admin %s (ID:%d) has setted %s (ID:%d) skin to (%d)", GetName(playerid), playerid, GetName(lookupid),lookupid, amount);
	SetPlayerSkin(lookupid, amount);
	pData[lookupid][skin] = amount;
	return 1;
}
CMD:setarmor(playerid, params[])
{
	new lookupid, amount;
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	if(sscanf(params, "ui",lookupid, amount)) return SendServerMessage(playerid ,"Usage: /setarmor <playerid/Name> <id>");
	if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid ,"Player is not connected");
	SendServerMessage(lookupid , "Admin %s (ID:%d) has setted %s (ID:%d) armor to (%d)", GetName(playerid), playerid, GetName(lookupid),lookupid, amount);
	SetPlayerArmour(lookupid, amount);
	pData[lookupid][Armor] = amount;
	return 1;
}
CMD:sethp(playerid, params[])
{
	new lookupid, amount;
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	if(sscanf(params, "ui",lookupid, amount)) return SendServerMessage(playerid ,"Usage: /sethp <playerid/Name> <id>");
	if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid ,"Player is not connected");
	SendServerMessage(lookupid , "Admin %s (ID:%d) has setted %s (ID:%d) hp to (%d)", GetName(playerid), playerid, GetName(lookupid),lookupid, amount);
	SetPlayerHealth(lookupid, amount);
	pData[lookupid][Life] = amount;
	return 1;
}
CMD:mute(playerid, params[])
{
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	new id, mins, str[128];
	if(sscanf(params,"ui",id,mins)) return SendClientMessage(playerid, -1,"Usage: /mute <playerid> <minutes>");
	if (!IsPlayerConnected(id)) return 1; // invalid player
	if(pMuted[id] == true) return SendClientMessage(playerid, COLOR_RED,"already muted ");
	pMuted[id] = true;
	format(str, sizeof(str),"Admin %s (ID:%d) has muted %s (ID:%d) for %d min(s)",GetName(playerid), playerid, GetName(id), id, mins);
	SendClientMessageToAll(COLOR_RED, str);
	SetTimerEx("UnMutedTimer", 60*1000*mins, false, "i", id); //60*1000 = 1 minute
	return 1;
}
CMD:unmute(playerid, params[])
{
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	new id, str[128];
	if(sscanf(params,"u",id)) return SendClientMessage(playerid, COLOR_CMY,"Usage: /mute <playerid>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_CMY,"target is not connected"); // invalid player id
	if(pMuted[id] == false) return SendClientMessage(playerid, COLOR_RED,"Player is not muted ");
	pMuted[id] = false;
	format(str, sizeof(str),"Admin %s (ID:%d) has unmuted %s (ID:%d)",GetName(playerid), playerid, GetName(id), id);
	SendClientMessageToAll(COLOR_RED, str);
	return 1;
}
CMD:createobject(playerid, params[])
{
	static id = -1;
    if(pData[playerid][Admin] < 1) return SendClientMessage(playerid, COLOR_RED, "Only admin level 1+ can use this cmd");
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
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendServerMessage(playerid, "/editobject [id] [name]");
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
		    return SendServerMessage(playerid, "/editobject [id] [model] [objects model]");
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
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
	if (sscanf(params, "d", id))
	    return SendServerMessage(playerid, "/delobject[object id]");
	if ((id < 0 || id >= MAX_OBJECTSC) || !objectsData[id][objectsExists])
	    return SendServerMessage(playerid, "Invalid object ID.");
	objects_Delete(id);
	SendServerMessage(playerid, "You have delete the object (ID: %d.)", id);
	return 1;
}
CMD:setvip(playerid, params[])
{
	new lookupid, str[128], level;
	if(pData[playerid][Admin] == 2)
	{
		if(sscanf(params,"ud",lookupid,level)) return SendClientMessage(playerid, -1, "Usage: /setlevel (UserID | UserName) (level)");
		if(pData[lookupid][Admin] > pData[playerid][Admin]) return SendClientMessage(playerid, -1, "Sorry you cant setlevel becoz his level is higher then you");
		if(level < 0 ||level > 3) return SendClientMessage(playerid, -1,  "1 to 5 levels"); //  you can change this to any level you want
		if(!IsPlayerConnected(lookupid)) return SendClientMessage(playerid, -1, "Sorry this player isnt connected ");
		if(level < pData[lookupid][Admin])
		{
			format(str, sizeof(str), "Admin %s (ID:%d) has demoted you to VIP level %d",GetName(playerid), playerid, level);
			SendClientMessage(lookupid, -1, str);
			format(str, sizeof(str),"You have demoted %s (ID:%d) to VIP level %d",GetName(lookupid),lookupid,level);
			SendClientMessage(playerid, -1, str);
            pData[lookupid][VIP] = level;
		}
		if(level > pData[lookupid][Admin])
		{
			format(str, sizeof(str), "Admin %s (ID:%d) has promoted you to VIP level %d",GetName(playerid), playerid, level);
			SendClientMessage(lookupid, -1, str);
			format(str, sizeof(str),"You have promoted %s (ID:%d) to VIP level %d",GetName(lookupid),lookupid,level);
			SendClientMessage(playerid, -1, str);
            pData[lookupid][VIP] = level;
		}
	}
	else return SendClientMessage(playerid, -1, "Only admin 2 can use this cmd");
	return 1;
}
CMD:setlevel(playerid, params[])
{
	new lookupid, str[128], level;
	if(pData[playerid][Admin] == 2)
	{
		if(sscanf(params,"ud",lookupid,level)) return SendClientMessage(playerid, -1, "Usage: /setlevel (UserID | UserName) (level)");
		if(pData[lookupid][Admin] > pData[playerid][Admin]) return SendClientMessage(playerid, -1, "Sorry you cant setlevel becoz his level is higher then you");
		if(level < 1 ||level > 2) return SendClientMessage(playerid, -1, "1 to 2 levels"); //  you can change this to any level you want
		if(!IsPlayerConnected(lookupid)) return SendClientMessage(playerid, -1, "Sorry this player isnt connected ");
		if(level < pData[lookupid][Admin])
		{
			format(str, sizeof(str), "Admin %s (ID:%d) has demoted you to level %d",GetName(playerid), playerid, level);
			SendClientMessage(lookupid, -1, str);
			format(str, sizeof(str),"You have demoted %s (ID:%d) to level %d",GetName(lookupid),lookupid,level);
			SendClientMessage(playerid, -1, str);
            pData[lookupid][Admin] = level;
		}
		if(level > pData[lookupid][Admin])
		{
			format(str, sizeof(str), "Admin %s (ID:%d) has promoted you to level %d",GetName(playerid), playerid, level);
			SendClientMessage(lookupid, -1, str);
			format(str, sizeof(str),"You have promoted %s (ID:%d) to level %d",GetName(lookupid),lookupid,level);
			SendClientMessage(playerid, -1, str);
            pData[lookupid][Admin] = level;
		}
	}
	else return SendClientMessage(playerid, -1, "Only admin 2 can use this cmd");
	return 1;
}
CMD:setscore(playerid, params[])
{
	new lookupid, amount;
	if(pData[playerid][Admin] == 2)
	{
		if(sscanf(params, "ui",lookupid, amount)) return SendServerMessage(playerid ,"Usage: /setscore <playerid/Name> <amount>");
		if(!IsPlayerConnected(lookupid)) return SendServerMessage(playerid ,"Player is not connected");
		SendServerMessage(lookupid , "Admin %s (ID:%d) has setted %s (ID:%d) score count to (%d)", GetName(playerid), playerid, GetName(lookupid),lookupid, amount);
		SetPlayerScore(lookupid, amount);
		pData[lookupid][Score] = amount;
	}
    else return SendClientMessage(playerid, COLOR_RED, "Only admin 2 can use this cmd");
	return 1;
}
CMD:createspawn(playerid,params[])
{
    if(pData[playerid][Admin] == 2)
	{
        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_RED, "Need to be on foot.");
        new Float:x,Float:y,Float:z;
        GetPlayerPos(playerid, x, y, z);
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `spawnpos` (`posx`,`posy`,`posz`) VALUES ('%.4f','%.4f','%.4f')", x, y, z);
        mysql_tquery(mysql, query, "", "");
        SendServerMessage(playerid,"Spawn object created effective next reboot");
	}
    else return SendClientMessage(playerid, COLOR_RED, "Only admin 2 can use this cmd");
	return 1;
}
