<?php

require_once "includes/auth.php";
require_once "config/database.php";
require_once "includes/player.php";
require_once "includes/header.php";
require_once "includes/discord_check.php";
require_once "includes/samp_status.php";

$server = GetSAMPStatus($SERVER_IP, $SERVER_PORT);
$stmt = $pdo->query(" SELECT * FROM announcements ORDER BY id DESC LIMIT 3");

$announcements = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<div class="dashboard-layout">
    <!-- LEFT SIDE -->
    <div class="player-section">
	<div class="card">
		<h2>📢 Latest Announcements</h2>
		<?php
		if(count($announcements) == 0)
		{
			echo '<p>No announcements available.</p> ';
		}
		else
		{
			foreach($announcements as $row)
			{
			?>
			<div class="announcement-box">
				<div class="announcement-header">
                <strong> 👤 <?php echo htmlspecialchars($row["Username"]); ?>  </strong>
                <span>  <?php echo date("d M Y - H:i", strtotime($row["Date"])); ?> </span>
				</div>
            <div class="announcement-message"> <br><?php echo nl2br(htmlspecialchars($row["Message"])); ?> </div>
			<br>
        </div>
        <?php
			}
		}
		?>
	<br>
	</div>
		<br>
        <div class="card">
            <h2> Welcome back <?php echo htmlspecialchars($player["Username"]); ?> ! </h2>
            <br>
            <div class="info">
                <strong>🕒 Last Login</strong>
                <span>
                <?php
                if($player["lasttime"] > 0)
                {
                    echo date("d M, Y - H:i", $player["lasttime"]);
                }
                else
                {
                    echo "Never";
                }
                ?>
                </span>
            </div>
            <div class="info">
                <strong>
                    🏆 If you want to be a VIP or Admin ask on discord!
                </strong>
            </div>
            <!-- Discord Status -->
            <div class="card">
                <h2>💬 Discord Status</h2>
                <?php
                if(empty($player["discordid"]))
                {
                ?>
                    <p>❌ Not Linked</p>
                    <a href="discord.php"> <button class="action-button success-button"> 🔗 Link Discord </button>
                    </a>
                <?php
                }
                else
                {
                    if(CheckDiscordRole($player["discordid"]))
                    {
                    ?>
                        <p>✅ Linked</p>
                        <p> Your Discord account is verified with the UCP-Check role. </p>
                    <?php
                    }
                    else
                    {
                    ?>
                        <p>⚠️ Discord linked but not verified</p>
                        <p>  Please make sure you joined the Discord server. </p>
                    <?php

                    }
                }
                ?>
            </div>
        </div>
    </div>
    <!-- RIGHT SIDE SERVER -->
    <div class="server-section">
        <div class="card">
            <h2>🖥️ Server Status</h2>
            <div class="info">
                <strong>🌐 Status</strong>
                <span>
                <?php
                if($server["online"])
                {
                    echo "🟢 Online";
                }
                else
                {
                    echo "🔴 Offline";
                }
                ?>
                </span>
            </div>
            <div class="info">
                <strong>👥 Players</strong>
                <span>
                <?php
                if($server["online"])
                {
                    echo $server["players"]." / ".$server["maxplayers"];
                }
                else
                {
                    echo "0 / 0";
                }
                ?>
                </span>
            </div>
        </div>
    </div>
</div>


<?php

require_once "includes/footer.php";

?>