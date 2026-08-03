script AutoCleanExpiredBans()
{
    mysql_format(mysql, query, sizeof(query),"DELETE FROM bans WHERE duration > 0 AND UNIX_TIMESTAMP() > (ban_time + duration * 60)");
    mysql_tquery(mysql, query, "", "");
}
script OnCheckPlayerBan(playerid)
{
    TogglePlayerSpectating(playerid, true);
    SetPlayerCameraPos(playerid,6590.942871,-7440.374511,5.358576);
    SetPlayerCameraLookAt(playerid,6610.283203,-7447.338378,7.408573);
    if(cache_num_rows() > 0)
    {
        new duration, ban_time, reason[128], value[64];
        cache_get_field_content(0, "duration", value); duration = strval(value);
        cache_get_field_content(0, "ban_time", value); ban_time = strval(value);
        cache_get_field_content(0, "reason", reason);
        if(duration == 0 || gettime() < ban_time + (duration * 60))
        {
			Dialog_Show(playerid,BANNED,DIALOG_STYLE_MSGBOX, "You are banned from this server.\nReason: %s\nType: %s","Ok", "",reason, (duration) ? ("Permanent") : ("Temporary"));
            Kick(playerid);
        }
        else
        {
            // expired: auto-remove
            new name[MAX_PLAYER_NAME];
            GetPlayerName(playerid, name, sizeof(name));
            mysql_format(mysql, query, sizeof(query), "DELETE FROM bans WHERE player_name = '%e'", name);
            mysql_tquery(mysql, query, "", "");
        }
    }
    else
    {
    	mysql_format(mysql, query, sizeof(query),"SELECT `IP`, `Password`, `ID` FROM `players` WHERE `Username` = '%e' LIMIT 1", Name[playerid]);
        mysql_tquery(mysql, query, "OnAccountCheck", "i", playerid);
    }
}
script OnShowBanList(playerid)
{
    new count = cache_num_rows(),name[24], reason[64], admin[24], ban_time, duration,output[1024], line[160], remaining_sec, hours, minutes, val[64];
    if(count == 0)
        return SendClientMessage(playerid, COLOR_GREEN, "[BanList] No active temporary bans.");
    for(new i = 0; i < count; i++)
    {
        cache_get_field_content(i, "player_name", name, sizeof(name));
        cache_get_field_content(i, "reason", reason, sizeof(reason));
        cache_get_field_content(i, "admin_name", admin, sizeof(admin));
        cache_get_field_content(i, "ban_time", val); ban_time = strval(val);
        cache_get_field_content(i, "duration", val); duration = strval(val);
        remaining_sec = (ban_time + duration * 60) - gettime();
        hours = remaining_sec / 3600;
        minutes = (remaining_sec % 3600) / 60;
        format(line, sizeof(line), "%s | Admin: %s | Remaining: %02d:%02d\nReason: %s\n\n",
            name, admin, hours, minutes, reason);
        strcat(output, line);
    }
    Dialog_Show(playerid,BANNED,DIALOG_STYLE_MSGBOX,"Active Temp Bans", output, "Close", "");
    return 1;
}
script OnPlayerTargetActor(playerid, newtarget, oldtarget)
{
    if (newtarget == missionactor[0])
    {
        ShowMenuForPlayer(Armory, playerid);
        TogglePlayerControllable(playerid, 0);
    }
    if (newtarget == missionactor[1]) //canibal
    {
        Dialog_Show(playerid, Missionclan00, DIALOG_STYLE_LIST, "Mission", "Go get some meat!\nChop Chop!\nGo see what going on there!\nSabotage Antenna\nQuest 5\n{0f5900}Quest validation.{FFFFFF}\nLevel Up", "OK", "Quit");
    }
    if (newtarget == missionactor[2]) //police
    {
        Dialog_Show(playerid, Missionclan10, DIALOG_STYLE_LIST, "Mission", "Quest 1\n{0f5900}Quest validation.{FFFFFF}\nQuest 2\n{0f5900}Quest validation.{FFFFFF}\nGo see what going on there!\nQuest 4\n{0f5900}Quest validation.{FFFFFF}\nQuest 5\n{0f5900}Quest validation.{FFFFFF}\nLevel Up", "OK", "Quit");
    }
    if (newtarget == missionactor[3])
    {
        ShowMenuForPlayer(PoliceArmory, playerid);
        TogglePlayerControllable(playerid, 0);
    }
    if (newtarget == missionactor[4]) //army
    {
        Dialog_Show(playerid, Missionclan20, DIALOG_STYLE_LIST, "Mission", "Requesting Food and water.\nRepair the antenna.\nGo see what going on there!\nQuest 4\n{0f5900}Quest validation.{FFFFFF}\nQuest 5\n{0f5900}Quest validation.{FFFFFF}\nLevel Up", "OK", "Quit");
    }
    if (newtarget == missionactor[5])
    {
        Dialog_Show(playerid, Missionclan22, DIALOG_STYLE_LIST, "Armory", "", "OK", "Quit");
    }
    if (newtarget == missionactor[6] && pData[playerid][Score] >= 5) //secret army
    {
        Dialog_Show(playerid, Missionclan222, DIALOG_STYLE_MSGBOX, "Secret Quest", "You seems a good call.\nCan you check on my sister?\nShe is probably somewhere with a bunch of wierdos.\nPlease go look out for here.", "OK", "Quit");
		missioncheck = 333;
		return 1;
    }
    if (newtarget == missionactor[7])
    {
		if(IsMining[playerid] == 1) return SendServerMessage(playerid,"You are trying to convert ores whitout finishing to mine it!");
		new ores = pData[playerid][inv][7];
		if (ores <= 0)
			return SendServerMessage(playerid, "You have no ores to convert.");
		new iron = ores / 2,gold = ores / 6;
		if (pData[playerid][inv][8] + iron > GetBackpackCapacity(playerid))
			return SendServerMessage(playerid, "Not enough backpack space for iron.");
		if (pData[playerid][inv][9] + gold > GetBackpackCapacity(playerid))
			return SendServerMessage(playerid, "Not enough backpack space for gold.");
		pData[playerid][inv][8] += iron;
		pData[playerid][inv][9] += gold;
		pData[playerid][inv][7] = 0;
		SendServerMessage(playerid,"You convert %d ores and received %d iron(s) and %d gold(s).",ores, iron, gold);
		return 1;
    }
    if (oldtarget != INVALID_ACTOR_ID) {ClearActorAnimations(oldtarget);}
    return 1;
}
script OnAccountLoad(playerid)
{
	format(query, sizeof(query), "UPDATE `players` SET `lasttime` = '%d' WHERE `Username` = '%s'", gettime(),Name[playerid]);
	mysql_tquery(mysql, query, "", "");
 	pData[playerid][Admin] = cache_get_field_content_int(0, "Admin"); //we're getting a field 4 from row 0. And since it's an integer, we use cache_get_row_int
 	pData[playerid][VIP] = cache_get_field_content_int(0, "VIP"); //Above
	pData[playerid][Life] =	cache_get_field_content_float(0, "Life");
	pData[playerid][Armor]  =	cache_get_field_content_float(0, "Armor");
    pData[playerid][skin]   =	cache_get_field_content_int(0, "skin");
    pData[playerid][Pos][0] =	cache_get_field_content_float(0, "posx");
    pData[playerid][Pos][1] =	cache_get_field_content_float(0, "posy");
    pData[playerid][Pos][2] =	cache_get_field_content_float(0, "posz");
    pData[playerid][idclan]   =	cache_get_field_content_int(0, "idclan");
    pData[playerid][Food]   =	cache_get_field_content_int(0, "food");
    pData[playerid][Water]   =	cache_get_field_content_int(0, "water");
    pData[playerid][clanrank]   =	cache_get_field_content_int(0, "clanrank");
    pData[playerid][interior]   =	cache_get_field_content_int(0, "interior");
	pData[playerid][clanexp][0] =	cache_get_field_content_int(0, "clanexp0");
    pData[playerid][clanexp][1] =	cache_get_field_content_int(0, "clanexp1");
    pData[playerid][clanexp][2] =	cache_get_field_content_int(0, "clanexp2");
    pData[playerid][clanexp][3] =	cache_get_field_content_int(0, "clanexp3");
    pData[playerid][clanexp][4] =	cache_get_field_content_int(0, "clanexp4");
    pData[playerid][inv][0] =	cache_get_field_content_int(0, "inv0");
    pData[playerid][inv][1] =	cache_get_field_content_int(0, "inv1");
    pData[playerid][inv][2] =	cache_get_field_content_int(0, "inv2");
    pData[playerid][inv][3] =	cache_get_field_content_int(0, "inv3");
    pData[playerid][inv][4] =	cache_get_field_content_int(0, "inv4");
    pData[playerid][inv][5] =	cache_get_field_content_int(0, "inv5");
    pData[playerid][inv][6] =	cache_get_field_content_int(0, "inv6");
    pData[playerid][inv][7] =	cache_get_field_content_int(0, "inv7");
    pData[playerid][inv][8] =	cache_get_field_content_int(0, "inv8");
    pData[playerid][inv][9] =	cache_get_field_content_int(0, "inv9");
    pData[playerid][inv][10] =	cache_get_field_content_int(0, "inv10");
    pData[playerid][inv][11] =	cache_get_field_content_int(0, "inv11");
    pData[playerid][inv][12] =	cache_get_field_content_int(0, "inv12");
    pData[playerid][inv][13] =	cache_get_field_content_int(0, "inv13");
    pData[playerid][inv][14] =	cache_get_field_content_int(0, "inv14");
    pData[playerid][inv][15] =	cache_get_field_content_int(0, "inv15");
    pData[playerid][inv][16] =	cache_get_field_content_int(0, "inv16");
    pData[playerid][inv][17] =	cache_get_field_content_int(0, "inv17");
    pData[playerid][inv][18] =	cache_get_field_content_int(0, "inv18");
    pData[playerid][inv][19] =	cache_get_field_content_int(0, "inv19");
    pData[playerid][inv][20] =	cache_get_field_content_int(0, "inv20");
    pData[playerid][inv][21] =	cache_get_field_content_int(0, "inv21");
    pData[playerid][inv][22] =	cache_get_field_content_int(0, "inv22");
    pData[playerid][inv][23] =	cache_get_field_content_int(0, "inv23");
    pData[playerid][inv][24] =	cache_get_field_content_int(0, "inv24");
    pData[playerid][inv][25] =	cache_get_field_content_int(0, "inv25");
	cache_get_field_content(0, "discordid", pData[playerid][pDiscordID],mysql,24);
 	pData[playerid][Score] = cache_get_field_content_int(0, "Score"); 
	if(pData[playerid][Life] <= 0.0) pData[playerid][Life] = 100.0;
	SetPlayerHealth(playerid,pData[playerid][Life]);	
	if(pData[playerid][Pos][0] == 0 && pData[playerid][Pos][1] == 0 && pData[playerid][Pos][2] == 0)
	{
		switch (random(8))
		{
			case 0: SetSpawnInfo(playerid, 0, pData[playerid][skin], -722.1279,2582.5281,70.3687,0.0,0,0,0,0,0,0);
			case 1: SetSpawnInfo(playerid, 0, pData[playerid][skin], -884.5097,2761.1423,46.0000,0.0,0,0,0,0,0,0);
			case 2: SetSpawnInfo(playerid, 0, pData[playerid][skin], -209.0710,2771.4448,62.3780,0.0,0,0,0,0,0,0);
			case 3: SetSpawnInfo(playerid, 0, pData[playerid][skin], 84.2828,2450.4319,16.4844,0.0,0,0,0,0,0,0);
			case 4: SetSpawnInfo(playerid, 0, pData[playerid][skin], 413.4136,2585.2964,16.7334,0.0,0,0,0,0,0,0);
			case 5: SetSpawnInfo(playerid, 0, pData[playerid][skin], 145.4671,2209.1653,35.5056,0.0,0,0,0,0,0,0);
			case 6: SetSpawnInfo(playerid, 0, pData[playerid][skin], 547.4021,2273.4055,34.8501,0.0,0,0,0,0,0,0);
			case 7: SetSpawnInfo(playerid, 0, pData[playerid][skin], 209.4851,2617.1570,16.6514,0.0,0,0,0,0,0,0);
		}
	}
	else SetSpawnInfo(playerid, 0, pData[playerid][skin], pData[playerid][Pos][0],pData[playerid][Pos][1],pData[playerid][Pos][2],0.0,0,0,0,0,0,0);
	KillTimer(LoginCameraTimer[playerid]);
	TogglePlayerSpectating(playerid, 0);
	//SpawnPlayer(playerid);
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
	SendServerMessage(playerid,"Successfully logged in"); //tell them that they have successfully logged in
    //weapons
	new szTmp[64];
    for(new i = 0; i <= 12; i++)
	{
	    format(szTmp, sizeof(szTmp), "Weap%d", i);
        pData[playerid][Guns][i] = cache_get_field_content_int(0 , szTmp);
    	format(szTmp, sizeof(szTmp), "AWeap%d", i);
        pData[playerid][Ammo][i] = cache_get_field_content_int(0 , szTmp);
		AllowWeapon(playerid, pData[playerid][Guns][i],pData[playerid][Ammo][i]);
	}
    SendServerMessage(playerid,"Hello player this server is on very-very early stage keep that in mind");
    SendServerMessage(playerid,"Command /help and /howto at your service!");
    ShowPlayerProgressBar(playerid, pData[playerid][Foodbar]);
    ShowPlayerProgressBar(playerid, pData[playerid][Waterbar]);
    SetPlayerProgressBarColour(playerid, pData[playerid][Foodbar], 0x33CC33BB);
    SetPlayerProgressBarColour(playerid, pData[playerid][Waterbar], 0x2641FEBB);
    SetPlayerProgressBarValue(playerid, pData[playerid][Foodbar], pData[playerid][Food]);
    SetPlayerProgressBarValue(playerid, pData[playerid][Waterbar], pData[playerid][Water]);
	CheckPlayerWeapons(playerid);
	return 1;
}

script SavePlayerData(playerid)
{
	//vie armure pos
    new intint = GetPlayerInterior(playerid),tmpPlayerWeapons[13][2],tmpString[64];
    for(new i = 0; i <= 12; i++)
	{
	    GetPlayerWeaponData(playerid, i, tmpPlayerWeapons[i][0], tmpPlayerWeapons[i][1]);
	}
	GetPlayerHealth(playerid,pData[playerid][Life]);
	GetPlayerArmour(playerid,pData[playerid][Armor]);
    GetPlayerPos(playerid,pData[playerid][Pos][0],pData[playerid][Pos][1],pData[playerid][Pos][2]);
	mysql_format(mysql, query, sizeof(query), "UPDATE `players` SET `IP`='%s', `Admin`=%d, `VIP`=%d, `Score`=%d,`Life` = %.4f,`Armor` = %.4f,`skin`=%d,`food`=%d,`water`=%d, `posx` = %.4f,`posy` = %.4f,`posz` = %.4f,`interior`=%d,`idclan`=%d,`clanrank`=%d,\
    `clanexp0`=%d,`clanexp1`=%d,`clanexp2`=%d,`clanexp3`=%d,`clanexp4`=%d,`inv0`=%d,`inv1`=%d,`inv2`=%d,`inv3`=%d,`inv4`=%d,`inv5`=%d,`inv6`=%d,`inv7`=%d,`inv8`=%d,`inv9`=%d,\
	`inv10`=%d,`inv11`=%d,`inv12`=%d,`inv13`=%d,`inv14`=%d,`inv15`=%d,`inv16`=%d,`inv17`=%d,`inv18`=%d,`inv19`=%d,\
    `inv20`=%d,`inv21`=%d,`inv22`=%d,`inv23`=%d,`inv24`=%d,`inv25`=%d \
    WHERE `ID`=%d",\
	IP[playerid], pData[playerid][Admin], pData[playerid][VIP], GetPlayerScore(playerid),pData[playerid][Life],pData[playerid][Armor],pData[playerid][skin],pData[playerid][Water],\
    pData[playerid][Food],pData[playerid][Pos][0],pData[playerid][Pos][1],pData[playerid][Pos][2],intint,pData[playerid][idclan],pData[playerid][clanrank],\
    pData[playerid][clanexp][0],pData[playerid][clanexp][1],pData[playerid][clanexp][2],pData[playerid][clanexp][3],pData[playerid][clanexp][4],\
    pData[playerid][inv][0],pData[playerid][inv][1],pData[playerid][inv][2],pData[playerid][inv][3],pData[playerid][inv][4],pData[playerid][inv][5],\
    pData[playerid][inv][6],pData[playerid][inv][7],pData[playerid][inv][8],pData[playerid][inv][9],pData[playerid][inv][10],\
    pData[playerid][inv][11],pData[playerid][inv][12],pData[playerid][inv][13],pData[playerid][inv][14],pData[playerid][inv][15],\
    pData[playerid][inv][16],pData[playerid][inv][17],pData[playerid][inv][18],pData[playerid][inv][19],pData[playerid][inv][20],\
    pData[playerid][inv][21],pData[playerid][inv][22],pData[playerid][inv][23],pData[playerid][inv][24],pData[playerid][inv][25],\
	pData[playerid][ID]);
	mysql_tquery(mysql, query, "", "");
    for(new i = 0; i <= 12; i++)
	{
	    format(tmpString, sizeof(tmpString), "Weap%d", i);
    	mysql_format(mysql, query, sizeof(query), "UPDATE `players` SET `%s`=%d WHERE `ID`=%d" ,tmpString , tmpPlayerWeapons[i][0] , pData[playerid][ID]);
    	mysql_tquery(mysql, query, "", "");
    	format(tmpString, sizeof(tmpString), "AWeap%d", i);
    	mysql_format(mysql, query, sizeof(query), "UPDATE `players` SET `%s`=%d WHERE `ID`=%d" ,tmpString , tmpPlayerWeapons[i][1] , pData[playerid][ID]);
    	mysql_tquery(mysql, query, "", "");
	}
}

script OnAccountCheck(playerid)
{
	new rows, fields; //a variable that will be used to retrieve rows and fields in the database.
	cache_get_data(rows, fields, mysql);//let's get the rows and fields from the database.
	if(rows) //if there is row
	{
		cache_get_field_content(0, "IP", IP[playerid], mysql, 16);
		new newIP[16];
		GetPlayerIp(playerid, newIP, 16);
		IsPlayerRegisterd[playerid] = 1;
		(!strlen(IP[playerid]) || strcmp(IP[playerid], newIP, true));
		cache_get_field_content(0, "Password", pData[playerid][Password], mysql, 129);
		pData[playerid][ID] = cache_get_field_content_int(0, "ID"); //now let's load player's ID into pData[playerid][ID] so we can use it later
		Dialog_Show(playerid, dLOGIN, DIALOG_STYLE_PASSWORD, "Login", "In order to play, you need to login", "Login", "Quit");
	}
	else //if we didn't find any rows from the database, that means, no accounts were found
	{
		Dialog_Show(playerid, dREGISTER, DIALOG_STYLE_PASSWORD, "Register", "In order to play, you need to register.", "Register", "Quit");
	}
	return 1;
}

script OnAccountRegister(playerid)
{
    pData[playerid][ID] = cache_insert_id(); //loads the ID of the player in the variable once they registered.
    printf("New account registered. ID: %d", pData[playerid][ID]); //just for debugging.
	pData[playerid][Life] = 100;
	pData[playerid][Armor] = 0;
	SetPlayerHealth(playerid,100);
	SetPlayerArmour(playerid,0);
    ResetPlayerWeapons(playerid);
    SetPlayerHealth(playerid,pData[playerid][Life]);
	SetPlayerArmour(playerid,pData[playerid][Armor]);
    pData[playerid][skin] = Skinsskins[random(sizeof(Skinsskins))];
	SetPlayerSkin(playerid, pData[playerid][skin]);
    mysql_format(mysql, query, sizeof(query),"SELECT `IP`, `Password`, `ID` FROM `players` WHERE `Username` = '%e' LIMIT 1", Name[playerid]);
    mysql_tquery(mysql, query, "OnAccountCheck", "i", playerid);
	//SpawnPlayer(playerid);
    return 1;
}
script loadspawnpos()
{
    new rows,fields;
    cache_get_data(rows, fields);
    for (new f = 0; f < rows; f ++) if (f < MAX_SPAWNPOS)
    {
        dspawnpos[f][Pos][0] = cache_get_field_content_float(f,"posx");
        dspawnpos[f][Pos][1] = cache_get_field_content_float(f,"posy");
        dspawnpos[f][Pos][2] = cache_get_field_content_float(f,"posz");
		DestroyDynamicObject(dspawnpos[f][Objects]);
        switch(random(6))
        {
            case 0: dspawnpos[f][Objects] = CreateDynamicObject(1575, dspawnpos[f][Pos][0], dspawnpos[f][Pos][1], dspawnpos[f][Pos][2]-1.0, 0, 0, 0,-1,-1,-1);
            case 1: dspawnpos[f][Objects] = CreateDynamicObject(1576, dspawnpos[f][Pos][0], dspawnpos[f][Pos][1], dspawnpos[f][Pos][2]-1.0, 0, 0, 0,-1,-1,-1);
            case 2: dspawnpos[f][Objects] = CreateDynamicObject(1577, dspawnpos[f][Pos][0], dspawnpos[f][Pos][1], dspawnpos[f][Pos][2]-1.0, 0, 0, 0,-1,-1,-1);
            case 3: dspawnpos[f][Objects] = CreateDynamicObject(1578, dspawnpos[f][Pos][0], dspawnpos[f][Pos][1], dspawnpos[f][Pos][2]-1.0, 0, 0, 0,-1,-1,-1);
            case 4: dspawnpos[f][Objects] = CreateDynamicObject(1579, dspawnpos[f][Pos][0], dspawnpos[f][Pos][1], dspawnpos[f][Pos][2]-1.0, 0, 0, 0,-1,-1,-1);
            case 5: dspawnpos[f][Objects] = CreateDynamicObject(1580, dspawnpos[f][Pos][0], dspawnpos[f][Pos][1], dspawnpos[f][Pos][2]-1.0, 0, 0, 0,-1,-1,-1);
        }
    }
	printf("[Loot] loaded %d lootable objects positions", rows);
    return true;
}
script loadclans()
{
    new rows,fields;
    cache_get_data(rows, fields);
	for (new f = 0; f < rows; f ++) if (f < MAX_CLANS)
	{
	    clans[f][clanexists] = true;
		clans[f][idclan] = cache_get_field_content_int(f,"idclan");
        cache_get_field_content(f, "clanname", clans[f][clanname],.max_len = MAX_PLAYER_NAME);
		cache_get_field_content(f, "Owner", clans[f][owner],.max_len = MAX_PLAYER_NAME);
		clans[f][maxrank] = cache_get_field_content_int(f,"maxrank");
		clans[f][clancolor] = cache_get_field_content_int(f, "clancolor");
        clans[f][enterpos][0] = cache_get_field_content_float(f,"enterposx");
        clans[f][enterpos][1] = cache_get_field_content_float(f,"enterposy");
        clans[f][enterpos][2] = cache_get_field_content_float(f,"enterposz");
        clans[f][enterinterior] = cache_get_field_content_int(f,"enterinterior");
        clans[f][entervw] = cache_get_field_content_int(f,"entervw");
        clans[f][exitpos][0] = cache_get_field_content_float(f,"exitposx");
        clans[f][exitpos][1] = cache_get_field_content_float(f,"exitposy");
        clans[f][exitpos][2] = cache_get_field_content_float(f,"exitposz");
        clans[f][exitinterior] = cache_get_field_content_int(f,"exitinterior");
        clans[f][exitvw] = cache_get_field_content_int(f,"exitvw");
        clans[f][chestpos][0] = cache_get_field_content_float(f,"chestposx");
        clans[f][chestpos][1] = cache_get_field_content_float(f,"chestposy");
        clans[f][chestpos][2] = cache_get_field_content_float(f,"chestposz");
        clans[f][clanexp][0] = cache_get_field_content_int(f, "clanexp0");
        clans[f][clanexp][1] = cache_get_field_content_int(f, "clanexp1");
        clans[f][clanexp][2] = cache_get_field_content_int(f, "clanexp2");
        clans[f][clanexp][3] = cache_get_field_content_int(f, "clanexp3");
        clans[f][clanexp][4] = cache_get_field_content_int(f, "clanexp4");
        clans[f][inv][0] = cache_get_field_content_int(f, "inv0");
        clans[f][inv][1] = cache_get_field_content_int(f, "inv1");
        clans[f][inv][2] = cache_get_field_content_int(f, "inv2");
        clans[f][inv][3] = cache_get_field_content_int(f, "inv3");
        clans[f][inv][4] = cache_get_field_content_int(f, "inv4");
        clans[f][inv][5] = cache_get_field_content_int(f, "inv5");
        clans[f][inv][6] = cache_get_field_content_int(f, "inv6");
        clans[f][inv][7] = cache_get_field_content_int(f, "inv7");
        clans[f][inv][8] = cache_get_field_content_int(f, "inv8");
        clans[f][inv][9] = cache_get_field_content_int(f, "inv9");
        clans[f][inv][10] = cache_get_field_content_int(f, "inv10");
        clans[f][inv][11] = cache_get_field_content_int(f, "inv11");
        clans[f][inv][12] = cache_get_field_content_int(f, "inv12");
        clans[f][inv][13] = cache_get_field_content_int(f, "inv13");
        clans[f][inv][14] = cache_get_field_content_int(f, "inv14");
        clans[f][inv][15] = cache_get_field_content_int(f, "inv15");
        clans[f][inv][16] = cache_get_field_content_int(f, "inv16");
        clans[f][inv][17] = cache_get_field_content_int(f, "inv17");
        clans[f][inv][18] = cache_get_field_content_int(f, "inv18");
        clans[f][inv][19] = cache_get_field_content_int(f, "inv19");
        clans[f][inv][20] = cache_get_field_content_int(f, "inv20");
        clans[f][inv][21] = cache_get_field_content_int(f, "inv21");
        clans[f][inv][22] = cache_get_field_content_int(f, "inv22");
        clans[f][inv][23] = cache_get_field_content_int(f, "inv23");
        clans[f][inv][24] = cache_get_field_content_int(f, "inv24");
        clans[f][inv][25] = cache_get_field_content_int(f, "inv25");
        clans[f][pickup][0] =  CreateDynamicPickup(19132, 23, clans[f][enterpos][0], clans[f][enterpos][1],clans[f][enterpos][2], clans[f][entervw], clans[f][enterinterior], -1, 50);
        clans[f][pickup][1] =  CreateDynamicPickup(19132, 23, clans[f][exitpos][0], clans[f][exitpos][1],clans[f][exitpos][2], clans[f][exitvw], clans[f][exitinterior], -1, 50);
        clans[f][pickup][2] =  CreateDynamicPickup(964, 23, clans[f][chestpos][0], clans[f][chestpos][1],clans[f][chestpos][2], -1, -1, -1, 50);
    }
	printf("[Clans] loaded %d clans", rows);
    return true;
}
script UnMutedTimer(playerid)
{
	pMuted[playerid] = false;
	SendAdminAlert(COLOR_LIGHTRED, "%s (ID:%d) has been auto unmuted by server ",GetName(playerid), playerid);
	return 1;
}
script OnPlayerCommandTextEx(playerid, cmdtext[])
{
	SendCommandMessage(playerid,"The command %s doesn't exists /help to see the commands avaible.",cmdtext);
	return 1;
}
script OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(!success) success = OnPlayerCommandTextEx(playerid,cmdtext);
    return success;
}
script objects_Create(playerid)
{
	new Float:x,Float:y,Float:z,Float:angle;
	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_OBJECTSC; i ++) if (!objectsData[i][objectsExists])
		{
		    objectsData[i][objectsExists] = true;
			objectsData[i][objectsModel] = 2000;
			objectsData[i][objectsPos][0] = x + (3.0 * floatsin(-angle, degrees));
			objectsData[i][objectsPos][1] = y + (3.0 * floatcos(-angle, degrees));
			objectsData[i][objectsPos][2] = z;
			objectsData[i][objectsPos][3] = 0.0;
			objectsData[i][objectsPos][4] = 0.0;
			objectsData[i][objectsPos][5] = angle;
            objectsData[i][objectsInterior] = GetPlayerInterior(playerid);
            objectsData[i][objectsWorld] = GetPlayerVirtualWorld(playerid);
            objectsData[i][objectsOb] = CreateDynamicObject(objectsData[i][objectsModel], objectsData[i][objectsPos][0], objectsData[i][objectsPos][1], objectsData[i][objectsPos][2], objectsData[i][objectsPos][3], objectsData[i][objectsPos][4], objectsData[i][objectsPos][5], objectsData[i][objectsWorld], objectsData[i][objectsInterior]);
			mysql_tquery(mysql, "INSERT INTO `objects` (`objectsModel`) VALUES(2000)", "OnobjectsCreated", "d", i);
			return i;
		}
	}
	return -1;
}
script objects_Delete(objectsid)
{
	if (objectsid != -1 && objectsData[objectsid][objectsExists])
	{
		mysql_format(mysql,query, sizeof(query), "DELETE FROM `objects` WHERE `objectsID` = '%d'", objectsData[objectsid][objectsID]);
		mysql_tquery(mysql, query);
		if (IsValidDynamicObject(objectsData[objectsid][objectsOb]))
		    DestroyDynamicObject(objectsData[objectsid][objectsOb]);
		for (new i = 0; i != MAX_OBJECTSC; i ++) if (objectsData[i][objectsExists]) {
		    objects_Save(i);
		}
	    objectsData[objectsid][objectsExists] = false;
	    objectsData[objectsid][objectsID] = 0;
	}
	return 1;
}
script objects_Save(objectsid)
{
	format(query, sizeof(query), "UPDATE `objects` SET `objectsModel` = '%d',`objectsX` = '%.4f', `objectsY` = '%.4f', `objectsZ` = '%.4f', `objectsRX` = '%.4f', `objectsRY` = '%.4f', `objectsRZ` = '%.4f', `objectsInterior` = '%d', `objectsWorld` = '%d' WHERE `objectsID` = '%d'",
	    objectsData[objectsid][objectsModel],
	    objectsData[objectsid][objectsPos][0],
	    objectsData[objectsid][objectsPos][1],
	    objectsData[objectsid][objectsPos][2],
	    objectsData[objectsid][objectsPos][3],
	    objectsData[objectsid][objectsPos][4],
	    objectsData[objectsid][objectsPos][5],
	    objectsData[objectsid][objectsInterior],
	    objectsData[objectsid][objectsWorld],
	    objectsData[objectsid][objectsID]
	);
	return mysql_tquery(mysql, query);
}
script objects_Load()
{
    static rows,fields;
	cache_get_data(rows, fields, mysql);
	for (new i = 0; i < rows; i ++) if (i < MAX_OBJECTSC)
	{
	    objectsData[i][objectsExists] = true;
	    objectsData[i][objectsID] = cache_get_field_content_int(i, "objectsID");
	    objectsData[i][objectsModel] = cache_get_field_content_int(i, "objectsModel");
	    objectsData[i][objectsInterior] = cache_get_field_content_int(i, "objectsInterior");
	    objectsData[i][objectsWorld] = cache_get_field_content_int(i, "objectsWorld");
	    objectsData[i][objectsPos][0] = cache_get_field_content_float(i, "objectsX");
	    objectsData[i][objectsPos][1] = cache_get_field_content_float(i, "objectsY");
	    objectsData[i][objectsPos][2] = cache_get_field_content_float(i, "objectsZ");
	    objectsData[i][objectsPos][3] = cache_get_field_content_float(i, "objectsRX");
	    objectsData[i][objectsPos][4] = cache_get_field_content_float(i, "objectsRY");
	    objectsData[i][objectsPos][5] = cache_get_field_content_float(i, "objectsRZ");
	    objectsData[i][objectsOb] = CreateDynamicObject(objectsData[i][objectsModel], objectsData[i][objectsPos][0], objectsData[i][objectsPos][1], objectsData[i][objectsPos][2], objectsData[i][objectsPos][3], objectsData[i][objectsPos][4], objectsData[i][objectsPos][5], objectsData[i][objectsWorld], objectsData[i][objectsInterior]);
	}
	printf("[Objects] loaded %d objects", rows);
	return 1;
}
script OnobjectsCreated(objectsid)
{
	if (objectsid == -1 || !objectsData[objectsid][objectsExists])
	    return 0;
	objectsData[objectsid][objectsID] = cache_insert_id(mysql);
	objects_Save(objectsid);
	return 1;
}
script storages_Create(playerid)
{
	new Float:x,Float:y,Float:z,Float:angle;
	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_STORAGES; i ++) if (!storageData[i][storagesExists])
		{
		    storageData[i][storagesExists] = true;
			storageData[i][storagesModel] = 1271;
			storageData[i][storagesPos][0] = x + (3.0 * floatsin(-angle, degrees));
			storageData[i][storagesPos][1] = y + (3.0 * floatcos(-angle, degrees));
			storageData[i][storagesPos][2] = z;
			storageData[i][storagesPos][3] = 0.0;
			storageData[i][storagesPos][4] = 0.0;
			storageData[i][storagesPos][5] = angle;
			storageData[i][storagesInv][0] = 0;
			storageData[i][storagesInv][1] = 0;
			storageData[i][storagesInv][2] = 0;
			storageData[i][storagesInv][3] = 0;
			storageData[i][storagesInv][4] = 0;
			storageData[i][storagesInv][5] = 0;
			storageData[i][storagesInv][6] = 0;
			storageData[i][storagesInv][7] = 0;
			storageData[i][storagesInv][8] = 0;
			storageData[i][storagesInv][9] = 0;
			storageData[i][storagesInv][10] = 0;
			storageData[i][storagesInv][11] = 0;
			storageData[i][storagesInv][12] = 0;
			storageData[i][storagesInv][13] = 0;
			storageData[i][storagesInv][14] = 0;
			storageData[i][storagesInv][15] = 0;
			storageData[i][storagesInv][16] = 0;
			storageData[i][storagesInv][17] = 0;
			storageData[i][storagesInv][18] = 0;
			storageData[i][storagesInv][19] = 0;
			storageData[i][storagesInv][20] = 0;
			storageData[i][storagesInv][21] = 0;
			storageData[i][storagesInv][22] = 0;
			storageData[i][storagesInv][23] = 0;
			storageData[i][storagesInv][24] = 0;
			storageData[i][storagesInv][25] = 0;
			storageData[i][storagesLock] = 0;
            storageData[i][storagesInterior] = GetPlayerInterior(playerid);
            storageData[i][storagesWorld] = GetPlayerVirtualWorld(playerid);
            storageData[i][storagesOb] = CreateDynamicObject(storageData[i][storagesModel], storageData[i][storagesPos][0], storageData[i][storagesPos][1], storageData[i][storagesPos][2], storageData[i][storagesPos][3], storageData[i][storagesPos][4], storageData[i][storagesPos][5], storageData[i][storagesWorld], storageData[i][storagesInterior]);
			mysql_tquery(mysql, "INSERT INTO `storages` (`storagesModel`) VALUES(3798)", "OnstoragesCreated", "d", i);
			return i;
		}
	}
	return -1;
}
script storages_Delete(storagesid)
{
	if (storagesid != -1 && storageData[storagesid][storagesExists])
	{
		mysql_format(mysql,query, sizeof(query), "DELETE FROM `storages` WHERE `storagesID` = '%d'", storageData[storagesid][storagesID]);
		mysql_tquery(mysql, query);
		if (IsValidDynamicObject(storageData[storagesid][storagesOb])) DestroyDynamicObject(storageData[storagesid][storagesOb]);
		for (new i = 0; i != MAX_STORAGES; i ++) if (storageData[i][storagesExists]) storages_Save(i);
	    storageData[storagesid][storagesExists] = false;
	    storageData[storagesid][storagesID] = 0;
	}
	return 1;
}
script storages_Save(storagesid)
{
	format(query, sizeof(query), "UPDATE `storages` SET `storagesModel` = '1271',`storagesLock` = '%d',`storagesX` = '%.4f', `storagesY` = '%.4f', `storagesZ` = '%.4f', `storagesRX` = '%.4f', `storagesRY` = '%.4f', `storagesRZ` = '%.4f', `storagesInterior` = '%d',	`storagesWorld` = '%d', \
	`inv0` = '%d',`inv1` = '%d',`inv2` = '%d',`inv3` = '%d',`inv4` = '%d',`inv5` = '%d',`inv6` = '%d',`inv7` = '%d',`inv8` = '%d',`inv9` = '%d',`inv10` = '%d',\
	`inv11` = '%d',`inv12` = '%d',`inv13` = '%d',`inv14` = '%d',`inv15` = '%d',`inv16` = '%d',`inv17` = '%d',`inv18` = '%d',`inv19` = '%d',`inv20` = '%d',\
	`inv21` = '%d',`inv22` = '%d',`inv23` = '%d',`inv24` = '%d',`inv25` = '%d'	WHERE `storagesID` = '%d'",
		storageData[storagesid][storagesLock],
	    storageData[storagesid][storagesPos][0],
	    storageData[storagesid][storagesPos][1],
	    storageData[storagesid][storagesPos][2],
	    storageData[storagesid][storagesPos][3],
	    storageData[storagesid][storagesPos][4],
	    storageData[storagesid][storagesPos][5],
	    storageData[storagesid][storagesInterior],
	    storageData[storagesid][storagesWorld],
        storageData[storagesid][storagesInv][0],
        storageData[storagesid][storagesInv][1],
        storageData[storagesid][storagesInv][2],
        storageData[storagesid][storagesInv][3],
        storageData[storagesid][storagesInv][4],
        storageData[storagesid][storagesInv][5],
        storageData[storagesid][storagesInv][6],
        storageData[storagesid][storagesInv][7],
        storageData[storagesid][storagesInv][8],
        storageData[storagesid][storagesInv][9],
        storageData[storagesid][storagesInv][10],
        storageData[storagesid][storagesInv][11],
        storageData[storagesid][storagesInv][12],
        storageData[storagesid][storagesInv][13],
        storageData[storagesid][storagesInv][14],
        storageData[storagesid][storagesInv][15],
        storageData[storagesid][storagesInv][16],
        storageData[storagesid][storagesInv][17],
        storageData[storagesid][storagesInv][18],
        storageData[storagesid][storagesInv][19],
        storageData[storagesid][storagesInv][20],
        storageData[storagesid][storagesInv][21],
        storageData[storagesid][storagesInv][22],
        storageData[storagesid][storagesInv][23],
        storageData[storagesid][storagesInv][24],
        storageData[storagesid][storagesInv][25],
	    storageData[storagesid][storagesID]
	);
	return mysql_tquery(mysql, query);
}
script storages_Load()
{
    static rows,fields;
	cache_get_data(rows, fields, mysql);
	for (new i = 0; i < rows; i ++) if (i < MAX_STORAGES)
	{
	    storageData[i][storagesExists] = true;
	    storageData[i][storagesID] = cache_get_field_content_int(i, "storagesID");
	    storageData[i][storagesModel] = cache_get_field_content_int(i, "storagesModel");
	    storageData[i][storagesLock] = cache_get_field_content_int(i, "storagesLock");
	    storageData[i][storagesInterior] = cache_get_field_content_int(i, "storagesInterior");
	    storageData[i][storagesWorld] = cache_get_field_content_int(i, "storagesWorld");
	    storageData[i][storagesPos][0] = cache_get_field_content_float(i, "storagesX");
	    storageData[i][storagesPos][1] = cache_get_field_content_float(i, "storagesY");
	    storageData[i][storagesPos][2] = cache_get_field_content_float(i, "storagesZ");
	    storageData[i][storagesPos][3] = cache_get_field_content_float(i, "storagesRX");
	    storageData[i][storagesPos][4] = cache_get_field_content_float(i, "storagesRY");
	    storageData[i][storagesPos][5] = cache_get_field_content_float(i, "storagesRZ");
        storageData[i][storagesInv][0] = cache_get_field_content_int(i, "inv0"); //vip stuff storage
        storageData[i][storagesInv][1] = cache_get_field_content_int(i, "inv1");
        storageData[i][storagesInv][2] = cache_get_field_content_int(i, "inv2");
        storageData[i][storagesInv][3] = cache_get_field_content_int(i, "inv3");
        storageData[i][storagesInv][4] = cache_get_field_content_int(i, "inv4");
        storageData[i][storagesInv][5] = cache_get_field_content_int(i, "inv5");
        storageData[i][storagesInv][6] = cache_get_field_content_int(i, "inv6");
        storageData[i][storagesInv][7] = cache_get_field_content_int(i, "inv7");
        storageData[i][storagesInv][8] = cache_get_field_content_int(i, "inv8");
        storageData[i][storagesInv][9] = cache_get_field_content_int(i, "inv9");
        storageData[i][storagesInv][10] = cache_get_field_content_int(i, "inv10");
        storageData[i][storagesInv][11] = cache_get_field_content_int(i, "inv11");
        storageData[i][storagesInv][12] = cache_get_field_content_int(i, "inv12");
        storageData[i][storagesInv][13] = cache_get_field_content_int(i, "inv13");
        storageData[i][storagesInv][14] = cache_get_field_content_int(i, "inv14");
        storageData[i][storagesInv][15] = cache_get_field_content_int(i, "inv15");
        storageData[i][storagesInv][16] = cache_get_field_content_int(i, "inv16");
        storageData[i][storagesInv][17] = cache_get_field_content_int(i, "inv17");
        storageData[i][storagesInv][18] = cache_get_field_content_int(i, "inv18");
        storageData[i][storagesInv][19] = cache_get_field_content_int(i, "inv19");
        storageData[i][storagesInv][20] = cache_get_field_content_int(i, "inv20");
        storageData[i][storagesInv][21] = cache_get_field_content_int(i, "inv21");
        storageData[i][storagesInv][22] = cache_get_field_content_int(i, "inv22");
        storageData[i][storagesInv][23] = cache_get_field_content_int(i, "inv23");
        storageData[i][storagesInv][24] = cache_get_field_content_int(i, "inv24");
        storageData[i][storagesInv][25] = cache_get_field_content_int(i, "inv25");
	    storageData[i][storagesOb] = CreateDynamicObject(storageData[i][storagesModel], storageData[i][storagesPos][0], storageData[i][storagesPos][1], storageData[i][storagesPos][2], storageData[i][storagesPos][3], storageData[i][storagesPos][4], storageData[i][storagesPos][5], storageData[i][storagesWorld], storageData[i][storagesInterior]);
	}
	printf("[Storages] loaded %d storages", rows);
	return 1;
}
script OnstoragesCreated(storagesid)
{
	if (storagesid == -1 || !storageData[storagesid][storagesExists])
	    return 0;
	storageData[storagesid][storagesID] = cache_insert_id(mysql);
	storages_Save(storagesid);
	return 1;
}
script OnClanCreated(playerid, clanName[])
{
    format(query, sizeof(query), "SELECT idclan FROM clans WHERE clanname = '%s' ORDER BY idclan DESC LIMIT 1", clanName);
    mysql_tquery(mysql, query, "OnClanIDFetched", "is", playerid, clanName);
	
	new DCC_User:user1 = DCC_FindUserById(pData[playerid][pDiscordID]);
	DCC_AddGuildMemberRole(GUILD_ID1,user1,RoleLeader);
    return 1;
}
script OnClanIDFetched(playerid, clanName[])
{
    new id;
	id = cache_get_row_int(0, 0); // fetch clan ID
    pData[playerid][idclan] = id;

    SendServerMessage(playerid, "Clan \"%s\" created and assigned to your profile!", clanName);
	Dialog_Show(playerid, CLANDIALOG00, DIALOG_STYLE_LIST, "Clan Setup", "Create Clan\nClan Stats\nEnter position\nExit position\nChest position\nMax Rank\nDelete Clan", "OK", "");
    return 1;
}
script Detectare_Intrare(playerid)
{
	inJOB[playerid] = 0;
	KillTimer(Meeters_BTWDeer[playerid]);
	DestroyObject(Hunter_Deer[playerid]);
	PlayerTextDrawHide(playerid, DistanceTD[playerid]);
	Deep_Deer[playerid] = 0;
	Deer[playerid] = 0;
	Shoot_Deer[playerid] = 0;
	return 1;
}
script Done_Deer(playerid)
{
    pData[playerid][inv][1] += (random(5)+1);
    pData[playerid][clanexp][0] += (random(5)+1);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	ClearAnimations(playerid, 0);
	DestroyObject(Hunter_Deer[playerid]);
	TogglePlayerControllable(playerid, 1);
	SetTimerEx("Next_Deer", 1000, false, "i", playerid);
	return 1;
}
script Detect_M(playerid)
{
	new Float:x, Float:y, Float:z, mesaj[256];
	GetPlayerPos(playerid, x, y, z);
	if(Deer[playerid] == 1) Meeters[playerid] = GetDistance(x, y, z, 8521.4727,13804.3506,4.8626);
	else if(Deer[playerid] == 2) Meeters[playerid] = GetDistance(x, y, z, 8712.4287,14008.3896,3.0037);
	else if(Deer[playerid] == 3) Meeters[playerid] = GetDistance(x, y, z, 8704.8564,14117.2051,5.8480);
	else if(Deer[playerid] == 4) Meeters[playerid] = GetDistance(x, y, z, 8729.0361,14638.2578,16.9921);
	else if(Deer[playerid] == 5) Meeters[playerid] = GetDistance(x, y, z, 8597.6152,14805.4805,24.4484);
	else if(Deer[playerid] == 6) Meeters[playerid] = GetDistance(x, y, z, 8800.6748,13836.8525,3.4051);
	format(mesaj, sizeof(mesaj), "Distance_%dM", Meeters[playerid]);
	PlayerTextDrawSetString(playerid, DistanceTD[playerid], mesaj);
	PlayerTextDrawShow(playerid, DistanceTD[playerid]);
	return 1;
}
script Next_Deer(playerid)
{
	new rand = random(7);
	switch(rand) {
		case 1: {
			Deer[playerid] = 1;
			Hunter_Deer[playerid] = CreateObject(19315, 8521.4727,13804.3506,4.8626,   0.00000, 0.00000, 0.00000);
			Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
		}
		case 2: {
			Deer[playerid] = 2;
			Hunter_Deer[playerid] = CreateObject(19315, 8712.4287,14008.3896,3.0037,   0.00000, 0.00000, -52.38000);
			Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
		}
		case 3: {
			Deer[playerid] = 3;
			Hunter_Deer[playerid] = CreateObject(19315, 8704.8564,14117.2051,5.8480,   0.00000, 0.00000, -7.38000);
			Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
		}
		case 4: {
			Deer[playerid] = 4;
			Hunter_Deer[playerid] = CreateObject(19315, 8729.0361,14638.2578,16.9921,   0.00000, 0.00000, 0.00000);
			Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
		}
		case 5: {
			Deer[playerid] = 5;
			Hunter_Deer[playerid] = CreateObject(19315,8597.6152,14805.4805,24.4484,   0.00000, 0.00000, -49.26000);
			Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
		}
		default: {
			Deer[playerid] = 6;
			Hunter_Deer[playerid] = CreateObject(19315, 8800.6748,13836.8525,3.4051,   0.00000, 0.00000, -71.64002);
			Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
		}
	}
	return 1;
}
//airbreak
script OnPlayerAirbreak(playerid)
{
    if (IsPlayerInAnyVehicle(playerid))
    {
		SendAdminAlert(COLOR_LIGHTRED,"Player %s has been detected for vehicle airbreak.",Name[playerid]);
        SendServerMessage(playerid,"Airbreak Vehicle detected Kick.");
    	KickEx(playerid);
    }
    else
    {
		SendAdminAlert(COLOR_LIGHTRED,"Player %s has been detected for vehicle airbreak.",Name[playerid]);
        SendServerMessage(playerid,"Airbreak Player detected Kick.");
    	KickEx(playerid);
    }
    return 1;
}
KickEx(playerid)
{
	SetTimerEx("KickTimer", 200, false, "d", playerid);
	return 1;
}
script KickTimer(playerid)
{
	Kick(playerid);
	return 0;
}
Storage_Nearest(playerid)
{
    for (new i = 0; i != MAX_STORAGES; i ++) if (storageData[i][storagesExists] && IsPlayerInRangeOfPoint(playerid, 5, storageData[i][storagesPos][0], storageData[i][storagesPos][1], storageData[i][storagesPos][2]))
	{
		if (GetPlayerInterior(playerid) == storageData[i][storagesInterior] && GetPlayerVirtualWorld(playerid) == storageData[i][storagesWorld])
			return i;
	}
	return -1;
}
objects_Nearest(playerid)
{
    for (new i = 0; i != MAX_OBJECTSC; i ++) if (objectsData[i][objectsExists] && IsPlayerInRangeOfPoint(playerid, 2, objectsData[i][objectsPos][0], objectsData[i][objectsPos][1], objectsData[i][objectsPos][2]))
	{
		if (GetPlayerInterior(playerid) == objectsData[i][objectsInterior] && GetPlayerVirtualWorld(playerid) == objectsData[i][objectsWorld])
			return i;
	}
	return -1;
}
ResetEditing(playerid)
{
	pData[playerid][pEditobjects] = -1;
	return 1;
}
script Float:GetFuelConsumptionRate(vehicleid)
{
    new model = GetVehicleModel(vehicleid);
    switch (model)
    {
        case 402,409,411,415,424,429,434,451,480,506,533,534,536,541,555,602,662,794,796,1194,1195,1197,3141,4790,4799,5693,6528,6554,6558,6561,6575,6585,6594,6595,6615,6648,
		6658,6660,6661,6664,6672,6673,6686,6700,25405,25435,25492,25539,25550,25602,25603,25614,25649: return 0.004;//executive

        case 405,421,426,445,457,474,477,535,551,558..562,565,566,579,587,663,665,797,965,1199,3223,4775,4804,5090,5092,6258,6262,6578,6593,6610,6643,6655,6670,6701,
		6762,25381,25385,25396,25466,25491,25522,25544,25547,25548,25551..25553,25557,25604,25605,25648,25650,25665,25666: return 0.005;//rich

        case 406,444,556,557,573,6526,6687,25360: return 0.007;//big like monster truc
        case 481,509,510,6677,66778,25500..25510: return 0.00;//bicycle bmx

        case 448,461..463,468,471,521..523,581,586,793,1205,1206,2884,3136..3139,3222,3224,3247,4783..4787,6269,6270,6271,6600,6605,6629,6632,6640,6698,6702,6794,6795,
		25394,25462,25499,25517,25576,25577,25641,25690: return 0.001; //bike

        default: return 0.003; //other like normal/poor/worker/boat/taxi
    }
    return 0.04;
}
script OnFuelStationsLoaded()
{
    new rows = cache_num_rows(),text[48];
    for (new i = 0; i < rows && i < MAX_FUEL_STATIONS; i++)
    {
        FuelStation[i][fsID] = cache_get_row_int(i, 0);
        FuelStation[i][fsPosX] = cache_get_row_float(i, 1);
        FuelStation[i][fsPosY] = cache_get_row_float(i, 2);
        FuelStation[i][fsPosZ] = cache_get_row_float(i, 3);
        FuelStation[i][fsStock] = cache_get_row_int(i, 4);
    	if (IsValidDynamic3DTextLabel(FuelStation[i][fsLabel]))
       		DestroyDynamic3DTextLabel(FuelStation[i][fsLabel]);
    	if (IsValidDynamicMapIcon(FuelStation[i][fsMapIcon]))
       		DestroyDynamicMapIcon(FuelStation[i][fsMapIcon]);
    	format(text, sizeof(text), "[ID %d] Fuel: %d liters",i,FuelStation[i][fsStock]);
    	FuelStation[i][fsLabel] = CreateDynamic3DTextLabel(text,0x00FF00FF,FuelStation[i][fsPosX],FuelStation[i][fsPosY],FuelStation[i][fsPosZ],15.0);
        FuelStation[i][fsMapIcon] = CreateDynamicMapIcon(FuelStation[i][fsPosX],FuelStation[i][fsPosY],FuelStation[i][fsPosZ],51,0,-1, -1, -1, 100.0);
        FuelStationCount++;
    }
    printf("[FuelStation] Loaded %d station(s).", FuelStationCount);
}
script GetNearestFuelStation(playerid)
{
    new nearest = -1,Float:px, Float:py, Float:pz, Float:dist, Float:minDist = 5.0;
    GetPlayerPos(playerid, px, py, pz);

    for (new i = 0; i < FuelStationCount; i++)
    {
        dist = GetDistance(px, py, pz, FuelStation[i][fsPosX], FuelStation[i][fsPosY], FuelStation[i][fsPosZ]);
        if (dist < minDist)
        {
            minDist = dist;
            nearest = i;
        }
    }
    return nearest;
}
script Float:floatmin(Float:a, Float:b)
{
    return (a < b) ? a : b;
}
script OnVehiclesLoaded()
{
    new rows = cache_num_rows(),string[64], ownerName[MAX_PLAYER_NAME],id, model,color1, color2,Float:x, Float:y, Float:z, Float:rot,modString[128],paintjob;
    for (new i = 0; i < rows; i++)
    {
        cache_get_row(i, 0, string); id = strval(string);
        cache_get_row(i, 1, string); model = strval(string);
        cache_get_row(i, 2, string); x = floatstr(string);
        cache_get_row(i, 3, string); y = floatstr(string);
        cache_get_row(i, 4, string); z = floatstr(string);
        cache_get_row(i, 5, string); rot = floatstr(string);
        cache_get_row(i, 6, ownerName);
        cache_get_row(i, 7, string); color1 = strval(string);
        cache_get_row(i, 8, string); color2 = strval(string);
        cache_get_field_content(i, "mods", modString, mysql, sizeof(modString));
        cache_get_row(i, 10, string); paintjob = strval(string);
        DB_Vehicle[i] = CreateVehicle(model, x, y, z, rot, color1, color2, -1);
        DB_VehicleID[i] = id;
        format(VehicleOwner[i], MAX_PLAYER_NAME, "%s", ownerName);
        if (paintjob >= 0) ChangeVehiclePaintjob(DB_Vehicle[i], paintjob);
        cache_get_row(i, 11, string);
        gVehicleFuel[DB_Vehicle[i]] = floatstr(string);
		g_LastVehiclePos[DB_Vehicle[i]][0] = x;
		g_LastVehiclePos[DB_Vehicle[i]][1] = y;
		g_LastVehiclePos[DB_Vehicle[i]][2] = z;
    }
	printf("[Vehicles] loaded %d vehicles", rows);
    return 1;
}
script OnLoadModsForVehicle(playerid, vehicleid)
{
    if (cache_num_rows())
    {
        new modString[128];
        cache_get_field_content(0, "mods", modString, mysql, sizeof(modString));
        ApplyModsToVehicle(vehicleid, modString);
    }
    return 1;
}
script OnVehicleCreated(modelid, Float:x, Float:y, Float:z, Float:a, color1, color2, fuel)
{
    new id = cache_insert_id();
    for (new i = 0; i < MAX_SERVER_VEHICLES; i++)
    {
        if (DB_Vehicle[i] == INVALID_VEHICLE_ID || DB_Vehicle[i] == 0)
        {
            DB_Vehicle[i] = CreateVehicle(modelid, x, y, z, a, color1, color2, -1);
            DB_VehicleID[i] = id;
			gVehicleFuel[i] = fuel;
			g_LastVehiclePos[DB_Vehicle[i]][0] = x;
			g_LastVehiclePos[DB_Vehicle[i]][1] = y;
			g_LastVehiclePos[DB_Vehicle[i]][2] = z;
            break;
        }
    }
    return 1;
}
script CheckUnoccupiedVehicleTeleport()
{
    for (new i = 1; i < MAX_SERVER_VEHICLES; i++)
    {
        if (!IsValidVehicle(i)) continue;
        if (GetVehicleModel(i) == 0) continue;
        if (GetVehicleDriver(i) != INVALID_PLAYER_ID) continue;
        new Float:x, Float:y, Float:z;
        GetVehiclePos(i, x, y, z);

        new Float:dist = GetDistance(x, y, z, g_LastVehiclePos[i][0], g_LastVehiclePos[i][1], g_LastVehiclePos[i][2]);
        if (dist > MAX_ALLOWED_VEHICLE_DISTANCE)
        {
            printf("[ANTI-CHEAT] Vehicle ID %d teleported %.2f units (unoccupied)!", i, dist);
            SetVehiclePos(i,g_LastVehiclePos[i][0],g_LastVehiclePos[i][1],g_LastVehiclePos[i][2]);
        }
    }
    return 1;
}
stock GetVehicleDriver(vehicleid)
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (!IsPlayerConnected(i)) continue;
        if (GetPlayerVehicleID(i) == vehicleid && GetPlayerState(i) == PLAYER_STATE_DRIVER) return i;
    }
    return INVALID_PLAYER_ID;
}
script ApplyModsToVehicle(vehicleid, const modString[])
{
    new component, part[6], i = 0, j = 0;
    while (modString[i] != '\0')
    {
        if (modString[i] == ',' || modString[i + 1] == '\0')
        {
            if (modString[i + 1] == '\0') part[j++] = modString[i];
            part[j] = '\0';
            component = strval(part);
            AddVehicleComponent(vehicleid, component);
            j = 0;
            i++;
        }
        else part[j++] = modString[i++];
    }
	if (VehiclePaintjob[i] >= 0) ChangeVehiclePaintjob(DB_Vehicle[i], VehiclePaintjob[i]);
	return 1;
}
script bool:IsPlayerInZone(playerid, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    return (x >= minx && x <= maxx && y >= miny && y <= maxy);
}
script LoadGangZones()
{
    new rows, fields;
    cache_get_data(rows, fields);
    for (new i = 0; i < rows && i < MAX_GZONES; i++)
    {
        GangZones[i][gID] = cache_get_field_content_int(i, "id");
        GangZones[i][gMinX] = cache_get_field_content_float(i, "minx");
        GangZones[i][gMinY] = cache_get_field_content_float(i, "miny");
        GangZones[i][gMaxX] = cache_get_field_content_float(i, "maxx");
        GangZones[i][gMaxY] = cache_get_field_content_float(i, "maxy");
        GangZones[i][gTeamID] = cache_get_field_content_int(i, "team_id");
		GangZones[i][gressources] = cache_get_field_content_int(i, "ressources");
		GangZones[i][gCaptureTime] = cache_get_field_content_int(i, "capturetime");
        GangZones[i][gZoneID] = GangZoneCreate(GangZones[i][gMinX], GangZones[i][gMinY], GangZones[i][gMaxX], GangZones[i][gMaxY]);
        GangZoneShowForAll(GangZones[i][gZoneID], COLOR_GRAY);
        TotalGZ++;		
    }
	printf("[GangZones] Loaded %d zones.", TotalGZ);
}
script GetTeamZoneColor(teamid)
{
    switch (teamid) //add more color if you want
    {
		case 9 .. 50: return COLOR_GREEN;
		case 1: return COLOR_RED;
		case 2: return COLOR_GREEN;
		case 3: return COLOR_BLUE;
		case 5: return COLOR_PURPLE;
		case 6: return COLOR_YELLOW;
		case 7: return COLOR_LIGHTRED;
		case 8: return COLOR_LIGHTBLUE;
        default: return COLOR_GRAY; // Gray
    }
    return COLOR_GRAY;
}
script EndZoneWar(zoneIndex)///re check for attacker print doenst match up
{
    if (!ZoneInWar[zoneIndex]) return 1;
	KillTimer(WarCheckTimer[zoneIndex]);
	WarCheckTimer[zoneIndex] = 0;
    new attackerTeam = -1,attackers = 0,denferTeam = -1,defenders = 0;
    // Count players from both teams inside zone
    foreach (new i : Player)
    {
        if (!IsPlayerConnected(i)) continue;

        if (IsPlayerInZone(i, GangZones[zoneIndex][gMinX], GangZones[zoneIndex][gMinY], GangZones[zoneIndex][gMaxX], GangZones[zoneIndex][gMaxY]))
        {
            if (pData[i][idclan] != GangZones[zoneIndex][gTeamID])
            {
                attackerTeam = pData[i][idclan];
                attackers++;
            }
            if (pData[i][idclan] == GangZones[zoneIndex][gTeamID])
            {
                denferTeam = pData[i][idclan];
                defenders++;
            }
        }
		// Decide outcome
		if (attackers > defenders && attackerTeam != -1)
		{
			GangZones[zoneIndex][gTeamID] = attackerTeam;
			GangZones[zoneIndex][gCaptureTime] = gettime();
			mysql_format(mysql, query, sizeof(query),"UPDATE gang_zones SET team_id='%d', capturetime='%d' WHERE id='%d'",attackerTeam,GangZones[zoneIndex][gCaptureTime],GangZones[zoneIndex][gID]);
			mysql_tquery(mysql, query);
			
			
			GangZoneHideForAll(GangZones[zoneIndex][gZoneID]);
			pData[attackers][clanexp][0] += 50;
			GangZoneShowForAll(GangZones[zoneIndex][gZoneID], GetTeamZoneColor(attackerTeam));
			SendServerMessage(attackers,"30 minutes = 1 point to convert into material.");
			SendAdminAlert(COLOR_LIGHTRED,"[Capture] Team %s has captured zone %d!", clans[pData[attackerTeam][idclan]][clanname], zoneIndex);
			GangZoneStopFlashForAll(GangZones[zoneIndex][gZoneID]);
		}
		else
		{
			pData[denferTeam][clanexp][0] += 50;
			SendAdminAlert(COLOR_LIGHTRED,"[CAPTURE] Defenders held zone %d successfully!", zoneIndex);
		}
    }
    ZoneInWar[zoneIndex] = false;
    WarTimer[zoneIndex] = 0;
    GlobalZoneCooldown = gettime() + 300; // 5-minute global cooldown
    return 1;
}
script CheckWarZoneEmpty(zoneIndex)
{
    if (!ZoneInWar[zoneIndex]) return 0;
    new inZoneCount = 0;
    foreach (new i : Player)
    {
        if (!IsPlayerConnected(i)) continue;

        if (IsPlayerInZone(i,GangZones[zoneIndex][gMinX],GangZones[zoneIndex][gMinY],GangZones[zoneIndex][gMaxX],GangZones[zoneIndex][gMaxY]))
        {
            inZoneCount++;
            break; // at least one player is still inside
        }
    }
    if (inZoneCount == 0)
    {
        // Cancel war
        KillTimer(WarTimer[zoneIndex]);
        KillTimer(WarCheckTimer[zoneIndex]);
        ZoneInWar[zoneIndex] = false;
        WarTimer[zoneIndex] = 0;
        WarCheckTimer[zoneIndex] = 0;
        SendAdminAlert(COLOR_LIGHTRED,"[CAPTURE] War in zone %d canceled: no players in area.", zoneIndex);
        GangZoneStopFlashForAll(GangZones[zoneIndex][gZoneID]);
    }
    GlobalZoneCooldown = gettime() + 300; // 5-minute global cooldown
    return 1;
}
script GangZoneResourceTick()
{
    for (new i = 0; i < TotalGZ; i++)
    {
        if (GangZones[i][gTeamID] == 0)
            continue;
        // Give 1 resource
        GangZones[i][gressources]++;
        mysql_format(mysql, query, sizeof(query), "UPDATE gang_zones SET ressources = %d WHERE id = %d",GangZones[i][gressources],GangZones[i][gID]);
        mysql_tquery(mysql, query);
    }
    return 1;
}
script CheckGangZones()
{
    new current = gettime();

    for(new i = 0; i < MAX_GANG_ZONES; i++)
    {
        if(GangZones[i][gTeamID] == 0) continue;
        if(current - GangZones[i][gCaptureTime] >= 604800) // 7 days
        {
            GangZones[i][gTeamID] = 0;
            GangZones[i][gCaptureTime] = 0;
            GangZoneShowForAll( GangZones[i][gZoneID], COLOR_GRAY); // Neutral color
            mysql_format(mysql, query, sizeof(query), "UPDATE `gang_zones` SET `team_id`='0', `capturetime`='0' WHERE `id`='%d'", GangZones[i][gID]);
            mysql_tquery(mysql, query);
        }
    }
    return 1;
}
script OnMissionLoadRandomCheckpoints(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields);

    if (rows < MAX_MISSION_CHECKPOINTS)
        return SendClientMessage(playerid, -1, "Not enough checkpoints in database.");

    for (new i = 0; i < MAX_MISSION_CHECKPOINTS; i++)
    {
        PlayerMissionCheckpoints[playerid][i][0] = cache_get_field_content_float(i, "x"); 
        PlayerMissionCheckpoints[playerid][i][1] = cache_get_field_content_float(i, "y"); 
        PlayerMissionCheckpoints[playerid][i][2] = cache_get_field_content_float(i, "z"); 
    }
    PlayerCurrentCheckpoint[playerid] = 0;
    SetPlayerCheckpoint(playerid,PlayerMissionCheckpoints[playerid][0][0],PlayerMissionCheckpoints[playerid][0][1],PlayerMissionCheckpoints[playerid][0][2],3.0);
    return 1;
}
script OnActorStreamIn(actorid, forplayerid)
{
	SetActorInvulnerable(actorid, true);
	SetActorRespawnTime(actorid,12000);
    return 1;
}
script SetPlayerToUnfreeze(playerid, Float:x, Float:y, Float:z)
{
	if (!IsPlayerInRangeOfPoint(playerid, 15.0, x, y, z))
	    return 0;
	pData[playerid][pFreeze] = 0;
	SetPlayerPos(playerid, x, y, z);
	TogglePlayerControllable(playerid, 1);
	return 1;
}
script OnEntranceCreated(entranceid)
{
	if (entranceid == -1 || !EntranceData[entranceid][entranceExists]) return 0;
	EntranceData[entranceid][entranceID] = cache_insert_id(mysql);
	EntranceData[entranceid][entranceWorld] = EntranceData[entranceid][entranceID] + 7000;
	Entrance_Save(entranceid);
	return 1;
}
script Entrance_Load()
{
    static rows,fields;
    cache_get_data(rows, fields, mysql);

	for (new i = 0; i < rows; i ++) if (i < MAX_OBJECTSC)
	{
	    EntranceData[i][entranceExists] = true;
    	EntranceData[i][entranceID] = cache_get_field_content_int(i, "entranceID");
		cache_get_field_content(i, "entranceName", EntranceData[i][entranceName], mysql, 32);
	    EntranceData[i][entranceLocked] = cache_get_field_content_int(i, "entranceLocked");
	    EntranceData[i][entrancePos][0] = cache_get_field_content_float(i, "entrancePosX");
	    EntranceData[i][entrancePos][1] = cache_get_field_content_float(i, "entrancePosY");
	    EntranceData[i][entrancePos][2] = cache_get_field_content_float(i, "entrancePosZ");
	    EntranceData[i][entrancePos][3] = cache_get_field_content_float(i, "entrancePosA");
	    EntranceData[i][entranceInt][0] = cache_get_field_content_float(i, "entranceIntX");
	    EntranceData[i][entranceInt][1] = cache_get_field_content_float(i, "entranceIntY");
	    EntranceData[i][entranceInt][2] = cache_get_field_content_float(i, "entranceIntZ");
	    EntranceData[i][entranceInt][3] = cache_get_field_content_float(i, "entranceIntA");
	    EntranceData[i][entranceInterior] = cache_get_field_content_int(i, "entranceInterior");
	    EntranceData[i][entranceExterior] = cache_get_field_content_int(i, "entranceExterior");
	    EntranceData[i][entranceExteriorVW] = cache_get_field_content_int(i, "entranceExteriorVW");
	    EntranceData[i][entranceWorld] = cache_get_field_content_int(i, "entranceWorld");
	    Entrance_Refresh(i);
	}
	printf("[Entrances] loaded %d entrances", rows);
	return 1;
}
//mining
script FinishMining(playerid)
{
    TogglePlayerControllable(playerid, 1);
    ClearAnimations(playerid); 
	new taking = random(3) + 1;
    if (pData[playerid][inv][7] + taking > GetBackpackCapacity(playerid)) return SendServerMessage(playerid, "Your backpack is full full of ores talk to the npc to convert to iron and gold.");
	pData[playerid][inv][7] += taking;
	pData[playerid][clanexp][0] += random(5)+1;
    IsMining[playerid] = 0;    
    GameTextForPlayer(playerid, "~g~Mining done!", 4000, 3);
    return 1;
}
//lockpick
script LockpickUpdate(playerid)
{
    if(!Lockpick[playerid][lpActive]) return 0;
    Lockpick[playerid][lpPos] += Lockpick[playerid][lpDir];
    if(Lockpick[playerid][lpPos] >= MAX_LOCKPICK_BAR) Lockpick[playerid][lpDir] = -1;
    if(Lockpick[playerid][lpPos] <= 0) Lockpick[playerid][lpDir] = 1;
    new bar[64];
    for(new i = 0; i <= MAX_LOCKPICK_BAR; i++)
    {
        if(i == Lockpick[playerid][lpPos]) strcat(bar, "|");
        else if( i >= Lockpick[playerid][lpZoneStart] && i <= Lockpick[playerid][lpZoneEnd]) strcat(bar, "=");
        else strcat(bar, "-");
    }
	TogglePlayerControllable(playerid, 0);
    GameTextForPlayer(playerid, bar, 100, 3);
    return 1;
}
//change camera
script LoginCamera(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new id = LoginCameraStep[playerid];

    SetPlayerCameraPos(playerid,CamPos[id][0],CamPos[id][1],CamPos[id][2]);
    SetPlayerCameraLookAt(playerid,CamLook[id][0],CamLook[id][1],CamLook[id][2]);
    LoginCameraStep[playerid]++;
    if(LoginCameraStep[playerid] >= MAX_LOGIN_CAMERAS) LoginCameraStep[playerid] = 0;
    LoginCameraTimer[playerid] =SetTimerEx("LoginCamera",15000, false, "i", playerid);

    return 1;
}
//antenna
script LoadAntennas()
{
    new rows, fields;

    cache_get_data(rows, fields);

    for(new i; i < rows && i < MAX_ANTENNAS; i++)
    {
        Antenna[i][aExists] = true;
        Antenna[i][aSQLID] = cache_get_field_content_int(i,"id");
        Antenna[i][aType] = cache_get_field_content_int(i,"type");
        Antenna[i][aPosX] = cache_get_field_content_float(i,"x");
        Antenna[i][aPosY] = cache_get_field_content_float(i,"y");
        Antenna[i][aPosZ] = cache_get_field_content_float(i,"z");
        Antenna[i][aHealth] = cache_get_field_content_float(i,"health");
        Antenna[i][aPowered] = cache_get_field_content_int(i,"powered");
        Antenna[i][aFuel] = cache_get_field_content_int(i,"fuel");
        switch(Antenna[i][aType])
        {
            case ANTENNA_SMALL: Antenna[i][aRange]=ANTENNA_SMALL_RANGE;
            case ANTENNA_MEDIUM: Antenna[i][aRange]=ANTENNA_MEDIUM_RANGE;
            case ANTENNA_LARGE: Antenna[i][aRange]=ANTENNA_LARGE_RANGE;
        }
        CreateAntennaVisual(i);
    }
    printf("[Radio] Loaded %d antennas.",rows);
    return 1;
}
script AntennaDecay()
{
    for(new i;i<MAX_ANTENNAS;i++)
    {
        if(!Antenna[i][aExists]) continue;
        if(!Antenna[i][aPowered]) continue;
        if(Antenna[i][aHealth]>0.0)
        {
            Antenna[i][aHealth]-=0.5;
            if(Antenna[i][aHealth]<0.0) Antenna[i][aHealth]=0.0;
            UpdateAntennaVisual(i);
            SaveAntenna(i);
        }
    }
    return 1;
}
script AntennaFuel()
{
    for(new i; i < MAX_ANTENNAS; i++)
    {
        if(!Antenna[i][aExists]) continue;
        if(!Antenna[i][aPowered]) continue;
        if(Antenna[i][aFuel] > 0)
        {
            Antenna[i][aFuel]--;
            SaveAntenna(i);
        }
        else
        {
            Antenna[i][aPowered]=false;
            UpdateAntennaVisual(i);
            SaveAntenna(i);
        }
    }
    return 1;
}
script FinishSabotage(playerid,id)
{
    TogglePlayerControllable(playerid,1);
    Antenna[id][aHealth] -= 40.0;
    if(Antenna[id][aHealth] < 0.0) Antenna[id][aHealth] = 0.0;
    if(Antenna[id][aHealth] == 0.0) Antenna[id][aPowered] = 0;
    UpdateAntennaVisual(id);
    SaveAntenna(id);
    missioncheck = 55;
    SendTWMessage(playerid, "Talkie-Walkie : Go back to me to do your report.");
    return 1;
}
//plant
script LoadPlants()
{
    new rows, fields;
    cache_get_data(rows, fields);
    for(new i; i < rows && i < MAX_PLANTS; i++)
    {
        Plant[i][plantExists] = true;
        Plant[i][plantSQLID] = cache_get_field_content_int(i,"id");
        Plant[i][plantOwner] = cache_get_field_content_int(i,"owner");
        Plant[i][plantType] =  cache_get_field_content_int(i,"type");
        Plant[i][plantX] = cache_get_field_content_float(i,"x");
        Plant[i][plantY] = cache_get_field_content_float(i,"y");
        Plant[i][plantZ] = cache_get_field_content_float(i,"z");
        Plant[i][plantVW] = cache_get_field_content_int(i,"world");
        Plant[i][plantInterior] = cache_get_field_content_int(i,"interior");
        Plant[i][plantTime] = cache_get_field_content_int(i,"planttime");
        CreatePlant(i);
    }
    printf("[PLANTS] Loaded %d plants.", rows);
    return 1;
}
script OnPlantCreated(slot)
{
    Plant[slot][plantSQLID] = cache_insert_id();
    return 1;
}
script UpdatePlantLabels()
{
    for(new i; i < MAX_PLANTS; i++)
    {
        if(!Plant[i][plantExists])
            continue;

        UpdatePlantLabel(i);
    }

    return 1;
}
//weather
script RandomWeather()
{
    new r = random(100);
    if(r < 35)       CurrentWeather = 0;   // Sunny
    else if(r < 55)  CurrentWeather = 1;   // Bright
    else if(r < 70)  CurrentWeather = 3;   // Dull
    else if(r < 82)  CurrentWeather = 4;   // Cloudy
    else if(r < 90)  CurrentWeather = 8;   // Fog
    else if(r < 96)  CurrentWeather = 9;   // Heavy Fog
    else             CurrentWeather = 19;  // Sandstorm
    SetWeather(CurrentWeather);
    return 1;
}