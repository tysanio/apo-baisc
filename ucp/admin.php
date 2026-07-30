<?php

require_once "includes/auth.php";
require_once "includes/player.php";


if($player["Admin"] < 1)
{
    header("Location: dashboard.php");
    exit;
}


require_once "includes/header.php";

?>


<div class="card">

<h2> 🛠️ Admin Control Panel </h2>

<div class="admin-menu">
<a href="admin_bans.php"> 🚫 Bans </a><br>
<a href="admin_suggestions.php"> 💡 Players Suggestions </a><br>
<a href="admin_antennas.php"> 📡 Antennas </a><br>
<a href="admin_entrances.php"> 🚪 Entrances </a><br>
<a href="admin_fuel.php"> ⛽ Fuel Stations </a><br>
<a href="admin_missions.php"> 📍 Missions Spawn </a><br>
<a href="admin_objects.php"> 🏗️ Object Spawn </a><br>
</div>


</div>


<?php

require_once "includes/footer.php";

?>