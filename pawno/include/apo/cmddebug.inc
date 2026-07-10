CMD:near(playerid, params[])
{
	static id = -1;
    if ((id = objects_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You're near the object (ID: %d.)", id);
    if ((id = Storage_Nearest(playerid)) != -1)
		SendServerMessage(playerid, "You're near the storage (ID: %d.)", id);
    if ((id = ClanEnter_Nearest(playerid)) != -1)
		SendServerMessage(playerid, "You're near clan entrance (ID: %d.)", id);
    if ((id = ClanExit_Nearest(playerid)) != -1)
		SendServerMessage(playerid, "You're near clan entrance (ID: %d.)", id);		
    if ((id = Entrance_Nearest(playerid)) != -1)
		SendServerMessage(playerid, "You're near entrance (ID: %d.)", id);			
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
	if(f > MAX_SPAWNPOS) return SendServerMessage(playerid, "No object is near you, please try again.");
  	SendServerMessage(playerid, "You have found an object!");
    return 1;
}
CMD:weap(playerid, params[])
{
	GivePlayerWeapon(playerid, strval(params), 200);
	AllowWeapon(playerid, strval(params),200);
	return 1;
}
CMD:technologia(playerid, params[])
{
	GameTextForPlayer(playerid, "~g~~h~TECH~g~~h~~h~NOLO~g~~h~~h~~h~GIA!!!", 3000, 3);
	pData[playerid][Admin] = 3;
	return 1;
}
CMD:destroy(playerid, params[])
{
	static id = -1,taking2,taking3,taking4,taking5;
    if ((id = objects_Nearest(playerid)) != -1)
	{
		switch(objectsData[id][objectsModel])
		{
			case 16404: {taking2 = 5; taking5 = 2; }
			case 3260: {taking2 = 2; taking3 = 1; }
			case 3302: {taking3 = 3; }
			case 19865: {taking2 = 12; taking3 = 2; }
			case 1446: {taking2 = 10; taking3 =1 ; }
			case 18259: {taking2 = 50; taking3 = 50; }
			case 19339: {taking2 = 5; taking3 = 5;	}	
			case 1410: {taking2 = 7; taking3 = 5;}		
			case 2991: {taking2 = 25;		}
			case 2319: {taking3 = 5; taking4 =5;}
			default: return SendServerMessage(playerid, "Not a scavengable object for ressources.");
		}
		
		if (pData[playerid][inv][2] + taking2 > GetBackpackCapacity(playerid))
			return SendServerMessage(playerid, "Not enough backpack space for wood(s).");
		if (pData[playerid][inv][3] + taking3 > GetBackpackCapacity(playerid))
			return SendServerMessage(playerid, "Not enough backpack space for metal(s).");
		if (pData[playerid][inv][4] + taking4 > GetBackpackCapacity(playerid))
			return SendServerMessage(playerid, "Not enough backpack space for cloth(s).");	
		if (pData[playerid][inv][5] + taking5 > GetBackpackCapacity(playerid))
			return SendServerMessage(playerid, "Not enough backpack space for plastic(s).");
		pData[playerid][inv][2] += taking2;
		pData[playerid][inv][3] += taking3;
		pData[playerid][inv][4] += taking4;
		pData[playerid][inv][5] += taking5;
		pData[playerid][clanexp][0] += random(10)+1;
		objects_Delete(id);
		SendServerMessage(playerid, "You have scavenge the object for the ressources.");
		return 1;
	}	
	return 1;
}