IsPlayerInConcencionario(playerid)
{
	new RANGE_POINT = 50;
	if ( IsPlayerInRangeOfPoint(playerid, RANGE_POINT, 546.3749,-1293.4868,17.2482) ||
		 IsPlayerInRangeOfPoint(playerid, RANGE_POINT, -1661.5085,1212.9225,21.1563) ||
		 IsPlayerInRangeOfPoint(playerid, RANGE_POINT, -1951.7966,279.0199,40.4895) ||
		 GetPlayerVirtualWorld(playerid) == WORLD_DEFAULT_INTERIOR && (
		 IsPlayerInRangeOfPoint(playerid, RANGE_POINT, -509.2497,2561.0613,53.8653)  ||
		 IsPlayerInRangeOfPoint(playerid, RANGE_POINT, 1644.9438,-2495.1252,13.6146) ||
		 IsPlayerInRangeOfPoint(playerid, RANGE_POINT, 1577.2163,1262.2421,10.8268)
		 )  )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}