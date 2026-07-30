/*
==========================================================
    SA-MP Tactical Map
==========================================================
*/
// ========================================================
// Map Settings
// ========================================================
// GTA SA world limits
const SA_MIN_X = -3000;
const SA_MAX_X = 3000;

const SA_MIN_Y = -3000;
const SA_MAX_Y = 3000;
// Radar image size
const MAP_SIZE = 6000;
// ========================================================
// Coordinate Converter
// ========================================================
function SAtoMap(x, y)
{
    let mapX =
        ((x - SA_MIN_X) / (SA_MAX_X - SA_MIN_X))
        * MAP_SIZE;
    let mapY =
        MAP_SIZE -
        (((y - SA_MIN_Y) / (SA_MAX_Y - SA_MIN_Y))
        * MAP_SIZE);
    return [
        mapY,
        mapX
    ];
}
// ========================================================
// Create Map
// ========================================================
const map = L.map('map',
{
    crs: L.CRS.Simple,
    minZoom:-2,
    maxZoom:3,
    zoomControl:true
});
// Image bounds
const bounds =
[
    [0,0],
    [MAP_SIZE,MAP_SIZE]
];
// Load SA radar map
L.imageOverlay(
    "assets/images/sa_map_6000.png",
    bounds
).addTo(map);
// Center
map.fitBounds(bounds);
// ========================================================
// Icons
// ========================================================
const antennaOnline =
L.divIcon(
{
    className:"antenna-marker online",
    html:
    `
    <div class="antenna-icon"> 📡 </div>
    `,
    iconSize:[40,40],
    iconAnchor:[40,40]
});
const antennaOffline =
L.divIcon(
{
    className:"antenna-marker offline",
    html:
    `
    <div class="antenna-icon"> 📡 </div>
    `,
    iconSize:[40,40],
    iconAnchor:[40,40]
});
const fuelIcon =
L.divIcon(
{
    className:"fuel-marker",
    html:
    `
    <div class="fuel-icon"> ⛽ </div>
    `,
    iconSize:[40,40],
    iconAnchor:[20,20]

});
const friendlyTerritory =
L.divIcon(
{
    className:"territory-marker",
    html:"🟩",
    iconSize:[25,25],
    iconAnchor:[12,12]

});
const enemyTerritory =
L.divIcon(
{
	className:"territory-marker",
    html:"🟥",
    iconSize:[20,20],
	iconAnchor:[12,12]

});
const neutralTerritory =
L.divIcon(
{
	className:"territory-marker",
    html:"⬜",
    iconSize:[20,20],
	iconAnchor:[12,12]

});
const clanEntranceIcon =
L.divIcon(
{
    className:"clan-marker",
    html:"🚪",
    iconSize:[35,35],
    iconAnchor:[17,17]
});


const clanChestIcon =
L.divIcon(
{
    className:"clan-marker",
    html:"📦",
    iconSize:[35,35],
    iconAnchor:[17,17]
});
// ========================================================
// Antennas
// ========================================================
ANTENNAS.forEach(function(antenna)
{
    let pos = SAtoMap(
        parseFloat(antenna.x),
        parseFloat(antenna.y)
    );
    let icon =
        antenna.powered == 1
        ?
        antennaOnline
        :
        antennaOffline;
    let status =
        antenna.powered == 1
        ?
        "🟢 Online"
        :
        "🔴 Offline";
    let type = "";
    switch(parseInt(antenna.type))
    {
        case 0: type="Small Range";
        break;
        case 1: type="Medium Range";
        break;
        case 2: type="Large Range";
        break;
        default:  type="Unknown";
    }
    L.marker(
        pos,
        {
            icon:icon
        }
    )
    .addTo(map)
    .bindPopup(`
        <h3>📡 Antenna #${antenna.id}</h3>
        <b>Status:</b>
        ${status}
        <br>
        <b>Type:</b>
        ${type}
        <hr>
        <b>Coordinates</b>
        <br>
        X: ${antenna.x}
        <br>
        Y: ${antenna.y}
        <br>
        Z: ${antenna.z}
    `);
});
// ========================================================
// Fuel Stations
// ========================================================
FUEL_STATIONS.forEach(function(station)
{
    let pos = SAtoMap(

        parseFloat(station.pos_x),

        parseFloat(station.pos_y)

    );
    L.marker(
        pos,
        {
            icon:fuelIcon
        }
    )
    .addTo(map)
    .bindPopup(`
        <h3>⛽ Fuel Station #${station.id}</h3>
        <b>Coordinates</b>
        <br>
        X: ${station.pos_x}
        <br>
        Y: ${station.pos_y}
        <br>
        Z: ${station.pos_z}
    `);
});
// ========================================================
// Territories
// ========================================================
TERRITORIES.forEach(function(zone)
{
    // Convert corners
    let pointA = SAtoMap(
        parseFloat(zone.minx),
        parseFloat(zone.miny)
    );
    let pointB = SAtoMap(
        parseFloat(zone.maxx),
        parseFloat(zone.maxy)
    );
    let color = "#ffffff"; // Neutral
    if(parseInt(zone.team_id) > 0)
    {
        if(parseInt(zone.team_id) == PLAYER_CLAN)
        {
            color = "#00ff00"; // Your clan
        }
        else
        {
            color = "#ff0000"; // Enemy
        }
    }
    // Rectangle corners
    let rectangleBounds =
    [
        pointA,
        pointB
    ];
    L.rectangle(
        rectangleBounds,
        {
            color: color,
            weight: 2,
            fillColor: color,
            fillOpacity: 0.25,
            interactive:false
        }
    )
    .addTo(map);
});
// ========================================================
// Player Clan Locations
// ========================================================
if(CLAN_LOCATION != null)
{
    // Clan Entrance
    let entrance =
    SAtoMap(
        parseFloat(CLAN_LOCATION.enterposx),
        parseFloat(CLAN_LOCATION.enterposy)
    );
    L.marker(
        entrance,
        {
            icon:clanEntranceIcon
        }
    )
    .addTo(map)
    .bindPopup(`
	
        <h3>🚪 Clan Entrance</h3>
		<b>Coordinates</b>
		<br>
        X: ${CLAN_LOCATION.enterposx} 
		<br>
		Y: ${CLAN_LOCATION.enterposy}
		<br>
		Z: ${CLAN_LOCATION.enterposz}

    `);
    // Clan Chest
    let chest =
    SAtoMap(
        parseFloat(CLAN_LOCATION.chestposx),
        parseFloat(CLAN_LOCATION.chestposy)
    );
    L.marker(

        chest,
        {
            icon:clanChestIcon
        }
    )
    .addTo(map)
    .bindPopup(`
        <h3>📦 Clan Chest</h3>
		<b>Coordinates</b>
		<br>
        X: ${CLAN_LOCATION.chestposx}
		<br>
		Y: ${CLAN_LOCATION.chestposy}
		<br>
		Z: ${CLAN_LOCATION.chestposz}

    `);



}