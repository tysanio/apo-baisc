<?php

require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/header.php";

?>

<div class="card">

    <h2>
        Welcome <?php echo htmlspecialchars($player["Username"]); ?>
    </h2>

    <br>

    <div class="info">
        <strong>Account ID:</strong>
        <?php echo $player["ID"]; ?>
    </div>

    <div class="info">
        <strong>Admin Level:</strong>
        <?php echo $player["Admin"]; ?>
    </div>

    <div class="info">
        <strong>VIP Level:</strong>
        <?php echo $player["VIP"]; ?>
    </div>

</div>

<?php
require_once "includes/footer.php";
?>