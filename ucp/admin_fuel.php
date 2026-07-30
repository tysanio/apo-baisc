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

$count = $pdo->query(" SELECT COUNT(*) FROM fuel_stations ")->fetchColumn();

$totalPages = ceil($count / $limit);
$stmt = $pdo->prepare(" SELECT * FROM fuel_stations ORDER BY id ASC LIMIT ? OFFSET ? ");

$stmt->bindValue(1, $limit, PDO::PARAM_INT);
$stmt->bindValue(2, $offset, PDO::PARAM_INT);

$stmt->execute();

$stations = $stmt->fetchAll();

?>
<div class="card">

    <h2>
        ⛽ Fuel Stations
    </h2>


    <table class="admin-table">

        <tr>

            <th>ID</th>
            <th>X</th>
            <th>Y</th>
            <th>Z</th>
            <th>Fuel Remaining Liters</th>
        </tr>
        <?php

        foreach($stations as $station)
        {
            echo "
            <tr>
                <td> ".$station["id"]." </td>
                <td> ".$station["pos_x"]." </td>
                <td> ".$station["pos_y"]." </td>
                <td> ".$station["pos_z"]." </td>
                <td> ".$station["stock"]." </td>
            </tr>
            ";
        }
        ?>
    </table>
    <div class="pagination">

        <?php
        if($page > 1)
        {
            echo ' <a href="admin_fuel.php?page='.($page - 1).'"> ⬅ Previous </a> ';
        }
        for($i = 1; $i <= $totalPages; $i++)
        {
            if($i == $page)
            {
                echo ' <a class="active"> '.$i.' </a> ';
            }
            else
            {
                echo ' <a href="admin_fuel.php?page='.$i.'"> '.$i.' </a> ';
            }
        }
        if($page < $totalPages)
        {
            echo ' <a href="admin_fuel.php?page='.($page + 1).'"> Next ➡ </a> ';
        }
        ?>
    </div>

</div>

<?php

require_once "includes/footer.php";

?>