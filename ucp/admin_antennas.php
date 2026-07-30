<?php

require_once "includes/auth.php";
require_once "includes/player.php";


// Admin only

if($player["Admin"] < 1)
{
    header("Location: dashboard.php");
    exit;
}
require_once "includes/header.php";
$limit = 25;
$page = isset($_GET["page"]) ? (int)$_GET["page"] : 1;

if($page < 1)
{
    $page = 1;
}
$offset = ($page - 1) * $limit;
$count = $pdo->query(" SELECT COUNT(*) FROM antennas ")->fetchColumn();
$totalPages = ceil($count / $limit);

$stmt = $pdo->prepare(" SELECT * FROM antennas ORDER BY id ASC LIMIT ? OFFSET ? ");
$stmt->bindValue(1, $limit, PDO::PARAM_INT);
$stmt->bindValue(2, $offset, PDO::PARAM_INT);
$stmt->execute();
$antennas = $stmt->fetchAll();
?>
<div class="card">


<h2> 📡 Antenna Management </h2>
<table class="admin-table">
<tr>
<th>ID</th>
<th>X</th>
<th>Y</th>
<th>Z</th>
<th>Health</th>
<th>Fuel</th>
<th>Power</th>
<th>Type</th>

</tr>
<?php


foreach($antennas as $antenna)
{
    if($antenna["powered"] == 1)
    {
        $power = "Online";
    }
    else
    {
        $power = "Offline";
    }
    switch($antenna["type"])
    {
        case 0:
            $type = "Small Range";
            break;
        case 1:
            $type = "Medium Range";
            break;

        case 2:
            $type = "Large Range";
            break;
        default:
            $type = "Unknown";
            break;
    }
    echo "
    <tr>

        <td> ".$antenna["id"]." </td>
        <td> ".$antenna["x"]." </td> 
        <td> ".$antenna["y"]." </td>
        <td> ".$antenna["z"]." </td>
        <td> ".$antenna["health"]." </td>
        <td> ".$antenna["fuel"]." </td>
        <td> ".$power." </td>
        <td> ".$type." </td>
    </tr>
    ";
}
?>
</table>
<div class="pagination">

<?php
if($page > 1)
{
echo ' <a href="admin_antennas.php?page='.($page - 1).'"> ⬅ Previous </a> ';
}
for($i = 1; $i <= $totalPages; $i++)
{

    if($i == $page)
    {
        echo ' <a class="active"> '.$i.'</a> ';
    }
    else
    {
        echo ' <a href="admin_antennas.php?page='.$i.'"> '.$i.' </a>';
    }
}
if($page < $totalPages)
{
	echo ' <a href="admin_antennas.php?page='.($page + 1).'"> Next ➡ </a> ';
}
?>
</div>
</div>
<?php

require_once "includes/footer.php";

?>