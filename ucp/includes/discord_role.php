<?php


function AddDiscordRole($discordID, $roleID)
{

    global $DISCORD_GUILD_ID;
    global $DISCORD_BOT_TOKEN;


    $url = "https://discord.com/api/v10/guilds/"
        .$DISCORD_GUILD_ID.
        "/members/"
        .$discordID.
        "/roles/"
        .$roleID;



    $ch = curl_init($url);


    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");


    curl_setopt($ch, CURLOPT_HTTPHEADER, [

        "Authorization: Bot ".$DISCORD_BOT_TOKEN

    ]);


    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);


    curl_exec($ch);


    curl_close($ch);


    return true;

}

?>