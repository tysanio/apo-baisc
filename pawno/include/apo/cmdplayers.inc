CMD:help(playerid, params[])
{
    SendServerMessage(playerid, "---List of commands for this server---");
    SendServerMessage(playerid, "/stats, /dwep, /swep, /pwep, /storage, /v, /createclan, /delcan, /animcmds, /dc");
    SendServerMessage(playerid, "To pickup and item crouch and press ~k~~CONVERSATION_NO~");
    return 1;
}
CMD:stats(playerid, params[])
{
	Dialog_Show(playerid, dSTATS,DIALOG_STYLE_MSGBOX,"Account stats","Your Stats\nLevel Admin: %d\nLevel VIP: %d\nScore: %d\n\
    Meat : %d\ninv2 : %d\ninv3 : %d\ninv4 : %d\ninv5 : %d\n\
    inv6 : %d\ninv7 : %d\ninv8 : %d\ninv9 : %d\ninv10 : %d\n\
    inv11 : %d\ninv12 : %d\ninv13 : %d\ninv14 : %d\ninv15 : %d\n\
    inv16 : %d\ninv17 : %d\ninv18 : %d\ninv19 : %d\ninv20 : %d\n\
    inv21 : %d\ninv22 : %d\ninv23 : %d\ninv24 : %d\ninv25 : %d\n\
    Korsfild CLan Exp: %d\n\
    ", "Close","",pData[playerid][Admin],pData[playerid][VIP],pData[playerid][Score],\
    pData[playerid][inv][1],pData[playerid][inv][2],pData[playerid][inv][3],pData[playerid][inv][4],pData[playerid][inv][5],\
    pData[playerid][inv][6],pData[playerid][inv][7],pData[playerid][inv][8],pData[playerid][inv][9],pData[playerid][inv][10],\
    pData[playerid][inv][11],pData[playerid][inv][12],pData[playerid][inv][13],pData[playerid][inv][14],pData[playerid][inv][15],\
    pData[playerid][inv][16],pData[playerid][inv][17],pData[playerid][inv][18],pData[playerid][inv][19],pData[playerid][inv][20],\
    pData[playerid][inv][21],pData[playerid][inv][22],pData[playerid][inv][23],pData[playerid][inv][24],pData[playerid][inv][25],\
    pData[playerid][clanexp][0]\
    );
	return 1;
}
CMD:dwep(playerid,params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_RED, "Need to be on foot.");
    new GunID = GetPlayerWeapon(playerid),GunAmmo = GetPlayerAmmo(playerid),buffer[50],GunNames[32];
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
        if(f > MAX_OBJ) return SendClientMessage(playerid, COLOR_RED, "You dont have a weapon on you.");
		RemovePlayerWeapon(playerid, GunID);
		dGunData[f][ObjData][0] = GunID;
		dGunData[f][ObjData][1] = GunAmmo;
        GetWeaponName(dGunData[f][ObjData][0], GunNames, sizeof(GunNames));
        GetPlayerPos(playerid, dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2]);
        dGunData[f][ObjID] = CreateObject(GunObjects[GunID], dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2]-1, 93.7, 120.0, 120.0);
		format(buffer, sizeof(buffer), "You have dropped a %s.", GunNames);
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `dropwep` (`posx`,`posy`,`posz`,`posrx`,`posry`,`posrz`,`gunid`,`gunammo`) VALUES ('%.4f','%.4f','%.4f', 93.7, 120.0, 120.0,'%d','%d')", dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2]-1,GunID,GunAmmo);
	    mysql_tquery(mysql, query, "", "");
    }
    return 1;
}
CMD:swep(playerid,params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_RED, "Need to be on foot.");
    new f = MAX_OBJ+1,buffer[50],GunNames[32];
	for(new a = 0; a < MAX_OBJ; a++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, dGunData[a][ObjPos][0], dGunData[a][ObjPos][1], dGunData[a][ObjPos][2]))
	    {
	        f = a;
	        break;
	    }
	}
	if(f > MAX_OBJ) return SendClientMessage(playerid, COLOR_RED, "No weapon is near you, please try again.");
	GetWeaponName(dGunData[f][ObjData][0], GunNames, sizeof(GunNames));
	format(buffer, sizeof(buffer), "You have found a %s type /pwep to pick it up.", GunNames);
  	SendClientMessage(playerid, COLOR_GREEN, buffer);
    return 1;
}
CMD:pwep(playerid,params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_RED, "Need to be on foot.");
    new f = MAX_OBJ+1,buffer[50],GunNames[32];
	for(new a = 0; a < MAX_OBJ; a++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, dGunData[a][ObjPos][0], dGunData[a][ObjPos][1], dGunData[a][ObjPos][2]))
	    {
	        f = a;
	        break;
	    }
	}
	if(f > MAX_OBJ) return SendClientMessage(playerid, COLOR_RED, "You are not near a weapon that you can pick up.");
    //ici le delete
    mysql_format(mysql,query, sizeof(query), "DELETE FROM `dropwep` WHERE CONCAT(`dropwep`.`posx`) = %.4f AND CONCAT(`dropwep`.`gunid`) = %d",dGunData[f][ObjPos][0],dGunData[f][ObjData][0]);
    mysql_tquery(mysql, query);
	DestroyObject(dGunData[f][ObjID]);
	GetWeaponName(dGunData[f][ObjData][0], GunNames, sizeof(GunNames));
	GivePlayerWeapon(playerid, dGunData[f][ObjData][0], dGunData[f][ObjData][1]);
	dGunData[f][ObjPos][0] = 0.0;
	dGunData[f][ObjPos][1] = 0.0;
	dGunData[f][ObjPos][2] = 0.0;
	dGunData[f][ObjID] = -1;
	dGunData[f][ObjData][0] = 0;
	dGunData[f][ObjData][1] = 0;
	format(buffer, sizeof(buffer), "You have picked up a %s.", GunNames);
  	SendClientMessage(playerid, COLOR_GREEN, buffer);
    return 1;
}
CMD:storage(playerid, params[])
{
    static id = -1;
    if ((id = Storage_Nearest(playerid)) != -1)
    {
        Dialog_Show(playerid, dStorage,DIALOG_STYLE_MSGBOX,"Storage","Size: %d\nLock: %d\n\
        inv1 : %d\ninv2 : %d\ninv3 : %d\ninv4 : %d\ninv5 : %d\n\
        inv6 : %d\ninv7 : %d\ninv8 : %d\ninv9 : %d\ninv10 : %d\n\
        inv11 : %d\ninv12 : %d\ninv13 : %d\ninv14 : %d\ninv15 : %d\n\
        inv16 : %d\ninv17 : %d\ninv18 : %d\ninv19 : %d\ninv20 : %d\n\
        inv21 : %d\ninv22 : %d\ninv23 : %d\ninv24 : %d\ninv25 : %d\n\
        ", "Close","",dStorage[id][typesize],dStorage[id][lock],\
        dStorage[id][inv][1],dStorage[id][inv][2],dStorage[id][inv][3],dStorage[id][inv][4],dStorage[id][inv][5],\
        dStorage[id][inv][6],dStorage[id][inv][7],dStorage[id][inv][8],dStorage[id][inv][9],dStorage[id][inv][10],\
        dStorage[id][inv][11],dStorage[id][inv][12],dStorage[id][inv][13],dStorage[id][inv][14],dStorage[id][inv][15],\
        dStorage[id][inv][16],dStorage[id][inv][17],dStorage[id][inv][18],dStorage[id][inv][19],dStorage[id][inv][20],\
        dStorage[id][inv][21],dStorage[id][inv][22],dStorage[id][inv][23],dStorage[id][inv][24],dStorage[id][inv][25]);
    }
    return 1;
}
CMD:v(playerid, params[])
{
    new bool:found = false, list[512];
    list = "ID\tVehicle\n";
    foreach(new i : PrivateVehicles[playerid])
    {
        if(!strcmp(vInfo[i][vehOwner], GetName(playerid)))
        {
            found = true;
            format(list, sizeof(list), "%s%d\t%s\n", list, i, vInfo[i][vehName]);
        }
    }
    if(found == true) return Dialog_Show(playerid, DIALOG_VEHICLES, DIALOG_STYLE_TABLIST_HEADERS, "Vehicles", list, "Select", "Close");
    else return Dialog_Show(playerid, 2114, DIALOG_STYLE_MSGBOX, "Vehicles", "{FF0000}No vehicles found", "Close", "");
}
CMD:createclan(playerid, params[])
{
	new  clanname1[26];
	if(sscanf(params,"s[26]",clanname1)) return SendClientMessage(playerid, -1, "Usage: /createclan (name of the clan) [2-25 character max]");
	mysql_format(mysql, query, sizeof(query),"SELECT * FROM `clans` WHERE `Owner` = '%e'  LIMIT 1", GetName(playerid));
    mysql_tquery(mysql, query, "onclancheck", "i", playerid);
    format(clannamec, sizeof(clannamec), "%s",clanname1);
	return 1;
}
CMD:delclan(playerid, params[])
{
    mysql_format(mysql,query, sizeof(query), "DELETE FROM `clans` WHERE `Owner` = '%e'", GetName(playerid));
	mysql_tquery(mysql, query);
    foreach(Player, i)
    {
        if (IsValidDynamicPickup(clans[i][pickup][0]))
        DestroyDynamicPickup(clans[i][pickup][0]);
        if (IsValidDynamicPickup(clans[i][pickup][1]))
        DestroyDynamicPickup(clans[i][pickup][1]);
        if (IsValidDynamicPickup(clans[i][pickup][2]))
        DestroyDynamicPickup(clans[i][pickup][2]);
    }
    SendServerMessage(playerid, "You're clan has been disband");
    return 1;
}
CMD:delstorage(playerid, params[])
{
    static id = -1;
    if ((id = Storage_Nearest(playerid)) != -1)
    {
        if(!strcmp(dStorage[id][Username], GetName(playerid)))
        {
            mysql_format(mysql,query, sizeof(query), "DELETE FROM `storage` WHERE CONCAT(`storage`.`posx`) = %.2f AND CONCAT(`storage`.`posy`) = %.2f AND CONCAT(`storage`.`posz`) = %.2f",dStorage[id][Pos][0],dStorage[id][Pos][1],dStorage[id][Pos][2]);
            mysql_tquery(mysql, query);
            if (IsValidDynamicObject(dStorage[id][objects])) DestroyDynamicObject(dStorage[id][objects]);
        }
        else return SendClientMessage(playerid, COLOR_RED, "This storage is not your's!");
    }
    return 1;
}
CMD:createstorage(playerid,params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_RED, "Need to be on foot.");
    new type;
	if (sscanf(params, "d",type))
 	{
	 	SendServerMessage(playerid, "/createstorage [type size 1-4] ");
		return 1;
	}
	if ((type < 1 || type > 4))
	    return SendServerMessage(playerid, "Invalid type size [1-4]");
    for (new f = 0; f < MAX_STORAGE; f ++)
    {
        GetPlayerPos(playerid, dStorage[f][Pos][0], dStorage[f][Pos][1], dStorage[f][Pos][2]);
        switch(type)
        {
            case 1: dStorage[f][objects] = CreateDynamicObject(2694, dStorage[f][Pos][0], dStorage[f][Pos][1]+2, dStorage[f][Pos][2], 0, 0.0, 0.0, -1, -1, -1, 200.0, 100.0);
            case 2: dStorage[f][objects] = CreateDynamicObject(1271, dStorage[f][Pos][0], dStorage[f][Pos][1]+2, dStorage[f][Pos][2], 0, 0.0, 0.0, -1, -1, -1, 200.0, 100.0);
            case 3: dStorage[f][objects] = CreateDynamicObject(3798, dStorage[f][Pos][0], dStorage[f][Pos][1]+2, dStorage[f][Pos][2], 0, 0.0, 0.0, -1, -1, -1, 200.0, 100.0);
            case 4: dStorage[f][objects] = CreateDynamicObject(3799, dStorage[f][Pos][0], dStorage[f][Pos][1]+2, dStorage[f][Pos][2], 0, 0.0, 0.0, -1, -1, -1, 200.0, 100.0);
        }
        mysql_format(mysql, query, sizeof(query), "INSERT INTO `storage` (`typesize`,`lock`,`posx`,`posy`,`posz`,`posrx`,`posry`,`posrz`,`Username`) VALUES ('%d',0,'%.4f','%.4f','%.4f', 0, 0, 0, '%e')",type, dStorage[f][Pos][0], dStorage[f][Pos][1], dStorage[f][Pos][2],GetName(playerid));
        mysql_tquery(mysql, query, "", "");
	}
    return 1;
}
CMD:editstorage(playerid, params[])
{
    static id = -1;
    if ((id = Storage_Nearest(playerid)) != -1)
    {
        if(!strcmp(dStorage[id][Username], GetName(playerid)))
        {
			ResetEditing(playerid);
			EditDynamicObject(playerid, dStorage[id][objects]);
			pData[playerid][pEditobjects] = id;
			pData[playerid][pEditType] = 2;
			SendServerMessage(playerid, "You are now editing the storage position.");
			return 1;
		}
        else return SendClientMessage(playerid, COLOR_RED, "This storage is not your's!");
    }
	return 1;
}
CMD:sobject(playerid,params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
    new f = MAX_SPAWNPOS+1;
	for(new a = 0; a < MAX_SPAWNPOS; a++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, dspawnpos[a][Pos][0], dspawnpos[a][Pos][1], dspawnpos[a][Pos][2]))
	    {
	        f = a;
	        break;
	    }
	}
	if(f > MAX_SPAWNPOS) return SendClientMessage(playerid, COLOR_RED, "No object is near you, please try again.");
  	SendClientMessage(playerid, COLOR_GREEN, "You have found an object!");
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
//anims
CMD:animcmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "ANIMATION:{FFFFFF} /dance, /handsup, /bat, /slap, /bar, /wash, /lay, /workout, /blowjob, /bomb.");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "ANIMATION:{FFFFFF} /carry, /crack, /sleep, /jump, /deal, /dancing, /eating, /puke, /gsign, /chat.");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "ANIMATION:{FFFFFF} /goggles, /spray, /throw, /swipe, /office, /kiss, /knife, /cpr, /scratch, /point.");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "ANIMATION:{FFFFFF} /cheer, /wave, /strip, /smoke, /reload, /taichi, /wank, /cower, /skate, /drunk.");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "ANIMATION:{FFFFFF} /cry, /tired, /assis, /crossarms, /fucku, /walk, /piss, /stopanim.");
	return 1;
}
CMD:dance(playerid, params[])
{
	new type;

	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/dance [1-4]");
	if (type < 1 || type > 4)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	return 1;
}
CMD:piss(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	SetPlayerSpecialAction(playerid, 68);
	return 1;
}
CMD:bat(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/bat [1-5]");
	if (type < 1 || type > 5)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "BASEBALL", "Bat_M", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:bar(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/bar [1-8]");
	if (type < 1 || type > 8)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:lay(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/lay [1-5]");
	if (type < 1 || type > 5)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/workout [1-7]");
	if (type < 1 || type > 7)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/blowjob [1-4]");
	if (type < 1 || type > 4)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");

	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:carry(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/carry [1-6]");
	if (type < 1 || type > 6)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/crack [1-6]");
	if (type < 1 || type > 6)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/sleep [1-2]");
	if (type < 1 || type > 2)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth4", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "CRACK", "crckidle4", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}
CMD:jump(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "DODGE", "Crush_Jump", 4.1, 0, 1, 1, 0, 0, 1);
	return 1;
}
CMD:deal(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/deal [1-6]");
	if (type < 1 || type > 6)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/dancing [1-10]");
	if (type < 1 || type > 10)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/eating [1-3]");
	if (type < 1 || type > 3)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");

	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:gsign(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/gsign [1-15]");
	if (type < 1 || type > 15)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/chat [1-6]");
	if (type < 1 || type > 6)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:spray(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
 	ApplyAnimationEx(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}
CMD:throw(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:swipe(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:office(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/office [1-6]");
	if (type < 1 || type > 6)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/kiss [1-6]");
	if (type < 1 || type > 6)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/knife [1-8]");
	if (type < 1 || type > 8)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:scratch(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/scratch [1-4]");
	if (type < 1 || type > 4)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/point [1-4]");
	if (type < 1 || type > 4)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/cheer [1-8]");
	if (type < 1 || type > 8)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/strip [1-7]");
	if (type < 1 || type > 7)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/wave [1-3]");
	if (type < 1 || type > 3)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/smoke [1-3]");
	if (type < 1 || type > 3)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/reload [1-4]");
	if (type < 1 || type > 4)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimationEx(playerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}
CMD:wank(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/wank [1-3]");
	if (type < 1 || type > 3)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimationEx(playerid, "PED", "cower", 4.1, 0, 0, 0, 1, 0, 1);
	return 1;
}
CMD:skate(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/skate [1-2]");
	if (type < 1 || type > 2)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimationEx(playerid, "SKATE", "skate_idle", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SKATE", "skate_run", 4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}
CMD:drunk(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimationEx(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1, 1);
	return 1;
}
CMD:cry(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimationEx(playerid, "GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}
CMD:tired(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/tired [1-2]");
	if (type < 1 || type > 2)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/assis [1-6]");
	if (type < 1 || type > 6)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/crossarms [1-4]");
	if (type < 1 || type > 4)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "PED", "fucku", 4.1, 0, 0, 0, 0, 0);
	return 1;
}
CMD:walk(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"/walk [1-16]");
	if (type < 1 || type > 17)
	    return SendClientMessage(playerid,COLOR_LIGHTBLUE,"Invalide type spécifié.");
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
	    return SendServerMessage(playerid, "Tu a pas besoin de cette commande maintenant.");
	ClearAnimations(playerid, 1);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	SendServerMessage(playerid, "Vous avez stop une animation.");
	return 1;
}
