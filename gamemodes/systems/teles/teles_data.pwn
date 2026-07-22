// capa de persistencia para teles y garages

// funciones que retornan handles de cache, las movemos al inicio
// para que el compilador las vea primero

stock Cache:FetchTeleDB(teleid)
{
	new query[80];
	format(query, sizeof(query), "SELECT * FROM %s WHERE ID=%i", DIR_TELES, teleid);
	return mysql_query(dataBase, query);
}

stock Cache:FetchGarageExDB(g)
{
	new query[80];
	format(query, sizeof(query), "SELECT * FROM %s WHERE ID=%i;", DIR_GARAGES_EX, g);
	return mysql_query(dataBase, query);
}

SaveTeleDB(teleid)
{
	new query[1024], Cache:cacheid, teleExist;

	format(query, sizeof(query), "SELECT ID from %s WHERE ID=%i;", DIR_TELES, teleid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(teleExist);
	cache_delete(cacheid);

	// si el tele no existe en la db pero tiene pickup, lo insertamos
	if(!teleExist && Teles[teleid][PickupID] != 0){
		format(query, sizeof(query), "INSERT INTO %s (ID) VALUES ('%i');", DIR_TELES, teleid);
		mysql_query(dataBase, query, false);
		teleExist = true;
	}

	if(teleExist){
		mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
			`PosX`='%f',`PosY`='%f',`PosZ`='%f',`PosZZ`='%f',`PickupIDGo`='%d',`World`='%d',`Interior`='%d',`Seguro`='%d',\
			`Dueno`='%d',`DuenoType`='%d',`IsBankTele`='%d',`IsHotelTele`='%d',`IsNegocioTele`='%d',`IsCasaTele`='%d',\
			`IsGarage`='%d',`Garage_ID`='%d',`PrecioEntrada`='%d',`LugarText`='%e' WHERE ID=%i;",
			DIR_TELES,
			Teles[teleid][PosX],
			Teles[teleid][PosY],
			Teles[teleid][PosZ],
			Teles[teleid][PosZZ],
			Teles[teleid][PickupIDGo],
			Teles[teleid][World],
			Teles[teleid][Interior],
			Teles[teleid][Lock],

			Teles[teleid][Dueno],
			Teles[teleid][DuenoType],
			Teles[teleid][IsBankTele],
			Teles[teleid][IsHotelTele],
			Teles[teleid][IsNegocioTele],
			Teles[teleid][IsCasaTele],

			Teles[teleid][IsGarage],
			Teles[teleid][Garage_ID],
			Teles[teleid][PrecioEntrada],
			Teles[teleid][LugarText],
			teleid);
		mysql_query(dataBase, query, false);
	}
	return 1;
}

SaveGarageExDB(g)
{
	new query[1024], Cache:cacheid, garageExist;

	format(query, sizeof(query), "SELECT ID FROM %s WHERE ID=%i;", DIR_GARAGES_EX, g);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(garageExist);
	cache_delete(cacheid);

	if(!garageExist && GaragesEx[g][Creado]){
		format(query, sizeof(query), "INSERT INTO %s (ID) VALUES ('%i');", DIR_GARAGES_EX, g);
		mysql_query(dataBase, query, false);
		garageExist++;
	}

	if(garageExist){
		format(query, sizeof(query), "UPDATE %s SET \
			`Creado`='%d',`ID_Tele`='%d',\
			`PosXOne`='%f',`PosYOne`='%f',`PosZOne`='%f',`PosZZOne`='%f',\
			`PosXTwo`='%f',`PosYTwo`='%f',`PosZTwo`='%f',`PosZZTwo`='%f' \
			WHERE ID=%i;",
			DIR_GARAGES_EX,
			GaragesEx[g][Creado],
			GaragesEx[g][ID_Tele],

			GaragesEx[g][PosXOne],
			GaragesEx[g][PosYOne],
			GaragesEx[g][PosZOne],
			GaragesEx[g][PosZZOne],

			GaragesEx[g][PosXTwo],
			GaragesEx[g][PosYTwo],
			GaragesEx[g][PosZTwo],
			GaragesEx[g][PosZZTwo],
			g);
		mysql_query(dataBase, query, false);
	}
}
