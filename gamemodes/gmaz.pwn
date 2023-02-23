#include <a_samp>
#include <a_actor>
#include <ugmp>
#include <a_mysql>
#include <streamer>
#include <foreach>
#include <strlib>
#include <easyDialog>
#include <sscanf2>
#include <zcmd>
#include <eSelection>
#include <discord-connector>
#include <discord-command>

#include <apo/antiairbreak>

#define host	"localhost"
#define user	"root"
#define db		"apo"
#define pass 	""

#define COLOR_RED       0xFF0000FF
#define COLOR_GREEN     0x00FF00FF
#define COLOR_BLUE      0x0000FFFF
#define COLOR_CMY       0xFFFF00FF
#define COLOR_YELLOW    0xFFDD00AA
#define COLOR_LIGHTRED  0xFF6347AA
#define COLOR_LIGHTBLUE 0x33CCFFAA

#define script%0(%1) forward%0(%1); public%0(%1)
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define MAX_OBJ 1000 // <- weapons drop
#define MAX_SERVER_VEHICLES     2000
#define MAX_STORAGE 500
#define MAX_OBJECTSC 500   //map object
#define MAX_SPAWNPOS 4000  //spawn object random
#define MAX_CLANS 5000
#define MAX_ZONE 100

#define MODEL_SELECTION_SKIN 													(1)

//discord chat A CHANGER POUR LES BONNE VALEUR
#define DISCORD_PREFIX "?"                  // your prefix to use command
#define Dadmin1 "999526889859321929"
#define Dverifier "999527205325525102"
#define Ddiscord "999480199211130970"
#define Dchat "1067560485135847504" //pour joueur
#define Achat "1067560485135847504" //pour admin
#define ooc "1067560485135847504"

#define SendServerMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_YELLOW, "[SERVER]:{FFFFFF} "%1)

new IsPlayerRegisterd[MAX_PLAYERS];
new query[2048];
new bool:pMuted[MAX_PLAYERS];

new DCC_Guild:GUILD_ID1,DCC_Role:RoleJoueur,DCC_Channel:discordlog,bool:simembreroleok;
new DCC_Role: RoleStaff1,bool:sistaff1ok,DCC_Embed:Embed;

new mysql,Name[MAX_PLAYERS][24],IP[MAX_PLAYERS][16],Death[MAX_PLAYERS];

new PlayerText:DistanceTD[MAX_PLAYERS],inJOB[MAX_PLAYERS], Hunter_Deer[MAX_PLAYERS],
	Meeters_BTWDeer[MAX_PLAYERS],Meeters[MAX_PLAYERS], Deer[MAX_PLAYERS], Deep_Deer[MAX_PLAYERS], Meeter_Kill[MAX_PLAYERS],Shoot_Deer[MAX_PLAYERS];

new missionactor[2];
static s_TargetActor[MAX_PLAYERS] = {INVALID_ACTOR_ID, ...};

native WP_Hash(buffer[], len, const str[]);

enum DATAX
{
	ID,
	Password[129],
	Admin,
	VIP,
	Score,
    Exp,
    Level,
    skin,
    interior,
    clanexp[5],
    Float:Life,
	Float:Armor,
    Float:Pos[3],
    inv[26],
    Skill[11],//to do after
    Guns[13],
    Ammo[13],
	LoggedIn,
    pEditobjects,
    pEditType,
    discordid[128],
	UserID
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

enum VehiclesData
{
    vehID,
    vehSessionID,
    vehModel,
    vehName[25],
    vehOwner[26],
    vehLock,
    vehMod[14],
    vehColorOne,
    vehColorTwo,
    Float:vehX,
    Float:vehY,
    Float:vehZ,
    Float:vehA
};

new vInfo[MAX_VEHICLES][VehiclesData],Iterator: ServerVehicles<MAX_VEHICLES>,Iterator: PrivateVehicles[MAX_PLAYERS]<MAX_SERVER_VEHICLES>;

enum DSTORAGE //inv 0 storage = vip add stuff
{
    Float:Pos[6],
    inv[26],
    lock,
    typesize,  // shoe box no vip small medium large + vip 6/7/8  6(x2 size + vip)
    objects,
	Username[26]
};
new dStorage[MAX_STORAGE][DSTORAGE];

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
    maxrank,    //1-15
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
    inv[26] // inv0= lvl of the clan more level more inv space each
};
new clans[MAX_CLANS][clan],clannamec[26];

enum zone1
{
	Float:zonepos[4],
	clanid,
    zoneexp,
    zoneressource,
    namezone[32],
    zoneplace
};
new zone[MAX_ZONE][zone1];

new Skinsskins[169] = {
    137,157,158,159,198,201,285,283,310,26153,26139,26401,26453,26464,26564,26565,26566,26567,26568,26569,26570,26571,26572,
    26573,26574,26575,26576,26577,26578,26579,26580,26581,26582,26583,26584,26585,26587,26589,26590,26591,26592,26593,26594,
    26595,26596,26597,26598,26599,26601,26602,26603,26604,26605,26606,26607,26608,26609,26610,26611,26612,26613,26614,26615,
    26616,26617,26618,26619,26620,26621,26622,26623,26624,26625,26626,26627,26628,26629,26630,26631,26680,26688,26723,26778,
    26780,26782,26949,27264,27381,27089,27090,27091,27092,27093,27094,27095,27096,27097,27098,27099,27100,27101,27102,27103,
    27104,27105,27109,27110,27111,27112,27113,27114,27115,27116,27117,27118,27119,27120,27121,27122,27123,27124,27125,27127,
    27128,27129,27130,27131,27132,27133,27134,27136,27137,27138,27140,27141,27142,27143,27144,27145,27146,27147,27148,27149,
    27150,27151,27152,27153,27154,27155,27156,27157,27158,27159,27161,27162,27163,27164,27165,27166,27167,27018,27070,27071,
    27226,27227,27233,27236,27237,27316
};

new VehicleNames[25313][] =
{
	"landstal","bravura","buffalo","linerun","peren","sentinel","dumper","firetruk","trash","stretch","m291anana","infernus","voodoo","pony","mule","cheetah",
	"ambulan","leviathn","moonbeam","esperant","taxi","washing","bobcat","mrwhoop","bfinject","hunter","premier","enforcer","securica","banshee","predator",
	"bus","rhino","barracks","hotknife","artict1","previon","coach","cabbie","stallion","rumpo","rcbandit","romero","packer","monster","admiral","squalo",
	"seaspar","pizzaboy","tram","artict2","turismo","speeder","reefer","tropic","flatbed","yankee","caddy","solair","topfun","skimmer","pcj600","faggio",
	"freeway","rcbaron","rcraider","glendale","oceanic","sanchez","sparrow","patriot","quad","coastg","dinghy","hermes","sabre","rustler","zr350","walton",
	"regina","comet","bmx","burrito","camper","marquis","baggage","dozer","maverick","vcnmav","rancher","fbiranch","virgo","greenwoo","jetmax","hotring",
	"sandking","blistac","polmav","boxville","benson","mesa","rcgoblin","hotrina","hotrinb","bloodra","rnchlure","supergt","elegant","journey","bike",
	"mtbike","beagle","cropdust","stunt","petro","rdtrain","nebula","majestic","buccanee","shamal","hydra","fcr900","nrg500","copbike","cement","towtruck",
	"fortune","cadrona","fbitruck","willard","forklift","tractor","combine","feltzer","remingtn","slamvan","blade","freight","streak","vortex","vincent",
	"bullet","clover","sadler","firela","hustler","intruder","primo","cargobob","tampa","sunrise","merit","utility","nevada","yosemite","windsor","monstera",
	"monsterb","uranus","jester","sultan","stratum","elegy","raindanc","rctiger","flash","tahoma","savanna","bandito","freiflat","streakc","kart","mower",
	"duneride","sweeper","broadway","tornado","at400","dft30","huntley","stafford","bf400","newsvan","tug","petrotr",//refaire up
	"emperor","wayfarer","euros","hotdog","club","freibox","artict3","androm","dodo","rccam","launch","copcarla","copcarsf","copcarvg","copcarru","picador",
	"swatvan","alpha","phoenix","glenshit","sadlshit","bagboxa","bagboxb","tugstair","boxburg","farmtr1","utiltr1","vcgangbur","lcbellyup","lchoods",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"lcyardie","lccolumb","NoVeh","lcmafia","lcmrwong","vcfbicar","lcdiablos",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","vccubanh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","vcangel","vcdeluxo","vcsabretur","lcyakuza","vcsentxs","vczebra","lcblista",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","lcsforellicar",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","vckaufman",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh",
	"vcstinger","vcvicechee","vcspand","vclovefist","vcidaho","lcsindaccocar","lcsbickle76","lckuruma","lcidaho","lctoyz","lcborgnine","lcmanchez","lcnoodleboy",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","lccopcarlc",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","vccopcarvc",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","lcmonstros",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","vcgangran","vcwintergreen",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","vccopwinter","vcmoped50","lcsavenger","vcstreetfighter","vcpolaris","clovral",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","lcsangel","lcslandstal","lcspcj600",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","lccopbike","airtrain","NoVeh","NoVeh","bwregina",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","bwvaquero",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh",
	"vchunter","vcmaverick","vcseaspar","vcskimmer","vcsparrow","vcfbiranch","bwstepfather","lccatalmav","lccoach","ccpolarm","ulenforcer",
	"ulcopcarul","ulpolmav","vcbloodrb","cccopbike","lvcopbike","sacopbike","sfcopbike","solroamer","decopcarru","vcsbulldozer","lcsdeimos",
	"lcsfbicar","atatnmav","bwbwnmav","ccccnmav","cmcmnmav","lclcnmav","mllmllnmav","ululnmav","lcstommy","bwdomestic","cmbloodh","ulwalton",
	"ugstanierr","ugsentinelr",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"ugsocialite","vcsocialite","lcsocialite","NoVeh","dash","NoVeh","NoVeh","NoVeh","NoVeh","cmarmymav","vcpolmav","lcpolmav",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"vcambulan","NoVeh","NoVeh","dukes","vcvcnmav","vcvcnvan","cmpolmav","NoVeh","NoVeh","NoVeh","NoVeh","cccopcarcc","cmcopcarcm",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","vcenforcer","lcenforcer","ccenforcer","cmenforcer",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"mwsultanrs","ulredwoo","ulcopcarul2","ccsadler","ughuntleys","ugpatrol","uggonzo","ccschafter","ccregina","ugdeluxo","ugbobcatxl","mwwarthog",
	"mwfalcon","mwmjolnir","vcsairtrain","mwhako","mwdefend",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","lcmonster","NoVeh","vcbanshee","lcpanlant","lcshellenbach","NoVeh","vccholo","NoVeh","NoVeh","NoVeh","NoVeh","ughydrag","ugarmhyd",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","lctrainf","vcscarab","lcbobcat","lcambulan","lcbanshee",
	"lcbarracks","lcbus","lccabbie","lccheetah","lcesperant","lcflatbed","lcinfernus","NoVeh","lclinerun","NoVeh","lcmanana","lcmoonbeam","lcmrwhoop","lcmule",
	"lcpatriot","lcperen","lcpony","lcrhino","lcsecurica","lcstallion","lcstretch","lctrash","lcyankee","vcadmiral","NoVeh","NoVeh",
	"vcbaggage","NoVeh","vcbarracks","vcbenson","vcbfinject","vcblistac","vcbloodra","vcbobcat","vcboxville","vcburrito","vcbus","vccabbie","vccaddy",
	"vccheetah","vccomet","NoVeh","NoVeh","NoVeh","vcesperant","vcfaggio","NoVeh","NoVeh","vcfiretruk","vcflatbed","vcfreeway","NoVeh",
	"uggreenwoor","vcglendale","vcgreenwoo","vchermes","vchotrina","vchotrinb","vchotring","NoVeh","vcinfernus","NoVeh","vclandstal","vclinerun",
	"NoVeh","vcmanana","vcmesa","vcmoonbeam","vcmrwhoop","vcmule","vcmule2","vcoceanic","vcpacker","vcpatriot","vcpcj600","vcperen","vcphoenix","vcpizzaboy","NoVeh",
	"vcpony","vcrancher","vcregina","vcrumpo","vcsabre","NoVeh","vcsanchez","vcsandking","vcsecurica","vcsentinel","NoVeh","NoVeh",                //a check
	"vcstallion","NoVeh","vcstretch","vctaxi","vctopfun","vctrash","vcvirgo","vcvoodoo","vcwalton","vcwashing","vcyankee","vcatv600","lcsv8ghost",
	"lctaxi","lcthunder","lcphobos","lcfiretruk","vclitwil","vccountach","vcarmadillo","vcaamb","lcpredator","lcreefer","lcrumpo","lcsentinel",
	"lcspeeder","lcstinger","lcbfinject","lcdodo","lcfbicar","NoVeh","vcsbmxboy","vcsbmxgirl","hydrab","NoVeh","NoVeh","NoVeh","NoVeh",
	"atambulan","mwcopcarmw1","solposher","solclovmon","mwambulan","atfiretruk","mwfiretruk","bwbus","bwdozer","bwforklift","ccluton","lctriads",
	"lcsairtrain","lcscopcarlc","lcsfaggio2","ugtampa","mwxenon","mwrebla","atdaemon","atcopcarat","atvoodoo",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","ccspeedo","ccambulan","solufo",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","bwcopcarbw","NoVeh","NoVeh",
	"bwambulan","bwfiretruk","vcstanier","bwstanier","bwtaxi","bwdelegate","bwairmax","bwcabbie","vccoastg","vcdinghy","vcjetmax","vcmarquis",
	"vcpredator","vcreefer","vcrio","vcspeeder","vcsqualo","vctropic","NoVeh","NoVeh","NoVeh","vcat4001","vcat4002","vcat4003","vcat4004","solkutt","soljamieshr",
	"solelevator","vcbiplane","vcbovver","vcyola","vcsspeeder","bwmower","soltowtruck","lcsrumpo","lcshoods","lcscampvan","solnrg500f","solnrg500rr",
	"bwreagan","solclover69","solsignum","lcstanier",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","solballer",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"lvenforcer","saenforcer","sfenforcer","lspolmav","lvpolmav","sfpolmav","ccccpdvan","ughellrais","cmbhburrito","mwpolmav","atpolmav","cmambulan",
	"lctrainr","cmfiretruk","lcbschoolbus","ccprisonbus","vcshamal","lccorpse","sabidaho","cmrhino","cmtaxi","NoVeh",
	"ccrhino","cmstanier","ccsecurica","lcclearjet","cmvoodoo","lcsperen","mhtailgater","mhyankee","lcsmanana","lcskuruma","lcsmafiab","lcspanlant",
    "lcspony","lcstoyz","lcsballot","lcsflatbed","atenforcer","mllenforcer","atfbisent","bwcopbike","mwcopcarmw2","mwbalmoral","cmadmiral","cmgreenwoo","ccboxville","mptranquility","lcshearse","mpvbloodr","mpcommy","cmkuruma","ughenry","mppolaris","bwstallion","cmburrito","mpdukesr","mpmajesticr",
	"mptahomar","mpsabrer","mpdeadwood","mpbcabbie","mpf1a","mpf1b","mpf1c","mppicadorr","mpfriscobl","lcsfiretruk","vcsfiretruk","NoVeh","NoVeh",
	"vccoach","cctuff","mpvcdinghyf","mpvcreeferf","mpvcfirehelif","mpvcfireunitf","mpvcfirelaf","mpvcfireamb","mpvcfirehzmtf","mpvcfirerescf",
	"vcsstinger","cmstinger","cmfbicar","ccfbicar","lcsrcbandit","vcrcgoblin","vcrcraider","vcrcbandit","vcrcbaron","lcrcbandit","mplifeguard",
	"vcscabbie","cmcabbie","cmblista","cmmilitiaenf","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"vcromero","mwcopbike","ugswtrailer","ugcaravana","mwpredator","uginsurrection",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"cmpredator","mplcdinghyf","mplcreeferf","mplcfireamb","mplcfireheli","mplcfirehzmt","mplcfirela","mplcfireresc","mplcfiretowt","mplcfiretruk",
	"mplcfireunit","vccturismo","ccbarracks","ccpatriot","cctrash","cmtrash","bwyankeea","bwyankeeb","bwfaggio","bwaquabike","bwbike","bwbmx",
	"bwbmxc","bwbmxr","bwbmxs","bwcustombike","bwmtbike","bwoladbike","bwracer","bwretro","cmreefer","vcspony","vcstopfun","vcsbenson","vcsboxville",
	"bwboxville","vcsquad","cmmule","cmmule2","bwkart","ccbus","lcsbullion",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"lcsspeeder","mwbarracks","mwbulletgt","mwcaldwell","mwcanyon","mwfbicanyo","mwprcanyon","mwcotmouth","mwdagger","mwdestino","mwfaction",
	"mwjuliette","mwlazer","mwlobodonk","mwpremier","mwschafter","mwdiamond","mwcntario","mwontario","mwtrash","mwzion",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"mwtaxi","cctrainf","cctrainr","mwprisonbus","lcsfaggio","lcspizzaboy","ccblistag","ccbolter","NoVeh",       //check
	"ccclover","ccemperor","NoVeh","ccpremier","cctampa","ccvoodoo","ccwhistle",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"mwcomet","mwcoquette","mwfiammetta","mwexsess","mwskimpy","mwsteed","artict4","cchauler","mwbug","NoVeh","mwpatriot","artict5","ccpython",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"vcsfreeway","vcsangel","vcsforklift","vcspatriot","mwtransit","ccannihilator","mwtexas","ccrumpo","mwstanier","mwveloce","uldeviant",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"mwdubsta","mwlokus","ccvanderlind","ccimperator",
	"NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh",
	"mwsteedvan","ccdinterc","mwmesa","cclandstal","ccreagan","ccsavanna","vcbcopcarvcb","lcsfreeway","ccbuffalo","mwinterstate","ulboyarin","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","NoVeh","ulblackline"
};

main(){}

public OnGameModeInit()
{
    SetCurrentSeason(SEASON_WINTER);
    AntiDeAMX();
	mysql_log(LOG_ERROR | LOG_WARNING);
	mysql = mysql_connect(host, user, db, pass);
	if(mysql_errno(mysql) != 0) { print("Could not connect to database!");}
	else {printf("Successfully connected on DB %s",db);}
	SetGameModeText("Apo 0.13.2");
	SendRconCommand("ackslimit 5000");
    SendRconCommand("hostname [4.2] Apocalyptica World (Pre-pre-Alpha release)");
	UsePlayerPedAnims();
    ManualVehicleEngineAndLights(); //vehicle on/off
	//DisableInteriorEnterExits();
	SetWeather(0);
	SetWorldTime(10);
    ShowPlayerMarkers(0);
    Iter_Init(PrivateVehicles);
    actorclanc();
    mapping();
    mysql_tquery(mysql, "SELECT * FROM `dropwep`", "loadwep", "");
    mysql_tquery(mysql, "SELECT * FROM `Vehicles` WHERE `vehOwner` = '-'", "LoadDealerVehicles", "");
    mysql_tquery(mysql, "SELECT * FROM `storage`", "loadstorage", "");
    mysql_tquery(mysql, "SELECT * FROM `objects`", "objects_Load", "");
    mysql_tquery(mysql, "SELECT * FROM `spawnpos`", "loadspawnpos", "");
    mysql_tquery(mysql, "SELECT * FROM `clans`", "loadclans", "");
    mysql_tquery(mysql, "SELECT * FROM `zones`", "loadzones", "");
    DCC_SetBotPresenceStatus(DO_NOT_DISTURB);
    DCC_SetBotActivity("Serveur charger!");
    GUILD_ID1 = DCC_FindGuildById(Ddiscord);
    discordlog = DCC_FindChannelById(Dchat); //chat general
    RoleJoueur = DCC_Role:DCC_FindRoleById(Dverifier);
	RoleStaff1 = DCC_Role:DCC_FindRoleById(Dadmin1);    //role
    AddPedModel(39000, "Hide","Hide","STAT_COWARD", PED_TYPE_COP, "man", "null", 0x1003, 0, 1, 4);
	return 1;
}
public OnGameModeExit()
{
	foreach(new i : ServerVehicles)
    {
        if(!strcmp(vInfo[i][vehOwner], "-") || strcmp(vInfo[i][vehOwner], "-"))
        {
            SaveVehicle(i);
            DestroyVehicle(vInfo[i][vehSessionID]);
        }
    }
    return 1;
}
public OnPlayerConnect(playerid)
{
	// resetting player enums so old's stats wont mix to new playerid
	for(new i; DATAX:i < DATAX; i++)
	{
 		pData[playerid][DATAX:i] = -1;
	}
    TogglePlayerSpectating(playerid, 1);
    SetPlayerHealth(playerid,10);
    SetPlayerInterior(playerid,0);
	IsPlayerRegisterd[playerid] = 0;
    Death[playerid] = 0;
    ResetPlayerWeapons(playerid);
	GetPlayerName(playerid, Name[playerid], 24); //Getting player's name
	GetPlayerIp(playerid, IP[playerid], 16); //Getting layer's IP
    //vie armure

	mysql_format(mysql, query, sizeof(query),"SELECT `IP`, `Password`, `ID` FROM `players` WHERE `Username` = '%e' LIMIT 1", Name[playerid]);
	mysql_tquery(mysql, query, "OnAccountCheck", "i", playerid);
	//deer
	inJOB[playerid] = 0;
	DistanceTD[playerid] = CreatePlayerTextDraw(playerid, 87.333358, 317.573242, "Distance_xxxM");
	PlayerTextDrawLetterSize(playerid, DistanceTD[playerid], 0.363428, 1.297067);
	PlayerTextDrawTextSize(playerid, DistanceTD[playerid], 0.000000, 111.000000);
	PlayerTextDrawAlignment(playerid, DistanceTD[playerid], 2);
	PlayerTextDrawColor(playerid, DistanceTD[playerid], -1);
	PlayerTextDrawUseBox(playerid, DistanceTD[playerid], 1);
	PlayerTextDrawBoxColor(playerid, DistanceTD[playerid], 112);
	PlayerTextDrawSetShadow(playerid, DistanceTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, DistanceTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DistanceTD[playerid], 189);
	PlayerTextDrawFont(playerid, DistanceTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, DistanceTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, DistanceTD[playerid], 0);
	PlayerTextDrawHide(playerid, DistanceTD[playerid]);
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	if(IsPlayerRegisterd[playerid] != 0)
	{
		SavePlayerData(playerid);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new Float:pPosX, Float:pPosY, Float:pPosZ;
	GetPlayerPos(playerid, pPosX, pPosY, pPosZ);
    for(new i_slot = 0, gun, ammo; i_slot != 12; i_slot++)
    {
        GetPlayerWeaponData(playerid, i_slot, gun, ammo);
        if(gun != 0 && ammo != 0) CreateDroppedGun(gun, ammo, pPosX+random(2)-random(2), pPosY+random(2)-random(2), pPosZ);
    }
    ResetPlayerWeapons(playerid);
    Death[playerid] = 1;
	return 1;
}
public OnPlayerUpdate(playerid)
{
	new target_actor = GetPlayerTargetActor(playerid);
	if (s_TargetActor[playerid] != target_actor)
	{
	    CallLocalFunction("OnPlayerTargetActor", "iii", playerid, target_actor, s_TargetActor[playerid]);
	    s_TargetActor[playerid] = target_actor;
	}
    new Float:health,Float:armour;
    GetPlayerHealth(playerid,health);
    GetPlayerArmour(playerid,armour);
    if (health >= 100.0) {SetPlayerHealth(playerid, 100.0);}
    if (armour >= 100.0) {SetPlayerArmour(playerid, 100.0);}
    return 1;
}
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if( hittype != BULLET_HIT_TYPE_NONE ) // Bullet Crashing uses just this hittype
	{
        if( !( -1000.0 <= fX <= 1000.0 ) || !( -1000.0 <= fY <= 1000.0 ) || !( -1000.0 <= fZ <= 1000.0 ) )
		{
			Kick(playerid);
			return 0;
		}
	}
	//deer
	if(Deer[playerid] == 1)
	{
		if(weaponid == 374)
		{
			if(hittype == BULLET_HIT_TYPE_OBJECT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 100.0, 8521.4727,13804.3506,3.8626) && Shoot_Deer[playerid] == 0)
				{
					KillTimer(Meeters_BTWDeer[playerid]);
					Meeter_Kill[playerid] = Meeters[playerid];
					Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
					if(Meeter_Kill[playerid] >= 20)
					{
						Shoot_Deer[playerid] = 1;
			  			MoveObject(Hunter_Deer[playerid], 8521.4727,13804.3506,3.8626, 3.5, -90.0000, 0.0000, 0.0000);
                        SendServerMessage(playerid,"You just kill a deer go collect his meat Press ~k~~SNEAK_ABOUT~ to take his meat");
			  			Deep_Deer[playerid] = 1;
       				}
					else
					{
			  			DestroyObject(Hunter_Deer[playerid]);
			  			SendServerMessage(playerid,"You shot too far the deer run off");
			  			DisablePlayerCheckpoint(playerid);
			  			SetTimerEx("Next_Deer", 1000, false, "i", playerid);
		  			}
		  		}
			}
		}
	}
	else if(Deer[playerid] == 2)
	{
        if(weaponid == 374)
		{
			if(hittype == BULLET_HIT_TYPE_OBJECT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 100.0, 8712.4287,14008.3896,2.0037) && Shoot_Deer[playerid] == 0) {
					KillTimer(Meeters_BTWDeer[playerid]);
					Meeter_Kill[playerid] = Meeters[playerid];
					Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
					if(Meeter_Kill[playerid] >= 20)
					{
						Shoot_Deer[playerid] = 1;
			  			MoveObject(Hunter_Deer[playerid], 8712.4287,14008.3896,2.0037, 3.5, -90.0000, 0.0000, 0.0000);
                        SendServerMessage(playerid,"You just kill a deer go collect his meat Press ~k~~SNEAK_ABOUT~ to take his meat");
			  			Deep_Deer[playerid] = 1;
					}
					else
					{
			  			DestroyObject(Hunter_Deer[playerid]);
						SendServerMessage(playerid,"You shot too far the deer run off");
			  			DisablePlayerCheckpoint(playerid);
			  			SetTimerEx("Next_Deer", 1000, false, "i", playerid);
					}
				}
			}
		}
	}
	else if(Deer[playerid] == 3)
	{
        if(weaponid == 374)
		{
			if(hittype == BULLET_HIT_TYPE_OBJECT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 100.0, 8704.8564,14117.2051,4.8480) && Shoot_Deer[playerid] == 0) {
					KillTimer(Meeters_BTWDeer[playerid]);
					Meeter_Kill[playerid] = Meeters[playerid];
					Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
					if(Meeter_Kill[playerid] >= 20)
					{
						Shoot_Deer[playerid] = 1;
			  			MoveObject(Hunter_Deer[playerid], 8704.8564,14117.2051,4.8480, 3.5, 90.00000, 0.00000, -54.66002);
                        SendServerMessage(playerid,"You just kill a deer go collect his meat Press ~k~~SNEAK_ABOUT~ to take his meat");
			  			Deep_Deer[playerid] = 1;
					}
					else
					{
						DestroyObject(Hunter_Deer[playerid]);
						SendServerMessage(playerid,"You shot too far the deer run off");
			  			DisablePlayerCheckpoint(playerid);
			  			SetTimerEx("Next_Deer", 1000, false, "i", playerid);
					}
				}
			}
		}
	}
	else if(Deer[playerid] == 4)
	{
        if(weaponid == 374)
		{
			if(hittype == BULLET_HIT_TYPE_OBJECT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 100.0, 8729.0361,14638.2578,15.9921) && Shoot_Deer[playerid] == 0) {
					KillTimer(Meeters_BTWDeer[playerid]);
					Meeter_Kill[playerid] = Meeters[playerid];
					Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
					if(Meeter_Kill[playerid] >= 20)
					{
						Shoot_Deer[playerid] = 1;
			  			MoveObject(Hunter_Deer[playerid], 8729.0361,14638.2578,15.9921, 3.5, 90.00000, 0.00000, -7.38000);
                        SendServerMessage(playerid,"You just kill a deer go collect his meat Press ~k~~SNEAK_ABOUT~ to take his meat");
			  			Deep_Deer[playerid] = 1;
					}
					else
					{
						DestroyObject(Hunter_Deer[playerid]);
						SendServerMessage(playerid,"You shot too far the deer run off");
			  			DisablePlayerCheckpoint(playerid);
			  			SetTimerEx("Next_Deer", 1000, false, "i", playerid);
					}
				}
			}
		}
	}
	else if(Deer[playerid] == 5)
	{
        if(weaponid == 374)
		{
			if(hittype == BULLET_HIT_TYPE_OBJECT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 100.0, 8597.6152,14805.4805,23.4484) && Shoot_Deer[playerid] == 0) {
					KillTimer(Meeters_BTWDeer[playerid]);
					Meeter_Kill[playerid] = Meeters[playerid];
					Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
					if(Meeter_Kill[playerid] >= 20)
					{
						Shoot_Deer[playerid] = 1;
			  			MoveObject(Hunter_Deer[playerid], 8597.6152,14805.4805,23.4484, 3.5, 90.00000, 0.00000, 0.00000);
                        SendServerMessage(playerid,"You just kill a deer go collect his meat Press ~k~~SNEAK_ABOUT~ to take his meat");
			  			Deep_Deer[playerid] = 1;
					}
					else
					{
						DestroyObject(Hunter_Deer[playerid]);
						SendServerMessage(playerid,"You shot too far the deer run off");
			  			DisablePlayerCheckpoint(playerid);
			  			SetTimerEx("Next_Deer", 1000, false, "i", playerid);
					}
				}
			}
		}
	}
	else if(Deer[playerid] == 6)
	{
        if(weaponid == 374)
		{
			if(hittype == BULLET_HIT_TYPE_OBJECT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 100.0, 8800.6748,13836.8525,2.4051) && Shoot_Deer[playerid] == 0) {
					KillTimer(Meeters_BTWDeer[playerid]);
					Meeter_Kill[playerid] = Meeters[playerid];
					Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
					if(Meeter_Kill[playerid] >= 20)
					{
						Shoot_Deer[playerid] = 1;
			  			MoveObject(Hunter_Deer[playerid], 8800.6748,13836.8525,2.4051, 3.5, 90.00000, 0.00000, -49.26000);
                        SendServerMessage(playerid,"You just kill a deer go collect his meat Press ~k~~SNEAK_ABOUT~ to take his meat");
			  			Deep_Deer[playerid] = 1;
					}
					else
					{
						DestroyObject(Hunter_Deer[playerid]);
						SendServerMessage(playerid,"You shot too far the deer run off");
			  			DisablePlayerCheckpoint(playerid);
			  			SetTimerEx("Next_Deer", 1000, false, "i", playerid);
					}
				}
			}
		}
	}
	return 1;
}
public OnPlayerSpawn(playerid)
{
	//skill
	SetPlayerSkillLevel(playerid,WEAPONSKILL_PISTOL,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_PISTOL_SILENCED,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_DESERT_EAGLE,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SHOTGUN,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SAWNOFF_SHOTGUN,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SPAS12_SHOTGUN,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_MICRO_UZI,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_MP5,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_AK47,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_M4,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SNIPERRIFLE,200);
    SetPlayerSkin(playerid,pData[playerid][skin]);
    //vie armure
	SetPlayerHealth(playerid,pData[playerid][Life]);
	SetPlayerArmour(playerid,pData[playerid][Armor]);
    if(Death[playerid] == 1)
	{
        SetPlayerInterior(playerid,0);
        ResetPlayerWeapons(playerid);
        switch (random(11))
		{
		    case 0: SetPlayerPos(playerid,8407.2646,14237.7061,7.2450);
            case 1: SetPlayerPos(playerid,8727.8994,14177.2285,6.5179);
            case 2: SetPlayerPos(playerid,8736.6973,14540.8691,20.9074);
            case 3: SetPlayerPos(playerid,8753.6191,14745.8828,20.6171);
            case 4: SetPlayerPos(playerid,8899.8818,14185.7197,10.4728);
            case 5: SetPlayerPos(playerid,8826.0381,13874.9414,3.5700);
            case 6: SetPlayerPos(playerid,8848.6006,13693.5068,1.7304);
            case 7: SetPlayerPos(playerid,8695.3877,13846.2305,4.9028);
            case 8: SetPlayerPos(playerid,8384.9932,13899.8945,3.9312);
            case 9: SetPlayerPos(playerid,8233.5928,13787.6973,2.3971);
            case 10: SetPlayerPos(playerid,8281.4336,13877.2793,1.3771);
            case 11: SetPlayerPos(playerid,8834.0010,13775.2080,5.4625);
        }
        Death[playerid] = 0;
    }
    else
    {
        SetPlayerInterior(playerid,pData[playerid][interior]);
        SetPlayerPos(playerid,pData[playerid][Pos][0],pData[playerid][Pos][1],pData[playerid][Pos][2]);
        SendServerMessage(playerid,"Hello player this server is on very-very-very early stage keep that in mind");
        for(new i = 0; i <= 12; i++) GivePlayerWeapon(playerid, pData[playerid][Guns][i], pData[playerid][Ammo][i]);
    }
    return 1;
}
public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
    if(GetVehicleDistanceFromPoint(vehicleid, new_x, new_y, new_z) > 3)
    {
        new id = Iter_Free(ServerVehicles);
		SetVehicleHealth(vehicleid,1000.0);
        SetVehicleToRespawn(vInfo[id][vehSessionID]);
        return 0;
    }
    return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
    SetSpawnInfo(playerid,2,0,0,0,0,0,0,0,0,0,0,0), SpawnPlayer(playerid);
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if (newkeys & KEY_YES && IsPlayerRegisterd[playerid] == 1)
	{
     	switch (GetEngineStatus(vehicleid))
  		{
   			case false: SetEngineStatus(vehicleid, true);
   			case true: SetEngineStatus(vehicleid, false);
  		}
    }
	if (newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK)
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
			new f = MAX_SPAWNPOS+1;
			for(new a = 0; a < MAX_SPAWNPOS; a++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.0, dspawnpos[a][Pos][0], dspawnpos[a][Pos][1], dspawnpos[a][Pos][2]) && IsValidDynamicObject(dspawnpos[a][Objects]))
				{
					f = a;
					break;
				}
			}
			if(f > MAX_SPAWNPOS) return SendClientMessage(playerid, COLOR_RED, "You are not near an object that you can pick up.");
			switch(random(39))
			{
				//melee
				case 0: GivePlayerWeapon(playerid,286,random(2)+1);
                case 1: GivePlayerWeapon(playerid,312,random(2)+1);
				//pistol
				case 2: GivePlayerWeapon(playerid,254,random(5)+1);
				case 3: GivePlayerWeapon(playerid,261,random(5)+1);
				//smg
				case 4: GivePlayerWeapon(playerid,263,random(10)+1);
				case 5: GivePlayerWeapon(playerid,285,random(25)+1);
				case 6: GivePlayerWeapon(playerid,225,random(12)+1);
                case 7: GivePlayerWeapon(playerid,418,random(10)+1);
				//rifle
				case 8: GivePlayerWeapon(playerid,256,random(5)+1);
				case 9: GivePlayerWeapon(playerid,228,random(5)+1);
                case 10: GivePlayerWeapon(playerid,259,random(5)+1);
                case 11: GivePlayerWeapon(playerid,374,random(5)+1);
				//inventaire
				case 12: pData[playerid][inv][1] +=random(3)+1;
				case 13: pData[playerid][inv][2] +=random(3)+1;
				case 14: pData[playerid][inv][3] +=random(3)+1;
				case 15: pData[playerid][inv][4] +=random(3)+1;
				case 16: pData[playerid][inv][5] +=random(3)+1;
				case 17: pData[playerid][inv][6] +=random(3)+1;
				case 18: pData[playerid][inv][7] +=random(3)+1;
				case 19: pData[playerid][inv][8] +=random(3)+1;
				case 20: pData[playerid][inv][9] +=random(3)+1;
				case 21: pData[playerid][inv][10] +=random(3)+1;
				case 22: pData[playerid][inv][11] +=random(3)+1;
				case 23: pData[playerid][inv][12] +=random(3)+1;
				case 24: pData[playerid][inv][13] +=random(3)+1;
				case 25: pData[playerid][inv][14] +=random(3)+1;
				case 26: pData[playerid][inv][15] +=random(3)+1;
				case 27: pData[playerid][inv][16] +=random(3)+1;
				case 28: pData[playerid][inv][17] +=random(3)+1;
				case 29: pData[playerid][inv][18] +=random(3)+1;
				case 30: pData[playerid][inv][19] +=random(3)+1;
				case 31: pData[playerid][inv][20] +=random(3)+1;
				case 32: pData[playerid][inv][21] +=random(3)+1;
				case 33: pData[playerid][inv][22] +=random(3)+1;
				case 34: pData[playerid][inv][23] +=random(3)+1;
				case 35: pData[playerid][inv][24] +=random(3)+1;
				case 36: pData[playerid][inv][25] +=random(3)+1;
                case 37: ShowModelSelectionMenu(playerid, "Skins", MODEL_SELECTION_SKIN, Skinsskins, sizeof(Skinsskins), -16.0, 0.0, -55.0);
                //grenade
                case 38: GivePlayerWeapon(playerid,281,1);
			}
			DestroyDynamicObject(dspawnpos[f][Objects]);
			SendClientMessage(playerid, COLOR_GREEN, "You have picked up an object.");
			return 1;
		}
	}
	//deer
	if(PRESSED(KEY_WALK))
	{
	 	if(Deep_Deer[playerid] == 1)
		{
	 	    DisablePlayerCheckpoint(playerid);
		 	if(IsPlayerInRangeOfPoint(playerid, 3.5, 8521.4727,13804.3506,4.8626) && Deer[playerid] == 1)
			{
		 		TogglePlayerControllable(playerid, 0);
		 		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 1, 1, 1, 1, 0);
		 		Deep_Deer[playerid] = 0;
		 		KillTimer(Meeters_BTWDeer[playerid]);
		 		Shoot_Deer[playerid] = 0;
		 		SetTimerEx("Done_Deer", 3500, false, "d",playerid);
		 	}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 8712.4287,14008.3896,3.0037) && Deer[playerid] == 2)
			{
		 		TogglePlayerControllable(playerid, 0);
		 		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 1, 1, 1, 1, 0);
		 		Deep_Deer[playerid] = 0;
		 		KillTimer(Meeters_BTWDeer[playerid]);
				Shoot_Deer[playerid] = 0;
		 		SetTimerEx("Done_Deer", 3500, false, "d",playerid);
		 	}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 8704.8564,14117.2051,5.8480) && Deer[playerid] == 3)
			{
		 		TogglePlayerControllable(playerid, 0);
		 		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 1, 1, 1, 1, 0);
		 		Deep_Deer[playerid] = 0;
		 		KillTimer(Meeters_BTWDeer[playerid]);
				Shoot_Deer[playerid] = 0;
		 		SetTimerEx("Done_Deer", 3500, false, "d",playerid);
		 	}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 8729.0361,14638.2578,16.9921) && Deer[playerid] == 4)
			{
		 		TogglePlayerControllable(playerid, 0);
		 		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 1, 1, 1, 1, 0);
		 		Deep_Deer[playerid] = 0;
		 		KillTimer(Meeters_BTWDeer[playerid]);
				Shoot_Deer[playerid] = 0;
		 		SetTimerEx("Done_Deer", 3500, false, "d",playerid);
		 	}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 8597.6152,14805.4805,24.4484) && Deer[playerid] == 5)
			{
		 		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 1, 1, 1, 1, 0);
		 		TogglePlayerControllable(playerid, 0);
		 		Deep_Deer[playerid] = 0;
		 		KillTimer(Meeters_BTWDeer[playerid]);
				Shoot_Deer[playerid] = 0;
		 		SetTimerEx("Done_Deer", 3500, false, "d",playerid);
		 	}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 8800.6748,13836.8525,3.4051) && Deer[playerid] == 6)
			{
		 		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 1, 1, 1, 1, 0);
		 		TogglePlayerControllable(playerid, 0);
		 		Deep_Deer[playerid] = 0;
		 		KillTimer(Meeters_BTWDeer[playerid]);
				Shoot_Deer[playerid] = 0;
		 		SetTimerEx("Done_Deer", 3500, false, "d",playerid);
		 	}
		}
	}
    return 1;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
	foreach(new i : ServerVehicles) { SaveVehicle(i);}
	foreach(new i : PrivateVehicles[playerid]) {SaveVehicle(i);}
    return 1;
}
public OnVehicleMod(playerid, vehicleid, componentid)
{
	foreach(new i : PrivateVehicles[playerid])
    {
        if(IsPlayerInVehicle(playerid, vInfo[i][vehSessionID]))
        {
            if(!strcmp(vInfo[i][vehOwner], GetName(playerid)))
            {
                for(new x; x < 14; x++) { if(GetVehicleComponentType(componentid) == x) { vInfo[i][vehMod][x] = componentid; } }
                SaveVehicle(i);
            }
        }
    }
	return 1;
}
public OnVehicleSpawn(vehicleid)
{
    foreach(new playerid : Player)
    {
        foreach(new i : PrivateVehicles[playerid])
        {
            for(new x = 0; x < 14; x++)
            {
                if(!strcmp(vInfo[i][vehOwner], GetName(playerid))) { if(vInfo[i][vehMod][x] > 0) AddVehicleComponent(vInfo[i][vehSessionID], vInfo[i][vehMod][x]); }
            }
        }
    }
    return 1;
}
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    foreach(new i : PrivateVehicles[playerid])
    {
        if(IsPlayerInVehicle(playerid, vInfo[i][vehSessionID]))
        {
            if(!strcmp(vInfo[i][vehOwner], GetName(playerid)))
            {
                vInfo[i][vehColorOne] = color1;
                vInfo[i][vehColorTwo] = color2;
                ChangeVehicleColor(vInfo[i][vehSessionID], vInfo[i][vehColorOne], vInfo[i][vehColorTwo]);
                SaveVehicle(i);
            }
        }
    }
    return 0;
}
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if (response == EDIT_RESPONSE_FINAL)
	{
	    if (pData[playerid][pEditobjects] != -1 && objectsData[pData[playerid][pEditobjects]][objectsExists])
	    {
	        switch (pData[playerid][pEditType])
	        {
	            case 1:
	            {
	                new id = pData[playerid][pEditobjects];
	                objectsData[pData[playerid][pEditobjects]][objectsPos][0] = x;
	                objectsData[pData[playerid][pEditobjects]][objectsPos][1] = y;
	                objectsData[pData[playerid][pEditobjects]][objectsPos][2] = z;
	                objectsData[pData[playerid][pEditobjects]][objectsPos][3] = rx;
	                objectsData[pData[playerid][pEditobjects]][objectsPos][4] = ry;
	                objectsData[pData[playerid][pEditobjects]][objectsPos][5] = rz;
	                DestroyDynamicObject(objectsData[id][objectsOb]);
					objectsData[id][objectsOb] = CreateDynamicObject(objectsData[id][objectsModel], objectsData[id][objectsPos][0], objectsData[id][objectsPos][1], objectsData[id][objectsPos][2], objectsData[id][objectsPos][3], objectsData[id][objectsPos][4], objectsData[id][objectsPos][5], objectsData[id][objectsWorld], objectsData[id][objectsInterior]);
					objects_Save(id);
                    SendServerMessage(playerid, "You have modify the position of the object ID: %d.", id);
				}
	            case 2:
	            {
	                new id = pData[playerid][pEditobjects];
                    new Float:oldx = dStorage[id][Pos][0];
                    new Float:oldy = dStorage[id][Pos][1];
                    new Float:oldz = dStorage[id][Pos][2];
	                dStorage[pData[playerid][pEditobjects]][Pos][0] = x;
	                dStorage[pData[playerid][pEditobjects]][Pos][1] = y;
	                dStorage[pData[playerid][pEditobjects]][Pos][2] = z;
	                dStorage[pData[playerid][pEditobjects]][Pos][3] = rx;
	                dStorage[pData[playerid][pEditobjects]][Pos][4] = ry;
	                dStorage[pData[playerid][pEditobjects]][Pos][5] = rz;
	                DestroyDynamicObject(dStorage[id][objects]);
                    switch (dStorage[id][typesize])
                    {
                        case 1: dStorage[id][objects] = CreateDynamicObject(2694, dStorage[id][Pos][0], dStorage[id][Pos][1], dStorage[id][Pos][2], dStorage[id][Pos][3], dStorage[id][Pos][4], dStorage[id][Pos][5],-1,-1);
                        case 2: dStorage[id][objects] = CreateDynamicObject(1271, dStorage[id][Pos][0], dStorage[id][Pos][1], dStorage[id][Pos][2], dStorage[id][Pos][3], dStorage[id][Pos][4], dStorage[id][Pos][5],-1,-1);
                        case 3: dStorage[id][objects] = CreateDynamicObject(3798, dStorage[id][Pos][0], dStorage[id][Pos][1], dStorage[id][Pos][2], dStorage[id][Pos][3], dStorage[id][Pos][4], dStorage[id][Pos][5],-1,-1);
                        case 4: dStorage[id][objects] = CreateDynamicObject(3799, dStorage[id][Pos][0], dStorage[id][Pos][1], dStorage[id][Pos][2], dStorage[id][Pos][3], dStorage[id][Pos][4], dStorage[id][Pos][5],-1,-1);
                    }
    	            mysql_format(mysql, query, sizeof(query), "UPDATE `storage` SET `posx`=%.4f,`posy`=%.4f,`posz`=%.4f,`posrx`=%.4f,`posry`=%.4f,`posrz`=%.4f WHERE CONCAT(`storage`.`posx`)=%.4f AND CONCAT(`storage`.`posy`)=%.4f AND CONCAT(`storage`.`posz`)=%.4f" ,x,y,z,rx,ry,rz,oldx,oldy,oldz);
    	            mysql_tquery(mysql, query, "", "");
                    SendServerMessage(playerid, "You have modify the position of the storage");
				}
			}
		}
	}
	if (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL)
	{
	    pData[playerid][pEditobjects] = -1;
	}
	return 1;
}
public OnPlayerEnterDynamicArea(playerid, areaid)
{
    new e;
    if(0 <= e < MAX_ZONE)
 	{
        if(pData[playerid][Admin] <= 3) return SendServerMessage(playerid,"Area %s Clan ID : %d",zone[e][namezone],zone[e][clanid]);
    }
    return 1;
}

public OnModelSelectionResponse(playerid, extraid, index, modelid, response)
{
	if ((response) && (extraid == MODEL_SELECTION_SKIN))
	{
	    pData[playerid][skin] = modelid;
	    SetPlayerSkin(playerid, modelid);
	}
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(pData[playerid][Admin] <= 1) return 0;
    SetPlayerPos(playerid,fX,fY,fZ);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    return 1;
}
script OnPlayerTargetActor(playerid, newtarget, oldtarget)
{
    if (newtarget == missionactor[1])
    {
        Dialog_Show(playerid, Missionclan0, DIALOG_STYLE_LIST, "Mission", "Go get some meat!\n{0f5900}Quest validation.{FFFFFF}\nQuest 2\n{0f5900}Quest validation.{FFFFFF}\nQuest 3\n{0f5900}Quest validation.{FFFFFF}\nQuest 4\n{0f5900}Quest validation.{FFFFFF}\nQuest 5\n{0f5900}Quest validation.{FFFFFF}\nLevel Up", "Valider", "Quitter");
    }
    if (oldtarget != INVALID_ACTOR_ID) {ClearActorAnimations(oldtarget);}
    return 1;
}
script OnAccountLoad(playerid)
{
 	pData[playerid][Admin] = cache_get_field_content_int(0, "Admin"); //we're getting a field 4 from row 0. And since it's an integer, we use cache_get_row_int
 	pData[playerid][VIP] = cache_get_field_content_int(0, "VIP"); //Above
	pData[playerid][Life] =	cache_get_field_content_float(0, "Life");
	pData[playerid][Armor]  =	cache_get_field_content_float(0, "Armor");
    pData[playerid][skin]   =	cache_get_field_content_int(0, "skin");
    pData[playerid][Pos][0] =	cache_get_field_content_float(0, "posx");
    pData[playerid][Pos][1] =	cache_get_field_content_float(0, "posy");
    pData[playerid][Pos][2] =	cache_get_field_content_float(0, "posz");
    pData[playerid][interior]   =	cache_get_field_content_int(0, "interior");
	pData[playerid][clanexp][0] =	cache_get_field_content_int(0, "clanexp0");
    pData[playerid][clanexp][1] =	cache_get_field_content_int(0, "clanexp1");
    pData[playerid][clanexp][2] =	cache_get_field_content_int(0, "clanexp2");
    pData[playerid][clanexp][3] =	cache_get_field_content_int(0, "clanexp3");
    pData[playerid][clanexp][4] =	cache_get_field_content_int(0, "clanexp4");
    pData[playerid][inv][0] =	cache_get_field_content_int(0, "inv0");
    pData[playerid][inv][1] =	cache_get_field_content_int(0, "inv1");
    pData[playerid][inv][2] =	cache_get_field_content_int(0, "inv2");
    pData[playerid][inv][3] =	cache_get_field_content_int(0, "inv3");
    pData[playerid][inv][4] =	cache_get_field_content_int(0, "inv4");
    pData[playerid][inv][5] =	cache_get_field_content_int(0, "inv5");
    pData[playerid][inv][6] =	cache_get_field_content_int(0, "inv6");
    pData[playerid][inv][7] =	cache_get_field_content_int(0, "inv7");
    pData[playerid][inv][8] =	cache_get_field_content_int(0, "inv8");
    pData[playerid][inv][9] =	cache_get_field_content_int(0, "inv9");
    pData[playerid][inv][10] =	cache_get_field_content_int(0, "inv10");
    pData[playerid][inv][11] =	cache_get_field_content_int(0, "inv11");
    pData[playerid][inv][12] =	cache_get_field_content_int(0, "inv12");
    pData[playerid][inv][13] =	cache_get_field_content_int(0, "inv13");
    pData[playerid][inv][14] =	cache_get_field_content_int(0, "inv14");
    pData[playerid][inv][15] =	cache_get_field_content_int(0, "inv15");
    pData[playerid][inv][16] =	cache_get_field_content_int(0, "inv16");
    pData[playerid][inv][17] =	cache_get_field_content_int(0, "inv17");
    pData[playerid][inv][18] =	cache_get_field_content_int(0, "inv18");
    pData[playerid][inv][19] =	cache_get_field_content_int(0, "inv19");
    pData[playerid][inv][20] =	cache_get_field_content_int(0, "inv20");
    pData[playerid][inv][21] =	cache_get_field_content_int(0, "inv21");
    pData[playerid][inv][22] =	cache_get_field_content_int(0, "inv22");
    pData[playerid][inv][23] =	cache_get_field_content_int(0, "inv23");
    pData[playerid][inv][24] =	cache_get_field_content_int(0, "inv24");
    pData[playerid][inv][25] =	cache_get_field_content_int(0, "inv25");
 	pData[playerid][Score] = cache_get_field_content_int(0, "Score");
 	SetPlayerScore(playerid, pData[playerid][Score]);
    //vie armure
	SetPlayerHealth(playerid,pData[playerid][Life]);
	SetPlayerArmour(playerid,pData[playerid][Armor]);
 	//For player's position, set it once they spawn(OnPlayerSpawn)
	SendClientMessage(playerid, -1, "Successfully logged in"); //tell them that they have successfully logged in
    TogglePlayerSpectating(playerid, 0);
    //weapons
	new szTmp[64];
    for(new i = 0; i <= 12; i++)
	{
	    format(szTmp, sizeof(szTmp), "Weap%d", i);
        pData[playerid][Guns][i] = cache_get_field_content_int(0 , szTmp);
    	format(szTmp, sizeof(szTmp), "AWeap%d", i);
        pData[playerid][Ammo][i] = cache_get_field_content_int(0 , szTmp);
	}
    //vehicle after
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `Vehicles` WHERE `vehOwner` = '%e'", GetName(playerid));
    mysql_tquery(mysql, query, "LoadPlayerVehicles", "i", playerid);
	return 1;
}

script SavePlayerData(playerid)
{
	//vie armure pos
    new intint = GetPlayerInterior(playerid),tmpPlayerWeapons[13][2],tmpString[64];
    for(new i = 0; i <= 12; i++)
	{
	    GetPlayerWeaponData(playerid, i, tmpPlayerWeapons[i][0], tmpPlayerWeapons[i][1]);
	}
	GetPlayerHealth(playerid,pData[playerid][Life]);
	GetPlayerArmour(playerid,pData[playerid][Armor]);
    GetPlayerPos(playerid,pData[playerid][Pos][0],pData[playerid][Pos][1],pData[playerid][Pos][2]);
	mysql_format(mysql, query, sizeof(query), "UPDATE `players` SET `IP`='%s', `Admin`=%d, `VIP`=%d, `Score`=%d,`Life` = %.4f,`Armor` = %.4f,`skin`=%d, `posx` = %.4f,`posy` = %.4f,`posz` = %.4f,`interior`=%d,\
    `clanexp0`=%d,`clanexp1`=%d,`clanexp2`=%d,`clanexp3`=%d,`clanexp4`=%d,`inv0`=%d,`inv1`=%d,`inv2`=%d,`inv3`=%d,`inv4`=%d,`inv5`=%d,`inv6`=%d,`inv7`=%d,`inv8`=%d,`inv9`=%d,\
	`inv10`=%d,`inv11`=%d,`inv12`=%d,`inv13`=%d,`inv14`=%d,`inv15`=%d,`inv16`=%d,`inv17`=%d,`inv18`=%d,`inv19`=%d,\
    `inv20`=%d,`inv21`=%d,`inv22`=%d,`inv23`=%d,`inv24`=%d,`inv25`=%d \
     WHERE `ID`=%d",\
	IP[playerid], pData[playerid][Admin], pData[playerid][VIP], GetPlayerScore(playerid),pData[playerid][Life],pData[playerid][Armor],pData[playerid][skin],\
    pData[playerid][Pos][0],pData[playerid][Pos][1],pData[playerid][Pos][2],intint,\
    pData[playerid][clanexp][0],pData[playerid][clanexp][1],pData[playerid][clanexp][2],pData[playerid][clanexp][3],pData[playerid][clanexp][4],\
    pData[playerid][inv][0],pData[playerid][inv][1],pData[playerid][inv][2],pData[playerid][inv][3],pData[playerid][inv][4],pData[playerid][inv][5],\
    pData[playerid][inv][6],pData[playerid][inv][7],pData[playerid][inv][8],pData[playerid][inv][9],pData[playerid][inv][10],\
    pData[playerid][inv][11],pData[playerid][inv][12],pData[playerid][inv][13],pData[playerid][inv][14],pData[playerid][inv][15],\
    pData[playerid][inv][16],pData[playerid][inv][17],pData[playerid][inv][18],pData[playerid][inv][19],pData[playerid][inv][20],\
    pData[playerid][inv][21],pData[playerid][inv][22],pData[playerid][inv][23],pData[playerid][inv][24],pData[playerid][inv][25],\
    pData[playerid][ID]);
	mysql_tquery(mysql, query, "", "");
    for(new i = 0; i <= 12; i++)
	{
	    format(tmpString, sizeof(tmpString), "Weap%d", i);
    	mysql_format(mysql, query, sizeof(query), "UPDATE `players` SET `%s`=%d WHERE `ID`=%d" ,tmpString , tmpPlayerWeapons[i][0] , pData[playerid][ID]);
    	mysql_tquery(mysql, query, "", "");
    	format(tmpString, sizeof(tmpString), "AWeap%d", i);
    	mysql_format(mysql, query, sizeof(query), "UPDATE `players` SET `%s`=%d WHERE `ID`=%d" ,tmpString , tmpPlayerWeapons[i][1] , pData[playerid][ID]);
    	mysql_tquery(mysql, query, "", "");
	}
	foreach(new i : PrivateVehicles[playerid])
    {
        if(!strcmp(vInfo[i][vehOwner], GetName(playerid)))
        {
            SaveVehicle(i);
            DestroyVehicle(vInfo[i][vehSessionID]);
            Iter_Remove(ServerVehicles, i);
        }
    }
	//let's execute the query.
}

script OnAccountCheck(playerid)
{
	new rows, fields; //a variable that will be used to retrieve rows and fields in the database.
	cache_get_data(rows, fields, mysql);//let's get the rows and fields from the database.
	if(rows) //if there is row
	{
		cache_get_field_content(0, "IP", IP[playerid], mysql, 16);
		new newIP[16];
		GetPlayerIp(playerid, newIP, 16);
		IsPlayerRegisterd[playerid] = 1;
		(!strlen(IP[playerid]) || strcmp(IP[playerid], newIP, true));
		cache_get_field_content(0, "Password", pData[playerid][Password], mysql, 129);
		pData[playerid][ID] = cache_get_field_content_int(0, "ID"); //now let's load player's ID into pData[playerid][ID] so we can use it later
		Dialog_Show(playerid, dLOGIN, DIALOG_STYLE_PASSWORD, "Login", "In order to play, you need to login", "Login", "Quit"); //And since we found a result from the database, which means, there is an account; we will show a login dialog
	}
	else //if we didn't find any rows from the database, that means, no accounts were found
	{
		Dialog_Show(playerid, dREGISTER, DIALOG_STYLE_PASSWORD, "Register", "In order to play, you need to register.", "Register", "Quit");
	}
	return 1;
}

script OnAccountRegister(playerid)
{
    pData[playerid][ID] = cache_insert_id(); //loads the ID of the player in the variable once they registered.
    printf("New account registered. ID: %d", pData[playerid][ID]); //just for debugging.
	pData[playerid][Life] = 100;
	pData[playerid][Armor] = 0;
	SetPlayerHealth(playerid,100);
	SetPlayerArmour(playerid,0);
    ResetPlayerWeapons(playerid);
    SpawnPlayer(playerid);
    return 1;
}
script loadwep()
{
    new rows,fields;
    cache_get_data(rows, fields);
    for (new f = 0; f < rows; f ++) if (f < MAX_OBJ)
    {
        dGunData[f][ObjPos][0] = cache_get_field_content_float(f,"posx");
        dGunData[f][ObjPos][1] = cache_get_field_content_float(f,"posy");
        dGunData[f][ObjPos][2] = cache_get_field_content_float(f,"posz");
        dGunData[f][ObjData][0] = cache_get_field_content_int(f, "gunid");
        dGunData[f][ObjData][1] = cache_get_field_content_int(f, "gunammo");
        dGunData[f][ObjID] = CreateObject(GunObjects[dGunData[f][ObjData][0]], dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2], 93.7, 120.0, 120.0);
    }
    return true;
}
script loadstorage()
{
    new rows,fields;
    cache_get_data(rows, fields);
    for (new f = 0; f < rows; f ++) if (f < MAX_STORAGE)
    {
        dStorage[f][typesize] = cache_get_field_content_int(f, "typesize");
        dStorage[f][lock] = cache_get_field_content_int(f, "lock");
        dStorage[f][Pos][0] = cache_get_field_content_float(f,"posx");
        dStorage[f][Pos][1] = cache_get_field_content_float(f,"posy");
        dStorage[f][Pos][2] = cache_get_field_content_float(f,"posz");
        dStorage[f][Pos][3] = cache_get_field_content_float(f,"posrx");
        dStorage[f][Pos][4] = cache_get_field_content_float(f,"posry");
        dStorage[f][Pos][5] = cache_get_field_content_float(f,"posrz");
        dStorage[f][inv][0] = cache_get_field_content_int(f, "inv0"); //vip stuff storage
        dStorage[f][inv][1] = cache_get_field_content_int(f, "inv1");
        dStorage[f][inv][2] = cache_get_field_content_int(f, "inv2");
        dStorage[f][inv][3] = cache_get_field_content_int(f, "inv3");
        dStorage[f][inv][4] = cache_get_field_content_int(f, "inv4");
        dStorage[f][inv][5] = cache_get_field_content_int(f, "inv5");
        dStorage[f][inv][6] = cache_get_field_content_int(f, "inv6");
        dStorage[f][inv][7] = cache_get_field_content_int(f, "inv7");
        dStorage[f][inv][8] = cache_get_field_content_int(f, "inv8");
        dStorage[f][inv][9] = cache_get_field_content_int(f, "inv9");
        dStorage[f][inv][10] = cache_get_field_content_int(f, "inv10");
        dStorage[f][inv][11] = cache_get_field_content_int(f, "inv11");
        dStorage[f][inv][12] = cache_get_field_content_int(f, "inv12");
        dStorage[f][inv][13] = cache_get_field_content_int(f, "inv13");
        dStorage[f][inv][14] = cache_get_field_content_int(f, "inv14");
        dStorage[f][inv][15] = cache_get_field_content_int(f, "inv15");
        dStorage[f][inv][16] = cache_get_field_content_int(f, "inv16");
        dStorage[f][inv][17] = cache_get_field_content_int(f, "inv17");
        dStorage[f][inv][18] = cache_get_field_content_int(f, "inv18");
        dStorage[f][inv][19] = cache_get_field_content_int(f, "inv19");
        dStorage[f][inv][20] = cache_get_field_content_int(f, "inv20");
        dStorage[f][inv][21] = cache_get_field_content_int(f, "inv21");
        dStorage[f][inv][22] = cache_get_field_content_int(f, "inv22");
        dStorage[f][inv][23] = cache_get_field_content_int(f, "inv23");
        dStorage[f][inv][24] = cache_get_field_content_int(f, "inv24");
        dStorage[f][inv][25] = cache_get_field_content_int(f, "inv25");
        cache_get_field_content(f, "Username", dStorage[f][Username],.max_len = MAX_PLAYER_NAME);
        switch (dStorage[f][typesize])
        {
            case 1: dStorage[f][objects] = CreateDynamicObject(2694,dStorage[f][Pos][0],dStorage[f][Pos][1],dStorage[f][Pos][2],dStorage[f][Pos][3],dStorage[f][Pos][4],dStorage[f][Pos][5], -1, -1, -1, 200.0, 100.0);
            case 2: dStorage[f][objects] = CreateDynamicObject(1271,dStorage[f][Pos][0],dStorage[f][Pos][1],dStorage[f][Pos][2],dStorage[f][Pos][3],dStorage[f][Pos][4],dStorage[f][Pos][5], -1, -1, -1, 200.0, 100.0);
            case 3: dStorage[f][objects] = CreateDynamicObject(3798,dStorage[f][Pos][0],dStorage[f][Pos][1],dStorage[f][Pos][2],dStorage[f][Pos][3],dStorage[f][Pos][4],dStorage[f][Pos][5], -1, -1, -1, 200.0, 100.0);
            case 4: dStorage[f][objects] = CreateDynamicObject(3799,dStorage[f][Pos][0],dStorage[f][Pos][1],dStorage[f][Pos][2],dStorage[f][Pos][3],dStorage[f][Pos][4],dStorage[f][Pos][5], -1, -1, -1, 200.0, 100.0);
        }
    }
    return true;
}
script loadspawnpos()
{
    new rows,fields;
    cache_get_data(rows, fields);
    for (new f = 0; f < rows; f ++) if (f < MAX_SPAWNPOS)
    {
        dspawnpos[f][Pos][0] = cache_get_field_content_float(f,"posx");
        dspawnpos[f][Pos][1] = cache_get_field_content_float(f,"posy");
        dspawnpos[f][Pos][2] = cache_get_field_content_float(f,"posz");
        switch(random(6))
        {
            case 0: dspawnpos[f][Objects] = CreateDynamicObject(1575, dspawnpos[f][Pos][0], dspawnpos[f][Pos][1], dspawnpos[f][Pos][2]-1.0, 0, 0, 0,-1,-1,-1);
            case 1: dspawnpos[f][Objects] = CreateDynamicObject(1576, dspawnpos[f][Pos][0], dspawnpos[f][Pos][1], dspawnpos[f][Pos][2]-1.0, 0, 0, 0,-1,-1,-1);
            case 2: dspawnpos[f][Objects] = CreateDynamicObject(1577, dspawnpos[f][Pos][0], dspawnpos[f][Pos][1], dspawnpos[f][Pos][2]-1.0, 0, 0, 0,-1,-1,-1);
            case 3: dspawnpos[f][Objects] = CreateDynamicObject(1578, dspawnpos[f][Pos][0], dspawnpos[f][Pos][1], dspawnpos[f][Pos][2]-1.0, 0, 0, 0,-1,-1,-1);
            case 4: dspawnpos[f][Objects] = CreateDynamicObject(1579, dspawnpos[f][Pos][0], dspawnpos[f][Pos][1], dspawnpos[f][Pos][2]-1.0, 0, 0, 0,-1,-1,-1);
            case 5: dspawnpos[f][Objects] = CreateDynamicObject(1580, dspawnpos[f][Pos][0], dspawnpos[f][Pos][1], dspawnpos[f][Pos][2]-1.0, 0, 0, 0,-1,-1,-1);
        }
    }
    return true;
}
script loadclans()
{
    new rows,fields;
    cache_get_data(rows, fields);
    for (new f = 0; f < rows; f ++) if (f < MAX_STORAGE)
    {
		clans[f][idclan] = cache_get_field_content_int(f,"idclan");
        cache_get_field_content(f, "clanname", clans[f][clanname],.max_len = MAX_PLAYER_NAME);
		cache_get_field_content(f, "Owner", clans[f][owner],.max_len = MAX_PLAYER_NAME);
		clans[f][maxrank] = cache_get_field_content_int(f,"maxrank");
        clans[f][enterpos][0] = cache_get_field_content_float(f,"enterposx");
        clans[f][enterpos][1] = cache_get_field_content_float(f,"enterposy");
        clans[f][enterpos][2] = cache_get_field_content_float(f,"enterposz");
        clans[f][enterinterior] = cache_get_field_content_int(f,"enterinterior");
        clans[f][entervw] = cache_get_field_content_int(f,"entervw");
        clans[f][exitpos][0] = cache_get_field_content_float(f,"exitposx");
        clans[f][exitpos][1] = cache_get_field_content_float(f,"exitposy");
        clans[f][exitpos][2] = cache_get_field_content_float(f,"exitposz");
        clans[f][exitinterior] = cache_get_field_content_int(f,"exitinterior");
        clans[f][exitvw] = cache_get_field_content_int(f,"exitvw");
        clans[f][chestpos][0] = cache_get_field_content_float(f,"chestposx");
        clans[f][chestpos][1] = cache_get_field_content_float(f,"chestposy");
        clans[f][chestpos][2] = cache_get_field_content_float(f,"chestposz");
        clans[f][clanexp][0] = cache_get_field_content_int(f, "clanexp0");
        clans[f][clanexp][1] = cache_get_field_content_int(f, "clanexp1");
        clans[f][clanexp][2] = cache_get_field_content_int(f, "clanexp2");
        clans[f][clanexp][3] = cache_get_field_content_int(f, "clanexp3");
        clans[f][clanexp][4] = cache_get_field_content_int(f, "clanexp4");
        clans[f][inv][0] = cache_get_field_content_int(f, "inv0");
        clans[f][inv][1] = cache_get_field_content_int(f, "inv1");
        clans[f][inv][2] = cache_get_field_content_int(f, "inv2");
        clans[f][inv][3] = cache_get_field_content_int(f, "inv3");
        clans[f][inv][4] = cache_get_field_content_int(f, "inv4");
        clans[f][inv][5] = cache_get_field_content_int(f, "inv5");
        clans[f][inv][6] = cache_get_field_content_int(f, "inv6");
        clans[f][inv][7] = cache_get_field_content_int(f, "inv7");
        clans[f][inv][8] = cache_get_field_content_int(f, "inv8");
        clans[f][inv][9] = cache_get_field_content_int(f, "inv9");
        clans[f][inv][10] = cache_get_field_content_int(f, "inv10");
        clans[f][inv][11] = cache_get_field_content_int(f, "inv11");
        clans[f][inv][12] = cache_get_field_content_int(f, "inv12");
        clans[f][inv][13] = cache_get_field_content_int(f, "inv13");
        clans[f][inv][14] = cache_get_field_content_int(f, "inv14");
        clans[f][inv][15] = cache_get_field_content_int(f, "inv15");
        clans[f][inv][16] = cache_get_field_content_int(f, "inv16");
        clans[f][inv][17] = cache_get_field_content_int(f, "inv17");
        clans[f][inv][18] = cache_get_field_content_int(f, "inv18");
        clans[f][inv][19] = cache_get_field_content_int(f, "inv19");
        clans[f][inv][20] = cache_get_field_content_int(f, "inv20");
        clans[f][inv][21] = cache_get_field_content_int(f, "inv21");
        clans[f][inv][22] = cache_get_field_content_int(f, "inv22");
        clans[f][inv][23] = cache_get_field_content_int(f, "inv23");
        clans[f][inv][24] = cache_get_field_content_int(f, "inv24");
        clans[f][inv][25] = cache_get_field_content_int(f, "inv25");
        clans[f][pickup][0] =  CreateDynamicPickup(19132, 23, clans[f][enterpos][0], clans[f][enterpos][1],clans[f][enterpos][2], clans[f][entervw], clans[f][enterinterior], -1, 50);
        clans[f][pickup][1] =  CreateDynamicPickup(19132, 23, clans[f][exitpos][0], clans[f][exitpos][1],clans[f][exitpos][2], clans[f][exitvw], clans[f][exitinterior], -1, 50);
        clans[f][pickup][2] =  CreateDynamicPickup(964, 23, clans[f][chestpos][0], clans[f][chestpos][1],clans[f][chestpos][2], -1, -1, -1, 50);
    }
    return true;
}
script loadzones()
{
    new rows,fields;
    cache_get_data(rows, fields);
    for (new e = 0; e < rows; e ++)  if (e < MAX_ZONE)
    {
        cache_get_field_content(e, "namezone", zone[e][namezone],.max_len = MAX_PLAYER_NAME);
        zone[e][clanid] = cache_get_field_content_int(e,"clanid");
        zone[e][zonepos][0] = cache_get_field_content_float(e,"zoneposx");
        zone[e][zonepos][1] = cache_get_field_content_float(e,"zoneposy");
        zone[e][zonepos][2] = cache_get_field_content_float(e,"zoneposxx");
        zone[e][zonepos][3] = cache_get_field_content_float(e,"zoneposyy");
        zone[e][zoneplace] = GangZoneCreate(zone[e][zonepos][0], zone[e][zonepos][e], zone[e][zonepos][2], zone[e][zonepos][3]);
        zone[e][zoneplace] = CreateDynamicRectangle(zone[e][zonepos][0], zone[e][zonepos][e], zone[e][zonepos][2], zone[e][zonepos][3],-1,-1,-1);
    }
    return true;
}
script GetEngineStatus(vehicleid)
{
	static engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	if (engine != 1)
		return 0;
	return 1;
}
script SetEngineStatus(vehicleid, status)
{
	static engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, status, lights, alarm, doors, bonnet, boot, objective);
}
script UnMutedTimer(playerid)
{
	new str[128];
	pMuted[playerid] = false;
	format(str,sizeof(str),"%s (ID:%d) has been auto unmuted by server ",GetName(playerid), playerid);
	SendClientMessageToAll(COLOR_RED, str);
	return 1;
}
script OnPlayerCommandTextEx(playerid, cmdtext[])
{
	SendClientMessage(playerid, COLOR_RED,"The command doesn't exists /help to see the commands avaible.");
	return 1;
}
script OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(!success) success = OnPlayerCommandTextEx(playerid,cmdtext);
    return success;
}
script CreateDroppedGun(GunID, GunAmmo, Float:gPosX, Float:gPosY, Float:gPosZ)
{
	new f = MAX_OBJ+1;
    for(new a = 0; a < MAX_OBJ; a++)
    {
        if(dGunData[a][ObjPos][0] == 0.0)
        {
            f = a;
            break;
        }
    }
    if(f > MAX_OBJ) return;
    dGunData[f][ObjData][0] = GunID;
	dGunData[f][ObjData][1] = GunAmmo;
	dGunData[f][ObjPos][0] = gPosX;
	dGunData[f][ObjPos][1] = gPosY;
	dGunData[f][ObjPos][2] = gPosZ;
	dGunData[f][ObjID] = CreateObject(GunObjects[GunID], dGunData[f][ObjPos][0], dGunData[f][ObjPos][1], dGunData[f][ObjPos][2]-1, 93.7, 120.0, random(360));
	return;
}
script RemovePlayerWeapon(playerid, weaponid)
{
	new plyWeapons[12] = 0,plyAmmo[12] = 0;
	for(new sslot = 0; sslot != 12; sslot++)
	{
		new wep, ammo;
		GetPlayerWeaponData(playerid, sslot, wep, ammo);
		if(wep != weaponid && ammo != 0) GetPlayerWeaponData(playerid, sslot, plyWeapons[sslot], plyAmmo[sslot]);
	}
	ResetPlayerWeapons(playerid);
	for(new sslot = 0; sslot != 12; sslot++) if(plyAmmo[sslot] != 0) GivePlayerWeapon(playerid, plyWeapons[sslot], plyAmmo[sslot]);
	return 1;
}
script LoadDealerVehicles()
{
    new rows = cache_num_rows();
    if(rows)
    {
        new string[75];
        for(new i; i < rows; i++)
        {
            new id = Iter_Free(ServerVehicles);
            cache_get_field_content(i, "vehOwner", vInfo[id][vehOwner], .max_len = MAX_PLAYER_NAME);
            vInfo[id][vehModel] = cache_get_field_content_int(i, "vehModel");
            cache_get_field_content(i, "vehName", vInfo[id][vehName]);
            vInfo[id][vehColorOne] = cache_get_field_content_int(i, "vehColorOne");
            vInfo[id][vehColorTwo] = cache_get_field_content_int(i, "vehColorTwo");
            vInfo[id][vehX] = cache_get_field_content_float(i, "vehX");
            vInfo[id][vehY] = cache_get_field_content_float(i, "vehY");
            vInfo[id][vehZ] = cache_get_field_content_float(i, "vehZ");
            vInfo[id][vehA] = cache_get_field_content_float(i, "vehA");

            vInfo[id][vehSessionID] = CreateVehicle(vInfo[id][vehModel], vInfo[id][vehX], vInfo[id][vehY], vInfo[id][vehZ], vInfo[id][vehA], vInfo[id][vehColorOne], vInfo[id][vehColorTwo], -1);
            vInfo[id][vehID] = cache_get_field_content_int(i, "vehID");

            SetVehicleToRespawn(vInfo[id][vehSessionID]);
            SetVehicleParamsEx(vInfo[id][vehSessionID], 0, 0, 0, 0, 0, 0, 0);
            format(string, sizeof(string), "APO%d",id);
            SetVehicleNumberPlate(vInfo[id][vehSessionID], string);

            Iter_Add(ServerVehicles, id);
        }
        printf("Loaded %d vehicles for dealership", rows);
    }
    return 1;
}
script LoadPlayerVehicles(playerid)
{
    new rows = cache_num_rows(),string[10];
    if(rows)
    {
        for(new i; i < rows; i++)
        {
            new id = Iter_Free(ServerVehicles);
            cache_get_field_content(i, "vehOwner", vInfo[id][vehOwner], .max_len = MAX_PLAYER_NAME);
            vInfo[id][vehModel] = cache_get_field_content_int(i, "vehModel");
            cache_get_field_content(i, "vehName", vInfo[id][vehName]);
            vInfo[id][vehLock] = cache_get_field_content_int(i, "vehLock");
            vInfo[id][vehMod][0] = cache_get_field_content_int(i, "vehMod_1");
            vInfo[id][vehMod][1] = cache_get_field_content_int(i, "vehMod_2");
            vInfo[id][vehMod][2] = cache_get_field_content_int(i, "vehMod_3");
            vInfo[id][vehMod][3] = cache_get_field_content_int(i, "vehMod_4");
            vInfo[id][vehMod][4] = cache_get_field_content_int(i, "vehMod_5");
            vInfo[id][vehMod][5] = cache_get_field_content_int(i, "vehMod_6");
            vInfo[id][vehMod][6] = cache_get_field_content_int(i, "vehMod_7");
            vInfo[id][vehMod][7] = cache_get_field_content_int(i, "vehMod_8");
            vInfo[id][vehMod][8] = cache_get_field_content_int(i, "vehMod_9");
            vInfo[id][vehMod][9] = cache_get_field_content_int(i, "vehMod_10");
            vInfo[id][vehMod][10] = cache_get_field_content_int(i, "vehMod_11");
            vInfo[id][vehMod][11] = cache_get_field_content_int(i, "vehMod_12");
            vInfo[id][vehMod][12] = cache_get_field_content_int(i, "vehMod_13");
            vInfo[id][vehMod][13] = cache_get_field_content_int(i, "vehMod_14");
            vInfo[id][vehColorOne] = cache_get_field_content_int(i, "vehColorOne");
            vInfo[id][vehColorTwo] = cache_get_field_content_int(i, "vehColorTwo");
            vInfo[id][vehX] = cache_get_field_content_float(i, "vehX");
            vInfo[id][vehY] = cache_get_field_content_float(i, "vehY");
            vInfo[id][vehZ] = cache_get_field_content_float(i, "vehZ");
            vInfo[id][vehA] = cache_get_field_content_float(i, "vehA");
            vInfo[id][vehSessionID] = CreateVehicle(vInfo[id][vehModel], vInfo[id][vehX], vInfo[id][vehY], vInfo[id][vehZ], vInfo[id][vehA], vInfo[id][vehColorOne], vInfo[id][vehColorTwo], -1);
            vInfo[id][vehID] = cache_get_field_content_int(i, "vehID");

            format(vInfo[id][vehName], MAX_PLAYER_NAME, GetVehicleName(vInfo[id][vehModel]));
            format(vInfo[id][vehOwner], MAX_PLAYER_NAME, GetName(playerid));

            SetVehicleToRespawn(vInfo[id][vehSessionID]);
            SetVehicleParamsEx(vInfo[id][vehSessionID], 0, 0, 0, vInfo[id][vehLock], 0, 0, 0);
            format(string, sizeof(string), "APO%d",id);
            SetVehicleNumberPlate(vInfo[id][vehSessionID], string);
            for(new x = 0; x < 14; x++) if(vInfo[id][vehMod][x] > 0) AddVehicleComponent(vInfo[id][vehSessionID], vInfo[id][vehMod][x]);
            Iter_Add(PrivateVehicles[playerid], id);
            Iter_Add(ServerVehicles, id);
        }
        printf("Loaded %d vehicles for %s", rows, GetName(playerid));
    }
    return 1;
}
script SaveVehicle(vehicleid)
{
    if(!Iter_Contains(ServerVehicles, vehicleid)) return 0;
    format(vInfo[vehicleid][vehName], 16, GetVehicleName(vInfo[vehicleid][vehModel]));
    GetVehiclePos(vInfo[vehicleid][vehSessionID], vInfo[vehicleid][vehX], vInfo[vehicleid][vehY], vInfo[vehicleid][vehZ]);
    GetVehicleZAngle(vInfo[vehicleid][vehSessionID], vInfo[vehicleid][vehA]);
    mysql_format(mysql, query, sizeof(query), "UPDATE `Vehicles` SET `vehName` = '%e', `vehOwner` = '%e', `vehLock` = %i, `vehModel` = %i,\
    `vehMod_1` = %i, `vehMod_2` = %i, `vehMod_3` = %i, `vehMod_4` = %i, `vehMod_5` = %i, `vehMod_6` = %i, `vehMod_7` = %i,\
    `vehMod_8` = %i, `vehMod_9` = %i, `vehMod_10` = %i, `vehMod_11` = %i, `vehMod_12` = %i, `vehMod_13` = %i, `vehMod_14` = %i, `vehColorOne` = %i,\
    `vehColorTwo` = %i, `vehX` = %f, `vehY` = %f, `vehZ` = %f, `vehA` = %f WHERE `vehID` = %d", vInfo[vehicleid][vehName], vInfo[vehicleid][vehOwner],
    vInfo[vehicleid][vehLock], vInfo[vehicleid][vehModel],vInfo[vehicleid][vehMod][0], vInfo[vehicleid][vehMod][1], vInfo[vehicleid][vehMod][2],
    vInfo[vehicleid][vehMod][3], vInfo[vehicleid][vehMod][4], vInfo[vehicleid][vehMod][5], vInfo[vehicleid][vehMod][6], vInfo[vehicleid][vehMod][7], vInfo[vehicleid][vehMod][8],
    vInfo[vehicleid][vehMod][9], vInfo[vehicleid][vehMod][10], vInfo[vehicleid][vehMod][11], vInfo[vehicleid][vehMod][12], vInfo[vehicleid][vehMod][13], vInfo[vehicleid][vehColorOne],
    vInfo[vehicleid][vehColorTwo], vInfo[vehicleid][vehX], vInfo[vehicleid][vehY], vInfo[vehicleid][vehZ], vInfo[vehicleid][vehA], vInfo[vehicleid][vehID]);
    mysql_tquery(mysql, query);
    return 1;
}
script ResetVehicle(vehicleid)
{
    if(!Iter_Contains(ServerVehicles, vehicleid)) return 0;
    foreach(new i : Player) {

        if(!strcmp(vInfo[vehicleid][vehOwner], GetName(i))){ Iter_Remove(PrivateVehicles[i], vehicleid); }
    }
    format(vInfo[vehicleid][vehOwner], MAX_PLAYER_NAME, "-");
    vInfo[vehicleid][vehModel] = -1;
    vInfo[vehicleid][vehLock] = 0;
    vInfo[vehicleid][vehColorOne] = -1;
    vInfo[vehicleid][vehColorTwo] = -1;
    for(new i = 0; i < 14; i++)
    {
        if(vInfo[vehicleid][vehMod][i] > 0)
        {
            RemoveVehicleComponent(vInfo[vehicleid][vehSessionID], vInfo[vehicleid][vehMod][i]);
            vInfo[vehicleid][vehMod][i] = 0;
        }
    }
    DestroyVehicle(vInfo[vehicleid][vehSessionID]);
    return 1;
}
createVehicle(vehicleid, Float:itsX, Float:itsY, Float:itsZ, Float:itsA, bool:removeold = false)
{
    new string[10];
    if(removeold == true) {DestroyVehicle(vInfo[vehicleid][vehSessionID]);}
    vInfo[vehicleid][vehSessionID] = CreateVehicle(vInfo[vehicleid][vehModel], itsX, itsY, itsZ, itsA, vInfo[vehicleid][vehColorOne], vInfo[vehicleid][vehColorTwo], -1);
    format(vInfo[vehicleid][vehName], MAX_PLAYER_NAME, GetVehicleName(vInfo[vehicleid][vehModel]));
    SetVehicleParamsEx(vInfo[vehicleid][vehSessionID], 0, 0, 0, 0, 0, 0, 0);
    format(string, sizeof(string), "APO%d",vehicleid);
    SetVehicleNumberPlate(vInfo[vehicleid][vehSessionID], string);
    for(new x = 0; x < 14; x++) if(vInfo[vehicleid][vehMod][x] > 0) AddVehicleComponent(vInfo[vehicleid][vehSessionID], vInfo[vehicleid][vehMod][x]);
    ChangeVehicleColor(vInfo[vehicleid][vehSessionID], vInfo[vehicleid][vehColorOne], vInfo[vehicleid][vehColorTwo]);
    SetVehicleToRespawn(vInfo[vehicleid][vehSessionID]);
    return 1;
}
script OnDealerVehicleCreated(vehicleid)
{
    vInfo[vehicleid][vehID] = cache_insert_id();
    Iter_Add(ServerVehicles, vehicleid);
    return 1;
}
script objects_Create(playerid)
{
	new Float:x,Float:y,Float:z,Float:angle;
	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_OBJECTSC; i ++) if (!objectsData[i][objectsExists])
		{
		    objectsData[i][objectsExists] = true;
			objectsData[i][objectsModel] = 2000;
			objectsData[i][objectsPos][0] = x + (3.0 * floatsin(-angle, degrees));
			objectsData[i][objectsPos][1] = y + (3.0 * floatcos(-angle, degrees));
			objectsData[i][objectsPos][2] = z;
			objectsData[i][objectsPos][3] = 0.0;
			objectsData[i][objectsPos][4] = 0.0;
			objectsData[i][objectsPos][5] = angle;
            objectsData[i][objectsInterior] = GetPlayerInterior(playerid);
            objectsData[i][objectsWorld] = GetPlayerVirtualWorld(playerid);
            objectsData[i][objectsOb] = CreateDynamicObject(objectsData[i][objectsModel], objectsData[i][objectsPos][0], objectsData[i][objectsPos][1], objectsData[i][objectsPos][2], objectsData[i][objectsPos][3], objectsData[i][objectsPos][4], objectsData[i][objectsPos][5], objectsData[i][objectsWorld], objectsData[i][objectsInterior]);
			mysql_tquery(mysql, "INSERT INTO `objects` (`objectsModel`) VALUES(2000)", "OnobjectsCreated", "d", i);
			return i;
		}
	}
	return -1;
}
script objects_Delete(objectsid)
{
	if (objectsid != -1 && objectsData[objectsid][objectsExists])
	{
		mysql_format(mysql,query, sizeof(query), "DELETE FROM `objects` WHERE `objectsID` = '%d'", objectsData[objectsid][objectsID]);
		mysql_tquery(mysql, query);
		if (IsValidDynamicObject(objectsData[objectsid][objectsOb]))
		    DestroyDynamicObject(objectsData[objectsid][objectsOb]);
		for (new i = 0; i != MAX_OBJECTSC; i ++) if (objectsData[i][objectsExists]) {
		    objects_Save(i);
		}
	    objectsData[objectsid][objectsExists] = false;
	    objectsData[objectsid][objectsID] = 0;
	}
	return 1;
}
script objects_Save(objectsid)
{
	format(query, sizeof(query), "UPDATE `objects` SET `objectsModel` = '%d',`objectsX` = '%.4f', `objectsY` = '%.4f', `objectsZ` = '%.4f', `objectsRX` = '%.4f', `objectsRY` = '%.4f', `objectsRZ` = '%.4f', `objectsInterior` = '%d', `objectsWorld` = '%d' WHERE `objectsID` = '%d'",
	    objectsData[objectsid][objectsModel],
	    objectsData[objectsid][objectsPos][0],
	    objectsData[objectsid][objectsPos][1],
	    objectsData[objectsid][objectsPos][2],
	    objectsData[objectsid][objectsPos][3],
	    objectsData[objectsid][objectsPos][4],
	    objectsData[objectsid][objectsPos][5],
	    objectsData[objectsid][objectsInterior],
	    objectsData[objectsid][objectsWorld],
	    objectsData[objectsid][objectsID]
	);
	return mysql_tquery(mysql, query);
}
script objects_Load()
{
    static rows,fields;
	cache_get_data(rows, fields, mysql);
	for (new i = 0; i < rows; i ++) if (i < MAX_OBJECTSC)
	{
	    objectsData[i][objectsExists] = true;
	    objectsData[i][objectsID] = cache_get_field_content_int(i, "objectsID");
	    objectsData[i][objectsModel] = cache_get_field_content_int(i, "objectsModel");
	    objectsData[i][objectsInterior] = cache_get_field_content_int(i, "objectsInterior");
	    objectsData[i][objectsWorld] = cache_get_field_content_int(i, "objectsWorld");
	    objectsData[i][objectsPos][0] = cache_get_field_content_float(i, "objectsX");
	    objectsData[i][objectsPos][1] = cache_get_field_content_float(i, "objectsY");
	    objectsData[i][objectsPos][2] = cache_get_field_content_float(i, "objectsZ");
	    objectsData[i][objectsPos][3] = cache_get_field_content_float(i, "objectsRX");
	    objectsData[i][objectsPos][4] = cache_get_field_content_float(i, "objectsRY");
	    objectsData[i][objectsPos][5] = cache_get_field_content_float(i, "objectsRZ");
	    objectsData[i][objectsOb] = CreateDynamicObject(objectsData[i][objectsModel], objectsData[i][objectsPos][0], objectsData[i][objectsPos][1], objectsData[i][objectsPos][2], objectsData[i][objectsPos][3], objectsData[i][objectsPos][4], objectsData[i][objectsPos][5], objectsData[i][objectsWorld], objectsData[i][objectsInterior]);
	}
	return 1;
}
script OnobjectsCreated(objectsid)
{
	if (objectsid == -1 || !objectsData[objectsid][objectsExists])
	    return 0;
	objectsData[objectsid][objectsID] = cache_insert_id(mysql);
	objects_Save(objectsid);
	return 1;
}
script onclancheck(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, mysql);
	if(rows) //if there is row
	{
		SendServerMessage(playerid, "You already have a clan! /myclan to check it!");
	}
	else
	{
		mysql_format(mysql, query, sizeof(query), "INSERT INTO `clans` (`clanname`,`Owner`) VALUES ('%e','%e')",clannamec,GetName(playerid));
		mysql_tquery(mysql, query, "", "");
        SendServerMessage(playerid, "Clan create with the name %s tpye /updateclan to setup it.",clannamec);
        clannamec = "\0";
	}
    return 1;
}
script Detectare_Intrare(playerid)
{
	inJOB[playerid] = 0;
	KillTimer(Meeters_BTWDeer[playerid]);
	DestroyObject(Hunter_Deer[playerid]);
	PlayerTextDrawHide(playerid, DistanceTD[playerid]);
	DisablePlayerCheckpoint(playerid);
	Deep_Deer[playerid] = 0;
	Deer[playerid] = 0;
	Shoot_Deer[playerid] = 0;
	return 1;
}
script Done_Deer(playerid)
{
    pData[playerid][inv][1] += (random(5)+1);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	ClearAnimations(playerid, 0);
	DestroyObject(Hunter_Deer[playerid]);
	TogglePlayerControllable(playerid, 1);
	SetTimerEx("Next_Deer", 1000, false, "i", playerid);
	return 1;
}
script Detect_M(playerid)
{
	new Float:x, Float:y, Float:z, mesaj[256];
	GetPlayerPos(playerid, x, y, z);
	if(Deer[playerid] == 1) Meeters[playerid] = GetDistance(x, y, z, 8521.4727,13804.3506,4.8626);
	else if(Deer[playerid] == 2) Meeters[playerid] = GetDistance(x, y, z, 8712.4287,14008.3896,3.0037);
	else if(Deer[playerid] == 3) Meeters[playerid] = GetDistance(x, y, z, 8704.8564,14117.2051,5.8480);
	else if(Deer[playerid] == 4) Meeters[playerid] = GetDistance(x, y, z, 8729.0361,14638.2578,16.9921);
	else if(Deer[playerid] == 5) Meeters[playerid] = GetDistance(x, y, z, 8597.6152,14805.4805,24.4484);
	else if(Deer[playerid] == 6) Meeters[playerid] = GetDistance(x, y, z, 8800.6748,13836.8525,3.4051);
	format(mesaj, sizeof(mesaj), "Distance_%dM", Meeters[playerid]);
	PlayerTextDrawSetString(playerid, DistanceTD[playerid], mesaj);
	PlayerTextDrawShow(playerid, DistanceTD[playerid]);
	return 1;
}
script Next_Deer(playerid)
{
	new rand = random(7);
	switch(rand) {
		case 1: {
			Deer[playerid] = 1;
			Hunter_Deer[playerid] = CreateObject(19315, 8521.4727,13804.3506,3.8626,   0.00000, 0.00000, 0.00000);
			SetPlayerCheckpoint(playerid, 8521.4727,13804.3506,4.8626, 1.0);
			Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
		}
		case 2: {
			Deer[playerid] = 2;
			Hunter_Deer[playerid] = CreateObject(19315, 8712.4287,14008.3896,2.0037,   0.00000, 0.00000, -52.38000);
			SetPlayerCheckpoint(playerid, 8712.4287,14008.3896,3.0037, 1.0);
			Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
		}
		case 3: {
			Deer[playerid] = 3;
			Hunter_Deer[playerid] = CreateObject(19315, 8704.8564,14117.2051,4.8480,   0.00000, 0.00000, -7.38000);
			SetPlayerCheckpoint(playerid, 8704.8564,14117.2051,5.8480, 1.0);
			Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
		}
		case 4: {
			Deer[playerid] = 4;
			Hunter_Deer[playerid] = CreateObject(19315, 8729.0361,14638.2578,15.9921,   0.00000, 0.00000, 0.00000);
			SetPlayerCheckpoint(playerid, 8729.0361,14638.2578,16.9921, 1.0);
			Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
		}
		case 5: {
			Deer[playerid] = 5;
			Hunter_Deer[playerid] = CreateObject(19315,8597.6152,14805.4805,23.4484,   0.00000, 0.00000, -49.26000);
			SetPlayerCheckpoint(playerid, 8597.6152,14805.4805,24.4484, 1.0);
			Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
		}
		default: {
			Deer[playerid] = 6;
			Hunter_Deer[playerid] = CreateObject(19315, 8800.6748,13836.8525,2.4051,   0.00000, 0.00000, -71.64002);
			SetPlayerCheckpoint(playerid, 8800.6748,13836.8525,3.4051, 1.0);
			Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
		}
	}
	return 1;
}
//airbreak
script OnPlayerAirbreak(playerid)
{
    if (IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessage(playerid, COLOR_LIGHTRED, "Airbreak Vehicle detected Kick");
    	KickEx(playerid);
    }
    else
    {
        SendClientMessage(playerid, COLOR_LIGHTRED, "Airbreak Player detected Kick");
    	KickEx(playerid);
    }
    return 1;
}
KickEx(playerid)
{
	SetTimerEx("KickTimer", 200, false, "d", playerid);
	return 1;
}
script KickTimer(playerid)
{
	Kick(playerid);
	return 0;
}
Dialog:dLOGIN(playerid, response, listitem, inputtext[])
{
    if(!response) Kick(playerid); //if they clicked Quit, we will kick them
    new hpass[129]; //for password hashing
    WP_Hash(hpass, 129, inputtext); //hashing inputtext
    if(!strcmp(hpass, pData[playerid][Password])) //remember we have loaded player's password into this variable, pData[playerid][Password] earlier. Now let's use it to compare the hashed password with password that we load
    { //if the hashed password matches with the loaded password from database
        mysql_format(mysql, query, sizeof(query), "SELECT * FROM `players` WHERE `Username` = '%e' LIMIT 1", Name[playerid]);
        mysql_tquery(mysql, query, "OnAccountLoad", "i", playerid);
    }
    else
    {
        Dialog_Show(playerid, dLOGIN, DIALOG_STYLE_PASSWORD, "Login", "In order to play, you need to login\nWrong password!", "Login", "Quit");
    }
    return 1;
}
Dialog:dREGISTER(playerid, response, listitem, inputtext[])
{
    if(!response) return Kick(playerid); //if they clicked Quit, we will kick them
    if(strlen(inputtext) < 6) return Dialog_Show(playerid, dREGISTER, DIALOG_STYLE_INPUT, "Register", "In order to play, you need to register.\nYour password must be at least 6 characters long!", "Register", "Quit");
    WP_Hash(pData[playerid][Password], 129, inputtext); //hashing inputtext
	mysql_format(mysql, query, sizeof(query), "INSERT INTO `players` (`Username`, `Password`, `IP`, `Admin`, `VIP`,`Score`) VALUES ('%e', '%s', '%s', 0, 0, 0)", Name[playerid], pData[playerid][Password], IP[playerid]);
	mysql_tquery(mysql, query, "OnAccountRegister", "i", playerid);
	return 1;
}
Dialog:DIALOG_BUY_VEHICLE(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new i = GetPVarInt(playerid, "buyVehicle");
        if(strcmp(vInfo[i][vehOwner], "-")) return SendClientMessage(playerid, COLOR_RED, "Vehicle is already owned by a player");

        SetVehicleToRespawn(vInfo[i][vehSessionID]);
		GetPlayerName(playerid, vInfo[i][vehOwner], MAX_PLAYER_NAME);

        SetVehicleParamsForPlayer(vInfo[i][vehSessionID], playerid, 0, 0);
        vInfo[i][vehLock] = 0;
        format(vInfo[i][vehOwner], MAX_PLAYER_NAME, GetName(playerid));
        Iter_Add(PrivateVehicles[playerid], i);
        SaveVehicle(i);
        return 1;
    }
	return 1;
}
Dialog:DIALOG_VEHICLES(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new count = 0;
        foreach(new i : PrivateVehicles[playerid])
        {
            if(!strcmp(vInfo[i][vehOwner], GetName(playerid)))
            {
                if(count == listitem)
                {
                    SetPVarInt(playerid, "playerVehID", i);
					Dialog_Show(playerid, DIALOG_VEHICLES1, DIALOG_STYLE_LIST, "Vehicles", "Spawn Car\nLock\nUnlock\nEmpty\nPark", "Select", "Close");
                    break;
                }
                else count++;
            }
        }
    }
	return 1;
}
Dialog:DIALOG_VEHICLES1(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				new i = GetPVarInt(playerid, "playerVehID");
				GetPlayerPos(playerid, vInfo[i][vehX], vInfo[i][vehY], vInfo[i][vehZ]);
				GetPlayerFacingAngle(playerid, vInfo[i][vehA]);
				createVehicle(i, vInfo[i][vehX]+3, vInfo[i][vehY], vInfo[i][vehZ], vInfo[i][vehA], true);
				SaveVehicle(i);
			}
			case 1:
			{
				new i = GetPVarInt(playerid, "playerVehID");
				foreach(new x : Player) if(x != playerid) SetVehicleParamsForPlayer(vInfo[i][vehSessionID], x, 0, 1);
				vInfo[i][vehLock] = 1;
                SetVehicleParamsEx(vInfo[i][vehSessionID], 0, 0, 0, 1, 0, 0, 0);
				SaveVehicle(i);
				SendClientMessage(playerid, COLOR_GREEN, "You have locked your vehicle");
			}
			case 2:
			{
				new i = GetPVarInt(playerid, "playerVehID");
				foreach(new x : Player) if(x != playerid) SetVehicleParamsForPlayer(vInfo[i][vehSessionID], x, 0, 0);
                SetVehicleParamsEx(vInfo[i][vehSessionID], 0, 0, 0, 0, 0, 0, 0);
				vInfo[i][vehLock] = 0;
				SaveVehicle(i);
				SendClientMessage(playerid, COLOR_GREEN, "You have unlocked your vehicle");
			}
			case 3:
			{
				new i = GetPVarInt(playerid, "playerVehID");
				foreach(new x : Player) { if(IsPlayerInVehicle(x, vInfo[i][vehSessionID])) { RemovePlayerFromVehicle(x); } }
				SendClientMessage(playerid, COLOR_GREEN, "You have ejected all the players from your vehicle");
			}
		}
	}
	return 1;
}
CMD:fuckthevehicle(playerid, params[])
{
    new id, string[100];
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_RED, "Buy vehicle: /fuckthevehicle <VehicleID>");
    if(!Iter_Contains(ServerVehicles, id)) return SendClientMessage(playerid, COLOR_RED, "Invalid vehicle ID");
    if(!strcmp(vInfo[id][vehOwner], "-")) {

        SetPVarInt(playerid, "buyVehicle", id);
        format(string, sizeof(string), "{FFFFFF}Vehicle: {00FF00}%s\n{FFFFFF}Buy it?", vInfo[id][vehName]);
        Dialog_Show(playerid, DIALOG_BUY_VEHICLE, DIALOG_STYLE_MSGBOX, "Buy Vehicle", string, "Buy", "Close");
        return 1;
    }
    else return SendClientMessage(playerid, COLOR_RED, "Vehicle is already owned by an other player");
}
CMD:vc(playerid, params[])
{
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    new modelid[30], vehid, color1, color2,string[10],index = Iter_Free(ServerVehicles);
    if(sscanf(params, "s[30]ii", modelid, color1, color2)) return SendClientMessage(playerid, COLOR_RED, "Create vehicle: /vc <ModelID/Vehicle Name> <Color1> <Color2>");

    if(IsNumeric(modelid)) vehid = strval(modelid);
    else vehid = ReturnVehicleModelID(modelid);
    if(vehid < 400 || vehid > 25313) return SendClientMessage(playerid, COLOR_RED, "Invalid vehicle model!");
    if(index == -1) return SendClientMessage(playerid, COLOR_RED, "You can't create more vehicle!");
    if(IsPlayerInAnyVehicle(playerid)) DestroyVehicle(GetPlayerVehicleID(playerid));
    GetPlayerPos(playerid, vInfo[index][vehX], vInfo[index][vehY], vInfo[index][vehZ]);
    GetPlayerFacingAngle(playerid, vInfo[index][vehA]);

    SetPlayerPos(playerid, vInfo[index][vehX] + 3, vInfo[index][vehY], vInfo[index][vehZ]);

    vInfo[index][vehSessionID] = CreateVehicle(vehid, vInfo[index][vehX], vInfo[index][vehY], vInfo[index][vehZ], vInfo[index][vehA], color1, color2, 10);
    SetVehicleParamsEx(vInfo[index][vehSessionID], 0, 0, 0, 0, 0, 0, 0);
    format(string, sizeof(string), "APO%d",index);
    SetVehicleNumberPlate(vInfo[index][vehSessionID], string);

    format(vInfo[index][vehName], MAX_PLAYER_NAME, GetVehicleName(vehid));
    format(vInfo[index][vehOwner], MAX_PLAYER_NAME, "-");

    vInfo[index][vehModel] = vehid;
    vInfo[index][vehLock] = 0;
    vInfo[index][vehColorOne] = color1;
    vInfo[index][vehColorTwo] = color2;

    mysql_format(mysql, query, sizeof(query),"INSERT INTO `Vehicles` (vehModel,vehName, vehColorOne, vehColorTwo, vehX, vehY, vehZ, vehA) VALUES (%d, '%e', '%e', %d, %d, %f, %f, %f, %f)",
    vInfo[index][vehModel], vInfo[index][vehName],vInfo[index][vehColorOne], vInfo[index][vehColorTwo], vInfo[index][vehX],
    vInfo[index][vehY], vInfo[index][vehZ], vInfo[index][vehA]);
    mysql_tquery(mysql, query, "OnDealerVehicleCreated", "i", index);

    format(query, sizeof(query), "You have created a vehicle - ModelID: %d, VehicleID: %d", vInfo[index][vehModel], index);
    SendClientMessage(playerid, COLOR_RED, query);
    return 1;
}
CMD:gotovehicle(playerid, params[])
{
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    new id;
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_RED, "Teleport to vehicle: /gotovehicle <VehicleID>");
    if(!Iter_Contains(ServerVehicles, id)) return SendClientMessage(playerid, COLOR_RED, "Invalid vehicle ID");
    GetVehiclePos(vInfo[id][vehSessionID], vInfo[id][vehX], vInfo[id][vehY], vInfo[id][vehZ]);

    SetPlayerPos(playerid, vInfo[id][vehX], vInfo[id][vehY], vInfo[id][vehZ]+3);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}
CMD:vdel(playerid, params[])
{
    if(pData[playerid][Admin] < 1) return SendServerMessage(playerid, "Only admin level 1+ can use this cmd.");
    new id;
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_RED, "Delete vehicle: /vdel <VehicleID>");
    if(!Iter_Contains(ServerVehicles, id)) return SendClientMessage(playerid, COLOR_RED, "Invalid vehicle ID");

    ResetVehicle(id);
    Iter_Remove(ServerVehicles, id);
    mysql_format(mysql, query, sizeof(query), "DELETE FROM `Vehicles` WHERE `vehID` = %d", vInfo[id][vehID]);
    mysql_tquery(mysql, query);

    SendClientMessage(playerid, COLOR_RED, "Vehicle deleted");
    return 1;
}
Storage_Nearest(playerid)
{
    for (new i = 0; i != MAX_STORAGE; i ++) if (dStorage[i][objects] && IsPlayerInRangeOfPoint(playerid, 3, dStorage[i][Pos][0], dStorage[i][Pos][1], dStorage[i][Pos][2]))
	{
        return i;
	}
	return -1;
}
objects_Nearest(playerid)
{
    for (new i = 0; i != MAX_OBJECTSC; i ++) if (objectsData[i][objectsExists] && IsPlayerInRangeOfPoint(playerid, 10, objectsData[i][objectsPos][0], objectsData[i][objectsPos][1], objectsData[i][objectsPos][2]))
	{
		if (GetPlayerInterior(playerid) == objectsData[i][objectsInterior] && GetPlayerVirtualWorld(playerid) == objectsData[i][objectsWorld])
			return i;
	}
	return -1;
}
ResetEditing(playerid)
{
	pData[playerid][pEditobjects] = -1;
	return 1;
}
//define blabla stuff easy
#include <apo/cmdplayers>
#include <apo/cmdadmins>
#include <apo/cmddebug>
#include <apo/dc>
#include <apo/actorclan>
stock GetVehicleName(modelid)
{
    new string[20];
    format(string,sizeof(string),"%s",VehicleNames[modelid - 400]);
    return string;
}
stock IsNumeric(string[])
{
    for (new i = 0, j = strlen(string); i < j; i++) {if (string[i] > '9' || string[i] < '0') return 0;}
    return 1;
}
stock ReturnVehicleModelID(Name1[])
{
    for(new i; i != 25313; i++) if(strfind(VehicleNames[i], Name1, true) != -1) return i + 400;
    return INVALID_VEHICLE_ID;
}
stock GetName(playerid)
{
	new PlayerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	return PlayerName;
}
stock GetSeconds(seconds)
{
	seconds = seconds * 1000;
	return seconds;
}
stock AnimationCheck(playerid) {return (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT);}
stock ApplyAnimationEx(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
	ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
	return 1;
}
stock SQL_ReturnEscaped(const string[])
{
	new entry[256];
	mysql_real_escape_string(string, entry, mysql);
	return entry;
}
stock GetDistance(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2) {return floatround(floatsqroot(((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)) + ((z1 - z2) * (z1 - z2))));}

stock SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
	static
	    args,
	    str[144];
	if ((args = numargs()) == 3)
	{
	    SendClientMessage(playerid, color, text);
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return 1;
}
AntiDeAMX()
{
	new b;
	#emit load.s.pri b
	#emit stor.s.pri b
	#emit load.alt b
	#emit stor.alt b
	#emit load.s.alt b
	#emit stor.s.alt b
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}
