// cette version est fait que les changement sur le code seulement
// faire attention les accent ne fonctionne pas avec discord connector  si onutilise pas le strlib include
#include    <a_samp>
#include    <sscanf2>
#include    <zcmd>
#include    <easyDialog>
#include    <discord-connector>
#include    <discord-command>

#define DISCORD_PREFIX "??" // your prefix to use command
#define GUILD_ID "999480199211130970"     // Your Server ID!
#define Role "Joueur" // you role name
#define ChatDC "·chat-box" // name chat

new DCC_Guild:GUILD_ID1,DCC_Role: RoleStaff,bool:simembreroleok,DCC_Channel: discordlog;

public OnFilterScriptInit()
{
    GUILD_ID1 = DCC_FindGuildById( GUILD_ID );
    RoleStaff = DCC_Role:DCC_FindRoleByName (DCC_Guild:GUILD_ID1, Role );   //role
    discordlog = DCC_FindChannelByName( ChatDC );                           // chat
    DCC_SetBotNickname(GUILD_ID1, "Catalina");                              //nom du bot
    DCC_SetBotActivity("Tu vois je suis online!");                          // activité du bot
    DCC_SendChannelMessage(discordlog,"Je suis vivant! :)");
    return 1;
}
public OnFilterScriptExit()
{
    DCC_SendChannelMessage(discordlog,"Je meurt X_X.");
    return 1;
}
stock ReturnDiscordName( DCC_User: author )
{
	static name[ 32+1 ];
	DCC_GetUserName( author, name, sizeof( name ) );
	return name;
}
//******************commande IG*******************
CMD:chat(playerid,params[])
{
    new string[65],name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));
    if (strlen(string) < 64)
	{
	    format(string, sizeof(string),"Player %s say : %s",name,params);
    	DCC_SendChannelMessage(discordlog,string);
    	SendClientMessage(playerid,-1,string);
    }
    else SendClientMessage(playerid,-1,"Text exceed 64 character long.");
    return 1;
}
//******************commande discord !*******************
DISCORD:c( DCC_Channel: channel, DCC_User: author, params[ ] )
{
	new msg[100];
    if(sscanf(params, "s[100]", msg)) return DCC_SendChannelMessage(discordlog,""DISCORD_PREFIX"c [Msg]");
    DCC_SendChannelMessage(discordlog, "%s: %s", ReturnDiscordName( author ), msg);
    format(msg, sizeof(msg),"[Discord] %s says : %s",ReturnDiscordName( author ),msg);
    SendClientMessageToAll(-1,msg);
    return 1;
}
DISCORD:players( DCC_Channel: channel, DCC_User: author, params[ ] )
{
	new name[24],msg[144];
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff,simembreroleok);
    if(simembreroleok)
    {
        DCC_SendChannelMessage(discordlog,"**__Joueurs sur le serveur__**");
        for(new i=0; i < MAX_PLAYERS; i++)
        {
            GetPlayerName(i, name, MAX_PLAYER_NAME);
            if(!IsPlayerConnected(i)) continue;
            format(msg, sizeof(msg),"```(ID : %d) %s score %d ping %d```",i, name,GetPlayerScore(i),GetPlayerPing(i));
            DCC_SendChannelMessage(discordlog,msg);
        }
    }
    else DCC_SendChannelMessage(discordlog,"Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:test( DCC_Channel: channel, DCC_User: author, params[ ] ) // discord command du CNR yes
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff,simembreroleok);
    if(simembreroleok) return DCC_SendChannelMessage(discordlog, "Ta le droit de faire cette commande");
    else DCC_SendChannelMessage(discordlog,"**[ERROR]** Ta pas le droit de faire cette commande");
    return 1;
}
DISCORD:kick( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff,simembreroleok);
	if (simembreroleok)
	{
		new pID;
		if (sscanf( params, "u", pID)) return DCC_SendChannelMessage( discordlog, "**[USAGE]** !kick [PLAYER_ID]" );
		if (IsPlayerConnected(pID))
		{
			DCC_SendChannelMessage(discordlog, "**[KICK]** **%s** a kick **%s(%d)**.", ReturnDiscordName( author ), GetName(pID), pID);
			Kick( pID );
		}
		else DCC_SendChannelMessage(discordlog, "**[ERROR]** Joueur non connecté!" );
	}
	else DCC_SendChannelMessage(discordlog, "**[ERROR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:ban( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff,simembreroleok);
	if (simembreroleok)
	{
		new pID;
		if (sscanf( params, "u", pID)) return DCC_SendChannelMessage( discordlog, "**[USAGE]** !ban [PLAYER_ID]" );
		if (IsPlayerConnected(pID))
		{
			DCC_SendChannelMessage(discordlog, "**[BAN]** **%s** as bannie **%s(%d)**.", ReturnDiscordName( author ), GetName(pID), pID);
			Ban( pID );
		}
		else DCC_SendChannelMessage(discordlog, "**[ERROR]** Joueur non conntecé!" );
	}
	else DCC_SendChannelMessage(discordlog, "**[ERROR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:npc( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff,simembreroleok);
	if (simembreroleok)
	{
        ConnectNPC("Albert", "Albert");
        DCC_SendChannelMessage(discordlog, "**[ADMIN]**Connexion d'un bot");
	}
	else DCC_SendChannelMessage(discordlog, "**[ERROR]** Ta pas le droit de faire cette commande");
}
DISCORD:reload( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff,simembreroleok);
	if (simembreroleok)
	{
        DCC_SendChannelMessage(discordlog, "**[ADMIN]** Rechargement du code.");
        SendRconCommand("reloadfs dc");
	}
	else DCC_SendChannelMessage(discordlog, "**[ERROR]** Ta pas le droit de faire cette commande");
}
stock GetName(playerid)
{
	new PlayerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	return PlayerName;
}
