script CreateZombies()
{
	new str[50];
	if(SpawnedZombies < MAX_ZOMBIES)
	{
		new thenpc_,Float:x, Float:y, Float:z;
		format(str,sizeof(str),"Zombie[%d]",MAX_PLAYERS-(SpawnedZombies));
		thenpc_ = FCNPC_Create(str);
        x = 1796.9733 + random(1000) - random(1000);
        y = 1452.6584 + random(1000) - random(1000);
        MapAndreas_FindZ_For2DCoord(x, y, z);
        FCNPC_Spawn(thenpc_,z_zombieskin[random(sizeof(z_zombieskin))],x,y,z + 1.0);
		FCNPC_SetWeapon(thenpc_, 0);
		FCNPC_SetHealth(thenpc_, 100);
		ZombieTimer[thenpc_] = repeat ZombieMove(thenpc_);
		//SetPlayerColor(thenpc_,DEFAULT_COLOR);
		IsAZombie[thenpc_] = 1;
		SpawnedZombies++;
	}
	else
	{
		KillTimer(ZombiesTimer);
		printf("Zombies creation done!");
	}
	return 1;
}
public FCNPC_OnDeath(npcid, killerid, reason)
{
    FCNPC_GetPosition(npcid,ZombieDeadPos[npcid][0], ZombieDeadPos[npcid][1], ZombieDeadPos[npcid][2]);
    ZombieDead[npcid] = 1;
	pData[killerid][clanexp][0] += 10;
	pData[killerid][pZombieKill] += 1;
    ZombieIsAttack[npcid] = 0;
    FCNPC_Stop(npcid);
    FCNPC_StopAttack(npcid);
    ApplyAnimation(npcid,"PED","BIKE_fall_off",4.1,0,1,1,1,0,1);
	if (reason == 22)	switch(random(5))	{case 0: pData[killerid][pSkills][1] +=1;}
	if (reason == 23)	switch(random(5))	{case 1: pData[killerid][pSkills][2] +=1;}
	if (reason == 24)	switch(random(5))	{case 2: pData[killerid][pSkills][3] +=1;}
	if (reason == 25)	switch(random(5))	{case 3: pData[killerid][pSkills][4] +=1;}
	if (reason == 26)	switch(random(5))	{case 4: pData[killerid][pSkills][5] +=1;}
	if (reason == 27)	switch(random(5))	{case 0: pData[killerid][pSkills][6] +=1;}
	if (reason == 28 || reason == 32)	switch(random(5))	{case 1: pData[killerid][pSkills][7] +=1;}
	if (reason == 29)	switch(random(5))	{case 2: pData[killerid][pSkills][8] +=1;}
	if (reason == 30)	switch(random(5))	{case 3: pData[killerid][pSkills][9] +=1;}
	if (reason == 31)	switch(random(5))	{case 4: pData[killerid][pSkills][0] +=1;}
    return 1;
}
public FCNPC_OnTakeDamage(npcid, issuerid, Float:amount, weaponid, bodypart)
{
	if(bodypart == 9) {FCNPC_SetHealth(npcid,0);}
	return 1;
}
timer ZombieMove[500](zombieid)
{
	new Float:xa,Float:ya,Float:za,Float:ground;
	if(FCNPC_IsDead(zombieid)) return 1;
    FCNPC_GetPosition(zombieid, xa, ya, za);
    if(MapAndreas_FindZ_For2DCoord(xa, ya, ground))
    {
        if(floatabs(za - (ground + 1.0)) > 0.3)
        {
            FCNPC_SetPosition(zombieid, xa, ya, ground + 1.0);
        }
    }
	foreach(Player, playerid)
	{
		GetPlayerPos(playerid,xa,ya,za);
		if(IsPlayerInRangeOfPoint(zombieid,1.0,xa,ya,za))// here playerid not zombieid
		{
			ZombieIsAttack[zombieid] = 2;
			FCNPC_MeleeAttack(zombieid,100);
			break;
		}
		else if(IsPlayerInRangeOfPoint(zombieid,25.0,xa,ya,za))
		{
			if(ZombieIsAttack[zombieid] == 2)
			{
				FCNPC_Stop(zombieid);
				FCNPC_StopAttack(zombieid);
			}
			ZombieIsAttack[zombieid] = 1;
            MapAndreas_FindZ_For2DCoord(xa, ya, ground);
            FCNPC_GoTo(zombieid,xa,ya,ground + 1.0,FCNPC_MOVE_TYPE_RUN,0.4);
			break;
		}
		else if(IsPlayerInRangeOfPoint(zombieid,50.0,xa,ya,za))
		{
			if(ZombieIsAttack[zombieid] == 2)
			{
				FCNPC_Stop(zombieid);
				FCNPC_StopAttack(zombieid);
			}
			ZombieIsAttack[zombieid] = 1;
			FCNPC_GoToPlayerEx(zombieid, playerid,5,5,FCNPC_MOVE_TYPE_RUN);
			break;
		}
		else
		{
			ZombieIsAttack[zombieid] = 0;
		}
	}
	return 1;
}
stock FCNPC_GoToPlayerEx(npcid, playerid, Float:dist, Float:rangle, movetype = FCNPC_MOVE_TYPE_RUN)
{
	new Float:xa, Float:ya, Float:za, Float:fa,Float:ground;
	GetPlayerPos(playerid, xa, ya, za);
	GetPlayerFacingAngle(playerid, fa);
	rangle += fa;
	xa = (xa + dist * floatsin(-rangle,degrees));
	ya = (ya + dist * floatcos(-rangle,degrees));
    MapAndreas_FindZ_For2DCoord(xa, ya, ground);
    FCNPC_GoTo(npcid,xa,ya,ground + 1.0,movetype,0.4);
    return 1;
}
script RespawnZombie(npcid)
{
    if(FCNPC_IsValid(npcid) && FCNPC_IsDead(npcid))
    {
        FCNPC_Respawn(npcid);
    }
	return 1;
}
public FCNPC_OnRespawn(npcid)
{
	FCNPC_SetWeapon(npcid,0);
	FCNPC_ApplyAnimation(npcid, "PED", "WALK_DRUNK", 4.1, 1, 1,  1,  0,  0);
	FCNPC_SetAmmo(npcid,1);
	FCNPC_Stop(npcid);
	FCNPC_StopAttack(npcid);
    new Float:x, Float:y, Float:z;
    x = 1796.9733 + random(2000) - 1000;
    y = 1452.6584 + random(2000) - 1000;
    MapAndreas_FindZ_For2DCoord(x, y, z);
    FCNPC_SetPosition( npcid,x,y,z + 1.0);
    return 1;
}
script ZombieGroundFix()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsAZombie[i]) continue;
        if(FCNPC_IsDead(i)) continue;
        new Float:x, Float:y, Float:z, Float:ground;
        FCNPC_GetPosition(i, x, y, z);
        if(MapAndreas_FindZ_For2DCoord(x, y, ground))
        {
            if(floatabs(z - (ground + 1.0)) > 0.5)
            {
                FCNPC_SetPosition(i, x, y, ground + 1.0);
            }
        }
    }
    return 1;
}