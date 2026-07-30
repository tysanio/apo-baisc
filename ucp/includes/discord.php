<?php

function DiscordWebhook($title, $message)
{
    global $DISCORD_WEBHOOK;
    if(empty($DISCORD_WEBHOOK))
    {
        return false;
    }
    $payload = [
        "username" => "UCP",
        "embeds" => [
            [
                "title" => $title,
                "description" => $message,
                "color" => 3447003,
                "timestamp" => date("c")

            ]

        ]

    ];



    $ch = curl_init($DISCORD_WEBHOOK);


    curl_setopt($ch, CURLOPT_POST, true);

    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));

    curl_setopt($ch, CURLOPT_HTTPHEADER, [

        "Content-Type: application/json"

    ]);

    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);



    curl_exec($ch);

    curl_close($ch);


    return true;
}

?>