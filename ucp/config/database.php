<?php

$DB_HOST = "localhost";
$DB_NAME = "apo";
$DB_USER = "root";
$DB_PASS = "";

try
{
    $pdo = new PDO(
        "mysql:host={$DB_HOST};dbname={$DB_NAME};charset=utf8mb4",
        $DB_USER,
        $DB_PASS
    );

    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
}
catch(PDOException $e)
{
    die("Database connection failed.");
}

$DISCORD_WEBHOOK = "";

$DISCORD_CLIENT_ID = "";

$DISCORD_CLIENT_SECRET = "";

$DISCORD_REDIRECT = "http://localhost/ucp/discord_callback.php";

$DISCORD_GUILD_ID = "";

$DISCORD_UCP_ROLE = "";
$DISCORD_ADMIN = "";

$DISCORD_BOT_TOKEN = "";

$SERVER_NAME = "Your Apocalypse Server";

$SERVER_IP = "127.0.0.1";
$SERVER_PORT = 7777;