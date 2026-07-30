CMD:discordconfirm(playerid,params[])
{
	Dialog_Show(playerid, discordid, DIALOG_STYLE_INPUT, "Assing role on discord", "Put your ID discord here", "There", "close");	
    return 1;
}
Dialog:discordid(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new DCC_User:user1 = DCC_FindUserById(inputtext),string[96];
		if(user1 == DCC_INVALID_USER)
			return Dialog_Show(playerid, discordid1, DIALOG_STYLE_INPUT, "Assing role on discord", "Error 1 ID user discord", "There", "Close");
		if(GUILD_ID1 == DCC_INVALID_GUILD) 
			return Dialog_Show(playerid, discordid1, DIALOG_STYLE_INPUT, "Assing role on discord", "Error 2 ID discord", "There", "Close");
		if(RoleJoueur == DCC_INVALID_ROLE) 
			return Dialog_Show(playerid, discordid1, DIALOG_STYLE_INPUT, "Assing role on discord", "Error 3 ID role", "There", "Close");
		DCC_AddGuildMemberRole(GUILD_ID1,user1,RoleJoueur);
		format(pData[playerid][pDiscordID],24,inputtext);
		
		mysql_format(mysql, query, sizeof(query), "UPDATE `players` SET `discordid`=%s WHERE `ID`=%d",inputtext,pData[playerid][ID]);
		mysql_tquery(mysql, query, "", "");
		SendServerMessage(playerid,"If your id correspond to you you will be assing the role verify");
		DCC_TriggerBotTypingIndicator(discordlog);
		format(string, sizeof(string), "```This Player %s just verify is account with id %s on discord!.```", Name[playerid],inputtext);
	    DCC_SendChannelMessage(discordlog,string); 
		return 1;
	}
	return 1;
}

CMD:dc(playerid,params[])
{
    new string[65],name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));
    if (strlen(string) < 64)
	{
	    format(string, sizeof(string),"Player %s say : %s",name,params);
    	DCC_SendChannelMessage(discordlog,string);
    	SendClientMessage(playerid,-1,string);
    }
    else SendServerMessage(playerid,"Text exceed 64 character long.");
    return 1;
}
CMD:suggest(playerid,params[])
{
    new string[65],name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));
    if (strlen(string) < 64)
	{
	    format(string, sizeof(string),"%s suggest : %s",name,params);
    	DCC_SendChannelMessage(discordlog,string);
    	SendServerMessage(playerid,"You send your suggestion to the discord");
    }
    else SendServerMessage(playerid,"Text exceed 64 character long.");
    return 1;
}
DISCORD:c( DCC_Channel: channel, DCC_User: author, params[ ] )
{
	new msg[100];
    if(sscanf(params, "s[100]", msg)) return DCC_SendChannelMessage(discordlog,"?c [Msg]");
    DCC_SendChannelMessage(discordlog, "%s: %s", ReturnDiscordName( author ), msg);
    format(msg, sizeof(msg),"[Discord] %s says : %s",ReturnDiscordName( author ),msg);
    SendClientMessageToAll(-1,msg);
    return 1;
}
DISCORD:players( DCC_Channel: channel, DCC_User: author, params[ ] )
{
	new name[24],msg[144];
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleJoueur,simembreroleok);
	if (simembreroleok)
	{
		DCC_SendChannelMessage(discordlog,"**__Players on the server__**");
		for(new i=0; i < 100; i++)
		{
			GetPlayerName(i, name, MAX_PLAYER_NAME);
			if(!IsPlayerConnected(i)) continue;
			DCC_TriggerBotTypingIndicator(discordlog);
			format(msg, sizeof(msg),"> (ID : %d) %s score %d ping %d",i, name,GetPlayerScore(i),GetPlayerPing(i));
			DCC_SendChannelMessage(discordlog,msg);
		}
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERROR]** You can't do this command.");
    return 1;
}
DISCORD:ostats( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
	if (sistaff1ok)
	{
		if ( isnull( params ) || strlen( params ) > 24 )
			return DCC_SendChannelMessage(discordlog,"> **[USAGE]** ?ostats [nom]");
		DCC_TriggerBotTypingIndicator(discordlog);
		format(query, sizeof(query), "SELECT * FROM `players` WHERE `Username` = '%s'", SQL_ReturnEscaped(params));
		mysql_tquery(mysql, query, "OnPlayerDiscordStats", "ds", INVALID_PLAYER_ID, params);
	}
	else DCC_SendChannelMessage( discordlog, "> **[ERROR]** You can't do this command.");
	return 1;
}
DISCORD:kick( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
	if (sistaff1ok)
	{
		new pID;
		if (sscanf( params, "u", pID)) return DCC_SendChannelMessage( discordlog, "**[USAGE]** ?kick [PLAYER_ID]" );
		if (IsPlayerConnected(pID))
		{
			DCC_SendChannelMessage(discordlog, "**[KICK]** **%s** as kick **%s(%d)**.", ReturnDiscordName( author ), GetName(pID), pID);
			Kick( pID );
		}
		else DCC_SendChannelMessage(discordlog, "> **[ERROR]** Player not connected!" );
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERROR]** You can't do this command.");
	return 1;
}
DISCORD:ban( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
	if (sistaff1ok)
	{
		new pID;
		if (sscanf( params, "u", pID)) return DCC_SendChannelMessage( discordlog, "**[USAGE]** ?ban [PLAYER_ID]" );
		if (IsPlayerConnected(pID))
		{
			DCC_SendChannelMessage(discordlog, "**[BAN]** **%s** as ban **%s(%d)**.", ReturnDiscordName( author ), GetName(pID), pID);
			Ban( pID );
		}
		else DCC_SendChannelMessage(discordlog, "> **[ERROR]** Player not connected!" );
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERROR]** You can't do this command.");
	return 1;
}
DISCORD:ping( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
	if (sistaff1ok)
	{
		DCC_TriggerBotTypingIndicator(discordlog);
		DCC_SendChannelMessage(discordlog, "Ping check");
		DCC_SetBotPresenceStatus(DO_NOT_DISTURB);
		DCC_SetBotActivity("Server Ping [DONE]");
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERROR]** You can't do this command.");
	return 1;
}
DISCORD:baninfo( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    static string[128];
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
	if (sistaff1ok)
	{
		DCC_TriggerBotTypingIndicator(discordlog);
		if (isnull(params) || strlen(params) > 24) DCC_SendChannelMessage( discordlog, "> **[USAGE]** ?baninfo [username]");
		else
		{
			format(string, sizeof(string), "SELECT * FROM `bans` WHERE `player_name` = '%s'", SQL_ReturnEscaped(params));
			mysql_tquery(mysql, string, "OnBanLookupDC", "ds", INVALID_PLAYER_ID, params);
		}
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERROR]** You can't do this command.");
	return 1;
}
script OnPlayerDiscordStats( playerid, params[ ] )
{
	new	rows,fields,string[70],string1[128],string4[128],string2[76],string3[76],string77[128],string99[128],clanexpj[5];
	new Admin1,VIP1,Score1,Skin1;
	DCC_TriggerBotTypingIndicator(discordlog);
	cache_get_data( rows, fields );
	if ( rows )
	{
		Admin1			= cache_get_field_content_int( 0, "Admin");
		VIP1   			= cache_get_field_content_int( 0, "VIP");
		Score1           = cache_get_field_content_int( 0, "Score");
        Skin1           = cache_get_field_content_int( 0, "skin");
		clanexpj[1]           = cache_get_field_content_int( 0, "clanexp1");
		clanexpj[2]           = cache_get_field_content_int( 0, "clanexp2");
		clanexpj[3]           = cache_get_field_content_int( 0, "clanexp3");
		clanexpj[4]           = cache_get_field_content_int( 0, "clanexp4");

		DCC_TriggerBotTypingIndicator(discordlog);
		format(string1, sizeof(string1), "**Player %s**",params);
		format(string4, sizeof(string4), "Admin: %s	VIP: %s	Score: %d",(Admin1) ? ("Yes") : ("No"),(VIP1) ? ("Yes") : ("No"),Score1);
        format(string2, sizeof(string2), "Clan Exp 2: %d/5000	Clan Exp 3: %d/5000",clanexpj[1],clanexpj[2]);
        format(string3, sizeof(string3), "Clan Exp 4: %d/5000	Clan Exp 5: %d/5000",clanexpj[3],clanexpj[4]);
		Embed = DCC_CreateEmbed(string1,string99);
		DCC_AddEmbedField(Embed ,string4,"");
        DCC_AddEmbedField(Embed ,string2,"");
        DCC_AddEmbedField(Embed ,string3,"");
		DCC_AddEmbedField(Embed ,string77,"----------------------SKIN IMAGE----------------------");
		DCC_SetEmbedColor(Embed,0xFF0000);
		format(string, sizeof(string), "https://gtaundergroundmod.com/resources/media/skins/%d.png",Skin1);
		DCC_SetEmbedImage(Embed,string);
		DCC_SendChannelEmbedMessage(discordlog, Embed);
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** This player doesn't exist in the database.");
	return 1;
}
script OnBanLookupDC(username[])
{
	static rows,fields,reason[128],date[36],string[196],string3[196];
	cache_get_data(rows, fields, mysql);
	if (rows) {
	    cache_get_field_content(0, "reason", reason, mysql);
	    cache_get_field_content(0, "ban_time", date, mysql);
	    cache_get_field_content(0, "player_name", username[24], mysql);
		DCC_TriggerBotTypingIndicator(discordlog);
		format(string, sizeof(string), "```This playeris banned, reason: %s```", reason);
		utf8encode(string3,string,sizeof(string3));
		DCC_SendChannelMessage(discordlog,string3); 
	}
	else {
		DCC_TriggerBotTypingIndicator(discordlog);
		format(string, sizeof(string), "```This Player is not ban from the server.```", username);
	    DCC_SendChannelMessage(discordlog,string); 
	}
	return 1;
}
stock ReturnDiscordName( DCC_User: author )
{
	static name[ 32+1 ];
	DCC_GetUserName( author, name, sizeof( name ) );
	return name;
}
script loaddiscord()
{
	DCC_SetBotPresenceStatus(DO_NOT_DISTURB);
    DCC_SetBotActivity("On arrive!");
    GUILD_ID1 = DCC_FindGuildById(Ddiscord);
    discordlog = DCC_FindChannelById(Dchat); //chat general
    RoleJoueur = DCC_Role:DCC_FindRoleById(Dverifier);
    RoleLeader = DCC_Role:DCC_FindRoleById(DLeader);
    RoleMember = DCC_Role:DCC_FindRoleById(DMember);
	RoleStaff1 = DCC_Role:DCC_FindRoleById(Dadmin1); //role
	return 1;
}