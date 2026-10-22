#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
main()
{
	setDvar("g_gametype", "gungame");
	SetDvarIfUninitialized("loaded_mod", 0);
    if(getDvarInt("loaded_mod") == 0)
	    maps\mp\gametypes\gungame::main();
	SetDvarIfUninitialized("loaded_mod", 1); 
}
