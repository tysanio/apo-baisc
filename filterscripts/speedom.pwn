#include <a_samp>
#include <foreach>
#include <zcmd>

#define script%0(%1) forward%0(%1); public%0(%1)

new Text:Textdraw[16],Text:Speed[MAX_PLAYERS],Speedo[MAX_PLAYERS];
public OnFilterScriptInit()
{
        Textdraw[0] = TextDrawCreate(571.000000, 364.000000, "BG");
        TextDrawBackgroundColor(Textdraw[0], 255);
        TextDrawFont(Textdraw[0], 1);
        TextDrawLetterSize(Textdraw[0], 0.000000, 2.200000);
        TextDrawColor(Textdraw[0], -1);
        TextDrawSetOutline(Textdraw[0], 0);
        TextDrawSetProportional(Textdraw[0], 1);
        TextDrawSetShadow(Textdraw[0], 1);
        TextDrawUseBox(Textdraw[0], 1);
        TextDrawBoxColor(Textdraw[0], 230);
        TextDrawTextSize(Textdraw[0], 387.000000, 2.000000);

        Textdraw[1] = TextDrawCreate(457.000000, 401.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[1], 255);
        TextDrawFont(Textdraw[1], 1);
        TextDrawLetterSize(Textdraw[1], 0.000000, -0.500000);
        TextDrawColor(Textdraw[1], -1);
        TextDrawSetOutline(Textdraw[1], 0);
        TextDrawSetProportional(Textdraw[1], 1);
        TextDrawSetShadow(Textdraw[1], 1);
        TextDrawUseBox(Textdraw[1], 1);
        TextDrawBoxColor(Textdraw[1], 16777215);
        TextDrawTextSize(Textdraw[1], 444.000000, 0.000000);

        Textdraw[2] = TextDrawCreate(467.000000, 401.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[2], 255);
        TextDrawFont(Textdraw[2], 1);
        TextDrawLetterSize(Textdraw[2], 0.000000, -0.600000);
        TextDrawColor(Textdraw[2], -1);
        TextDrawSetOutline(Textdraw[2], 0);
        TextDrawSetProportional(Textdraw[2], 1);
        TextDrawSetShadow(Textdraw[2], 1);
        TextDrawUseBox(Textdraw[2], 1);
        TextDrawBoxColor(Textdraw[2], 16777215);
        TextDrawTextSize(Textdraw[2], 454.000000, -1.000000);

        Textdraw[3] = TextDrawCreate(477.000000, 401.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[3], 255);
        TextDrawFont(Textdraw[3], 1);
        TextDrawLetterSize(Textdraw[3], 0.000000, -0.700000);
        TextDrawColor(Textdraw[3], -1);
        TextDrawSetOutline(Textdraw[3], 0);
        TextDrawSetProportional(Textdraw[3], 1);
        TextDrawSetShadow(Textdraw[3], 1);
        TextDrawUseBox(Textdraw[3], 1);
        TextDrawBoxColor(Textdraw[3], 16777215);
        TextDrawTextSize(Textdraw[3], 464.000000, -1.000000);

        Textdraw[4] = TextDrawCreate(487.000000, 401.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[4], 255);
        TextDrawFont(Textdraw[4], 1);
        TextDrawLetterSize(Textdraw[4], 0.000000, -0.800000);
        TextDrawColor(Textdraw[4], -1);
        TextDrawSetOutline(Textdraw[4], 0);
        TextDrawSetProportional(Textdraw[4], 1);
        TextDrawSetShadow(Textdraw[4], 1);
        TextDrawUseBox(Textdraw[4], 1);
        TextDrawBoxColor(Textdraw[4], 16777215);
        TextDrawTextSize(Textdraw[4], 474.000000, -1.000000);

        Textdraw[5] = TextDrawCreate(498.000000, 401.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[5], 255);
        TextDrawFont(Textdraw[5], 1);
        TextDrawLetterSize(Textdraw[5], 0.000000, -0.900000);
        TextDrawColor(Textdraw[5], -1);
        TextDrawSetOutline(Textdraw[5], 0);
        TextDrawSetProportional(Textdraw[5], 1);
        TextDrawSetShadow(Textdraw[5], 1);
        TextDrawUseBox(Textdraw[5], 1);
        TextDrawBoxColor(Textdraw[5], 16777215);
        TextDrawTextSize(Textdraw[5], 484.000000, -1.000000);

        Textdraw[6] = TextDrawCreate(508.000000, 401.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[6], 255);
        TextDrawFont(Textdraw[6], 1);
        TextDrawLetterSize(Textdraw[6], 0.000000, -1.000000);
        TextDrawColor(Textdraw[6], -1);
        TextDrawSetOutline(Textdraw[6], 0);
        TextDrawSetProportional(Textdraw[6], 1);
        TextDrawSetShadow(Textdraw[6], 1);
        TextDrawUseBox(Textdraw[6], 1);
        TextDrawBoxColor(Textdraw[6], 16777215);
        TextDrawTextSize(Textdraw[6], 495.000000, -1.000000);

        Textdraw[7] = TextDrawCreate(518.000000, 401.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[7], 255);
        TextDrawFont(Textdraw[7], 1);
        TextDrawLetterSize(Textdraw[7], 0.000000, -1.100000);
        TextDrawColor(Textdraw[7], -1);
        TextDrawSetOutline(Textdraw[7], 0);
        TextDrawSetProportional(Textdraw[7], 1);
        TextDrawSetShadow(Textdraw[7], 1);
        TextDrawUseBox(Textdraw[7], 1);
        TextDrawBoxColor(Textdraw[7], 16777215);
        TextDrawTextSize(Textdraw[7], 505.000000, -1.000000);

        Textdraw[8] = TextDrawCreate(529.000000, 401.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[8], 255);
        TextDrawFont(Textdraw[8], 1);
        TextDrawLetterSize(Textdraw[8], 0.000000, -1.300000);
        TextDrawColor(Textdraw[8], -1);
        TextDrawSetOutline(Textdraw[8], 0);
        TextDrawSetProportional(Textdraw[8], 1);
        TextDrawSetShadow(Textdraw[8], 1);
        TextDrawUseBox(Textdraw[8], 1);
        TextDrawBoxColor(Textdraw[8], 16777215);
        TextDrawTextSize(Textdraw[8], 515.000000, -1.000000);

        Textdraw[9] = TextDrawCreate(541.000000, 401.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[9], 255);
        TextDrawFont(Textdraw[9], 1);
        TextDrawLetterSize(Textdraw[9], 0.000000, -1.500000);
        TextDrawColor(Textdraw[9], -1);
        TextDrawSetOutline(Textdraw[9], 0);
        TextDrawSetProportional(Textdraw[9], 1);
        TextDrawSetShadow(Textdraw[9], 1);
        TextDrawUseBox(Textdraw[9], 1);
        TextDrawBoxColor(Textdraw[9], 16777215);
        TextDrawTextSize(Textdraw[9], 526.000000, -1.000000);

        Textdraw[10] = TextDrawCreate(553.000000, 401.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[10], 255);
        TextDrawFont(Textdraw[10], 1);
        TextDrawLetterSize(Textdraw[10], 0.000000, -1.700000);
        TextDrawColor(Textdraw[10], -1);
        TextDrawSetOutline(Textdraw[10], 0);
        TextDrawSetProportional(Textdraw[10], 1);
        TextDrawSetShadow(Textdraw[10], 1);
        TextDrawUseBox(Textdraw[10], 1);
        TextDrawBoxColor(Textdraw[10], 16777215);
        TextDrawTextSize(Textdraw[10], 538.000000, -1.000000);

        Textdraw[11] = TextDrawCreate(565.000000, 401.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[11], 255);
        TextDrawFont(Textdraw[11], 1);
        TextDrawLetterSize(Textdraw[11], 0.000000, -2.000000);
        TextDrawColor(Textdraw[11], -1);
        TextDrawSetOutline(Textdraw[11], 0);
        TextDrawSetProportional(Textdraw[11], 1);
        TextDrawSetShadow(Textdraw[11], 1);
        TextDrawUseBox(Textdraw[11], 1);
        TextDrawBoxColor(Textdraw[11], 16777215);
        TextDrawTextSize(Textdraw[11], 550.000000, -1.000000);

        Textdraw[13] = TextDrawCreate(446.000000, 367.000000, "KPH");
        TextDrawBackgroundColor(Textdraw[13], 255);
        TextDrawFont(Textdraw[13], 2);
        TextDrawLetterSize(Textdraw[13], 0.329999, 1.099999);
        TextDrawColor(Textdraw[13], -1);
        TextDrawSetOutline(Textdraw[13], 0);
        TextDrawSetProportional(Textdraw[13], 1);
        TextDrawSetShadow(Textdraw[13], 0);

        Textdraw[14] = TextDrawCreate(571.000000, 410.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[14], 255);
        TextDrawFont(Textdraw[14], 1);
        TextDrawLetterSize(Textdraw[14], 0.000000, -0.099999);
        TextDrawColor(Textdraw[14], -1);
        TextDrawSetOutline(Textdraw[14], 0);
        TextDrawSetProportional(Textdraw[14], 1);
        TextDrawSetShadow(Textdraw[14], 1);
        TextDrawUseBox(Textdraw[14], 1);
        TextDrawBoxColor(Textdraw[14], 190);
        TextDrawTextSize(Textdraw[14], 387.000000, 2.000000);

        Textdraw[15] = TextDrawCreate(571.000000, 359.000000, "New Textdraw");
        TextDrawBackgroundColor(Textdraw[15], 255);
        TextDrawFont(Textdraw[15], 1);
        TextDrawLetterSize(Textdraw[15], 0.000000, -0.099999);
        TextDrawColor(Textdraw[15], -1);
        TextDrawSetOutline(Textdraw[15], 0);
        TextDrawSetProportional(Textdraw[15], 1);
        TextDrawSetShadow(Textdraw[15], 1);
        TextDrawUseBox(Textdraw[15], 1);
        TextDrawBoxColor(Textdraw[15], 180);
        TextDrawTextSize(Textdraw[15], 387.000000, 2.000000);

        return true;
}
public OnPlayerConnect(playerid)
{
    Speed[playerid] = TextDrawCreate(441.000000, 362.000000, "000");
    TextDrawAlignment(Speed[playerid], 3);
    TextDrawBackgroundColor(Speed[playerid], -16776961);
    TextDrawFont(Speed[playerid], 3);
    TextDrawLetterSize(Speed[playerid], 0.740000, 4.299999);
    TextDrawColor(Speed[playerid], 255);
    TextDrawSetOutline(Speed[playerid], 1);
    TextDrawSetProportional(Speed[playerid], 1);
    return true;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER && Speedo[playerid] == 1) ShowTD(playerid);
    if(oldstate == PLAYER_STATE_DRIVER && Speedo[playerid] == 1) HideTD(playerid);
    return true;
}
public OnPlayerUpdate(playerid)
{
        foreach(Player, i)
        {
            if(IsPlayerInAnyVehicle(i) && Speedo[i] != 0)
            {
                new Float:SPD, Float:vx, Float:vy, Float:vz;
                GetVehicleVelocity(GetPlayerVehicleID(i), vx,vy,vz);
                SPD = floatsqroot(((vx*vx)+(vy*vy))+(vz*vz))*100;
                TextdrawUpdate(i, SPD*2);
            }
        }
        return true;
}
CMD:speedo(playerid, params[])
{
    if(Speedo[playerid] == 0) {
        SendClientMessage(playerid, 0xFFFFFFFF, "Состояние спидометра: {00FF00}Активираванно");
        Speedo[playerid] = 1;
        if(IsPlayerInAnyVehicle(playerid)) ShowTD(playerid);
    } else {
        SendClientMessage(playerid, 0xFFFFFFFF, "Состояние спидометра: {FF0000}ДеАктивированно.");
        Speedo[playerid] = 0;
        HideTD(playerid);
    }
    return true;
}
script TextdrawUpdate(playerid, Float:speed)
{
        new SS[4];
        format(SS,4,"%f",speed);
        TextDrawSetString(Speed[playerid], SS);
        if(speed >= 10) { TextDrawShowForPlayer(playerid, Textdraw[1]); }
        else TextDrawHideForPlayer(playerid, Textdraw[1]);
        if(speed >= 30) { TextDrawShowForPlayer(playerid, Textdraw[2]); }
        else TextDrawHideForPlayer(playerid, Textdraw[2]);
        if(speed >= 50) { TextDrawShowForPlayer(playerid, Textdraw[3]); }
        else TextDrawHideForPlayer(playerid, Textdraw[3]);
        if(speed >= 70) { TextDrawShowForPlayer(playerid, Textdraw[4]); }
        else TextDrawHideForPlayer(playerid, Textdraw[4]);
        if(speed >= 90) { TextDrawShowForPlayer(playerid, Textdraw[5]); }
        else TextDrawHideForPlayer(playerid, Textdraw[5]);
        if(speed >= 110) { TextDrawShowForPlayer(playerid, Textdraw[6]); }
        else TextDrawHideForPlayer(playerid, Textdraw[6]);
        if(speed >= 130) { TextDrawShowForPlayer(playerid, Textdraw[7]); }
        else TextDrawHideForPlayer(playerid, Textdraw[7]);
        if(speed >= 150) { TextDrawShowForPlayer(playerid, Textdraw[8]); }
        else TextDrawHideForPlayer(playerid, Textdraw[8]);
        if(speed >= 170) { TextDrawShowForPlayer(playerid, Textdraw[9]); }
        else TextDrawHideForPlayer(playerid, Textdraw[9]);
        if(speed >= 180) { TextDrawShowForPlayer(playerid, Textdraw[10]); }
        else TextDrawHideForPlayer(playerid, Textdraw[10]);
        if(speed >= 200) { TextDrawShowForPlayer(playerid, Textdraw[11]); }
        else TextDrawHideForPlayer(playerid, Textdraw[11]);
        return true;
}
script ShowTD(playerid)
{
        TextDrawShowForPlayer(playerid, Textdraw[0]);
        TextDrawShowForPlayer(playerid, Speed[playerid]);
        TextDrawShowForPlayer(playerid, Textdraw[13]);
        TextDrawShowForPlayer(playerid, Textdraw[14]);
        TextDrawShowForPlayer(playerid, Textdraw[15]);
        return true;
}
script HideTD(playerid)
{
        TextDrawHideForPlayer(playerid, Textdraw[0]);
        TextDrawHideForPlayer(playerid, Speed[playerid]);
        TextDrawHideForPlayer(playerid, Textdraw[13]);
        TextDrawHideForPlayer(playerid, Textdraw[14]);
        TextDrawHideForPlayer(playerid, Textdraw[15]);
        TextDrawHideForPlayer(playerid, Textdraw[1]);
        TextDrawHideForPlayer(playerid, Textdraw[2]);
        TextDrawHideForPlayer(playerid, Textdraw[3]);
        TextDrawHideForPlayer(playerid, Textdraw[4]);
        TextDrawHideForPlayer(playerid, Textdraw[5]);
        TextDrawHideForPlayer(playerid, Textdraw[6]);
        TextDrawHideForPlayer(playerid, Textdraw[7]);
        TextDrawHideForPlayer(playerid, Textdraw[8]);
        TextDrawHideForPlayer(playerid, Textdraw[9]);
        TextDrawHideForPlayer(playerid, Textdraw[10]);
        TextDrawHideForPlayer(playerid, Textdraw[11]);
        return true;
}
