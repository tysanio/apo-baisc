<?php
function CheckDiscordRole($discordID)
{

    global $DISCORD_GUILD_ID;
    global $DISCORD_BOT_TOKEN;
    global $DISCORD_UCP_ROLE;
    if(empty($discordID))
    {
        return false;
    }
    $url = "https://discord.com/api/v10/guilds/"
        .$DISCORD_GUILD_ID.
        "/members/"
        .$discordID;

    $ch = curl_init($url);

    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Authorization: Bot ".$DISCORD_BOT_TOKEN
    ]);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($ch);
    curl_close($ch);
    $member = json_decode($response, true);
    if(!isset($member["roles"]))
    {
        return false;
    }
    if(in_array($DISCORD_UCP_ROLE, $member["roles"]))
    {
        return true;
    }
    return false;
}

?>