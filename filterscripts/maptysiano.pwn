#include <a_samp>
#include <streamer>
#include <a_mysql>
#include <zcmd>
#include <sscanf2>

#define SQL_HOSTNAME "xx"
#define SQL_USERNAME "xx"
#define SQL_DATABASE "xx"
#define SQL_PASSWORD "xx"

new g_iHandle;
SQL_Connect() {
	g_iHandle = mysql_connect(SQL_HOSTNAME, SQL_USERNAME, SQL_DATABASE, SQL_PASSWORD);

	if (mysql_errno(g_iHandle) == 1) {
		printf("[SQL] Connection to \"%s\" failed! Please check the connection settings...\a", SQL_HOSTNAME);
	}
	else {
		printf("[SQL] Connection to \"%s\" passed!", SQL_HOSTNAME);
	}
}



//mapping ig
#define MAX_batiementS															(3000)
new EnMapping[MAX_PLAYERS];
//new EnCmap[MAX_PLAYERS];
forward batiement_Load();
forward OnbatiementCreated(batiementid);
enum BatiementData {
	batiementID,
	batiementExists,
	batiementModel,
	Float:batiementPos[6],
	batiementInterior,
	batiementWorld,
	batiementObject
};
new batiementData[MAX_batiementS][BatiementData];
enum pmapdata {
    	pEditbatiement,
    	pEditType
};
new MapData[MAX_PLAYERS][pmapdata];
public batiement_Load()
{
    static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_batiementS)
	{
	    batiementData[i][batiementExists] = true;

	    batiementData[i][batiementID] = cache_get_field_content_int(i, "batiementID");
	    batiementData[i][batiementModel] = cache_get_field_content_int(i, "batiementModel");
	    batiementData[i][batiementInterior] = cache_get_field_content_int(i, "batiementInterior");
	    batiementData[i][batiementWorld] = cache_get_field_content_int(i, "batiementWorld");

	    batiementData[i][batiementPos][0] = cache_get_field_content_float(i, "batiementX");
	    batiementData[i][batiementPos][1] = cache_get_field_content_float(i, "batiementY");
	    batiementData[i][batiementPos][2] = cache_get_field_content_float(i, "batiementZ");
	    batiementData[i][batiementPos][3] = cache_get_field_content_float(i, "batiementRX");
	    batiementData[i][batiementPos][4] = cache_get_field_content_float(i, "batiementRY");
	    batiementData[i][batiementPos][5] = cache_get_field_content_float(i, "batiementRZ");

	    batiementData[i][batiementObject] = CreateDynamicObject(batiementData[i][batiementModel], batiementData[i][batiementPos][0], batiementData[i][batiementPos][1], batiementData[i][batiementPos][2], batiementData[i][batiementPos][3], batiementData[i][batiementPos][4], batiementData[i][batiementPos][5], batiementData[i][batiementWorld], batiementData[i][batiementInterior]);
	}
	return 1;
}
CMD:aidemapping(playerid, params[])
{
    SendClientMessage(playerid,-1, "CREER UN OBJET: /creermapping");
    SendClientMessage(playerid,-1, "EDITER UN OBJET: /editmapping");
    SendClientMessage(playerid,-1, "SE TP A UN OBJET: /gotomapping");
    SendClientMessage(playerid,-1, "SUPPRIMER UN OBJET: /supmapping");
    return 1;
}


CMD:creermapping(playerid, params[])
{
    if(EnMapping[playerid] != 0) return SendClientMessage(playerid,-1,"Finissez votre édition en cours.");
	static id = -1;
	id = batiement_Create(playerid);
	if (id == -1)
	    return SendClientMessage(playerid,-1, "MAX LIMITES");
    MapData[playerid][pEditbatiement] = id;
    MapData[playerid][pEditType] = 1;
    EnMapping[playerid] = 1;
	EditDynamicObject(playerid, batiementData[id][batiementObject]);
	SendClientMessage(playerid,-1, "Créer avec succès batiement (ID: %d.)");
	return 1;
}

CMD:supmapping(playerid, params[])
{
  
	static id = 0;
	if (sscanf(params, "d"))
	    return SendClientMessage(playerid,-1, "/supmapping [batiement id]");
	if ((id < 0 || id >= MAX_batiementS) || !batiementData[id][batiementExists])
	    return SendClientMessage(playerid,-1, "Vous avez spécifier un mapping invalide.");
	batiement_Delete(id);
	SendClientMessage(playerid,-1, "Vous avez supprimé avec succes le mapping (ID: %d.)");
	return 1;
}
CMD:gotomapping(playerid, params[])
{

	static id;
	if (sscanf(params, "d"))
 	{
 	    SendClientMessage(playerid,-1, "/gotomapping [id]");
		return 1;
	}
	if ((id < 0 || id >= MAX_batiementS) || !batiementData[id][batiementExists])
	    return SendClientMessage(playerid,-1, "Vous avez spécifier un mapping invalide.");
		SetPlayerPos(playerid,batiementData[id][batiementPos][0],batiementData[id][batiementPos][1],batiementData[id][batiementPos][2]);
		return 1;
}
CMD:idmapping(playerid, params[])
{
 

  //  static Float:x,Float:y,Float:z;
//	GetPlayerPos(playerid, x, y, z);

	/*for (new i = 0; i < MAX_batiemntS; i ++) if (batiementData[i][batiementExists] && IsPlayerInRangeOfPoint(playerid, 15.5, batiementData[i][batiementPos][0], batiementData[i][batiementPos][1], batiementData[i][batiementPos][2]))
	{
		SendClientMessage(playerid,-1,"[MAPPING]: Model: %d - ID: %d.", batiementData[id][batiementModel], id);
	}*/


    /*for(new id = -1; id < MAX_batiementS; id ++)
   	{
		if(batiementData[id][batiementExists]){
            if(IsPlayerInRangeOfPoint(playerid, 15.0, batiementData[id][batiementPos][0],batiementData[id][batiementPos][1],batiementData[id][batiementPos][2])){
            	SendClientMessage(playerid,-1,"[MAPPING]: Model: %d - ID: %d.", batiementData[id][batiementModel], id);
            }
		}
	}*/
	return 1;
}
CMD:editmapping(playerid, params[])
{
 
	static id,type[24],string[128];
	if (sscanf(params, "ds[24]S()[128]", type, string))
 	{
	 	SendClientMessage(playerid,-1, "/editmapping [id] [name]");
	    SendClientMessage(playerid, -1, "MAPPING: model, pos");
		return 1;
	}
	if ((id < 0 || id >= MAX_batiementS) || !batiementData[id][batiementExists])
	    return SendClientMessage(playerid,-1, "Vous avez spécifier un mapping invalide.");
    if (!strcmp(type, "location", true))
	{
		static Float:x,Float:y,Float:z,Float:angle;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		x += 3.0 * floatsin(-angle, degrees);
		y += 3.0 * floatcos(-angle, degrees);
		batiementData[id][batiementPos][0] = x;
		batiementData[id][batiementPos][1] = y;
		batiementData[id][batiementPos][2] = z;
		batiementData[id][batiementPos][3] = 0.0;
		batiementData[id][batiementPos][4] = 0.0;
		batiementData[id][batiementPos][5] = angle;
		SetDynamicObjectPos(batiementData[id][batiementObject], x, y, z);
		SetDynamicObjectRot(batiementData[id][batiementObject], 0.0, 0.0, angle);
		batiement_Save(id);
		SendClientMessage(playerid,-1,"[MAPPING]: mapping changé de location)");
		EnMapping[playerid] = 0;
		return 1;
	}
	else if (!strcmp(type, "model", true))
	{
	    static model;
		if (sscanf(string, "d", model))
		    return SendClientMessage(playerid,-1, "/editbatiement [id] [model] [batiement model]");
  		if(EnMapping[playerid] != 0) return SendClientMessage(playerid,-1,"Finissez votre édition en cours.");
        batiementData[id][batiementModel] = model;
		DestroyDynamicObject(batiementData[id][batiementObject]);
		batiementData[id][batiementObject] = CreateDynamicObject(batiementData[id][batiementModel], batiementData[id][batiementPos][0], batiementData[id][batiementPos][1], batiementData[id][batiementPos][2], batiementData[id][batiementPos][3], batiementData[id][batiementPos][4], batiementData[id][batiementPos][5], batiementData[id][batiementWorld], batiementData[id][batiementInterior]);
		batiement_Save(id);
		SendClientMessage(playerid,-1,"[MAPPING]: Vous ajustez le modele");
		return 1;
	}
    else if (!strcmp(type, "pos", true))
	{
	    if(EnMapping[playerid] != 0) return SendClientMessage(playerid,-1,"Finissez votre édition en cours.");
	   	EditDynamicObject(playerid, batiementData[id][batiementObject]);
		MapData[playerid][pEditbatiement] = id;
		MapData[playerid][pEditType] = 1;
		EnMapping[playerid] = 2;
		SendClientMessage(playerid,-1, "Vous réglez la position de l'objet");
		return 1;
	}
	return 1;
}
//mapping ig
stock batiement_Create(playerid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;
	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_batiementS; i ++) if (!batiementData[i][batiementExists])
		{
		    batiementData[i][batiementExists] = true;
			batiementData[i][batiementModel] = 19357;
			batiementData[i][batiementPos][0] = x + (3.0 * floatsin(-angle, degrees));
			batiementData[i][batiementPos][1] = y + (3.0 * floatcos(-angle, degrees));
			batiementData[i][batiementPos][2] = z;
			batiementData[i][batiementPos][3] = 0.0;
			batiementData[i][batiementPos][4] = 0.0;
			batiementData[i][batiementPos][5] = angle;
            batiementData[i][batiementInterior] = GetPlayerInterior(playerid);
            batiementData[i][batiementWorld] = GetPlayerVirtualWorld(playerid);
            batiementData[i][batiementObject] = CreateDynamicObject(batiementData[i][batiementModel], batiementData[i][batiementPos][0], batiementData[i][batiementPos][1], batiementData[i][batiementPos][2], batiementData[i][batiementPos][3], batiementData[i][batiementPos][4], batiementData[i][batiementPos][5], batiementData[i][batiementWorld], batiementData[i][batiementInterior]);
			mysql_tquery(g_iHandle, "INSERT INTO `batiements` (`batiementModel`) VALUES(19510)", "OnbatiementCreated", "d", i);
			return i;
		}
	}
	return -1;
}
stock batiement_Delete(batiementid)
{
	if (batiementid != -1 && batiementData[batiementid][batiementExists])
	{
		new query[64];
		format(query, sizeof(query), "DELETE FROM `batiements` WHERE `batiementID` = '%d'", batiementData[batiementid][batiementID]);
		mysql_tquery(g_iHandle, query);
		if (IsValidDynamicObject(batiementData[batiementid][batiementObject]))
		    DestroyDynamicObject(batiementData[batiementid][batiementObject]);
		for (new i = 0; i < MAX_batiementS; i ++) if (batiementData[i][batiementExists]) {
		    batiement_Save(i);
		}
	    batiementData[batiementid][batiementExists] = false;
	    batiementData[batiementid][batiementID] = 0;
	}
	return 1;
}
stock batiement_Save(batiementid)
{
	new query[768];
	format(query, sizeof(query), "UPDATE `batiements` SET `batiementModel` = '%d',`batiementX` = '%.4f', `batiementY` = '%.4f', `batiementZ` = '%.4f', `batiementRX` = '%.4f', `batiementRY` = '%.4f', `batiementRZ` = '%.4f', `batiementInterior` = '%d', `batiementWorld` = '%d' WHERE `batiementID` = '%d'",
	    batiementData[batiementid][batiementModel],
	    batiementData[batiementid][batiementPos][0],
	    batiementData[batiementid][batiementPos][1],
	    batiementData[batiementid][batiementPos][2],
	    batiementData[batiementid][batiementPos][3],
	    batiementData[batiementid][batiementPos][4],
	    batiementData[batiementid][batiementPos][5],
	    batiementData[batiementid][batiementInterior],
	    batiementData[batiementid][batiementWorld],
	    batiementData[batiementid][batiementID]
	);
	return mysql_tquery(g_iHandle, query);
}

public OnFilterScriptInit(){
    SQL_Connect();
	mysql_tquery(g_iHandle, "SELECT * FROM `batiements`", "batiement_Load", "");
	return 1;
}

public OnbatiementCreated(batiementid)
{
	if (batiementid == -1 || !batiementData[batiementid][batiementExists])
	    return 0;

	batiementData[batiementid][batiementID] = cache_insert_id(g_iHandle);
	batiement_Save(batiementid);
	return 1;
}















public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(!response && MapData[playerid][pEditbatiement] != -1 ) EditDynamicObject(playerid, batiementData[MapData[playerid][pEditbatiement]][batiementObject]);

	if (response == EDIT_RESPONSE_FINAL)
	{
		if (MapData[playerid][pEditbatiement] != -1 && batiementData[MapData[playerid][pEditbatiement]][batiementExists])
	    {
	        switch (MapData[playerid][pEditType])
	        {
	            case 1:
	            {
	                new id = MapData[playerid][pEditbatiement];
	                batiementData[MapData[playerid][pEditbatiement]][batiementPos][0] = x;
	                batiementData[MapData[playerid][pEditbatiement]][batiementPos][1] = y;
	                batiementData[MapData[playerid][pEditbatiement]][batiementPos][2] = z;
	                batiementData[MapData[playerid][pEditbatiement]][batiementPos][3] = rx;
	                batiementData[MapData[playerid][pEditbatiement]][batiementPos][4] = ry;
	                batiementData[MapData[playerid][pEditbatiement]][batiementPos][5] = rz;
	                DestroyDynamicObject(batiementData[id][batiementObject]);
					batiementData[id][batiementObject] = CreateDynamicObject(batiementData[id][batiementModel], batiementData[id][batiementPos][0], batiementData[id][batiementPos][1], batiementData[id][batiementPos][2], batiementData[id][batiementPos][3], batiementData[id][batiementPos][4], batiementData[id][batiementPos][5], batiementData[id][batiementWorld], batiementData[id][batiementInterior]);
					if(EnMapping[playerid] == 1) SendClientMessage(playerid,-1,"Création réussi.");
					if(EnMapping[playerid] == 2) SendClientMessage(playerid,-1,"Edit réussi.");
					EnMapping[playerid] = 0;
					batiement_Save(id);
                    SendClientMessage(playerid,-1,"Tu a modifié la position de la batiement ID: %d.");
				}
			}
		}
	}
	return 1;
}
