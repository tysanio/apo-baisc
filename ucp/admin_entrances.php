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



// ==========================
// Pagination
// ==========================

$limit = 25;


$page = isset($_GET["page"]) ? (int)$_GET["page"] : 1;


if($page < 1)
{
    $page = 1;
}


$offset = ($page - 1) * $limit;



// Count Entrances

$count = $pdo->query(" SELECT COUNT(*)  FROM entrances ")->fetchColumn();


$totalPages = ceil($count / $limit);




// ==========================
// Load Entrances
// ==========================

$stmt = $pdo->prepare("SELECT * FROM entrances ORDER BY entranceID ASC LIMIT ? OFFSET ? ");



$stmt->bindValue(1, $limit, PDO::PARAM_INT);
$stmt->bindValue(2, $offset, PDO::PARAM_INT);


$stmt->execute();


$entrances = $stmt->fetchAll();

?>



<div class="card">

    <h2>
        🚪 Entrance Management
    </h2>


    <table class="admin-table">

        <tr>

            <th>ID</th>
            <th>Name</th>
            <th>Locked</th>

            <th>Exterior Position (XYZA)</th>

            <th>Interior Position (XYZA)</th>
			
            <th>Interior</th>
            <th>Exterior</th>

            <th>Exterior VW</th>
            <th>Interior VW</th>

        </tr>


        <?php

        foreach($entrances as $entrance)
        {

            $locked = ($entrance["entranceLocked"] == 1) ? "Yes" : "No";

            echo "

            <tr>
                <td>".$entrance["entranceID"]."</td>
                <td>".htmlspecialchars($entrance["entranceName"])."</td>
                <td>".$locked."</td>
                <td>  ".$entrance["entrancePosX"].",".$entrance["entrancePosY"].",".$entrance["entrancePosZ"].",".$entrance["entrancePosA"]."</td>
                <td> ".$entrance["entranceIntX"].",".$entrance["entranceIntY"].",".$entrance["entranceIntZ"].",".$entrance["entranceIntA"]."</td>
                <td>  ".$entrance["entranceInterior"]." </td>
                <td>  ".$entrance["entranceExterior"]." </td>
                <td>  ".$entrance["entranceExteriorVW"]." </td>
                <td>  ".$entrance["entranceWorld"]." </td>
            </tr>
            ";
        }
        ?>
    </table>

    <div class="pagination">

        <?php

        if($page > 1)
        {
            echo ' <a href="admin_entrances.php?page='.($page - 1).'"> ⬅ Previous</a> ';
        }
        for($i = 1; $i <= $totalPages; $i++)
        {

            if($i == $page)
            {
                echo ' <a class="active"> '.$i.' </a> ';
            }
            else
            {
                echo '  <a href="admin_entrances.php?page='.$i.'"> '.$i.' </a> ';
            }
        }
        if($page < $totalPages)
        {
            echo ' <a href="admin_entrances.php?page='.($page + 1).'"> Next ➡  </a> ';
        }
        ?>

    </div>

</div>

<?php

require_once "includes/footer.php";

?>