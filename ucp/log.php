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

    <h3>📜 Log #0 — Sorry</h3>

    <div class="log-paper">Hey, sis… it's me. I don't think I'm gonna make it.<br>
		I'm sorry. I really am. I tried to get back home, but everything went to hell so fast.<br>
		I kept thinking I'd see you again… that we'd laugh about all this someday.<br>
		If you're reading this… I'm sorry I couldn't make it back.<br>
		Please don't wait for me.<br>
		I love you, sis.
    </div>
</div>
<?php
    $pLog1 = isset($options["pLog1"])  ? (int)$options["pLog1"] : 0;
    $part1 = false;
    $part2 = false;
    $part3 = false;
    switch($pLog1)
    {
        case 10: $part1 = true; break;
        case 11: $part1 = true; $part2 = true; break;
        case 3: $part1 = true; $part2 = true; $part3 = true; break;
    }
?>
<?php if($part1 || $part2 || $part3): ?>
    <div class="announcement-box">
                        <h3>📜 Log #1 — A Shred Page of a Diary</h3>
                        <div class="log-paper">
                            <?php if($part1): ?>
                                <strong>09 September 20xx</strong><br>
                                Me and Melany are going to the mountain to celebrate her promotion that she worked hard to get.<br> 
								I'll support her with some intimate times for the both of us, she deserves it.
                                <br><br>
                            <?php endif; ?>
                            <?php if($part2): ?>
                                <strong>16 September 20xx</strong><br>
                                Someone attacked Melany while we were walking on the trail in the mountain today.<br>
                                She got bitten on her hand, it's not pretty.<br>
                                We ran away from the person back to our cabin. <br>
								I wanted to bring her to the hospital but she refused, saying she will be fine after I bandaged her hand.<br>
                                She's sleeping tight tonight on our bed. I guess it was a rough day for her.
                                <br><br>
                            <?php endif; ?>
                            <?php if($part3): ?>
                                <strong>17 September 20xx</strong><br>
                                I don't know what happened today...<br>
                                I woke up with the sight and pain of my wife biting my arms. She became uncontrollable trying to hurt me.<br>
                                I locked myself in the bathroom and tried to call the hospital, but the phone lines aren't getting through. I tried all day.<br>
                                I don't know what's going on, and I don't know what to do.<br>
                                I guess I'll just go to sleep tonight and see what I can do tomorrow.
                            <?php endif; ?>

                        </div>

                    </div>

                <?php endif; ?>

<?php
        }

        // LOG 2
        if((int)$options["pLog2"] == 1)
        {
?>

<div class="announcement-box">
    <h3>📜 Log #2</h3>
	<div class="log-paper">
		<p>
			Your log text goes here...
		</p>
	</div>
</div>

<?php
        }

        // LOG 3
        if((int)$options["pLog3"] == 1)
        {
?>

<div class="announcement-box">
    <h3>📜 Log #3</h3>
	<div class="log-paper">
		<p>
			Your log text goes here...
		</p>
	</div>
</div>

<?php
        }

        // LOG 4
        if((int)$options["pLog4"] == 1)
        {
?>

<div class="announcement-box">
    <h3>📜 Log #4</h3>
	<div class="log-paper">
		<p>
			Your log text goes here...
		</p>
	</div>
</div>

<?php
        }

        // LOG 5
        if((int)$options["pLog5"] == 1)
        {
?>

<div class="announcement-box">
    <h3>📜 Log #5</h3>
	<div class="log-paper">
		<p>
			Your log text goes here...
		</p>
	</div>
</div>

<?php
        }

        // LOG 6
        if((int)$options["pLog6"] == 1)
        {
?>

<div class="announcement-box">
    <h3>📜 Log #6</h3>
	<div class="log-paper">
		<p>
			Your log text goes here...
		</p>
	</div>
</div>

<?php
        }

        // LOG 7
        if((int)$options["pLog7"] == 1)
        {
?>

<div class="announcement-box">
    <h3>📜 Log #7</h3>
	<div class="log-paper">
		<p>
			Your log text goes here...
		</p>
	</div>
</div>

<?php
        }

        // LOG 8
        if((int)$options["pLog8"] == 1)
        {
?>

<div class="announcement-box">
    <h3>📜 Log #8</h3>
	<div class="log-paper">
		<p>
			Your log text goes here...
		</p>
	</div>
</div>

<?php
        }

        // LOG 9
        if((int)$options["pLog9"] == 1)
        {
?>

<div class="announcement-box">
    <h3>📜 Log #9</h3>
	<div class="log-paper">
		<p>
			Your log text goes here...
		</p>
	</div>
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