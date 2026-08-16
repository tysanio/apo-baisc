script actorclanc()
{
    //clan asylum
    CreateActor(162,-672.4170,2704.1809,70.7614,246.4555);
    CreateActor(162,-624.4245,2707.8982,72.3750,87.9074);
    CreateActor(162,-624.1594,2712.2605,72.3750,77.5673);
    CreateActor(162,-603.9059,2711.1470,72.3750,95.4274);
    CreateActor(162,-599.7225,2712.2048,72.3750,272.4625);
    CreateActor(162,-582.3083,2716.6399,72.0623,97.3075);
    CreateActor(162,-578.5978,2715.0129,72.0242,303.4593);
    CreateActor(162,-580.9335,2708.3379,71.5887,165.5914);
    CreateActor(162,-600.9240,2710.0220,72.3750,199.4317);
    missionactor[0] = CreateActor(168,-676.4368,2706.6545,70.1794,69.7340);
    missionactor[1] = CreateActor(200,-679.5840,2701.0906,70.3549,61.2739);
	//clanpolice or somehting
	CreateActor(282,-219.1680,983.6078,19.5269,18.3019); 
	CreateActor(283,-219.2213,974.5335,19.4927,254.5340); 
	CreateActor(282,-221.2942,974.2610,22.2833,265.0190); 
	CreateActor(283,-228.7793,979.0109,22.2833,359.6465); 
	CreateActor(302,-216.7117,981.4099,22.9432,323.2761); 
	CreateActor(302,-215.5549,977.2121,22.9432,235.8553); 
	missionactor[2] = CreateActor(311,-226.5449,980.5844,19.5498,8.5856);
	missionactor[3] = CreateActor(309,-229.7154,980.6211,19.5516,7.0189);
	//sciene and army
	CreateActor(179,282.4752,1872.3901,8.7578,102.7513);
	CreateActor(179,282.5449,1866.9982,8.7578,87.5662);
	CreateActor(287,279.8940,1864.6954,8.7578,7.8572); 
	CreateActor(287,301.1192,1857.5419,7.7266,180.6506);
	CreateActor(287,301.0567,1853.2960,7.7266,352.9856); 
	CreateActor(287,295.7274,1857.1534,7.8281,263.2263);
	missionactor[4] = CreateActor(70,272.2670,1854.0015,8.7649,171.0822); // science
	missionactor[5] = CreateActor(70,279.6077,1855.4661,8.7649,296.1035); // science
	missionactor[6] = CreateActor(191,273.4673,1864.6194,8.7578,4.8688); // spécial faction
	//other NPC
	missionactor[7] = CreateActor(260,584.7945,870.1245,-42.4973,283.6910); //miner
    return 1;
}
Dialog:Missionclan00(playerid, response, listitem, inputtext[])
{
    if (response)
	{
        switch (listitem)
        {
			case 0: 
			{
				if(pData[playerid][inv][1] <= 0) return Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 1", "Hey meat bag we need meats!\nBring us all the meat you can find and we gonna pay you.\nSimple right? GO GRAB SOME MEAT(S).", "OK", "");
				else 
				{
					new meat = pData[playerid][inv][1],exp = meat*2;
					pData[playerid][clanexp][1] += exp;
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 1 done", "Thank for THAT MEAT(S)!!\n{0f5900}Exp clan + %d", "OK", "", exp);
					pData[playerid][inv][1] = 0;
				}
			}
			case 1:
			{
				if(GetPlayerWeapon(playerid) == 4)
				{
					pData[playerid][clanexp][1] += 100;
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 2 done", "Thank for the chop chop!!\n{0f5900}Exp clan + 100", "OK", "");
					//remove weapon
					RemovePlayerWeapon(playerid, 4);
				}
				else Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 2", "You dont have the chop chop!\nBring us the chop chop for the meat!", "OK", "");
			}
			case 2:
			{
				if(pData[playerid][missioncheck] == 11)
				{
					pData[playerid][clanexp][1] += 200;
					pData[playerid][missioncheck] = 0;
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 3 done", "Thank for the report.\n{0f5900}Exp clan + 200", "OK", "");
					if(pData[playerid][pAchievements][4] == 0)
				    {
                        SendACMessage(playerid,"Did you visite a lot of the map?");
                        pData[playerid][clanexp][0] += 500;
                        pData[playerid][pAchievements][4] = 1;
                    }
				}
				else
				{
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 3", "Go outside to see what going on and report to me!", "OK", "");
					mysql_format(mysql, query, sizeof(query),"SELECT x, y, z FROM missions ORDER BY RAND() LIMIT %d", MAX_MISSION_CHECKPOINTS);
					mysql_tquery(mysql, query, "OnMissionLoadRandomCheckpoints", "d", playerid);
					pData[playerid][missioncheck] = 1;
				}
			}
			case 3:
			{
				if(pData[playerid][missioncheck] == 55)
				{
					pData[playerid][clanexp][1] += 50;
					pData[playerid][inv][14] += 5;
					pData[playerid][missioncheck] = 0;
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 4 done", "Thank for the sabotage of the antenna.\n{0f5900}Exp clan + 50 and 5 9mm bullet(s)", "OK", "");
				}
				else
				{				
					new antenna = GetHighestHealthAntenna();
					if(antenna == -1) return SendServerMessage(playerid,"No antenna available.");
					SetPlayerCheckpoint(playerid, Antenna[antenna][aPosX],Antenna[antenna][aPosY],Antenna[antenna][aPosZ], 5.0);												
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 4", "Go sabotage some antenna!", "OK", "");
					pData[playerid][missioncheck] = 5;
				}
			}
            case 6:
            {
                if(pData[playerid][clanexp][1] >= 2500)
                {
                    pData[playerid][clanexp][1] -= 2500;
                    pData[playerid][Score] += 1;
                    SetPlayerScore(playerid, pData[playerid][Score]);
                    Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Level UP", "Level up +1\nClan Exp -2500", "OK", "");
                }
                else Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Level UP", "You don't have the right amount of EXP do it (2500)", "OK", "");
            }
        }
        return 1;
    }
    return 1;
}
Dialog:Missionclan10(playerid, response, listitem, inputtext[])
{
    if (response)
	{
        switch (listitem)
        {
            case 0:
			{
				if(pData[playerid][pZombieKill] > 10)
				{
					pData[playerid][clanexp][2] += 100;
					pData[playerid][pZombieKill] -= 10;
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 1 done", "Rest and peace for who those where infected.\n{0f5900}Exp clan + 100", "OK", "");
				}
				else  Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 1", "Go kill some infected and report to me! (10 kills)", "OK", "");
			}
            case 1: {			}
			case 2: {			}
			case 3:
			{
				if(pData[playerid][missioncheck] == 22)
				{
					pData[playerid][clanexp][2] += 200;
					pData[playerid][missioncheck] = 0;
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 3 done", "Thank for the report.\n{0f5900}Exp clan + 200", "OK", "");
					if(pData[playerid][pAchievements][4] == 0)
				    {
                        SendACMessage(playerid,"Did you visite a lot of the map?");
                        pData[playerid][clanexp][0] += 500;
                        pData[playerid][pAchievements][4] = 1;
                    }
				}
				else 
				{
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 3", "Go outside to see what going on and report to me!", "OK", "");
					mysql_format(mysql, query, sizeof(query),"SELECT x, y, z FROM missions ORDER BY RAND() LIMIT %d", MAX_MISSION_CHECKPOINTS);
					mysql_tquery(mysql, query, "OnMissionLoadRandomCheckpoints", "d", playerid);
					pData[playerid][missioncheck] = 2;
				}
			}
            case 8:
            {
                if(pData[playerid][clanexp][2] >= 2500)
                {
                    pData[playerid][clanexp][2] -= 2500;
                    pData[playerid][Score] += 1;
                    SetPlayerScore(playerid, pData[playerid][Score]);
                    Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Level UP", "Level up +1\nClan Exp -2500", "OK", "");
                }
                else Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Level UP", "You don't have the right amount of EXP do it (2500)", "OK", "");
            }
        }
        return 1;
    }
    return 1;
}
Dialog:Missionclan20(playerid, response, listitem, inputtext[])
{
    if (response)
	{
        switch (listitem)
        {
            case 0:
			{
				if(pData[playerid][inv][18] <= 0 && pData[playerid][inv][19] <= 0) return Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 1", "Hey civilians our guys need food for the barrack.\nThe water is for the coffee addict please bring some.", "OK", "");
				else 
				{
					new food1 = pData[playerid][inv][19],exp1 = food1*2;
					new water1 = pData[playerid][inv][18],exp2 = water1*2;
					pData[playerid][clanexp][3] += exp1+exp2;
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 1 done", "Thank for the food and water civilian.\n{0f5900}Exp clan + %d", "OK", "", exp1+exp2);
					pData[playerid][inv][19] = 0;
					pData[playerid][inv][18] = 0;
				}
			}
            case 1: 
			{
				if(pData[playerid][missioncheck] == 0)
				{
					new antenna = GetLowestHealthAntenna();
					if(antenna == -1) return Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 2", "All antenna is repair good job civilian.", "OK", "");
					pData[playerid][missioncheck] = 4;
					SetPlayerCheckpoint( playerid,Antenna[antenna][aPosX],Antenna[antenna][aPosY],Antenna[antenna][aPosZ],5.0);
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 2", "Hey civilians one of our antenna need repair go repair it!", "OK", "");
				}
				if(pData[playerid][missioncheck] == 44)
				{
					pData[playerid][missioncheck] = 0;
					pData[playerid][clanexp][3] += 50;
					//reward XP clan and food/water ??
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 2 done", "Thank for the repair on that antenna civilian.\n{0f5900}Exp clan + 50", "OK", "");
				}

			}
			case 2:
			{
				if(pData[playerid][missioncheck] == 33)
				{
					pData[playerid][clanexp][3] += 200;
					pData[playerid][missioncheck] = 0;
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 3 done", "Thank for the report.\n{0f5900}Exp clan + 200", "OK", "");
					if(pData[playerid][pAchievements][4] == 0)
				    {
                        SendACMessage(playerid,"Did you visite a lot of the map?");
                        pData[playerid][clanexp][0] += 500;
                        pData[playerid][pAchievements][4] = 1;
                    }
				}
				else
				{
					Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Mission 3", "Go outside to see what going on and report to me!", "OK", "");
					mysql_format(mysql, query, sizeof(query),"SELECT x, y, z FROM missions ORDER BY RAND() LIMIT %d", MAX_MISSION_CHECKPOINTS);
					mysql_tquery(mysql, query, "OnMissionLoadRandomCheckpoints", "d", playerid);
					pData[playerid][missioncheck] = 3;
				}
			}
            case 7:
            {
                if(pData[playerid][clanexp][3] >= 2500)
                {
                    pData[playerid][clanexp][3] -= 2500;
                    pData[playerid][Score] += 1;
                    SetPlayerScore(playerid, pData[playerid][Score]);
                    Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Level UP", "Level up +1\nClan Exp -2500", "OK", "");
                }
                else Dialog_Show(playerid, MISSIONTALK, DIALOG_STYLE_MSGBOX, "Level UP", "You don't have the right amount of EXP do it (2500)", "OK", "");
            }
        }
        return 1;
    }
    return 1;
}
Dialog:Missionclan22(playerid, response, listitem, inputtext[])
{
    if (response)
	{
        switch (listitem)
        {
            case 0: {	}
            case 1:
            {            }
        }
        return 1;
    }
    return 1;
}
Dialog:Missionclan222(playerid, response, listitem, inputtext[])
{
    if (response)
	{
		mysql_format(mysql, query, sizeof(query),"SELECT x, y, z FROM missions ORDER BY RAND() LIMIT %d", MAX_MISSION_CHECKPOINTS);
		mysql_tquery(mysql, query, "OnMissionLoadRandomCheckpoints", "d", playerid);
        return 1;
    }
    return 1;
}
Dialog:Missionclan2222(playerid, response, listitem, inputtext[])
{
    if (response)
	{
		mysql_format(mysql, query, sizeof(query),"SELECT x, y, z FROM missions ORDER BY RAND() LIMIT %d", MAX_MISSION_CHECKPOINTS);
		mysql_tquery(mysql, query, "OnMissionLoadRandomCheckpoints", "d", playerid);
    }
    return 1;
}
script mapping()
{
    new retexture;
	//église
	CreateDynamicObject(18783, -1991.81006, 1118.50000, 453.84000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(18766, -1986.80005, 1128.03003, 458.73001,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(18766, -1996.80005, 1128.01001, 458.82001,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(18766, -1996.63000, 1108.93994, 458.73001,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(18766, -1986.64001, 1108.96997, 458.73001,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(18766, -1982.00000, 1113.50000, 458.73001,   0.00000, 0.00000, 90.00000,-1,-1);
	CreateDynamicObject(18766, -1982.00000, 1123.50000, 458.70001,   0.00000, 0.00000, 90.00000,-1,-1);
	CreateDynamicObject(18766, -2001.09998, 1123.37000, 458.73999,   0.00000, 0.00000, 90.00000,-1,-1);
	CreateDynamicObject(18766, -1985.39001, 1115.33997, 458.70999,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(18766, -1989.92004, 1110.76001, 458.69000,   0.00000, 0.00000, 90.00000,-1,-1);
	CreateDynamicObject(18766, -1985.52002, 1122.06995, 458.64001,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(18766, -1990.01001, 1126.56995, 458.69000,   0.00000, 0.00000, 90.00000,-1,-1);
	CreateDynamicObject(18766, -2001.09998, 1113.42004, 458.73001,   0.00000, 0.00000, 90.00000,-1,-1);
	CreateDynamicObject(9316, -1974.23999, 1123.70996, 457.10001,   0.00000, 0.00000, -90.00000,-1,-1);
	CreateDynamicObject(1557, -1982.44995, 1117.21997, 457.31000,   0.00000, 0.00000, 90.00000,-1,-1);
	CreateDynamicObject(1557, -1982.44995, 1120.17004, 457.29999,   0.00000, 0.00000, -90.00000,-1,-1);
	CreateDynamicObject(1280, -1992.16003, 1114.48999, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1992.05005, 1111.31006, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1993.85999, 1114.46997, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1993.81995, 1111.42004, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1995.32996, 1114.65002, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1995.46997, 1111.46997, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1996.79004, 1114.72998, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1996.84998, 1111.27002, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1998.18994, 1114.80005, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1998.18994, 1111.23999, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1991.96997, 1125.75000, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1992.00000, 1123.04004, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1994.12000, 1125.88000, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1996.18005, 1122.56006, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1996.18005, 1125.78003, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1998.10999, 1122.48999, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1998.05005, 1125.67004, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1280, -1994.10999, 1122.75000, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(2207, -1998.98999, 1117.62000, 456.29999,   0.00000, 0.00000, 88.00000,-1,-1);
	CreateDynamicObject(627, -1983.54004, 1116.63000, 459.07999,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(627, -1983.22998, 1120.82996, 459.01999,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(3806, -1989.26001, 1121.19995, 456.67999,   0.00000, 0.00000, -90.00000,-1,-1);
	CreateDynamicObject(3806, -1989.31006, 1116.28003, 456.67999,   0.00000, 0.00000, 90.00000,-1,-1);
	CreateDynamicObject(16779, -1997.98999, 1118.93994, 461.17999,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(18783, -1991.56995, 1118.51001, 463.66000,   0.00000, 180.00000, 0.00000,-1,-1);
	CreateDynamicObject(644, -2000.01001, 1110.16003, 456.60001,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(644, -1999.95996, 1126.68994, 456.62000,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(19381, -1995.35999, 1118.81995, 456.26001,   0.00000, 90.00000, 0.00000,-1,-1);
	CreateDynamicObject(19381, -1984.89001, 1118.80005, 456.26001,   0.00000, 90.00000, 0.00000,-1,-1);
	CreateDynamicObject(2712, -1990.79004, 1121.58997, 456.89999,   0.00000, 0.00000, 0.00000,-1,-1);
	CreateDynamicObject(1742, -2000.72998, 1125.05005, 456.35001,   0.00000, 0.00000, 90.00000,-1,-1);
	CreateDynamicObject(1742, -2000.73999, 1112.23999, 456.35999,   0.00000, 0.00000, 90.00000,-1,-1);
	//trailer park
	retexture = CreateDynamicObject(19445, 2334.13672, -1041.55115, 1044.74890,   0.00000, 0.00000, 0.00000);
 	SetDynamicObjectMaterial(retexture, 0, 17008, "farmhouse", "gz_vic2c", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19445, 2330.46118, -1043.88293, 1044.74890,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(retexture, 0, 17008, "farmhouse", "gz_vic2c", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19445, 2330.46118, -1053.51685,1044.74890,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(retexture, 0, 17008, "farmhouse", "gz_vic2c", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19445, 2334.13672, -1054.45313, 1044.74890,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(retexture, 0, 17008, "farmhouse", "gz_vic2c", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19445, 2332.15381, -1054.61560, 1044.74890,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(retexture, 0, 17008, "farmhouse", "gz_vic2c", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19445, 2331.68042, -1042.38049, 1044.74890,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(retexture, 0, 17008, "farmhouse", "gz_vic2c", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19445, 2332.15381, -1054.61560, 1048.24890,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(retexture, 0, 17008, "farmhouse", "gz_vic2c", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19445, 2331.68042, -1042.38049, 1048.24890,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(retexture, 0, 17008, "farmhouse", "gz_vic2c", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19383, 2334.13574, -1047.54578, 1044.74890,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(retexture, 0, 17008, "farmhouse", "gz_vic2c", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19426, 2334.13574, -1049.95264, 1044.74890,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(retexture, 0, 17008, "farmhouse", "gz_vic2c", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19449, 2339.04150, -1046.27856, 1044.74890,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_wall3", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19449, 2339.04150, -1049.72656, 1044.74890,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_wall3", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19449, 2336.67090, -1047.77747, 1044.74890,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_wall3", 0xFFFFFFFF);
    retexture = CreateDynamicObject(19383, 2334.14600, -1047.54175, 1044.74690,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_wall3", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19426, 2334.14600, -1049.94861, 1044.74690,   0.00000, 0.00000, 180.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_wall3", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19448, 2335.80103, -1048.51013, 1046.48640,   0.00000, -87.00000, 0.00000);
    SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_wall2", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19447, 2332.31909, -1046.34253, 1046.74670,   0.00000, -84.00000, 0.00000);
    SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_wall1", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19447, 2332.31909, -1055.97644, 1046.74670,   0.00000, -84.00000, 0.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_wall1", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19447, 2332.26904, -1046.34253, 1046.74670,   0.00000, -84.00000, 180.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_wall1", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19447, 2332.26904, -1055.97644, 1046.74670,   0.00000, -84.00000, 180.00000);
    SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_wall1", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19446, 2332.29980, -1052.80164, 1042.95410,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(retexture, 0, 5134, "wasteland_las2", "floorboard256128", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19446, 2332.29980, -1043.16760, 1042.95410,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(retexture, 0, 5134, "wasteland_las2", "floorboard256128", 0xFFFFFFFF);
	retexture = CreateDynamicObject(19446, 2335.79810, -1046.36084, 1042.95410,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(retexture, 0, 5134, "wasteland_las2", "floorboard256128", 0xFFFFFFFF);
	retexture = CreateDynamicObject(18762, 2339.07593, -1048.01001, 1045.16420,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_win2", 0xFFFFFFFF);
	retexture = CreateDynamicObject(2255, 2331.02588, -1047.89941, 1044.72040,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_win", 0xFFFFFFFF);
	retexture = CreateDynamicObject(2255, 2331.02588, -1048.74243, 1044.72040,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_win", 0xFFFFFFFF);
	retexture = CreateDynamicObject(2346, 2334.04199, -1044.72290, 1044.8977,   90.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_win", 0xFFFFFFFF);
	retexture = CreateDynamicObject(2346, 2331.83960, -1041.97815, 1044.8977,   90.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_win", 0xFFFFFFFF);
	retexture = CreateDynamicObject(2346, 2330.55542, -1043.71436, 1044.8977,   90.00000, 0.00000, -90.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_win", 0xFFFFFFFF);
	retexture = CreateDynamicObject(2346, 2330.55542, -1051.62634, 1044.8977,   90.00000, 0.00000, -90.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_win", 0xFFFFFFFF);
	retexture = CreateDynamicObject(2346, 2334.04199, -1052.63293, 1044.8977,   90.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_win", 0xFFFFFFFF);
	retexture = CreateDynamicObject(2346, 2332.84229, -1055.01904, 1044.8977,   90.00000, 0.00000, 180.00000);
	SetDynamicObjectMaterial(retexture, 0, 3167, "trailers", "trail_win", 0xFFFFFFFF);
	CreateDynamicObject(1495, 2334.64502, -1046.38147, 1043.03510,   0.00000, 0.00000, 0.00000);
	retexture = CreateDynamicObject(19174, 2335.39771, -1046.35425, 1044.08620,   0.00000, -90.00000, 0.00000);
	SetDynamicObjectMaterial(retexture, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	CreateDynamicObject(2074, 2335.32227, -1047.99915, 1046.40330,   0.00000, 0.00000, 0.00000);
	retexture = CreateDynamicObject(19426, 2333.25122, -1046.30847, 1042.89190,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(retexture, 0, 17008, "farmhouse", "gz_vic2c", 0xFFFFFFFF);
	//caravan intérieur
	CreateDynamicObject(14385, 2511.64, -1725.44, 779.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(14386, 2511.68, -1726.33, 779.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(6959, 2509.99, -1725.07, 777.64,   0.00, 0.00, 0.00);
	CreateDynamicObject(5856, 2509.53, -1731.39, 779.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(5856, 2509.33, -1728.60, 779.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(5856, 2509.53, -1726.11, 779.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(5856, 2509.51, -1722.18, 779.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(5856, 2508.47, -1723.26, 779.62,   0.00, 0.00, 90.00);
	CreateDynamicObject(5856, 2511.75, -1732.36, 779.64,   0.00, 0.00, 90.00);
	CreateDynamicObject(5856, 2512.50, -1718.45, 779.62,   0.00, 0.00, 90.00);
	CreateDynamicObject(5856, 2508.47, -1720.58, 779.62,   0.00, 0.00, 90.00);
	CreateDynamicObject(5856, 2510.50, -1718.54, 779.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(5856, 2513.87, -1722.26, 779.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(5856, 2513.82, -1718.46, 779.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(5856, 2513.88, -1726.27, 779.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(5856, 2513.86, -1732.01, 779.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(1506, 2513.86, -1728.39, 777.64,   0.00, 0.00, 270.27);
	CreateDynamicObject(1506, 2513.91, -1728.41, 779.47,   0.00, 0.00, 270.27);
	CreateDynamicObject(970, 2511.75, -1732.08, 778.16,   90.00, 180.00, 0.00);
	CreateDynamicObject(970, 2509.78, -1732.34, 778.19,   90.00, 168.46, 281.54);
	CreateDynamicObject(970, 2513.58, -1732.32, 778.09,   90.00, 165.52, 104.48);
	CreateDynamicObject(970, 2513.58, -1725.89, 778.06,   90.00, 191.10, 78.90);
	CreateDynamicObject(970, 2513.88, -1726.11, 778.08,   90.00, 179.99, 0.00);
	CreateDynamicObject(970, 2509.60, -1728.11, 778.76,   90.00, 173.28, 276.72);
	CreateDynamicObject(1271, 2510.18, -1723.83, 778.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(1271, 2510.18, -1725.79, 778.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(1271, 2510.13, -1724.27, 777.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 2508.43, -1724.94, 778.64,   90.00, 179.99, 0.00);
	CreateDynamicObject(970, 2508.72, -1726.81, 778.19,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 2508.71, -1726.37, 778.19,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 2513.86, -1725.27, 778.61,   90.00, 179.99, 0.00);
	CreateDynamicObject(970, 2513.40, -1723.75, 778.64,   90.00, 180.00, 90.00);
	CreateDynamicObject(970, 2513.83, -1725.82, 778.19,   0.00, 0.00, 0.00);
	CreateDynamicObject(1271, 2509.67, -1727.24, 779.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(2238, 2509.91, -1729.96, 779.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(2238, 2510.36, -1726.62, 778.60,   90.00, 0.00, 90.00);
	CreateDynamicObject(970, 2511.14, -1720.63, 778.79,   0.00, 90.00, 0.00);
	CreateDynamicObject(970, 2513.45, -1720.60, 778.74,   0.00, 90.00, 0.00);
	CreateDynamicObject(970, 2512.92, -1720.63, 780.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 2510.54, -1721.08, 778.19,   0.00, 90.00, 270.00);
	CreateDynamicObject(970, 2510.78, -1719.46, 777.96,   90.00, 180.01, 180.00);
	CreateDynamicObject(970, 2510.71, -1718.87, 778.06,   90.00, 179.99, 0.00);
	CreateDynamicObject(2238, 2513.51, -1724.43, 779.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(2238, 2513.54, -1723.88, 779.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2238, 2513.50, -1722.42, 779.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(2238, 2513.50, -1721.91, 779.63,   0.00, 0.00, 0.00);
	CreateDynamicObject(2238, 2513.52, -1723.09, 779.81,   0.00, 90.00, 90.00);
	CreateDynamicObject(2238, 2512.34, -1725.89, 779.85,   0.00, 90.00, 0.00);
	CreateDynamicObject(2238, 2513.22, -1725.84, 779.87,   0.00, 90.00, 0.00);
	CreateDynamicObject(2238, 2510.32, -1726.63, 778.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(5856, 2509.52, -1728.53, 782.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(5856, 2511.66, -1731.29, 780.87,   0.00, 90.00, 90.00);
	CreateDynamicObject(1749, 2509.80, -1725.85, 778.65,   0.00, 0.00, 89.73);
	CreateDynamicObject(5856, 2511.68, -1727.16, 780.87,   0.00, 90.00, 90.00);
	CreateDynamicObject(5856, 2511.67, -1723.13, 780.87,   0.00, 90.00, 90.00);
	CreateDynamicObject(5856, 2511.68, -1719.77, 780.87,   0.00, 90.00, 90.00);
	CreateDynamicObject(970, 2510.55, -1721.17, 780.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(3461, 2510.54, -1722.74, 779.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 2510.54, -1723.16, 779.91,   0.00, 0.00, 0.00);
	//entrainement swat
	CreateDynamicObject(14408, 1032.07, 1256.97, 1814.11,   0.00, 0.00, 0.00);
	CreateDynamicObject(14412, 1085.99, 1252.99, 1816.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1042.02, 1256.66, 1806.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(1649, 1041.90, 1256.88, 1805.68,   0.00, 0.00, 270.00);
	CreateDynamicObject(1649, 1042.02, 1264.76, 1805.68,   0.00, 0.00, 90.00);
	CreateDynamicObject(1649, 1041.92, 1264.79, 1805.68,   0.00, 0.00, 269.99);
	CreateDynamicObject(14409, 1019.61, 1237.17, 1801.63,   0.00, 0.00, 0.00);
	CreateDynamicObject(14409, 1051.82, 1252.73, 1807.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(14438, 1081.48, 1251.53, 1816.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(3851, 1041.89, 1261.80, 1813.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(3851, 1041.90, 1250.72, 1813.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(3851, 1062.86, 1258.83, 1813.77,   90.00, 0.00, 0.00);
	CreateDynamicObject(3851, 1062.81, 1254.93, 1813.77,   90.00, 0.00, 0.00);
	CreateDynamicObject(3851, 1062.79, 1250.82, 1813.77,   90.00, 0.00, 0.00);
	CreateDynamicObject(3851, 1062.84, 1246.87, 1813.77,   90.00, 0.00, 0.00);
	CreateDynamicObject(14438, 1019.76, 1250.07, 1816.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(5422, 1037.93, 1270.69, 1806.78,   0.00, 0.00, 90.00);
	CreateDynamicObject(8613, 1012.80, 1249.01, 1807.54,   0.00, 0.00, 179.99);
	CreateDynamicObject(16501, 1018.81, 1246.60, 1806.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(14438, 1019.18, 1264.25, 1816.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(16501, 1018.81, 1250.15, 1806.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(16501, 1015.36, 1253.58, 1806.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(16501, 1007.02, 1246.04, 1806.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(16501, 1007.03, 1250.10, 1806.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(16501, 1013.06, 1253.59, 1806.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(16501, 1013.29, 1257.12, 1806.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(16501, 1013.33, 1267.26, 1806.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(16501, 1016.78, 1263.80, 1806.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(16501, 1016.75, 1260.58, 1806.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(16501, 1025.29, 1262.25, 1806.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(16501, 1025.28, 1255.18, 1806.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(16501, 1025.29, 1264.13, 1806.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(3025, 1014.45, 1265.15, 1808.36,   0.00, 0.00, 90.00);
	CreateDynamicObject(3025, 1014.57, 1269.69, 1808.36,   0.00, 0.00, 90.00);
	CreateDynamicObject(3025, 1014.43, 1267.63, 1808.36,   0.00, 0.00, 90.00);
	CreateDynamicObject(3018, 1014.43, 1265.10, 1809.17,   0.00, 0.00, 90.00);
	CreateDynamicObject(3019, 1014.45, 1265.10, 1809.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3020, 1014.49, 1265.11, 1809.24,   0.00, 0.00, 90.00);
	CreateDynamicObject(3021, 1014.43, 1265.12, 1809.17,   0.00, 0.00, 90.00);
	CreateDynamicObject(3022, 1014.44, 1265.14, 1809.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3023, 1014.44, 1265.10, 1809.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(3024, 1014.44, 1265.10, 1809.22,   0.00, 0.00, 90.00);
	CreateDynamicObject(3077, 1011.52, 1268.37, 1804.77,   0.00, 0.00, 300.00);
	CreateDynamicObject(2051, 931.03, 1226.70, 1805.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(2055, 1012.08, 1267.29, 1807.23,   0.00, 0.00, 300.00);
	CreateDynamicObject(3111, 1035.33, 1361.31, 1801.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(3111, 1011.21, 1268.86, 1806.96,   90.00, 90.00, 30.00);
	CreateDynamicObject(1499, 1020.26, 1260.69, 1804.77,   0.00, 0.00, 90.00);
	CreateDynamicObject(1499, 1020.22, 1263.70, 1804.77,   0.00, 0.00, 270.00);
	CreateDynamicObject(3785, 1005.78, 1254.84, 1807.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(3785, 1005.78, 1258.62, 1807.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(18625, 1013.44, 1269.10, 1882.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1014.57, 1269.64, 1805.77,   0.00, 0.00, 90.00);
	CreateDynamicObject(1291, 1019.66, 1266.65, 1805.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(1291, 1019.66, 1267.38, 1805.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(1262, 1024.70, 1261.87, 1808.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(7191, 1021.98, 1254.32, 1810.94,   0.00, 90.00, 0.00);
	CreateDynamicObject(983, 1020.09, 1248.22, 1811.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1020.08, 1254.61, 1811.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1020.07, 1261.01, 1811.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1023.79, 1248.24, 1811.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1023.81, 1254.67, 1811.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1023.80, 1261.05, 1811.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1023.81, 1265.85, 1811.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1007.67, 1265.63, 1811.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1007.67, 1259.27, 1811.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1007.65, 1252.86, 1811.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1007.65, 1248.04, 1811.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1016.79, 1244.97, 1811.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1013.60, 1244.97, 1811.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1030.55, 1244.95, 1811.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1017.25, 1268.83, 1811.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1010.87, 1268.82, 1811.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1020.08, 1265.81, 1811.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1030.49, 1268.79, 1811.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1027.29, 1268.80, 1811.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1027.35, 1244.95, 1811.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1033.73, 1241.74, 1811.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1033.63, 1272.01, 1811.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(11245, 1065.91, 1252.68, 1814.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(14438, 1036.57, 1257.46, 1816.11,   0.00, 0.00, 90.00);
	CreateDynamicObject(3025, 1014.46, 1254.83, 1808.36,   0.00, 0.00, 90.00);
	CreateDynamicObject(3025, 1014.54, 1257.01, 1808.36,   0.00, 0.00, 90.00);
	CreateDynamicObject(3025, 1014.56, 1259.07, 1808.36,   0.00, 0.00, 90.00);
	CreateDynamicObject(1588, 1014.46, 1257.02, 1806.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1590, 1014.45, 1257.00, 1806.77,   0.00, 0.00, 90.00);
	CreateDynamicObject(1589, 1014.37, 1257.00, 1806.77,   0.00, 0.00, 90.00);
	CreateDynamicObject(1591, 1014.33, 1257.01, 1806.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(1592, 1014.41, 1257.01, 1806.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(1584, 1014.54, 1259.08, 1805.77,   0.00, 0.00, 90.00);
	CreateDynamicObject(1583, 1014.48, 1254.81, 1805.77,   0.00, 0.00, 90.00);
	CreateDynamicObject(3800, 1018.92, 1256.86, 1804.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(3800, 1018.91, 1257.93, 1804.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(16501, 1022.14, 1251.99, 1806.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(16770, 1034.03, 1270.72, 1806.36,   0.00, 0.00, 270.00);
	CreateDynamicObject(3659, 1043.36, 1265.81, 1805.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(3659, 1044.22, 1267.17, 1805.78,   0.00, 0.00, 90.00);
	CreateDynamicObject(3659, 1044.23, 1267.03, 1807.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(3025, 1041.01, 1258.87, 1808.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(3025, 1039.64, 1260.92, 1808.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(3025, 1035.51, 1255.96, 1808.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(3025, 1036.94, 1259.55, 1808.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(3025, 1038.37, 1258.12, 1808.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(3025, 1034.01, 1260.37, 1808.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(3025, 1032.34, 1255.28, 1808.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(3025, 1030.81, 1258.20, 1808.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(16501, 1038.35, 1250.94, 1806.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(16501, 1031.77, 1250.92, 1806.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(3659, 1043.34, 1265.81, 1807.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(3659, 1043.40, 1268.53, 1805.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(3659, 1043.36, 1268.53, 1807.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(3025, 1029.34, 1256.32, 1808.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(3025, 1028.08, 1261.66, 1808.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1040.96, 1259.03, 1805.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1583, 1039.59, 1261.07, 1805.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1585, 1038.32, 1258.27, 1805.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1583, 1036.85, 1259.69, 1805.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1035.41, 1256.15, 1805.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1585, 1033.86, 1260.49, 1805.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1032.30, 1255.44, 1805.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1583, 1030.76, 1258.34, 1805.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1029.26, 1256.53, 1805.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1585, 1027.96, 1261.82, 1805.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1614, 1041.78, 1248.87, 1808.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(1615, 1062.71, 1241.40, 1814.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(14410, 1112.13, 1252.10, 1803.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(3851, 1117.63, 1259.29, 1809.85,   0.00, 0.00, 90.00);
	CreateDynamicObject(3799, 1043.56, 1253.46, 1804.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(3798, 1048.36, 1257.80, 1804.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1044.16, 1265.84, 1808.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(1583, 1047.65, 1270.72, 1808.11,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1045.45, 1270.72, 1806.43,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1042.19, 1245.00, 1814.14,   0.00, 0.00, 90.00);
	CreateDynamicObject(1583, 1042.19, 1247.92, 1813.03,   0.00, 0.00, 90.00);
	CreateDynamicObject(3798, 1048.58, 1249.37, 1811.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(1654, 1053.21, 1269.42, 1812.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(1217, 1053.51, 1269.56, 1811.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(1218, 1052.78, 1270.04, 1811.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(1222, 1053.16, 1263.93, 1811.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(3057, 1053.50, 1268.42, 1811.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(2894, 1004.65, 1258.95, 1805.67,   0.00, 0.00, 0.00);
	CreateDynamicObject(2919, 1051.51, 1270.14, 1811.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(1252, 1052.63, 1269.25, 1812.09,   0.00, 0.00, 0.00);
	CreateDynamicObject(1318, 1041.78, 1248.93, 1809.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(1318, 1053.88, 1245.07, 1814.43,   0.00, 0.00, 0.00);
	CreateDynamicObject(1318, 1005.28, 1256.72, 1807.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(1318, 1103.21, 1245.17, 1810.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(1318, 1110.20, 1241.11, 1803.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(3798, 1048.44, 1254.99, 1811.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(3796, 1044.70, 1268.21, 1811.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1043.55, 1267.74, 1811.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(1583, 1044.26, 1268.70, 1811.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1045.83, 1270.72, 1813.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(1583, 1049.09, 1263.47, 1811.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1046.78, 1270.45, 1811.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(7191, 1081.25, 1257.22, 1810.93,   0.00, 90.00, 0.00);
	CreateDynamicObject(983, 1079.40, 1259.78, 1811.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1079.41, 1253.40, 1811.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1079.43, 1247.01, 1811.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1083.18, 1259.76, 1811.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1083.18, 1253.37, 1811.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1083.19, 1247.00, 1811.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1066.39, 1242.79, 1811.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1072.75, 1242.78, 1811.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1075.95, 1242.76, 1811.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1070.51, 1263.09, 1811.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1075.31, 1263.08, 1811.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1096.06, 1263.07, 1811.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1089.68, 1263.06, 1811.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1086.51, 1263.04, 1811.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1095.97, 1242.94, 1811.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1089.59, 1242.91, 1811.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1086.40, 1242.92, 1811.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1099.26, 1259.88, 1811.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1099.28, 1253.49, 1811.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1099.30, 1247.10, 1811.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(14416, 1065.29, 1259.97, 1807.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(9589, 1095.45, 1250.17, 1809.87,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1105.15, 1266.97, 1809.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(1583, 1095.00, 1250.23, 1812.79,   0.00, 0.00, 90.00);
	CreateDynamicObject(1583, 1094.16, 1257.76, 1806.95,   0.00, 0.00, 90.00);
	CreateDynamicObject(1583, 1082.85, 1249.00, 1806.95,   0.00, 0.00, 90.00);
	CreateDynamicObject(1584, 1095.48, 1251.41, 1809.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(1616, 1103.21, 1240.24, 1816.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1616, 1041.78, 1243.94, 1815.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(1614, 1109.71, 1256.83, 1810.45,   180.00, 0.00, 0.00);
	CreateDynamicObject(967, 1104.49, 1261.02, 1806.95,   0.00, 0.00, 270.00);
	CreateDynamicObject(1584, 1105.30, 1261.48, 1806.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(1583, 1108.52, 1266.97, 1810.91,   0.00, 0.00, 0.00);
	CreateDynamicObject(1431, 1108.64, 1262.10, 1807.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1685, 1106.50, 1264.88, 1807.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(1583, 1106.34, 1265.14, 1808.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(1584, 1108.07, 1263.18, 1806.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(1271, 1109.37, 1248.92, 1807.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(964, 1106.91, 1249.64, 1806.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(1569, 1110.21, 1239.73, 1800.60,   0.00, 0.00, 90.00);
	CreateDynamicObject(1569, 1110.20, 1242.73, 1800.61,   0.00, 0.00, 270.00);
	CreateDynamicObject(3024, 1014.44, 1267.64, 1809.22,   0.00, 0.00, 90.00);
	CreateDynamicObject(3022, 1014.44, 1267.68, 1809.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3023, 1014.44, 1267.64, 1809.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(3021, 1014.43, 1267.66, 1809.17,   0.00, 0.00, 90.00);
	CreateDynamicObject(3020, 1014.49, 1267.61, 1809.24,   0.00, 0.00, 90.00);
	CreateDynamicObject(3018, 1014.43, 1267.64, 1809.17,   0.00, 0.00, 90.00);
	CreateDynamicObject(3019, 1014.45, 1267.64, 1809.20,   0.00, 0.00, 90.00);
	//submarine interior
	CreateDynamicObject(3117, 520.2861328125, -2433.1201171875, 1203.025390625, 0, 0, 0);
    CreateDynamicObject(3117, 538.02746582031, -2431, 1203.025390625, 0, 0, 0);
	CreateDynamicObject(3117, 534.50219726563, -2431, 1203.025390625, 0, 0, 0);
	CreateDynamicObject(3117, 530.94000244141, -2431, 1203.025390625, 0, 0, 0);
	CreateDynamicObject(3117, 527.388671875, -2431, 1203.025390625, 0, 0, 0);
	CreateDynamicObject(9820, 533.20812988281, -2434.4289550781, 1203.9852294922, 0, 0, 270);
	CreateDynamicObject(3117, 538.01861572266, -2433.1201171875, 1203.025390625, 0, 0, 0);
	CreateDynamicObject(3117, 534.501953125, -2433.1201171875, 1203.025390625, 0, 0, 0);
	CreateDynamicObject(3117, 530.939453125, -2433.1201171875, 1203.025390625, 0, 0, 0);
	CreateDynamicObject(3117, 527.388671875, -2433.1201171875, 1203.025390625, 0, 0, 0);
	CreateDynamicObject(3117, 523.837890625, -2433.1201171875, 1203.025390625, 0, 0, 0);
	CreateDynamicObject(3095, 535.32977294922, -2429.962890625, 1207.4162597656, 90, 0, 180);
	CreateDynamicObject(3095, 533.54315185547, -2432.1628417969, 1207.4665527344, 90, 0, 180);
	CreateDynamicObject(3095, 539.5791015625, -2428.357421875, 1205.7175292969, 90, 0, 90);
	CreateDynamicObject(3095, 540.30078125, -2434.3935546875, 1206.4172363281, 0, 0, 0);
	CreateDynamicObject(3095, 543.3359375, -2435.3017578125, 1205.6912841797, 90, 0, 90);
	CreateDynamicObject(3095, 544.634765625, -2432.837890625, 1205.6922607422, 90, 0, 179.99450683594);
	CreateDynamicObject(3095, 531.34338378906, -2434.4631347656, 1206.4172363281, 0, 0, 0);
	CreateDynamicObject(3095, 544.28686523438, -2435.7065429688, 1203.1677246094, 180, 0, 0);
	CreateDynamicObject(3095, 539.814453125, -2438.6484375, 1205.7423095703, 90, 0, 270);
	CreateDynamicObject(3095, 544.1376953125, -2438.8251953125, 1204.4417724609, 90, 0, 0);
	CreateDynamicObject(2944, 539.60577392578, -2434.2741699219, 1204.5452880859, 0, 0, 261.20385742188);
	CreateDynamicObject(3095, 534.77545166016, -2434.1518554688, 1207.4167480469, 90, 0, 0);
	CreateDynamicObject(3095, 533.5185546875, -2431.5751953125, 1207.4672851563, 90, 0, 0);
	CreateDynamicObject(9819, 542.25457763672, -2437.5654296875, 1203.9002685547, 0, 0, 270.27026367188);
	CreateDynamicObject(1663, 541.26226806641, -2436.9877929688, 1203.6245117188, 0, 0, 0);
	CreateDynamicObject(3095, 526.58880615234, -2428.4353027344, 1202.9417724609, 90, 0, 270);
	CreateDynamicObject(3095, 522.07385253906, -2432.9611816406, 1202.6665039063, 90, 0, 180.27014160156);
	CreateDynamicObject(3095, 522.36553955078, -2434.474609375, 1206.4172363281, 0, 0, 0);
	CreateDynamicObject(16782, 539.89959716797, -2435.6579589844, 1204.6827392578, 0, 0, 0);
	CreateDynamicObject(3095, 524.52368164063, -2434.1721191406, 1202.7666015625, 90, 0, 0);
	CreateDynamicObject(2944, 530.34967041016, -2434.3896484375, 1204.5452880859, 0, 0, 351.41479492188);
	CreateDynamicObject(3095, 530.46459960938, -2438.6704101563, 1203.1427001953, 179.99450683594, 0, 0);
	CreateDynamicObject(10227, 530.46575927734, -2436.7365722656, 1204.9790039063, 0, 0, 90);
	CreateDynamicObject(3095, 526.03820800781, -2438.9262695313, 1203.2921142578, 90, 0, 270);
	CreateDynamicObject(3095, 534.91082763672, -2438.8146972656, 1207.3671875, 90, 0, 90);
	CreateDynamicObject(3095, 530.50500488281, -2438.7270507813, 1203.2661132813, 90, 0, 0);
	CreateDynamicObject(3095, 530.658203125, -2439.1062011719, 1205.8416748047, 0, 0, 0);
	CreateDynamicObject(3095, 524.54742431641, -2434.7482910156, 1203.3907470703, 90, 0, 179.99450683594);
	CreateDynamicObject(3095, 534.77416992188, -2434.7270507813, 1207.4172363281, 90, 0, 179.99450683594);
	CreateDynamicObject(2690, 529.82861328125, -2438.5744628906, 1203.4986572266, 0, 0, 192.54040527344);
	CreateDynamicObject(918, 533.12744140625, -2433.9267578125, 1203.5219726563, 0, 0, 0);
	CreateDynamicObject(918, 532.19744873047, -2433.884765625, 1203.5219726563, 0, 0, 300.18017578125);
	CreateDynamicObject(2312, 530.33752441406, -2432.1123046875, 1205.3646240234, 6, 0, 0);
	CreateDynamicObject(2886, 529.6884765625, -2432.1235351563, 1204.5522460938, 0, 0, 0);
	CreateDynamicObject(2886, 532.06359863281, -2432.1220703125, 1204.5522460938, 0, 0, 1.9849853515625);
	CreateDynamicObject(2312, 532.68737792969, -2432.107421875, 1205.3646240234, 5.99853515625, 0, 0);
	CreateDynamicObject(2063, 535.6181640625, -2432.4604492188, 1203.9842529297, 0, 0, 0);
	CreateDynamicObject(1242, 534.58074951172, -2432.4663085938, 1204.0692138672, 0, 0, 338.1201171875);
	CreateDynamicObject(1242, 534.97930908203, -2432.4438476563, 1204.0692138672, 0, 0, 23.905090332031);
	CreateDynamicObject(1242, 535.40185546875, -2432.4643554688, 1204.0692138672, 0, 0, 351.96069335938);
	CreateDynamicObject(2043, 534.83953857422, -2432.5034179688, 1203.5206298828, 0, 0, 270.27026367188);
	CreateDynamicObject(2043, 535.92388916016, -2432.52734375, 1203.5206298828, 0, 0, 70.869232177734);
	CreateDynamicObject(2969, 536.19653320313, -2432.4033203125, 1203.9854736328, 0, 0, 357.75);
	CreateDynamicObject(2690, 534.41552734375, -2431.447265625, 1203.4986572266, 0, 0, 190.50842285156);
	CreateDynamicObject(2690, 534.86975097656, -2431.4250488281, 1203.4986572266, 0, 0, 250.32806396484);
	CreateDynamicObject(2359, 535.0068359375, -2432.4235839844, 1204.9534912109, 0, 0, 0);
	CreateDynamicObject(2359, 536.29071044922, -2432.3913574219, 1204.9534912109, 0, 0, 356.03002929688);
	CreateDynamicObject(2358, 535.44219970703, -2432.48828125, 1204.4558105469, 0, 0, 0);
	CreateDynamicObject(1271, 531.34405517578, -2431.2106933594, 1203.5003662109, 0, 0, 0);
	CreateDynamicObject(1271, 532.06781005859, -2431.1884765625, 1203.5003662109, 0, 0, 358.78002929688);
	CreateDynamicObject(1271, 531.79602050781, -2431.1955566406, 1204.1760253906, 0, 0, 359.99841308594);
	CreateDynamicObject(3879, 522.79968261719, -2430.4990234375, 1216.5125732422, 0, 180, 180);
	CreateDynamicObject(3095, 520.33489990234, -2430.3913574219, 1202.5418701172, 90, 0, 270);
	CreateDynamicObject(2634, 521.62847900391, -2433.548828125, 1206.4168701172, 270, 0, 270.02026367188);
	CreateDynamicObject(2690, 543.03540039063, -2433.1096191406, 1203.4986572266, 0, 0, 312.13012695313);
	CreateDynamicObject(3111, 524.69171142578, -2434.1579589844, 1204.6546630859, 270, 90, 270);
	CreateDynamicObject(3386, 528.38543701172, -2434.1892089844, 1203.1496582031, 0, 0, 270);
	CreateDynamicObject(12985, 530.96057128906, -2429.4606933594, 1200.5476074219, 0, 0, 270.25);
	CreateDynamicObject(3095, 530.28283691406, -2425.46875, 1207.6424560547, 90, 0, 90);
	CreateDynamicObject(3095, 530.02172851563, -2428.9338378906, 1202.0416259766, 90, 0, 180);
	CreateDynamicObject(3095, 527.61779785156, -2429.9677734375, 1198.6169433594, 90, 0, 359.75);
	CreateDynamicObject(3095, 529.77532958984, -2425.46875, 1206.4172363281, 0, 0, 0);
	CreateDynamicObject(3095, 535.2802734375, -2425.4484863281, 1202.9177246094, 0, 0, 0);
	CreateDynamicObject(3095, 533.5009765625, -2425.4375, 1202.0418701172, 90, 0, 90);
	CreateDynamicObject(3095, 533.0244140625, -2434.4638671875, 1198.9937744141, 179.99450683594, 0, 0);
	CreateDynamicObject(3095, 531.04742431641, -2425.9897460938, 1199.6657714844, 48, 180, 90.25);
	CreateDynamicObject(1800, 528.29656982422, -2431.0593261719, 1198.9904785156, 0, 0, 270);
	CreateDynamicObject(1800, 528.2958984375, -2431.05859375, 1199.8658447266, 0, 0, 270);
	CreateDynamicObject(1800, 528.04467773438, -2434.041015625, 1198.9904785156, 0, 0, 270);
	CreateDynamicObject(1800, 528.322265625, -2437.9799804688, 1199.8656005859, 0, 0, 270);
	CreateDynamicObject(1800, 528.33276367188, -2437.978515625, 1198.9904785156, 0, 0, 270);
	CreateDynamicObject(1800, 531.681640625, -2437.94921875, 1198.9904785156, 0, 0, 270);
	CreateDynamicObject(1800, 531.68212890625, -2437.94921875, 1199.8653564453, 0, 0, 270);
	CreateDynamicObject(3095, 524.11560058594, -2434.4887695313, 1198.9937744141, 179.99450683594, 0, 0);
	CreateDynamicObject(3095, 529.396484375, -2440.3095703125, 1198.1677246094, 90, 0, 270);
	CreateDynamicObject(3095, 528.82373046875, -2440.3239746094, 1198.1677246094, 90, 0, 90.290161132813);
	CreateDynamicObject(2514, 520.80499267578, -2433.5725097656, 1198.9903564453, 0, 0, 89.730010986328);
	CreateDynamicObject(2739, 521.42553710938, -2433.4611816406, 1198.9903564453, 0, 0, 0);
	CreateDynamicObject(2739, 522.27471923828, -2433.4450683594, 1198.9903564453, 0, 0, 0);
	CreateDynamicObject(2944, 526.4873046875, -2432.8095703125, 1200.3696289063, 0, 0, 99.55810546875);
	CreateDynamicObject(3095, 533.1416015625, -2434.5673828125, 1201.7415771484, 0, 0, 0);
	CreateDynamicObject(3095, 524.17797851563, -2434.5625, 1201.7415771484, 0, 0, 0);
	CreateDynamicObject(3117, 533.58203125, -2430.0791015625, 1202.0744628906, 89.324340820313, 0, 359.74731445313);
	CreateDynamicObject(3095, 527.64892578125, -2430.5646972656, 1197.2668457031, 90, 0, 179.99450683594);
	CreateDynamicObject(2527, 526.66650390625, -2437.2890625, 1198.9655761719, 0, 0, 180);
	CreateDynamicObject(2527, 528.35589599609, -2437.2658691406, 1198.9655761719, 0, 0, 179.99450683594);
	CreateDynamicObject(11631, 534.91815185547, -2430.9252929688, 1200.2359619141, 0, 0, 0);
	CreateDynamicObject(3095, 538.060546875, -2430.2431640625, 1197.3377685547, 90, 0, 179.99450683594);
	CreateDynamicObject(1663, 535.23059082031, -2431.5083007813, 1199.4191894531, 0, 0, 160.60052490234);
	CreateDynamicObject(2007, 526.5126953125, -2435.2265625, 1198.9904785156, 0, 0, 0);
	CreateDynamicObject(2416, 527.42669677734, -2431.1213378906, 1198.8720703125, 0, 0, 0);
	CreateDynamicObject(1800, 528.0439453125, -2434.041015625, 1199.6906738281, 0, 0, 270);
	CreateDynamicObject(2690, 532.3095703125, -2438.2602539063, 1199.3232421875, 0, 0, 170.74377441406);
	CreateDynamicObject(2690, 536.43225097656, -2430.5341796875, 1199.3232421875, 0, 0, 335.35363769531);
	CreateDynamicObject(3095, 539.2568359375, -2438.7294921875, 1198.2911376953, 90, 0, 0);
	CreateDynamicObject(3095, 537.32739257813, -2436.1455078125, 1198.2918701172, 90, 0, 90);
	CreateDynamicObject(2944, 537.42340087891, -2431.7294921875, 1200.3696289063, 0, 0, 324.76245117188);
	CreateDynamicObject(1800, 536.50280761719, -2437.6374511719, 1198.9654541016, 0, 0, 0);
	CreateDynamicObject(1800, 536.501953125, -2437.63671875, 1199.8663330078, 0, 0, 0);
	CreateDynamicObject(3386, 537.34405517578, -2438.6044921875, 1198.9655761719, 0, 0, 319.61853027344);
	CreateDynamicObject(2007, 529.81372070313, -2436.6037597656, 1198.9654541016, 0, 0, 89.684936523438);
	CreateDynamicObject(2007, 536.85040283203, -2433.5270996094, 1198.9654541016, 0, 0, 270.22143554688);
	CreateDynamicObject(2007, 525.03350830078, -2433.8515625, 1198.9654541016, 0, 0, 180.48974609375);
	CreateDynamicObject(3095, 537.94476318359, -2434.2509765625, 1197.2440185547, 179.99450683594, 0, 0);
	CreateDynamicObject(3095, 546.93872070313, -2434.2585449219, 1197.2440185547, 179.99450683594, 0, 0);
	CreateDynamicObject(3095, 547.01922607422, -2430.2373046875, 1197.3377685547, 90, 0, 179.99450683594);
	CreateDynamicObject(3095, 548.23669433594, -2438.7329101563, 1198.2906494141, 90, 0, 0);
	CreateDynamicObject(3095, 542.13323974609, -2434.6682128906, 1201.1927490234, 0, 0, 0);
	CreateDynamicObject(3095, 550.76525878906, -2434.6833496094, 1198.3181152344, 90, 0, 90);
	CreateDynamicObject(3095, 551.06671142578, -2434.6713867188, 1201.1927490234, 0, 0, 0);
	CreateDynamicObject(3095, 538.14105224609, -2436.1105957031, 1197.1429443359, 90, 0, 270);
	CreateDynamicObject(3787, 541.83905029297, -2432.0568847656, 1197.7816162109, 0, 0, 89.730010986328);
	CreateDynamicObject(8572, 538.388671875, -2433.0817871094, 1197.7409667969, 0, 0, 89.730041503906);
	CreateDynamicObject(964, 539.80517578125, -2434.8369140625, 1197.2407226563, 0, 0, 0);
	CreateDynamicObject(964, 540.00012207031, -2433.5756835938, 1197.2407226563, 0, 0, 0);
	CreateDynamicObject(964, 539.96453857422, -2434.0815429688, 1198.1666259766, 0, 0, 352.06005859375);
	CreateDynamicObject(964, 541.27093505859, -2434.435546875, 1197.2407226563, 0, 0, 344.1201171875);
	CreateDynamicObject(964, 540.37884521484, -2432.2858886719, 1197.2407226563, 0, 0, 358.01416015625);
	CreateDynamicObject(964, 540.44445800781, -2430.9887695313, 1197.2407226563, 0, 0, 359.01147460938);
	CreateDynamicObject(964, 540.23645019531, -2431.6215820313, 1198.1666259766, 0, 0, 352.3212890625);
	CreateDynamicObject(3117, 537.99005126953, -2431.9519042969, 1197.8988037109, 89.324340820313, 0, 89.977294921875);
	CreateDynamicObject(3788, 539.72692871094, -2438.126953125, 1197.7603759766, 0, 0, 0);
	CreateDynamicObject(3788, 545.88702392578, -2432.2800292969, 1197.7600097656, 0, 0, 0);
	CreateDynamicObject(3788, 545.87335205078, -2434.2255859375, 1197.7600097656, 0, 0, 0);
	CreateDynamicObject(3788, 545.85906982422, -2436.2758789063, 1197.7600097656, 0, 0, 0);
	CreateDynamicObject(3786, 546.21185302734, -2432.2673339844, 1197.9476318359, 0, 0, 180);
	CreateDynamicObject(3786, 546.21862792969, -2434.2109375, 1197.9476318359, 0, 0, 180);
	CreateDynamicObject(3786, 546.20245361328, -2436.2770996094, 1197.9476318359, 0, 0, 180);
	CreateDynamicObject(14450, 549.74066162109, -2434.4230957031, 1200.4025878906, 0, 0, 270);
	CreateDynamicObject(927, 526.06927490234, -2436.9543457031, 1199.9611816406, 0, 0, 89.730010986328);
	CreateDynamicObject(927, 523.02197265625, -2434.1232910156, 1199.9611816406, 0, 0, 179.70520019531);
	CreateDynamicObject(934, 550.01379394531, -2433.0434570313, 1198.5690917969, 0, 0, 0);
	CreateDynamicObject(958, 550.34869384766, -2437.2211914063, 1198.0677490234, 0, 0, 89.730010986328);
    return 1;
}