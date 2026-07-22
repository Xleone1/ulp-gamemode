/*
PlayersDataOnline[playerid][EditingType]
PlayersDataOnline[playerid][EditingMapeo]
PlayersDataOnline[playerid][EditingObjectID]
PlayersDataOnline[playerid][EditingIndex]
PlayersDataOnline[playerid][EditingOption]
PlayersDataOnline[playerid][EditingMovement]

new mapeoid = PlayersDataOnline[playerid][EditingMapeo];
new objectid = PlayersDataOnline[playerid][EditingObjectID];
new objectid = Mapeo[mapeoid][ID_Objeto];
new indexid = PlayersDataOnline[playerid][EditingIndex];
new option = PlayersDataOnline[playerid][EditingOption];
*/
GetMyNearDoor(playerid, key)
{
	new iBucle;
	new i = -1;
	new Float:RangoC;
    do
    {
	    RangoC++;
	    iBucle = 0;
	    
	    for (; iBucle != MAX_PUERTAS_COUNT; iBucle++)
	    {
	        if (Puerta[iBucle][Creada])
	        {
	            if (IsPlayerInRangeOfPoint(playerid, RangoC, Puerta[iBucle][PosX], Puerta[iBucle][PosY], Puerta[iBucle][PosZ]) ||
	            	IsPlayerInRangeOfPoint(playerid, RangoC, Mapeo[Puerta[iBucle][ID_Mapeo]][PosX], Mapeo[Puerta[iBucle][ID_Mapeo]][PosY], Mapeo[Puerta[iBucle][ID_Mapeo]][PosZ]) )
	            {
	                i = iBucle;
	                RangoC = 15.0;
	                break;
	            }
	        }
	    }
	}
	while ( RangoC != 15.0 );

	if ( i != -1 )
	{
	    if (Puerta[i][PosX] == 0) return SendInfoMessage(playerid, 0, "", "Esta puerta no tiene un recorrido valido!");
	    
	    if (Puerta[i][LlaveTipo] == 0 && Puerta[i][LlaveOwnerID] == CIVIL ||
	    	Puerta[i][LlaveTipo] == 0 && PlayersData[playerid][Faccion] == Puerta[i][LlaveOwnerID] ||
	    	Puerta[i][LlaveTipo] == 1 && PlayersData[playerid][House] == Puerta[i][LlaveOwnerID] ||
	    	Puerta[i][LlaveTipo] == 1 && PlayersData[playerid][Alquiler] == Puerta[i][LlaveOwnerID] ||
	    	Puerta[i][LlaveTipo] == 1 && IsPlayerInHouseFriend(playerid, Puerta[i][LlaveOwnerID]) != -1 || 
	    	Puerta[i][LlaveTipo] == 2 && IsMyBizz(playerid, Puerta[i][LlaveOwnerID], false)  )
    	{
    	    if (Puerta[i][Abierta])
    	    {
    	        new mapeoid = Puerta[i][ID_Mapeo];
    	        MoveDynamicObject(Mapeo[mapeoid][ID_Objeto], Mapeo[mapeoid][PosX], Mapeo[mapeoid][PosY], Mapeo[mapeoid][PosZ], Puerta[i][Velocidad], Mapeo[mapeoid][PosRX], Mapeo[mapeoid][PosRY], Mapeo[mapeoid][PosRZ]);
    	        Puerta[i][Abierta] = false;
    	    }
    	    else
    	    {
    	        new objectid = Mapeo[Puerta[i][ID_Mapeo]][ID_Objeto];
    	        MoveDynamicObject(objectid, Puerta[i][PosX], Puerta[i][PosY], Puerta[i][PosZ], Puerta[i][Velocidad], Puerta[i][PosRX], Puerta[i][PosRY], Puerta[i][PosRZ]);
    	        Puerta[i][Abierta] = true;
    	    }
    	    return 1;
    	}
		else
		{
		    SendInfoMessage(playerid, 0, "778", "No tienes las llaves de esta puerta");
			return -1;
		}
	}
	if ( !key )
	{
	    SendInfoMessage(playerid, 0, "777", "No hay ninguna puerta a su alrededor");
	}
	return -1;
}

LoadMapeos()
{
	new query[100], Cache:CACHE, rowExist, Cache:MATERIAL_DATA;
    for(new i=0; i != MAX_MAPEOS_COUNT; i++)
	{
		format(query, sizeof(query), "SELECT * FROM %s WHERE ID=%d;", DIR_MAPEOS_DB, i);
		CACHE = mysql_query(dataBase, query);
		cache_get_row_count(rowExist);

		if ( rowExist )
		{
		    cache_get_value_name_int(0, "Modelo", Mapeo[i][Modelo]);
			if(Mapeo[i][Modelo])
			{
				cache_get_value_name_float(0, "PosX", Mapeo[i][PosX]);
				cache_get_value_name_float(0, "PosY", Mapeo[i][PosY]);
				cache_get_value_name_float(0, "PosZ", Mapeo[i][PosZ]);
				cache_get_value_name_float(0, "PosRX", Mapeo[i][PosRX]);
				cache_get_value_name_float(0, "PosRY", Mapeo[i][PosRY]);
				cache_get_value_name_float(0, "PosRZ", Mapeo[i][PosRZ]);
				cache_get_value_name_int(0, "Mundo", Mapeo[i][Mundo]);
				cache_get_value_name_int(0, "Interior", Mapeo[i][Interior]);
				cache_get_value_name(0, "CreatedBy", Mapeo[i][CreatedBy], MAX_PLAYER_NAME);
				cache_get_value_name_int(0, "Tipo", Mapeo[i][Tipo]);
				cache_get_value_name_int(0, "Tipoid", Mapeo[i][Tipoid]);

				new objectid = CreateDynamicObject(Mapeo[i][Modelo], Mapeo[i][PosX], Mapeo[i][PosY], Mapeo[i][PosZ], Mapeo[i][PosRX], Mapeo[i][PosRY], Mapeo[i][PosRZ], Mapeo[i][Mundo], Mapeo[i][Interior]);
				Mapeo[i][ID_Objeto] = objectid;
				MAX_MAPEOS++;

				////////////////////////
				format(query, sizeof(query), "SELECT * FROM %s WHERE mapeo_id=%d;", DIR_MAPEOS_MATERIAL, i);
				MATERIAL_DATA = mysql_query(dataBase, query);
				cache_get_row_count(rowExist);
				if(rowExist == 16){
					for(new indexid=0; indexid != MAX_MATERIALINDEX; indexid++)
					{
						cache_get_value_index_int(indexid, 3, Mapeo[i][materialtype][indexid]);
						cache_get_value_index_int(indexid, 4, Mapeo[i][texturemodel][indexid]);
						cache_get_value_index(indexid, 5, MapeoTxdName[i][indexid], 80);
						cache_get_value_index(indexid, 6, MapeoTextureName[i][indexid], 80);
						cache_get_value_index_int(indexid, 7, Mapeo[i][materialcolor][indexid]);
						//////////
						cache_get_value_index(indexid, 8, MapeoText[i][indexid], 128);
						cache_get_value_index_int(indexid, 9, Mapeo[i][materialsize][indexid]);
						cache_get_value_index(indexid, 10, MapeoFont[i][indexid], 80);
						cache_get_value_index_int(indexid, 11, Mapeo[i][fontsize][indexid]);
						cache_get_value_index_int(indexid, 12, Mapeo[i][bold][indexid]);
						cache_get_value_index_int(indexid, 13, Mapeo[i][fontcolor][indexid]);
						cache_get_value_index_int(indexid, 14, Mapeo[i][backgroundcolor][indexid]);
						cache_get_value_index_int(indexid, 15, Mapeo[i][textalignment][indexid]);

						if (Mapeo[i][materialtype][indexid] == 1)
						{
							SetDynamicObjectMaterial(objectid, indexid, Mapeo[i][texturemodel][indexid], MapeoTxdName[i][indexid], MapeoTextureName[i][indexid], Mapeo[i][materialcolor][indexid]);
						}
						if (Mapeo[i][materialtype][indexid] == 2)
						{
							SetDynamicObjectMaterialText(objectid, indexid,
								ConvertToRGBColor(MapeoText[i][indexid]),
								Mapeo[i][materialsize][indexid],
								MapeoFont[i][indexid],
								Mapeo[i][fontsize][indexid],
								Mapeo[i][bold][indexid],
								Mapeo[i][fontcolor][indexid],
								Mapeo[i][backgroundcolor][indexid],
								Mapeo[i][textalignment][indexid]);
						}
					}
				}
				else{
					printf("[%s]: Error no se encontraron los materiales del objeto %d dentro de %s!", DIR_MAPEOS_DB, i, DIR_MAPEOS_MATERIAL);
				}
				cache_delete(MATERIAL_DATA);
				
				if (Mapeo[i][Tipo] == MAPEO_TYPE_PUERTA)
				{
					if (MAX_PUERTAS < MAX_PUERTAS_COUNT)
					{
						LoadPuertaMapeo(Mapeo[i][Tipoid], i);
					}
				}
				else if (Mapeo[i][Tipo] == MAPEO_TYPE_PEAJE)
				{
					if (MAX_PEAJES < MAX_PEAJES_COUNT)
					{
						LoadPeaje(Mapeo[i][Tipoid], i);
					}
				}
				else if (Mapeo[i][Tipo] == MAPEO_TYPE_PARQUEO)
				{
					if (MAX_PARQUEOS < MAX_PARQUEOS_COUNT)
					{
						LoadParqueo(Mapeo[i][Tipoid], i);
					}
				}
			}
		}
		cache_delete(CACHE);
	}
	printf("[%s]: Se cargaron %d mapeos!", DIR_MAPEOS_DB, MAX_MAPEOS);
	printf("[%s]: Se cargaron %d puertas!", DIR_PUERTAS_DB, MAX_PUERTAS);
	printf("[%s]: Se cargaron %d peajes!", DIR_PEAJES_DB, MAX_PEAJES);
	printf("[%s]: Se cargaron %d parqueos!", DIR_PARQUEOS_DB, MAX_PARQUEOS);
}

LoadPeaje(peajeid, mapeoid)
{
	new query[120], Cache:CACHE, rowExist;
	format(query, sizeof(query), "SELECT * FROM %s WHERE ID=%d;", DIR_PEAJES_DB, peajeid);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowExist);

	if(rowExist)
	{
	    cache_get_value_name_int(0, "mapeo_id", Peajes[peajeid][ID_Mapeo]);
	    cache_get_value_name_float(0, "PosXFalse", Peajes[peajeid][PosXFalse]);
	    cache_get_value_name_float(0, "PosYFalse", Peajes[peajeid][PosYFalse]);
	    cache_get_value_name_float(0, "PosZFalse", Peajes[peajeid][PosZFalse]);
	    cache_get_value_name_float(0, "PosRotXFalse", Peajes[peajeid][PosRotXFalse]);
	    cache_get_value_name_float(0, "PosRotYFalse", Peajes[peajeid][PosRotYFalse]);
	    cache_get_value_name_float(0, "PosRotZFalse", Peajes[peajeid][PosRotZFalse]);
	    cache_get_value_name_float(0, "PosCommandX", Peajes[peajeid][PosCommandX]);
	    cache_get_value_name_float(0, "PosCommandY", Peajes[peajeid][PosCommandY]);
	    cache_get_value_name_float(0, "PosCommandZ", Peajes[peajeid][PosCommandZ]);
	    cache_get_value_name_float(0, "Velocidad", Peajes[peajeid][Velocidad]);
	}
	cache_delete(CACHE);
	if(Peajes[peajeid][ID_Mapeo] != -1)
	{
		Peajes[peajeid][Creado] = true;
		MAX_PEAJES++;
		return true;
	}
	Mapeo[mapeoid][Tipo] = MAPEO_TYPE_OBJETO;
	Mapeo[mapeoid][Tipoid] = 0;
	return false;
}

LoadParqueo(parqueoid, mapeoid)
{
    new query[120], Cache:CACHE, rowExist;
	format(query, sizeof(query), "SELECT * FROM %s WHERE ID=%d;", DIR_PARQUEOS_DB, parqueoid);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowExist);
	if (rowExist)
	{
     	cache_get_value_name_int(0, "mapeo_id", Parqueo[parqueoid][ID_Mapeo]);
     	cache_get_value_name_float(0, "PosXFalse", Parqueo[parqueoid][PosXFalse]);
     	cache_get_value_name_float(0, "PosYFalse", Parqueo[parqueoid][PosYFalse]);
     	cache_get_value_name_float(0, "PosZFalse", Parqueo[parqueoid][PosZFalse]);
     	cache_get_value_name_float(0, "PosRotXFalse", Parqueo[parqueoid][PosRotXFalse]);
     	cache_get_value_name_float(0, "PosRotYFalse", Parqueo[parqueoid][PosRotYFalse]);
     	cache_get_value_name_float(0, "PosRotZFalse", Parqueo[parqueoid][PosRotZFalse]);
     	cache_get_value_name_float(0, "Velocidad", Parqueo[parqueoid][Velocidad]);
	}
	cache_delete(CACHE);
	if(Parqueo[parqueoid][ID_Mapeo] != -1){
		Parqueo[parqueoid][Creado] = true;
		Parqueo[parqueoid][Abierto] = false;
		MAX_PARQUEOS++;
		return true;
	}
	Mapeo[mapeoid][Tipo] = MAPEO_TYPE_OBJETO;
	Mapeo[mapeoid][Tipoid] = 0;
	return false;
}

stock LoadMapeosEx()
{
	//Cargar mapeos externos no usar
    for(new i=0; i != MAX_DOORS; i++)
	{
	    Mapeo[i][Modelo] = Doors[i][objectmodel];
	    Mapeo[i][PosX] = Doors[i][PosXTrue];
	    Mapeo[i][PosY] = Doors[i][PosYTrue];
	    Mapeo[i][PosZ] = Doors[i][PosZTrue];
	    Mapeo[i][PosRX] = Doors[i][PosRotXTrue];
	    Mapeo[i][PosRY] = Doors[i][PosRotYTrue];
	    Mapeo[i][PosRZ] = Doors[i][PosRotZTrue];
	    Mapeo[i][Mundo] = 0;
	    Mapeo[i][Interior] = 0;
	    format(Mapeo[i][CreatedBy], MAX_PLAYER_NAME, "Server");
	    Mapeo[i][Tipo] = 1;
	    Mapeo[i][Tipoid] = i;

	    new objectid = CreateDynamicObject(Mapeo[i][Modelo], Mapeo[i][PosX], Mapeo[i][PosY], Mapeo[i][PosZ], Mapeo[i][PosRX], Mapeo[i][PosRY], Mapeo[i][PosRZ], Mapeo[i][Mundo], Mapeo[i][Interior]);
		Mapeo[i][ID_Objeto] = objectid;
		MAX_MAPEOS++;

		Puerta[i][ID_Mapeo] = i;
		Puerta[i][Creada] = true;
		Puerta[i][PosX] = Doors[i][PosXFalse];
		Puerta[i][PosY] = Doors[i][PosYFalse];
		Puerta[i][PosZ] = Doors[i][PosZFalse];
		Puerta[i][PosRX] = Doors[i][PosRotXFalse];
		Puerta[i][PosRY] = Doors[i][PosRotYFalse];
		Puerta[i][PosRZ] = Doors[i][PosRotZFalse];
		Puerta[i][Velocidad] = Doors[i][speedmove];
		Puerta[i][Abierta] = false;
		Puerta[i][LlaveTipo] = 0;
		Puerta[i][LlaveOwnerID] = Doors[i][Dueno];
		MAX_PUERTAS++;
	}
}

LoadPuertaMapeo(id, mapeoid)
{
    new query[100], Cache:CACHE, rowExist;
	format(query,sizeof(query), "SELECT * FROM %s WHERE ID=%d;", DIR_PUERTAS_DB, id);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowExist);
	if (rowExist)
	{
		cache_get_value_name_int(0, "mapeo_id", Puerta[id][ID_Mapeo]);
		cache_get_value_name_float(0, "PosX", Puerta[id][PosX]);
		cache_get_value_name_float(0, "PosY", Puerta[id][PosY]);
		cache_get_value_name_float(0, "PosZ", Puerta[id][PosZ]);
		cache_get_value_name_float(0, "PosRX", Puerta[id][PosRX]);
		cache_get_value_name_float(0, "PosRY", Puerta[id][PosRY]);
		cache_get_value_name_float(0, "PosRZ", Puerta[id][PosRZ]);
		cache_get_value_name_float(0, "Velocidad", Puerta[id][Velocidad]);
		cache_get_value_name_int(0, "Abierta", Puerta[id][Abierta]);
		cache_get_value_name_int(0, "LlaveTipo", Puerta[id][LlaveTipo]);
		cache_get_value_name_int(0, "LlaveOwnerID", Puerta[id][LlaveOwnerID]);
	}
	cache_delete(CACHE);
	if(Puerta[id][ID_Mapeo] != -1)
	{
		Puerta[id][Creada] = true;
		MAX_PUERTAS++;
		
		if (Puerta[id][Abierta])
		{
			SetDynamicObjectPos(Mapeo[mapeoid][ID_Objeto], Puerta[id][PosX], Puerta[id][PosY], Puerta[id][PosZ]);
			SetDynamicObjectRot(Mapeo[mapeoid][ID_Objeto], Puerta[id][PosRX], Puerta[id][PosRY], Puerta[id][PosRZ]);
		}
		return true;
	}
	Mapeo[mapeoid][Tipo] = MAPEO_TYPE_OBJETO;
	Mapeo[mapeoid][Tipoid] = 0;
	return false;
}

SaveMapeo(mapeoid)
{
	new query[1024], Cache:cacheid, rowExist;

	format(query, sizeof(query), "SELECT ID FROM %s WHERE ID=%i;", DIR_MAPEOS_DB, mapeoid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(rowExist);
	cache_delete(cacheid);

    if (Mapeo[mapeoid][Modelo] != 0 && !rowExist)
	{
		mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s (ID,Modelo) VALUES ('%d', '%d');", DIR_MAPEOS_DB, mapeoid, Mapeo[mapeoid][Modelo]);
		mysql_query(dataBase, query, false);
		rowExist = true;
	}
    if(rowExist)
    {
		mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET `Modelo`='%d',`PosX`='%f',`PosY`='%f',`PosZ`='%f',\
			`PosRX`='%f',`PosRY`='%f',`PosRZ`='%f',`Mundo`='%d',`Interior`='%d',`CreatedBy`='%e',`Tipo`='%d',`Tipoid`='%d' WHERE ID=%d;", DIR_MAPEOS_DB,
			Mapeo[mapeoid][Modelo],
			Mapeo[mapeoid][PosX],
			Mapeo[mapeoid][PosY],
			Mapeo[mapeoid][PosZ],

			Mapeo[mapeoid][PosRX],
			Mapeo[mapeoid][PosRY],
			Mapeo[mapeoid][PosRZ],
			Mapeo[mapeoid][Mundo],
			Mapeo[mapeoid][Interior],
			Mapeo[mapeoid][CreatedBy],
			Mapeo[mapeoid][Tipo],
			Mapeo[mapeoid][Tipoid],
			mapeoid);
		mysql_query(dataBase, query, false);

		//////////////////
	    for(new indexid=0; indexid != MAX_MATERIALINDEX; indexid++)
	    {
			mysql_format(dataBase, query, sizeof(query), "SELECT ID FROM %s WHERE mapeo_id=%d AND material_id=%d;", DIR_MAPEOS_MATERIAL, mapeoid, indexid);
			cacheid = mysql_query(dataBase, query);
			cache_get_row_count(rowExist);
			cache_delete(cacheid);

			if(!rowExist){
				mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s (mapeo_id, material_id) VALUES ('%d','%d');", DIR_MAPEOS_MATERIAL, mapeoid, indexid);
				mysql_query(dataBase, query, false);
			}

			mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
				`materialtype`='%d',`texturemodel`='%d',`txdname`='%e',`texturename`='%e',`materialcolor`='%d',\
				`materialtext`='%e',`materialsize`='%d',`fonttext`='%e',`fontsize`='%d',`bold`='%d',`fontcolor`='%d',`backgroundcolor`='%d',`textalignment`='%d'\
				 WHERE mapeo_id=%d AND material_id=%d;", DIR_MAPEOS_MATERIAL, 
				Mapeo[mapeoid][materialtype][indexid],
				Mapeo[mapeoid][texturemodel][indexid],
				MapeoTxdName[mapeoid][indexid],
				MapeoTextureName[mapeoid][indexid],
				Mapeo[mapeoid][materialcolor][indexid],
				//////////
				MapeoText[mapeoid][indexid],
				Mapeo[mapeoid][materialsize][indexid],
				MapeoFont[mapeoid][indexid],
				Mapeo[mapeoid][fontsize][indexid],
				Mapeo[mapeoid][bold][indexid],
				Mapeo[mapeoid][fontcolor][indexid],
				Mapeo[mapeoid][backgroundcolor][indexid],
				Mapeo[mapeoid][textalignment][indexid],
				mapeoid, indexid);
			mysql_query(dataBase, query, false);
		}

	    if (Mapeo[mapeoid][Tipo] == MAPEO_TYPE_PUERTA)
	    {
	        SavePuerta(Mapeo[mapeoid][Tipoid]);
	    }
	    else if(Mapeo[mapeoid][Tipo] == MAPEO_TYPE_PEAJE)
	    {
	        SavePeaje(Mapeo[mapeoid][Tipoid]);
	    }
	    else if(Mapeo[mapeoid][Tipo] == MAPEO_TYPE_PARQUEO)
	    {
	        SaveParqueo(Mapeo[mapeoid][Tipoid]);
	    }
    }
}

SavePuerta(id)
{
	new query[1024], Cache:CACHE, rowExist;
	format(query, sizeof(query), "SELECT ID FROM %s WHERE ID=%d;", DIR_PUERTAS_DB, id);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowExist);
	cache_delete(CACHE);

	if(Puerta[id][Creada] && !rowExist){
		format(query, sizeof(query), "INSERT INTO %s (ID,mapeo_id) VALUES ('%d','%d');", DIR_PUERTAS_DB, id, Puerta[id][ID_Mapeo]);
		mysql_query(dataBase, query, false);
		rowExist = true;
	}

	if(rowExist){
		mysql_format(dataBase, query,sizeof(query), "UPDATE %s SET \
			`mapeo_id`='%d',`PosX`='%f',`PosY`='%f',`PosZ`='%f',`PosRX`='%f',`PosRY`='%f',`PosRZ`='%f',\
			`Velocidad`='%f',`Abierta`='%d',`LlaveTipo`='%d',`LlaveOwnerID`='%d' WHERE ID=%d;", DIR_PUERTAS_DB,
			Puerta[id][ID_Mapeo],
			Puerta[id][PosX],
			Puerta[id][PosY],
			Puerta[id][PosZ],
			Puerta[id][PosRX],
			Puerta[id][PosRY],
			Puerta[id][PosRZ],

			Puerta[id][Velocidad],
			Puerta[id][Abierta],
			Puerta[id][LlaveTipo],
			Puerta[id][LlaveOwnerID],
			id);
		mysql_query(dataBase, query, false);
	}
}

SavePeaje(peajeid)
{
	new query[1024], Cache:CACHE, rowExist;
	format(query, sizeof(query), "SELECT ID FROM %s WHERE ID=%d;", DIR_PEAJES_DB, peajeid);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowExist);
	cache_delete(CACHE);

	if(Peajes[peajeid][Creado] && !rowExist){
		format(query, sizeof(query), "INSERT INTO %s (ID,mapeo_id) VALUES ('%d','%d');", DIR_PEAJES_DB, peajeid, Peajes[peajeid][ID_Mapeo]);
		mysql_query(dataBase, query, false);
		rowExist = true;
	}

	if(rowExist)
	{
		format(query, sizeof(query), "UPDATE %s SET `mapeo_id`='%d',`PosXFalse`='%f',`PosYFalse`='%f',`PosZFalse`='%f',`PosRotXFalse`='%f',`PosRotYFalse`='%f',`PosRotZFalse`='%f',\
			`PosCommandX`='%f',`PosCommandY`='%f',`PosCommandZ`='%f',`Velocidad`='%f' WHERE ID=%d;", DIR_PEAJES_DB, 
			Peajes[peajeid][ID_Mapeo],
			Peajes[peajeid][PosXFalse],
			Peajes[peajeid][PosYFalse],
			Peajes[peajeid][PosZFalse],
			Peajes[peajeid][PosRotXFalse],
			Peajes[peajeid][PosRotYFalse],
			Peajes[peajeid][PosRotZFalse],
			
			Peajes[peajeid][PosCommandX],
			Peajes[peajeid][PosCommandY],
			Peajes[peajeid][PosCommandZ],
			Peajes[peajeid][Velocidad],
			peajeid);
		mysql_query(dataBase, query, false);
	}
}

ShowObjectMenu(playerid, tipoObjeto)
{
    new objectid = PlayersDataOnline[playerid][EditingObjectID];
	if (tipoObjeto == EDITING_TYPE_MAPEO)
	{
	    new mapeoid = PlayersDataOnline[playerid][EditingMapeo];
	    if (Mapeo[mapeoid][ID_Objeto] == objectid && objectid != 0)
	    {
	        new string[1024], caption[100];

	        if (Mapeo[mapeoid][Tipo] == MAPEO_TYPE_OBJETO)//Objeto
	        {
	            format(caption, sizeof(caption), "{"COLOR_AZUL"}Objeto modelo %i (ID: %i[%i])", Mapeo[mapeoid][Modelo], Mapeo[mapeoid][ID_Objeto], mapeoid);
	            format(string, sizeof(string), "Editar\n");
			 	format(string, sizeof(string), "%sIndexs\n", string);
			 	format(string, sizeof(string), "%sDuplicar\n", string);
			 	format(string, sizeof(string), "%sPropiedades\n", string);
			 	format(string, sizeof(string), "%sCreado por: {"COLOR_AZUL"}%s\n", string, Mapeo[mapeoid][CreatedBy]);
			 	format(string, sizeof(string), "%sTipo: {"COLOR_AZUL"}%s\n \n", string, MapeoType[Mapeo[mapeoid][Tipo]]);
			 	format(string, sizeof(string), "%s{FF0000}Borrar", string);
	        }
			else if (Mapeo[mapeoid][Tipo] == MAPEO_TYPE_PUERTA)//Puerta
	        {
	            new puertaid = Mapeo[mapeoid][Tipoid];
	            format(caption, sizeof(caption), "{"COLOR_AZUL"}Puerta [%i] modelo %i (ID: %i[%i])", puertaid, Mapeo[mapeoid][Modelo], Mapeo[mapeoid][ID_Objeto], mapeoid);
	            format(string, sizeof(string), "Editar\n");
			 	format(string, sizeof(string), "%sIndexs\n", string);
			 	format(string, sizeof(string), "%sDuplicar\n", string);
			 	format(string, sizeof(string), "%sCreada por: {"COLOR_AZUL"}%s\n", string, Mapeo[mapeoid][CreatedBy]);
			 	format(string, sizeof(string), "%sTipo: {"COLOR_AZUL"}%s\n \n", string, MapeoType[Mapeo[mapeoid][Tipo]]);
			 	format(string, sizeof(string), "%sLlave Tipo: {"COLOR_AZUL"}%s\n", string, LlaveTipoName[Puerta[puertaid][LlaveTipo]]);
			 	if (Puerta[puertaid][LlaveTipo] == 0)
				format(string, sizeof(string), "%sLlave Faccion: {"COLOR_AZUL"}%s\n \n", string, FaccionData[Puerta[puertaid][LlaveOwnerID]][NameFaccion]);
			 	else format(string, sizeof(string), "%sLlave ID: {"COLOR_AZUL"}%i\n \n", string, Puerta[puertaid][LlaveOwnerID]);
			 	format(string, sizeof(string), "%sEditar Recorrido\n", string);
			 	format(string, sizeof(string), "%sVelocidad: {"COLOR_AZUL"}%.2f\n \n", string, Puerta[puertaid][Velocidad]);
			 	format(string, sizeof(string), "%s{FF0000}Borrar", string);
	        }
			else if (Mapeo[mapeoid][Tipo] == MAPEO_TYPE_PEAJE)//Peaje
	        {
	            new peajeid = Mapeo[mapeoid][Tipoid];
	            format(caption, sizeof(caption), "{"COLOR_AZUL"}Peaje [%i] modelo %i (ID: %i[%i])", peajeid, Mapeo[mapeoid][Modelo], Mapeo[mapeoid][ID_Objeto], mapeoid);
	            format(string, sizeof(string), "Editar\n");
			 	format(string, sizeof(string), "%sIndexs\n", string);
			 	format(string, sizeof(string), "%sDuplicar\n", string);
			 	format(string, sizeof(string), "%sCreada por: {"COLOR_AZUL"}%s\n", string, Mapeo[mapeoid][CreatedBy]);
			 	format(string, sizeof(string), "%sTipo: {"COLOR_AZUL"}%s\n \n", string, MapeoType[Mapeo[mapeoid][Tipo]]);
			 	format(string, sizeof(string), "%sEditar Recorrido\n", string);
			 	format(string, sizeof(string), "%sVelocidad: {"COLOR_AZUL"}%.2f\n", string, Peajes[peajeid][Velocidad]);
			 	format(string, sizeof(string), "%sPosicion del comando\n \n", string);
			 	format(string, sizeof(string), "%s{FF0000}Borrar", string);
	        }
			else if (Mapeo[mapeoid][Tipo] == MAPEO_TYPE_PARQUEO)
	        {
	            new parqueoid = Mapeo[mapeoid][Tipoid];
	            format(caption, sizeof(caption), "{"COLOR_AZUL"}Parqueo [%i] modelo %i (ID: %i[%i])", parqueoid, Mapeo[mapeoid][Modelo], Mapeo[mapeoid][ID_Objeto], mapeoid);
	            format(string, sizeof(string), "Editar\n");
			 	format(string, sizeof(string), "%sIndexs\n", string);
			 	format(string, sizeof(string), "%sDuplicar\n", string);
			 	format(string, sizeof(string), "%sCreada por: {"COLOR_AZUL"}%s\n", string, Mapeo[mapeoid][CreatedBy]);
			 	format(string, sizeof(string), "%sTipo: {"COLOR_AZUL"}%s\n \n", string, MapeoType[Mapeo[mapeoid][Tipo]]);
			 	format(string, sizeof(string), "%sEditar Recorrido\n", string);
			 	format(string, sizeof(string), "%sVelocidad: {"COLOR_AZUL"}%.2f\n \n", string, Parqueo[parqueoid][Velocidad]);
			 	format(string, sizeof(string), "%s{FF0000}Borrar", string);
	        }
		    ShowPlayerDialogEx(playerid, 156, DIALOG_STYLE_LIST, caption, string, "Seleccionar", "Cancelar");
	    }
	}
}

ShowObjectIndexes(playerid)
{
	new objectid = PlayersDataOnline[playerid][EditingObjectID];
	new string[1024], caption[100];

	if (PlayersDataOnline[playerid][EditingType] == EDITING_TYPE_MAPEO)
	{
	    new mapeoid = PlayersDataOnline[playerid][EditingMapeo];

	    format(caption, sizeof(caption), "{0075FF}Indexs del objeto modelo %i (ID: %i[%i])", Mapeo[mapeoid][Modelo], objectid, mapeoid);

	    for( new index=0; index!=MAX_MATERIALINDEX; index++)
	    {
	        format(string, sizeof(string), "%sIndex %i: %s\n", string, index, IndexType[Mapeo[mapeoid][materialtype][index]]);
		}
	}
	ShowPlayerDialogEx(playerid, 157, DIALOG_STYLE_LIST, caption, string, "Seleccionar", "Volver");
}

ShowObjectIndex(playerid, indexid)
{
	new string[1024], caption[100];
	if (PlayersDataOnline[playerid][EditingType] == EDITING_TYPE_MAPEO)
	{
	    new mapeoid = PlayersDataOnline[playerid][EditingMapeo];

	    format(caption, sizeof(caption), "{"COLOR_AZUL"}Index %i del objeto modelo %i (ID: %i[%i])", indexid, Mapeo[mapeoid][Modelo], Mapeo[mapeoid][ID_Objeto], mapeoid);
	    format(string, sizeof(string), "{"COLOR_AZUL"}TEXTURAS\n");
	    format(string, sizeof(string), "%sModelo: {"COLOR_AZUL"}(%i)\n", string, Mapeo[mapeoid][texturemodel][indexid]);//1
	    format(string, sizeof(string), "%sTXD: {"COLOR_AZUL"}(%s)\n", string, MapeoTxdName[mapeoid][indexid]);
	    format(string, sizeof(string), "%sTextura: {"COLOR_AZUL"}(%s)\n", string, MapeoTextureName[mapeoid][indexid]);
	    format(string, sizeof(string), "%sColor: {"COLOR_AZUL"}(%i)\n \n", string, Mapeo[mapeoid][materialcolor][indexid]);//4
	    format(string, sizeof(string), "%s{"COLOR_AZUL"}TEXTO\n", string);
	    format(string, sizeof(string), "%sAsignar Texto\n", string);//7
	    format(string, sizeof(string), "%sTamaño de lienzo {"COLOR_AZUL"}(%i)\n", string, Mapeo[mapeoid][materialsize][indexid]);
	    format(string, sizeof(string), "%sCambiar Fuente {"COLOR_AZUL"}(%s)\n", string, MapeoFont[mapeoid][indexid]);
	    format(string, sizeof(string), "%sTamaño de Texto {"COLOR_AZUL"}(%i)\n", string, Mapeo[mapeoid][fontsize][indexid]);
	    format(string, sizeof(string), "%sUsar Negrita {"COLOR_AZUL"}(%i)\n", string, Mapeo[mapeoid][bold][indexid]);
	    format(string, sizeof(string), "%sColor de Texto {"COLOR_AZUL"}(%i)\n", string, Mapeo[mapeoid][fontcolor][indexid]);
	    format(string, sizeof(string), "%sColor del Fondo {"COLOR_AZUL"}(%x)\n", string, Mapeo[mapeoid][backgroundcolor][indexid]);
	    format(string, sizeof(string), "%sCambiar Alineacion {"COLOR_AZUL"}(%s)\n \n", string, Alineacion[Mapeo[mapeoid][textalignment][indexid]]);//14
	    format(string, sizeof(string), "%s{FF0000}Borrar Index", string);//16
	}
    ShowPlayerDialogEx(playerid, 158, DIALOG_STYLE_LIST, caption, string, "Seleccionar", "Volver");
}

ShowEditObjectMaerial(playerid, indexid, option)
{
	new string[1024], caption[100];
    //Material
    if (option == 1)//Modelo
    {
        format(caption, sizeof(caption), "{"COLOR_AZUL"}Index %i -> Modelo", indexid);
        format(string, sizeof(string), "Ingrese el ID de modeo de la textura:\n");
    }
    else if (option == 2)//TXD
    {
        format(caption, sizeof(caption), "{"COLOR_AZUL"}Index %i -> TXD", indexid);
        format(string, sizeof(string), "Ingrese el TXD de la textura:\n");
    }
    else if (option == 3)//Textura
    {
        format(caption, sizeof(caption), "{"COLOR_AZUL"}Index %i -> Textura", indexid);
        format(string, sizeof(string), "Ingrese la Textura:\n");
    }
    else if (option == 4)//Color
    {
        format(caption, sizeof(caption), "{"COLOR_AZUL"}Index %i -> Color de la textura", indexid);
        format(string, sizeof(string), "Ingrese el color en formato ARGB:\n");
    }
    //MaterialText
    else if (option == 7)//Asignar Texto
    {
        format(caption, sizeof(caption), "{"COLOR_AZUL"}Index %i -> Texto", indexid);
        format(string, sizeof(string), "Ingrese el texto:\n");
    }
    else if (option == 8)//Tamaño Lienzo
    {
        format(caption, sizeof(caption), "{"COLOR_AZUL"}Index %i -> Tamaño del Lienzo", indexid);
        format(string, sizeof(string), "Ingrese :\n");
    }
    else if (option == 9)//Fuente
    {
        format(caption, sizeof(caption), "{"COLOR_AZUL"}Index %i -> Fuente", indexid);
        format(string, sizeof(string), "Ingrese una fuente. Ejemplo: \"Arial\"\n");
    }
    else if (option == 10)//Tamaño de Texto
    {
        format(caption, sizeof(caption), "{"COLOR_AZUL"}Index %i -> Tamaño de Texto", indexid);
        format(string, sizeof(string), "Ingrese un Tamaño del texto 0-255:\n");
    }
    else if (option == 12)//Color Texto
    {
        format(caption, sizeof(caption), "{"COLOR_AZUL"}Index %i -> Color del Texto", indexid);
        format(string, sizeof(string), "Ingrese el color en formato ARGB:\n");
    }
    else if (option == 13)//Color Fondo
    {
        format(caption, sizeof(caption), "{"COLOR_AZUL"}Index %i -> Color del Fondo", indexid);
        format(string, sizeof(string), "Ingrese el color en formato ARGB:\n");
    }
    ShowPlayerDialogEx(playerid, 159, DIALOG_STYLE_INPUT, caption, string, "Aceptar", "Cancelar");
}

ShowVelocidadObjetoMenu(playerid, mapeoid)
{
	new caption[64];
    format(caption, sizeof(caption), "{"COLOR_AZUL"}%s %i -> Velocidad", MapeoType[Mapeo[mapeoid][Tipo]], Mapeo[mapeoid][Tipoid]);
    
    ShowPlayerDialogEx(playerid, 160, DIALOG_STYLE_INPUT, caption, "Ingrese la velocidad a la que se movera el objeto:\n", "Aceptar", "Cancelar");
}

ShowPuertaOwnerMenu(playerid, mapeoid)
{
	new
		puertaid = Mapeo[mapeoid][Tipoid],
		caption[64],
		info[140];
    format(caption, sizeof(caption), "{"COLOR_AZUL"}Puerta %i -> %s ID", puertaid, LlaveTipoName[Puerta[puertaid][LlaveTipo]]);
    format(info, sizeof(info), "{"COLOR_CREMA"}Ingrese el ID de %s", LlaveTipoName[Puerta[puertaid][LlaveTipo]]);
	ShowPlayerDialogEx(playerid, 161, DIALOG_STYLE_INPUT, caption, info, "Aceptar", "Cancelar");
}

CrearMapeo(playerid, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid, interiorid)
{
	new mapeoid = GetNextMapeoID();
	if (mapeoid == -1) return -1;
    new objectid = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, worldid, interiorid);
	//////////
	Mapeo[mapeoid][Modelo] = modelid;
	Mapeo[mapeoid][PosX] = x;
	Mapeo[mapeoid][PosY] = y;
	Mapeo[mapeoid][PosZ] = z;
	Mapeo[mapeoid][PosRX] = rx;
	Mapeo[mapeoid][PosRY] = ry;
	Mapeo[mapeoid][PosRZ] = rz;
	Mapeo[mapeoid][Mundo] = worldid;
	Mapeo[mapeoid][Interior] = interiorid;
	format(Mapeo[mapeoid][CreatedBy], MAX_PLAYER_NAME, PlayersDataOnline[playerid][NameOnline]);
	//////////
	Mapeo[mapeoid][ID_Objeto] = objectid;
	MAX_MAPEOS++;
	SaveMapeo(mapeoid);
	return mapeoid;
}

GetNextMapeoID()
{
	for (new i=0; i != MAX_MAPEOS_COUNT; i++)
	{
	    if (Mapeo[i][Modelo] == 0) return i;
	}
	return -1;
}

DuplicarMapeo(playerid, mapeoid)
{
    if (MAX_MAPEOS == MAX_MAPEOS_COUNT)
	{
	    new string[144];
	    format(string, sizeof(string), "Se alcanzo el maximo de mapeos (%i)", MAX_MAPEOS_COUNT);
	    return SendInfoMessage(playerid, 0, "", string);
	}
	new mapeoid_new = CrearMapeo(playerid, Mapeo[mapeoid][Modelo],
		Mapeo[mapeoid][PosX], Mapeo[mapeoid][PosY], Mapeo[mapeoid][PosZ],
		Mapeo[mapeoid][PosRX], Mapeo[mapeoid][PosRY], Mapeo[mapeoid][PosRZ],
		Mapeo[mapeoid][Mundo], Mapeo[mapeoid][Interior]);

	for (new indexid=0; indexid != MAX_MATERIALINDEX; indexid++)
	{
	    Mapeo[mapeoid_new][materialtype][indexid] = Mapeo[mapeoid][materialtype][indexid];
	    
	    Mapeo[mapeoid_new][texturemodel][indexid] = Mapeo[mapeoid][texturemodel][indexid];
	    format(MapeoTxdName[mapeoid_new][indexid], 30, MapeoTxdName[mapeoid][indexid]);
	    format(MapeoTextureName[mapeoid_new][indexid], 30, MapeoTextureName[mapeoid][indexid]);
	    Mapeo[mapeoid_new][materialcolor][indexid] = Mapeo[mapeoid][materialcolor][indexid];
	    
	    format(MapeoText[mapeoid_new][indexid], 128, MapeoText[mapeoid][indexid]);
	    Mapeo[mapeoid_new][materialsize][indexid] = Mapeo[mapeoid][materialsize][indexid];
	    format(MapeoFont[mapeoid_new][indexid], 40, MapeoFont[mapeoid][indexid]);
	    Mapeo[mapeoid_new][fontsize][indexid] = Mapeo[mapeoid][fontsize][indexid];
	    Mapeo[mapeoid_new][bold][indexid] = Mapeo[mapeoid][bold][indexid];
	    Mapeo[mapeoid_new][fontcolor][indexid] = Mapeo[mapeoid][fontcolor][indexid];
	    Mapeo[mapeoid_new][backgroundcolor][indexid] = Mapeo[mapeoid][backgroundcolor][indexid];
	    Mapeo[mapeoid_new][textalignment][indexid] = Mapeo[mapeoid][textalignment][indexid];
	
	    if (Mapeo[mapeoid][materialtype][indexid] == 1)
	    {
	        SetDynamicObjectMaterial(Mapeo[mapeoid_new][ID_Objeto], indexid, Mapeo[mapeoid][texturemodel][indexid], MapeoTxdName[mapeoid][indexid], MapeoTextureName[mapeoid][indexid], Mapeo[mapeoid][materialcolor][indexid]);
	    }
	    if (Mapeo[mapeoid][materialtype][indexid] == 2)
	    {
	        SetDynamicObjectMaterialText(Mapeo[mapeoid_new][ID_Objeto], indexid,
				ConvertToRGBColor(MapeoText[mapeoid][indexid]),
				Mapeo[mapeoid][materialsize][indexid],
				MapeoFont[mapeoid][indexid],
				Mapeo[mapeoid][fontsize][indexid],
				Mapeo[mapeoid][bold][indexid],
				Mapeo[mapeoid][fontcolor][indexid],
				Mapeo[mapeoid][backgroundcolor][indexid],
				Mapeo[mapeoid][textalignment][indexid]);
	    }
	}

    if (playerid != -1)
    {
        CancelEdit(playerid);
		PlayersDataOnline[playerid][EditingMapeo] = mapeoid_new;
		PlayersDataOnline[playerid][EditingObjectID] = Mapeo[mapeoid_new][ID_Objeto];
        EditDynamicObject(playerid, Mapeo[mapeoid_new][ID_Objeto]);
        new string[144];
        format(string, sizeof(string), "Creaste un mapeo modelo %i, Objetoid %i con el ID %i (Duplicar %i)", Mapeo[mapeoid_new][Modelo], Mapeo[mapeoid_new][ID_Objeto], mapeoid_new, mapeoid);
		SendAdviseMessage(playerid, string);
    }
    return 1;
}

DuplicarMapeoEx(playerid, mapeoid)
{
    if (MAX_MAPEOS == MAX_MAPEOS_COUNT)
	{
	    new string[144];
	    format(string, sizeof(string), "Se alcanzo el maximo de mapeos (%i)", MAX_MAPEOS_COUNT);
	    return SendInfoMessage(playerid, 0, "", string);
	}
    new Float:Pos[6];
	Pos[0] = GetPVarFloat(playerid, "editingobjectX");
	Pos[1] = GetPVarFloat(playerid, "editingobjectY");
	Pos[2] = GetPVarFloat(playerid, "editingobjectZ");
	Pos[3] = GetPVarFloat(playerid, "editingobjectRX");
 	Pos[4] = GetPVarFloat(playerid, "editingobjectRY");
	Pos[5] = GetPVarFloat(playerid, "editingobjectRZ");

	Mapeo[mapeoid][PosX] = Pos[0];
	Mapeo[mapeoid][PosY] = Pos[1];
	Mapeo[mapeoid][PosZ] = Pos[2];
	Mapeo[mapeoid][PosRX] = Pos[3];
	Mapeo[mapeoid][PosRY] = Pos[4];
	Mapeo[mapeoid][PosRZ] = Pos[5];
	SetDynamicObjectPos(Mapeo[mapeoid][ID_Objeto], Pos[0], Pos[1], Pos[2]);
	SetDynamicObjectRot(Mapeo[mapeoid][ID_Objeto], Pos[3], Pos[4], Pos[5]);

	new mapeoid_new = CrearMapeo(playerid, Mapeo[mapeoid][Modelo],
		Mapeo[mapeoid][PosX], Mapeo[mapeoid][PosY], Mapeo[mapeoid][PosZ],
		Mapeo[mapeoid][PosRX], Mapeo[mapeoid][PosRY], Mapeo[mapeoid][PosRZ],
		Mapeo[mapeoid][Mundo], Mapeo[mapeoid][Interior]);
		
    for (new indexid=0; indexid != MAX_MATERIALINDEX; indexid++)
	{
	    Mapeo[mapeoid_new][materialtype][indexid] = Mapeo[mapeoid][materialtype][indexid];

	    Mapeo[mapeoid_new][texturemodel][indexid] = Mapeo[mapeoid][texturemodel][indexid];
	    format(MapeoTxdName[mapeoid_new][indexid], 30, MapeoTxdName[mapeoid][indexid]);
	    format(MapeoTextureName[mapeoid_new][indexid], 30, MapeoTextureName[mapeoid][indexid]);
	    Mapeo[mapeoid_new][materialcolor][indexid] = Mapeo[mapeoid][materialcolor][indexid];

	    format(MapeoText[mapeoid_new][indexid], 128, MapeoText[mapeoid][indexid]);
	    Mapeo[mapeoid_new][materialsize][indexid] = Mapeo[mapeoid][materialsize][indexid];
	    format(MapeoFont[mapeoid_new][indexid], 40, MapeoFont[mapeoid][indexid]);
	    Mapeo[mapeoid_new][fontsize][indexid] = Mapeo[mapeoid][fontsize][indexid];
	    Mapeo[mapeoid_new][bold][indexid] = Mapeo[mapeoid][bold][indexid];
	    Mapeo[mapeoid_new][fontcolor][indexid] = Mapeo[mapeoid][fontcolor][indexid];
	    Mapeo[mapeoid_new][backgroundcolor][indexid] = Mapeo[mapeoid][backgroundcolor][indexid];
	    Mapeo[mapeoid_new][textalignment][indexid] = Mapeo[mapeoid][textalignment][indexid];

	    if (Mapeo[mapeoid][materialtype][indexid] == 1)
	    {
	        SetDynamicObjectMaterial(Mapeo[mapeoid_new][ID_Objeto], indexid, Mapeo[mapeoid][texturemodel][indexid], MapeoTxdName[mapeoid][indexid], MapeoTextureName[mapeoid][indexid], Mapeo[mapeoid][materialcolor][indexid]);
	    }
	    if (Mapeo[mapeoid][materialtype][indexid] == 2)
	    {
	        SetDynamicObjectMaterialText(Mapeo[mapeoid_new][ID_Objeto], indexid,
				ConvertToRGBColor(MapeoText[mapeoid][indexid]),
				Mapeo[mapeoid][materialsize][indexid],
				MapeoFont[mapeoid][indexid],
				Mapeo[mapeoid][fontsize][indexid],
				Mapeo[mapeoid][bold][indexid],
				Mapeo[mapeoid][fontcolor][indexid],
				Mapeo[mapeoid][backgroundcolor][indexid],
				Mapeo[mapeoid][textalignment][indexid]);
	    }
	}

	if (playerid != -1)
    {
        CancelEdit(playerid);
		PlayersDataOnline[playerid][EditingMapeo] = mapeoid_new;
		PlayersDataOnline[playerid][EditingObjectID] = Mapeo[mapeoid_new][ID_Objeto];
        EditDynamicObject(playerid, Mapeo[mapeoid_new][ID_Objeto]);
        new string[144];
        format(string, sizeof(string), "Creaste un mapeo modelo %i, Objetoid %i con el ID %i (Duplicar %i)", Mapeo[mapeoid_new][Modelo], Mapeo[mapeoid_new][ID_Objeto], mapeoid_new, mapeoid);
		SendAdviseMessage(playerid, string);
    }
    return 1;
}

ShowMapeoTypeDialog(playerid)
{
	new mapeoid = PlayersDataOnline[playerid][EditingMapeo];
	new caption[60], info[80];
	
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Objeto modelo %i (ID: %i[%i]) -> Tipo", Mapeo[mapeoid][Modelo], Mapeo[mapeoid][ID_Objeto], mapeoid);
	for(new i=0; i!=4; i++)
	{
	    if (Mapeo[mapeoid][Tipo] == i)
	    format(info, sizeof(info), "%s{"COLOR_AZUL"}%s\n", info, MapeoType[i]);
	    else
	    format(info, sizeof(info), "%s%s\n", info, MapeoType[i]);
	}
	ShowPlayerDialogEx(playerid, 164, DIALOG_STYLE_LIST, caption, info, "Cambiar", "Volver");
}

ShowMapeoPropiedades(playerid, mapeoid)
{
	new caption[60], info[500];
	
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Objeto modelo %i (ID: %i[%i]) -> Propiedades", Mapeo[mapeoid][Modelo], Mapeo[mapeoid][ID_Objeto], mapeoid);
	format(info, sizeof(info), "Modelo:\t%i\n", Mapeo[mapeoid][Modelo]);
	format(info, sizeof(info), "%sMundo:\t%i\n", info, Mapeo[mapeoid][Mundo]);
	format(info, sizeof(info), "%sInterior:\t%i\n", info, Mapeo[mapeoid][Interior]);
	format(info, sizeof(info), "%sX:\t%f\n", info, Mapeo[mapeoid][PosX]);
	format(info, sizeof(info), "%sY:\t%f\n", info, Mapeo[mapeoid][PosY]);
	format(info, sizeof(info), "%sZ:\t%f\n", info, Mapeo[mapeoid][PosZ]);
	format(info, sizeof(info), "%sRX:\t%f\n", info, Mapeo[mapeoid][PosRX]);
	format(info, sizeof(info), "%sRY:\t%f\n", info, Mapeo[mapeoid][PosRY]);
	format(info, sizeof(info), "%sRZ:\t%f\n", info, Mapeo[mapeoid][PosRZ]);
	
    ShowPlayerDialogEx(playerid, 165, DIALOG_STYLE_TABLIST, caption, info, "Aceptar", "Volver");
	return 1;
}

ShowMapeoPropiedadChange(playerid, mapeoid, option)
{
	new caption[60], info[144];
	
	if (option == 0)
	{
	    format(caption, sizeof(caption), "{"COLOR_AZUL"}Objeto %i[%i] -> Propiedades -> Modelo", Mapeo[mapeoid][ID_Objeto], mapeoid);
		format(info, sizeof(info), "Ingrese un nuevo Model_ID para el objeto:");
	}
	else if (option == 1)
	{
	    format(caption, sizeof(caption), "{"COLOR_AZUL"}Objeto %i[%i] -> Propiedades -> Mundo", Mapeo[mapeoid][ID_Objeto], mapeoid);
		format(info, sizeof(info), "Ingrese un nuevo mundo para el objeto:");
	}
	else if (option == 2)
	{
	    format(caption, sizeof(caption), "{"COLOR_AZUL"}Objeto %i[%i] -> Propiedades -> Interior", Mapeo[mapeoid][ID_Objeto], mapeoid);
		format(info, sizeof(info), "Ingrese un nuevo interior para el objeto:");
	}
	else if (option == 3)
	{
	    format(caption, sizeof(caption), "{"COLOR_AZUL"}Objeto %i[%i] -> Propiedades -> PosX", Mapeo[mapeoid][ID_Objeto], mapeoid);
		format(info, sizeof(info), "Ingrese una nueva coordenada X para el objeto:");
	}
	else if (option == 4)
	{
	    format(caption, sizeof(caption), "{"COLOR_AZUL"}Objeto %i[%i] -> Propiedades -> PosY", Mapeo[mapeoid][ID_Objeto], mapeoid);
		format(info, sizeof(info), "Ingrese una nueva coordenada Y para el objeto:");
	}
	else if (option == 5)
	{
	    format(caption, sizeof(caption), "{"COLOR_AZUL"}Objeto %i[%i] -> Propiedades -> PosZ", Mapeo[mapeoid][ID_Objeto], mapeoid);
		format(info, sizeof(info), "Ingrese una nueva coordenada Z para el objeto:");
	}
	else if (option == 6)
	{
	    format(caption, sizeof(caption), "{"COLOR_AZUL"}Objeto %i[%i] -> Propiedades -> RotX", Mapeo[mapeoid][ID_Objeto], mapeoid);
		format(info, sizeof(info), "Ingrese una nueva rotacion X para el objeto:");
	}
	else if (option == 7)
	{
	    format(caption, sizeof(caption), "{"COLOR_AZUL"}Objeto %i[%i] -> Propiedades -> RotY", Mapeo[mapeoid][ID_Objeto], mapeoid);
		format(info, sizeof(info), "Ingrese una nueva rotacion Y para el objeto:");
	}
	else if (option == 8)
	{
	    format(caption, sizeof(caption), "{"COLOR_AZUL"}Objeto %i[%i] -> Propiedades -> RotZ", Mapeo[mapeoid][ID_Objeto], mapeoid);
		format(info, sizeof(info), "Ingrese una nueva rotacion Z para el objeto:");
	}
	ShowPlayerDialogEx(playerid, 166, DIALOG_STYLE_INPUT, caption, info, "Aceptar", "Cancelar");
	return 1;
}

CambiarMapeoTipo(playerid, mapeoid, tipo)
{
	if (Mapeo[mapeoid][Tipo] == MAPEO_TYPE_PUERTA)
	{
	    BorrarPuerta(Mapeo[mapeoid][Tipoid]);
	}
	else if (Mapeo[mapeoid][Tipo] == MAPEO_TYPE_PEAJE)
	{
	    BorrarPeaje(Mapeo[mapeoid][Tipoid]);
	}
	else if (Mapeo[mapeoid][Tipo] == MAPEO_TYPE_PARQUEO)
	{
	    BorrarParqueo(Mapeo[mapeoid][Tipoid]);
	}
	if (Mapeo[mapeoid][Tipo] == tipo) return SendInfoMessage(playerid, 0, "", "Ese objeto ya es del mismo tipo");

    if (tipo == MAPEO_TYPE_OBJETO)
    {
        Mapeo[mapeoid][Tipo] = MAPEO_TYPE_OBJETO;
    }
	else if (tipo == MAPEO_TYPE_PUERTA)
	{
	    if(MAX_PUERTAS == MAX_PUERTAS_COUNT) return SendInfoMessage(playerid, 0, "", "Se Alcanzo el maximo de puertas");

		new puertaid = CrearPuerta(mapeoid);
		if (puertaid != -1)
		{
		    Mapeo[mapeoid][Tipo] = MAPEO_TYPE_PUERTA;
		    Mapeo[mapeoid][Tipoid] = puertaid;
		}
	}
	else if (tipo == MAPEO_TYPE_PEAJE)
	{
	    if (MAX_PEAJES == MAX_PEAJES_COUNT) return SendInfoMessage(playerid, 0, "", "Se Alcanzo el maximo de peajes");
	    
	    new peajeid = CrearPeaje(mapeoid);
	    if (peajeid != -1)
	    {
		    Mapeo[mapeoid][Tipo] = MAPEO_TYPE_PEAJE;
		    Mapeo[mapeoid][Tipoid] = peajeid;
	    }
	}
	else if (tipo == MAPEO_TYPE_PARQUEO)
	{
	    if (MAX_PARQUEOS == MAX_PARQUEOS_COUNT) return SendInfoMessage(playerid, 0, "", "Se Alcanzo el maximo de parqueos");
	    
	    new parqueoid = CrearParqueo(mapeoid);
	    if (parqueoid != -1)
	    {
		    Mapeo[mapeoid][Tipo] = MAPEO_TYPE_PARQUEO;
		    Mapeo[mapeoid][Tipoid] = parqueoid;
	    }
	}
	return 1;
}

BorrarPuerta(puertaid)
{
	Puerta[puertaid][ID_Mapeo] = -1;
    Puerta[puertaid][Creada] = false;
    Puerta[puertaid][PosX] = 0;
    Puerta[puertaid][Velocidad] = 0;
    Puerta[puertaid][Abierta] = false;
    Puerta[puertaid][LlaveTipo] = 0;
    Puerta[puertaid][LlaveOwnerID] = 0;
	SavePuerta(puertaid);
	return 1;
}

BorrarPeaje(peajeid)
{
	Peajes[peajeid][ID_Mapeo] = -1;
	Peajes[peajeid][Creado] = false;
	Peajes[peajeid][PosXFalse] = 0.0;
	Peajes[peajeid][PosCommandX] = 0.0;
	SavePeaje(peajeid);
	return 1;
}

BorrarParqueo(parqueoid)
{
	Parqueo[parqueoid][ID_Mapeo] = -1;
	Parqueo[parqueoid][Creado] = false;
	Parqueo[parqueoid][PosXFalse] = 0.0;
	SaveParqueo(parqueoid);
	return 1;
}

CrearPuerta(mapeoid)
{
    new puertaid = GetNextPuertaID();
    if (puertaid != -1)
    {
        Puerta[puertaid][ID_Mapeo] = mapeoid;
	    Puerta[puertaid][Creada] = true;
	    Puerta[puertaid][Velocidad] = 1.0;
	    Puerta[puertaid][Abierta] = false;
	    SavePuerta(puertaid);
	    return puertaid;
    }
    return -1;
}

CrearPeaje(mapeoid)
{
    new peajeid = GetNextPeajeID();
	if (peajeid != -1)
    {
        Peajes[peajeid][ID_Mapeo] = mapeoid;
		Peajes[peajeid][Creado] = true;
		Peajes[peajeid][PosXFalse] = 0.0;
		Peajes[peajeid][PosCommandX] = 0.0;
		Peajes[peajeid][Velocidad] = 0.2;
		SavePeaje(peajeid);
		return peajeid;
    }
	return -1;
}

CrearParqueo(mapeoid)
{
    new parqueoid = GetNextParqueoID();
	if (parqueoid != -1)
    {
        Parqueo[parqueoid][ID_Mapeo] = mapeoid;
        Parqueo[parqueoid][Creado] = true;
        Parqueo[parqueoid][PosXFalse] = 0.0;
        Parqueo[parqueoid][Velocidad] = 0.2;
        Parqueo[parqueoid][Abierto] = false;
        SaveParqueo(parqueoid);
		return parqueoid;
    }
	return -1;
}
	    
GetNextPuertaID()
{
	for(new i=0; i!=MAX_PUERTAS_COUNT; i++)
	{
	    if (!Puerta[i][Creada]) return i;
	}
	return -1;
}

GetNextPeajeID()
{
	for(new i=0; i!=MAX_PEAJES_COUNT; i++)
	{
	    if (!Peajes[i][Creado]) return i;
	}
	return -1;
}

GetNextParqueoID()
{
    for(new i=0; i!=MAX_PARQUEOS_COUNT; i++)
	{
	    if (!Parqueo[i][Creado]) return i;
	}
	return -1;
}

BorrarMapeo(playerid, mapeoid)
{
	new
		objectid = Mapeo[mapeoid][ID_Objeto],
		tipo = Mapeo[mapeoid][Tipo],
		tipoid = Mapeo[mapeoid][Tipoid];
	
	for(new i=0; i!=MAX_MATERIALINDEX; i++)
    {
        BorrarObjetoIndex(playerid, 1, i);
    }
    DestroyDynamicObject(objectid);
    
    Mapeo[mapeoid][Modelo] = 0;
    format(Mapeo[mapeoid][CreatedBy], MAX_PLAYER_NAME, "");
    Mapeo[mapeoid][Tipo] = 0;
    Mapeo[mapeoid][Tipoid] = 0;
    Mapeo[mapeoid][ID_Objeto] = 0;
    MAX_MAPEOS--;
    
	if (tipo == MAPEO_TYPE_PUERTA)
	{
	    BorrarPuerta(tipoid);
	}
	else if(tipo == MAPEO_TYPE_PEAJE)
	{
	    BorrarPeaje(tipoid);
	}
	else if(tipo == MAPEO_TYPE_PARQUEO)
	{
	    BorrarParqueo(tipoid);
	}
	SaveMapeo(mapeoid);
	
	if (playerid != -1)
	{
		new string[144];
		format(string, sizeof(string), "Borraste el mapeo ID %i, Objetoid %i", mapeoid, objectid);
		SendAdviseMessage(playerid, string);
		PlayersDataOnline[playerid][EditingType] = false;
		PlayersDataOnline[playerid][EditingObjectID] = 0;
	}
}

BorrarObjetoIndex(playerid, tipo, indexid)
{
    new objectid = PlayersDataOnline[playerid][EditingObjectID];
    
	if (tipo == EDITING_TYPE_MAPEO)//Mapeo
	{
		new mapeoid = PlayersDataOnline[playerid][EditingMapeo];
		
		Mapeo[mapeoid][materialtype][indexid] = 0;
		
	    Mapeo[mapeoid][texturemodel][indexid] = 0;
	    format(MapeoTxdName[mapeoid][indexid], 30, "");
	    format(MapeoTextureName[mapeoid][indexid], 30, "");
	    Mapeo[mapeoid][materialcolor][indexid] = 0;
	    format(MapeoText[mapeoid][indexid], 128, "");
	    Mapeo[mapeoid][materialsize][indexid] = 0;
	    format(MapeoFont[mapeoid][indexid], 40, "");
	    Mapeo[mapeoid][fontsize][indexid] = 0;
	    Mapeo[mapeoid][bold][indexid] = 0;
	    Mapeo[mapeoid][fontcolor][indexid] = 0;
	    Mapeo[mapeoid][backgroundcolor][indexid] = 0;
	    Mapeo[mapeoid][textalignment][indexid] = 0;
	}
	RemoveDynamicObjectMaterial(objectid, indexid);
	RemoveDynamicObjectMaterialText(objectid, indexid);
}

SaveParqueo(parqueoid)
{
    new query[1024], Cache:CACHE, rowExist;
	format(query, sizeof(query), "SELECT ID FROM %s WHERE ID=%d;", DIR_PARQUEOS_DB, parqueoid);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowExist);
	cache_delete(CACHE);

	if(Parqueo[parqueoid][Creado] && !rowExist){
		format(query, sizeof(query), "INSERT INTO %s (ID,mapeo_id) VALUES ('%d','%d');", DIR_PARQUEOS_DB, parqueoid, Parqueo[parqueoid][ID_Mapeo]);
		mysql_query(dataBase, query, false);
		rowExist = true;
	}

	if(rowExist){
		format(query, sizeof(query), "UPDATE %s SET `mapeo_id`='%d',`PosXFalse`='%f',`PosYFalse`='%f',`PosZFalse`='%f',\
			`PosRotXFalse`='%f',`PosRotYFalse`='%f',`PosRotZFalse`='%f',`Velocidad`='%f' WHERE ID=%d;", DIR_PARQUEOS_DB,
			Parqueo[parqueoid][ID_Mapeo],
			Parqueo[parqueoid][PosXFalse],
			Parqueo[parqueoid][PosYFalse],
			Parqueo[parqueoid][PosZFalse],

			Parqueo[parqueoid][PosRotXFalse],
			Parqueo[parqueoid][PosRotYFalse],
			Parqueo[parqueoid][PosRotZFalse],
			Parqueo[parqueoid][Velocidad],
			parqueoid);
		mysql_query(dataBase, query, false);
	}
	return 1;
}

function CerrarPeaje(peajeid)
{
	new mapeoid = Peajes[peajeid][ID_Mapeo];
	MoveDynamicObject(Mapeo[mapeoid][ID_Objeto], Mapeo[mapeoid][PosX], Mapeo[mapeoid][PosY], Mapeo[mapeoid][PosZ], Peajes[peajeid][Velocidad], Mapeo[mapeoid][PosRX], Mapeo[mapeoid][PosRY], Mapeo[mapeoid][PosRZ]);
	Peajes[peajeid][Abierto] = false;
	return 1;
}

function CerrarParqueo(parqueoid)
{
	new mapeoid = Parqueo[parqueoid][ID_Mapeo];
	MoveDynamicObject(Mapeo[mapeoid][ID_Objeto], Mapeo[mapeoid][PosX], Mapeo[mapeoid][PosY], Mapeo[mapeoid][PosZ], Parqueo[parqueoid][Velocidad], Mapeo[mapeoid][PosRX], Mapeo[mapeoid][PosRY], Mapeo[mapeoid][PosRZ]);
	Parqueo[parqueoid][Abierto] = false;
	return 1;
}