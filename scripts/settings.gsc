#include common_scripts\utility; #include maps\mp\_utility; #include maps\mp\gametypes\_hud_util;   


Init()
{     
	level.devmode = 0;      
	level.playerhealth = 75; 
	level.killstreaks = 1; 
	level.speed = 1.15; 	
	level.weapon = []; 	
	level.list = 0;  	
	AddWeapon("defaultweapon_mp"); 
	level Weapons(); 
} 
	
Weapons() 
{  
	
	AddWeapon("usp_mp");
	AddWeapon("usp_tactical_mp");
	AddWeapon("usp_akimbo_mp");
	AddWeapon("coltanaconda_mp");
	AddWeapon("coltanaconda_tactical_mp");
	AddWeapon("coltanaconda_akimbo_mp");
	AddWeapon("beretta_mp");
	AddWeapon("beretta_silencer_mp");
	AddWeapon("beretta_akimbo_mp");
	AddWeapon("deserteaglegold_mp");
	 
	AddWeapon("deserteagle_akimbo_mp");
	AddWeapon("beretta393_mp");
	AddWeapon("beretta393_reflex_mp");
	AddWeapon("beretta393_akimbo_mp");
	AddWeapon("glock_mp");
	AddWeapon("glock_silencer_mp");
	AddWeapon("glock_akimbo_mp");
	AddWeapon("tmp_mp");
	AddWeapon("tmp_reflex_mp");
	AddWeapon("tmp_akimbo_mp");
	
	AddWeapon("pp2000_mp");
	AddWeapon("pp2000_fmj_reflex_mp");
	AddWeapon("pp2000_akimbo_mp");
	AddWeapon("spas12_mp");
	AddWeapon("spas12_silencer_mp");
	AddWeapon("m1014_mp");
	AddWeapon("m1014_silencer_mp");
	AddWeapon("aa12_mp");
	AddWeapon("aa12_silencer_mp");
	AddWeapon("aa12_eotech_xmags_mp");
	AddWeapon("striker_eotech_mp");
	
	//AddWeapon("winchester1200");
	AddWeapon("striker_mp");
	AddWeapon("striker_eotech_mp");
	AddWeapon("ranger_mp"); // blunderbuss
	AddWeapon("ranger_fmj_mp");
	AddWeapon("ranger_akimbo_mp");	 
	AddWeapon("model1887_mp");
	AddWeapon("model1887_akimbo_mp");
	AddWeapon("uzi_mp");
	AddWeapon("uzi_fmj_reflex_mp");
	AddWeapon("uzi_akimbo_mp");
	AddWeapon("mp5k_mp");
	
	AddWeapon("uzi_acog_fmj_mp"); // MP7
	AddWeapon("mp5k_thermal_xmags_mp"); // Mp40
	
	AddWeapon("mp5k_rof_mp");
	AddWeapon("wa2000_mp");
	AddWeapon("wa2000_silencer_mp");
	AddWeapon("wa2000_fmj_thermal_mp");
	AddWeapon("m21_silencer_mp");
	AddWeapon("m21_fmj_silencer_mp");
	AddWeapon("m21_acog_fmj_mp");
	AddWeapon("barrett_mp");
	AddWeapon("cheytac_mp");
	AddWeapon("cheytac_heartbeat_mp");
	AddWeapon("cheytac_thermal_mp");
	
	AddWeapon("cheytac_xmags_mp"); // USR
	AddWeapon("cheytac_silencer_mp"); // DSR
	AddWeapon("cheytac_fmj_heartbeat_mp"); // Kar98k
	AddWeapon("cheytac_acog_mp"); // Ballista
	
	AddWeapon("m40a3_mp");
	AddWeapon("dragunov_mp");
	AddWeapon("kriss_mp");
	AddWeapon("kriss_acog_silencer_mp");
	AddWeapon("kriss_thermal_xmags_mp");
	AddWeapon("ump45_mp");
	AddWeapon("ump45_silencer_mp");
	AddWeapon("ump45_rof_thermal_mp");
	AddWeapon("p90_rof_mp");
	AddWeapon("p90_fmj_silencer_mp");
	AddWeapon("p90_akimbo_fmj_mp");
	
	AddWeapon("ak47_eotech_fmj_mp"); // PPSH
	AddWeapon("ak47_acog_fmj_mp"); // M1927
	AddWeapon("ak47_eotech_heartbeat_mp"); // RIPPER
	
	AddWeapon("peacekeeper_mp");
	
	AddWeapon("ak74u_mp");
	AddWeapon("ak74u_acog_mp");
	AddWeapon("ak47classic_mp");
	AddWeapon("ak74u_acog_mp");
	AddWeapon("ak47classic_fmj_gl_mp");
	AddWeapon("fal_mp");
	AddWeapon("fal_eotech_mp");
	AddWeapon("ak47_mp");
	AddWeapon("ak47_heartbeat_mp");
	AddWeapon("ak47_thermal_mp");
	
	AddWeapon("fn2000_mp"); // BAL 27
	
	AddWeapon("m16_mp");
	AddWeapon("m16_shotgun_mp");
	AddWeapon("m16_heartbeat_mp");
	AddWeapon("m4_mp");
	AddWeapon("m4_silencer_mp");
	AddWeapon("m4_acog_gl_mp");
	AddWeapon("fn2000_fmj_mp");
	AddWeapon("fn2000_acog_shotgun_mp");
	AddWeapon("fn2000_heartbeat_reflex_mp");
	AddWeapon("masada_mp");
	
	AddWeapon("ak47_fmj_mp"); // ASM
	
	AddWeapon("masada_shotgun_mp");
	AddWeapon("masada_gl_thermal_mp");
	AddWeapon("masada_thermal_xmags_mp");
	AddWeapon("famas_mp");
	AddWeapon("famas_eotech_heartbeat_mp");
	AddWeapon("scar_mp");
	AddWeapon("scar_acog_fmj_mp");
	AddWeapon("tavor_mp");
	AddWeapon("tavor_reflex_mp");
	AddWeapon("tavor_acog_mp");
	
	AddWeapon("ak47_acog_silencer_mp"); // \Volkssturmgewehr
	AddWeapon("ak47_acog_shotgun_mp"); // KN44
	AddWeapon("ak47_acog_heartbeat_mp"); // AN94
	
	AddWeapon("sa80_mp");
	AddWeapon("sa80_eotech_fmj_mp");
	AddWeapon("sa80_acog_heartbeat_mp");
	
	AddWeapon("mg4_mp"); // das MG
	
	AddWeapon("mg4_fmj_heartbeat_mp");
	AddWeapon("mg4_fmj_reflex_mp");
	AddWeapon("mg4_thermal_xmags_mp");
	AddWeapon("m240_mp");
	AddWeapon("m240_eotech_xmags_mp");
	AddWeapon("m240_grip_thermal_mp");
	AddWeapon("aug_mp");
	AddWeapon("aug_eotech_silencer_mp");
	
	AddWeapon("aug_heartbeat_reflex_mp");
	AddWeapon("rpd_mp");
	AddWeapon("rpd_heartbeat_mp");
	AddWeapon("rpd_fmj_heartbeat_mp");
	AddWeapon("pp2000_eotech_mp");
	AddWeapon("ac130_25mm_mp");
	AddWeapon("ac130_40mm_mp");
	AddWeapon("ac130_105mm_mp");
	AddWeapon("m40a3_mp");
	AddWeapon("riotshield_mp");
	
	
	AddWeapon("barrett_xmags_mp"); // Mors
	AddWeapon("barrett_silencer_mp"); // MSR
	AddWeapon("barrett_acog_mp"); // L96A1
	
	AddWeapon("m79_mp");
	AddWeapon("rpg_mp");
	//AddWeapon("javelin_mp");
	AddWeapon("stinger_mp");
	AddWeapon("nuke_mp");
	 

}

AddWeapon(name)
{     
	level.weapon[level.list] = name; 	
	level.list++; 
}   















	  