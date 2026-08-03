<?php

require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/discord.php";

// =====================================
// Admin Only
// =====================================

if($player["Admin"] < 3)
{
    require_once "includes/header.php";

    echo '
    <div class="card error-box">
        <h2>🚫 Access Denied</h2>
        <p>You do not have permission to access this page.</p>
    </div>
    ';

    require_once "includes/footer.php";
    exit;
}

require_once "includes/header.php";

$message = "";
$error = "";

// =====================================
// Create Announcement
// =====================================

if(isset($_POST["post"]))
{
    $text = trim($_POST["message"]);

    if($text == "")
    {
        $error = '
        <div class="card error-box">
            <h2>❌ Empty Announcement</h2>
            <p>Please write an announcement.</p>
        </div>';
    }
    elseif(strlen($text) > 128)
    {
        $error = '
        <div class="card error-box">
            <h2>❌ Too Long</h2>
            <p>Maximum length is 128 characters.</p>
        </div>';
    }
    else
    {
        $stmt = $pdo->prepare("
            INSERT INTO announcements
            (Username, Message)
            VALUES
            (?, ?)
        ");

        $stmt->execute([
            $player["Username"],
            $text
        ]);

        // Discord webhook
        DiscordWebhook(
            "📢 New Server Announcement",
            "👤 **".$player["Username"]."**\n\n".
            "📢 ".$text."\n\n".
            "🌐 Check the UCP for the latest announcements."
        );
        $message = '
        <div class="card success-box">
            <h2>📢 Announcement Posted!</h2>
            <p style="font-size:16px;">
                Your announcement has been published successfully.
            </p>

        </div>';
    }
}

// =====================================
// Delete
// =====================================

if(isset($_POST["delete"]))
{
    $stmt = $pdo->prepare(" DELETE FROM announcements WHERE id = ? ");

    $stmt->execute([
        $_POST["id"]
    ]);

    header("Location: admin_annouce.php");
    exit;
}
// =====================================
// Load Announcements
// =====================================

$stmt = $pdo->query(" SELECT *FROM announcements ORDER BY id DESC");

$announcements = $stmt->fetchAll(PDO::FETCH_ASSOC);

?>

<div class="card">

<h2>📢 Server Announcements</h2>

<p>Create announcements visible in the UCP and sent to Discord.</p>

<br>

<?php

echo $message;
echo $error;

?>

<form method="POST">

<div class="info">

<strong>Announcement</strong>

<textarea
name="message"
maxlength="128"
rows="4"
style="width:100%;resize:none;"
placeholder="Maximum 128 characters..."
required></textarea>

</div>

<br>

<button
type="submit"
name="post"
class="action-button success-button"
style="width:220px;height:45px;">
📢 Publish Announcement
</button>

</form>

</div>

<br>

<div class="card">

<h2>📜 Previous Announcements</h2>

<table class="admin-table">

<tr>

<th>ID</th>
<th>Username</th>
<th>Message</th>
<th>Date</th>
<th>Action</th>

</tr>

<?php

foreach($announcements as $row)
{
?>

<tr>

<td>
<?php echo $row["id"]; ?>
</td>

<td>
<?php echo htmlspecialchars($row["Username"]); ?>
</td>

<td>
<?php echo htmlspecialchars($row["Message"]); ?>
</td>

<td>
<?php echo $row["Date"]; ?>
</td>

<td>

<form
method="POST"
onsubmit="return confirm('Delete this announcement?');">

<input
type="hidden"
name="id"
value="<?php echo $row["id"]; ?>">

<button
type="submit"
name="delete"
class="action-button danger-button">

🗑 Delete

</button>

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