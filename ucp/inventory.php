<?php

require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/functions.php";
require_once "includes/header.php";

$capacity = GetBackpackCapacity($player["Score"]);

$used = 0;

for($i = 1; $i <= 25; $i++)
{
    $column = "inv".$i;
    if($player[$column] >= 0)
    {
        $used += $player[$column];
    }
}
function GetItemName($id)
{
    switch($id)
    {
        case 1: return "Meat(s)";
        case 2: return "Wood(s)";
        case 3: return "Metal(s)";
        case 4: return "Cloth(s)";
        case 5: return "Plastic(s)";
        case 6: return "Gun Powder(s)";
        case 7: return "Ore(s)";
        case 8: return "Iron(s)";
        case 9: return "Gold(s)";
        case 10: return "Lockpick(s)";
		case 11: return "Repair kit(s)";
		case 12: return "Med Kit(s)";
		case 13: return "Jerrycan(s)";
		case 14: return "9mm Bullet(s)";
		case 15: return "00' Buck's";
		case 16: return ".308(s)";
		case 17: return "Armor Plate(s)";
		case 18: return "Water Bottle(s)";
		case 19: return "Canned Food";
		case 20: return "Seed(s)";
		case 21: return "Potato(es)";
		case 22: return "inv22";
		case 23: return "Tomato(es)";
		case 24: return "inv24";
		case 25: return "inv25";
        default: return "Unknown Item";
    }
}
?>
<div class="card">
<h2> 🎒 Inventory - Backpack Max Capacity: <?php echo $capacity; ?> </h2>
<table class="inventory-table">
<tr>
    <th>Item</th>
    <th>Amount</th>
</tr>

<?php

for($i = 1; $i <= 25; $i++)
{
    $column = "inv".$i;

    $amount = $player[$column] ?? 0;

    if($amount >= 0)
    {
        $max = $capacity;

        $percent = ($amount / $max) * 100;

        if($percent > 100)
        {
            $percent = 100;
        }
		$barColor = "normal";

		if($percent >= 90)
		{
			$barColor = "danger";
		}
		else if($percent >= 70)
		{
			$barColor = "warning";
		}
	echo "
		<tr>
			<td>
				".GetItemName($i)."
			</td>
			<td>
				<div class='item-progress'>
					<span class='item-count'>
						".$amount."
					</span>
				<div class='item-bar'>
					<div class='item-fill ".$barColor."' style='width:".$percent."%'>
					</div>
				</div>
				</div>
			</td>
		</tr>
		";
    }
}
?>
</table>
</div>
<?php
require_once "includes/footer.php";
?>