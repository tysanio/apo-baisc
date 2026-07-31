<?php

require_once "includes/auth.php";
require_once "includes/player.php";
require_once "config/database.php";
require_once "includes/header.php";
require_once "includes/discord.php";
if($player["Admin"] < 2)
{
    echo '
    <div class="card error-box">
        <h2>🚫 Access Denied</h2>
        <p>You do not have permission to access this page.</p>
    </div>';

    require_once "includes/footer.php";
    exit;
}
require_once "includes/header.php";
$message = "";
$error = "";
if(isset($_POST["update_player"]))
{
    $username = trim($_POST["username"]);
    $type = $_POST["type"];
    $value = (int)$_POST["value"];
	if($type == "VIP") { $value = max(0, min(3, $value)); }
	if($type == "Admin") { $value = max(0, min(3, $value)); }
	if($type == "food") { $value = max(0, min(100, $value)); }
	if($type == "water") { $value = max(0, min(100, $value)); }
	if($type == "Life") { $value = max(0, min(100, $value)); }
	if($type == "Armor") { $value = max(0, min(100, $value)); }
    if($type != "Admin" && $type != "VIP" && $type != "Score" && $type != "idclan" && $type != "clanrank" && $type != "Life" && $type != "Armor" && $type != "food" && $type != "water")
    {
        $error = "Invalid selection.";
    }
    else
    {
        $stmt = $pdo->prepare("SELECT Username FROM players WHERE Username = ?");
        $stmt->execute([$username]);

		if($stmt->rowCount() == 0)
		{
			$error = '
			<div class="card error-box">
				<h2>❌ Player Not Found!</h2>
				<p style="text-align:center;font-size:16px;">
					The username <strong>'.$username.'</strong> could not be found in the database.
				</p>
			</div>';
		}
        else
        {
			if($type == "VIP")
			{
				$value = max(0, min(3, $value));
				$stmt = $pdo->prepare(" UPDATE players SET VIP = ? WHERE Username = ? ");
				$stmt->execute([$value,$username ]);
				if($value == 1) { $bonus = 25; }
				elseif($value == 2) { $bonus = 50; }
				elseif($value == 3) { $bonus = 100; }
				else { $bonus = 0; }
				if($bonus > 0)
				{
				$stmt = $pdo->prepare(" UPDATE players SET  inv1 = inv1 + ?, inv2 = inv2 + ?,
					inv3 = inv3 + ?,inv4 = inv4 + ?,inv5 = inv5 + ?,inv6 = inv6 + ?,inv7 = inv7 + ?,inv8 = inv8 + ?,
					inv9 = inv9 + ?,inv10 = inv10 + ?,inv11 = inv11 + ?,inv12 = inv12 + ?,inv13 = inv13 + ?,inv14 = inv14 + ?,
					inv15 = inv15 + ?,inv16 = inv16 + ?,inv17 = inv17 + ?,inv18 = inv18 + ?,inv19 = inv19 + ?,inv20 = inv20 + ?,
					inv21 = inv21 + ?,inv22 = inv22 + ?,inv23 = inv23 + ?,inv24 = inv24 + ?,inv25 = inv25 + ?
					WHERE Username = ? ");
				$stmt->execute(array_merge( array_fill(0,25,$bonus), [$username] ));
				$stmt = $pdo->prepare("
					UPDATE players SET clanexp0 = clanexp0 + ?,clanexp1 = clanexp1 + ?,clanexp2 = clanexp2 + ?,clanexp3 = clanexp3 + ?,clanexp4 = clanexp4 + ?
					WHERE Username = ? ");
				$stmt->execute([ $bonus,$bonus,$bonus,$bonus,$bonus, $username ]);
				}
			}
	elseif($type == "Admin")
	{
		$value = max(0, min(3, $value));
		$stmt = $pdo->prepare(" UPDATE players SET Admin = ? WHERE Username = ?  ");
		$stmt->execute([ $value, $username]);
	}
	elseif($type == "Life")
	{
		$value = max(0, min(100, $value));
		$stmt = $pdo->prepare(" UPDATE players SET Life = ? WHERE Username = ?  ");
		$stmt->execute([ $value, $username]);
	}
	elseif($type == "Armor")
	{
		$value = max(0, min(100, $value));
		$stmt = $pdo->prepare(" UPDATE players SET Armor = ? WHERE Username = ?  ");
		$stmt->execute([ $value, $username]);
	}
	elseif($type == "water")
	{
		$value = max(0, min(100, $value));
		$stmt = $pdo->prepare(" UPDATE players SET water = ? WHERE Username = ?  ");
		$stmt->execute([ $value, $username]);
	}
	elseif($type == "food")
	{
		$value = max(0, min(100, $value));
		$stmt = $pdo->prepare(" UPDATE players SET food = ? WHERE Username = ?  ");
		$stmt->execute([ $value, $username]);
	}
// ==============================
// NORMAL UPDATES
// ==============================
	else
	{
		$stmt = $pdo->prepare(" UPDATE players SET {$type} = ? WHERE Username = ? ");
		$stmt->execute([$value,$username]);
	}

            DiscordWebhook(
                "🛠️ Player Updated",
                "**Admin:** ".$player["Username"].
                "\n**Player:** ".$username.
                "\n**Field:** ".$type.
                "\n**New Value:** ".$value
            );
            $message = '
			<div class="card success-box">
				<h2>🎉 Player Updated!</h2>
			<div class="info">
				<strong>👤 Player</strong> '.$username.'
			</div>

			<div class="info">
				<strong>📋 Modified</strong> '.$type.'
			</div>
			<div class="info">
				<strong>🔢 New Value</strong> '.$value.'
			</div>
		<br>
		</div>';
        }
    }
}
?>
<div class="card">
<h2>🛠️ Admin Tools</h2>

<?php
if($message != "")
{
    echo $message;
}

if($error != "")
{
    echo $error;
}
?>

<form method="POST">

<label>👤 Username</label>
<input type="text" name="username" required>

<br><br>

<label>📋 Change</label>

<select name="type" required>
    <option value="Admin">🛡️ Admin Level</option>
    <option value="VIP">💎 VIP Level</option>
	<option value="Score">⭐ Level</option>
    <option value="idclan">🏰 Clan</option>
    <option value="clanrank">👑 Clan Rank</option>
    <option value="Life">❤️ Health</option>
    <option value="Armor">🦺 Armor</option>
	<option value="food">🍗 Hunger</option>
    <option value="water">💧 Thirst</option>
	
</select>

<br><br>

<label>🔢 New Value</label>
<input type="number" name="value" min="0" max="999" required>

<br><br>

<button type="submit" name="update_player" class="action-button success-button"> 💾 Update Player </button>

</form>

</div>
<?php
require_once "includes/footer.php";
?>