<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title><?php echo htmlspecialchars($SERVER_NAME); ?> </title>

<link rel="stylesheet" href="assets/css/style.css">

</head>

<body>

<div class="topbar">User Control Panel</div>

<div class="wrapper">

<div class="sidebar">

    <a href="dashboard.php">🏠 Dashboard</a>

    <a href="character.php">👤 Character</a>

    <a href="inventory.php">🎒 Inventory</a>

    <a href="vehicles.php">🚗 Vehicles</a>

    <a href="clans.php">🏰 Clan</a>

	<a href="map.php"> 🗺️ Map </a>

	<a href="suggestions.php"> 💡 Suggestions </a>

	<?php if($player["Admin"] >= 1 && $player["Admin"] <= 3) { ?>
	<a href="admin.php">🛠️ Admin Control Panel </a>	
	<?php } ?>
	
	<a href="faq.php"> ❓ FAQ </a>

    <a href="settings.php">⚙️ Settings</a>

    <a href="logout.php">🚪 Logout</a>

</div>

<div class="content">