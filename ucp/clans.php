<?php

require_once "includes/auth.php";
require_once "includes/player.php";

require_once "includes/header.php";

if($player["idclan"] == 0)
{

?>
<div class="card">
    <h2> 🏰 Clan Information </h2>
    <p> You are not currently in a clan. </p>
</div>

<?php
require_once "includes/footer.php";
exit;

}
$stmt = $pdo->prepare("SELECT * FROM clans WHERE idclan = ? ");
$stmt->execute([$player["idclan"] ]);
$clan = $stmt->fetch();
if(!$clan)
{
    echo "Clan not found.";
    exit;
}
$stmt = $pdo->prepare(" SELECT Username, clanrank FROM players WHERE idclan = ? ORDER BY ClanRank DESC, Username ASC ");
$stmt->execute([ $clan["idclan"] ]);
$members = $stmt->fetchAll();


?>

<div class="card">
    <h2> 🏰 Clan Information </h2>
    <table class="info-table">
        <tr>
            <th> Clan ID
            </th>
            <td>
                <?php echo $clan["idclan"]; ?>
            </td>
        </tr>
        <tr>
            <th>
                Clan Name
            </th>
            <td>
                <?php echo htmlspecialchars($clan["clanname"]); ?>
            </td>
        </tr>
        <tr>
            <th>
                Owner
            </th>
            <td>
                <?php echo htmlspecialchars($clan["Owner"]); ?>
            </td>
        </tr>
        <tr>
            <th>
                Maximum Rank
            </th>
            <td>
                <?php echo $clan["maxrank"]; ?>
            </td>
        </tr>
    </table>
    <div class="position-grid">
        <div class="position-card">
            <h3>  🚪 Entrance Position </h3>
            <div class="coord">
				<div class="coord">
					<strong>X</strong> <?php echo $clan["enterposx"]; ?>
					&nbsp;&nbsp;&nbsp;
					<strong>Y</strong> <?php echo $clan["enterposy"]; ?>
					&nbsp;&nbsp;&nbsp;
					<strong>Z</strong> <?php echo $clan["enterposz"]; ?>
				</div>
            </div>
        </div>
        <div class="position-card">
            <h3> 📦 Chest Position </h3>
            <div class="coord">
				<div class="coord">
					<strong>X</strong> <?php echo $clan["chestposx"]; ?>
					&nbsp;&nbsp;&nbsp;
					<strong>Y</strong> <?php echo $clan["chestposy"]; ?>
					&nbsp;&nbsp;&nbsp;
					<strong>Z</strong> <?php echo $clan["chestposz"]; ?>
				</div>
            </div>
        </div>
    </div>
</div>

<div class="card">

    <h2> 👥 Clan Members </h2>
    <div class="member-list">
    <?php
    if(count($members) == 0)
    {	
		echo " No members found. ";
    }
    else
    {
        foreach($members as $member)
        {
            echo "
            <div class='member-box'>
                <strong>
                    ".htmlspecialchars($member["Username"])."
                </strong>
                <br>
                Rank: ".$member["clanrank"]."
            </div>
            ";
        }
    }
    ?>
    </div>
</div>

<?php

require_once "includes/footer.php";

?>