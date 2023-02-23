GetPlayerFPS(playerid) {
    new playerDrunkLevel = GetPlayerDrunkLevel(playerid);

    if(playerDrunkLevel < 100)
    {
        SetPlayerDrunkLevel(playerid, 2000);
    }
    else
    {
        if(lastDrunkLevel[playerid] != playerDrunkLevel)
        {
            currFPS[playerid] = (lastDrunkLevel[playerid] - playerDrunkLevel);

            lastDrunkLevel[playerid] = playerDrunkLevel;
            if((currFPS[playerid] > 0) && (currFPS[playerid] < 256))
            {
                return currFPS[playerid] - 1;
            }
        }
    }
    return 0;
}


// more utilitys here https://github.com/PatrickGTR/gta-open/blob/master/gamemodes/utils/utils_player.inc
