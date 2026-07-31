<?php

require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/header.php";
require_once "includes/discord_check.php";
?>
<div class="card">

    <h2>
        Welcome back <?php echo htmlspecialchars($player["Username"]); ?> !
    </h2>

    <br>

    <div class="info">
        <strong>Account ID:</strong>
        <?php echo $player["ID"]; ?>
    </div>

    <div class="info">
        <strong>Admin Level:</strong>
        <?php echo $player["Admin"]; ?>
    </div>

    <div class="info">
        <strong>VIP Level:</strong>
        <?php echo $player["VIP"]; ?>
    </div>
    <div class="info">
        <strong>🏆 If you want to be a VIP or Admin ask on discord!</strong>
    </div>
<div class="card">


<h2> 💬 Discord Status </h2>
<?php
	if(empty($player["discordid"]))
	{
?>
	<p> ❌ Not Linked </p>

	<a href="discord.php"> <button class="action-button success-button"> 🔗 Link Discord </button> </a>
	<?php
	}
	else
	{
		if(CheckDiscordRole($player["discordid"]))
		{
	?>
		<p> ✅ Linked </p>
		<p> Your Discord account is verified with the UCP-Check role. </p>
		<?php
		}
		else
		{
		?>
		<p> ⚠️ Discord linked but not verified </p>
		<p> Please make sure you joined the Discord server. </p>
		<?php
		}
	}
	?>
	</div>
</div>

<?php
require_once "includes/footer.php";
?>