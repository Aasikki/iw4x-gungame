#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

Init()
{
	precacheLocationSelector("map_nuke_selector"); // can be any image

	wait 1;
	if(level.killstreaks == 0)
	    return;
    level thread onPlayerConnect();
	
	level.streaks = [];
	
	level.streaks[0][0] = "No Recoil";
	level.streaks[0][1] = "Speed";
	level.streaks[0][2] = "Explosive Bullets";
	level.streaks[0][3] = "Riotshield";
	
	level.streaks[1][0] = "Jetpack";
	level.streaks[1][1] = "Juggernaut"; //  Suicide Bomber	
	level.streaks[1][2] = "I.M.S"; 
	level.streaks[1][3] = "Radioactive";
	
	level.streaks[2][0] = "Bomber";
	level.streaks[2][1] = "XRay";
	level.streaks[2][2] = "Gl Sentry";
	level.streaks[2][3] = "Godmode";
}
onPlayerConnect()
{
    while(1)
	{
	    level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}
onPlayerSpawned()
{
    self endon("disconnect");
	self.streaks = [];
	self.stack = [];
	self.stackLength = 0;
	self.hasSentry = false;
	self.hasBomber = false;
	self.hasims = false;
	self thread tryUseStreak();
	//self thread test();
	for(;;)
	{
	    self waittill("spawned_player");
		self.streaks[0] = getStreak(0);
		self.streaks[1] = getStreak(1);
		self.streaks[2] = getStreak(2);
		self thread drawStreaks();
		self thread OnKilling();
	}
}
drawStreaks()
{
	if(isDefined(self.streakIcons[0]))
	{
		for(i=0;i<3;i++)
		{
			self.streakIcons[i] destroy();		    
		} 
		self.streakText destroy();
	}  
	self.streakIcons = [];
	for(index = 0;index < 3;index++)
	{
		self.streakIcons[index] = self createFontString( "objective", 2 );
        self.streakIcons[index].foreground = false;
        self.streakIcons[index].hideWhenInMenu = true;
        self.streakIcons[index].fontScale = 1;
        self.streakIcons[index].font = "hudbig";
        self.streakIcons[index].alpha = 1;
        self.streakIcons[index].glow = 1;
        self.streakIcons[index].glowColor = ( 0, 0, 1 );
        self.streakIcons[index].glowAlpha = 1;
        self.streakIcons[index].color = ( 1.0, 1.0, 1.0 );
		self.streakIcons[index] setPoint("RIGHT", "RIGHT", 0, 0-(index *45));
        self.streakIcons[index] setShader(getStreakIcon(self.streaks[index]), 40, 40 );
	}
	self.streakText = self createFontString( "objective", 2 );
    self.streakText.foreground = false;
    self.streakText.hideWhenInMenu = true;
    self.streakText.fontScale = 1;
    self.streakText.font = "hudbig";
    self.streakText.alpha = 1;
    self.streakText.glow = .3;
    self.streakText.glowColor = ( 1, 0, 0 );
    self.streakText.glowAlpha = 1;
    self.streakText.color = ( 1.0, 1.0, 0.0 );
	self.streakText setPoint("RIGHT", "RIGHT", -50, 0);
}
KillingSpree(kills, user)
{
   self notify("notfyhud"); // needed?
   self endon("notfyhud");
   self.streakhud.alpha = 1;
   self.streakhud setText("" + user.name + " ^7made " + kills + " kills in a row!");
   self.streakhud fadeOverTime(4);
   self.streakhud.alpha = 0;
}
KillstreakSplash(message, user)
{
    self notify("notfyhud");
    self endon("notfyhud");
	self.streakhud.alpha = 1;
	self.streakhud setText("" + user.name + " ^7has " + message);	
	self.streakhud ChangeFontScaleOverTime( 0.2 ); 
    self.streakhud.fontScale = 1.2; 
	self.streakhud fadeOverTime(6);
	self.streakhud.alpha = 0;
	wait .2;
    self.streakhud ChangeFontScaleOverTime( 0.2 ); 
    self.streakhud.fontScale = .8; 
	wait 4;
    self.streakhud setText("");
}
getStreak(index)
{
	/*
	if(index == 0)
		value = 4;
	else if(index == 1)
		value = 4;
	else 
		value = 4;
	*/
	value = 4;
	return level.streaks[index][randomInt(value)];
}
getStreakIcon(streak)
{
	if(streak == "Riotshield")
		return "cardicon_helmet_brit_ww2";
	if(streak == "Speed")
		return "cardicon_boot";
	if(streak == "No Recoil")	
		return "cardicon_headshot";
	if(streak == "Suicide Bomber")	
		return "cardicon_ghost_mic";
	if(streak == "Radioactive")	
		return "cardicon_biohazard"; //cardicon_hazard
	if(streak == "Juggernaut")	
		return "cardicon_juggernaut_2";
	if(streak == "Jetpack")	
		return "cardicon_paratrooper";
	if(streak == "XRay")	
		return "cardicon_xray";	
	if(streak == "Gl Sentry")	
		return "dpad_killstreak_sentry";
		//return tableLookup( "mp/killstreakTable.csv", 1, "sentry", 14 );
	if(streak == "Bomber")	
		return "cardicon_b2";	
	if(streak == "Explosive Bullets")
		return "cardicon_fmj";
	if(streak == "I.M.S")
		return "cardicon_thebomb";	
	if(streak == "Godmode")
		return "cardicon_chicken";
	return "cardicon_cod4";
}
OnKilling()
{
	self endon("disconnect");
	self endon("death");
	spree = 0;
	value = 3;
	counter = 1;
	self.streakText setValue(value);
	while(true)
	{
		kills = self.kills;
		wait .1;
		if(kills != self.kills)
		{
			for(i = kills;i < self.kills;i++)
			{
				spree++;
				value--;				
				if(spree == 3 || spree == 6 || spree == 9)
				{
					streak = self giveReward(spree);
					self thread doStreakPopup(spree,streak);
					if(spree == 9)
						spree = 0;
				}
				if(value == 0)
				{
					value = 3;
					if(counter < 3)
					{
						y = self.streakText.y - 45;
						self.streakText setPoint("RIGHT", "RIGHT", -50, y);						
						counter++;
					}
					else
					{
						self.streakText setPoint("RIGHT", "RIGHT", -50, 100);
						counter = 1;
						self.streaks[0] = getStreak(0);
						self.streaks[1] = getStreak(1);
						self.streaks[2] = getStreak(2);
						self thread drawStreaks();
					}
				}
				self.streakText setValue(value);				
			}
		}
	}
}
doStreakPopup(spree, streak)
{
	notifyHello = spawnstruct();
	notifyHello.glowColor = (0.0, 0.6, 0.3);
	notifyHello.titleText = spree + " Streak";
	notifyHello.notifyText = streak;	
	notifyHello.iconName = getStreakIcon(streak);	
	notifyHello.hideWhenInMenu = true;
	notifyHello.sound = "mp_level_up"; 
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyHello );
}
giveReward(spree)
{
	streak = "";
	if(spree == 3)
		streak = self.streaks[0];
	else if(spree == 6)
		streak = self.streaks[1];
	else if(spree == 9)
		streak = self.streaks[2];	
	foreach(player in level.players)
		player thread KillstreakSplash(streak, self);
	self thread giveStreak(streak);
	return streak;	
}
tryUseStreak()
{
	self endon("disconnect");
	self notifyOnPlayerCommand("tryStreak", "+actionslot 4");
	while(true)
	{
		self waittill("tryStreak");
		if(self.hasSentry)
		{
			//self thread tryUseGlSentry();
			self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry();
			self.hasSentry = false;
		}			
		else if(self.hasBomber)
		{
			self thread tryUseBomber();
			self.hasBomber = false;
		}	
		else if(self.hasims)
		{
			self thread tryUseIMS();
			self.hasims = false;
		}
	}
}
infoText(item)
{
	infotext = self createFontString("hudsmall", 1);
	infotext  setPoint("CENTER", "CENTER", 0, -50);
	infotext.color = (1,1,0); 
	infotext.glowalpha = .5; 
	infotext.glowcolor = (1,0,0); 		
	infotext setText("Press [{+actionslot 4}] to use " + item);
	//infoText fadeOverTime(2);
	//infoText.alpha = 0;
	wait 2;
	if(isDefined(infoText))
		infoText destroy();
}
getStreakSoundId(streak)
{
	if(streak == "Riotshield")
		return "riotshield";
	if(streak == "No Recoil")
		return "norecoil";
	if(streak == "Speed")
		return "speed";
	if(streak == "Gl Sentry")
		return "glsentry";
	if(streak == "Suicide Bomber")
		return "suicidebomber";
	if(streak == "Jetpack")
		return "jetpack";
	if(streak == "Bomber")
		return "bomber";
	if(streak == "I.M.S")
		return "ims";
	if(streak == "Juggernaut")
		return "juggernaut";
	if(streak == "Explosive Bullets")
		return "explosivebullets";
	if(streak == "Radioactive")
		return "radioactive";
	if(streak == "XRay")
		return "xray";
	if(streak == "Godmode")
		return "godmode";
	return "";
}
playStreakSound(streak)
{
	id = getStreakSoundId(streak);
	if(id == "")
		return;
	if(!isDefined(level.streakSounds))
		level.streakSounds = [];
	if(!isDefined(level.streakSounds[id]))
		level.streakSounds[id] = fileExists("streaksounds/" + id + ".wav");
	if(level.streakSounds[id])
		self playLocalSound("gg_streak_" + id);
}
giveStreak(streak)
{
	self thread playStreakSound(streak);
	if(streak == "Riotshield")
	{
		//self giveWeapon("riotshield_mp",0,false);
		//wait .2;
		//self switchToWeapon("riotshield_mp");
		self AttachShieldModel( "weapon_riot_shield_mp", "tag_shield_back" );
		//self setClientDvar("cg_thirdPerson", 1);
		wait 2;
		self iPrintlnBold("Riotshield attached on your back");
		//self setClientDvar("cg_thirdPerson", 0);
	}
	else if(streak == "No Recoil")
	{
		self player_recoilScaleOn(0);
	}
	else if(streak == "Speed")
	{
		self.speed = 1;
		wait 1;
		self maps\mp\perks\_perks::givePerk("specialty_lightweight");
		self maps\mp\perks\_perks::givePerk("specialty_lightweight");
		self setMoveSpeedScale(2.0);
		self.setMoveSpeedScale = 2.0;
		playfxontag( level.fx_airstrike_contrail, self, "pelvis" );
	}
	else if(streak == "Gl Sentry")
	{
		self.hasSentry = true;
		self thread infoText("Sentrygun");
	}
	else if(streak == "Suicide Bomber") // seems to crash the game at some point
	{
		/*self endon("disconnect");
		c4 = GetWeaponModel("c4_mp",0);
		self attach(c4,"tag_stowed_back");
		self attach(c4,"pelvis");
		self attach(c4,"back_mid");
		self attach(c4,"torso_stabilizer");
		self attach(c4,"j_head");
		self attach(c4,"tag_weapon_right");
		self attach(c4,"tag_weapon_left");
		self waittill("death");
		//PlayRumbleOnPosition( "grenade_rumble", self.origin );
		earthquake( 0.4, 0.75, self.origin, 512 );
		MagicBullet("ac130_105mm_mp", self.origin+(0,0,20), self.origin, self);*/
	}
	else if(streak == "Jetpack")
	{
		self thread Jetpack();
	}
	else if(streak == "Bomber")
	{
		self.hasBomber = true;
		self thread infoText("Bomber");
	}
	else if(streak == "I.M.S")
	{
		self thread tryUseIMS();
		self thread infoText("I.M.S");
	}
	else if(streak == "Juggernaut")
	{
		self.maxhealth = 175;
		self.health = self.maxhealth;
		//self [[game["allies_model"]["RIOT"]]]();
	}
	else if(streak == "Explosive Bullets")
	{
		self thread Explosive();
	}
	else if(streak == "Radioactive")
	{
		self endon("disconnect");
		self endon("death");
		playFxOnTag( level.spawnGlow["enemy"], self, "pelvis" ); 
		playFxOnTag( level.spawnGlow["friendly"], self, "j_head" );
		//self SetPlayerIgnoreRadiusDamage( true );
		while(1)
		{
			wait .5;
			//self RadiusDamage(self.origin,120,50,40,self,"MOD_Explosive","nuke_mp");
			//RadiusDamage(self.origin, 50, 30, 20, self );
			foreach(player in level.players)
			{
				if(player == self)
					continue;
				if(Distance(player.origin,self.origin) < 100)
				{
					player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( self, self, 20, 0, "MOD_MELEE", "none", player.origin, player.origin, "none", 0, 0 );
					self thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback("");
				}
			}		
		}
	}
	else if(streak == "XRay")
	{		
		self thread Wh();
	}
	else if(streak == "Godmode")
	{
		self thread Godmode();
	}
	else 
	{
		self iPrintln("^1ERROR: unknown streak!");
	}
}
Godmode()
{
	self endon("disconnect");
	self endon("death");
	self iPrintln("Make a kill to gain godmode");
	for(;;)
	{
		self waittill("killed_enemy");
		self.hasGodmode = true;
		self thread GodActivated();
	}
}
GodActivated()
{
	self endon("disconnect");
	self endon("death");
	self notify("god");
	self endon("god");
	if(isDefined(self.godHud))
		self.godHud destroy();
	self.godHud = self createFontString("default", 1.5);
	self.godHud setPoint("CENTER", "BOTTOM", 0, -130);
	self.godHud.glowAlpha = 1;
	self.godHud.hideWhenInMenu = true;
	self.godHud.glowColor = (0,.8,0);
	self.godHud.label = &"Godmode activated for: ";
	for(i = 4;i > 0;i--)
	{
		self.godHud setValue(i);
		wait 1;
	}
	self.hasGodmode = false;
	self.godHud fadeOverTime(1);
	self.godHud.alpha = 0;
	wait 1;
	if(isDefined(self.godHud))
		self.godHud destroy();
}
Wh()
{
	self endon("death");
	self endon("disconnect");
	self notify("wh");
	self endon("wh");
	self ThermalVisionFOFOverlayOn();
	for(i = 30;i > 0;i--)
	{
		wait 1;
		self iPrintln("Infrared Vision for: " + i);
	}
	self ThermalVisionFOFOverlayOff();
}
Explosive()
{
    self endon("disconnect");
	self endon("death");
	self notify("exploagain");
	self endon("exploagain");
	self.explodmg = 40;
	self.explomindmg = 20;
	self.explotime = .1;
	for(;;)
	{
	    self waittill("weapon_fired");
		class = WeaponClass(self getCurrentWeapon());
		self setClassTime(class);
		forward = self getTagOrigin("j_head");
        end = self thread vector_scal(anglestoforward(self getPlayerAngles()),1000000);
        Location = BulletTrace( forward, end, 0, self )[ "position" ];
		playFx(level.explosionfx, Location); 	
		RadiusDamage(Location, 50, 30, 20, self );
		//self RadiusDamage(Location,250,self.explodmg,self.explomindmg,self,"MOD_Explosive","barrel_mp");
		wait self.explotime;
	}
}
setClassTime(class)
{
    if(class == "rifle")
	{
	    self.explodmg = 20;
	    self.explotime = 0;
		self.explomindmg = 1;
	}
	else if(class == "smg")
	{
	    self.explodmg = 20;
	    self.explotime = 0;
		self.explomindmg = 1;
	}
	else if(class == "spread")
	{
	    self.explodmg = 30;
	    self.explotime = .5;
		self.explomindmg = 10;
	}
	else //pistol
	{
	    self.explodmg = 40;
	    self.explotime = 1;
		self.explomindmg = 15;
	}
}

Jetpack()
{
    self endon("death");
	self endon("disconnect");
	self notify("jetpack");
	self endon("jetpack");
	self iPrintlnBold("^3Press ^1F ^7to use ^:Jetpack!");
    self.jetpack = 80;
    self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	self.fx = [];
    self.fx[0] = loadfx ("smoke/smoke_trail_white_heli");
    self.fx[1] = loadfx( "misc/flares_cobra" );     
    JETPACKBACK = createPrimaryProgressBar( -275 );
    JETPACKBACK.bar.x = 40;
    JETPACKBACK.x = 100;
    JETPACKTXT = createPrimaryProgressBarText( -275 );
    JETPACKTXT.x=100;
	if(randomInt(10) < 8)
        JETPACKTXT settext("^:Jetpack");
	else
	{
	    JETPACKTXT settext("^:Big Jetpack");
		self.jetpack = 120;
	}	    
    self thread dod(JETPACKBACK.bar,JETPACKBACK,JETPACKTXT);
    self attach("projectile_hellfire_missile","tag_stowed_back");
    while(true)
    {
        if(self usebuttonpressed() && self.jetpack>0)
        {
            //self playsound("veh_ac130_sonic_boom");
            //self playsound("veh_mig29_sonic_boom");
			self playsound("cobra_helicopter_dying_loop");
            self setstance("crouch");
            playfx(self.fx[0],self gettagorigin("j_spine4"));
			playfx(self.fx[1],self gettagorigin("j_spine4"));
            earthquake(.15,.2,self gettagorigin("j_spine4"),50);
            self.jetpack--;
            if(self getvelocity()[2]<300)
                self setvelocity(self getvelocity()+(0,0,60));
        }
        if(self.jetpack < 80 &&!self usebuttonpressed())
            self.jetpack++;
        JETPACKBACK updateBar(self.jetpack/80);
        JETPACKBACK.bar.color=(1,self.jetpack/80,self.jetpack/80);
        wait .05;
    }
}

dod(a,b,c)
{
    self waittill_any("death", "disconnect", "jetpack");
    a destroy();
    b destroy();
    c destroy();
}
tryUseGlSentry()
{
	self endon("disconnect");
	loop = true;
	valid = true;
	self disableWeapons();
	sentry = spawn("script_model", self.origin+(50,0,30));
	sentry setModel(level.sentrySettings["sentry_minigun"].modelPlacement);
	while(loop)
	{
		wait .1;
		sentry.angles = self getPlayerAngles();
		sentry.angles = (0,sentry.angles[1],0);
		//sentry.origin = self getCursorPos(100);
		sentry.origin = self getForwardPos(self.origin+(0,0,10),60);
		//sentry.origin = self.origin;
		if(bulletTracePassed(self.origin, self.origin - (0, 0, 5), false, self))
		{
			sentry setModel(level.sentrySettings["sentry_minigun"].modelPlacementFailed);
			valid = false;
		}
		else
		{
			sentry setModel(level.sentrySettings["sentry_minigun"].modelPlacement);
			valid = true;
		}
		if(self AttackButtonPressed() && valid)
		{
			loop = false;
		}
	}
	self enableWeapons();
	sentry delete();
	sentry = spawnTurret( "misc_turret", self getForwardPos(self.origin,60), "sentry_minigun_mp" );
	sentry setModel( "sentry_minigun" );
	sentry.angles = self getPlayerAngles();
	sentry.angles = (0,sentry.angles[1],0);
	sentry.owner = self;
	sentry.team = self.team;
	sentry SetSentryOwner(self);
	sentry SetConvergenceTime(0.5);
	sentry SetSuppressionTime(0.5);
	sentry SetTurretMinimapVisible( true );
	sentry laserOn();
	sentry setMode( "auto_nonai" );
	sentry makeTurretInoperable();
	sentry Makeusable();
	sentry SetSentryOwner(self);
	sentry SetTurretMinimapVisible( true );
	sentry setBottomArc(360);
	sentry setTopArc(360);
	sentry setRightArc(360);
	sentry setLeftArc(360);
	sentry thread SentryHealth(self);
	sentry thread SentryAttack(self);
	sentry thread onPlayerDeath(self);
	return true; // unecessary
}
SentryHealth(owner)
{
	sentryDamage = spawn("script_model", self.origin);
	sentryDamage setModel( "sentry_minigun" );
	sentryDamage.angles = (0,self.angles[1],0);
	//sentryDamage.owner = owner;
	sentryDamage.team = owner.team;
	sentryDamage hide();
	sentryDamage EnableLinkTo();
	sentryDamage LinkTo(self);
	self.SentryDamage = SentryDamage;
	self.SentryDamage SetCanDamage(true);
	self.SentryDamage.maxhealth = 9999;
	self.SentryDamage.health = 9999;
	while(1)
	{
		self.SentryDamage waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
		//if(attacker == self || attacker.team == self.team)
		//	continue;
		if(type == "MOD_MELEE")
			damage = 9999;
		attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "" );
		self.health -= damage;
		if(self.health <= 0)
			break;			
	}
	self deleteSentry(owner);
}
SentryAttack(owner)
{
	owner endon("disconnect");
	self endon("death");
	bullets = 10;
	wait 2;
	while(bullets > 0)
	{
		targetEnt = self getTurretTarget(false);
		if(isDefined(targetEnt))
		{
			if(Distance(self.origin, targetEnt.origin) < 400)
			{
				for(i = 0; i < 3; i++)
				{
					self ShootTurret();				
				}
			}
			else
			{
				wait 1;
				MagicBullet("m79_mp", self getForwardPos(self.origin+(0,0,47),40), targetEnt.origin+(0,0,20),owner);
				bullets--;
			}
		}
		wait .1;
	}
	self deleteSentry(owner);
}
onPlayerDeath(owner)
{
	self endon("delete_sentry");
	owner waittill_any("death", "disconnect");
	self deleteSentry(owner);
}
deleteSentry(owner)
{
	self notify("delete_sentry");
	playFx( level._effect[ "sentry_explode_mp" ], self.origin+(0,0,30));
	owner leaderDialogOnPlayer("sentry_gone");
	wait 2;
	self.SentryDamage delete();
	self delete();
}
GetCursorPos(dist)
{
	if(!isDefined(dist))
	{
		iPrintln("^1ERROR: no distance for getCursorPos defined!");
		return;
	}	
	end = self.origin + vector_Scal(AnglesToUp(self.angles),dist); 			
	bulletTrace = BulletTrace(self.origin, end,true);
	pos = BulletTrace(bulletTrace["position"],bulletTrace["position"]+(0,0,-200),false);
	return(pos["position"]);		
	
}
vector_scal(vec, scale)
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}

test()
{
	self notifyOnPlayerCommand("n", "+actionslot 1");
	while(1)
	{
		self waittill("n");
		self thread tryUseIMS();
	}
}

tryUseBomber()
{
	self endon("disconnect");
	self endon("death");
	self endon("cancel_location");
	self beginLocationSelection( "map_nuke_selector", false, ( level.mapSize / 5.625 ) ); // map_artillery_selector
    self.selectingLocation = true;
    self waittill( "confirm_location", location, directionYaw );
	self endLocationSelection();
	self.selectingLocation = undefined;
	self thread useBomber(location);
	return true;
}
useBomber(location)
{
	plane = [];
	start = location+(20000,0,3000);
	if(getDvar("mapname") == "mp_highrise")
		start = start + (0,0,2000);
	end = location+(-20000,0,3000);
	angles = VectorToAngles(end-start);
	for(i = 0;i < 10;i++)
	{
		myStart = start + (0,i*2000,0);
		myEnd = end + (0,i*2000,0);
		plane[i] = spawn("script_model", myStart);
		plane[i] setModel("vehicle_ac130_low_mp");
		plane[i].angles = (0,angles[1],0);
		plane[i] moveTo(myEnd,20);
		plane[i] thread planeAttack(location, self);
		plane[i] thread deletePlane();
		wait .5;
	}
}	
planeAttack(pos,owner)
{
	for(i = 0;i < 20;i++)
	{
		x = randomInt(1500);
		y = randomInt(1500);
		if(cointoss())
			x *=-1;
		if(cointoss())
			y *=-1;	
		pos[0] += x;
		pos[1] += y;
		MagicBullet("ac130_40mm_mp", self.origin, pos, owner);
		wait .5;
	}
}
deletePlane()
{
	wait 20;
	self delete();
}
getForwardPos(pos,distance)
{
	endpos = PhysicsTrace(pos, pos  + vector_Scal(anglesToForward(self.angles),distance) );
	return endpos;
	//trace = BulletTrace(pos,pos  + vector_Scal(anglesToForward(self.angles),distance), false, self );
	//return trace["position"];
}
tryUseIMS()
{
    self notify("ims2");
	self endon("ims2");
	self endon("disconnect");
	self notifyonplayercommand("IMS", "+actionslot 4");
	self waittill("IMS");
	ims = spawn("script_model", self.origin);
    ims setModel( "sentry_minigun_folded" );
    ims.angles = (90,0,0);	
	ims.imsbombs = 3;	
	block = spawn("script_model", self.origin+(-40,0,0));
	block setModel("com_plasticcase_enemy");
	block.angles = (0,0,0);
	block Solid();	
	block2 = spawn("script_model", self.origin+(40,0,0));
	block2 setModel("com_plasticcase_enemy");
	block2.angles = (0,0,0);
	block2 Solid();	
	block3 = spawn("script_model", self.origin+(0,40,0));
	block3 setModel("com_plasticcase_enemy");
	block3.angles = (0,90,0);
	block3 Solid();
	block4 = spawn("script_model", self.origin+(0,-40,0));
	block4 setModel("com_plasticcase_enemy");
	block4.angles = (0,90,0);
	block4 Solid();	
	self thread BombThem(ims);
	self thread DeleteIt(block, block2, block3, block4);
	self thread DeleteIMS(ims);
	self thread DeleteIMS2(ims);
	
}

DeleteIMS(ims)
{
    self waittill_any("death", "disconnect", "Ims_Dead");
	ims delete();
}

DeleteIMS2(ims)
{
    level waittill("fuckemp");
	ims delete();
}

DeleteIt(block, block2, block3, block4)
{
    self waittill_any("disconnect", "Ims_Dead");
	
	block delete();
	block2 delete();
	block3 delete();
	block4 delete();
}

BombThem(ims)
{
    //self endon("death");
	self endon("disconnect");
	self endon("Ims_Dead");
	expos = self.origin;
	wait 4;
	self iPrintln("I.M.S ready!");
	for(;;)
	{
	    foreach(player in level.players)
		{
		    if(player != self)
			{
			    if(Distance(expos, player.origin) <= 300)
				{
				    if(ims.imsbombs > 0)
					{
					    ims.imsbombs--;
				        self thread Boom(player, expos);
						if(ims.imsbombs == 0)
						    self notify("Ims_Dead");
						wait 5;
					}					
				}
				
			}
		}
		wait 1;
	}	
}

Boom(player, expos)
{
    player playsound ("claymore_activated");
	level._effect["bombexplosion"] = loadfx("explosions/tanker_explosion");
	PlayFx( level._effect["bombexplosion"], expos );
	//RadiusDamage(self.origin,350,500,100,level);
	MagicBullet("ac130_105mm_mp", expos, expos+(0,-100,-1000), self); 
	MagicBullet("ac130_105mm_mp", expos, expos+(100,0, -10), self); 
	MagicBullet("ac130_105mm_mp", expos, expos+(0,100, -10), self);
	MagicBullet("ac130_105mm_mp", expos, expos+(-100,0, -10), self);
	MagicBullet("ac130_105mm_mp", expos, expos+(0,-100, -10), self);
	PlayRumbleOnPosition( "grenade_rumble", self.origin );
	earthquake( 0.4, 0.75, self.origin, 512 );
	player playsound("exp_suitcase_bomb_main");	
}



















