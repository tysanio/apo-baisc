Dialog:dLOGIN(playerid, response, listitem, inputtext[])
{
    if(!response) Kick(playerid); //if they clicked Quit, we will kick them
    new hpass[129]; //for password hashing
    WP_Hash(hpass, 129, inputtext); //hashing inputtext
    if(!strcmp(hpass, pData[playerid][Password])) //remember we have loaded player's password into this variable, pData[playerid][Password] earlier. Now let's use it to compare the hashed password with password that we load
    { //if the hashed password matches with the loaded password from database
        mysql_format(mysql, query, sizeof(query), "SELECT * FROM `players` WHERE `Username` = '%e' LIMIT 1", Name[playerid]);
        mysql_tquery(mysql, query, "OnAccountLoad", "i", playerid);
    }
    else
    {
        Dialog_Show(playerid, dLOGIN, DIALOG_STYLE_PASSWORD, "Login", "In order to play, you need to login\nWrong password!", "Login", "Quit");
    }
    return 1;
}
Dialog:dREGISTER(playerid, response, listitem, inputtext[])
{
    if(!response) return Kick(playerid); //if they clicked Quit, we will kick them
    if(strlen(inputtext) < 6) return Dialog_Show(playerid, dREGISTER, DIALOG_STYLE_INPUT, "Register", "In order to play, you need to register.\nYour password must be at least 6 characters long!", "Register", "Quit");
    WP_Hash(pData[playerid][Password], 129, inputtext); //hashing inputtext
	mysql_format(mysql, query, sizeof(query), "INSERT INTO `players` (`Username`, `Password`, `IP`, `Admin`, `VIP`,`Score`) VALUES ('%e', '%s', '%s', 0, 0, 0)", Name[playerid], pData[playerid][Password], IP[playerid]);
	mysql_tquery(mysql, query, "OnAccountRegister", "i", playerid);
	return 1;
}
Dialog:TeleportInterior(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    SetPlayerInterior(playerid, g_arrInteriorData[listitem][e_InteriorID]);
	    SetPlayerPos(playerid, g_arrInteriorData[listitem][e_InteriorX], g_arrInteriorData[listitem][e_InteriorY], g_arrInteriorData[listitem][e_InteriorZ]);
	}
	return 1;
}
//Meat  Wood  Metal Cloth Plastic Gun Powder 
//inv1  inv2  inv3  inv4  inv5     inv6
Dialog:Craft(playerid, response, listitem, inputtext[])
{
    if (response)
	{
        switch (listitem)
        {
            case 0: Dialog_Show(playerid, Craft01, DIALOG_STYLE_LIST, "Craft Vehicles", "Bicycle(8M/2P/2I)\nBandito(24M/24P/5G)", "Craft", "Close");
            case 1: Dialog_Show(playerid, Craft11, DIALOG_STYLE_LIST, "Craft Weapons", "Pistol\nShotGun\nRifle\nSniper", "Craft", "Close");
            case 2: Dialog_Show(playerid, Craft21, DIALOG_STYLE_LIST, "Craft Ammos", "9 mm(5M/5P/5GP)\n00' Buck's(5M/5P/10GP)\n.308(5M/5P/25GP)", "Craft", "Close");
            case 3: Dialog_Show(playerid, Craft31, DIALOG_STYLE_LIST, "Craft Miscs", "Repair kit (3M/3P)\nMed Kit(2M/3P/5C)\nJerrycan (3P/Stations)\nArmor Plates(10M/10P/10C)\nCanned Food(1M/2Meats)\nBarricades", "Craft", "Close");
		}
        return 1;
	}
	return 1;
}
Dialog:Craft01(playerid, response, listitem, inputtext[])
{
	new modelid, color1 = random(128), color2 = random(128),Float:x, Float:y, Float:z, Float:a; // random default colors
    if (response)
	{
        switch (listitem)
        {
            case 0: 
			{
				if (pData[playerid][inv][3] >= 8 && pData[playerid][inv][5] >= 2 && pData[playerid][inv][8] >= 2)
				{
					pData[playerid][clanexp][0] += 250;
					pData[playerid][inv][3] -= 8;
					pData[playerid][inv][5] -= 2;
					pData[playerid][inv][8] -= 2;
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, a);
					mysql_format(mysql, query, sizeof(query),"INSERT INTO vehicles (model, posX, posY, posZ, rot,  color1, color2, fuel) VALUES (481,%f,%f,%f,%f,-1,-1,100)", x, y, z, a, color1, color2);
					modelid = 481;
					mysql_tquery(mysql, query, "OnVehicleCreated", "iffffii", modelid, x, y, z, a, color1, color2);
					SendServerMessage(playerid, "Vehicle crafted and saved.");
				}
				else SendServerMessage(playerid, "You don't have 8 metals or/and 2 plastics or/and 2 irons.");
			}
            case 1:
			{
				if (pData[playerid][inv][3] >= 24 && pData[playerid][inv][5] >= 24 && pData[playerid][inv][9] >= 5)
				{
					pData[playerid][inv][3] -= 24;
					pData[playerid][inv][5] -= 24;
					pData[playerid][inv][9] -= 5;
					pData[playerid][clanexp][0] += 1000;
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, a);
					mysql_format(mysql, query, sizeof(query),"INSERT INTO vehicles (model, posX, posY, posZ, rot,  color1, color2, fuel) VALUES (568,%f,%f,%f,%f,-1,-1,20)", x, y, z, a, color1, color2);
					modelid = 568;
					mysql_tquery(mysql, query, "OnVehicleCreated", "iffffii", modelid, x, y, z, a, color1, color2);
					SendServerMessage(playerid, "Vehicle crafted and saved.");
				}
				else SendServerMessage(playerid, "You don't have 24 metals or/and 24 plastics or/and 5 golds.");
			}
		}
        return 1;
	}
	return 1;
}
Dialog:Craft11(playerid, response, listitem, inputtext[])
{
    if (response)
	{
        switch (listitem)
        {
            case 0: {pData[playerid][clanexp][0] += 10;}
            case 1: {pData[playerid][clanexp][0] += 10;}
            case 2: {pData[playerid][clanexp][0] += 10;}
            case 3: {pData[playerid][clanexp][0] += 10;}
		}
        return 1;
	}
	return 1;
}
Dialog:Craft21(playerid, response, listitem, inputtext[])
{
    if (response)
	{ //"9 mm(5M/5P/5GP)\n 00' Buck's(10M/10P/10GP)\n.308(25M/25P/25GP)"
        switch (listitem)
        {
            case 0:
			{
				if (pData[playerid][inv][3] >= 5 && pData[playerid][inv][5] >= 5 && pData[playerid][inv][6] >= 5)
				{
					pData[playerid][clanexp][0] += 20;
					pData[playerid][inv][14] += 1;
					pData[playerid][inv][3] -= 5;
					pData[playerid][inv][5] -= 5;
					pData[playerid][inv][6] -= 5;
				}
				else SendServerMessage(playerid, "You don't have 5 metals or/and 5 plastics or/and 5 gun powders.");
			}
            case 1:
			{
				if (pData[playerid][inv][3] >= 5 && pData[playerid][inv][5] >= 5 && pData[playerid][inv][6] >= 10)
				{
					pData[playerid][clanexp][0] += 30;
					pData[playerid][inv][15] += 1;
					pData[playerid][inv][3] -= 5;
					pData[playerid][inv][5] -= 5;
					pData[playerid][inv][6] -= 10;
				}
				else SendServerMessage(playerid, "You don't have 5 metals or/and 5 plastics or/and 10 gun powders.");
			}
            case 2:
			{
				if (pData[playerid][inv][3] >= 5 && pData[playerid][inv][5] >= 5 && pData[playerid][inv][6] >= 25)
				{
					pData[playerid][clanexp][0] += 50;
					pData[playerid][inv][16] += 1;
					pData[playerid][inv][3] -= 5;
					pData[playerid][inv][5] -= 5;
					pData[playerid][inv][6] -= 25;
				}
				else SendServerMessage(playerid, "You don't have 5 metals or/and 5 plastics or/and 25 gun powders.");
			}
		}
        return 1;
	}
	return 1;
}
Dialog:Craft31(playerid, response, listitem, inputtext[])
{
    new stationid = GetNearestFuelStation(playerid),label[32];
    if (response)
	{
        switch (listitem)
        { //Repair kit (3M/3P)\nMed Kit(2M/3P/5C)\nJerrycan (3P/Stations)\nArmor Plates(10M/10P/10C)
            case 0: 
			{
				if (pData[playerid][inv][3] >= 3 && pData[playerid][inv][5] >= 3)
				{
					if (pData[playerid][inv][11] + 1 > GetBackpackCapacity(playerid))
						return SendServerMessage(playerid, "Not enough backpack space for this item.");
					pData[playerid][clanexp][0] += 10;
					pData[playerid][inv][11] += 1;
					pData[playerid][inv][3] -= 3;
					pData[playerid][inv][5] -= 3;
					SendServerMessage(playerid, "You craft one Repair kit.");
				}
				else SendServerMessage(playerid, "You don't have 3 metals or/and 3 plastics.");
			}
            case 1: 
			{
				if (pData[playerid][inv][3] >= 3 && pData[playerid][inv][5] >= 3 && pData[playerid][inv][4] >= 5)
				{
					if (pData[playerid][inv][12] + 12 > GetBackpackCapacity(playerid))
						return SendServerMessage(playerid, "Not enough backpack space for this item.");
					pData[playerid][clanexp][0] += 15;
					pData[playerid][inv][12] += 1;
					pData[playerid][inv][3] -= 3;
					pData[playerid][inv][5] -= 3;
					pData[playerid][inv][4] -= 5;
					SendServerMessage(playerid, "You craft one med kit.");
				}
				else SendServerMessage(playerid, "You don't have 3 metals or/and 3 plastics or/and 5 cloths.");
			}
            case 2: 
			{
				if (pData[playerid][inv][5] >= 3 && stationid == -1)
				{
					if (FuelStation[stationid][fsStock] <= 0)
						return SendServerMessage(playerid,"[Fuel] This station is out of fuel!");
					if (pData[playerid][inv][13] + 1 > GetBackpackCapacity(playerid))
						return SendServerMessage(playerid, "Not enough backpack space for this item.");
					FuelStation[stationid][fsStock] -= 5;
					format(label, sizeof(label), "[ID %d] Fuel: %d liters",stationid,FuelStation[stationid][fsStock],FuelStation[stationid][fsPricePerLiter]);
					UpdateDynamic3DTextLabelText(FuelStation[stationid][fsLabel], 0x00FF00FF, label);
					mysql_format(mysql, label, sizeof(label),"UPDATE fuel_stations SET stock = %d WHERE id = %d", FuelStation[stationid][fsStock], FuelStation[stationid][fsID]);
					mysql_query(mysql, label);
					pData[playerid][clanexp][0] += 5;
					pData[playerid][inv][5] -= 3;
					pData[playerid][inv][13] += 1;
					SendServerMessage(playerid, "You craft one jerrycan and filled up.");	
				}
				else SendServerMessage(playerid, "You don't have 3 plastics or not in the right position to refuel");
			}
            case 3: 
			{
				if (pData[playerid][inv][3] >= 10 && pData[playerid][inv][5] >= 10 && pData[playerid][inv][4] >= 10)
				{
					if (pData[playerid][inv][17] + 1 > GetBackpackCapacity(playerid))
						return SendServerMessage(playerid, "Not enough backpack space for this item.");
					pData[playerid][clanexp][0] += 25;
					pData[playerid][inv][17] += 1;
					pData[playerid][inv][3] -= 10;
					pData[playerid][inv][5] -= 10;
					pData[playerid][inv][4] -= 10;
					SendServerMessage(playerid, "You craft one armor plate.");
				}
				else SendServerMessage(playerid, "You don't have 10 metals or/and 10 plastics or/and 10 cloths.");
			}
            case 4: 
			{
				if (pData[playerid][inv][1] >= 2 && pData[playerid][inv][3] >= 1 )
				{
					if (pData[playerid][inv][19] + 1 > GetBackpackCapacity(playerid))
						return SendServerMessage(playerid, "Not enough backpack space for this item.");
					pData[playerid][clanexp][0] += 3;
					pData[playerid][inv][19] += 1;
					pData[playerid][inv][1] -= 2;
					pData[playerid][inv][3] -= 1;
					SendServerMessage(playerid, "You craft one can of food.");
				}
				else SendServerMessage(playerid, "You don't have 1 metals or/and 2 meats.");
			}
			case 5: ShowModelSelectionMenu(playerid, "Crafting Barricades", MODEL_SELECTION_CRAFT, CraftBarridaces, sizeof(CraftBarridaces), -12.0, 0.0, 0.0);
		}
        return 1;
	}
	return 1;
}
// /use
Dialog:UseItem(playerid, response, listitem, inputtext[])
{//9 mm\n00' Buck's\n.308\nMed Kit\nArmor Plates\nRefuel\nWater\nFood\nLockpick
    if (response)
	{
		static Float:health;
        switch (listitem)
        {
            case 0: {}
            case 1: {}
            case 2: {}
            case 3: 
			{
				if (pData[playerid][inv][12] >= 1)
				{			
					GetPlayerHealth(playerid, health);
					if (health <= 99.0)
					{
						SetPlayerHealth(playerid, floatadd(health, 20.0));
						pData[playerid][inv][12] -= 1;
					}
					else SendServerMessage(playerid, "You have full health already.");
				}
				else SendServerMessage(playerid, "You don't have a med kit.");
			}
            case 4: 
			{
				if (pData[playerid][inv][17] >= 1)
				{			
					GetPlayerArmour(playerid, health);
					if (health <= 99.0)
					{
						SetPlayerArmour(playerid, floatadd(health, 20.0));
						pData[playerid][inv][17] -= 1;
					}
					else SendServerMessage(playerid, "You have full armor already.");
				}
				else SendServerMessage(playerid, "You don't have armor plate(s).");
			}
			case 5: cmd_refuel(playerid, "");
            case 6: 
			{
				if (pData[playerid][inv][18] >= 1)
				{
					switch (random(5))
					{
						case 0: 
						{
							pData[playerid][Water] += 1;
							SendServerMessage(playerid, "This water bottle was normal.");
							if(pData[playerid][Water] > 101) pData[playerid][Water] = 100;
						}
						case 1:
						{
							pData[playerid][Water] += 3;
							SendServerMessage(playerid, "This water bottle was very good!");
							if(pData[playerid][Water] > 101) pData[playerid][Water] = 100;
						}
						case 2:
						{
							pData[playerid][Water] -= 5;
							SendServerMessage(playerid, "This water bottle was not good like poisoned.");
							if(pData[playerid][Water] > 101) pData[playerid][Water] = 100;
						}
						case 3:
						{
							pData[playerid][Water] += 2;
							SendServerMessage(playerid, "This water bottle was good.");
							if(pData[playerid][Water] > 101) pData[playerid][Water] = 100;
						}
						case 4:
						{
							pData[playerid][Water] -= 2;
							SendServerMessage(playerid, "This water bottle was not so good.");
							if(pData[playerid][Water] > 101) pData[playerid][Water] = 100;
						}						
					}				
					pData[playerid][inv][18] -= 1;
				}
				else SendServerMessage(playerid, "You don't have a water bottle(s).");
			}
            case 7: 
			{
				if (pData[playerid][inv][19] >= 1)
				{
					switch (random(5))
					{
						case 0: 
						{
							pData[playerid][Food] += 1;
							SendServerMessage(playerid, "This canned food was dog food still edible.");
							if(pData[playerid][Food] > 101) pData[playerid][Food] = 100;
						}
						case 1:
						{
							pData[playerid][Food] += 3;
							SendServerMessage(playerid, "This canned food was very good!");
							if(pData[playerid][Food] > 101) pData[playerid][Food] = 100;
						}
						case 2:
						{
							pData[playerid][Food] -= 5;
							SendServerMessage(playerid, "This canned food was expired like longtime ago.");
							if(pData[playerid][Food] > 101) pData[playerid][Food] = 100;
						}
						case 3:
						{
							pData[playerid][Food] += 2;
							SendServerMessage(playerid, "This canned food was normal.");
							if(pData[playerid][Food] > 101) pData[playerid][Food] = 100;
						}
						case 4:
						{
							pData[playerid][Food] -= 2;
							SendServerMessage(playerid, "This canned food was not so good.");
							if(pData[playerid][Food] > 101) pData[playerid][Food] = 100;
						}
					}				
					pData[playerid][inv][19] -= 1;
				}
				else SendServerMessage(playerid, "You don't have a canned food(s).");
			}
			case 8: 
			{
                if(pData[playerid][inv][10] >= 1)
				{
					new id = Storage_Nearest(playerid);
					if(id != -1)
					{
						pData[playerid][pLockpickStorage] = id;
						StartLockpick(playerid, 50, random(5)+1, random(3)+1);
					}
					else SendServerMessage(playerid,"Not near any storage to lockpick.");
                }
                else SendServerMessage(playerid, "You don't have atleast one lockpick to try it.");
			} //lockpick stuff
		}
        return 1;
	}
	return 1;
}
//clan
Dialog:CLANDIALOG00(playerid, response, listitem, inputtext[])
{
    if (response)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
		new facass = clans[pData[playerid][idclan]][idclan],slot = GetClanByID(pData[playerid][idclan]);
        switch (listitem)
        {
			case 0:
			{
				if (pData[playerid][idclan] > 0) return SendServerMessage(playerid, "You are already in a clan.");
				Dialog_Show(playerid, CLANDIALOG03, DIALOG_STYLE_INPUT, "Create a clan", "What the name of your clan will be?", "Create", "Back");
			}
			case 1:
			{
				if (pData[playerid][idclan] !=0)
				{
					Dialog_Show(playerid, CLANDIALOG01, DIALOG_STYLE_MSGBOX, "Clan Stats","Database ID %d (%d)\nClan level %d\nMax Rank %d\n\nChest Location\n%.2f %.2f %.2f\n\nEntry location\n%.2f %.2f %.2f\n\nClan Exp 0 %d\nClan Exp 1 %d\nClan Exp 2 %d\nClan Exp 3 %d\nClan Exp 4 %d\n", "OK", "",clans[facass][idclan],slot,clans[facass][inv][0],clans[facass][maxrank],clans[facass][chestpos][0],clans[facass][chestpos][1],clans[facass][chestpos][2],clans[facass][enterpos][0],clans[facass][enterpos][1],clans[facass][enterpos][2],clans[facass][clanexp][0],clans[facass][clanexp][1],clans[facass][clanexp][2],clans[facass][clanexp][3],clans[facass][clanexp][4]);  		
				}
			}
			case 2:
			{
				new factionid = pData[playerid][idclan],dialogStr[2048], temp[128];
				if (factionid == 0)
					return SendServerMessage(playerid, "You need to be in clan.");
				format(dialogStr, sizeof(dialogStr), "ID\tName\tRank\n");
				foreach (new i : Player)
				{
					if (pData[i][idclan] == factionid)
					{
						format(temp, sizeof(temp), "%d\t%s \t%d\n",i,Name[playerid],pData[i][clanrank]);
						strcat(dialogStr, temp);
					}
				}
				Dialog_Show(playerid,DIALOG_MEMBRES, DIALOG_STYLE_TABLIST_HEADERS, "Online Member", dialogStr, "Close", "");
				return 1;
			}
			case 3:
			{
					if (pData[playerid][clanrank] < clans[pData[playerid][idclan]][maxrank] - 1)
						return SendServerMessage(playerid, "You must be at least rank %d to use that command.", clans[pData[playerid][idclan]][maxrank] - 1);
					clans[facass][enterpos][0] = x;
					clans[facass][enterpos][1] = y;
					clans[facass][enterpos][2] = z;
					clans[facass][enterinterior] = GetPlayerInterior(playerid);
					clans[facass][entervw] = GetPlayerVirtualWorld(playerid);
					SendServerMessage(playerid, "Clan Enter position updated.");
					mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `enterposx` = '%.4f',`enterposy` = '%.4f',`enterposz` = '%.4f',`enterinterior` = '%d',`entervw` = '%d' WHERE `idclan` = '%d'",x,y,z,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),clans[facass][idclan]);
					mysql_tquery(mysql, query);
					foreach(Player, i)
					{
						if (IsValidDynamicPickup(clans[i][pickup][0]))
						DestroyDynamicPickup(clans[i][pickup][0]);
					}
					clans[facass][pickup][0] =  CreateDynamicPickup(19132, 23, clans[facass][enterpos][0], clans[facass][enterpos][1],clans[facass][enterpos][2], clans[facass][entervw], clans[facass][enterinterior], -1, 50);
			}
			case 4:
			{
				if (pData[playerid][clanrank] < clans[pData[playerid][idclan]][maxrank] - 1)
					return SendServerMessage(playerid, "You must be at least rank %d to use that command.", clans[pData[playerid][idclan]][maxrank] - 1);
				clans[facass][exitpos][0] = x;
				clans[facass][exitpos][1] = y;
				clans[facass][exitpos][2] = z;
				clans[facass][exitinterior] = GetPlayerInterior(playerid);
				clans[facass][exitvw] = GetPlayerVirtualWorld(playerid);
				SendServerMessage(playerid, "Clan Exit position updated.");
				mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `exitposx` = '%.4f',`exitposy` = '%.4f',`exitposz` = '%.4f',`exitinterior` = '%d',`exitvw` = '%d' WHERE `idclan` = '%d'",x,y,z,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),clans[facass][idclan]);
				mysql_tquery(mysql, query);
				foreach(Player, i)
				{
					if (IsValidDynamicPickup(clans[i][pickup][1]))
					DestroyDynamicPickup(clans[i][pickup][1]);
				}
				clans[facass][pickup][1] =  CreateDynamicPickup(19132, 23, clans[facass][exitpos][0], clans[facass][exitpos][1],clans[facass][exitpos][2], clans[facass][exitvw], clans[facass][exitinterior], -1, 50);
			}
			case 5:
			{
				if (pData[playerid][inv][1] >= 25 && pData[playerid][inv][2] >= 25 && pData[playerid][inv][4] >= 25)
				{
					pData[playerid][inv][1] -= 25;
					pData[playerid][inv][2] -= 25;
					pData[playerid][inv][4] -= 25;
					clans[facass][chestpos][0] = x;
					clans[facass][chestpos][1] = y;
					clans[facass][chestpos][2] = z;				
					SendServerMessage(playerid, "Clan Chest position updated new pos %.4f %.4f %.4f.",x,y,z);
					mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `chestposx` = '%.4f',`chestposy` = '%.4f',`chestposz` = '%.4f' WHERE `idclan` = '%d'",x,y,z,clans[facass][idclan]);
					mysql_tquery(mysql, query);
					foreach(Player, i)
					{
						if (IsValidDynamicPickup(clans[i][pickup][2]))
						DestroyDynamicPickup(clans[i][pickup][2]);
					}
					clans[facass][pickup][2] =  CreateDynamicPickup(964, 23, clans[facass][chestpos][0], clans[facass][chestpos][1],clans[facass][chestpos][2], -1, -1, -1, 50);
				}
				else SendServerMessage(playerid, "You don't have 25 Metal(s) or/and 25 plastic(s) or/and 25 wood(s).");
			}
			case 6:
			{
				if (pData[playerid][clanrank] < clans[pData[playerid][idclan]][maxrank])
					return SendServerMessage(playerid, "You must be at least rank %d to use that command.", clans[pData[playerid][idclan]][maxrank] );
				Dialog_Show(playerid, CLANDIALOG02, DIALOG_STYLE_INPUT, "Max rank", "Put maximum ranks for the member your clan.", "Set", "Back");
			}
			case 7: 
			{
				if (pData[playerid][idclan] !=0)
				{
					if(IsNearChest(playerid))
					{
						if (pData[playerid][clanrank] < clans[pData[playerid][idclan]][maxrank])
							return SendServerMessage(playerid, "You must be at least rank %d to use that command.", clans[pData[playerid][idclan]][maxrank]);
						pData[playerid][inv][1] += clans[facass][inv][1];
						pData[playerid][inv][2] += clans[facass][inv][2];
						pData[playerid][inv][3] += clans[facass][inv][3];
						pData[playerid][inv][4] += clans[facass][inv][4];
						pData[playerid][inv][5] += clans[facass][inv][5];
						pData[playerid][inv][6] += clans[facass][inv][6];
						pData[playerid][inv][7] += clans[facass][inv][7];
						pData[playerid][inv][8] += clans[facass][inv][8];
						pData[playerid][inv][9] += clans[facass][inv][9];
						pData[playerid][inv][10] += clans[facass][inv][10];
						pData[playerid][inv][11] += clans[facass][inv][11];
						pData[playerid][inv][12] += clans[facass][inv][12];
						pData[playerid][inv][13] += clans[facass][inv][13];
						pData[playerid][inv][14] += clans[facass][inv][14];
						pData[playerid][inv][15] += clans[facass][inv][15];
						pData[playerid][inv][16] += clans[facass][inv][16];
						pData[playerid][inv][17] += clans[facass][inv][17];
						pData[playerid][inv][18] += clans[facass][inv][18];
						pData[playerid][inv][19] += clans[facass][inv][19];
						pData[playerid][inv][20] += clans[facass][inv][20];
						pData[playerid][inv][21] += clans[facass][inv][21];
						pData[playerid][inv][22] += clans[facass][inv][22];
						pData[playerid][inv][23] += clans[facass][inv][23];
						pData[playerid][inv][24] += clans[facass][inv][24];
						pData[playerid][inv][25] += clans[facass][inv][25];
						foreach(Player, i)
						{
							if (IsValidDynamicPickup(clans[i][pickup][0]))
							DestroyDynamicPickup(clans[i][pickup][0]);
							if (IsValidDynamicPickup(clans[i][pickup][1]))
							DestroyDynamicPickup(clans[i][pickup][1]);
							if (IsValidDynamicPickup(clans[i][pickup][2]))
							DestroyDynamicPickup(clans[i][pickup][2]);
						}
						mysql_format(mysql,query, sizeof(query), "DELETE FROM `clans` WHERE `idclan` = '%d'", pData[playerid][idclan]);
						mysql_tquery(mysql, query);
						pData[playerid][idclan] = 0;
						pData[playerid][clanrank] = 0;
						SendServerMessage(playerid, "You're clan has been disband and you retake everything from the chest.");
					}
					else SendServerMessage(playerid,"You're not near your clan chest to disband.");
				}					
			}
		}
	}
	return 1;
}
Dialog:CLANDIALOG03(playerid, response, listitem, inputtext[])
{
    if (response)
	{
		mysql_format(mysql, query, sizeof(query), "INSERT INTO clans (clanname,Owner) VALUES ('%e','%e')", SQL_ReturnEscaped(inputtext),GetName(playerid));
		mysql_tquery(mysql, query, "OnClanCreated", "is", playerid, inputtext);
	}
	return 1;
}
Dialog:CLANDIALOG02(playerid, response, listitem, inputtext[])
{
    if (response)
	{
		new facass = clans[pData[playerid][idclan]][idclan];
		clans[facass][maxrank] = strval(inputtext);
		pData[playerid][clanrank] = strval(inputtext);
		SendServerMessage(playerid, "Clan max rank updated.");
		mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `maxrank` = '%d' WHERE `idclan` = '%d'",strval(inputtext),clans[facass][idclan]);
		mysql_tquery(mysql, query);
		if (pData[playerid][idclan] !=0) Dialog_Show(playerid, CLANDIALOG00, DIALOG_STYLE_LIST, "Clan Setup", "Create Clan\nClan Stats\nEnter position\nExit position\nChest position\nMax Rank\nDelete Clan", "OK", "");
		return 1;
	}
	return 1;
}
Dialog:CLANDIALOG10(playerid, response, listitem, inputtext[])
{//that gonna be a looonnnngggg boyy
    if (response)
	{
        switch (listitem)
        {
			case 0: 
			{
				claninv = 1;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Meat(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 1:
			{
				claninv = 2;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Wood(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 2:
			{
				claninv = 3;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Metal(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 3:
			{
				claninv = 4;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Cloth(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 4:
			{
				claninv = 5;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Plastic(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 5:
			{
				claninv = 6;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Gun Powder(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 6:
			{
				claninv = 7;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Ore(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 7:
			{
				claninv = 8;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Iron(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 8:
			{
				claninv = 9;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Gold(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 9:
			{
				claninv = 10;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Lockpick(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 10:
			{
				claninv = 11;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Repair kit(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 11:
			{
				claninv = 12;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Med Kit(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 12:
			{
				claninv = 13;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Jerrycan(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 13:
			{
				claninv = 14;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "9mm Bullet(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 14:
			{
				claninv = 15;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "00' Buck's", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 15:
			{
				claninv = 16;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, ".308(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 16:
			{
				claninv = 17;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Armor Plate(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 17:
			{
				claninv = 18;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Water Bottle(s)", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 18:
			{
				claninv = 19;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Canned Food", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 19:
			{
				claninv = 20;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv20", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 20:
			{
				claninv = 21;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv21", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 21:
			{
				claninv = 22;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv22", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 22:
			{
				claninv = 23;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv23", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 23:
			{
				claninv = 24;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv24", "How much you want to withdraw?", "Withdraw", "Back");
			}
			case 24:
			{
				claninv = 25;
				Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv25", "How much you want to withdraw?", "Withdraw", "Back");
			}
		}
	}
	return 1;
}
Dialog:CLANDIALOG100(playerid, response, listitem, inputtext[])
{//logn respons
	new id = clans[pData[playerid][idclan]][idclan],amount = strval(inputtext);
    if (response)
	{
		if(claninv == 1)
		{
			if (amount < 0 || amount >= clans[id][inv][1]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Meat", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][1] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][1] -=amount;
			pData[playerid][inv][1] +=amount;
			SendServerMessage(playerid,"You take %d meat(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv1` = '%d' WHERE `idclan` = '%d'",clans[id][inv][1],clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 2)
		{
			if (amount < 0 || amount >= clans[id][inv][2]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Woods", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][2] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][2] -=amount;
			pData[playerid][inv][2] +=amount;
			SendServerMessage(playerid,"You take %d wood(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv2` = '%d' WHERE `idclan` = '%d'",clans[id][inv][2],clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 3)
		{
			if (amount < 0 || amount >= clans[id][inv][3]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Metals", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][3] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][3] -=amount;
			pData[playerid][inv][3] +=amount;
			SendServerMessage(playerid,"You take %d Metal(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv3` = '%d' WHERE `idclan` = '%d'",clans[id][inv][3],clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 4)
		{
			if (amount < 0 || amount >= clans[id][inv][4]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Cloths", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][4] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][4] -=amount;
			pData[playerid][inv][4] +=amount;
			SendServerMessage(playerid,"You take %d Cloth(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv4` = '%d' WHERE `idclan` = '%d'",clans[id][inv][4],clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 5)
		{
			if (amount < 0 || amount >= clans[id][inv][5]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Plastics", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][5] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][5] -=amount;
			pData[playerid][inv][5] +=amount;
			SendServerMessage(playerid,"You take %d Plastic(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv5` = '%d' WHERE `idclan` = '%d'",clans[id][inv][5],clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 6)
		{
			if (amount < 0 || amount >= clans[id][inv][6]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Gun Powder", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][6] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][6] -= amount;
			pData[playerid][inv][6] += amount;
			SendServerMessage(playerid,"You take %d Gun Powder(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv6` = '%d' WHERE `idclan` = '%d'", clans[id][inv][6], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 7)
		{
			if (amount < 0 || amount >= clans[id][inv][7]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Ore(s)", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][7] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][7] -= amount;
			pData[playerid][inv][7] += amount;
			SendServerMessage(playerid,"You take %d Ore(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv7` = '%d' WHERE `idclan` = '%d'", clans[id][inv][7], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 8)
		{
			if (amount < 0 || amount >= clans[id][inv][8]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Iron(s)", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][8] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][8] -= amount;
			pData[playerid][inv][8] += amount;
			SendServerMessage(playerid,"You take %d Iron(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv8` = '%d' WHERE `idclan` = '%d'", clans[id][inv][8], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 9)
		{
			if (amount < 0 || amount >= clans[id][inv][9]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Gold(s)", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][9] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][9] -= amount;
			pData[playerid][inv][9] += amount;
			SendServerMessage(playerid,"You take %d Gold(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv9` = '%d' WHERE `idclan` = '%d'", clans[id][inv][9], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 10)
		{
			if (amount < 0 || amount >= clans[id][inv][10]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Lockpick(s)", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][10] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][10] -= amount;
			pData[playerid][inv][10] += amount;
			SendServerMessage(playerid,"You take %d Lockpick(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv10` = '%d' WHERE `idclan` = '%d'", clans[id][inv][10], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 11)
		{
			if (amount < 0 || amount >= clans[id][inv][11]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Repair kit", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][11] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][11] -= amount;
			pData[playerid][inv][11] += amount;
			SendServerMessage(playerid,"You take %d Repair kit(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv11` = '%d' WHERE `idclan` = '%d'", clans[id][inv][11], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 12)
		{
			if (amount < 0 || amount >= clans[id][inv][12]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Med Kit", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][12] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][12] -= amount;
			pData[playerid][inv][12] += amount;
			SendServerMessage(playerid,"You take %d Med Kit(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv12` = '%d' WHERE `idclan` = '%d'", clans[id][inv][12], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 13)
		{
			if (amount < 0 || amount >= clans[id][inv][13]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Jerrycan", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][13] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][13] -= amount;
			pData[playerid][inv][13] += amount;
			SendServerMessage(playerid,"You take %d Jerrycan(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv13` = '%d' WHERE `idclan` = '%d'", clans[id][inv][13], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 14)
		{
			if (amount < 0 || amount >= clans[id][inv][14]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "9mm Bullet", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][14] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][14] -= amount;
			pData[playerid][inv][14] += amount;
			SendServerMessage(playerid,"You take %d 9mm Bullet(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv14` = '%d' WHERE `idclan` = '%d'", clans[id][inv][14], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 15)
		{
			if (amount < 0 || amount >= clans[id][inv][15]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "00' Buck's", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][15] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][15] -= amount;
			pData[playerid][inv][15] += amount;
			SendServerMessage(playerid,"You take %d 00' Buck's from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv15` = '%d' WHERE `idclan` = '%d'", clans[id][inv][15], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 16)
		{
			if (amount < 0 || amount >= clans[id][inv][16]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, ".308(s)", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][16] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][16] -= amount;
			pData[playerid][inv][16] += amount;
			SendServerMessage(playerid,"You take %d .308(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv16` = '%d' WHERE `idclan` = '%d'", clans[id][inv][16], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 17)
		{
			if (amount < 0 || amount >= clans[id][inv][17]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "Armor Plate(s)", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][17] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][17] -= amount;
			pData[playerid][inv][17] += amount;
			SendServerMessage(playerid,"You take %d Armor Plate(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv12` = '%d' WHERE `idclan` = '%d'", clans[id][inv][17], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 18)
		{
			if (amount < 0 || amount >= clans[id][inv][18]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv18 ", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][18] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][18] -= amount;
			pData[playerid][inv][18] += amount;
			SendServerMessage(playerid,"You take %d Water Bottle(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv18` = '%d' WHERE `idclan` = '%d'", clans[id][inv][18], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 19)
		{
			if (amount < 0 || amount >= clans[id][inv][19]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv19 ", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][19] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][19] -= amount;
			pData[playerid][inv][19] += amount;
			SendServerMessage(playerid,"You take %d Canned Food(s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv19` = '%d' WHERE `idclan` = '%d'", clans[id][inv][19], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 20)
		{
			if (amount < 0 || amount >= clans[id][inv][20]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv20 ", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][20] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][20] -= amount;
			pData[playerid][inv][20] += amount;
			SendServerMessage(playerid,"You take %d inv20 (s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv20` = '%d' WHERE `idclan` = '%d'", clans[id][inv][20], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 21)
		{
			if (amount < 0 || amount >= clans[id][inv][21]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv21 ", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][21] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][21] -= amount;
			pData[playerid][inv][21] += amount;
			SendServerMessage(playerid,"You take %d inv21 (s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv21` = '%d' WHERE `idclan` = '%d'", clans[id][inv][21], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 22)
		{
			if (amount < 0 || amount >= clans[id][inv][22]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv22 ", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][22] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][22] -= amount;
			pData[playerid][inv][22] += amount;
			SendServerMessage(playerid,"You take %d inv22 (s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv22` = '%d' WHERE `idclan` = '%d'", clans[id][inv][22], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 23)
		{
			if (amount < 0 || amount >= clans[id][inv][23]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv23 ", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][23] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][23] -= amount;
			pData[playerid][inv][23] += amount;
			SendServerMessage(playerid,"You take %d inv23 (s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv23` = '%d' WHERE `idclan` = '%d'", clans[id][inv][23], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 24)
		{
			if (amount < 0 || amount >= clans[id][inv][24]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv24 ", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][24] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][24] -= amount;
			pData[playerid][inv][24] += amount;
			SendServerMessage(playerid,"You take %d inv24 (s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv24` = '%d' WHERE `idclan` = '%d'", clans[id][inv][24], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 25)
		{
			if (amount < 0 || amount >= clans[id][inv][25]) return Dialog_Show(playerid, CLANDIALOG100, DIALOG_STYLE_INPUT, "inv25 ", "Error on the quantity!\nHow much you want to withdraw?", "Withdraw", "Back");
			if (pData[playerid][inv][25] + amount > GetBackpackCapacity(playerid))
				return SendServerMessage(playerid, "Not enough storage space for this item in your backpack.");
			clans[id][inv][25] -= amount;
			pData[playerid][inv][25] += amount;
			SendServerMessage(playerid,"You take %d inv25 (s) from the clan chest.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv25` = '%d' WHERE `idclan` = '%d'", clans[id][inv][25], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		claninv = -1;
	}
	else
	{
		Dialog_Show(playerid, CLANDIALOG10, DIALOG_STYLE_TABLIST, "Clan Chest\tAmount","Meat(s) : \t%d\nWood(s) : \t%d\nMetal(s) : \t%d\nCloth(s) : \t%d\nPlastic(s) : \t%d\n\
		Gun Powder : \t%d\nOre(s) : \t%d\nIron(s): \t%d\nGold(s) : \t%d\nLockpick(s): \t%d\n\
		Repair kit(s) : \t%d\nMed Kit(s) : \t%d\nJerrycan(s) : \t%d\n9mm Bullet(s) : \t%d\n00' Buck's : \t%d\n\
		.308(s) : \t%d\nArmor Plate(s) : \t%d\nWater Bottle : \t%d\nCanned Food : \t%d\ninv20 : \t%d\n\
		inv21 : \t%d\ninv22 : \t%d\ninv23 : \t%d\ninv24 : \t%d\ninv25 : \t%d", "OK", "",clans[id][inv][1],clans[id][inv][2],clans[id][inv][3],clans[id][inv][4],clans[id][inv][5],        clans[id][inv][6],clans[id][inv][7],clans[id][inv][8],clans[id][inv][9],clans[id][inv][10],        clans[id][inv][11],clans[id][inv][12],clans[id][inv][13],clans[id][inv][14],clans[id][inv][15],        clans[id][inv][16],clans[id][inv][17],clans[id][inv][18],clans[id][inv][19],clans[id][inv][20],        clans[id][inv][21],clans[id][inv][22],clans[id][inv][23],clans[id][inv][24],clans[id][inv][25]); 
	}
	return 1;
}
Dialog:CLANDIALOG20(playerid, response, listitem, inputtext[])
{//that gonna be a looonnnngggg boyy
    if (response)
	{
        switch (listitem)
        {
			case 0: 
			{
				claninv = 1;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Meat(s)", "How much do you want to give?", "Withdraw", "Back");
			}
			case 1:
			{
				claninv = 2;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 2:
			{
				claninv = 3;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 3:
			{
				claninv = 4;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 4:
			{
				claninv = 5;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 5:
			{
				claninv = 6;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 6:
			{
				claninv = 7;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 7:
			{
				claninv = 8;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 8:
			{
				claninv = 9;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 9:
			{
				claninv = 10;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 10:
			{
				claninv = 11;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 11:
			{
				claninv = 12;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 12:
			{
				claninv = 13;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 13:
			{
				claninv = 14;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 14:
			{
				claninv = 15;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 15:
			{
				claninv = 16;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 16:
			{
				claninv = 17;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 17:
			{
				claninv = 18;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 18:
			{
				claninv = 19;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 19:
			{
				claninv = 20;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 20:
			{
				claninv = 21;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 21:
			{
				claninv = 22;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 22:
			{
				claninv = 23;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 23:
			{
				claninv = 24;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 24:
			{
				claninv = 25;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
			case 25:
			{
				claninv = 26;
				Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Amount", "How much do you want to give?", "Withdraw", "Back");
			}
		}
	}
	return 1;
}
Dialog:CLANDIALOG200(playerid, response, listitem, inputtext[])
{//logn respons
	new id = clans[pData[playerid][idclan]][idclan],amount = strval(inputtext);
    if (response)
	{
		if(claninv == 1)
		{
			if (amount < 0 || amount >= pData[playerid][inv][1]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Meat", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][1] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][1] -=amount;
			clans[id][inv][1] +=amount;
			SendServerMessage(playerid,"You give %d meat(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv1` = '%d' WHERE `idclan` = '%d'",clans[id][inv][1],clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 2)
		{
			if (amount < 0 || amount >= pData[playerid][inv][2]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Woods", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][2] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][2] -=amount;
			pData[playerid][inv][2] +=amount;
			SendServerMessage(playerid,"You give %d wood(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv2` = '%d' WHERE `idclan` = '%d'",clans[id][inv][2],clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 3)
		{
			if (amount < 0 || amount >= pData[playerid][inv][3]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Metals", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][3] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][3] -=amount;
			clans[id][inv][3] +=amount;
			SendServerMessage(playerid,"You give %d Metal(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv3` = '%d' WHERE `idclan` = '%d'",clans[id][inv][3],clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 4)
		{
			if (amount < 0 || amount >= pData[playerid][inv][4]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Cloths", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][4] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][4] -=amount;
			clans[id][inv][4] +=amount;
			SendServerMessage(playerid,"You give %d Cloth(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv4` = '%d' WHERE `idclan` = '%d'",clans[id][inv][4],clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 5)
		{
			if (amount < 0 || amount >= pData[playerid][inv][5]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Plastics", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][5] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][5] -=amount;
			clans[id][inv][5] +=amount;
			SendServerMessage(playerid,"You give %d Plastic(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv5` = '%d' WHERE `idclan` = '%d'",clans[id][inv][5],clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 6)
		{
			if (amount < 0 || amount >= pData[playerid][inv][6]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Gun Powder", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][6] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][6] -= amount;
			clans[id][inv][6] += amount;
			SendServerMessage(playerid,"You give %d Gun Powder(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv6` = '%d' WHERE `idclan` = '%d'", clans[id][inv][6], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 7)
		{
			if (amount < 0 || amount >= pData[playerid][inv][7]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Ore(s)", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][7] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][7] -= amount;
			clans[id][inv][7] += amount;
			SendServerMessage(playerid,"You give %d Ore(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv7` = '%d' WHERE `idclan` = '%d'", clans[id][inv][7], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 8)
		{
			if (amount < 0 || amount >= pData[playerid][inv][8]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Iron(s)", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][8] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][8] -= amount;
			clans[id][inv][8] += amount;
			SendServerMessage(playerid,"You give %d Iron(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv8` = '%d' WHERE `idclan` = '%d'",clans[id][inv][8], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 9)
		{
			if (amount < 0 || amount >= pData[playerid][inv][9]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Gold(s)", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][9] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][9] -= amount;
			pData[playerid][inv][9] += amount;
			SendServerMessage(playerid,"You give %d Gold(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv9` = '%d' WHERE `idclan` = '%d'",clans[id][inv][9], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 10)
		{
			if (amount < 0 || amount >= pData[playerid][inv][10]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Lockpick(s)", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][10] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][10] -= amount;
			clans[id][inv][10] += amount;
			SendServerMessage(playerid,"You give %d Lockpick(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv10` = '%d' WHERE `idclan` = '%d'",clans[id][inv][10], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 11)
		{
			if (amount < 0 || amount >= pData[playerid][inv][11]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Repair kit", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][11] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][11] -= amount;
			clans[id][inv][11] += amount;
			SendServerMessage(playerid,"You give %d Repair kit(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv11` = '%d' WHERE `idclan` = '%d'",clans[id][inv][11], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 12)
		{
			if (amount < 0 || amount >= pData[playerid][inv][12]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Med Kit", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][12] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][12] -= amount;
			clans[id][inv][12] += amount;
			SendServerMessage(playerid,"You give %d Med Kit(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv12` = '%d' WHERE `idclan` = '%d'",clans[id][inv][12], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 13)
		{
			if (amount < 0 || amount >= pData[playerid][inv][13]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Jerrycan", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][13] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][13] -= amount;
			clans[id][inv][13] += amount;
			SendServerMessage(playerid,"You give %d Jerrycan(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv13` = '%d' WHERE `idclan` = '%d'",clans[id][inv][13], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 14)
		{
			if (amount < 0 || amount >= pData[playerid][inv][14]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "9mm Bullet", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][14] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][14] -= amount;
			clans[id][inv][14] += amount;
			SendServerMessage(playerid,"You give %d 9mm Bullet(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv14` = '%d' WHERE `idclan` = '%d'",clans[id][inv][14], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 15)
		{
			if (amount < 0 || amount >= pData[playerid][inv][15]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "00' Buck's", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][15] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][15] -= amount;
			clans[id][inv][15] += amount;
			SendServerMessage(playerid,"You give %d 00' Buck's into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv15` = '%d' WHERE `idclan` = '%d'",clans[id][inv][15], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 16)
		{
			if (amount < 0 || amount >= pData[playerid][inv][16]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, ".308(s)", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][16] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][16] -= amount;
			clans[id][inv][16] += amount;
			SendServerMessage(playerid,"You give %d .308(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv16` = '%d' WHERE `idclan` = '%d'",clans[id][inv][16], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 17)
		{
			if (amount < 0 || amount >= pData[playerid][inv][17]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "Armor Plate(s)", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][17] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][17] -= amount;
			clans[id][inv][17] += amount;
			SendServerMessage(playerid,"You give %d Armor Plate(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv12` = '%d' WHERE `idclan` = '%d'",clans[id][inv][17], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 18)
		{
			if (amount < 0 || amount >= pData[playerid][inv][18]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "inv18 ", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][18] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][18] -= amount;
			clans[id][inv][18] += amount;
			SendServerMessage(playerid,"You give %d Water Bottle(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv18` = '%d' WHERE `idclan` = '%d'",clans[id][inv][18], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 19)
		{
			if (amount < 0 || amount >= pData[playerid][inv][19]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "inv19 ", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][19] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][19] -= amount;
			clans[id][inv][19] += amount;
			SendServerMessage(playerid,"You give %d Canned Food(s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv19` = '%d' WHERE `idclan` = '%d'",clans[id][inv][19], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 20)
		{
			if (amount < 0 || amount >= pData[playerid][inv][20]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "inv20 ", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][20] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][20] -= amount;
			clans[id][inv][20] += amount;
			SendServerMessage(playerid,"You give %d inv20 (s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv20` = '%d' WHERE `idclan` = '%d'",clans[id][inv][20], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 21)
		{
			if (amount < 0 || amount >= pData[playerid][inv][21]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "inv21 ", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][21] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][21] -= amount;
			clans[id][inv][21] += amount;
			SendServerMessage(playerid,"You give %d inv21 (s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv21` = '%d' WHERE `idclan` = '%d'",clans[id][inv][21], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 22)
		{
			if (amount < 0 || amount >= pData[playerid][inv][22]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "inv22 ", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][22] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][22] -= amount;
			clans[id][inv][22] += amount;
			SendServerMessage(playerid,"You give %d inv22 (s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv22` = '%d' WHERE `idclan` = '%d'",clans[id][inv][22], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 23)
		{
			if (amount < 0 || amount >= pData[playerid][inv][23]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "inv23 ", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][23] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][23] -= amount;
			clans[id][inv][23] += amount;
			SendServerMessage(playerid,"You give %d inv23 (s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv23` = '%d' WHERE `idclan` = '%d'",clans[id][inv][23], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 24)
		{
			if (amount < 0 || amount >= pData[playerid][inv][24]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "inv24 ", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][24] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][24] -= amount;
			clans[id][inv][24] += amount;
			SendServerMessage(playerid,"You give %d inv24 (s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv24` = '%d' WHERE `idclan` = '%d'",clans[id][inv][24], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		if(claninv == 25)
		{
			if (amount < 0 || amount >= clans[id][inv][25]) return Dialog_Show(playerid, CLANDIALOG200, DIALOG_STYLE_INPUT, "inv25 ", "Error on the quantity!\nHow much you want to give?", "give", "Back");
			if (clans[id][inv][25] + amount > GetClanCapacity(id))
				return SendServerMessage(playerid, "Not enough storage space for this item in clan chest.");
			pData[playerid][inv][25] -= amount;
			clans[id][inv][25] += amount;
			SendServerMessage(playerid,"You give %d inv25 (s) into the chest clan.",amount);
			mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `inv25` = '%d' WHERE `idclan` = '%d'",clans[id][inv][25], clans[id][idclan]);
			mysql_tquery(mysql, query);
		}
		claninv = -1;
	}
	else
	{
		Dialog_Show(playerid, CLANDIALOG20,DIALOG_STYLE_TABLIST,"Inventory","Meat(s) : \t%d\nWood(s) : \t%d\nMetal(s) : \t%d\nCloth(s) : \t%d\nPlastic(s) : \t%d\nGun Powder(s) : \t%d\nOre(s) : \t%d\nIron(s) : \t%d\nGold(s) : \t%d\nLockpick(s) : \t%d\n\
		Repair kit(s) : \t%d\nMed Kit( s): \t%d\nJerrycan(s) : \t%d\n9mm Bullet(s) : \t%d\n00' Buck's : \t%d\n.308(s) : \t%d\nArmor Plate(s) : \t%d\nWater Bottle : \t%d\nCanned Food : \t%d\ninv20 : \t%d\n\
		inv21 : \t%d\ninv22 : \t%d\ninv23 : \t%d\ninv24 : \t%d\ninv25 : \t%d\
		", "Close","",pData[playerid][inv][1],pData[playerid][inv][2],pData[playerid][inv][3],pData[playerid][inv][4],pData[playerid][inv][5],\
		pData[playerid][inv][6],pData[playerid][inv][7],pData[playerid][inv][8],pData[playerid][inv][9],pData[playerid][inv][10],\
		pData[playerid][inv][11],pData[playerid][inv][12],pData[playerid][inv][13],pData[playerid][inv][14],pData[playerid][inv][15],\
		pData[playerid][inv][16],pData[playerid][inv][17],pData[playerid][inv][18],pData[playerid][inv][19],pData[playerid][inv][20],\
		pData[playerid][inv][21],pData[playerid][inv][22],pData[playerid][inv][23],pData[playerid][inv][24],pData[playerid][inv][25]);
	}
	return 1;
}
//clan ressource
Dialog:Ressources(playerid, response, listitem, inputtext[])
{
    if (response)
	{
        switch (listitem)
        {
            case 0: cmd_clanres(playerid, "");
			case 1: ConvertZoneResource(playerid,1, 10, 5);
			case 2: ConvertZoneResource(playerid,2, 10, 2);
			case 3: ConvertZoneResource(playerid,3, 5, 3);
			case 4: ConvertZoneResource(playerid,4, 5, 3);
			case 5: ConvertZoneResource(playerid,5, 5, 3);
			case 6: ConvertZoneResource(playerid,6, 10, 5);
			case 7: ConvertZoneResource(playerid,18, 2, 1);
			case 8: ConvertZoneResource(playerid,19, 2, 1);
		}
	}	
	return 1;
}
//storage
Dialog:storageData(playerid, response, listitem, inputtext[])
{
    if (response)
	{
        static id = -1;
        switch (listitem)
        {
            case 0:
            {
				if (pData[playerid][inv][1] >= 100 && pData[playerid][inv][2] >= 100 && pData[playerid][inv][4] >= 100)
				{
					pData[playerid][inv][1] -= 100;
					pData[playerid][inv][2] -= 100;
					pData[playerid][inv][4] -= 100;
					pData[playerid][clanexp][0] += 300;
					id = storages_Create(playerid);
					if (id == -1) return SendServerMessage(playerid, "Max limits storages");
					ResetEditing(playerid);
					pData[playerid][pEditobjects] = id;
					EditDynamicObject(playerid, storageData[id][storagesOb]);
					SendServerMessage(playerid, "You have created an storage with (ID: %d.)", id);
					SendServerMessage(playerid, "To claim it use /storage.");
				}
				else SendServerMessage(playerid, "You don't have 100 Metal(s) or/and 100 plastic(s) or/and 100 wood(s).");

            }
            case 1:
            {
				if ((id = Storage_Nearest(playerid)) != -1) if (storageData[id][storagesLock] != pData[playerid][ID]) return SendServerMessage(playerid, "This is not your storage or near one.");
				//retake every item form the storage
				pData[playerid][inv][1] += storageData[id][storagesInv][1];
				pData[playerid][inv][2] += storageData[id][storagesInv][2];
				pData[playerid][inv][3] += storageData[id][storagesInv][3];
				pData[playerid][inv][4] += storageData[id][storagesInv][4];
				pData[playerid][inv][5] += storageData[id][storagesInv][5];
				pData[playerid][inv][6] += storageData[id][storagesInv][6];
				pData[playerid][inv][7] += storageData[id][storagesInv][7];
				pData[playerid][inv][8] += storageData[id][storagesInv][8];
				pData[playerid][inv][9] += storageData[id][storagesInv][9];
				pData[playerid][inv][10] += storageData[id][storagesInv][10];
				pData[playerid][inv][11] += storageData[id][storagesInv][11];
				pData[playerid][inv][12] += storageData[id][storagesInv][12];
				pData[playerid][inv][13] += storageData[id][storagesInv][13];
				pData[playerid][inv][14] += storageData[id][storagesInv][14];
				pData[playerid][inv][15] += storageData[id][storagesInv][15];
				pData[playerid][inv][16] += storageData[id][storagesInv][16];
				pData[playerid][inv][17] += storageData[id][storagesInv][17];
				pData[playerid][inv][18] += storageData[id][storagesInv][18];
				pData[playerid][inv][19] += storageData[id][storagesInv][19];
				pData[playerid][inv][20] += storageData[id][storagesInv][20];
				pData[playerid][inv][21] += storageData[id][storagesInv][21];
				pData[playerid][inv][22] += storageData[id][storagesInv][22];
				pData[playerid][inv][23] += storageData[id][storagesInv][23];
				pData[playerid][inv][24] += storageData[id][storagesInv][24];
				pData[playerid][inv][25] += storageData[id][storagesInv][25];
				storages_Delete(id);
				SendServerMessage(playerid, "You have delete your storage (ID: %d.) and retake everything from it.", id);
            }
            case 2:
            {
				if ((id = Storage_Nearest(playerid)) != -1) if (storageData[id][storagesLock] != pData[playerid][ID]) return SendServerMessage(playerid, "This is not your storage or near one.");
				ResetEditing(playerid);
				EditDynamicObject(playerid, storageData[id][storagesOb]);
				pData[playerid][pEditobjects] = id;
				pData[playerid][pEditType] = 2;
				SendServerMessage(playerid, "You are now editing the storage (ID: %d.) position.", id);
            }
            case 3:
            {
				if ((id = Storage_Nearest(playerid)) != -1) if (storageData[id][storagesLock] != 0) return SendServerMessage(playerid, "This storage is already claim.");
				storageData[id][storagesLock] = pData[playerid][ID];
				storages_Save(id);
				SendServerMessage(playerid, "You have claim the storage (ID: %d.)", id);
            }
		}
        return 1;
	}
	return 1;
}
//change weapon
Dialog:CHANGEWEAPON(playerid, response, listitem, inputtext[])
{
    if (response)
	{
        if(response)
        {
            ReplaceWeapon(playerid,ChangeWeaponOld[playerid],ChangeWeaponNew[playerid]);
            SendServerMessage(playerid,"Weapon replaced.");
        }
        else SendServerMessage(playerid,"You kept your current weapon.");
        return 1;
    }
    return 0;
}