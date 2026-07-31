<?php
require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/header.php";

require_once "config/database.php";
require_once "includes/discord_role.php";
require_once "includes/discord.php";

// Check if Discord returned a code

if(!isset($_GET["code"]))
{
    die("Discord authorization failed.");
}


$code = $_GET["code"];


// Exchange code for access token

$data = [
    "client_id" => $DISCORD_CLIENT_ID,
    "client_secret" => $DISCORD_CLIENT_SECRET,
    "grant_type" => "authorization_code",
    "code" => $code,
    "redirect_uri" => $DISCORD_REDIRECT
];


$ch = curl_init("https://discord.com/api/oauth2/token");


curl_setopt($ch, CURLOPT_POST, true);

curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));

curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "Content-Type: application/x-www-form-urlencoded"
]);

curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);


$response = curl_exec($ch);

curl_close($ch);



$token = json_decode($response, true);



if(!isset($token["access_token"]))
{
    die("Could not connect Discord.");
}

// Get Discord user information

$ch = curl_init("https://discord.com/api/users/@me");


curl_setopt($ch, CURLOPT_HTTPHEADER, [

    "Authorization: Bearer ".$token["access_token"]

]);


curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);


$user = curl_exec($ch);


curl_close($ch);



$discord = json_decode($user, true);



$discordID = $discord["id"];

// Save Discord ID to player account
$stmt = $pdo->prepare("
    UPDATE players SET discordid = ? WHERE Username = ?
");


$stmt->execute([

    $discordID,

    $player["Username"]
]);
AddDiscordRole(
    $discordID,
    $DISCORD_UCP_ROLE
);
DiscordWebhook(

    "🔗 UCP-Discord Linked",

    "**Player:** ".$player["Username"]."\n".
    "**Discord ID:** ".$discordID."\n\n".
    "✅ Double check UCP-Discord done!"

);
echo ' <div class="card success-box"> 
<h2> ✅ Discord Linked Successfully </h2>

<p> Your Discord account has been successfully linked with the UCP. </p>

<p> 🛡️ Discord UCP role assigned successfully. </p>

<p> 📡 Discord notification sent. </p>

</div>';
exit;
// Return to dashboard

header("Location: dashboard.php");

exit;

?>