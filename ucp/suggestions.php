<?php

require_once "includes/auth.php";
require_once "includes/player.php";

require_once "includes/header.php";
require_once "includes/discord.php";

// ==============================
// Add Suggestion
// ==============================
if(isset($_POST["add_suggestion"]))
{
    $suggestion = trim($_POST["suggestion"]);
    if(strlen($suggestion) > 128)
    {
        $error = "Suggestion is limited to 128 characters.";
    }
    else
    {

        $stmt = $pdo->prepare(" INSERT INTO suggestions (Username, suggestions, Status) VALUES (?, ?, 0) ");
        $stmt->execute([ $player["Username"], $suggestion ]);
		DiscordWebhook(
		"💡 New Suggestion From ".$player["Username"],
		"**Suggestion:**\n".
		$suggestion.
		"\n\n".
		"🔎 Check the UCP!");
        header("Location: suggestions.php");
        exit;
    }

}

// ==============================
// Pagination
// ==============================

$limit = 50;


$page = isset($_GET["page"]) ? (int)$_GET["page"] : 1;


if($page < 1)
{
    $page = 1;
}


$offset = ($page - 1) * $limit;



// ==============================
// Count Player Suggestions
// ==============================

$countStmt = $pdo->prepare(" SELECT COUNT(*)  FROM suggestions WHERE Username = ? ");


$countStmt->execute([
    $player["Username"]
]);


$count = $countStmt->fetchColumn();



$totalPages = ceil($count / $limit);




// ==============================
// Load Player Suggestions
// ==============================

$stmt = $pdo->prepare("  SELECT * FROM suggestions WHERE Username = ? ORDER BY id ASC LIMIT ? OFFSET ? ");


$stmt->bindValue(
    1,
    $player["Username"],
    PDO::PARAM_STR
);


$stmt->bindValue(
    2,
    $limit,
    PDO::PARAM_INT
);


$stmt->bindValue(
    3,
    $offset,
    PDO::PARAM_INT
);


$stmt->execute();


$suggestions = $stmt->fetchAll(PDO::FETCH_ASSOC);



?>

<div class="card">


<h2>
➕ Add Suggestion
</h2>



<?php

if(isset($error))
{

echo "

<p class='error-message'>
".$error."
</p>";

}

?>



<form method="POST">


<textarea
name="suggestion"
maxlength="128"
required
placeholder="Write your suggestion here..."
style="width:100%; height:100px;">
</textarea>


<br><br>


<button
type="submit"
name="add_suggestion"
class="action-button success-button">

💡 Submit Suggestion

</button>


</form>


<p>
Maximum characters: 128
</p>


</div>

<div class="card">


<h2> 💡 My Suggestions </h2>




<table class="admin-table">


<tr>

<th>
ID
</th>


<th>
Suggestion
</th>


<th>
Status
</th>


</tr>




<?php


if(count($suggestions) == 0)
{

?>

<tr>

<td colspan="3">

No suggestions submitted yet.

</td>

</tr>


<?php

}



foreach($suggestions as $row)
{


switch($row["Status"])
{

    case 1:

        $status = "✅ Yes";

    break;


    case 2:

        $status = "❌ No";

    break;


    default:

        $status = "⏳ Not Checked";

    break;

}


?>



<tr>


<td>

<?php echo $row["id"]; ?>

</td>



<td>

<?php echo htmlspecialchars($row["suggestions"]); ?>

</td>



<td>

<?php echo $status; ?>

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

?>

<a href="suggestions.php?page=<?php echo $page - 1; ?>">
⬅ Previous
</a>


<?php

}



for($i = 1; $i <= $totalPages; $i++)
{


if($i == $page)
{

?>

<a class="active">

<?php echo $i; ?>

</a>


<?php

}

else

{

?>

<a href="suggestions.php?page=<?php echo $i; ?>">

<?php echo $i; ?>

</a>


<?php

}


}



if($page < $totalPages)
{

?>

<a href="suggestions.php?page=<?php echo $page + 1; ?>">
Next ➡
</a>


<?php

}


?>


</div>



</div>



<?php

require_once "includes/footer.php";

?>