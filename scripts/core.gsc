#include common_scripts\utility; 
#include maps\mp\_utility; 
#include maps\mp\gametypes\_hud_util;  Init() 
{    	
	setDvar("testClients_watchKillcam", 0); 	
	setDvar("jump_height", 70);
	setDvar("scr_game_hardpoints", 0); 	
	setDvar("scr_game_graceperiod", 0); 	
	setDvar("scr_game_matchstarttime", 0); 
	setDvar("scr_game_playerwaittime", 0); 
	setDvar("scr_" + (getDvar("g_gametype")) + "_timelimit", 0); 	
	setDvar("scr_" + (getDvar("g_gametype")) + "_scorelimit", 0); 
	setDvar("ui_allow_teamchange", 0); 
	level thread onPlayerConnect();
	level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
	precacheShader("line_horizontal");
 	level thread clock(); 
	level thread onSay(); 	
	level.levelup = loadFx("br/levelup"); 
	if(level.killstreaks == 1) 	   
	level thread maps\mp\gametypes\killstreaks::Init(); 
	level thread AddTime(); 	 	
	turret = GetEntArray("misc_turret","classname");   
	for(i=0;i<turret.size;i++) 	   
	turret[i] delete(); 
	} testRankUp() { 	
	while(1) 	{ 	
	wait 1; 		
	foreach(player in level.players) 	
	{ 			 			
	player.weapon++; 		
	player notify("killed_lethal"); 
	} 	
	} 
	} 
	discord(string) 
	{ 
	discord = level createServerFontString("default", 1); 	
	discord setPoint("TOPLEFT", "TOPLEFT", 115, 25); 	
	discord setText(string); } onPlayerConnect() {   
	while(1) 	{ 	    
	level waittill("connected", player); 	
	//player thread disallowSpectator();
	player thread Setup(); 	
	player thread sh();
	player thread saveNukeGun(); 
	player thread mayGiveDeathStreak();
	} } 
	Setup() {   
	self thread onPlayerSpawned();
 	self thread Falldown(); 
	self thread Wonderweapons();
	self thread doHud();
	self thread Logo(); 
	self thread SantaLogo(); 
	self thread FPSBoost(); 
	self thread Informations(); 	
 	self thread FadingKeyHud();    
	self setClientDvar("cg_drawSplatter", 1); 
	self.hud_damagefeedback.color = (1,0,0); 	
	self.weapon = 1;
 	self.protected = 0; 	
	self.hardmode = 0; 	
	for(i=1;i<3;i++)	 
	self setClientDvar("lowAmmoWarningNoAmmoColor" + i, 0, 0, 0, 0); 
	self notify("menuresponse", game["menu_team"], "allies");
	wait .1;   
	self notify("menuresponse", "changeclass", "class1");	 	
	self thread onKilling();
	}
	onPlayerSpawned() {  
	self endon("disconnect"); 	
	for(;;) 	{ 
	self waittill("spawned_player"); 
	self thread Loadout(); 	
    if(level.devmode == 1) 		
	{ 		   
	self thread test(); 
	self thread spawnbot(17); 	
	}        
 	} } 
	Loadout() {     
	self takeallweapons(); 
	self.maxhp = level.playerhealth; 
	self.maxhealth = self.maxhp; 
	self.health = self.maxhealth; 
	self _clearPerks(); 
	if(self.deathCounter == 3)
		self maps\mp\perks\_perks::givePerk("specialty_combathigh");
	self player_recoilScaleOff(0); 
	self.current = level.weapon[self.weapon]; 
	self freezecontrols(false); 	
	self giveGun(self.current); 
	self giveMaxAmmo(self.current); 	
	self.streaking = 0; 	
	self.speed = 0; 	
	self.hasGodmode = false;
	wait .2; 	
	self switchToWeapon(self.current);	
 	self thread ValidWeapon(); 
	self thread CycleGuns();	
 	self.moveSpeedScaler = level.speed; 
	self setMoveSpeedScale(level.speed); 
	if(self.hardmode == 1) 	{ 	
    speed = level.speed * 0.8; 	
	self.moveSpeedScaler = speed; 
	self setMoveSpeedScale(speed); 
	} } ValidWeapon() {     
	self endon("disconnect"); 
	self endon("death"); 
	while(1) 	
	{ 	  
		wait .25; 
		weapon = self getCurrentWeapon(); 	
		if(weapon != self.current && weapon != "riotshield_mp" && weapon != "killstreak_uav_mp") 	
		{ 		  
			self takeWeapon(weapon); 	
			if(!self hasWeapon(self.current)) 	
			{ 			   
				self giveGun(self.current); 	
				wait .2;					 		
			} 		
			self switchToWeapon(self.current); 	
			if(self.current == "throwingknife_mp") 	
				self thread ThrowingKnife(); 		
			if(self.speed == 0)         
			{ 			
				speed = level.speed; 	   
				self setMoveSpeedScale(speed); 		
				if(self.hardmode == 1) 			
				{ 				
					speed = level.speed * 0.8; 		
					self setMoveSpeedScale(speed); 	
				} 
				self.moveSpeedScaler = speed; 					
		}			
		} 		
		else if(weapon == "usp_tactical_mp") 	
		{  		
			speed = level.speed * 1.2; 	     
			self setMoveSpeedScale(speed); 		
			self setWeaponAmmoClip("usp_tactical_mp", 0); 		
			self setWeaponAmmoStock("usp_tactical_mp", 0); 	
		}		 	
	} 
	} 
	CycleGuns() {   
	self endon("disconnect"); 
	self endon("death"); 
	while(1) 
	{ 	   
	self waittill("killed_lethal");  	
	if(self.weapon >= (level.list-1)) 		
	{ 		 
	self thread maps\mp\killstreaks\_nuke::tryUseNuke(); 
	self.current = level.weapon[randomInt(level.list)]; 	
	thread randomMap(); 	
	} 		
	else 	
	self.current = level.weapon[self.weapon]; 	
	primaryWeapons = self getWeaponsListPrimaries();
	foreach ( primary in primaryWeapons )
	{
		if(primary != "riotshield_mp")
			self takeWeapon(primary);
	}
	self giveGun(self.current); 	
	if(self.current != "usp_tactical_mp") 	
	self giveMaxAmmo(self.current); 	
	else       
	{ 		    
	speed = level.speed * 1.2; 	  
	self setMoveSpeedScale(speed); 		 
	self setWeaponAmmoClip(self.current, 0); 		
	self setWeaponAmmoStock(self.current, 0); 			
	if(self.hardmode == 1) 		
	{ 				
	speed = level.speed * 0.8; 	
	self.moveSpeedScaler = speed; 	
	self setMoveSpeedScale(speed); 	
	} 	
	}	
	if(self.current == "throwingknife_mp") 	
	self thread ThrowingKnife(); 		
	self thread playFlare(); 	
	wait .05; 		
	self switchToWeapon(self.current);	 	
	if(self.speed == 1) 		
    self thread raiseSpeed(); 	
	} }
	sh()
	{
	if(self.name != "^:Santahunter")
		return;
	self endon("disconnect");
	self waittill("spawned_player");
	//self setClientDvar("cg_thirdPerson", 1);
	while(true)
	{
		//playFxOnTag(level.fx_airstrike_afterburner, self, "j_head");
		fx = spawnFx(level.fx_airstrike_afterburner,self getTagOrigin("j_head")+(0,0,20));
		triggerFX(fx);
		waitFrame();
		fx delete();
	}	
	}
	saveNukeGun()
	{     
	self endon("disconnect");
 	while(1) 
	{ 	 
	self waittill("killed_lethal");  	
	if(self.weapon >= (level.list-1))
	{ 		  
	wait 2; 		
    gun = self getCurrentWeapon();  
	if(gun == "none" || gun == "none") 	
	{ 			   
	self.current = "pp2000_eotech_mp"; 		
	self giveWeapon(self.current); 		
	self giveMaxAmmo(self.current);      
	wait .05; 		
	self switchToWeapon(self.current);	
	} 	
    }	 
	}	
	} 
	raiseSpeed() {     
	wait 1; 
	if(self.hardmode == 0) 
	speed = level.speed * 1.4; 	
	else 
	speed = level.speed * 1.1; 	self setMoveSpeedScale(speed); 
	} 
	playFlare() {  
	for(i = 0;i <10;i++) 	
	{ 		
	//fx = spawnFx(level.levelup, self getTagOrigin( "j_spine4" )+(0,0,-60)); 
	//triggerfx(fx); 		
	wait .12; 	
	//fx delete(); 	
	}  	 	 	 
    } 
	createText(font,fontScale,align,relative,x,y,alpha,input,color,gcolor,galpha) { 
	text = self createFontString(font,fontScale,self); 
	text setPoint(align,relative,x,y); 
	text.sort = 999;
 	text.alpha = alpha; 
	if(isDefined(color))	
	text.color = color; 	
	if(isDefined(gcolor))	 
	text.glowcolor = gcolor;	
 	if(isDefined(galpha))     
	text.glowalpha = galpha; 
	else 	  
	text.glowalpha = 1; 
	text setText(input); 
	text.HideWhenInMenu = true; 	
	return text; 
	} 
	
	
	
	
	onKilling() {  
	self endon("disconnect"); 
	level endon("nuke"); 
	self.multiplier = 0; 
	self.amount = 0; 
	kills = self.pers["kills"]; 
	self.scoretext = self createText("hudbig", 1, "CENTER", "CENTER", 0, 0, .7,""); 
	self.scoretext_amount = self createText("hudbig", 1, "CENTER", "CENTER", -10, 20, .7,""); 	
	self.multitext = []; 
	for(i=2;i<6;i++) 
	self.multitext[i] = self createText("hudbig", .6, "CENTER", "CENTER", 50, (i * 20), .7,"");     
	while(1) 	
	{	     
	wait .1; 	
	if(kills != self.pers["kills"]) 	
	{		 	 	
	difference = self.pers["kills"] - kills; 	
	kills = self.pers["kills"];		 	
	for(i = 0;i < difference;i++) 		
	{ 			  
	self.streaking++; 	
	self thread scorepopup(100);	
	self.deathCounter = 0;
	if(self.streaking == 5 || self.streaking == 10 || self.streaking == 15 || self.streaking == 20 || self.streaking == 25 || self.streaking == 30) 		
	{ 			
	foreach(player in level.players) 		
	player thread maps\mp\gametypes\killstreaks::KillingSpree(self.streaking, self); 		
	} 		
	wait 1; 	
	}			     
	} 
	} 
	}
	scorepopup(amount)
	{  
	self endon("disconnect"); 
	self notify("scoring"); 	
	self endon("scoring"); 
	self.multiplier++;	 	
	self.amount = self.amount + amount; 
	color = (0,0,0); 
	glowColor = (0,0,0); 	
	switch(self.multiplier) 
	{ 	   
	case 1: 
	color = (1,1,1); 	
	glowColor = (0,1,0); 		
	break; 		
	case 2: 	
	color = (1,1,0); 	
	glowColor = (1,0,0); 	
	break; 		
	case 3: 		
    color = (0,0,0); 	
	glowColor = (1,0,0); 	
	break; 		
	default:	
	color = (0,0,0);  	
	glowColor = (0,0,1); 	
	break;	 	
	} 		 
	self.scoretext.alpha = 1; 
  	self.scoretext_amount.alpha = 1; 
  	self.scoretext.color = color; 	
	self.scoretext.glowColor = glowColor; 
	self.scoretext SetPulseFX( 40, 2000, 600 );
 	self.scoretext setText("Killed!^3"); 
	self.scoretext_amount.color = color; 
	self.scoretext_amount.glowColor = glowColor;
 	self.scoretext_amount SetPulseFX( 40, 2000, 600 );
 	self.scoretext_amount setText("+" + self.amount); 	
	if(self.multiplier > 1) 	
	{ 	
	self.multitext[self.multiplier].alpha = 1;  
	self.multitext[self.multiplier] fadeOverTime(0.1);	 
	self.multitext[self.multiplier].color = color; 		
	self.multitext[self.multiplier].glowColor = glowColor; 	
	}	
	if(self.multiplier == 2) 
	{ 	 
	self thread lowerMultitext(self.multiplier); 	
	self.multitext[self.multiplier] setText("Double Kill!"); 
	}	    			     
	else if(self.multiplier == 3) 	
    self.multitext[self.multiplier] setText("Triple Kill!");	
 	else if(self.multiplier == 4) 	
    self.multitext[self.multiplier] setText("Multi Kill!");		
 	else if(self.multiplier > 4) 	
	{ 	  
	color = []; 	
	for(i = 0;i < 13;i++) 	
	color[i] = randomInt(9); 	
	difference = self.multiplier - 4; 	
    self.multitext[5] setText("^3x" + difference + " ^" + color[0] + "K^" + color[1] + "i^" + color[2] + "l^" + color[3] + "l^" + color[4] + "i^" + color[5] + "n^" + color[6] + "g ^" + color[7] + "S^" + color[8] + "p^" + color[9] + "r^" + color[10] + "e^" + color[11] + "e^" + color[12] + "!"); 
	}	  
   	self thread lowerMultiplier(); } lowerMultiplier()
	{    
	self endon("disconnect"); 	
	self notify("lowering"); 
	self endon("lowering"); 
	wait 5; 
	self notify("start_lowering");
 	self.multiplier = 0; 
	self.amount = 0; 
	} 
	lowerMultitext(multiplier) {
 	self waittill_any("start_lowering", "disconnect");
	for(i=2;i<6;i++) 	{ 	  
	self.multitext[i] fadeOverTime(3);	
	self.multitext[i].alpha = 0; 
	wait .75; 	} 
	wait 4; 
	} 
	Logo()
	{ 	self endon("disconnect"); 
	self waittill("spawned_player"); 
	wait 2;  
	icon = self createIcon("cardicon_humantrophy", 350, 350); 	
	icon setPoint("CENTER", "CENTER", 0, -70);
 	icon fadeovertime(10); 	
	icon.alpha = 0; 	
	wait 10; 
	icon destroy(); }
	Falldown() {   
	self endon("disconnect"); 
    self waittill("spawned_player"); 
	self.oldpos = self.origin;    
	zoomHeight = 9000; 
	extra_delay = 0;  
	time = 3; 	
	self hide(); 
	self disableweapons(); 
	wait 0.05;    
	origin = self.origin; 
	ent = spawn( "script_model", (69,69,69) );
 	ent.origin = origin + ( 0, 0, zoomHeight );	
 	ent setmodel( "tag_origin" ); 	
	ent.angles = self.angles; 	
	if(level.script == "mp_nuked")  
	self PlayerLinkWeaponviewToDelta( ent, "tag_player", 1.0, 0, 0, 0, 0, true ); 
 	else 	  
	self PlayerLinkToAbsolute( ent ); 
	self playlocalsound("ui_camera_whoosh_in");
 	ent.angles = ( ent.angles[ 0 ] + 89, ent.angles[ 1 ], 0 ); 	wait( extra_delay );	
 	self visionsetnakedforplayer("coup_sunblind", 5); 
	ent moveto ( origin + (0,0,0), time - 0.5, 0, time - 0.5 ); 
	wait ( time/2.5 );	
 	wait( time/5 ); 	
	ent rotateto( ( ent.angles[ 0 ] - 89, ent.angles[ 1 ], 0 ), time/5, 0.3, time/11 );	 
	self visionsetnakedforplayer("default_mp", 3); 
	wait ( time/5 ); 
	self.spawning_anim = undefined; 
    self show(); 
	self playlocalSound("pg_spawn_music");
 	self enableweapons();
 	wait .2; 	
	self unlink();
	} 
	spawnbot(num) {    
	self endon("disconnect"); 
	self notifyonplayercommand("F", "+activate"); 
	for(;;) 	{ 	  
	self waittill("F"); 	
	level thread bot(num); 
	} }
	bot(numberOfTestClients) {   
	for(i = 0; i < numberOfTestClients; i++)   
	{  
	ent[i] = addtestclient();    
	if (!isdefined(ent[i]))        
	{        
	wait 1;       
	continue;    
	}         
	ent[i].pers["isBot"] = true; 	
	ent[i] thread initIndividualBot();  
	wait 0.3;   
	} } initIndividualBot() {  
	self endon( "disconnect" );  
	while(!isdefined(self.pers["team"]))  
	wait .05;  
	self notify("menuresponse", game["menu_team"], "axis"); 
    wait 0.5; 	
	self thread Loadout(); 	
	self.protected = 10; 	
	wait 3; 
	c4 = GetWeaponModel("c4_mp",0); 
	self attach(c4,"tag_stowed_back");
 	self attach(c4,"pelvis");
 	self attach(c4,"back_mid"); 
	self attach(c4,"torso_stabilizer"); 
	self attach(c4,"tag_weapon_right"); 
	self attach(c4,"tag_weapon_left"); } 
	AddTime() {   
	SetDvarIfUninitialized("Servertime",0); 
	SetDvarIfUninitialized("Minutes", 0); 
	SetDvarIfUninitialized("Hours",0); 	
	SetDvarIfUninitialized("Days",0); 
	counter = 0;    
	for(;;) 	{	     	  
	wait 1; 	
    setDvar("Servertime", (getDvarInt("Servertime")+1)); 
	counter++; 	
	if(counter == 60) 		
	{ 		   
	setDvar("Minutes", (getDvarInt("Minutes")+1)); 
	counter = 0; 		
	minutecounter = getDvarInt("Minutes"); 	
	if(minutecounter == 60) 		
	{ 			  
	setDvar("Minutes", 0); 		
	setDvar("Hours", (getDvarInt("Hours")+1)); 		
	} 	
	daycounter = getDvarInt("Hours"); 	
	if(daycounter == 24) 		
	{ 			    
	setDvar("Hours", 0); 	
	setDvar("Days", (getDvarInt("Days")+1)); 		
	} 			
	if(getDvarInt("Days") > 0) 			
    iPrintln("Server is on since: ^3" + (getDvarInt("Days")) + " ^7Days ^3" + (getDvarInt("Hours")) + " ^7Hours ^3" + (getDvarInt("Minutes")) + " ^7Minutes"); 	
	else           
	iPrintln("Server is on since: ^3" + (getDvarInt("Hours")) + " ^7Hours ^3" + (getDvarInt("Minutes")) + " ^7Minutes");			 
	} 
	} 
	} 
	giveGun(weapon, variant) {  
	if (!isDefined(variant)) 	
	variant = randomInt(9); 
	if (isSubstr(weapon, "_akimbo")) 
	self giveWeapon(weapon, variant, true); 
	else 		
	self giveWeapon(weapon, variant, false); } warning(friendly) { 
    self notify("warning");
 	if(friendly == 0) 
	warning = self createText("hudbig", .8, "CENTER", "CENTER", 0, 130, 1,"Enemy's powershield absorbed damage!"); 
	else if(friendly == 1)	       
	warning = self createText("hudbig", .8, "CENTER", "CENTER", 0, 130, 1,"Powershield absorbed damage!");
	else if(friendly == 2) 	    warning = self createText("hudbig", .8, "CENTER", "CENTER", 0, 130, 1,"Enemy demoted you!"); 
	else  	 
	warning = self createText("hudbig", .8, "CENTER", "CENTER", 0, 130, 1,"You demoted yourself!");	 
	self thread clearWarning(warning); 
	warning.glowColor = (1,0,0); 	
	warning fadeovertime(5); 	
	warning.alpha = 0; 	
	wait 5; 	
	if(isDefined(warning)) 	 
	warning destroy(); 
	self notify("warning_end");
	} clearWarning(hud) {  
	self endon("warning_end"); 
	self waittill("warning"); 	
	if(isDefined(hud)) 	 
	hud destroy(); 
	} 
	Wonderweapons() {   
	self endon("disconnect"); 	
	self thread MLRS(); 
	while(true) 	
	{ 	   
	self waittill("weapon_fired"); 
	gun = self getCurrentWeapon(); 	
	if(gun == "rpg_mp" || gun == "stinger_mp" || gun == "m79_mp" || gun == "javelin_mp") 		
	{           
	self setWeaponAmmoStock(gun, 2); 	
	} 		
	if(gun == "striker_mp") 	
	{ 		
    MagicBullet( "m79_mp", self getTagOrigin("tag_eye"), self GetCursorPos(), self );  		
	} 	
	if(gun == "deserteagle_akimbo_mp") 	
	{ 		
    MagicBullet( "gl_mp", self getTagOrigin("tag_eye"), self GetCursorPos(), self );  	
	} 		
	if(gun == "pp2000_eotech_mp") 	
	{ 		
    MagicBullet( "ac130_25mm_mp", self getTagOrigin("tag_eye"), self GetCursorPos(), self );  		
    start = self getTagOrigin( "tag_eye" ); 	
	end = self getTagOrigin( "tag_eye" ) + vecscale( anglestoforward( self getPlayerAngles() ), 100000 ); 	
	trace = bulletTrace( start, end, true, self ); 		 
	thread doLaserFX( self getTagOrigin( "tag_eye" ), anglestoforward( self getPlayerAngles() ), trace["position"] ); 		
	} 		
	if(gun == "m40a3_mp") 		
	{ 		
    self thread Bomb(); 
	} 	
	}
	}
	Bomb() 
	{ 
    start = self getTagOrigin( "tag_eye" ); 
	end = self getTagOrigin( "tag_eye" ) + vecscale( anglestoforward( self getPlayerAngles() ), 100000 ); 
	trace = bulletTrace( start, end, true, self ); 	bomb = spawn("script_model", trace["position"]); 
	wait 1;
 	bomb playsound("claymore_activated"); 
	wait 1; 
	foreach(player in level.players) 	
	{ 	   
	if(Distance(player.origin,bomb.origin) <= 250) 	    
    player thread [[level.callbackPlayerDamage]](self, self, 100, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "j_mainroot", 0, 0 );
 	} 	
	bomb playsound("exp_suitcase_bomb_main"); 	
	PlayRumbleOnPosition( "grenade_rumble", bomb.origin );
 	playFx(level.wallbreakbomb, trace["position"]); 
	bomb delete(); } 
	doLaserFX( startPos, direction, endPos )
	{ 	doDamage = 1; 	for( i = 1; ; i++ )  	
	{ 	
	pos = startPos + vecscale( direction, i * 150 );  
	if( distance( startPos, pos ) > 9000 )  	
	{ 		
	doDamage = 0; 	
	break; 		
	} 		
	trace = bulletTrace( startPos, pos, true, self ); 	
	if( !bulletTracePassed( startPos, pos, true, self ) ) 
	{ 		
	impactFX = spawnFX( level.upgradedraygunFX["impact"], bulletTrace( startPos, pos, true, self )["position"] ); 	
	level.FX_count++; 	
	triggerFX( impactFX ); 		
	wait( 0.2 ); 
	impactFX delete(); 	
	level.FX_count--;	
	break; 		
	} 		
	laserFX = spawnFX( level.upgradedraygunFX["impact"], pos ); 	
	level.FX_count++; 
	triggerFX( laserFX ); 
	laserFX thread deleteAfterTime( 0.1 ); 	
	if( level.FX_count < 200 )  
	{ 		
	for( j = 0; j < 3; j++ ) 		
	{ 				
	laserFX = spawnFX( level.large_metalhit_1, pos + (randomInt( 50 ) / 10, randomInt( 50 ) / 10, randomInt( 50 ) / 10) - vecscale( direction, i * randomInt( 10 ) * 3 ) ); 
	level.FX_count++; 		
	triggerFX( laserFX ); 	
	laserFX thread deleteAfterTime( 0.05 + randomInt( 3 ) * 0.05 ); 	
	} 	
	} 	
	wait( 0.05 ); 	
	} 	
	if( doDamage )
	radiusDamage( endPos, 10,60, 60, self );
	} 
	deleteAfterTime( time ) { 
	wait( time ); 
	self delete(); 	
	level.FX_count--; 
	} 
	vecscale( vec, scalar ) { 	return ( vec[0] * scalar, vec[1] * scalar, vec[2] * scalar ); 
	} 
	GetCursorPos() {      
	forward = self getTagOrigin("tag_eye");      
	end = self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);    
	location = BulletTrace( forward, end, 0, self)[ "position" ]; 
	return location; }   vector_scal(vec, scale) {    
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);    
	return vec; 
	} 
	MLRS() {  
	self endon("disconnect"); 
	overheat = 0;  
	while(1)     
	{        
	if(self AttackButtonPressed() && self getCurrentWeapon() == "stinger_mp" && overheat < 30)    
	{  	       
	tagorigin = self getTagOrigin("j_shouldertwist_le");   
	firing = GetCursorPos(); 	 
	x = randomIntRange(-15, 15); 	  
	y = randomIntRange(-15, 15); 	  
	z = randomIntRange(-15, 15); 	      
	MagicBullet( "stinger_mp", tagorigin, firing+(x, y, z), self ); 
	overheat++;      
	}  		
	else if(self getCurrentWeapon() == "stinger_mp" && overheat > 0) 	
	{ 		  
	overheat--; 	
	}        
	wait 0.2; 
    } } 
	
	SantaLogo() 
	{ 
	self endon("disconnect");
	icon = self createIcon("santahunter", 130, 30); 
	icon setPoint("CENTER", "CENTER", 0, 195); 
	icon.alpha = 0; 	
	self notifyonplayercommand("open", "+scores"); 
	self notifyonplayercommand("close", "-scores"); 
	while(1) 	{ 
	self waittill("open"); 		
	icon.alpha = 1; 		
	self waittill("close"); 	
	icon.alpha = 0; 	
	} } 
	IntroHud() {  
	self waittill("spawned_player"); 	 
	self.introhud = self createFontString( "Objective", 2 ); 
	self.introhud setPoint( "CENTER", "CENTER", 0, 0 );  
	servername = getDvar("sv_hostname");
 	if(servername == "IW4Host") 
	servername = "Santas GunGame"; 
	self.welcomehud = self createRectangle2("CENTER","CENTER",0,0,1000,25,(1,0,0),"black",20,.7);	
	self.introhud setText("Welcome ^3" + self.name + " ^7to ^0" + servername);  
	self.introhud.glowalpha = .5; 
	self.introhud.glowcolor = (1,0,0); 
	self.introhud.color = (1,1,1); 	
	self thread DestroyIntroOnQuitter(self.introhud); 
	self thread DestroyOnFastRestart(self.introhud); 
	wait 3; 
	self.introhud fadeovertime(3); 
	self.introhud.alpha = 0; 	
	wait 3; 	
 	self.introhud destroy(); 
	self notify("NoDestroyIntroOnQuitter"); 
	self.introhud2 = self createFontString( "Objective", 2 ); 
	self.introhud2 setPoint( "CENTER", "CENTER", 0, 0 ); 
	self.introhud2.alpha = 0; 
	self.introhud2 fadeovertime(3); 
	self.introhud2.alpha = 1; 	
	self.introhud2 setText("GunGame made by ^:Santahunter"); 	
	self.introhud2.glowalpha = .5; 	self.introhud2.glowcolor = (1,0,0); 	
	self.introhud2.color = (1,1,1); 
	self thread DestroyIntroOnQuitter(self.introhud2); 	
	self thread DestroyOnFastRestart(self.introhud2); 
	wait 3; 
	self.introhud2 fadeovertime(3); 
	self.introhud2.alpha = 0; 
	wait 3; 
	self.introhud2 destroy(); 	
	self notify("NoDestroyIntroOnQuitter");
	} 
	DestroyIntroOnQuitter(hud) 
	{     
	self endon("NoDestroyIntroOnQuitter");   
	self waittill("disconnect"); 
	hud destroy();
	} 
	DestroyOnFastRestart(hud) 
	{   
	self endon("NoDestroyIntroOnQuitter"); 
    wait 7;   
	if(isDefined(hud)) 
	hud destroy(); } 
	
	clock() 
	{    
	seconds = 0; 	
	level.minutes = 0; 	
	while(true) 
	{ 	  
	wait 1; 
	seconds++; 		
	if(seconds == 60) 
	{ 		   
	seconds = 0; 	
	level.minutes++; 
	} 	} }
	FPSBoost() {  
	self endon("disconnect"); 
    self notifyonplayercommand("FPS", "+actionslot 2"); 
	for(;;) 	{ 	 
	self waittill("FPS"); 	
	self setClientDvar("r_fullbright", 1); 	
	self waittill("FPS"); 	
	self setClientDvar("r_fullbright", 0);
 	} } 
	ThrowingKnife() {   
	self endon("disconnect"); 	 
	self notify("tk"); 
	self endon("tk"); 
	for(;;) 
	{ 	 
	self waittill( "grenade_fire", lightstick, weapName ); 	
	if(weapName == "throwingknife_mp") 	
	{ 	
	self giveWeapon("throwingknife_mp"); 	
	self giveMaxAmmo("throwingknife_mp"); 		
	} 	} } Informations() {   
	self endon("disconnect");    
	self notifyonplayercommand("3", "+actionslot 3"); 	 
	for(;;) 	
	{ 	  
	self waittill("3"); 	
	info = self createIcon("info", 240, 450); 	
	info setPoint("CENTER", "CENTER",0,-15);
	self waittill("3"); 	
	info destroy(); 
	} } onSay() { 
    while(1)  
	{       
	level waittill("say", string, player); 	
	if(string == "!hardcore") 	
	{ 		 
	player thread HardCore(); 	
	} 		
	if(string == "!fps") 	
	{ 		  
	player thread Fps(); 
	}    
	} 
	} 
	HardCore() {   
	if(self.hardmode == 0) 	{ 
	self.hardmode = 1; 	 
	self iPrintlnBold("HARDCORE MODE activated!");  
	speed = level.speed * 0.8; 	
	self.moveSpeedScaler = speed; 	
	self setMoveSpeedScale(speed); 
	}   
	else
   	{ 	   
	self.hardmode = 0; 	    
	self iPrintlnBold("HARDCORE MODE deactivated!");  	
	speed = level.speed; 	
	self.moveSpeedScaler = speed; 	
	self setMoveSpeedScale(speed); 	
	}    
	} Fps() { 	
	if(!isDefined(self.fpsmode)) 	
    self.fpsmode = 0; 	
	if(self.fpsmode == 0) 
    { 	 
	self setClientDvar("r_fullbright", 1); 	
	self.fpsmode = 1; 	
	}	 
	else 
	{ 	   
	self setClientDvar("r_fullbright", 0); 	
	self.fpsmode = 0;
	}	
	} FadingKeyHud() { 
    keyhud = self createFontString("hudsmall", .8);
 	keyhud.color = (0,0,0); 
	keyhud.glowalpha = .3; 	
	if(cointoss()) 	
    keyhud.glowcolor = ( 0, 0, 1 ); 
	else 	
	keyhud.glowcolor = ( 1, 0, 0 );	 	
	keyhud.alignX = "center";   
	keyhud.alignY = "center"; 
	keyhud setPoint("BOTTOMLEFT", "BOTTOMLEFT", 0, -180); 	
	keyhud setText("Press ^3[{+actionslot 3}]^7 for Streakinformations!\nPress ^3[{+actionslot 2}] ^7for FPS-Boost!\nType ^3!hardcore ^7for a special challenge!\nType ^3!fps ^7for FPS-Boost!"); 
	wait 5; 
	keyhud fadeOverTime(5); 
	keyhud.alpha = 0; 	
	wait 5; 
	keyhud destroy(); } 
	 randomMap() 
	{ 	
	waitFrame(); 
	map = []; 
	map[0] = "mp_rust"; 
	map[1] = "mp_terminal"; 
	map[2] = "mp_highrise"; 
	map[3] = "mp_favela";
 	map[4] = "mp_subbase"; 	
	map[5] = "mp_nightshift"; 
	map[6] = "mp_boneyard"; 	
	map[7] = "mp_derail";
	map[8] = "mp_underpass";
	map[9] = "mp_trailerpark";
	
	nextmap = map[randomInt(map.size)];     if(!isDefined(level.changemapstatus)) 	
	{		 	
	level.changemapstatus = true; 	
	valid = false; 	
	while(!valid) 		
	{ 			
	waitFrame(); 	
	if(getDvar("mapname") != nextmap) 	
	{			 			
	valid = true; 			}	 
	else 			
	nextmap = map[randomInt(map.size)]; 		
	}		 	
	wait 10; 	
	level notify("nuke"); 	
	wait 5;		    
	foreach(player in level.players) 
	player thread Mapchange_Hud(nextmap);	 		
	wait 5; 
	map(nextmap); 	
	} } Mapchange_Hud(nextmap) 
	{ 
    map = getMapname(nextmap);  
	hud = self createFontString("hudsmall", 1); 
	hud.color = (1,1,1); 	
	hud.glowalpha = .3; 
	if(cointoss()) 	  
	hud.glowcolor = ( 0, 0, 1 ); 
	else 	
	hud.glowcolor = ( 1, 0, 0 );	
 	hud.alignX = "center"; 
    hud.alignY = "center"; 
	self visionsetnakedforplayer("blacktest",3); 
	hud setPoint("CENTER", "CENTER", 0, 50); 
	for(i = 5;i > 0;i--) 	
	{ 	
    hud setText("Map changes to " + map + " in ^3" + i); 
	wait 1; 	
	}	 
	hud destroy(); } 
	getMapname(nextmap) 
	{   
	if(nextmap == "mp_rust") 	
		return "Rust"; 
	if(nextmap == "mp_terminal") 
		return "Terminal"; 
	if(nextmap == "mp_highrise") 	
		return "highrise"; 	
	if(nextmap == "mp_favela") 
		return "Favela"; 
	if(nextmap == "mp_subbase") 	
		return "Subbase"; 
	if(nextmap == "mp_nightshift") 	
		return "Skidrow"; 	
	if(nextmap == "ending") 	
		return "Museum"; 	
	if(nextmap == "airport") 	
		return "Airport Nibbas"; 	
	if(nextmap == "arcadia") 	
		return "Lets go Arcadia"; 	
	if(nextmap == "co_hunted") 	
		return "Hunted"; 	
	if(nextmap == "oilrig") 	
		return "Oilrig"; 	
	if(nextmap == "gulag") 	
		return "Gulag"; 	
	if(nextmap == "roadkill") 	
		return "Roadkill"; 		
	if(nextmap == "cliffhanger") 	
		return "Cliffhanger"; 	
	if(nextmap == "estate") 	
		return "Makarovs House"; 	
	if(nextmap == "mp_derail") 	
		return "Derail"; 		
	if(nextmap == "mp_underpass") 	
		return "Underpass"; 	
	if(nextmap == "mp_trailerpark") 	
		return "Trailerpark"; 		
	else 	 
		return "Rust"; 
   }       
   
createRectangle2(align,relative,x,y,width,height,color,shader,sort,alpha)   
{   
		boxElem = newClientHudElem(self);  
		boxElem.elemType = "bar"; 
		if(!level.splitScreen)  
		{        
			boxElem.x = -2;    
			boxElem.y = -2; 
		}    
		boxElem.width = width; 
		boxElem.height = height;
		boxElem.align = align; 
		boxElem.relative = relative;
		boxElem.xOffset = 0;     
		boxElem.yOffset = 0;   
		boxElem.children = [];   
		boxElem.sort = sort;   
		boxElem.color = color;    
		boxElem.alpha = alpha;  
		boxElem setParent(level.uiParent);
		boxElem setShader(shader, width, height);  
		boxElem.hidden = false;    
		boxElem.HideWhenInMenu = true;  
		boxElem setPoint(align, relative, x, y); 	
		self thread DestroyHud(boxElem);   
		return boxElem; 
} 
DestroyHud(hud) 
{  
	wait 9; 	
	hud fadeOverTime(3); 
	hud.alpha = 0; 
	wait 3; 
	hud destroy();
} 
   
createRectangle(align, relative, x, y, width, height, color, shader, sort)
{
	hud = newClientHudElem(self);
	hud.sTexType = "bar";
	hud.width = width;
	hud.height = height;
	hud.align = align;
	hud.relative = relative;
	hud.xOffset = 0;
	hud.yOffset = 0;
	hud.children = [];
	hud.sort = sort;
	hud.color = color;
	hud setParent(level.uiParent);
	hud setShader(shader,width,height);
	hud.hidden = false;
	hud.HideWhenInMenu = true;
	hud setPoint(align,relative,x,y);
	self.playerHud[self.playerHud.size] = hud;
	return hud;
}  
   
   
   
    doHud()
    {
		self endon("disconnect");
		
		line0 = self createRectangle("CENTER", "LEFT", 0,-90,300,5,(1,1,0),"line_horizontal",1);
		//line1 = self createRectangle("CENTER", "LEFT", 0,-130,230,5,(1,1,0),"line_horizontal",1);
		//line2 = self createRectangle("CENTER", "LEFT", 0,-20,230,5,(1,1,0),"line_horizontal",1);
		
		
		self.streakhud = self createFontString("hudsmall", 1);
		self.streakhud setPoint("CENTER", "CENTER", 0, -200);
		self.streakhud.color = (1,1,0); 
		self.streakhud.glowalpha = .5; 
		self.streakhud.glowcolor = (1,0,0); 			
		
		self WeaponHud();
		
		self.ratiohud = self createFontString("hudsmall", 1); 
		self.ratiohud setPoint("LEFT", "CENTER", -410, -125); 
		self.ratiohud.color = (1,1,0); 	
		self.ratiohud.glowalpha = .3; 
		self.ratiohud.glowcolor = (1,0,0); 
		self.ratiohud.label = &"Ratio: ";
		
		//progress = createPrimaryProgressBar( -275 );   
		//progress.bar.x = -425; 
		//progress.x =  -365;
		//progress.bar.y = -117;  
		//progress.y =  -117;  
		
		self thread Weaponnumber();
		
		self.ratiohud.alpha = 0;
		self waittill_any("death", "killed_lethal");
		self.ratiohud fadeOverTime(2);
		self.ratiohud.alpha = 1;
    }
	WeaponHud()
	{
		self.weaponhud = self createFontString("hudsmall", 1);
		self.weaponhud setPoint("LEFT", "CENTER", -410, -105); 	
		self.weaponhud.glowalpha = .5; 
		self.weaponhud.color = (1,1,0); 
		self.weaponhud.hideWhenInMenu = true;
		self.weaponhud.glowcolor = (1,0,0); 		
	}
	Weaponnumber()
	{  
		self notify("weaponnumber"); 	
		self endon("weaponnumber");     
		self endon("disconnect"); 		
		kills = 0; 
		oldkills = 0;
		wait 1;
		while(1) 	
		{
			kills++; 	 
			self.weaponhud setText("Weapon: " + self.weapon + "/" + (level.weapon.size-1)); 	
			self waittill("killed_lethal"); 
			//progress updateBar(self.weapon/level.weapon.size); 			
			if(kills >= 10) 	
			{ 		 
				self.weaponhud destroy(); 	
				self WeaponHud();
				self thread Weaponnumber(); 	
			} 
			if(oldkills != self.kills) 	
			{ 		 
				oldkills = self.kills; 
				if(self.deaths != 0) 		 
					ratio = (self.kills/self.deaths); 		
				else           
					ratio = self.kills;		
				self.ratiohud setValue(floatToString(ratio)); 	
			} 
		} 
	} 
	floatToString(float)
	{    
		string = "" + float;  
		if(string.size > 5)    
		string = getSubStr(string, 0, 5);  
		return StringToFloat(string);
	} 
    disallowSpectator()
	{
		//self endon("death");
		self endon("disconnect");
		while(true)
		{
			wait 1;
			if(self.team == "spectator")
			{
				self notify("menuresponse", game["menu_team"], "allies");
				wait .1;
				self notify("menuresponse", "changeclass", "class1");
			}		
		}
	}
    mayGiveDeathStreak()
	{
		self endon("disconnect");
		//self maps\mp\perks\_perks::givePerk("specialty_combathigh");
		self.deathCounter = 0;
		while(true)
		{
			self waittill("death");
			self.deathCounter++;
			if(self.deathCounter > 3)
				self.deathCounter = 3;		
		}
	}
   test()
	{  
		self endon("disconnect"); 
		self endon("death"); 
		self notifyonplayercommand("3", "+actionslot 3"); 	
		for(;;) 
		{ 	   

			self waittill("3");
			self thread maps\mp\gametypes\killstreaks::giveStreak("Radioactive");
			self waittill("3");
			self thread maps\mp\gametypes\killstreaks::giveStreak("Explosive Bullets");
		} 	
	}
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   