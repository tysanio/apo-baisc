<?php

require_once "includes/auth.php";
require_once "includes/player.php";

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
$count = $pdo->query(" SELECT COUNT(*)  FROM missions ")->fetchColumn();

$totalPages = ceil($count / $limit);
// ==========================
// Load Missions
// ==========================

$stmt = $pdo->prepare(" SELECT * FROM missions ORDER BY id ASC LIMIT ? OFFSET ?");
$stmt->bindValue(1, $limit, PDO::PARAM_INT);
$stmt->bindValue(2, $offset, PDO::PARAM_INT);


$stmt->execute();


$missions = $stmt->fetchAll();

?>

<div class="card">

    <h2> 📍 Mission Spawn Positions </h2>
    <table class="admin-table">
        <tr>
            <th>ID</th>
            <th>X</th>
            <th>Y</th>
            <th>Z</th>
        </tr>
        <?php
        foreach($missions as $mission)
        {
            echo "
            <tr>
                <td> ".$mission["id"]." </td>
                <td> ".$mission["x"]." </td>
                <td> ".$mission["y"]." </td>
                <td>  ".$mission["z"]." </td>
            </tr>
            ";
        }
        ?>
    </table>
    <div class="pagination">
        <?php
        if($page > 1)
        {
            echo ' <a href="admin_missions.php?page='.($page - 1).'"> ⬅ Previous </a> ';
        }
        for($i = 1; $i <= $totalPages; $i++)
        {

            if($i == $page)
            {
                echo ' <a class="active">'.$i.'</a> ';
            }
            else
            {
                echo ' <a href="admin_missions.php?page='.$i.'"> '.$i.' </a> ';
            }
        }
        if($page < $totalPages)
        {
            echo ' <a href="admin_missions.php?page='.($page + 1).'"> Next ➡  </a>';
        }
        ?>
    </div>
</div>
<?php
require_once "includes/footer.php";
?>