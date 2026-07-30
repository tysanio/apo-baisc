<?php

session_start();

require_once "config/database.php";

// Only allow POST requests
if ($_SERVER["REQUEST_METHOD"] != "POST")
{
    header("Location: index.php");
    exit;
}

$username = trim($_POST["username"] ?? "");
$password = $_POST["password"] ?? "";

// Check for empty fields
if ($username == "" || $password == "")
{
    header("Location: index.php?error=1");
    exit;
}

// Hash the password with Whirlpool
$passwordHash = hash("whirlpool", $password);

// Search the account
$stmt = $pdo->prepare("SELECT id,username,admin,vip FROM players WHERE username = ?AND password = ?LIMIT 1 ");

$stmt->execute([
    $username,
    $passwordHash
]);

$user = $stmt->fetch();

if (!$user)
{
    header("Location: index.php?error=1");
    exit;
}

// Login successful
$_SESSION["userid"]   = $user["id"];

header("Location: dashboard.php");
exit;