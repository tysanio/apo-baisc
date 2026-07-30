<?php

require_once "includes/auth.php";
require_once "includes/player.php";

require_once "includes/header.php";


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
// Count Suggestions
// ==============================

$count = $pdo->query(" SELECT COUNT(*) FROM suggestions ")->fetchColumn();



$totalPages = ceil($count / $limit);



// ==============================
// Load Suggestions
// ==============================

$stmt = $pdo->prepare("
    SELECT * FROM suggestions ORDER BY id ASC LIMIT ? OFFSET ?
");


$stmt->bindValue(
    1,
    $limit,
    PDO::PARAM_INT
);


$stmt->bindValue(
    2,
    $offset,
    PDO::PARAM_INT
);


$stmt->execute();


$suggestions = $stmt->fetchAll(PDO::FETCH_ASSOC);



?>



<div class="card">


<h2>
💡 Player Suggestions
</h2>



<table class="admin-table">


<tr>

<th>
ID
</th>


<th>
Username
</th>


<th>
Suggestion
</th>


<th>
Status
</th>


</tr>



<?php


foreach($suggestions as $row)
{


switch($row["Status"])
{

    case 1:$status = "✅ Yes";
    break;
    case 2: $status = "❌ No";
    break;
    default:$status = "⏳ Not Checked";
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