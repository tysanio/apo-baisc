<?php
session_start();
require_once "config/database.php";
$stmt = $pdo->query("SELECT * FROM announcements ORDER BY id DESC LIMIT 3");

$announcements = $stmt->fetchAll(PDO::FETCH_ASSOC);
$message = "";
// Password changed notification
if(isset($_GET["password_changed"]))
{
    $message = "
    <div class='password-success'>
        <h2>✅ Password Changed!</h2>
        <p> Your password has been updated successfully. </p>
        <p> Please login again using your new password.  </p>
    </div>
    ";
}
// Login process
if(isset($_POST["login"]))
{
	$username = $_POST["username"];
	$password = $_POST["password"];
    // Whirlpool uppercase (same as database)
    $passwordHash = strtoupper(hash("whirlpool", $password));
    $stmt = $pdo->prepare("SELECT * FROM players WHERE Username = ? LIMIT 1 ");
    $stmt->execute([ $username ]);
    $player = $stmt->fetch();
    if($player)
    {
        if($passwordHash == $player["Password"])
        {
            $_SESSION["userid"] = $player["ID"];
            header("Location: dashboard.php");
            exit;
        }
        else $message = " <div class='error'> Invalid password. </div> ";
    }
    else $message = " <div class='error'> Account not found. </div> ";
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
		<meta charset="UTF-8">
		<title> <?php echo htmlspecialchars($SERVER_NAME); ?>  </title>
	<link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
	<div class="card" style="width:700px; margin:1px auto;">
		<h1>📢 Latest News</h1>
		<?php
			if(count($announcements) == 0) echo "<p>No announcements available.</p>";
			else
			{
				foreach($announcements as $row)
				{
		?>
				<div class="announcement-box">
				<div class="announcement-header">
					<strong> 👤 <?php echo htmlspecialchars($row["Username"]); ?> </strong>
					<?php echo date("d M Y - H:i", strtotime($row["Date"])); ?> 
				</div>
				<div class="announcement-message">
					<?php echo nl2br(htmlspecialchars(trim($row["Message"]))); ?>
				</div>
				</div>
		<?php
				}
			}
		?>
</div>
	<div class="login-container">
	<?php echo $message; ?>
		<div class="login-box">
		<h1><?php echo htmlspecialchars($SERVER_NAME); ?> </h1>
			<form method="POST">
				<div class="info">
					<label> Username </label>
						<input type="text" name="username" required>
				</div>
				<div class="info">
					<label> Password </label>
						<input type="password" name="password" required>
				</div>
				<button type="submit" name="login" > Login </button>
			</form>
		</div>
	</div>
</body>

</html>