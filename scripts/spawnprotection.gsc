Init()
{
	level thread onPlayerConnect();
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
	while(true)
	{
		self waittill("spawned_player");
		self thread spawnSafety();
	}
}
spawnSafety()
{
	self notify("spawnSafety");
	self endon("spawnSafety");
	self endon("endSafety");
	self endon("disconnect");
	self thread onShoot();
	//hp = self.health;
	self.protected = 99999;
	//self.health = 999999;
	wait 2;
	//self.health = hp;
	self.protected = 0;
	self notify("endSafety");
}
onShoot()
{
	self endon("endSafety");
	self waittill("weapon_fired");
	self.protected = 0;
	self notify("endSafety");
}
