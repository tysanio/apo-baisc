<?php

require_once __DIR__ . "/../config/database.php";

$stmt = $pdo->prepare("SELECT * FROM players WHERE id = ?  LIMIT 1 ");

$stmt->execute([
    $_SESSION["userid"]
]);

$player = $stmt->fetch();

if (!$player)
{
    session_destroy();
    header("Location: index.php");
    exit;
}