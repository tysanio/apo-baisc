<?php

require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/header.php";

// =====================================
// Load Player Options
// =====================================

$stmt = $pdo->prepare(" SELECT * FROM players_options WHERE Username = ? LIMIT 1");
$stmt->execute([ $player["Username"] ]);
$options = $stmt->fetch(PDO::FETCH_ASSOC);

?>

<div class="card">

<h2>🏆 Achievements</h2>

<?php

if(!$options) echo "<p>No achievement data found.</p>";
else
{
    $skillNames =
    [
        "Pistol Skill",
        "Silenced Pistol Skill",
        "Desert Eagle Skill",
        "Shotgun Skill",
        "Sawn-off Shotgun Skill",
        "Spas 12 Skill",
        "Uzi Skill",
        "MP5 Skill",
        "AK47 Skill",
        "M4 Skill",
        "Sniper Rifle Skill"
    ];
?>

<table class="inventory-table">

<tr>
    <th>Skill</th>
    <th>Progress</th>
</tr>

<?php

for($i = 0; $i <= 10; $i++)
{
    $skill = "pSkill".$i;
    $value = isset($options[$skill]) ? (int)$options[$skill] : 0;
    $value = max(0, min(1000, $value));
    $percent = ($value / 1000) * 100;
    $barClass = "danger";
    if($percent >= 70) $barClass = "normal";
    elseif($percent >= 40) $barClass = "warning";
?>

<tr>
    <td> <strong><?php echo $skillNames[$i]; ?></strong> </td>
    <td>
        <div class="item-progress">
            
            <div class="item-bar">
                <div
                    class="item-fill <?php echo $barClass; ?>"
                    style="width:<?php echo $percent; ?>%;">
                </div>
            </div>
            <div class="item-count">  <?php echo $value; ?>
            </div>
        </div>
    </td>
</tr>

<?php
}
?>

</table>
<br>

<h2>🏅 Achievements</h2>

<?php

$achievementNames =
[
    "First Blood",
    "Zombie Hunter",
    "Craft a vehicle",
    "Your first house",
    "Visiting new place",
    "Lockpick something",
    "How do you get there",
    "Level Up",
    "Too much exp",
    "None"
];

?>

<table class="inventory-table">

<tr>
    <th>Achievement</th>
    <th>Status</th>
</tr>

<?php

for($i = 0; $i <= 9; $i++)
{
    $achievement = "pAchievements".$i;

    $unlocked = isset($options[$achievement]) ? (int)$options[$achievement] : 0;

?>

<tr>

    <td>

        <?php echo $achievementNames[$i]; ?>

    </td>

    <td>

        <?php

        if($unlocked == 1)
        {
            echo "✅ Yes";
        }
        else
        {
            echo "❌ No";
        }

        ?>

    </td>

</tr>

<?php
}
?>

</table>
<?php
}
?>

</div>

<?php

require_once "includes/footer.php";

?>