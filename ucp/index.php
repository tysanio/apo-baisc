<?php

session_start();

require_once "config/database.php";


$message = "";


// Password changed notification
if(isset($_GET["password_changed"]))
{
    $message = "

    <div class='password-success'>

        <h2>✅ Password Changed!</h2>

        <p>
            Your password has been updated successfully.
        </p>

        <p>
            Please login again using your new password.
        </p>

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


    $stmt->execute([
        $username
    ]);


    $player = $stmt->fetch();



    if($player)
    {
        if($passwordHash == $player["Password"])
        {
            $_SESSION["userid"] = $player["ID"];
            header("Location: dashboard.php");
            exit;
        }
        else
        {
            $message = " <div class='error'> Invalid password. </div> ";
        }
    }
    else
    {
        $message = " <div class='error'> Account not found. </div> ";

    }

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