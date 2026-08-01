<?php

require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/header.php";

?>

<?php
$clan = null;
if($player["idclan"] > 0)
{
    $stmt = $pdo->prepare(" SELECT * FROM clans WHERE idclan = ? LIMIT 1 ");
    $stmt->execute([ $player["idclan"] ]);
    $clan = $stmt->fetch();
}
?>
<?php
$stmt = $pdo->prepare(" SELECT * FROM clans WHERE Owner = ? LIMIT 1");
$stmt->execute([ $player["Username"] ]);
$clanOwner = $stmt->fetch();
?>
<div class="card character-card">

    <div class="character-details">
        <h2>  👤 Character Info </h2>
        <p>
            <b>Name:</b>
            <?php echo htmlspecialchars($player["Username"]); ?>
        </p>
		<p>
            <b>Account ID:</b>
            <?php echo $player["ID"]; ?>
		</p>
        <p>
            <b>Admin Level:</b>
            <?php echo $player["Admin"]; ?>
        </p>
        <p>
            <b>VIP Level:</b>
            <?php echo $player["VIP"]; ?>
        </p>
		<p>
			<b>Clan ID Database:</b>
			<?php echo $player["idclan"]; ?>
		</p>
		<p>
			<b>Clan Name:</b>
			<?php
				if($clan)
				{
					echo htmlspecialchars($clan["clanname"]);
				}
				else
				{
					echo "No Clan";
				}
			?>
		</p>
		<p>
			<b>Clan Leader:</b>
			<?php
				if($clanOwner)
				{
					echo "Yes";
				}
				else
				{
					echo "No";
				}
			?>
		</p>
		<p>
			<b>Clan Rank:</b>
			<?php
				if($clan)
				{
					echo $player["clanrank"];
				}
				else
				{
					echo "-";
				}
			?>
		</p>
    </div>
    <div class="character-skin">
        <img src="https://gtaundergroundmod.com/resources/media/skins/<?php echo $player["skin"]; ?>.png">
    </div>
</div>

<?php

require_once "includes/footer.php";

?>