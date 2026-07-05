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
CMD:weap(playerid, params[])
{
	GivePlayerWeapon(playerid, strval(params), 200);
	AllowWeapon(playerid, strval(params),200);
	return 1;
}