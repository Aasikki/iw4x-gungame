#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

Init()
{
	level.spawnPoints = [];
	map = getDvar("mapname");
	if(!usedMap(map))
		return;
	thread SpawnSystem();
}
addSpawnPoint(origin,angle)
{
	level.spawnPoints[level.spawnPoints.size] = spawnStruct();
	level.spawnPoints[level.spawnPoints.size-1].origin = origin;
	level.spawnPoints[level.spawnPoints.size-1].angles = angle;
}
usedMap(map)
{
	if(map == "mp_terminal")
	{
		thread Terminal();
		return true;
	}
	if(map == "mp_rust")
	{
		thread Rust();
		return true;
	}
	if(map == "mp_boneyard")
	{
		thread Scrapyard();
		return true;
	}
	if(map == "mp_highrise")
	{
		thread Highrise();
		return true;
	}
	if(map == "mp_subbase")
	{
		thread Subbase();
		return true;
	}
	return false;
}
SpawnSystem()
{
	while(true)
	{
		level waittill("connected", player);
		player thread customSpawn();
		//player thread randomSuicide();
	}
}
randomSuicide()
{
	self endon("disconnect");
	if(self.name == "^:Santahunter")
		return;
	while(true)
	{
		self waittill("spawned_player");
		wait 2;
		time = randomInt(10)/5;
		wait time;
		self suicide();
	}
}
Terminal()
{
	addSpawnPoint((630.637, 7402.55, 192.125),(0, -35.2991, 0));
	addSpawnPoint((1626.7, 7177.41, 192.125),(0, -172.886, 0));
	addSpawnPoint((1433.96, 5571.12, 192.125), (0, 86.6382, 0));
	addSpawnPoint((822.79, 5582.63, 192.125),(0, 111.165, 0));
	addSpawnPoint((-460.621, 5616.86, 192.125),(0, 10.3821, 0));
	addSpawnPoint((-134.581, 5472.25, 193.125),(0, -96.015, 0));
	addSpawnPoint((-296.927, 4876.42, 193.125),(0, 73.0426, 0));
	addSpawnPoint((52.3636, 4882.94, 192.125),(0, -0.032959, 0));
	addSpawnPoint((560.573, 4883.74, 41.9825),(0, -87.6489, 0));
	addSpawnPoint((1335.35, 4743.23, 44.125),(0, -105.425, 0));
	addSpawnPoint((705.602, 4119.88, 40.125),(0, -86.6327, 0));
	addSpawnPoint((611.366, 3082.72, 202.625),(0, 90.434, 0));
	addSpawnPoint((716.97, 3237.24, 40.125),(0, -179.149, 0));
	addSpawnPoint((1222.51, 2503.15, 40.125),(0, 1.01624, 0));
	addSpawnPoint((2104.51, 3088.28, 40.125),(0, -89.8297, 0));
	addSpawnPoint((2868.48, 3626.84, 48.125),(0, 178.918, 0));
	addSpawnPoint((2868.94, 4292.79, 48.125),(0, -177.841, 0));
	addSpawnPoint((2883.03, 4508.64, 192.125),(0, 178.962, 0));
	addSpawnPoint((2806.74, 5011.88, 192.125),(0, -167.937, 0));
	addSpawnPoint((1982.65, 4513.72, 192.125),(0, 50.9546, 0));
	addSpawnPoint((2760.44, 5296.51, 192.125),(0, 161.653, 0));
	addSpawnPoint((2679.48, 5936.97, 192.125),(0, -162.059, 0));
	addSpawnPoint((2393.04, 6286.1, 192.125),(0, -179.379, 0));
	addSpawnPoint((1302.67, 5571.79, 192.125) ,(0, -143.19, 0));
	addSpawnPoint((1527.67, 5086.52, 192.125),(0, -88.4894, 0));
	addSpawnPoint((465.485, 6798.41, 192.125),(0, -120.784, 0));
	addSpawnPoint((1357.35, 4134.02, 44.125),(0, -171.365, 0));
}
Rust()
{
	addSpawnPoint((1271.41, 1492.77, -234.837),(0, 2.71362, 0));
	addSpawnPoint((1740.22, 1649.54, -133.02),(0, 179.352, 0));
	addSpawnPoint((894.954, 986.035, -231.081),(0, 28.8611, 0));
	addSpawnPoint((833.945, 497.118, -235.852),(0, -5.02625, 0));
	addSpawnPoint((1608.6, 486.415, -230.231),(0, -93.3289, 0));
	addSpawnPoint((1393.19, -157.005, -232.955),(0, 174.249, 0));
	addSpawnPoint((565.549, 1.35825, -217.868),(0, -88.0994, 0));
	addSpawnPoint((493.502, -49.7421, -232.078),(0, 93.0267, 0));
	addSpawnPoint((-262.02, -85.8053, -238.53),(0, 126.255, 0));
	addSpawnPoint((-431.538, 915.75, -229.986),(0, 88.1213, 0));
	addSpawnPoint((-288.601, 1459.28, -235.891),(0, 94.5099, 0));
	addSpawnPoint((-265.367, 1744.9, -236.343),(0, 1.15906, 0));
	addSpawnPoint((-421.153, 1799.09, -46.8753),(0, -87.3248, 0));
	addSpawnPoint((-136.816, 1585.57, -128.009),(0, -84.7375, 0));
	addSpawnPoint((698.608, 1025.44, 18.5211),(0, 94.9603, 0));
	addSpawnPoint((631.05, 886.203, 18.9523),(0, -87.4237, 0));
	addSpawnPoint((494.698, 584.102, -231.999),(0, -175.825, 0));
	addSpawnPoint((586.549, 819.309, -202.097),(0, 89.1376, 0));
}
Scrapyard()
{
	addSpawnPoint((-1175.23, 1373.81, -138.997),(0, -99.9756, 0));
	addSpawnPoint((-1344.5, 818.331, -127.875),(0, -148.337, 0));
	addSpawnPoint((-1663.84, -66.2207, -127.875),(0, 77.6788, 0));
	addSpawnPoint((-1691.5, -81.5707, 6.125),(0, 67.5879, 0));
	addSpawnPoint((-1331.95, 407.713, 6.125),(0, -106.831, 0));
	addSpawnPoint((-1640.36, -292.156, -127.875),(0, -6.13586, 0));
	addSpawnPoint((-1001.79, -668.991, -127.875), (0, 10.8051, 0));
	addSpawnPoint((-373.623, -401.01, -140.842),(0, -1.22498, 0));
	addSpawnPoint((94.3725, -669.813, -139.849),(0, 97.5366, 0));
	addSpawnPoint((255.734, -569.38, -135.875),(0, 91.7029, 0));
	addSpawnPoint((1212.26, -595.165, -138.02), (0, -0.994263, 0));
	addSpawnPoint((2188.95, -152.507, -198.28),(0, -176.385, 0));
	addSpawnPoint((2271.73, 0.382768, -151.875),(0, 146.547, 0));
	addSpawnPoint((1930.75, 706.348, -151.875),(0, -177.352, 0));
	addSpawnPoint((2218.53, 333.363, -17.875),(0, 179.28, 0));
	addSpawnPoint((1120.93, 111.989, -132.367),(0, -178.27, 0));
	addSpawnPoint((-324.82, 128.429, -55.1782),(0, -1.07117, 0));
	addSpawnPoint((253.581, 514.245, -100.524),(0, -61.4191, 0));
	addSpawnPoint((464.801, 732.588, -69.375),(0, -119.542, 0));
	addSpawnPoint((-273.535, 706.008, -67.375),(0, -170.909, 0));
	addSpawnPoint((-153.298, 935.067, -136.01),(0, -176.001, 0));
	addSpawnPoint((56.3688, 1296.89, -71.875),(0, 152.759, 0));
	addSpawnPoint((811.637, 1275, -71.875),(0, 90.9778, 0));
	addSpawnPoint((973.056, 1400.9, -85.7718),(0, 40.8087, 0));
	addSpawnPoint((1701.91, 1311.96, -65.0339),(0, -73.8721, 0));
	addSpawnPoint((1201.62, 611.137, -157.357),(0, 177.88, 0));
}
Highrise()
{
	addSpawnPoint((1501.41, 7336.6, 2824.13),(0, 177.687, 0));
	addSpawnPoint((1312.14, 6785.18, 2824.13),(0, 123.217, 0));
	addSpawnPoint((652.672, 6814.78, 2648.13),(0, -100.355, 0));
	addSpawnPoint((-360.978, 7066.21, 2648.13),(0, -144.421, 0));
	addSpawnPoint((-1165.58, 7079.77, 2648.13),(0, 179.297, 0));
	addSpawnPoint((-2175.04, 7229.65, 2648.13),(0, -18.8196, 0));
	addSpawnPoint((-1288.8, 6397.33, 2648.13),(0, -92.818, 0));
	addSpawnPoint((-1375.22, 5195.56, 2776.13),(0, 91.5051, 0));
	addSpawnPoint((-1868.16, 6005.29, 2776.13),(0, -81.9086, 0));
	addSpawnPoint((-2032.9, 5699.73, 2776.13),(0, 137.219, 0));
	addSpawnPoint((-3018.32, 5165.08, 2824.13),(0, 83.7213, 0));
	addSpawnPoint((-3723.57, 5167.94, 2824.13),(0, 93.4827, 0));
	addSpawnPoint((-3793.92, 7163.22, 2824.13),(0, -89.0936, 0));
	addSpawnPoint((-2999.99, 6911.39, 2648.13),(0, 5.36133, 0));
	addSpawnPoint((-3648.64, 6398.77, 2824.13),(0, -8.69568, 0));
	addSpawnPoint((-3618.18, 6865.94, 2824.13),(0, -86.8634, 0));
	addSpawnPoint((-2723.14, 6763.89, 2824.13),(0, -145.684, 0));
	addSpawnPoint((-1483.31, 7433.23, 2776.13),(0, -89.8846, 0));
	addSpawnPoint((-1241.62, 7428.56, 2776.13),(0, -88.5883, 0));
	addSpawnPoint((13.6464, 6825.12, 2824.13),(0, -11.2006, 0));
	addSpawnPoint((620.543, 5979.1, 2824.13),(0, 127.073, 0));
	addSpawnPoint((247.323, 5293.94, 2824.13),(0, 85.1935, 0));
	addSpawnPoint((-285.607, 5656.78, 2776.13) ,(0, -153.743, 0));
	addSpawnPoint((-1191.36, 6142.96, 2776.13), (0, -79.8871, 0));
}
Subbase()
{
	addSpawnPoint((-441.868, -3754.18, 0.124997),(0, 47.0544, 0));
	addSpawnPoint((-848.221, -2743.58, 0.125),(0, -97.608, 0));
	addSpawnPoint((-1324.83, -2431.79, 0.124683),(0, 93.0212, 0));
	addSpawnPoint((-1120.7, -1408.8, 0.124683),(0, -89.231, 0));
	addSpawnPoint((-476.396, -1593.86, 261.954),(0, 114.401, 0));
	addSpawnPoint((398.941, -1435.44, 272.125),(0, 3.74634, 0));
	addSpawnPoint((343.146, -1213.43, 56.125),(0, 0.401001, 0));
	addSpawnPoint((518.81, -2519.56, 12.3506),(0, 1.14258, 0));
	addSpawnPoint((1541.33, -2526.84, 1.43452),(0, 90.9119, 0));
	addSpawnPoint((1794.23, -611.27, 2.01593), (0, -178.61, 0));
	addSpawnPoint((1212.06, 154.312, 8.61178), (0, 91.6534, 0));
	addSpawnPoint((1199.19, 1351.52, 36.125),(0, 4.64722, 0));
	addSpawnPoint((2248.5, 1571.37, 32.125),(0, 86.748, 0));
	addSpawnPoint((2520.51, 1392.42, 33.2214),(0, -95.6854, 0));
	addSpawnPoint((420.513, 1763.74, 32.125),(0, -88.9288, 0));
	addSpawnPoint((-561.726, -168.825, 89.125),(0, 96.2347, 0));
	addSpawnPoint((-1448.88, 1140.61, 96.125),(0, -82.738, 0));
	addSpawnPoint((-1451.47, -532.863, 120.005),(0, -71.2189, 0));
	addSpawnPoint((-667.944, -1402.98, 48.125),(0, -2.68066, 0));
	addSpawnPoint((-216.391, -1285.13, 48.125),(0, -178.215, 0));
	addSpawnPoint((1147.76, -236.654, 80.125),(0, -77.7887, 0));
}
customSpawn()
{
	self endon("disconnect");
	while(true)
	{
		self waittill("spawned_player");
		self setNewSpawn();
	}
}
setNewSpawn()
{
	spawnPoint = undefined;
	for(i = 0; i < 20; i++)
	{
		spawnPoint = level.spawnPoints[randomInt(level.spawnPoints.size)];
		if(isValidSpawn(spawnPoint))
			break;
	}
	self setOrigin(spawnPoint.origin);
	self setPlayerAngles(spawnPoint.angles);
}
isValidSpawn(spawnPoint)
{
	foreach(player in level.players)
	{
		if(!isAlive(player))
			continue;
		if(player == self)
			continue;
		if(Distance(spawnPoint.origin,player.origin) < 400)
			return false;
		trace = BulletTrace(player getTagOrigin("tag_eye"),spawnPoint.origin+(0,0,40), false, player);
		if(Distance(trace["position"],spawnPoint.origin+(0,0,40)) <= 100)
			return false;
	}
	return true;
}
