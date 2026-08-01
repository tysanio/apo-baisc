new IsPlayerRegisterd[MAX_PLAYERS];
new query[2048],bool:pMuted[MAX_PLAYERS];

new Dadmin1[24],Dverifier[24],DLeader[24],DMember[24],Ddiscord[24],Dchat[24],Achat[24],ooc[24];
new DCC_Guild:GUILD_ID1,DCC_Role:RoleJoueur,DCC_Role:RoleLeader,DCC_Role:RoleMember,DCC_Channel:discordlog,bool:simembreroleok;
new DCC_Role: RoleStaff1,bool:sistaff1ok,DCC_Embed:Embed;

new mysql,Name[MAX_PLAYERS][24],IP[MAX_PLAYERS][16],Death[MAX_PLAYERS];

new PlayerText:DistanceTD[MAX_PLAYERS],inJOB[MAX_PLAYERS], Hunter_Deer[MAX_PLAYERS],AdminTarget[MAX_PLAYERS],
	Meeters_BTWDeer[MAX_PLAYERS],Meeters[MAX_PLAYERS], Deer[MAX_PLAYERS], Deep_Deer[MAX_PLAYERS], Meeter_Kill[MAX_PLAYERS],Shoot_Deer[MAX_PLAYERS];

new DB_Vehicle[MAX_SERVER_VEHICLES],DB_VehicleID[MAX_SERVER_VEHICLES],VehicleOwner[MAX_SERVER_VEHICLES][MAX_PLAYER_NAME],VehiclePaintjob[MAX_SERVER_VEHICLES];
new Float:gVehicleFuel[MAX_SERVER_VEHICLES],PlayerText:txtSpeed[MAX_PLAYERS],PlayerBar:FuelBar[MAX_PLAYERS],PlayerBar:HealthBar[MAX_PLAYERS];
new bool:EngineState[MAX_SERVER_VEHICLES],bool:FuelLeaking[MAX_SERVER_VEHICLES],bool:FuelWarningVisible[MAX_PLAYERS],FuelStationCount;
new Float:g_LastVehiclePos[MAX_SERVER_VEHICLES][3];

new missionactor[8],missioncheck;

native WP_Hash(buffer[], len, const str[]);

enum DATAX
{
	ID,
	Password[129],
	Admin,
	lasttime,
	VIP,
	Score,
    Exp,
    skin,
    interior,
    idclan, //for clan stuff
    clanrank, //for clan stuff
    clanexp[5],
    Float:Life,
	Float:Armor,
    Float:Pos[3],
    inv[26], //inv0= more inv space each
    Skill[11],//to do after
    Guns[13],
    Ammo[13],
    pEditobjects,
    pEditType,
    discordid[128],
	pSpamCount,
	Food,
	Water,
	PlayerBar:Foodbar,
	PlayerBar:Waterbar,
	pFreeze,
	pFreezeTimer,
	pLockpickStorage, //because derp
	pDiscordID,
	//antenna
	pHasRadio,
    pFrequency,
    pCurrentAntenna
}
new pData[MAX_PLAYERS][DATAX];

enum dGunEnum
{
	Float:ObjPos[3],
	ObjID,
	ObjData[2]
};
new dGunData[MAX_OBJ][dGunEnum];

new GunObjects[418] = { //fucking hell
	0,331,333,334,335,336,337,338,339,341,321,322,323,324,325,326,342,343,344,
	0,0,0,346,347,348,349,350,351,352,353,355,356,372,357,358,359,360,361,362,
	363,364,365,366,367,368,368,371,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    29000,29001,29002,29003,29004,29005,29006,29007,29008,29009,29010,29011,29012,29013,29014,29015,
    29016,29017,0,29019,29020,29021,29022,29023,29024,29025,29026,29027,29028,29029,29030,29031,29032,
    29033,29034,29035,29036,29037,29038,29039,29040,29041,29042,29043,29045,29047,29048,29049,29050,
    29051,29052,29053,29054,29055,0,29057,29058,29059,29060,29061,0,29082,29069,29064,29085,29097,29297,29065,
    29065,29074,29083,29071,29071,29094,29080,29076,29070,29066,29089,29073,29068,29092,29086,29091,29095,
    29072,29096,29079,29075,29090,29067,29081,29093,29084,29077,29087,29088,29116,29104,29114,29132,29099,
    29119,29100,29131,29298,29109,29117,29115,29128,29106,29101,29110,29105,29123,0,29103,29120,0,29125,
    29127,29129,29107,29130,29112,29121,29124,29118,29126,29111,29122,29134,29135,29136,29137,29138,29139,
    29140,29141,29142,29143,29144,29145,29146,29147,29148,29149,29150,29151,29152,29153,29154,29155,29156,
    29157,29158,29159,29160,29161,29162,29163,29164,29165,29166,29167,29168,29169,0,29171,29172,29173,29174,
    29175,29176,29177,29178,29179,29180,29181,29323,29182,29183,29184,29185,29186,29187,
    29188,29189,29190,29191,29192,29193,29194,29195,29196,29197,29198,29199,29200,29201,
    29202,29203,29204,29205,29206,29207,29208,29209,29210,29211,29212,29213,29214,29215,
    29216,29217,29218,29219,29220,29221,29222,29223,29224,29225,29226,29227,29228,29229,
    29230,29231,29232,29233,29234,29235,29236,29237,29238,29239,29240,29241,29242,29243,
    29244,29245,29246,29272,29273,29247,29248,29249,29250,29251,29252,29253,29254,29255,
    29256,29257,29258,29259,29260,29261,29262,29263,29264,29265,29266,29267,29268,29269,
    29270,29271,29274,29275,29276,29277,29278,29279,29280,29281,29282,29283,29284,29285,
    29286,29287,29288,29289,29290,0,29295,29296,29299,29300,29301,29302,0,29304,29306,
    29307,29309,29312,0,29313,0,29315,29316,29317,29319,29320,29321,29322,29324,29325,
    29326,29327,29328,29329
};

enum objectsData1
{
	objectsID,
	objectsExists,
	objectsModel,
	Float:objectsPos[6],
	objectsInterior,
	objectsWorld,
	objectsOb
};
new objectsData[MAX_OBJECTSC][objectsData1];

enum storageData1
{
	storagesID,
	storagesExists,
	storagesModel,
	Float:storagesPos[6],
	storagesInterior,
	storagesWorld,
	storagesLock, //lock = id of player database instead of using username
	storagesInv[26],
	storagesOb
};
new storageData[MAX_STORAGES][storageData1];

enum Dspawnpos
{
    Float:Pos[6],
    Objects
};
new dspawnpos[MAX_SPAWNPOS][Dspawnpos];

enum clan
{
    idclan,
    owner[26],
    clanname[26],
	clanexists,
    maxrank,    //1-15
	clanlock, //interior lock
    Float:enterpos[3],
    Float:exitpos[3],
    enterinterior,
    entervw,
    exitinterior,
    exitvw,
    pickup[3],
    Float:chestpos[3],
    clanrankname[15],
    clanexp[5], // for npc faction
	clancolor, //for war place
    inv[26] // inv0= lvl of the clan more level more inv space each
};
new clans[MAX_CLANS][clan],claninv;

new Skinsskins[32] = {
    1,30,95,127,128,131,132,133,134,136,135,137,
	151,157,158,159,160,161,162,168,191,192,
	190,198,200,201,202,239,254,291,292,303
};
new Skinspolice[9] = {
    280,281,282,284,300,301,302,306,307
};

enum e_InteriorData {
	e_InteriorName[32],
	e_InteriorID,
	Float:e_InteriorX,
	Float:e_InteriorY,
	Float:e_InteriorZ
};

new const g_arrInteriorData[][e_InteriorData] = {
{"24/7 V1",17,-25.8845,-185.869,1003.55},
{"24/7 V2",10,6.09118,-29.2719,1003.55},
{"24/7 V3",18,-89.6096,6.09118,1003.55},
{"24/7 V4",16,-25.1326,-139.067,1003.55},
{"24/7 V5",4,-27.3123,-29.2776,1003.55},
{"24/7 V6",6,-26.6916,-55.7149,1003.55},
{"4 Dragons Casino",10,2016.27,1017.78,996.875},
{"8-Track-Stadium",7,-1395.96,-208.197,1051.17},
{"Ammu-Nation",15,8603.34,7541.65,1025.95},
{"Ammu-Nation 1",1,286.149,-40.6444,1001.57},
{"Ammu-Nation 2",4,286.801,286.801,1001.54},
{"Ammu-Nation 3",6,296.92,-108.072,1001.57},
{"Ammu-Nation 4",7,314.821,-141.432,999.662},
{"Ammu-Nation 5",6,316.525,-167.707,999.662},
{"Andromada cargo hold",9,315.856,1024.5,1949.8},
{"Angel Pine Trailer",2,1.1853,-3.2397,999.428},
{"Apartment 3C",11,7526.9,-8827.15,1008.00},
{"Atrium",18,1726.18,-1641.0,20.23},
{"Auntie Poulets",16,6537.41,-7349.3,1004.35},
{"B Dup's Apartment",3,1527.22,-11.5744,1002.1},
{"B Dup's Crack Palace",2,1523.51,-47.8211,1002.13},
{"Barbara's office",5,322.198,302.498,999.148},
{"Barber Shop",3,418.653,-82.6397,1001.8},
{"Below the Belt Gym",7,773.58,-77.0966,1000.66},
{"Big Smoke's Crack Palace",2,2567.52,-1294.59,-1294.59},
{"Bike School",3,1494.33,1304.94,1093.29},
{"Binco,",15,207.738,-109.02,1005.13},
{"Blastin' Fools Hallway",3,1038.53,0.111,1001.28},
{"Bloodbowl Stadium",15,-1394.2,987.62,1023.96},
{"Boxing interior",27,7519.29,14632.2,1299.05},
{"Boys dorm",5,7747.73,14561.2,1032.42},
{"Bullworth Academy",32,7621.53,13926.9,1001.0},
{"Burger Shot",10,363.413,-74.5786,1001.51},
{"Burning Desire house",5,2338.32,-1180.61,1027.98},
{"Café Robina",7,6330.19,-8111.4,1006.79},
{"Caligula's Casino",1,2233.8,1712.23,1011.76},
{"Caligula's Roof",1,2268.16,1647.77,1084.23},
{"Casino",2,5071.1,5068.51,1001.47},
{"Casino",12,1118.89,-10.2737,1002.09},
{"Catalina's mansion",12,7694.56,8558.14,1071.88},
{"Chemical power plant",40,7496.02,14344.7,1131.86},
{"Claudes Portland hideout",1,894.148,-307.21,1008.69},
{"Club",17,493.391,-22.7227,1000.68},
{"Cluckin' Bell",9,365.716,-9.8873,1001.85},
{"Cobra Marital Arts Gym",6,774.214,-48.9242,1000.59},
{"Colonel Furhberger's",8,2807.63,-1170.15,1025.57},
{"Concert hall",8,6556.27,-6415.6,1006.06},
{"Crack Den",5,318.565,1115.21,1082.98},
{"Custom safehouse interior",4,8561.16,7953.1,1056.23},
{"VC introduction",1,7719.74,-8788.32,1113.02},
{"Denise's room",1,244.412,305.033,999.148},
{"Diaz's mansion",2,7121.85,-8057.43,1014.53},
{"Didier Sachs",14,204.333,-166.695,1000.52},
{"Dillimore Gas Station",0,664.19,-570.73,16.34},
{"Dirt Bike Stadium",4,-1424.93,-664.587,1059.86},
{"Downtown Ammu-Nation",10,6823.55,-6296.16,1006.03},
{"Ammu-Nation shooting range",14,7082.12,-6032.45,1006.03},
{"East Los Albos Ammu-Nation",6,6111.99,5414.18,1001.0},
{"El Banco Corrupto Grande",3,6597.05,-7840.55,1008.35},
{"El Corona safehouse",8,2365.42,-1131.85,1050.88},
{"Fanny Batter's Brothel",6,761.413,1440.19,1102.7},
{"FDC Janitor's Room",10,1891.38,1017.99,31.8828},
{"Forbes apartment",0,6869.48,-6288.08,45.9404},
{"Francis Intn'l Airport",14,-1827.15,7.20742,1061.14},
{"Gant Bridge Diner",5,454.974,-110.105,1000.08},
{"Ganton Gym",5,772.112,-3.8986,1000.73},
{"Girls dorm",35,7829.17,14561.1,993.088},
{"Golden Bed Motel Room",9,2251.85,-1138.16,1050.63},
{"Greasy Chopper",11,6903.89,-6852.58,1006.64},
{"Grocery store #1",26,7677.8,14638.8,1001.07},
{"Happy Voltz Asylum",23,7514.76,14673.2,1003.0},
{"Hardware store (Little Havanna)",5,7014.88,-6949.58,1022.19},
{"Hardware store Washington",5,7014.88,-6949.58,1022.19},
{"Hashbury safehouse",10,2260.76,-1210.45,1049.02},
{"Helena's barn",3,291.283,310.932,999.148},
{"Hotel Room",5,2233.69,-1112.81,1050.88},
{"House 1",3,235.509,1189.17,1080.34},
{"House 2",2,225.757,1240.0,1082.15},
{"House 3",1,223.044,1289.26,1082.2},
{"House 4",7,225.631,1022.48,1084.07},
{"House 5",15,295.139,1474.47,1080.52},
{"House 6",15,328.494,1480.59,1084.45},
{"House 7",15,385.804,1471.77,1080.21},
{"House 8",2,446.626,1397.74,1084.3},
{"House 9",2,490.194,1402.04,1080.26},
{"House 10",4,261.116,1287.22,1080.26},
{"House 11",4,221.677,1142.5,1082.61},
{"House 12",4,-262.176,1456.62,1084.37},
{"House 13",5,22.861,1404.92,1084.43},
{"House 14",5,239.282,1114.2,1080.99},
{"House 15",5,140.368,1367.88,1083.86},
{"House 16",6,-68.5145,1353.85,1080.21},
{"House 17",6,234.283,1065.23,1084.21},
{"House 18",8,-42.5267,1408.23,1084.43},
{"House 19",9,260.742,1238.23,1084.26},
{"House 20",9,84.9244,1324.3,1083.86},
{"House 21",10,24.3769,1341.18,1084.38},
{"House 22",15,375.587,1417.14,1081.33},
{"House 23",15,-285.251,1471.2,1084.38},
{"Inside Track",3,833.27,10.5884,1004.18},
{"Jay's Diner",4,457.305,-88.4284,999.555},
{"Jefferson Motel",15,2220.26,-1148.01,1025.8},
{"Johnson house",3,2496.65,-1696.55,1014.74},
{"Journalists apartment",1,5034.1,5160.92,1002.38},
{"Katie's room",2,271.885,306.632,999.148},
{"Ken's office",6,7638.91,-8870.81,1008.14},
{"Kickstart Stadium",14,-1410.72,1591.16,1052.53},
{"King Knuts",8,12761.5,-13781.9,1002.7},
{"Lance's apartment",32,7751.58,-8845.11,1020.64},
{"Lance's hotel",23,6976.74,-6449.96,1021.83},
{"Liberty City (snowy)",1,-750.8,491.0,1371.7},
{"Lil' Probe'Inn",18,-227.028,1401.23,27.7656},
{"Loco Low Co.",2,616.782,-74.8151,997.635},
{"LSPD HQ",6,246.784,63.9001,1003.64},
{"LVPD HQ",3,288.746,169.351,1007.17},
{"Madd Doggs mansion",5,1299.14,-794.77,1084.0},
{"Malibu Club",17,7986.82,-7575.61,1006.44},
{"Mall hardware store",7,13114.3,-11670.9,1214.4},
{"Mansion interior",12,2324.33,-1144.79,1050.71},
{"Marias house",13,8101.41,7544.63,1029.06},
{"Masicla Unisex Hair Salon",12,412.022,-52.6498,1001.9},
{"Michelle's room",4,302.181,300.723,999.148},
{"Millie's room",6,346.87,309.259,999.156},
{"North Point Mall",4,13167.4,-11631.8,1013.35},
{"North Point Ammu-Nation",7,7437.53,-8981.17,1005.44},
{"Observatory",40,7554.74,14322.2,1021.24},
{"Ocean Beach Hotel",1,7726.39,-8777.01,1007.03},
{"OG Loc's House",3,513.883,-11.2699,1001.57},
{"Phil's Fully Cocked",14,8148.81,7184.21,1012.65},
{"Pirates in Men's Pants",2,2236.7,-1078.95,1049.02},
{"Planning Department",3,384.809,173.805,1008.38},
{"Pleasure Dome",3,-2637.69,1404.24,906.46},
{"Pole Position Club",5,7593.95,-8965.76,1005.52},
{"Preps Hideout",60,7476.23,14603.1,1007.39},
{"Prickle Pine Safehouse",9,2319.13,-1023.96},
{"Print Works",18,6433.02,-7782.69,1007.05},
{"Pro Laps",3,207.055,-138.805,1003.51},
{"RC Battlefield",10,-1079.99,1061.58,1343.04},
{"Recording studio",9,6632.63,-6347.55,1009.72},
{"Red Bed Motel Room",10,2262.83,-1137.71,1050.63},
{"Reece's Hair and Facial Studio",2,411.626,-21.4332,1001.8},
{"Rosenberg's Office",2,2182.2,1628.58,1043.87},
{"Rusty Brown's",17,376.99,-191.21,1000.63},
{"Ryders house",2,2451.77,-1699.8,1013.51},
{"San Fierro Garage Interior",1,-2042.42,178.59,28.84},
{"School Library Interior",9,7466.71,14452.7,1091.14},
{"Secret Valley Diner",6,435.271,-80.9589,999.555},
{"Sex Shop XXX",3,-103.559,-24.2256,1000.72},
{"SFPD precinct",10,246.4,110.84,1003.22},
{"Shamal cabin",1,2.38483,33.1034,1199.85},
{"Sherman Dam",17,-959.564,1848.58,9.0},
{"Sindacco Abattoir",1,963.419,2108.29,1011.03},
{"Stadium interiors",14,6048.08,-6021.31,1302.06},
{"SubUrban",1,203.778,-48.4923,1001.8},
{"Sweets house",1,2535.83,-1674.32,1015.5},
{"Tarbrush Café",6,7966.65,-6493.18,1014.13},
{"Tattoo shop",16,-203.076,-24.1658,1002.27},
{"Ten Green Bottles",11,501.981,-69.1501,998.758,},
{"The Big Spread Ranch",3,1212.02,-28.663,1000.95},
{"The Camel's Toe Safehouse",1,2216.13,-1076.31,1050.48},
{"The Hole",8,7477.71,14143.1,1008.4},
{"The Pig Pen",2,1204.81,-11.5867,1000.92},
{"Tiger Skin Brothel",3,964.107,-53.2054,1001.12},
{"Toni's Shoreside Vale safehouse",7,7419.91,8538.39,1043.57},
{"Tonis Staunton hideout",7,287.461,-429.894,1023.89},
{"Trailer",14,7594.22,14331.0,1001.23},
{"TransFender",1,617.538,-1.99,1000.68},
{"Turning Tricks Advanced Motor",3,-2029.8,-106.676,1035.17},
{"U Get Inn Motel Room",12,444.647,508.239,1001.42},
{"Umberto's house",20,7552.54,-6239.87,1013.76},
{"Unknown Brothel",3,942.172,-16.5427,1000.93},
{"VCPD HQ",12,7892.19,-7977.33,1007.2},
{"Vice Stadium",1,-1401.83,107.051,1032.27},
{"Victim",5,226.294,-7.4315,1002.21},
{"Victors loft apartment",3,8210.19,-7687.17,1001.74},
{"Wardrobe",14,256.905,-41.6537,1002.02},
{"Warehouse",1,1412.64,-1.7875,1000.92},
{"Warehouse 2",18,1302.52,-1.7875,1001.03},
{"Washington Beach Ammu-Nation",7,7437.86,-8981.17,1005.43},
{"Welcome Pump",1,681.66,-453.32,-25.61},
{"Well Stacked Pizza",5,6627.2,-6705.07,999.407},
{"Well Stacked Pizza",5,372.352,-131.651,1001.49},
{"Wheel Arch Angels",3,615.285,-124.239,997.635},
{"Willowfield Safehouse",11,2283.31,-1139.31,1050.9},
{"Woozie's apartment",1,-2158.72,641.29,1052.38},
{"World of Coq",1,445.6,-6.9823,1000.73},
{"Zero's RC shop",6,-2240.0,131.0,1035.4},
{"ZIP",18,161.392,-93.1591,1001.8},
{"Entrainement Swat",10,1019.8245,1246.5947,1799.4005},
{"Élise", 1,-1991.9131, 1118.6000, 457.4883},
{"Caravan FIX", 1,2511.8999, -1729.8052, 778.1525},
{"Trailer park boys",1,2334.9458, -1047.7510,1043.7659}
};
enum E_FUEL_STATION {
    fsID,
    Float:fsPosX,
    Float:fsPosY,
    Float:fsPosZ,
    fsStock,
    Text3D:fsLabel,
    fsMapIcon
}
new FuelStation[MAX_FUEL_STATIONS][E_FUEL_STATION];

new WeaponFireDelay[47] = {
    0, 0, 450, 0, 0, 0, 150, 0, 0, 0, 500,
    200, 250, 0, 0, 0, 350, 350, 350, 350,
    200, 1000, 0, 0, 350, 500, 0, 0, 0, 0,
    600, 0, 300, 0, 1000, 600, 0, 0, 0, 0,
    800, 400, 250, 0, 0, 0
};

new AllowedWeapons[MAX_PLAYERS][MAX_WEAPONS],AllowedAmmo[MAX_PLAYERS][MAX_WEAPONS];
new LastShotTick[MAX_PLAYERS],AimbotFlags[MAX_PLAYERS];

enum GZInfo {
    gID,
    Float:gMinX,
    Float:gMinY,
    Float:gMaxX,
    Float:gMaxY,
    gZoneID,
    gTeamID, // New
	gressources,
	gCaptureTime
};
new GangZones[MAX_GZONES][GZInfo],TotalGZ = 0,Float:gZonePointA[MAX_PLAYERS][2],bool:gPointASet[MAX_PLAYERS],bool:ZoneInWar[MAX_GZONES],WarTimer[MAX_GZONES];
new WarCheckTimer[MAX_GZONES],GlobalZoneCooldown = 0; // Stores the timestamp until which zone is on cooldown

new Float:PlayerMissionCheckpoints[MAX_PLAYERS][MAX_MISSION_CHECKPOINTS][3];
new PlayerCurrentCheckpoint[MAX_PLAYERS];

enum entranceData {
	entranceID,
	entranceExists,
	entranceName[32],
	entranceLocked,
	Float:entrancePos[4],
	Float:entranceInt[4],
	entranceInterior,
	entranceExterior,
	entranceExteriorVW,
	entranceWorld,
	entrancePickup,
	Text3D:entranceText3D
};
new EntranceData[MAX_OBJECTSC][entranceData];

new CraftBarridaces[12] = { //18259 big one
	16404,3260,3302,19865,1446,18259,19339,1410,2991,2319
};

new ItemNames[26][24] =
{
    "Nothing",  //0
    "Meat(s)",  //1
    "Wood(s)",  //2
    "Metal(s)", //3
    "Cloth(s)", //4
    "Plastic(s)", //5
    "Gun Powder(s)", //6
    "Ore(s)", //inv 7
    "Iron(s)", //inv 8
    "Gold(s)", //inv 9
    "Lockpick(s)", //inv10
    "Repair kit(s)",
    "Med Kit(s)",
    "Jerrycan(s)",
    "9mm Bullet(s)",
    "00' Buck's",
    ".308(s)",
    "Armor Plate(s)",
    "Water Bottle(s)", //18
    "Canned Food",  //19
    "seeds", //seeds
    "potatoes", //potatoes
    "inv22", //weed-drug
    "tomatoes", //tomatoes
    "inv24",
    "inv25"
};

//mining
new IsMining[MAX_PLAYERS]; // Suit si le joueur est en train de miner
new Float:MineRock_X = 590.11;
new Float:MineRock_Y = 890.35;
new Float:MineRock_Z = -42.34;

//menu shop-armory
new Menu:Armory,Menu:PoliceArmory;
InitMenu()
{
	//first clan armory
	Armory = CreateMenu("Armory",2,20,120,120,15);
	SetMenuColumnHeader(Armory,0,"Items");
    AddMenuItem(Armory,0,"00' Buck x1");
    AddMenuItem(Armory,0,"00' Buck x5");
    AddMenuItem(Armory,0,"00' Buck x10");
    AddMenuItem(Armory,0,"Shotgun");
    AddMenuItem(Armory,0,"Sawn-off");
    AddMenuItem(Armory,0,"Exit");
    SetMenuColumnHeader(Armory,1,"Prices");
    AddMenuItem(Armory,1,"1 Iron");
    AddMenuItem(Armory,1,"5 Irons");
    AddMenuItem(Armory,1,"10 Irons");
    AddMenuItem(Armory,1,"2 Golds");
    AddMenuItem(Armory,1,"3 Golds");
	//police armory skin pistol food water
	PoliceArmory = CreateMenu("Armory",2,20,120,120,15);
	SetMenuColumnHeader(PoliceArmory,0,"Items");
    AddMenuItem(PoliceArmory,0,"Clothes");
    AddMenuItem(PoliceArmory,0,"Canned Foods x4");
    AddMenuItem(PoliceArmory,0,"Water Bottles x2");
    AddMenuItem(PoliceArmory,0,"9mm Bullet(s) x5");
    AddMenuItem(PoliceArmory,0,"9mm Bullet(s) x10");
    AddMenuItem(PoliceArmory,0,"Pistol");
    AddMenuItem(PoliceArmory,0,"Exit");
    SetMenuColumnHeader(PoliceArmory,1,"Prices");
    AddMenuItem(PoliceArmory,1,"10 Cloths");
    AddMenuItem(PoliceArmory,1,"5 Irons");
    AddMenuItem(PoliceArmory,1,"3 Irons");
    AddMenuItem(PoliceArmory,1,"5 Irons");
    AddMenuItem(PoliceArmory,1,"10 Irons");
    AddMenuItem(PoliceArmory,1,"5 Golds");
	//army armory skins AR plate armor
	//wasteland skin rifle medkit
}
//lockpick
enum E_LOCKPICK_DATA
{
    bool:lpActive,
    lpStep,
    lpRequiredPins,
    lpZoneSize,
    lpPos,
    lpDir,
    lpZoneStart,
    lpZoneEnd,
    lpTimer,
    lpSpeed
};
new Lockpick[MAX_PLAYERS][E_LOCKPICK_DATA];
//weapons change
new ChangeWeaponOld[MAX_PLAYERS];
new ChangeWeaponNew[MAX_PLAYERS];
//camera
new LoginCameraStep[MAX_PLAYERS],LoginCameraTimer[MAX_PLAYERS];
new Float:CamPos[MAX_LOGIN_CAMERAS][3] =
{
    {319.78, 1759.40, 71.61},
    {-473.00, 2118.08, 103.09},
    {-395.99, 2598.31, 137.53},
    {432.80, 2481.46, 47.72},
    {667.61, 781.77, -4.49},
    {-485.32, -25.10, 82.27},
    {-1772.82, -1766.63, 82.17},
    {-868.99, -451.18, 56.22}
};
new Float:CamLook[MAX_LOGIN_CAMERAS][3] =
{
    {319.06, 1760.10, 71.27},
    {-472.42, 2118.90, 102.65},
    {-395.18, 2598.90, 137.05},
    {432.05, 2482.13, 47.27},
    {666.95, 782.52, -4.81},
    {-485.77, -25.99, 82.00},
    {-1773.46, -1765.86, 81.65},
    {-869.69, -451.89, 55.87}
};
enum e_Antenna
{
    bool:aExists,
    aSQLID,
    aType,
    Float:aPosX,
    Float:aPosY,
    Float:aPosZ,
    Float:aHealth,
    Float:aRange,
    aPowered,
    aFuel,
    Text3D:aLabel
};
new Antenna[MAX_ANTENNAS][e_Antenna];
enum
{
    SIGNAL_NONE,
    SIGNAL_POOR,
    SIGNAL_MEDIUM,
    SIGNAL_GOOD,
    SIGNAL_PERFECT
};
//plant
enum ePlant
{
    plantExists,
    plantSQLID,
    plantOwner,
    plantType,
    Float:plantX,
    Float:plantY,
    Float:plantZ,
    plantVW,
    plantInterior,
    plantTime,
    plantObject,
    Text3D:plantLabel
};
new Plant[MAX_PLANTS][ePlant];