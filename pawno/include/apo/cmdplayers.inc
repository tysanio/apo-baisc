CMD:help(playerid, params[])
{
    SendServerMessage(playerid, "---List of commands for this server---");
	SendCommandMessage(playerid, "/howto, /me, /do, /stats, /craft, /use, /suggest, /levelup, /vipchat");
    SendCommandMessage(playerid, "/dwep, /swep, /pwep, /storage, /editstorage, /animcmds, /dc, /admins");
	SendCommandMessage(playerid, "/clan, /clanchest, /clanwar, /claninvite, /clanremove, /clanrank, /clanres, /clans");
    SendCommandMessage(playerid, "/repairleak, /repair, /refuel, /virtualworld, /discordconfirm");
    SendCommandMessage(playerid, "Admin Commands : /ahelp");
    SendServerMessage(playerid, "To pickup and item crouch and press ~k~~CONVERSATION_NO~");
    return 1;
}
CMD:howto(playerid, params[])
{
	Dialog_Show(playerid, howto, DIALOG_STYLE_MSGBOX, "How to do stuff","\
	Q: How to pickup stuff?\nA: If its an item crouch and press N, if its a weapon /pwep\n\n\
	Q: How to level up?\nA: Need to have 5000 exp on personal exp (clan exp 0) or one of the 4 clan have 2500 exp go see them and select level up.\n\n\
	Q: How to interact with those bots?\nA: Aim at then to have a dialog pop-in up.\n\n\
	Q: How to have bigger backpack? \nA: Each 5 level 0 to 25 give bigger backpack slot 8-16-32 max 256.\n\n\
	","OK","");
    return 1;
}
CMD:stats(playerid, params[])
{
	Dialog_Show(playerid, dSTATS,DIALOG_STYLE_TABLIST,"Account stats","Level Admin : \t%d\nLevel VIP : \t%d\nScore : \t%d\n\
    Meat(s) : \t%d\nWood(s) : \t%d\nMetal(s) : \t%d\nCloth(s) : \t%d\nPlastic(s) : \t%d\nGun Powder(s) : \t%d\nOre(s) : \t%d\nIron(s) : \t%d\nGold(s) : \t%d\nLockpick(s) : \t%d\n\
    Repair kit(s) : \t%d\nMed Kit( s): \t%d\nJerrycan(s) : \t%d\n9mm Bullet(s) : \t%d\n00' Buck's : \t%d\n.308(s) : \t%d\nArmor Plate(s) : \t%d\nWater Bottle : \t%d\nCanned Food : \t%d\nSeed(s) : \t%d\n\
    Potato(es) : \t%d\nWeed(s) : \t%d\nTomato(es) : \t%d\ninv24 : \t%d\ninv25 : \t%d\nClan 0 Exp: \t%d\nClan 1 Exp: \t%d\nClan 2 Exp: \t%d\nClan 3 Exp: \t%d\nClan 4 Exp: \t%d\nDiscord ID : \t%s\
    ", "Close","",pData[playerid][Admin],pData[playerid][VIP],pData[playerid][Score],\
    pData[playerid][inv][1],pData[playerid][inv][2],pData[playerid][inv][3],pData[playerid][inv][4],pData[playerid][inv][5],\
    pData[playerid][inv][6],pData[playerid][inv][7],pData[playerid][inv][8],pData[playerid][inv][9],pData[playerid][inv][10],\
    pData[playerid][inv][11],pData[playerid][inv][12],pData[playerid][inv][13],pData[playerid][inv][14],pData[playerid][inv][15],\
    pData[playerid][inv][16],pData[playerid][inv][17],pData[playerid][inv][18],pData[playerid][inv][19],pData[playerid][inv][20],\
    pData[playerid][inv][21],pData[playerid][inv][22],pData[playerid][inv][23],pData[playerid][inv][24],pData[playerid][inv][25],\
    pData[playerid][clanexp][0],pData[playerid][clanexp][1],pData[playerid][clanexp][2],pData[playerid][clanexp][3],pData[playerid][clanexp][4],pData[playerid][pDiscordID]);
	return 1;
}
CMD:levelup(playerid, params[])
{
	if(pData[playerid][clanexp][0] >= 5000)
	{
		pData[playerid][clanexp][0] -= 5000;
        pData[playerid][Score] += 1;
        SetPlayerScore(playerid, pData[playerid][Score]);
        Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Level UP", "Wow a self thought congradulation!\nLevel up +1\nPersonnal Exp -5000", "OK", "");
    }
    else Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Level UP", "You don't have the right amount of EXP do it (5000).", "OK", "");
}
CMD:me(playerid, params[])
{
	if (isnull(params))
	    return SendCommandMessage(playerid, "/me [action]");
	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %.64s", Name[playerid], params);
	    SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "...%s", params[64]);
	}
	else {
	    SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %s", Name[playerid], params);
	}
	pData[playerid][clanexp][0] += random(3)+1;
	return 1;
}
CMD:do(playerid, params[])
{
	if (isnull(params))
	    return SendCommandMessage(playerid, "/do [description]");

	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %.64s", params);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "...%s (( %s ))", params[64], Name[playerid]);
	}
	else {
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s (( %s ))", params, Name[playerid]);
	}
	pData[playerid][clanexp][0] += random(3)+1;
	return 1;
}
CMD:vipchat(playerid, params[])
{
    new message[144],string[180];
    if(pData[playerid][VIP] < 1 && pData[playerid][Admin] < 1) return SendServerMessage(playerid, "You are not a VIP.");
    if(sscanf(params, "s[144]", message)) return SendCommandMessage(playerid, "/v [message]");
    format(string, sizeof(string), "[VIP CHAT] %s: %s",Name[playerid],message);
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(pData[i][VIP] < 1 && pData[i][Admin] < 1) continue;
        SendClientMessage(i, 0x33CCFFFF, string);
    }
    return 1;
}
CMD:virtualworld(playerid, params[])
{
    SendServerMessage(playerid,"Virtual world %d",GetPlayerVirtualWorld(playerid));
	return 1;
}
CMD:dwep(playerid,params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
    new GunID = GetPlayerWeapon(playerid),GunAmmo = GetPlayerAmmo(playerid),GunNames[32];
    if(GunID > 0 && GunAmmo != 0)
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
        if(f > MAX_OBJ) return SendServerMessage(playerid,"You dont have a weapon on you.");
		RemovePlayerWeapon(playerid, GunID);
		dGunData[f][ObjData][0] = GunID;
		dGunData[f][ObjData][1] = GunAmmo;
        GetWeaponName(dGunData[f][ObjData][0], GunNames, sizeof(GunNames));
        GetPlayerPos(playerid, dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2]);
        dGunData[f][ObjID] = CreateObject(GunObjects[GunID], dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2]-1, 93.7, 120.0, 120.0);
		SendServerMessage(playerid, "You have dropped a %s.", GunNames);
    	format(query, sizeof(query),"INSERT INTO weapon_drops (weaponid, ammo, pos_x, pos_y, pos_z) VALUES (%d, %d, %f, %f, %f)",
		GunID,GunAmmo,dGunData[f][ObjPos][0],dGunData[f][ObjPos][1],dGunData[f][ObjPos][2]);
    	mysql_tquery(mysql, query,"","");
	}
    return 1;
}
CMD:swep(playerid,params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
    new f = MAX_OBJ+1,GunNames[32];
	for(new a = 0; a < MAX_OBJ; a++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, dGunData[a][ObjPos][0], dGunData[a][ObjPos][1], dGunData[a][ObjPos][2]))
		{
			f = a;
		    break;
		}
	}
	if(f > MAX_OBJ) return SendServerMessage(playerid,"No weapon is near you, please try again.");
	GetWeaponName(dGunData[f][ObjData][0], GunNames, sizeof(GunNames));
	SendServerMessage(playerid, "You have found a %s type /pwep to pick it up.", GunNames);
  	return 1;
}
CMD:pwep(playerid,params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
    new f = MAX_OBJ+1,GunNames[32];
	for(new a = 0; a < MAX_OBJ; a++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, dGunData[a][ObjPos][0], dGunData[a][ObjPos][1], dGunData[a][ObjPos][2]))
	    {
	        f = a;
	        break;
	    }
	}
    format(query, sizeof(query),"DELETE FROM weapon_drops WHERE `weaponid`='%d' AND `ammo`='%d' LIMIT 1",
	dGunData[f][ObjData][0],dGunData[f][ObjData][1]);
    mysql_query(mysql, query, false);
	if(f > MAX_OBJ) return SendServerMessage(playerid,"You are not near a weapon that you can pick up.");
	DestroyObject(dGunData[f][ObjID]);
	GetWeaponName(dGunData[f][ObjData][0], GunNames, sizeof(GunNames));
	AllowWeapon(playerid, dGunData[f][ObjData][0], dGunData[f][ObjData][1]);
	GivePlayerWeapon(playerid, dGunData[f][ObjData][0], dGunData[f][ObjData][1]);
	dGunData[f][ObjPos][0] = 0.0;
	dGunData[f][ObjPos][1] = 0.0;
	dGunData[f][ObjPos][2] = 0.0;
	dGunData[f][ObjID] = -1;
	dGunData[f][ObjData][0] = 0;
	dGunData[f][ObjData][1] = 0;
	SendServerMessage(playerid, "You have picked up a %s.", GunNames);
    return 1;
}
CMD:storage(playerid, params[])
{
    Dialog_Show(playerid, storageData,DIALOG_STYLE_LIST,"Storage","Create Storage\nDelete storage\nEdit position\nClaim", "Close","");
	return 1;
}
CMD:editstorage(playerid, params[])
{
    new subcmd[16], args[32],item_id, amount;
	static id = -1;
    if (sscanf(params, "s[16]S()[32]",subcmd, args)) {
        SendCommandMessage(playerid, "Usage: /editstorage <withdraw|give|view|upgrade> [item_id] [amount]");
		SendServerMessage(playerid, "1: Meat(s), 2: Wood(s), 3: Metal(s),4: Cloth(s), 5: Plastic(s),6: Gun Powder(s)");
		SendServerMessage(playerid, "7: Ore(s), 8: Iron(s), 9: Gold(s), 10: Lockpick(s), 11: Repair kit(s), 12: Med Kit(s),13: Jerrycan(s) ");
		SendServerMessage(playerid, "14: 9mm Bullet(s), 15: 00' Buck's, 16: 308(s), 17: Armor Plate(s), 18: Water Bottle, 19: Canned Food");
		SendServerMessage(playerid, "20: Seed(s), 21: Potato(es), 22: Weed(s), 23: Tomato(es), 24: inv24, 25: inv25");
        return 1;
    }
    if (!strcmp(subcmd, "withdraw", true))
    {
        if (sscanf(args, "ii", item_id, amount)) {
            SendCommandMessage(playerid, "Usage: /editstorage withdraw <item_id> <amount>");
            return 1;
        }
        if ((id = Storage_Nearest(playerid)) != -1)
		{
            if (item_id < 0 || item_id > 26) return SendServerMessage(playerid,"Invalid item ID [1-25].");
            if (amount <= 0) return SendServerMessage(playerid, "Invalid amount.");
            if (storageData[id][storagesInv][item_id] < amount) return SendServerMessage(playerid,"Not enough items in storage.");
			if (pData[playerid][inv][item_id] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough backpack space for this item.");
			storageData[id][storagesInv][item_id] -= amount;
            pData[playerid][inv][item_id] += amount;
            SendServerMessage(playerid,"You withdrew %d of item %s from storage.", amount, ItemNames[item_id]);
            storages_Save(id);
        }
        else SendServerMessage(playerid,"You're not near a storage that you own.");
    }
    else if (!strcmp(subcmd, "give", true))
    {
        if (sscanf(args, "ii", item_id, amount)) {
            SendServerMessage(playerid,"Usage: /editstorage give <item_id> <amount>");
            return 1;
        }
        if ((id = Storage_Nearest(playerid)) != -1)
		{
            if (item_id < 0 || item_id >= 26) return SendServerMessage(playerid,"Invalid item ID [1-25].");
            if (amount <= 0) return SendServerMessage(playerid,"Invalid amount.");
            if (pData[playerid][inv][item_id] < amount) return SendServerMessage(playerid,"You don't have enough of that item.");
			if (storageData[id][storagesInv][item_id] + amount > GetStorageCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item.");
            storageData[id][storagesInv][item_id] += amount;
            pData[playerid][inv][item_id] -= amount;
            SendServerMessage(playerid,"You gave %d of %s to storage.", amount, ItemNames[item_id]);
            storages_Save(id);
        }
        else SendServerMessage(playerid,"You're not near a storage that you own.");
    }
	else if (!strcmp(subcmd, "view", true))
	{
		if ((id = Storage_Nearest(playerid)) != -1)
		{
			if (storageData[id][storagesLock] != pData[playerid][ID]) return SendServerMessage(playerid, "This is not your storage."); 
			Dialog_Show(playerid, storageData,DIALOG_STYLE_MSGBOX,"Storage","Lock [ID] : \t%d\nCapacity : \t%d\n\
			Meat(s) : \t%d\nWood(s) : \t%d\nMetal(s) : \t%d\nCloth(s) : \t%d\nPlastic(s) : \t%d\nGun Powder(s) : \t%d\n\
			Ore(s) : \t%d\nIron(s) : \t%d\nGold(s) : \t%d\nLockpick(s) : \t%d\n\
			Repair kit(s) : \t%d\nMed Kit( s): \t%d\nJerrycan(s) : \t%d\n\
			9mm Bullet(s) : \t%d\n00' Buck's : \t%d\n.308(s) : \t%d\nArmor Plate(s) : \t%d\n\
			Water Bottle : \t%d\nCanned Food : \t%d\nSeed(s) : \t%d\nPotato(es) : \t%d\nWeed(s) : \t%d\nTomato(es) : \t%d\ninv24 : \t%d\ninv25 : \t%d\n\
			", "Close","",storageData[id][storagesLock],GetStorageCapacity(id),\
			storageData[id][storagesInv][1],storageData[id][storagesInv][2],storageData[id][storagesInv][3],storageData[id][storagesInv][4],storageData[id][storagesInv][5],\
			storageData[id][storagesInv][6],storageData[id][storagesInv][7],storageData[id][storagesInv][8],storageData[id][storagesInv][9],storageData[id][storagesInv][10],\
			storageData[id][storagesInv][11],storageData[id][storagesInv][12],storageData[id][storagesInv][13],storageData[id][storagesInv][14],storageData[id][storagesInv][15],\
			storageData[id][storagesInv][16],storageData[id][storagesInv][17],storageData[id][storagesInv][18],storageData[id][storagesInv][19],storageData[id][storagesInv][20],\
			storageData[id][storagesInv][21],storageData[id][storagesInv][22],storageData[id][storagesInv][23],storageData[id][storagesInv][24],storageData[id][storagesInv][25]);
		}
		else SendServerMessage(playerid,"You're not near a storage that you own.");
	}
    else if (!strcmp(subcmd, "upgrade", true))
    {
        if ((id = Storage_Nearest(playerid)) != -1)
		{
			if (storageData[id][storagesInv][2] < GetStorageCapacity(id))
				return SendServerMessage(playerid, "The storage is not full of %s for upgrade (%d).",ItemNames[2],GetStorageCapacity(id));
			if (storageData[id][storagesInv][3] < GetStorageCapacity(id))
				return SendServerMessage(playerid, "The storage is not full of %s for upgrade (%d).",ItemNames[3],GetStorageCapacity(id));
			if (storageData[id][storagesInv][5] < GetStorageCapacity(id))
				return SendServerMessage(playerid, "The storage is not full of %s for upgrade (%d).",ItemNames[5],GetStorageCapacity(id));
			storageData[id][storagesInv][2] -= GetStorageCapacity(id);
			storageData[id][storagesInv][3] -= GetStorageCapacity(id);
			storageData[id][storagesInv][5] -= GetStorageCapacity(id);
            storageData[id][storagesInv][0] += 1;
            SendServerMessage(playerid,"You upgrade your storage to level %d capacity : (%d).",storageData[id][storagesInv][0],GetStorageCapacity(id));
            storages_Save(id);
        }
        else SendServerMessage(playerid,"You're not near a storage that you own.");
    }
	else return SendServerMessage(playerid, "Invalid option to choose from.");
	return 1;
}
CMD:deer(playerid, params[])
{
	if(inJOB[playerid] == 1)
	{
		Detectare_Intrare(playerid);
	}
	else if (inJOB[playerid] == 0)
	{
		inJOB[playerid] = 1;
		Deep_Deer[playerid] = 0;
		Shoot_Deer[playerid] = 0;
		SetTimerEx("Next_Deer", 1000, false, "i", playerid);
	}
	return 1;
}
CMD:craft(playerid, params[])
{
	Dialog_Show(playerid, Craft,DIALOG_STYLE_LIST,"Crafting","Vehicles\nWeapons\nAmmos\nMisc's", "Craft","Close");
    return 1;
}
CMD:use(playerid, params[])
{
	Dialog_Show(playerid, UseItem,DIALOG_STYLE_LIST,"Use Item(s)","9 mm\n00' Buck's\n.308\nMed Kit\nArmor Plates\nJerrycan\nWater Bottle\nCanned Food\nPotatoes\nTomatoes\nWeed\nLockpick", "Use", "Close");
    return 1;
}
CMD:saveveh(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), Float:x, Float:y, Float:z, Float:angle,modString[128], mod[6],model = GetVehicleModel(vehicleid);
    if (!vehicleid) return SendServerMessage(playerid, "You are not in a vehicle.");
    for (new i = 0; i < MAX_SERVER_VEHICLES; i++)
    {
        if (DB_Vehicle[i] == vehicleid)
        {
            GetVehiclePos(vehicleid, x, y, z);
            GetVehicleZAngle(vehicleid, angle);
			g_LastVehiclePos[DB_Vehicle[i]][0] = x;
			g_LastVehiclePos[DB_Vehicle[i]][1] = y;
			g_LastVehiclePos[DB_Vehicle[i]][2] = z;
            format(modString, sizeof(modString), "");
            if (gVehicleFuel[vehicleid] >= 100.1) gVehicleFuel[vehicleid] = 100.0;
            for (new slot = 0; slot < 23; slot++)
            {
                new comp = GetVehicleComponentInSlot(vehicleid, slot);
                if (comp != 0)
                {
                    format(mod, sizeof(mod), "%d,", comp);
                    strcat(modString, mod);
                }
            }
            mysql_format(mysql, query, sizeof(query),"UPDATE vehicles SET model = %d, posX = %.2f, posY = %.2f, posZ = %.2f, rot = %.2f, mods = '%e', fuel = '%.2f' WHERE id = %d",
				model, x, y, z, angle, modString, gVehicleFuel[vehicleid], DB_VehicleID[i]);
            mysql_tquery(mysql, query);
            return SendServerMessage(playerid, "Vehicle data saved successfully.");
        }
    }
    return SendServerMessage(playerid, "This vehicle is not managed by the system.");
}
CMD:repairleak(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsPlayerInAnyVehicle(playerid))
        return SendServerMessage(playerid,"[Leak] You must be in a vehicle.");
	if (pData[playerid][inv][11] <= 1 )
		return SendServerMessage(playerid,"You don't have a repair kit.");
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendServerMessage(playerid,"[Leak] Only the driver can repair the vehicle.");
    if (!FuelLeaking[vehicleid])
        return SendServerMessage(playerid,"[Leak] This vehicle has no fuel leak.");
    FuelLeaking[vehicleid] = false;
    if (FuelWarningVisible[playerid])
    {
    	FuelWarningVisible[playerid] = false;
    }
    SetVehicleHealth(vehicleid, 651.0);
	pData[playerid][inv][11] -= 1; 
    SendServerMessage(playerid,"[Leak] Fuel leak repaired successfully!");
    return 1;
}
CMD:repair(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsPlayerInAnyVehicle(playerid))
        return SendServerMessage(playerid,"[Leak] You must be in a vehicle.");
	if (pData[playerid][inv][11] <= 0 )
		return SendServerMessage(playerid,"You don't have a repair kit.");
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendServerMessage(playerid,"[Leak] Only the driver can repair the vehicle.");
    if (FuelLeaking[vehicleid])
        return SendServerMessage(playerid,"[Leak] This vehicle has a fuel leak.");
    SetVehicleHealth(vehicleid, 1000.0);
	pData[playerid][inv][11] -= 1; 
    SendServerMessage(playerid,"[Vehicle] repaired successfully!");
    return 1;
}
CMD:refuel(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsPlayerInAnyVehicle(playerid))
        return SendServerMessage(playerid,"[Leak] You must be in a vehicle.");
	if (pData[playerid][inv][13] <= 0 )
		return SendServerMessage(playerid,"You don't have a jerrycan");
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendServerMessage(playerid,"[Leak] Only the driver can use a jerrycan.");
    if (FuelLeaking[vehicleid])
        return SendServerMessage(playerid,"[Leak] This vehicle has a fuel leak.");
	pData[playerid][inv][13] -= 1; 
	gVehicleFuel[vehicleid] += 20.0;
    SendServerMessage(playerid,"[Vehicle] refuel successfully!");
    return 1;
}
//mine
CMD:mine(playerid, params[])
{
	if(IsMining[playerid] == 1) return SendServerMessage(playerid,"Vous êtes déjà en train de miner ! Veuillez patienter.");
	if(IsPlayerInRangeOfPoint(playerid, 50.0, MineRock_X, MineRock_Y, MineRock_Z))
    {
        IsMining[playerid] = 1;
        TogglePlayerControllable(playerid, 0);            
        ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~w~Minage en cours...~n~~r~10 Secondes Restantes", 10000, 3);
        SetTimerEx("FinishMining", 10000, false, "i", playerid);
    }
    else
    {
		SendServerMessage(playerid,"Vous n'êtes pas à côté d'un rocher exploitable.");
    }
    return 1;
}
CMD:admins(playerid, params[])
{
    new count = 0;
    SendServerMessage(playerid, "========== Online Admins ==========");
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(pData[i][Admin] > 0)
        {
            SendServerMessage(playerid, "Level %d - %s (ID: %d)",pData[i][Admin],Name[i],i);
            count++;
        }
    }
    if(count == 0) SendServerMessage(playerid, "There are currently no admins online."); 
    return 1;
}
CMD:clans(playerid, params[])
{
    new count = 0;
    SendServerMessage(playerid, "========== Clan List ==========");
    for(new i = 0; i < MAX_CLANS; i++)
    {
        if(!clans[i][clanexists]) continue;
        SendServerMessage(playerid, "Server ID: %d | %s",i,clans[i][clanname]);
        count++;
    }
    if(count == 0) SendServerMessage(playerid, "There are no clans created.");
    return 1;
}
//antenna
CMD:freq(playerid, params[])
{
    new freq;
    if(sscanf(params, "d", freq)) return SendCommandMessage(playerid, "/freq [1-250]");
    if(freq < 1 || freq > MAX_FREQUENCY) return SendRadioMessage(playerid, "Frequency must be between 1 and 250.");
    //regarde si radio ou non
    pData[playerid][pFrequency] = freq;
    SendRadioMessage(playerid, "Radio frequency changed to %d.", freq);
    return 1;
}
CMD:r(playerid, params[])
{
    new message[144],msg[160];
    if(sscanf(params,"s[144]",message)) return SendCommandMessage(playerid, "/r [message]");

    if(!pData[playerid][pHasRadio]) return SendRadioMessage(playerid,"You don't have a radio.");
    if(pData[playerid][pFrequency] == 0) return SendRadioMessage(playerid, "Select a frequency first.");
    foreach(new i : Player)
    {
		new quality = GetSignalQuality(i);
        if(!pData[i][pHasRadio]) continue;

        if(pData[i][pFrequency] != pData[playerid][pFrequency]) continue;
		if(!RadioCanReach(playerid,i))
		{
			SendRadioMessage(i,"<< STATIC >>");
			continue;
		}
        if(quality == SIGNAL_NONE)
        {
            SendRadioMessage(i,"<< STATIC >>");
            continue;
        }
        format(msg,sizeof(msg),"%s",message);
        CorruptRadioMessage(msg,quality);
        SendRadioMessage(i,"[RADIO %d] %s: %s",pData[playerid][pFrequency],Name[playerid],msg);
    }
    return 1;
}
CMD:antenna(playerid,params[])
{
	Dialog_Show(playerid,AntennaDialog,DIALOG_STYLE_LIST,"Action you can perfom","Repair\nRefuel","Ok","");
	return 1;
}
//plant
CMD:plant(playerid, params[])
{
    new type[16],Float:x,Float:y, Float:z,slot = GetFreePlantSlot(),planttype;
    if(sscanf(params,"s[16]",type)) return SendCommandMessage(playerid,"/plant [potato/tomato/weed]");
    if(GetPlayerInterior(playerid))  return SendServerMessage(playerid, "You can only plant outside.");
    if(GetPlayerVirtualWorld(playerid)) return SendServerMessage(playerid,  "You can only plant outside.");
    GetPlayerPos(playerid,x,y,z);
    if(IsNearAnotherPlant(x,y,z)) return SendServerMessage(playerid, "Too close to another plant.");
    if(slot == -1) return SendServerMessage(playerid, "No free plant slots.");
    if(!strcmp(type,"potato",true))
    {
        if(pData[playerid][inv][20] < 1) return SendServerMessage(playerid, "You don't have a potato seed.");
        pData[playerid][inv][20]--;
        planttype = PLANT_POTATO;
    }
    else if(!strcmp(type,"tomato",true))
    {
        if(pData[playerid][inv][20] < 1) return SendServerMessage(playerid, "You don't have a tomato seed.");
        pData[playerid][inv][20]--;
        planttype = PLANT_TOMATO;
    }
    else if(!strcmp(type,"weed",true))
    {
        if(pData[playerid][inv][20] < 1) return SendServerMessage(playerid, "You don't have a weed seed.");
        pData[playerid][inv][20]--;
        planttype = PLANT_WEED;
    }
    else return SendServerMessage(playerid, "Valid plants: potato, tomato.");
    Plant[slot][plantExists] = true;
    Plant[slot][plantOwner] =
    pData[playerid][ID];
    Plant[slot][plantType] = planttype;
    Plant[slot][plantX] = x;
    Plant[slot][plantY] = y;
    Plant[slot][plantZ] = z;
    Plant[slot][plantVW] = GetPlayerVirtualWorld(playerid);
    Plant[slot][plantInterior] = GetPlayerInterior(playerid);
    Plant[slot][plantTime] = gettime();
    CreatePlant(slot);
    mysql_format(mysql,query,sizeof(query),"INSERT INTO plants (owner,type,x,y,z,world,interior,planttime) VALUES (%d,%d,'%f','%f','%f',%d,%d,%d)",
        Plant[slot][plantOwner],
        Plant[slot][plantType],
        Plant[slot][plantX],
        Plant[slot][plantY],
        Plant[slot][plantZ],
        Plant[slot][plantVW],
        Plant[slot][plantInterior],
        Plant[slot][plantTime]);
    mysql_tquery(mysql,query, "OnPlantCreated","d",slot);
    SendServerMessage(playerid,"You planted a %s seed.",GetPlantName(planttype));
    return 1;
}
CMD:harvest(playerid, params[])
{
    new id = GetNearestPlant(playerid);
    if(id == -1)  return SendServerMessage(playerid,"There are no plants nearby.");
    if(GetPlayerDistanceFromPoint(playerid, Plant[id][plantX], Plant[id][plantY], Plant[id][plantZ]) > 3.0)
    {
        return SendServerMessage(playerid, "Move closer to the plant.");
    }
    if(!IsPlantReady(id)) return SendServerMessage(playerid,  "This plant is still growing.");
    switch(Plant[id][plantType])
    {
        case PLANT_POTATO:
        {
            new amount = random(4)+2; //2-5
            pData[playerid][inv][21] += amount;
			if(pData[playerid][inv][21] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "You don't have enough backpack space.");
            SendServerMessage(playerid,"You harvested %d potatoes.",amount);
        }
        case PLANT_TOMATO:
        {
            new amount = random(4)+3; //3-6
            if(pData[playerid][inv][23] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "You don't have enough backpack space.");
            SendServerMessage(playerid,  "You harvested %d tomatoes.",amount);
        }
        case PLANT_WEED:
        {
            new amount = random(4)+3; //3-6
            if(pData[playerid][inv][22] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "You don't have enough backpack space.");
            SendServerMessage(playerid,  "You harvested %d weeds.",amount);
        }
    }
    mysql_format(mysql,query,sizeof(query),"DELETE FROM plants WHERE id=%d",Plant[id][plantSQLID]);
    mysql_tquery(mysql, query);
    DestroyPlant(id);
    return 1;
}
//anims
CMD:animcmds(playerid, params[])
{
	SendAnimsMessage(playerid,"{FFFFFF} /dance, /handsup, /bat, /slap, /bar, /wash, /lay, /workout, /blowjob, /bomb.");
	SendAnimsMessage(playerid,"{FFFFFF} /carry, /crack, /sleep, /jump, /deal, /dancing, /eating, /puke, /gsign, /chat.");
	SendAnimsMessage(playerid,"{FFFFFF} /goggles, /spray, /throw, /swipe, /office, /kiss, /knife, /cpr, /scratch, /point.");
	SendAnimsMessage(playerid,"{FFFFFF} /cheer, /wave, /strip, /smoke, /reload, /taichi, /wank, /cower, /skate, /drunk.");
	SendAnimsMessage(playerid,"{FFFFFF} /cry, /tired, /assis, /crossarms, /fucku, /walk, /piss, /stopanim.");
	return 1;
}
CMD:dance(playerid, params[])
{
	new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/dance [1-4]");
	if (type < 1 || type > 4)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
		case 1: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
	    case 2: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
	    case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
	    case 4: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
	}
	return 1;
}
CMD:handsup(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	return 1;
}
CMD:piss(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	SetPlayerSpecialAction(playerid, 68);
	return 1;
}
CMD:bat(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/bat [1-5]");
	if (type < 1 || type > 5)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "BASEBALL", "Bat_1", 4.1, 0, 1, 1, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "BASEBALL", "Bat_2", 4.1, 0, 1, 1, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "BASEBALL", "Bat_3", 4.1, 0, 1, 1, 0, 0, 1);
	    case 4: ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 0, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "BASEBALL", "Bat_IDLE", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:slap(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimation(playerid, "BASEBALL", "Bat_M", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:bar(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/bar [1-8]");
	if (type < 1 || type > 8)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "BAR", "Barserve_give", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "BAR", "Barserve_glass", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimation(playerid, "BAR", "Barserve_in", 4.1, 0, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimation(playerid, "BAR", "Barserve_order", 4.1, 0, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "BAR", "BARman_idle", 4.1, 1, 0, 0, 0, 0, 1);
	    case 7: ApplyAnimationEx(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 0, 0, 0, 0, 1);
	    case 8: ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:wash(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:lay(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/lay [1-5]");
	if (type < 1 || type > 5)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "BEACH", "bather", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "BEACH", "ParkSit_M_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "BEACH", "ParkSit_W_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "BEACH", "SitnWait_loop_W", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:workout(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/workout [1-7]");
	if (type < 1 || type > 7)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "benchpress", "gym_bp_celebrate", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "benchpress", "gym_bp_down", 4.1, 0, 0, 0, 1, 0, 1);
	    case 3: ApplyAnimation(playerid, "benchpress", "gym_bp_getoff", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "benchpress", "gym_bp_geton", 4.1, 0, 0, 0, 1, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_A", 4.1, 0, 0, 0, 1, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_B", 4.1, 0, 0, 0, 1, 0, 1);
	    case 7: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_smooth", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}
CMD:blowjob(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/blowjob [1-4]");
	if (type < 1 || type > 4)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:bomb(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:carry(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/carry [1-6]");
	if (type < 1 || type > 6)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "CARRY", "liftup05", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimation(playerid, "CARRY", "putdwn105", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:crack(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/crack [1-6]");
	if (type < 1 || type > 6)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "CRACK", "crckdeth3", 4.1, 0, 0, 0, 1, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "CRACK", "crckidle1", 4.1, 0, 0, 0, 1, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "CRACK", "crckidle2", 4.1, 0, 0, 0, 1, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "CRACK", "crckidle3", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}
CMD:sleep(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/sleep [1-2]");
	if (type < 1 || type > 2)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth4", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "CRACK", "crckidle4", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}
CMD:jump(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimation(playerid, "DODGE", "Crush_Jump", 4.1, 0, 1, 1, 0, 0, 1);
	return 1;
}
CMD:deal(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/deal [1-6]");
	if (type < 1 || type > 6)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "DEALER", "DRUGS_BUY", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_02", 4.1, 1, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_03", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:dancing(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/dancing [1-10]");
	if (type < 1 || type > 10)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "DANCING", "dance_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "DANCING", "DAN_Left_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "DANCING", "DAN_Right_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "DANCING", "DAN_Loop_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "DANCING", "DAN_Up_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "DANCING", "DAN_Down_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 7: ApplyAnimationEx(playerid, "DANCING", "dnce_M_a", 4.1, 1, 0, 0, 0, 0, 1);
	    case 8: ApplyAnimationEx(playerid, "DANCING", "dnce_M_e", 4.1, 1, 0, 0, 0, 0, 1);
	    case 9: ApplyAnimationEx(playerid, "DANCING", "dnce_M_b", 4.1, 1, 0, 0, 0, 0, 1);
	    case 10: ApplyAnimationEx(playerid, "DANCING", "dnce_M_c", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:eating(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/eating [1-3]");
	if (type < 1 || type > 3)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "FOOD", "EAT_Chicken", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:puke(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:gsign(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/gsign [1-15]");
	if (type < 1 || type > 15)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
		case 1: ApplyAnimation(playerid, "GHANDS", "gsign1", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "GHANDS", "gsign1LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "GHANDS", "gsign2", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "GHANDS", "gsign2LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "GHANDS", "gsign3", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "GHANDS", "gsign3LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "GHANDS", "gsign4", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "GHANDS", "gsign4LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 9: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.1, 0, 0, 0, 0, 0, 1);
		case 10: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.1, 0, 0, 0, 0, 0, 1);
		case 11: ApplyAnimation(playerid, "GHANDS", "gsign5LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 12: ApplyAnimation(playerid, "GANGS", "Invite_No", 4.1, 0, 0, 0, 0, 0, 1);
		case 13: ApplyAnimation(playerid, "GANGS", "Invite_Yes", 4.1, 0, 0, 0, 0, 0, 1);
		case 14: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 4.1, 0, 0, 0, 0, 0, 1);
		case 15: ApplyAnimation(playerid, "GANGS", "smkcig_prtl", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:chat(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/chat [1-6]");
	if (type < 1 || type > 6)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
		case 1: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:goggles(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:spray(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
 	ApplyAnimationEx(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}
CMD:throw(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:swipe(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:office(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/office [1-6]");
	if (type < 1 || type > 6)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
		case 1: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Bored_Loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Crash", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Drink", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Read", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Type_Loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Watch", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:kiss(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/kiss [1-6]");
	if (type < 1 || type > 6)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
		case 1: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:knife(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/knife [1-8]");
	if (type < 1 || type > 8)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
		case 1: ApplyAnimation(playerid, "KNIFE", "knife_1", 4.1, 0, 1, 1, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "KNIFE", "knife_2", 4.1, 0, 1, 1, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "KNIFE", "knife_3", 4.1, 0, 1, 1, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "KNIFE", "knife_4", 4.1, 0, 1, 1, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "KNIFE", "WEAPON_knifeidle", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Player", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Damage", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:cpr(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimation(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:scratch(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/scratch [1-4]");
	if (type < 1 || type > 4)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
    	case 1: ApplyAnimationEx(playerid, "SCRATCHING", "scdldlp", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SCRATCHING", "scdlulp", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "SCRATCHING", "scdrdlp", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "SCRATCHING", "scdrulp", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:point(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/point [1-4]");
	if (type < 1 || type > 4)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "PED", "ARRESTgun", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "SHOP", "ROB_Loop_Threat", 4.1, 1, 0, 0, 0, 0, 1);
    	case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "point_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "ON_LOOKERS", "Pointup_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:cheer(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/cheer [1-8]");
	if (type < 1 || type > 8)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
		case 1: ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "ON_LOOKERS", "shout_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "RIOT", "RIOT_CHANT", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "RIOT", "RIOT_shout", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "STRIP", "PUN_HOLLER", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:strip(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/strip [1-7]");
	if (type < 1 || type > 7)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
		case 1: ApplyAnimationEx(playerid, "STRIP", "strip_A", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "STRIP", "strip_B", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "STRIP", "strip_C", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "STRIP", "strip_D", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "STRIP", "strip_E", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "STRIP", "strip_F", 4.1, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "STRIP", "strip_G", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:wave(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/wave [1-3]");
	if (type < 1 || type > 3)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "PED", "endchat_03", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "KISSING", "gfwave2", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:smoke(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/smoke [1-3]");
	if (type < 1 || type > 3)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "SMOKING", "M_smk_drag", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "SMOKING", "M_smklean_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "SMOKING", "M_smkstnd_loop", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:reload(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/reload [1-4]");
	if (type < 1 || type > 4)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
		case 1: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "UZI", "UZI_reload", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "RIFLE", "rifle_load", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:taichi(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimationEx(playerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}
CMD:wank(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/wank [1-3]");
	if (type < 1 || type > 3)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
		case 1: ApplyAnimationEx(playerid, "PAULNMAC", "wank_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "PAULNMAC", "wank_in", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "PAULNMAC", "wank_out", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:cower(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimationEx(playerid, "PED", "cower", 4.1, 0, 0, 0, 1, 0, 1);
	return 1;
}
CMD:skate(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/skate [1-2]");
	if (type < 1 || type > 2)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
		case 1: ApplyAnimationEx(playerid, "SKATE", "skate_idle", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SKATE", "skate_run", 4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}
CMD:drunk(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimationEx(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1, 1);
	return 1;
}
CMD:cry(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimationEx(playerid, "GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}
CMD:tired(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/tired [1-2]");
	if (type < 1 || type > 2)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "PED", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:assis(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/assis [1-6]");
	if (type < 1 || type > 6)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
		case 1: ApplyAnimationEx(playerid, "CRIB", "PED_Console_Loop", 4.1, 1, 0, 0, 0, 0);
		case 2: ApplyAnimationEx(playerid, "INT_HOUSE", "LOU_In", 4.1, 0, 0, 0, 1, 0);
		case 3: ApplyAnimationEx(playerid, "MISC", "SEAT_LR", 4.1, 1, 0, 0, 0, 0);
		case 4: ApplyAnimationEx(playerid, "MISC", "Seat_talk_01", 4.1, 1, 0, 0, 0, 0);
		case 5: ApplyAnimationEx(playerid, "MISC", "Seat_talk_02", 4.1, 1, 0, 0, 0, 0);
		case 6: ApplyAnimationEx(playerid, "ped", "SEAT_down", 4.1, 0, 0, 0, 1, 0);
	}
	return 1;
}
CMD:crossarms(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/crossarms [1-4]");
	if (type < 1 || type > 4)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "GRAVEYARD", "prst_loopa", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "GRAVEYARD", "mrnM_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 0, 1);
	}
	return 1;
}
CMD:fucku(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	ApplyAnimation(playerid, "PED", "fucku", 4.1, 0, 0, 0, 0, 0);
	return 1;
}
CMD:walk(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid,"You can't to thids animations right now.");
	if (sscanf(params, "d", type))
	    return SendCommandMessage(playerid,"/walk [1-16]");
	if (type < 1 || type > 17)
	    return SendServerMessage(playerid,"Type invalid.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "FAT", "FatWalk", 4.1, 1, 1, 1, 1, 1, 1);
	    case 2: ApplyAnimationEx(playerid, "MUSCULAR", "MuscleWalk", 4.1, 1, 1, 1, 1, 1, 1);
	    case 3: ApplyAnimationEx(playerid, "PED", "WALK_armed", 4.1, 1, 1, 1, 1, 1, 1);
	    case 4: ApplyAnimationEx(playerid, "PED", "WALK_civi", 4.1, 1, 1, 1, 1, 1, 1);
	    case 5: ApplyAnimationEx(playerid, "PED", "WALK_fat", 4.1, 1, 1, 1, 1, 1, 1);
	    case 6: ApplyAnimationEx(playerid, "PED", "WALK_fatold", 4.1, 1, 1, 1, 1, 1, 1);
	    case 7: ApplyAnimationEx(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1, 1);
	    case 8: ApplyAnimationEx(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1, 1);
	    case 9: ApplyAnimationEx(playerid, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 1, 1);
	    case 10: ApplyAnimationEx(playerid, "PED", "WALK_old", 4.1, 1, 1, 1, 1, 1, 1);
	    case 11: ApplyAnimationEx(playerid, "PED", "WALK_wuzi", 4.1, 1, 1, 1, 1, 1, 1);
	    case 12: ApplyAnimationEx(playerid, "PED", "WOMAN_walkbusy", 4.1, 1, 1, 1, 1, 1, 1);
	    case 13: ApplyAnimationEx(playerid, "PED", "WOMAN_walkfatold", 4.1, 1, 1, 1, 1, 1, 1);
	    case 14: ApplyAnimationEx(playerid, "PED", "WOMAN_walknorm", 4.1, 1, 1, 1, 1, 1, 1);
	    case 15: ApplyAnimationEx(playerid, "PED", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1, 1);
	    case 16: ApplyAnimationEx(playerid, "PED", "WOMAN_walkshop", 4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}
CMD:stopanim(playerid, params[])
{
	if (!AnimationCheck(playerid))
	    return SendServerMessage(playerid, "You don't need to do this command right now.");
	ClearAnimations(playerid, 1);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	SendServerMessage(playerid, "You stop an animation.");
	return 1;
}