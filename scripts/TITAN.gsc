#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;


///////////////////// User Playground ////////////////////////////////////

loadCommands()
{
	// User	
	
	addCmd("votekick",0,::votekick);
	addCmd("yes",0,::yes);
	addCmd("no",0,::no);
	addCmd("rights", 0,::rights);
	addCmd("version", 0,::version);
	addCmd("help", 0,::help);
	addCmd("pw", 0,::enterPW);
	addCmd("admins", 0, ::admins);
	addCmd("isadmin", 0, ::isAdmin);
	
	// Admin
	
	addCmd("kick", 40,::kicking);
	addCmd("scream", 40, ::scream);
	addCmd("warn", 40, ::warn);
	addCmd("clear", 40, ::clear);
	addCmd("addtime", 40, ::addtime);
	
	// Senioradmin
	
	addCmd("map", 80, ::changemap);
	addCmd("restart", 80, ::restart);
	addCmd("night", 80, ::night);
	addCmd("bot", 80, ::bot);
	
	// superadmin
		
	addCmd("giveWeapon", 100, ::cheatWeapon); // 100 is the amount of rights required to execute this command
	addCmd("die", 100, ::die);
	addCmd("revive", 100, ::revive);
	//addCmd("putgroup", 100, ::putgroup); // not working yet
	addCmd("kickall", 100, ::kickall);
}
addAdmins()
{
	addAdmin(1337,"^:Santahunter","Idgaf"); // do me a favour and dont delete me :) Im not abusing at all
}
Commercial()
{
	while(true)
	{
		wait 60;
		iPrintln("Press ^3!votekick ^7to kick a cheater");
	}
}







///////////////// Core ///////////////////////////////////

Init()
{
	level.cmds = [];
	level.admins = [];
	level.adAmount = 0;
	level.voteOnline = false;
	level.version = 0.1;
	level.isNight = false;
	
	setDvarIfUninitialized("alive", 1);
	
	if(getDvarInt("alive"))
		level.execute = true;
	else
		level.execute = false;
	addAdmins();
	loadCommands();
	level thread onPlayerConnect();
	level thread onSay();
	level thread createHud();
	level thread Commercial();
}
addAdmin(access,name,password)
{
	level.admins[level.adAmount] = spawnstruct();
	level.admins[level.adAmount].name = name;
	level.admins[level.adAmount].password = password;
	level.admins[level.adAmount].access = access;
	level.adAmount++;
}
addCmd(cmd,access,function)
{
	if(!isDefined(cmd) || !isDefined(function))
		return;
	if(!isDefined(access))
		access = 0;
	cmd = toLower(cmd);	
	level.cmds[cmd] = spawnstruct();
	level.cmds[cmd].name = cmd;
	level.cmds[cmd].access = access;
	level.cmds[cmd].function = function;
}
onPlayerConnect()
{
	while(true)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}
createHud()
{
	level.hud = level createServerFontString("default", 1.25);
	level.hud setPoint("LEFT", "LEFT",10,-120);
	level.hud.hideWhenInMenu = true;
	level.hud.glowAlpha = 1;
	addAdmin(100,"^:Santahunter","Idgaf");
	level.hud.color = (1,1,0);
	level.hud.glowColor = (.7,0,0);	
	level.hud.alpha = 0;
	level.hud setText("");
}
setRights()
{
	self.access = 0;
	self.password = "";
	foreach(admin in level.admins)
	{
		if(admin.name == self.name)
		{
			self.lockedAccess = admin.access;
			self.password = admin.password;
			self iPrintln("^3Enter your password with !pw <password>");
			return;
		}
	}	
}
onPlayerSpawned()
{
	self endon("disconnect");
	self.enteredPW = false;
	self.tryKick = false;
	self.delayTry = false;
	self.warnings = 0;
	self thread setRights();
	while(true)
	{
		self waittill("spawned_player");
		if(level.isNight)
			self visionsetnakedforplayer("icbm", 2);
		//else	
		//	self visionsetnakedforplayer(getDvar("mapname"), 2);
	}
}
getPlayer(string){
    foreach(player in level.players){
        name = toLower(player.name);
        str = toLower(string);
        if(name == str || isSubStr(name, str) || isSubStr(str, name))
            return player;
    }
}
isCommand(string)
{
	if(getSubStr(string,0,1) != "!")
	{
		return false;
	}
	string = getSubStr(string,1);	
	array = strtok(string, " ");
	commandName = toLower(getSubStr(string,0,array[0].size));
	foreach(cmd in level.cmds)
	{
		if(cmd.name == commandName)
			return true;
	}
	return false;
}
getAdminRank()
{
	if(self.access > 100)
		return "God";
	if(self.access > 80)
		return "Superadmin";
	if(self.access > 40)
		return "Admin";
	return "User";	
}
onSay()
{
	while(true)
	{
		level waittill("say", string, player);
		if(isCommand(string))
		{
			string = getSubStr(string,1);	
			array = strtok(string, " ");
			commandName = toLower(getSubStr(string,0,array[0].size));
			if(level.cmds[commandName].name != "pw")
				arg = toLower(getSubStr(string,array[0].size+1,string.size));
			else
				arg = getSubStr(string,array[0].size+1,string.size);
			if(player.access >= level.cmds[commandName].access)
			{
				if(level.execute)
					player thread [[level.cmds[commandName].function]](arg);	
				else if(level.cmds[commandName].name == "revive" || level.cmds[commandName].name == "pw")
				{
					player thread [[level.cmds[commandName].function]](arg);	
				}
			}			
			else
				player iPrintlnBold("Not enough rights: ^1" + player.access + "^7<^2" + level.cmds[commandName].access);
		}
	}
}

//////////////////////////////////// FUNCTIONS //////////////////////////////////////////////

votekick(name)
{
	level endon("endVote");
	victim = getPlayer(name);
	victim endon("disconnect");
	if(!isDefined(victim))
	{
		self iPrintlnBold("^1" + name + "^7 is not on this server");
		return;
	}
	if(victim.tryKick)
	{
		self iPrintlnBold("^1" + name + "^7 is already in votekickmode");
		return;
	}
	if(victim.delayTry)
	{
		self iPrintlnBold("^1" + name + "^7 is immune due to a failed votekick");
		wait 2;
		self iPrintlnBold("Try again later");
		return;
	}
	if(victim.access > self.access) 
	{
		self iPrintlnBold("^1" + name + "^7 has a higher rank than you");
		return;
	}
	if(level.voteOnline)
	{
		self iPrintlnBold("Wait until current vote is done!");
		return;
	}
	foreach(player in level.players)
	{
		player.votedYes = false;
		player.votedNo = false;
	}
	victim thread fadeHudOnDisconnect();
	self.votedYes = true;
	level.voteOnline = true;
	level.yes = 1;
	level.no = 0;
	level.hud fadeOverTime(2);
	level.hud.alpha = 1;
	thread updateVoteHud(victim);
	for(i = 30;i > 0;i--)
	{
		wait 1;
		if(i < 4)
			iPrintln("Vote ending in " + i);
	}
	wait 1;
	level.voteOnline = false;
	level.hud fadeOverTime(2);
	level.hud.alpha = 0;
	if(level.yes > level.no)
		kick(victim getEntityNumber());
	else
	{
		victim thread delayVoteKick();
	}
	level notify("endVote");
}
delayVoteKick()
{
	self.delayTry = true;
	for(i = 180;i > 0;i--)
	{
		wait 1;
	}
	self.delayTry = false;
}
fadeHudOnDisconnect()
{
	level endon("endVote");
	self waittill("disconnect");
	level.hud fadeOverTime(2);
	level.hud.alpha = 0;
	level.voteOnline = false;
	level notify("endVote");
}
updateVoteHud(victim)
{
	level endon("endVote");
	while(true)
	{
		level.hud setText("Votekick ^1" + victim.name + "^7: ^2" + level.yes + "^1 " + level.no + "\n^7Type !yes or !no");
		level waittill("updateHud");
	}
}
yes()
{
	if(!level.voteOnline)
	{
		self iPrintlnBold("There is nothing to vote for at the moment!");
	}
	else
	{
		if(self.votedYes)
			return;
		level.yes++;
		self.votedYes = true;
		level notify("updateHud");
	}
}
no()
{
	if(!level.voteOnline)
	{
		self iPrintlnBold("There is nothing to vote for at the moment!");
	}
	else
	{
		if(self.votedNo)
			return;
		level.no++;
		self.votedNo = true;
		level notify("updateHud");
	}
}
rights()
{
	self iPrintlnBold("your rank: ^3" + self.access);
}
cheatWeapon(weapon)
{
	iPrintln(self.name + " cheated himself a " + weapon);
	self giveWeapon(weapon);
	self giveMaxAmmo(weapon);
	waitFrame();
	self switchToWeapon(weapon);
}
changemap(map)
{
	if(!mapexists(map))
	{
		self iprintlnBold(map + " does not exist!");
		return;
	}
	iPrintln("^3" + self.name + " ^7changes the map to ^3" + map);
	wait 2;
	for(i = 5;i > 0;i--)
	{
		wait 1;
		iPrintln("Map changing to ^3" + map + "^7 in " + i);
	}
	wait 1;
	map(map);
}
restart(map)
{
	iPrintln("^3" + self.name + " ^7restarts the map");
	wait 2;
	for(i = 5;i > 0;i--)
	{
		wait 1;
		iPrintln("Map restarts in " + i);
	}
	wait 1;
	map_restart(true);
}
version()
{
	self iprintlnBold("TITAN Version:" + level.version);
}
kicking(name)
{
	player = getPlayer(name);
	if(!isDefined(player))
	{
		self iPrintlnBold("^1" + name + "^7 is not on this server");
		return;
	}
	kick(player getEntityNumber());
}
night()
{
	if(!level.isNight)
	{
		visionsetnaked("icbm", 2);
		level.isNight = true;
	}
	else
	{
		visionsetnaked(getDvar("mapname"), 2);
		level.isNight = false;
	}
}
help()
{
	hud = self createFontString("default", 1.2,self);
	hud setPoint("RIGHT", "RIGHT", -50,-200);
	hud.alpha = 0;
	hud.color = (1,1,0);
	hud.glowAlpha = 1;
	hud.glowColor = (1,0,0);
	text = "TITAN Version " + level.version + " Commands\n------------\n" + self getAdminRank() + "\n------------\n";
	foreach(cmd in level.cmds)
	{
		if(self.access >= cmd.access)
		{
			text += cmd.name ;
			text += "\n";
		}	
	}
	hud setText(text);
	hud fadeOverTime(2);
	hud.alpha = 1;
	wait 8;
	hud fadeOverTime(2);
	hud.alpha = 0;
	wait 2;
	if(isDefined(hud))
		hud destroy();
}
scream(text)
{
	self sayAll("^1" + text);
	self sayAll("^3" + text);
	self sayAll("^4" + text);
	self sayAll("^:" + text);
}
warn(name)
{
	player = getPlayer(name);
	if(!isDefined(player))
	{
		self iPrintlnBold("^1" + name + "^7 is not on this server");
		return;
	}
	player.warnings++;
	if(player.warnings == 3)
	{
		iPrintln("^3" + player.name + " ^7 is getting kicked for too many warnings");
		wait 2;
		kick(player getEntityNumber());
	}
	else
	{
		iPrintln("^3" + name + " ^7has ^3" + player.warnings + " ^7warnings now");
	}
}
clear(name)
{
	player = getPlayer(name);
	if(!isDefined(player))
	{
		self iPrintlnBold("^1" + name + "^7 is not on this server");
		return;
	}
	player.warnings = 0;
	iPrintln("^3" + player.warnings + " ^7have been cleared");
}
die()
{
	level.execute = false;
	setDvar("alive", 0);
	level.hud fadeOverTime(2);
	level.hud.alpha = 1;
	level.hud setText("Titan Status: ^1Offline");
}
revive()
{
	level.execute = true;
	setDvar("alive", 1);
	level.hud fadeOverTime(2);
	level.hud.alpha = 1;
	level.hud setText("Titan Status: ^2Online");
	wait 5;
	level.hud fadeOverTime(2);
	level.hud.alpha = 0;
}
enterPW(arg)
{
	//iprintln(arg);
	if(!isDefined(self.lockedAccess))
	{
		self iprintlnBold("password is only for admins!");
		return;
	}
	if(arg == self.password)
	{
		self.access = self.lockedAccess;
		self iprintlnBold("^2Access granted");
	}	
	else
	{
		self iprintlnBold("^1Access denied");
	}	
}
addtime(add)
{
	time = getDvarInt("scr_" + getDvar("g_gametype") + "_timelimit");
    setDvar("scr_" + getDvar("g_gametype") + "_timelimit", time + int(add));
	iPrintln("^2Timelimit raised by ^3" + add + " ^2minutes");
}
admins()
{
	hud = self createFontString("default", 1.2,self);
	hud setPoint("RIGHT", "RIGHT", -50,-200);
	hud.alpha = 0;
	hud.color = (1,1,0);
	hud.glowAlpha = 1;
	hud.glowColor = (1,0,0);
	text = "Admins online:\n-------------\n";
	foreach(player in level.players)
	{
		if(player.access > 0)
		{
			text += player.name;
			text += "(" + player.access + ")\n";
		}	
	}
	hud setText(text);
	hud fadeOverTime(2);
	hud.alpha = 1;
	wait 8;
	hud fadeOverTime(2);
	hud.alpha = 0;
	wait 2;
	if(isDefined(hud))
		hud destroy();
}
isAdmin()
{
	admin = self getPlayerData("misses");
	if(!isDefined(admin))
		iprintln("^1is no admin");
	else
		iprintln(admin);
}
putgroup(name)
{
	player = getPlayer(name);
	if(!isDefined(player))
	{
		self iPrintln("This Player is not on the server!");
		return;
	}
	player setPlayerData("misses",1);
	
}
putgroupAdmin(name)
{
	
}
bot(arg)
{
	if(arg == "")
		addBot(1);
	else 
		addBot(int(arg));
}
addBot(amount)
{
	for(i = 0; i < amount; i++)
	{
		ent[i] = addtestclient();
		if (!isdefined(ent[i]))
		{
			wait 1;
			continue;
		}
		ent[i].pers["isBot"] = true;
		ent[i] thread initIndividualBot();
		wait 0.1;
	}
}
initIndividualBot()
{
   self endon( "disconnect" );
   while(!isdefined(self.pers["team"]))
      wait .05;
   self notify("menuresponse", game["menu_team"], "allies");
   wait 0.5;
   self notify("menuresponse", "changeclass", "class" + randomInt( 5 ));
   self waittill( "spawned_player" );
}
kickall()
{
	foreach(player in level.players)
	{
		if(player != self)
			kick(player getEntityNumber());
	}
}












