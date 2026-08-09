<?php

require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/header.php";
require_once "includes/discord.php";
// ==========================
// Reset Character
// ==========================

if(isset($_POST["reset_player"]))
{
    $stmt = $pdo->prepare(" UPDATE players SET
            Score = 0,inv1 = 0,inv2 = 0,inv3 = 0,inv4 = 0,inv5 = 0,inv6 = 0,inv7 = 0,inv8 = 0,inv9 = 0,
            inv10 = 0,inv11 = 0,inv12 = 0,inv13 = 0,inv14 = 0,inv15 = 0,inv16 = 0,inv17 = 0,inv18 = 0,inv19 = 0,
            inv20 = 0,inv21 = 0,inv22 = 0,inv23 = 0,inv24 = 0,inv25 = 0,
            clanexp0 = 0,clanexp1 = 0,clanexp2 = 0,clanexp3 = 0,clanexp4 = 0,
            Weap1 = 0,Weap2 = 0,Weap3 = 0,Weap4 = 0, Weap5 = 0,Weap6 = 0,Weap7 = 0,Weap8 = 0,Weap9 = 0,
            Weap10 = 0,Weap11 = 0,Weap12 = 0,AWeap1 = 0,AWeap2 = 0,AWeap3 = 0,AWeap4 = 0,AWeap5 = 0,AWeap6 = 0,AWeap7 = 0,AWeap8 = 0,AWeap9 = 0,
            AWeap10 = 0,AWeap11 = 0,AWeap12 = 0 WHERE Username = ? ");
    $stmt->execute([ $player["Username"] ]);

    $stmt = $pdo->prepare("
        UPDATE players_options SET
            pSkill0 = 0,pSkill1 = 0,pSkill2 = 0,pSkill3 = 0,pSkill4 = 0,pSkill5 = 0,pSkill6 = 0,pSkill7 = 0,pSkill8 = 0,pSkill9 = 0,pSkill10 = 0,
			pLog0 = 0,pLog1 = 0,pLog2 = 0,pLog3 = 0,pLog4 = 0,pLog5 = 0,pLog6 = 0,pLog7 = 0,pLog8 = 0,pLog9 = 0,
			pAchievements0 = 0,pAchievements1 = 0,pAchievements2 = 0,pAchievements3 = 0,pAchievements4 = 0,pAchievements5 = 0,pAchievements6 = 0,pAchievements7 = 0,pAchievements8 = 0,pAchievements9 = 0,pAchievements10 = 0 WHERE Username = ?
    ");
    $stmt->execute([
        $player["Username"]
    ]);
	DiscordWebhook( "🗑️ Character Reset", "**Player:** ".$player["Username"]);		
    header("Location: index.php?reset=1");
    exit;
}

$message = "";


if(isset($_POST["change_password"]))
{

    $oldPassword = $_POST["old_password"];
    $newPassword = $_POST["new_password"];
    $confirmPassword = $_POST["confirm_password"];


    // Check new passwords match
    if($newPassword != $confirmPassword)
    {
        $message = "New passwords do not match.";
    }
    else
    {
        // Whirlpool encryption
        $oldHash = strtoupper(hash("whirlpool", $oldPassword));
        // Check old password
		if($oldHash != $player["Password"])
		{
			echo "<pre>";
			echo "Entered password hash:\n";
			echo $oldHash;
			echo "\n\nDatabase password:\n";
			echo $player["Password"];
			echo "</pre>";
			exit;

		}
        else
        {
            $newHash = strtoupper(hash("whirlpool", $newPassword));
            $stmt = $pdo->prepare(" UPDATE players SET Password = ? WHERE id = ? ");
            $stmt->execute([
                $newHash,
                $_SESSION["userid"]
            ]);
            session_destroy();
            header("Location: index.php?password_changed=1");
            exit;
        }
    }
}

?>


<div class="card">

<h2>⚙️ Settings</h2>
<?php

if($message != "")
{
    echo "
    <div class='error'>
        ".$message."
    </div>
    ";
}

?>
<form method="POST">
<div class="info">
<label> Old Password</label>
<input type="password" name="old_password" required>
</div>
<div class="info">
<label> New Password </label>
<input type="password" name="new_password" required>
</div>
<div class="info">
<label>Confirm Password</label>
<input type="password" name="confirm_password" required>
</div>
<button type="submit" name="change_password"> Change Password </button>
</form>
</div>

<div class="card danger-card">
    <h2>⚠ Reset Character</h2>
    <p class="warning-text">
        <strong>Warning!</strong><br><br>
        Resetting your character will permanently erase:
        <ul>
			<li>Your level</li>
            <li>All inventory items</li>
            <li>All equipped weapons</li>
            <li>All weapon ammunition</li>
            <li>All clan experience</li>
            <li>All achievements</li>
            <li>All weapons skills</li>
            <li>All collectibles logs</li>
        </ul>
        <strong>This action cannot be undone.</strong>
    </p>
    <form method="POST"
          onsubmit="return confirm('Are you absolutely sure? This will permanently reset your character.');">
        <button  type="submit" name="reset_player" class="danger-button"> 🗑 Reset Character </button>

    </form>

</div>

<?php

require_once "includes/footer.php";

?>