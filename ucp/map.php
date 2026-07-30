<?php

require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/header.php";



// =====================================
// Load Antennas
// =====================================

$stmt = $pdo->query("SELECT * FROM antennas ORDER BY id ASC ");

$antennas = $stmt->fetchAll(PDO::FETCH_ASSOC);



// =====================================
// Load Fuel Stations
// =====================================

$stmt = $pdo->query("  SELECT * FROM fuel_stations ORDER BY id ASC ");

$fuelStations = $stmt->fetchAll(PDO::FETCH_ASSOC);



// =====================================
// Load Territories
// =====================================

$stmt = $pdo->query(" SELECT * FROM gang_zones ORDER BY id ASC ");

$territories = $stmt->fetchAll(PDO::FETCH_ASSOC);



// =====================================
// Player Clan
// =====================================

$playerClan = (int)$player["idclan"];

?>

<link
rel="stylesheet"
href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>

<link rel="stylesheet" href="assets/css/map.css">

<div class="card">

    <h2> 🗺 Tactical World Map </h2>

    <p> Click an antenna or fuel station for details. </p>

</div>



<div id="map"></div>



<div class="map-legend">

    <h3>Legend</h3>

    <div> 🟢 Active Antenna </div>

    <div> 🔴 Offline Antenna  </div>

    <div> ⛽ Fuel Station </div>
	
    <div> 🟩 Your Territory </div>
    <div> 🟥 Enemy Territory </div>
    <div> ⬜ Neutral Territory </div>

</div>



<script>

const PLAYER_CLAN =
<?php
echo $playerClan;
?>;



const ANTENNAS =
<?php
echo json_encode(
    $antennas,
    JSON_PRETTY_PRINT
);
?>;



const FUEL_STATIONS =
<?php
echo json_encode(
    $fuelStations,
    JSON_PRETTY_PRINT
);
?>;



const TERRITORIES =
<?php
echo json_encode(
    $territories,
    JSON_PRETTY_PRINT
);
?>;

</script>



<script
src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js">
</script>

<script
src="assets/js/map.js">
</script>



<?php

require_once "includes/footer.php";

?>