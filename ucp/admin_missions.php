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
// Add Mission
// ==========================

if(isset($_POST["add_mission"]))
{
    $x = $_POST["x"];
    $y = $_POST["y"];
    $z = $_POST["z"];

    $stmt = $pdo->prepare("
        INSERT INTO missions (x, y, z) VALUES (?, ?, ?)
    ");
    $stmt->execute([ $x,$y,$z ]);
    header("Location: admin_missions.php");
    exit;
}
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
// Count missions
$count = $pdo->query(" SELECT COUNT(*) FROM missions ")->fetchColumn();
$totalPages = ceil($count / $limit);
// ==========================
// Load Missions
// ==========================
$stmt = $pdo->prepare(" SELECT * FROM missions ORDER BY id ASC LIMIT ? OFFSET ? ");
$stmt->bindValue(1, $limit, PDO::PARAM_INT);
$stmt->bindValue(2, $offset, PDO::PARAM_INT);

$stmt->execute();

$missions = $stmt->fetchAll();

?>
<div class="card">

    <h2>📍 Mission Spawn Positions</h2>

    <table class="admin-table">

        <tr>
            <th>ID</th>
            <th>X</th>
            <th>Y</th>
            <th>Z</th>
        </tr>

        <?php foreach($missions as $mission) { ?>

        <tr>

            <td><?php echo $mission["id"]; ?></td>

            <td><?php echo $mission["x"]; ?></td>

            <td><?php echo $mission["y"]; ?></td>

            <td><?php echo $mission["z"]; ?></td>
        </tr>
        <?php } ?>
    </table>
    <div class="pagination">
        <?php if($page > 1) { ?>

            <a href="admin_missions.php?page=<?php echo $page - 1; ?>">
                ⬅ Previous
            </a>
        <?php } ?>
        <?php
        for($i = 1; $i <= $totalPages; $i++)
        {
            if($i == $page)
            {
                echo '<a class="active">'.$i.'</a>';
            }
            else
            {
                echo '<a href="admin_missions.php?page='.$i.'">'.$i.'</a>';
            }
        }
        ?>
        <?php if($page < $totalPages) { ?>
            <a href="admin_missions.php?page=<?php echo $page + 1; ?>"> Next ➡ </a>
        <?php } ?>
    </div>
</div>

<div class="card">
    <h2>➕ Add Mission Spawn</h2>
    <form method="POST">
        <div class="position-row">
            <div class="info">
                <label>X Position</label>
                <input type="text" name="x" required>
            </div>
            <div class="info">
                <label>Y Position</label>
                <input type="text" name="y" required>
            </div>
            <div class="info">
                <label>Z Position</label>
                <input type="text"name="z" required>
            </div>
        </div>
        <br>
		<button type="submit" name="add_mission"> ➕ Add Mission </button>

    </form>

</div>
<?php

require_once "includes/footer.php";

?>