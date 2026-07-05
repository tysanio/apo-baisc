/*
command /howto dialog to do stuff	
clanexp0 need to player exp and everything for a player
need to do skill weapons maybe when level up?
checking actor because doing something fuck top maybe need interior actor?
command invite for clan stuff-----to test
craft food/water bar remove stuff
Secteur H , la meute, les évader et la zone---name D.rtto
do admin edit player stuff
do admin edit stuff discord
ID 16404 16405 3260 3302
*/
#define host	"localhost"
#define user	"apo"
#define db		"apo"
#define pass 	"blablabla"

#define COLOR_WHITE       	0xFFFFFFBB
#define COLOR_RED       	0xFF0000AA
#define COLOR_GREEN     	0x00FF00AA
#define COLOR_BLUE      	0x0000FFAA
#define COLOR_PURPLE    	0xD0AEEBBB
#define COLOR_YELLOW    	0xFFDD00AA
#define COLOR_LIGHTRED  	0xFF6347AA
#define COLOR_LIGHTBLUE 	0x33CCFFAA
#define COLOR_GRAY			0x808080AA // Gray

#define script%0(%1) forward%0(%1); public%0(%1)
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define MAX_OBJ 1000 // <- weapons drop
#define MAX_OBJECTSC 500   //map object
#define MAX_STORAGES 2000   //map storage
#define MAX_SPAWNPOS 4000  //spawn object random
#define MAX_CLANS 5000
#define MAX_ALLOWED_VEHICLE_DISTANCE 5.0 // Max allowed movement in 3s
#define MAX_SERVER_VEHICLES 500
#define MAX_FUEL_STATIONS 10
#define MAX_WEAPONS 13
#define MAX_GZONES 50
#define MAX_MISSION_CHECKPOINTS 5

#define MODEL_SELECTION_SKIN 													(1)
#define MODEL_SELECTION_CRAFT 													(2)

//discord chat A CHANGER POUR LES BONNE VALEUR
#define Dadmin1 "1212826877849505883"
#define Dverifier "1212826848262885456"
#define DLeader "1392247995059146782"
#define DMember "1392248046649344150"
#define Ddiscord "1212826277946458162"
#define Dchat "1212826278600777730" //pour joueur
#define Achat "1212826278600777730" //pour admin
#define ooc "1212826278600777730"

#define SendServerMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_YELLOW, "[SERVER]:{FFFFFF} "%1)
#define SendCommandMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_GREEN, "[COMMAND]:{FFFFFF} "%1)
#define SendTWMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_PURPLE, "[COMMAND]:{FFFFFF} "%1)

//timer first value minute(s)
#define GANG_RESOURCE_TIME (60 * 60 * 1000) // 60 minutes