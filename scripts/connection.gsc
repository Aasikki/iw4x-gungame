#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

transform(seconds)
{
	seconds = int(seconds);
	minutes = int(seconds/60)-1;
	hours = int(minutes/60)-1;
	days = int(hours/24)-1;
	years = int(days/355)-1;
	
	//minutes = int(minutes)-1;
	//hours = int(hours)-1;
	//days = int(days)-1;
	//years = int(years)-1;
	
	//iPrintln(minutes);
	
	if(years >= 1)
	{
		if(years > 1)
			return (years + "years and " + days + "days");
		else
			return (years + "year and " + days + "days");
	}	
	else if(days >= 1)
	{
		if(days > 1)
			return (days + "days and " + hours + "hours");
		else
			return (days + "day and " + hours + "hours");
	}	
	else if(hours >= 1)
	{
		if(hours > 1)
			return (hours + "hours and " + minutes + "minutes");
		else
			return (hours + "hour and " + minutes + "minutes");
	}	
	else if(minutes >= 1)	
		return (minutes + "minutes and " + seconds + "seconds");
	return (seconds + "seconds");	
}



















