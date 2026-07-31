<?php
require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/header.php";

require_once "config/database.php";
require_once "includes/discord_role.php";
require_once "includes/discord.php";



$url = "https://discord.com/oauth2/authorize?" . http_build_query([

    "client_id" => $DISCORD_CLIENT_ID,

    "redirect_uri" => $DISCORD_REDIRECT,

    "response_type" => "code",

    "scope" => "identify"

]);



?>

<div class="card">

<h2> 🔗 Link Discord Account </h2>
<p> Connect your Discord account to your UCP. </p>


<a href="<?php echo $url; ?>">
<button class="action-button success-button"> 💬 Connect Discord </button>
</a>


</div>
<?php

require_once "includes/footer.php";

?>