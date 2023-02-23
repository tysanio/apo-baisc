#include <a_samp>
#include <streamer>
#include ugmp
public OnFilterScriptInit()
{
	//RedirectDownloadsTo("http://127./folder"); //it is working somehow but the simple methond wont
    //AddAtomicModel(39000, "lae", "laesmokecnthus", 100, 0);
    AddIDE("skins.ide");
    AddIDE("objects.ide");
    AddPedModel(39000, "Hide","Hide","STAT_COWARD", PED_TYPE_COP, "sexywoman", "null", 0x1003, 0, 1, 4);
    OnAddModelCompleted(-1,"lae",39001);
    CreateDynamicObject(39001,10,10,5,0,0,0,-1,-1);
	return 1;
}
