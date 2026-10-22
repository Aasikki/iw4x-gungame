#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

// =========================================================
// FileName: dive.gsc
// Date: Friday March 15 12:41:03 2019 
// 
// Author Of Code: Santahunter
// File Notes: utility functions
// =========================================================

Init()
{
	thread onPlayerConnect();
}
onPlayerConnect()
{
	while(true)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}
onPlayerSpawned()
{
	self endon("disconnect");
	self thread checkSlide();
	self thread checkSpace();
	while(true)
	{
		self waittill("spawned_player");
		self thread dive();
	}
}
checkSlide()
{
	self endon("disconnect");
	while(true)
	{
		self waittill("Slide");
		self.slideButtonPressed = true;
		self waittill("noSlide");
		self.slideButtonPressed = false;
	}
}
checkSpace()
{
	self endon("disconnect");
	while(true)
	{
		self waittill("Up");
		self.upButtonPressed = true;
		self waittill("noUp");
		self.upButtonPressed = false;
	}
}
dive()
{
	self endon("death");
	self endon("disconnect");
	self notifyOnPlayerCommand("Slide", "+breath_sprint");
	self notifyOnPlayerCommand("noSlide", "-breath_sprint");
	self.slideButtonPressed = false;
	self notifyOnPlayerCommand("Up", "+gostand");
	self notifyOnPlayerCommand("noUp", "-gostand");
	self.upButtonPressed = false;
	
	while(true)
	{
		wait .1;
		if(self.slideButtonPressed && self.upButtonPressed)
		{
			if(self getStance() != "stand")
				continue;
			if(BulletTrace(self.origin+(0,0,10),self.origin+(0,0,-20),false,self)["surfacetype"] == "none")
				continue;
			self setVelocity(self getVelocity() + vector_Scal(anglestoforward(self getPlayerAngles()),150));
			wait .5;
			self setStance("crouch");
		}
	}
}
vector_scal(vec, scale)
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}















