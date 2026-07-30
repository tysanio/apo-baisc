<?php

require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/header.php";


$message = "";


if(isset($_POST["change_password"]))
{

    $oldPassword = $_POST["old_password"];
    $newPassword = $_POST["new_password"];
    $confirmPassword = $_POST["confirm_password"];


    // Check new passwords match
    if($newPassword != $confirmPassword)
    {
        $message = "New passwords do not match.";
    }
    else
    {

        // Whirlpool encryption
        $oldHash = strtoupper(hash("whirlpool", $oldPassword));


        // Check old password
		if($oldHash != $player["Password"])
		{

			echo "<pre>";

			echo "Entered password hash:\n";
			echo $oldHash;

			echo "\n\nDatabase password:\n";
			echo $player["Password"];

			echo "</pre>";

			exit;

		}
        else
        {

            $newHash = strtoupper(hash("whirlpool", $newPassword));


            $stmt = $pdo->prepare(" UPDATE players SET Password = ? WHERE id = ? ");


            $stmt->execute([
                $newHash,
                $_SESSION["userid"]
            ]);


            // Logout
            session_destroy();


            header("Location: index.php?password_changed=1");
            exit;

        }

    }

}

?>


<div class="card">

<h2>⚙️ Settings</h2>


<?php

if($message != "")
{
    echo "
    <div class='error'>
        ".$message."
    </div>
    ";
}

?>


<form method="POST">


<div class="info">

<label>
Old Password
</label>

<input type="password" name="old_password" required>

</div>



<div class="info">

<label>
New Password
</label>

<input type="password" name="new_password" required>

</div>



<div class="info">

<label>
Confirm Password
</label>

<input type="password" name="confirm_password" required>

</div>



<button type="submit" name="change_password">
Change Password
</button>


</form>


</div>


<?php

require_once "includes/footer.php";

?>