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

$DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1532483558780833924/rfq0SfuVdpy6cCgguRXKLBKTmqY6aah6u9WNsPp51nd7f9OVIefZUhw3zTmctp-ANZVG";


$SERVER_NAME = "Your Apocalypse Server";