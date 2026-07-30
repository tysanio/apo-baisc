<?php

require_once "includes/auth.php";
require_once "includes/player.php";


// Admin only

if($player["Admin"] < 2)
{
    require_once "includes/header.php";

    echo '
    <div class="card error-box"> <h2>🚫 Access Denied</h2> 
	<p> You do not have permission to access this page. </p>
    </div>
    ';
    require_once "includes/footer.php";
    exit;
}

require_once "includes/header.php";

// ==============================
// Delete Refused Suggestions
// ==============================

if(isset($_POST["delete_refused"]))
{
    $stmt = $pdo->prepare(" DELETE FROM suggestions WHERE Status = 2");
    $stmt->execute();

    header("Location: admin_suggestions.php");

    exit;

}

// ==============================
// Update Status
// ==============================

if(isset($_POST["update_status"]))
{
    $id = $_POST["id"];
    $status = $_POST["update_status"];
    $stmt = $pdo->prepare(" UPDATE suggestions SET Status = ? WHERE id = ? ");
    $stmt->execute([$status, $id]);
    header("Location: admin_suggestions.php");
    exit;
}
// ==============================
// Load Suggestions
// ==============================
$stmt = $pdo->query("  SELECT * FROM suggestions ORDER BY id ASC ");
$suggestions = $stmt->fetchAll(PDO::FETCH_ASSOC);

?>

<div class="card">

<h2> 💡 Suggestions Management </h2>

<div class="suggestion-legend">

<h3> Legend </h3>


<p> ⏳ <b>Not Checked</b> - Waiting for review </p>
<p> ✅ <b>Yes</b> - Accepted suggestion </p>
<p> ❌ <b>No</b> - Refused suggestion </p>


</div>

<form method="POST" onsubmit="return confirm('Are you sure you want to delete all refused suggestions?');">

<button
type="submit"
name="delete_refused"
class="action-button delete-button">

🗑️ Remove All Refused Suggestions

</button>

</form>



<table class="admin-table">

<tr>
<th> ID </th>
<th> Username </th>
<th> Suggestion </th>
<th> Status </th>
<th> Action </th>
</tr>

<?php

foreach($suggestions as $row)
{

switch($row["Status"])
{
    case 1:  $status = "✅";
    break;
    case 2:  $status = "❌";
    break;
    default: $status = "⏳";
    break;
}
?>
<tr>
<td>

<?php echo $row["id"]; ?>

</td>

<td>

<?php echo htmlspecialchars($row["Username"]); ?>

</td>

<td>

<?php echo htmlspecialchars($row["suggestions"]); ?>

</td>

<td>

<?php echo $status; ?>

</td>

<td>


<form method="POST">

<input  type="hidden" name="id" value="<?php echo $row["id"]; ?>">
<button type="submit" name="update_status" class="action-button success-button" name="Status" value="1"> ✅ </button>
<button type="submit" name="update_status" class="action-button danger-button" name="Status" value="2"> ❌ </button>
<button type="submit" name="update_status" class="action-button warning-button" name="Status" value="0"> ⏳ </button>

</form>

</td>

</tr>

<?php

}
?>

</table>
</div>
<?php

require_once "includes/footer.php";

?>