<?php
require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/header.php";
$stmt = $pdo->prepare(" SELECT *FROM players_options WHERE Username = ? LIMIT 1 ");
$stmt->execute([ $player["Username"] ]);
$options = $stmt->fetch(PDO::FETCH_ASSOC);
?>
<div class="card">
<h2>📖 Logs</h2>
<?php

if(!$options)
{
    echo ' <div class="error-box">
        <h2>❌ Logs Unavailable</h2>
        <p>Player options could not be found.</p>
    </div>';
}
else
{
    $hasLogs = false;
    for($i = 0; $i <= 9; $i++)
    {
        if((int)$options["pLog".$i] == 1)
        {
            $hasLogs = true;
            break;
        }
    }
    if(!$hasLogs)
    {
?>

<div class="error-box">
    <h2>📖 No Logs Found</h2>
    <p style="font-size:16px;"> You haven't discovered any logs yet. </p>
    <p style="font-size:16px;"> Go in-game and explore the world to discover hidden logs scattered around the map!</p>
</div>

<?php
    }
    else
    {
?>

    <!-- LOG 0 -->

<?php
        if((int)$options["pLog0"] == 1)
        {
?>
<div class="announcement-box">

    <h3>📜 Log #0 — The Beginning</h3>

    <p style="font-family:'Special Elite', cursive !important; font-size:18px;"> Hey, sis… it's me. I don't think I'm gonna make it.<br>
		I'm sorry. I really am. I tried to get back home, but everything went to hell so fast.<br>
		I kept thinking I'd see you again… that we'd laugh about all this someday.<br>
		If you're hearing this… I'm sorry I couldn't make it back.<br>
		Please don't wait for me.<br>
		I love you, sis.
    </p>
</div>

<?php
        }

        // LOG 1
        if((int)$options["pLog1"] == 1)
        {
?>

<div class="announcement-box">

    <h3>📜 Log #1</h3>

    <p>
        Your log text goes here...
    </p>

</div>

<?php
        }

        // LOG 2
        if((int)$options["pLog2"] == 1)
        {
?>

<div class="announcement-box">

    <h3>📜 Log #2</h3>

    <p>
        Your log text goes here...
    </p>

</div>

<?php
        }

        // LOG 3
        if((int)$options["pLog3"] == 1)
        {
?>

<div class="announcement-box">

    <h3>📜 Log #3</h3>

    <p>
        Your log text goes here...
    </p>

</div>

<?php
        }

        // LOG 4
        if((int)$options["pLog4"] == 1)
        {
?>

<div class="announcement-box">

    <h3>📜 Log #4</h3>

    <p>
        Your log text goes here...
    </p>

</div>

<?php
        }

        // LOG 5
        if((int)$options["pLog5"] == 1)
        {
?>

<div class="announcement-box">

    <h3>📜 Log #5</h3>

    <p>
        Your log text goes here...
    </p>

</div>

<?php
        }

        // LOG 6
        if((int)$options["pLog6"] == 1)
        {
?>

<div class="announcement-box">

    <h3>📜 Log #6</h3>

    <p>
        Your log text goes here...
    </p>

</div>

<?php
        }

        // LOG 7
        if((int)$options["pLog7"] == 1)
        {
?>

<div class="announcement-box">

    <h3>📜 Log #7</h3>

    <p>
        Your log text goes here...
    </p>

</div>

<?php
        }

        // LOG 8
        if((int)$options["pLog8"] == 1)
        {
?>

<div class="announcement-box">

    <h3>📜 Log #8</h3>

    <p>
        Your log text goes here...
    </p>

</div>

<?php
        }

        // LOG 9
        if((int)$options["pLog9"] == 1)
        {
?>

<div class="announcement-box">

    <h3>📜 Log #9</h3>

    <p>
        Your log text goes here...
    </p>

</div>

<?php
        }
    }
}

?>

</div>

<?php

require_once "includes/footer.php";

?>