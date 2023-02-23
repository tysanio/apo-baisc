CMD:near(playerid, params[])
{
	static id = -1;
    if ((id = objects_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You're near the object (ID: %d.)", id);
	return 1;
}
CMD:zonecheck(playerid,params[])
{
    new e;
    if(0 <= e < MAX_ZONE)
 	{
        if(IsPlayerInDynamicArea(playerid,zone[e][zoneplace],1)) SendServerMessage(playerid,"Name %s Clan ID : %d",zone[e][namezone],zone[e][clanid]);
        else SendServerMessage(playerid,"Out of the zone");
    }
    return 1;
}
CMD:weap(playerid, params[])
{
	GivePlayerWeapon(playerid, strval(params), 200);
	return 1;
}
CMD:virtualworld(playerid, params[])
{
    SendServerMessage(playerid,"Virtual world %d",GetPlayerVirtualWorld(playerid));
	return 1;
}
CMD:gotoactor(playerid, params[])
{
	static actorid;
	if (sscanf(params, "u", actorid))
 	{
	 	SendServerMessage(playerid, "/gotoactor [id]");
		return 1;
	}
    if (actorid == INVALID_ACTOR_ID)
	{
		SendServerMessage(playerid, "/gotoactor [id]");
		return 1;
	}
	SendPlayerToActor(playerid, actorid);
	return 1;
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
