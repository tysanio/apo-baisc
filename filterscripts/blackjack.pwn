#include <a_samp>
#include <streamer>
#include <foreach>
#include <zcmd>
#include <easyDialog>

#define script%0(%1) forward%0(%1); public%0(%1)

#define SendBlackJackMessage(%0,%1) \
	SendClientMessageEx(%0,COLOR_LIME,"[Croupier]: {FFFFFF}" %1)

#define COLOR_LIME        														(0x00FF00BB)

enum blackjack {
	somme1,somme2,somme3,somme4,somme5,somme6,
	somme7,somme8,somme9,somme10,sommejouer,
	dealercarte1,dealercarte2,dealercarte3
}
new BlackJack[MAX_PLAYERS][blackjack];
new PlayerText:BlackJackTD[21][MAX_PLAYERS];

public OnFilterScriptInit()
{
	foreach (new i : Player) BlackJackTextdraw(i);
	return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
    BlackJackTextdraw(playerid);
    BlackJack[playerid][somme1] = 0;
	BlackJack[playerid][somme2] = 0;
	BlackJack[playerid][somme3] = 0;
	BlackJack[playerid][somme4] = 0;
	BlackJack[playerid][somme5] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    BlackJackTextdraw(playerid);
    BlackJack[playerid][somme1] = 0;
	BlackJack[playerid][somme2] = 0;
	BlackJack[playerid][somme3] = 0;
	BlackJack[playerid][somme4] = 0;
	BlackJack[playerid][somme5] = 0;
	return 1;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == BlackJackTD[12][playerid])
	{
	    Dialog_Show(playerid, BlackJackMiser, DIALOG_STYLE_INPUT, "BlackJack mise","Veuiller plac? une mise pour commencer.", "Mise", "Annuler");
	}
    if(playertextid == BlackJackTD[14][playerid])
	{
        if(BlackJack[playerid][sommejouer] <= 0) return SendBlackJackMessage(playerid,"Veuiller miser pour jouer.");
        SetTimerEx("blackjackstart1",1000, false, "d", playerid);
	}
    if(playertextid == BlackJackTD[16][playerid])
	{
		if(BlackJack[playerid][somme3] == 0)
		{
    		SetTimerEx("blackjackcarte1",1000, false, "d", playerid);
    	}
    	else if(BlackJack[playerid][somme4] == 0)
 		{
    		SetTimerEx("blackjackcarte2",1000, false, "d", playerid);
    	}
    	else if(BlackJack[playerid][somme5] == 0)
 		{
    		SetTimerEx("blackjackcarte3",1000, false, "d", playerid);
    	}
	}
	if(playertextid == BlackJackTD[20][playerid])
	{
		SendBlackJackMessage(playerid,"Au croupier de jouer");
		SetTimerEx("blackjackcroupier",1000, false, "d", playerid);
	}
    return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
    BlackJackTextdraw(playerid);
    BlackJack[playerid][somme1] = 0;
	BlackJack[playerid][somme2] = 0;
	BlackJack[playerid][somme3] = 0;
	BlackJack[playerid][somme4] = 0;
	BlackJack[playerid][somme5] = 0;
	for(new i = 0; i < 19; i++)
    {
		PlayerTextDrawHide(playerid,BlackJackTD[i][playerid]);
	}
	return 1;
}
script blackjackstart1(playerid)
{
    new sommetotal = BlackJack[playerid][somme1] + BlackJack[playerid][somme2] + BlackJack[playerid][somme3] + BlackJack[playerid][somme4] + BlackJack[playerid][somme5],string[8];
    //SendBlackJackMessage(playerid,"Votre somme est de %d",sommetotal); //debug
   	format(string, sizeof(string), "%d",sommetotal);
    PlayerTextDrawSetString(playerid,BlackJackTD[8][playerid],string);
    PlayerTextDrawShow(playerid,BlackJackTD[8][playerid]);
    switch (random(13))
	{
	    case 0:
	    {
            BlackJack[playerid][somme1] = 1;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd1h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd1s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd1d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd1c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 1:
	    {
            BlackJack[playerid][somme1] = 2;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd2h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd2s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd2d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd2c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 2:
	    {
            BlackJack[playerid][somme1] = 3;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd3h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd3s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd3d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd3c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 3:
	    {
            BlackJack[playerid][somme1] = 4;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd4h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd4s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd4d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd4c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 4:
	    {
            BlackJack[playerid][somme1] = 5;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd5h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd5s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd5d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd5c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 5:
	    {
            BlackJack[playerid][somme1] = 6;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd6h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd6s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd6d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd6c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 6:
	    {
            BlackJack[playerid][somme1] = 7;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd7h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd7s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd7d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd7c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 7:
	    {
            BlackJack[playerid][somme1] = 8;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd8h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd8s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd8d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd8c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 8:
	    {
            BlackJack[playerid][somme1] = 9;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd9h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd9s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd9d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd9c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 9:
	    {
            BlackJack[playerid][somme1] = 10;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd10h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd10s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd10d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd10c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 10:
	    {
            BlackJack[playerid][somme1] = 10;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd11h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd11s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd11d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd11c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 11:
	    {
            BlackJack[playerid][somme1] = 10;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd12h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd12s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd12d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd12c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 12:
	    {
            BlackJack[playerid][somme1] = 10;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd13h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd13s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd13d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd13c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
	}
	return 1;
}
script blackjackstart2(playerid)
{
    new sommetotal = BlackJack[playerid][somme1] + BlackJack[playerid][somme2] + BlackJack[playerid][somme3] + BlackJack[playerid][somme4] + BlackJack[playerid][somme5],string[8];
    //SendBlackJackMessage(playerid,"Votre somme est de %d",sommetotal); //debug
   	format(string, sizeof(string), "%d",sommetotal);
    PlayerTextDrawSetString(playerid,BlackJackTD[8][playerid],string);
    PlayerTextDrawShow(playerid,BlackJackTD[8][playerid]);
    switch (random(13))
	{
	    case 0:
	    {
            BlackJack[playerid][somme2] = 1;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd1h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd1s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd1d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd1c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 1:
	    {
            BlackJack[playerid][somme2] = 2;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd2h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd2s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd2d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd2c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 2:
	    {
            BlackJack[playerid][somme2] = 3;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd3h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd3s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd3d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd3c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 3:
	    {
            BlackJack[playerid][somme2] = 4;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd4h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd4s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd4d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd4c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 4:
	    {
            BlackJack[playerid][somme2] = 5;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd5h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd5s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd5d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd5c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 5:
	    {
            BlackJack[playerid][somme2] = 6;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd6h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd6s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd6d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd6c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 6:
	    {
            BlackJack[playerid][somme2] = 7;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd7h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd7s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd7d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd7c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 7:
	    {
            BlackJack[playerid][somme2] = 8;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd8h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd8s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd8d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd8c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 8:
	    {
            BlackJack[playerid][somme2] = 9;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd9h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd9s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd9d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd9c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 9:
	    {
            BlackJack[playerid][somme2] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd10h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd10s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd10d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd10c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 10:
	    {
            BlackJack[playerid][somme2] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd11h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd11s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd11d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd11c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 11:
	    {
            BlackJack[playerid][somme2] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd12h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd12s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd12d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd12c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 12:
	    {
            BlackJack[playerid][somme2] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd13h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd13s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd13d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd13c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
	}
	return 1;
}
script blackjackstart3(playerid)
{
    new sommetotal = BlackJack[playerid][somme1] + BlackJack[playerid][somme2] + BlackJack[playerid][somme3] + BlackJack[playerid][somme4] + BlackJack[playerid][somme5],string[8];
    //SendBlackJackMessage(playerid,"Votre somme est de %d",sommetotal); //debug
   	format(string, sizeof(string), "%d",sommetotal);
    PlayerTextDrawSetString(playerid,BlackJackTD[8][playerid],string);
    PlayerTextDrawShow(playerid,BlackJackTD[8][playerid]);
    if(sommetotal > 21)
	{
		SendBlackJackMessage(playerid,"Votre main est plus haute que 21");
    	BlackJack[playerid][somme1] = 0;
		BlackJack[playerid][somme2] = 0;
		BlackJack[playerid][somme3] = 0;
		BlackJack[playerid][somme4] = 0;
		BlackJack[playerid][somme5] = 0;
		PlayerTextDrawHide(playerid,BlackJackTD[1][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[2][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[3][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[4][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[5][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[8][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[10][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[18][playerid]);
		// -- l'argent au croupier
	}
    if(sommetotal == 21)
	{
		SendBlackJackMessage(playerid,"Votre main est 21!");
    	BlackJack[playerid][somme1] = 0;
		BlackJack[playerid][somme2] = 0;
		BlackJack[playerid][somme3] = 0;
		BlackJack[playerid][somme4] = 0;
		BlackJack[playerid][somme5] = 0;
		PlayerTextDrawHide(playerid,BlackJackTD[1][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[2][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[3][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[4][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[5][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[8][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[10][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[18][playerid]);
		//l'argent x2
	}
    return 1;
}
script blackjackcarte1(playerid)
{
    switch (random(13))
	{
	    case 0:
	    {
            BlackJack[playerid][somme3] = 1;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd1h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd1s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd1d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd1c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 1:
	    {
            BlackJack[playerid][somme3] = 2;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd2h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd2s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd2d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd2c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 2:
	    {
            BlackJack[playerid][somme3] = 3;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd3h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd3s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd3d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd3c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 3:
	    {
            BlackJack[playerid][somme3] = 4;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd4h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd4s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd4d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd4c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 4:
	    {
            BlackJack[playerid][somme3] = 5;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd5h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd5s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd5d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd5c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 5:
	    {
            BlackJack[playerid][somme3] = 6;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd6h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd6s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd6d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd6c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 6:
	    {
            BlackJack[playerid][somme3] = 7;
            SetTimerEx("blackjackstar3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd7h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd7s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd7d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd7c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 7:
	    {
            BlackJack[playerid][somme3] = 8;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd8h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd8s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd8d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd8c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 8:
	    {
            BlackJack[playerid][somme3] = 9;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd9h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd9s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd9d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd9c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 9:
	    {
            BlackJack[playerid][somme3] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd10h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd10s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd10d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd10c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 10:
	    {
            BlackJack[playerid][somme3] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd11h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd11s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd11d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd11c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 11:
	    {
            BlackJack[playerid][somme3] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd12h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd12s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd12d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd12c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 12:
	    {
            BlackJack[playerid][somme3] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd13h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd13s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd13d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd13c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
	}
	return 1;
}
script blackjackcarte2(playerid)
{
    switch (random(13))
	{
	    case 0:
	    {
            BlackJack[playerid][somme4] = 1;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd1h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd1s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd1d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd1c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 1:
	    {
            BlackJack[playerid][somme4] = 2;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd2h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd2s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd2d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd2c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 2:
	    {
            BlackJack[playerid][somme4] = 3;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd3h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd3s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd3d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd3c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 3:
	    {
            BlackJack[playerid][somme4] = 4;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd4h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd4s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd4d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd4c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 4:
	    {
            BlackJack[playerid][somme4] = 5;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd5h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd5s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd5d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd5c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 5:
	    {
            BlackJack[playerid][somme4] = 6;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd6h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd6s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd6d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd6c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 6:
	    {
            BlackJack[playerid][somme4] = 7;
            SetTimerEx("blackjackstar3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd7h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd7s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd7d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd7c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 7:
	    {
            BlackJack[playerid][somme4] = 8;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd8h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd8s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd8d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd8c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 8:
	    {
            BlackJack[playerid][somme4] = 9;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd9h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd9s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd9d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd9c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 9:
	    {
            BlackJack[playerid][somme4] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd10h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd10s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd10d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd10c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 10:
	    {
            BlackJack[playerid][somme4] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd11h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd11s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd11d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd11c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 11:
	    {
            BlackJack[playerid][somme4] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd12h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd12s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd12d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd12c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 12:
	    {
            BlackJack[playerid][somme4] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd13h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd13s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd13d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd13c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
	}
	return 1;
}
script blackjackcarte3(playerid)
{
    switch (random(13))
	{
	    case 0:
	    {
            BlackJack[playerid][somme5] = 1;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd1h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd1s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd1d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd1c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 1:
	    {
            BlackJack[playerid][somme5] = 2;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd2h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd2s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd2d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd2c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 2:
	    {
            BlackJack[playerid][somme5] = 3;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd3h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd3s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd3d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd3c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 3:
	    {
            BlackJack[playerid][somme5] = 4;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd4h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd4s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd4d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd4c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 4:
	    {
            BlackJack[playerid][somme5] = 5;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd5h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd5s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd5d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd5c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 5:
	    {
            BlackJack[playerid][somme5] = 6;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd6h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd6s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd6d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd6c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 6:
	    {
            BlackJack[playerid][somme5] = 7;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd7h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd7s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd7d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd7c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 7:
	    {
            BlackJack[playerid][somme5] = 8;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd8h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd8s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd8d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd8c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 8:
	    {
            BlackJack[playerid][somme5] = 9;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd9h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd9s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd9d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd9c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 9:
	    {
            BlackJack[playerid][somme5] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd10h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd10s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd10d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd10c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 10:
	    {
            BlackJack[playerid][somme5] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd11h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd11s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd11d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd11c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 11:
	    {
            BlackJack[playerid][somme5] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd12h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd12s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd12d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd12c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 12:
	    {
            BlackJack[playerid][somme5] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd13h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd13s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd13d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd13c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
	}
	return 1;
}
script blackjackcroupier(playerid)
{
	BlackJack[playerid][dealercarte1] = random(10);
	new blackjackcroupierpoint = BlackJack[playerid][dealercarte2] = random(10) + BlackJack[playerid][dealercarte1];
	if(blackjackcroupierpoint >= 22)
	{
	    PlayerTextDrawSetString(playerid,BlackJackTD[18][playerid],"~r~Busted");
	    PlayerTextDrawShow(playerid,BlackJackTD[18][playerid]);
	}
	else
	{
		new blackjackcroupierpoint2 = BlackJack[playerid][dealercarte3] = random(10) + blackjackcroupierpoint;
		if(blackjackcroupierpoint >= 22)
		{
	    	PlayerTextDrawSetString(playerid,BlackJackTD[18][playerid],"~r~Busted");
	    	PlayerTextDrawShow(playerid,BlackJackTD[18][playerid]);
		}
		else
		{
  			new sommetotal = BlackJack[playerid][somme1] + BlackJack[playerid][somme2] + BlackJack[playerid][somme3] + BlackJack[playerid][somme4] + BlackJack[playerid][somme5],string[4];
    		SendBlackJackMessage(playerid,"Votre somme est de %d et le croupier est de %d",sommetotal,blackjackcroupierpoint2);
    		format(string, sizeof(string), "%d",blackjackcroupierpoint2);
    		if((sommetotal >= blackjackcroupierpoint2) && blackjackcroupierpoint != 21)
    		{
    		    SendBlackJackMessage(playerid,"Vous avez gagner votre main contre le croupier.");
    		    PlayerTextDrawSetString(playerid,BlackJackTD[18][playerid],string);
    		    PlayerTextDrawShow(playerid,BlackJackTD[18][playerid]);
    		    GivePlayerMoney(playerid, 2*BlackJack[playerid][sommejouer]);
    		    //argent remis au joueur ou perdu a joueur x2
    		    SetTimerEx("finducroupier",5000,false,"d",playerid);
    		}
    		else
    		{
    		    SendBlackJackMessage(playerid,"Le croupier a gagnez");
    		    PlayerTextDrawSetString(playerid,BlackJackTD[18][playerid],string);
    		    PlayerTextDrawShow(playerid,BlackJackTD[18][playerid]);
    		    GivePlayerMoney(playerid, -BlackJack[playerid][sommejouer]);
    		    GivePlayerMoney(playerid, 2*BlackJack[playerid][sommejouer]);
    		    //argenr perdu du joueur a ajouter dans la banque truc
    		    SetTimerEx("finducroupier",5000,false,"d",playerid);
    		}
		}
	}
	return 1;
}
script finducroupier(playerid)
{
    PlayerTextDrawHide(playerid,BlackJackTD[1][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[2][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[3][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[4][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[5][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[8][playerid]);
    PlayerTextDrawHide(playerid,BlackJackTD[10][playerid]);
    PlayerTextDrawHide(playerid,BlackJackTD[18][playerid]);
    BlackJack[playerid][somme1] = 0;
	BlackJack[playerid][somme2] = 0;
	BlackJack[playerid][somme3] = 0;
	BlackJack[playerid][somme4] = 0;
	BlackJack[playerid][somme5] = 0;
	BlackJack[playerid][sommejouer] = 0;
	return 1;
}
Dialog:BlackJackMiser(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new misejb = strval(inputtext),string[8];
	    if (misejb < 1 || misejb > 99999) return Dialog_Show(playerid, BlackJackMiser, DIALOG_STYLE_INPUT, "BlackJack mise","Mise trop ?lev?e ou trop basse.\nEntre 1$ et 99999$ maximum.\nVeuiller plac? une mise pour commencer.", "Mise", "Annuler");
	    format(string, sizeof(string), "%d $",misejb);
	    PlayerTextDrawSetString(playerid,BlackJackTD[10][playerid],string);
	    BlackJack[playerid][sommejouer] = misejb;
	    PlayerTextDrawShow(playerid,BlackJackTD[10][playerid]);
	    //ici a mettre pour retirer l'argent
		GivePlayerMoney(playerid, -misejb);
	}
	return 1;
}
BlackJackTextdraw(playerid)
{
	BlackJackTD[0][playerid] = CreatePlayerTextDraw(playerid, 398.399993, 319.579986, "usebox");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[0][playerid], 0.000000, 11.408765);
	PlayerTextDrawTextSize(playerid,BlackJackTD[0][playerid], 146.800003, 0.000000);
	PlayerTextDrawAlignment(playerid,BlackJackTD[0][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[0][playerid], 0);
	PlayerTextDrawUseBox(playerid,BlackJackTD[0][playerid], true);
	PlayerTextDrawBoxColor(playerid,BlackJackTD[0][playerid], 102);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[0][playerid], 0);
	PlayerTextDrawFont(playerid,BlackJackTD[0][playerid], 0);

	BlackJackTD[1][playerid] = CreatePlayerTextDraw(playerid, 155.200012, 328.533203, "LD_CARD:cd1h");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[1][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid,BlackJackTD[1][playerid], 45.600009, 86.613334);
	PlayerTextDrawAlignment(playerid,BlackJackTD[1][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[1][playerid], -1);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[1][playerid], 0);
	PlayerTextDrawFont(playerid,BlackJackTD[1][playerid], 4);

	BlackJackTD[2][playerid] = CreatePlayerTextDraw(playerid, 201.799957, 328.537658, "LD_CARD:cd1h");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[2][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid,BlackJackTD[2][playerid], 45.600009, 86.613334);
	PlayerTextDrawAlignment(playerid,BlackJackTD[2][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[2][playerid], -1);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[2][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[2][playerid], 0);
	PlayerTextDrawFont(playerid,BlackJackTD[2][playerid], 4);

	BlackJackTD[3][playerid] = CreatePlayerTextDraw(playerid, 248.400009, 328.542114, "LD_CARD:cd1h");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[3][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid,BlackJackTD[3][playerid], 45.600009, 86.613334);
	PlayerTextDrawAlignment(playerid,BlackJackTD[3][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[3][playerid], -1);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[3][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[3][playerid], 0);
	PlayerTextDrawFont(playerid,BlackJackTD[3][playerid], 4);

	BlackJackTD[4][playerid] = CreatePlayerTextDraw(playerid, 295.400054, 328.546539, "LD_CARD:cd1h");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[4][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid,BlackJackTD[4][playerid], 45.600009, 86.613334);
	PlayerTextDrawAlignment(playerid,BlackJackTD[4][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[4][playerid], -1);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[4][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[4][playerid], 0);
	PlayerTextDrawFont(playerid,BlackJackTD[4][playerid], 4);

	BlackJackTD[5][playerid] = CreatePlayerTextDraw(playerid, 342.400024, 328.550994, "LD_CARD:cd1h");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[5][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid,BlackJackTD[5][playerid], 45.600009, 86.613334);
	PlayerTextDrawAlignment(playerid,BlackJackTD[5][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[5][playerid], -1);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[5][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[5][playerid], 0);
	PlayerTextDrawFont(playerid,BlackJackTD[5][playerid], 4);

	BlackJackTD[6][playerid] = CreatePlayerTextDraw(playerid, 469.599975, 319.082214, "usebox");
	PlayerTextDrawLetterSize(playerid, BlackJackTD[6][playerid], 0.000000, 11.353453);
	PlayerTextDrawTextSize(playerid, BlackJackTD[6][playerid], 399.199981, 0.000000);
	PlayerTextDrawAlignment(playerid, BlackJackTD[6][playerid], 1);
	PlayerTextDrawColor(playerid, BlackJackTD[6][playerid], 0);
	PlayerTextDrawUseBox(playerid, BlackJackTD[6][playerid], true);
	PlayerTextDrawBoxColor(playerid, BlackJackTD[6][playerid], 102);
	PlayerTextDrawSetShadow(playerid, BlackJackTD[6][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BlackJackTD[6][playerid], 0);
	PlayerTextDrawFont(playerid, BlackJackTD[6][playerid], 0);

	BlackJackTD[7][playerid] = CreatePlayerTextDraw(playerid, 409.199981, 319.075653, "MAIN :");
	PlayerTextDrawLetterSize(playerid, BlackJackTD[7][playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, BlackJackTD[7][playerid], 1);
	PlayerTextDrawColor(playerid, BlackJackTD[7][playerid], -1);
	PlayerTextDrawSetShadow(playerid, BlackJackTD[7][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BlackJackTD[7][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, BlackJackTD[7][playerid], 51);
	PlayerTextDrawFont(playerid, BlackJackTD[7][playerid], 1);
	PlayerTextDrawSetProportional(playerid, BlackJackTD[7][playerid], 1);

	BlackJackTD[8][playerid] = CreatePlayerTextDraw(playerid, 423.600036, 334.506805, "30");
	PlayerTextDrawLetterSize(playerid, BlackJackTD[8][playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, BlackJackTD[8][playerid], 1);
	PlayerTextDrawColor(playerid, BlackJackTD[8][playerid], -1);
	PlayerTextDrawSetShadow(playerid, BlackJackTD[8][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BlackJackTD[8][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, BlackJackTD[8][playerid], 51);
	PlayerTextDrawFont(playerid, BlackJackTD[8][playerid], 1);
	PlayerTextDrawSetProportional(playerid, BlackJackTD[8][playerid], 1);

	BlackJackTD[9][playerid] = CreatePlayerTextDraw(playerid, 408.800048, 348.444213, "PARIE :");
	PlayerTextDrawLetterSize(playerid, BlackJackTD[9][playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, BlackJackTD[9][playerid], 1);
	PlayerTextDrawColor(playerid, BlackJackTD[9][playerid], -1);
	PlayerTextDrawSetShadow(playerid, BlackJackTD[9][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BlackJackTD[9][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, BlackJackTD[9][playerid], 51);
	PlayerTextDrawFont(playerid, BlackJackTD[9][playerid], 1);
	PlayerTextDrawSetProportional(playerid, BlackJackTD[9][playerid], 1);

	BlackJackTD[10][playerid] = CreatePlayerTextDraw(playerid, 403.199951, 363.875518, "88888 $");
	PlayerTextDrawLetterSize(playerid, BlackJackTD[10][playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, BlackJackTD[10][playerid], 1);
	PlayerTextDrawColor(playerid, BlackJackTD[10][playerid], -1);
	PlayerTextDrawSetShadow(playerid, BlackJackTD[10][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BlackJackTD[10][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, BlackJackTD[10][playerid], 51);
	PlayerTextDrawFont(playerid, BlackJackTD[10][playerid], 1);
	PlayerTextDrawSetProportional(playerid, BlackJackTD[10][playerid], 1);

	BlackJackTD[11][playerid] = CreatePlayerTextDraw(playerid, 202.800003, 300.166687, "usebox");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[11][playerid], 0.000000, 1.231971);
	PlayerTextDrawTextSize(playerid,BlackJackTD[11][playerid], 148.000000, 0.000000);
	PlayerTextDrawAlignment(playerid,BlackJackTD[11][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[11][playerid], 0);
	PlayerTextDrawUseBox(playerid,BlackJackTD[11][playerid], true);
	PlayerTextDrawBoxColor(playerid,BlackJackTD[11][playerid], 102);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[11][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[11][playerid], 0);
	PlayerTextDrawFont(playerid,BlackJackTD[11][playerid], 0);

	BlackJackTD[12][playerid] = CreatePlayerTextDraw(playerid, 152.000015, 298.168884, "MISER");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[12][playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid,BlackJackTD[12][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[12][playerid], -1);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[12][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[12][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid,BlackJackTD[12][playerid], 51);
	PlayerTextDrawFont(playerid,BlackJackTD[12][playerid], 1);
	PlayerTextDrawSetProportional(playerid,BlackJackTD[12][playerid], 1);
	PlayerTextDrawSetSelectable(playerid,BlackJackTD[12][playerid], true);

	BlackJackTD[13][playerid] = CreatePlayerTextDraw(playerid, 255.999908, 300.166687, "usebox");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[13][playerid], 0.000000, 1.336669);
	PlayerTextDrawTextSize(playerid,BlackJackTD[13][playerid], 202.000000, 0.000000);
	PlayerTextDrawAlignment(playerid,BlackJackTD[13][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[13][playerid], 0);
	PlayerTextDrawUseBox(playerid,BlackJackTD[13][playerid], true);
	PlayerTextDrawBoxColor(playerid,BlackJackTD[13][playerid], 102);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[13][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[13][playerid], 0);
	PlayerTextDrawFont(playerid,BlackJackTD[13][playerid], 0);

	BlackJackTD[14][playerid] = CreatePlayerTextDraw(playerid, 204.399993, 297.671051, "JOUER");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[14][playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid,BlackJackTD[14][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[14][playerid], -1);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[14][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[14][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid,BlackJackTD[14][playerid], 51);
	PlayerTextDrawFont(playerid,BlackJackTD[14][playerid], 1);
	PlayerTextDrawSetProportional(playerid,BlackJackTD[14][playerid], 1);
	PlayerTextDrawSetSelectable(playerid,BlackJackTD[14][playerid], true);

	BlackJackTD[15][playerid] = CreatePlayerTextDraw(playerid, 306.799926, 300.664428, "usebox");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[15][playerid], 0.000000, 1.266050);
	PlayerTextDrawTextSize(playerid,BlackJackTD[15][playerid], 255.600006, 0.000000);
	PlayerTextDrawAlignment(playerid,BlackJackTD[15][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[15][playerid], 0);
	PlayerTextDrawUseBox(playerid,BlackJackTD[15][playerid], true);
	PlayerTextDrawBoxColor(playerid,BlackJackTD[15][playerid], 102);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[15][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[15][playerid], 0);
	PlayerTextDrawFont(playerid,BlackJackTD[15][playerid], 0);

	BlackJackTD[16][playerid] = CreatePlayerTextDraw(playerid, 258.799957, 298.168731, "CARTE");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[16][playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid,BlackJackTD[16][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[16][playerid], -1);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[16][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[16][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid,BlackJackTD[16][playerid], 51);
	PlayerTextDrawFont(playerid,BlackJackTD[16][playerid], 1);
	PlayerTextDrawSetProportional(playerid,BlackJackTD[16][playerid], 1);
	PlayerTextDrawSetSelectable(playerid,BlackJackTD[16][playerid], true);

	BlackJackTD[17][playerid] = CreatePlayerTextDraw(playerid, 403.599945, 380.799804, "Croupier");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[17][playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid,BlackJackTD[17][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[17][playerid], -1);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[17][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[17][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid,BlackJackTD[17][playerid], 51);
	PlayerTextDrawFont(playerid,BlackJackTD[17][playerid], 1);
	PlayerTextDrawSetProportional(playerid,BlackJackTD[17][playerid], 1);

	BlackJackTD[18][playerid] = CreatePlayerTextDraw(playerid, 424.399963, 399.715515, "30");
	PlayerTextDrawLetterSize(playerid,BlackJackTD[18][playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid,BlackJackTD[18][playerid], 1);
	PlayerTextDrawColor(playerid,BlackJackTD[18][playerid], -1);
	PlayerTextDrawSetShadow(playerid,BlackJackTD[18][playerid], 0);
	PlayerTextDrawSetOutline(playerid,BlackJackTD[18][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid,BlackJackTD[18][playerid], 51);
	PlayerTextDrawFont(playerid,BlackJackTD[18][playerid], 1);
	PlayerTextDrawSetProportional(playerid,BlackJackTD[18][playerid], 1);

	BlackJackTD[19][playerid] = CreatePlayerTextDraw(playerid, 353.799865, 300.171112, "usebox");
	PlayerTextDrawLetterSize(playerid, BlackJackTD[19][playerid], 0.000000, 1.266049);
	PlayerTextDrawTextSize(playerid, BlackJackTD[19][playerid], 305.599884, 0.000000);
	PlayerTextDrawAlignment(playerid, BlackJackTD[19][playerid], 1);
	PlayerTextDrawColor(playerid, BlackJackTD[19][playerid], 0);
	PlayerTextDrawUseBox(playerid, BlackJackTD[19][playerid], true);
	PlayerTextDrawBoxColor(playerid, BlackJackTD[19][playerid], 102);
	PlayerTextDrawSetShadow(playerid, BlackJackTD[19][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BlackJackTD[19][playerid], 0);
	PlayerTextDrawFont(playerid, BlackJackTD[19][playerid], 0);

	BlackJackTD[20][playerid] = CreatePlayerTextDraw(playerid, 307.800018, 298.173248, "FINIR");
	PlayerTextDrawLetterSize(playerid, BlackJackTD[20][playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, BlackJackTD[20][playerid], 1);
	PlayerTextDrawColor(playerid, BlackJackTD[20][playerid], -1);
	PlayerTextDrawSetShadow(playerid, BlackJackTD[20][playerid], 0);
	PlayerTextDrawSetOutline(playerid, BlackJackTD[20][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, BlackJackTD[20][playerid], 51);
	PlayerTextDrawFont(playerid, BlackJackTD[20][playerid], 1);
	PlayerTextDrawSetProportional(playerid, BlackJackTD[20][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, BlackJackTD[20][playerid], true);
}
CMD:bjstart(playerid, params[])
{
	/*if (!IsPlayerInRangeOfPoint(playerid,2.0,-238.3116,-26.3283,1004.14615) && !IsPlayerInRangeOfPoint(playerid,5.0,-236.7883,-31.4460,1004.1461))
		return SendBlackJackMessage(playerid, "Vous n'?tes pas a la bonne place pour faire cela");*/
    SendBlackJackMessage(playerid,"BlackJack commencer");
    PlayerTextDrawShow(playerid,BlackJackTD[0][playerid]);
    PlayerTextDrawShow(playerid,BlackJackTD[6][playerid]);
    PlayerTextDrawShow(playerid,BlackJackTD[7][playerid]);
    PlayerTextDrawShow(playerid,BlackJackTD[9][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[11][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[12][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[13][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[14][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[15][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[16][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[17][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[19][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[20][playerid]);
	SelectTextDraw(playerid, -1);
    return 1;
}
CMD:bjstop(playerid, params[])
{
    BlackJack[playerid][somme1] = 0;
	BlackJack[playerid][somme2] = 0;
	BlackJack[playerid][somme3] = 0;
	BlackJack[playerid][somme4] = 0;
	BlackJack[playerid][somme5] = 0;
	BlackJack[playerid][sommejouer] = 0;
	PlayerTextDrawHide(playerid,BlackJackTD[0][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[1][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[2][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[3][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[4][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[5][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[6][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[7][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[8][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[9][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[10][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[11][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[12][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[13][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[14][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[15][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[16][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[17][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[18][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[19][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[20][playerid]);
    SendBlackJackMessage(playerid,"BlackJack fini");
    CancelSelectTextDraw(playerid);
    return 1;
}
stock SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
	static
	    args,
	    str[144];
	if ((args = numargs()) == 3)
	{
	    SendClientMessage(playerid, color, text);
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return 1;
}
