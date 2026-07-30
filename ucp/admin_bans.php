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

if(isset($_POST["revoke_ban"]))
{
    $id = (int)$_POST["ban_id"];
    $stmt = $pdo->prepare(" DELETE FROM bans WHERE id = ? ");
    $stmt->execute([$id]);
    header("Location: admin_bans.php?page=".$page);
    exit;
}
$offset = ($page - 1) * $limit;
// Count bans
$count = $pdo->query(" SELECT COUNT(*) FROM bans ")->fetchColumn();

$totalPages = ceil($count / $limit);

// ==========================
// Load bans
// ==========================

$stmt = $pdo->prepare(" SELECT * FROM bans ORDER BY id DESC LIMIT ? OFFSET ? ");

$stmt->bindValue(1, $limit, PDO::PARAM_INT);
$stmt->bindValue(2, $offset, PDO::PARAM_INT);

$stmt->execute();

$bans = $stmt->fetchAll();

?>

<div class="card">
    <h2>  🚫 Ban Management </h2>
    <table class="admin-table">
        <tr>
            <th>ID</th>
            <th>Player</th>
            <th>Admin</th>
            <th>Reason</th>
            <th>Ban Date</th>
            <th>Expires</th>
            <th>Action</th>

        </tr>

        <?php

        foreach($bans as $ban)
        {

            $banDate = date("d/m/Y H:i:s", $ban["ban_time"]);

            if($ban["duration"] == 0)
            {
                $duration = "Permanent";
            }
            else
            {
                $duration = date("d/m/Y H:i:s", $ban["duration"]);
            }

        ?>

        <tr>

            <td>
                <?php echo $ban["id"]; ?>
            </td>

            <td>
                <?php echo htmlspecialchars($ban["player_name"]); ?>
            </td>

            <td>
                <?php echo htmlspecialchars($ban["admin_name"]); ?>
            </td>

            <td>
                <?php echo htmlspecialchars($ban["reason"]); ?>
            </td>

            <td>
                <?php echo $banDate; ?>
            </td>

            <td>
                <?php echo $duration; ?>
            </td>
			<td>
				<form method="POST" onsubmit="return confirm('Are you sure you want to revoke this ban?');">
				<input type="hidden" name="ban_id" value="<?php echo $ban["id"]; ?>">
				<button type="submit" name="revoke_ban" class="danger-button">  Revoke</button>
			</form>

</td>

        </tr>

        <?php
        }
        ?>

    </table>



    <div class="pagination">

        <?php

        if($page > 1)
        {
            echo '
            <a href="admin_bans.php?page='.($page - 1).'">
                ⬅ Previous
            </a>
            ';
        }


        for($i = 1; $i <= $totalPages; $i++)
        {
            if($i == $page)
            {
                echo '
                <a class="active">
                    '.$i.'
                </a>
                ';
            }
            else
            {
                echo '
                <a href="admin_bans.php?page='.$i.'">
                    '.$i.'
                </a>
                ';
            }
        }


        if($page < $totalPages)
        {
            echo '
            <a href="admin_bans.php?page='.($page + 1).'">
                Next ➡
            </a>
            ';
        }

        ?>

    </div>

</div>



<?php

require_once "includes/footer.php";

?>