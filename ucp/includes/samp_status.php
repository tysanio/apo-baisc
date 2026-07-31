<?php

function GetSAMPStatus($ip, $port)
{
    $socket = fsockopen("udp://".$ip, $port, $errno, $errstr, 2);

    if(!$socket)
    {
        return [
            "online" => false,
            "players" => 0,
            "maxplayers" => 0
        ];
    }


    stream_set_timeout($socket, 2);


    // SA-MP info query
    $packet = "SAMP";

    $parts = explode(".", $ip);

    foreach($parts as $part)
    {
        $packet .= chr($part);
    }

    $packet .= chr($port & 0xFF);
    $packet .= chr($port >> 8);

    $packet .= "i";


    fwrite($socket, $packet);


    $response = fread($socket, 2048);

    fclose($socket);


    if(!$response)
    {
        return [
            "online" => false,
            "players" => 0,
            "maxplayers" => 0
        ];
    }


    // Read player count
    $players = ord($response[13]);

    // Read max players
    $maxplayers = ord($response[14]);


    return [
        "online" => true,
        "players" => $players,
        "maxplayers" => $maxplayers
    ];

}

?>