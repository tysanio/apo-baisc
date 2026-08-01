CMD:clan(playerid,params[])
{
	if (pData[playerid][Score] < 10)
	    return SendServerMessage(playerid, "You must be at least level 10 to use that command.");
	Dialog_Show(playerid, CLANDIALOG00, DIALOG_STYLE_LIST, "Clan Setup", "Create Clan\nClan Stats\nMembers list\nEnter position\nExit position\nChest position\nMax Rank\nDelete Clan", "OK", "");
	return 1;
}
CMD:clanchest(playerid, params[])
{
	static type[24];
	if (sscanf(params, "s[24]", type))
	{
		SendServerMessage(playerid,"[NAMES]:{FFFFFF} withdraw, give");
		return 1;
	}
	else if (!strcmp(type, "withdraw", true))
	{
		if (pData[playerid][idclan] !=0)
		{
			new id = clans[pData[playerid][idclan]][idclan];	
			if(IsNearChest(playerid))
			{
				if (pData[playerid][clanrank] < clans[pData[playerid][idclan]][maxrank] - 1)
					return SendServerMessage(playerid, "You must be at least rank %d to use that command.", clans[pData[playerid][idclan]][maxrank] - 1);
				Dialog_Show(playerid, CLANDIALOG10, DIALOG_STYLE_TABLIST, "Clan Chest \tAmount","Meat(s) : \t%d\nWood(s) : \t%d\nMetal(s) : \t%d\nCloth(s) : \t%d\nPlastic(s) : \t%d\n\
				Gun Powder(s) : \t%d\nOre(s) :\t%d\nIron(s) : \t%d\nGold(s) : \t%d\nLockpick(s) : \t%d\n\
				Repair kit(s) : \t%d\nMed Kit(s) : \t%d\nJerrycan(s) : \t%d\n9mm Bullet(s) : \t%d\n00' Buck's : \t%d\n\
				.308(s) : \t%d\nArmor Plate(s) : \t%d\nWater Bottle : \t%d\nCanned Food : \t%d\nSeed(s) : \t%d\n\
				Potato(es) : \t%d\ninv22 : \t%d\nTomato(es) : \t%d\ninv24 : \t%d\ninv25 : \t%d", "OK", "",clans[id][inv][1],clans[id][inv][2],clans[id][inv][3],clans[id][inv][4],clans[id][inv][5],        clans[id][inv][6],clans[id][inv][7],clans[id][inv][8],clans[id][inv][9],clans[id][inv][10],        clans[id][inv][11],clans[id][inv][12],clans[id][inv][13],clans[id][inv][14],clans[id][inv][15],        clans[id][inv][16],clans[id][inv][17],clans[id][inv][18],clans[id][inv][19],clans[id][inv][20],        clans[id][inv][21],clans[id][inv][22],clans[id][inv][23],clans[id][inv][24],clans[id][inv][25]); 
			}
			else SendServerMessage(playerid,"You're not near your clan chest.");		
		}
		else SendServerMessage(playerid,"You're not in any clan.");
	}
	else if (!strcmp(type, "give", true))
	{
		if (pData[playerid][idclan] !=0)
		{
			if(IsNearChest(playerid))
			{
				Dialog_Show(playerid, CLANDIALOG20,DIALOG_STYLE_TABLIST,"Inventory","Meat(s) : \t%d\nWood(s) : \t%d\nMetal(s) : \t%d\nCloth(s) : \t%d\nPlastic(s) : \t%d\nGun Powder(s) : \t%d\nOre(s) : \t%d\nIron(s) : \t%d\nGold(s) : \t%d\nLockpick(s) : \t%d\n\
				Repair kit(s) : \t%d\nMed Kit( s): \t%d\nJerrycan(s) : \t%d\n9mm Bullet(s) : \t%d\n00' Buck's : \t%d\n.308(s) : \t%d\nArmor Plate(s) : \t%d\nWater Bottle : \t%d\nCanned Food : \t%d\nSeed(s): \t%d\n\
				Potato(es) : \t%d\ninv22 : \t%d\nTomato(es) : \t%d\ninv24 : \t%d\ninv25 : \t%d\
				", "Close","",pData[playerid][inv][1],pData[playerid][inv][2],pData[playerid][inv][3],pData[playerid][inv][4],pData[playerid][inv][5],\
				pData[playerid][inv][6],pData[playerid][inv][7],pData[playerid][inv][8],pData[playerid][inv][9],pData[playerid][inv][10],\
				pData[playerid][inv][11],pData[playerid][inv][12],pData[playerid][inv][13],pData[playerid][inv][14],pData[playerid][inv][15],\
				pData[playerid][inv][16],pData[playerid][inv][17],pData[playerid][inv][18],pData[playerid][inv][19],pData[playerid][inv][20],\
				pData[playerid][inv][21],pData[playerid][inv][22],pData[playerid][inv][23],pData[playerid][inv][24],pData[playerid][inv][25]);
			}
			else SendServerMessage(playerid,"You're not near your clan chest.");		
		}
		else SendServerMessage(playerid,"You're not in any clan.");
	}
	else return SendServerMessage(playerid, "Invalid option to choose from.");
	return 1;
}
CMD:claninvite(playerid, params[])
{
	new userid;
	if (pData[playerid][idclan] == -1)
	    return SendServerMessage(playerid, "You must be a clan member.");
	if (pData[playerid][clanrank] < clans[pData[playerid][idclan]][maxrank] - 1)
	    return SendServerMessage(playerid, "You must be at least rank %d to use that command.", clans[pData[playerid][idclan]][maxrank] - 1);
	if (sscanf(params, "u", userid))
	    return SendCommandMessage(playerid, "/claninvite [playerid/name]");
	if (userid == INVALID_PLAYER_ID)
	    return SendServerMessage(playerid, "That player is disconnected.");
	if (pData[userid][idclan] == pData[playerid][idclan])
	    return SendServerMessage(playerid, "That player is already part of your clan.");
    if (pData[userid][idclan] != 0)
	    return SendServerMessage(playerid, "That player is already part of another clan.");
	pData[userid][idclan] = pData[playerid][idclan];
    SendServerMessage(playerid, "You have %s to join your clan.", Name[userid]);
	new DCC_User:user1 = DCC_FindUserById(pData[userid][pDiscordID]);
	DCC_AddGuildMemberRole(GUILD_ID1,user1,RoleMember);
	return 1;
}
CMD:clanremove(playerid, params[])
{
    new userid;
	if (pData[playerid][idclan] == -1)
	    return SendServerMessage(playerid, "You must be a clan member.");
	if (pData[playerid][clanrank] < clans[pData[playerid][idclan]][maxrank] - 1)
	    return SendServerMessage(playerid, "You must be at least rank %d to use that command.", clans[pData[playerid][idclan]][maxrank] - 1);
	if (sscanf(params, "u", userid))
	    return SendCommandMessage(playerid, "/clanremove [playerid/name]");
	if (userid == INVALID_PLAYER_ID)
	    return SendServerMessage(playerid, "That player is disconnected.");
	if (pData[userid][idclan] != pData[playerid][idclan])
	    return SendServerMessage(playerid, "That player is not part of your clan.");
    SendServerMessage(playerid, "You have removed %s from the clan.", Name[playerid]);
    SendServerMessage(userid, "%s has removed you from the clan.", Name[playerid]);
	pData[userid][idclan] = 0;
	pData[userid][clanrank] = 0;
	return 1;
}
CMD:clanrank(playerid, params[])
{
    new userid,rankid;
	if (pData[playerid][idclan] == -1)
	    return SendServerMessage(playerid, "You must be a clan member.");
	if (pData[playerid][clanrank] < clans[pData[playerid][idclan]][maxrank] - 1)
	    return SendServerMessage(playerid, "You must be at least rank %d to use that command.", clans[pData[playerid][idclan]][maxrank] - 1);
	if (sscanf(params, "ud", userid, rankid))
	    return SendCommandMessage(playerid, "/frank [playerid/name] [rank (1-%d)]", clans[pData[playerid][idclan]][maxrank]);
	if (userid == INVALID_PLAYER_ID)
	    return SendServerMessage(playerid, "That player is disconnected.");
	if (userid == playerid)
	    return SendServerMessage(playerid, "You cannot set your own rank.");
	if (pData[userid][idclan] != pData[playerid][idclan])
	    return SendServerMessage(playerid, "That player is not part of your clan.");
	if (rankid < 0 || rankid > clans[pData[playerid][idclan]][maxrank])
	    return SendServerMessage(playerid, "Invalid rank specified. Ranks range from 1 to %d.", clans[pData[playerid][idclan]][maxrank]);
	pData[userid][clanrank] = rankid;
    SendServerMessage(playerid, "You have promoted %s to rank %d.", Name[playerid], rankid);
    SendServerMessage(userid, "%s has promoted you to rank %d.", Name[playerid], rankid);
	return 1;
}
CMD:clanquit(playerid, params[])
{
	if (pData[playerid][idclan] == -1)
	    return SendServerMessage(playerid, "You must be a member of any clan.");
	if (pData[playerid][clanrank] == clans[pData[playerid][idclan]][maxrank])
	    return SendServerMessage(playerid, "You are an owner of a clan use /clan to delete it");
	pData[playerid][idclan] = 0;
	pData[playerid][clanrank] = 0;
	SendServerMessage(playerid, "You just quit your clan.");
	return 1;
}
CMD:clanwar(playerid, params[])
{
    new attackerTeam = pData[playerid][idclan];
	if(pData[playerid][idclan] == 0) SendServerMessage(playerid,"You need to be in a clan to do a clan war");
    for (new i = 0; i < TotalGZ; i++)
    {
        if (IsPlayerInZone(playerid, GangZones[i][gMinX], GangZones[i][gMinY], GangZones[i][gMaxX], GangZones[i][gMaxY]))
        {
            new zoneID = i,remaining = GlobalZoneCooldown - gettime();
            if (ZoneInWar[i])
                return SendServerMessage(playerid,"[CAPTURE] A war is already ongoing in this zone.");
            // Check cooldown
			if (gettime() < GlobalZoneCooldown)
			{
    			SendServerMessage(playerid,"[CAPTURE] All zones are on cooldown for %d more seconds.", remaining);
			}
            if (GangZones[i][gTeamID] == attackerTeam)
                return SendServerMessage(playerid,"[CAPTURE] You already own this zone.");
            // Start war
			ZoneInWar[zoneID] = true;
			WarTimer[zoneID] = SetTimerEx("EndZoneWar", 30000, false, "d", zoneID);
			WarCheckTimer[zoneID] = SetTimerEx("CheckWarZoneEmpty", 5000, true, "d", zoneID);
			GangZoneFlashForAll(GangZones[zoneID][gZoneID], GetTeamZoneColor(attackerTeam));
            SendServerMessage(playerid,"[CAPTURE] Clan %d has started a war for zone %d!", attackerTeam, i);
            return 1;
        }
    }
    SendServerMessage(playerid,"[CAPTURE] You must be inside an enemy zone to start a war.");
    return 1;
}
CMD:clanres(playerid, params[])
{
    new attackerTeam = pData[playerid][idclan];
    for (new i = 0; i < TotalGZ; i++)
    {
        if (IsPlayerInZone(playerid, GangZones[i][gMinX], GangZones[i][gMinY], GangZones[i][gMaxX], GangZones[i][gMaxY]))
        {
			if (GangZones[i][gTeamID] != attackerTeam) return SendServerMessage(playerid, "[CLAN] You don't own this zone.");		
			if (pData[playerid][clanrank] < clans[pData[playerid][idclan]][maxrank] - 1)
			return SendServerMessage(playerid, "You must be at least rank %d to use that command.", clans[pData[playerid][idclan]][maxrank] - 1);			
			Dialog_Show(playerid, Ressources,DIALOG_STYLE_LIST,"Convert ressources ","Point(s) remaining:%d\n10 Meat(s) for 5\n10 Wood(s) for 2\n5 Metal(s) for 3\n5 Cloth(s) for 3\n5 Plastic(s) for 3\n10 Gun Powder(s) for 5\n2 Water Bottle for 1\n2 Canned Food for 1", "Convert", "Close",GangZones[i][gressources]);  
			return 1;
		}
    }
    return 1;
}