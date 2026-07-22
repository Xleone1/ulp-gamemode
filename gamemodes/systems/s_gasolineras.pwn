GetMyNearGas(playerid)
{
	for (new i = 0; i != MAX_GASOLINERAS_COUNT; i++)
	{
		if(!Gasolineras[i][PosX]) continue;
		if (IsPlayerInRangeOfPoint(playerid, 8.0,
			Gasolineras[i][PosX],
			Gasolineras[i][PosY],
			Gasolineras[i][PosZ]) )
		{
		    return i;
		}
	}
	SendInfoMessage(playerid, 0, "519", "No hay ninguna gasolinera a su alrededor");
	return -1;
}
SaveGasolinera(g)
{
	new query[200], Cache:CACHE, rowExist;
	mysql_format(dataBase, query, sizeof(query), "SELECT ID FROM %s WHERE ID=%d;", DIR_GASOLINERAS, g);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowExist);
	cache_delete(CACHE);

	if(Gasolineras[g][PosX] && !rowExist){
		mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s VALUES (%d,%f,%f,%f,%d);", DIR_GASOLINERAS, 
			g,
			Gasolineras[g][PosX],
			Gasolineras[g][PosY],
			Gasolineras[g][PosZ],
			Gasolineras[g][Fuel]);
		mysql_query(dataBase, query, false);
	}
	else if(rowExist){
		mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET `PosX`='%f',`PosY`='%f',`PosZ`='%f',`Fuel`='%d' WHERE ID=%d;", DIR_GASOLINERAS, 
			Gasolineras[g][PosX],
			Gasolineras[g][PosY],
			Gasolineras[g][PosZ],
			Gasolineras[g][Fuel],
			g);
		mysql_query(dataBase, query, false);
	}
}

LoadGasolineras()
{
	new query[30], Cache:CACHE, rowCount;
	mysql_format(dataBase, query, sizeof(query), "SELECT * FROM %s", DIR_GASOLINERAS);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowCount);
	if(rowCount)
	{
		for(new g; g != rowCount; g++){
			cache_get_value_name_float(g, "PosX", Gasolineras[g][PosX]);
			cache_get_value_name_float(g, "PosY", Gasolineras[g][PosY]);
			cache_get_value_name_float(g, "PosZ", Gasolineras[g][PosZ]);
			cache_get_value_name_int(g, "Fuel", Gasolineras[g][Fuel]);
			if(Gasolineras[g][PosX]){
				MAX_GASOLINERAS++;
			}
		}
	    printf("[%s]: Se cargaron %d/%d Gasolineras (MAX: %d)", DIR_GASOLINERAS, MAX_GASOLINERAS, rowCount, MAX_GASOLINERAS_COUNT);
	}
	else
	{
	    printf("[%s]: Error el cargar gasolineras", DIR_GASOLINERAS);
	}
	cache_delete(CACHE);
}