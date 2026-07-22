LoadHouse(houseid)
{
	HouseData[houseid][StationID] = -1;
	new query[100], Cache:cacheid, casaExiste, Cache:casaData, rowCount;
	format(query, 100, "SELECT * FROM `%s` WHERE ID=%i;", DIR_HOUSES, houseid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(casaExiste);

	if (casaExiste)
	{
		cache_get_value_name(0, "Dueno", HouseData[houseid][Dueno], MAX_PLAYER_NAME);
		cache_get_value_name_float(0, "Chaleco", HouseData[houseid][Chaleco]);
		cache_get_value_name_int(0, "Drogas", HouseData[houseid][Drogas]);
		cache_get_value_name_int(0, "Ganzuas", HouseData[houseid][Ganzuas]);
		cache_get_value_name_float(0, "PosX", HouseData[houseid][PosX]);
		cache_get_value_name_float(0, "PosY", HouseData[houseid][PosY]);
		cache_get_value_name_float(0, "PosZ", HouseData[houseid][PosZ]);
		cache_get_value_name_float(0, "PosZZ", HouseData[houseid][PosZZ]);
		cache_get_value_name_int(0, "Interior", HouseData[houseid][Interior]);
		cache_get_value_name_int(0, "TypeHouseId", HouseData[houseid][TypeHouseId]);
		cache_get_value_name_int(0, "PriceRent", HouseData[houseid][PriceRent]);
		cache_get_value_name_int(0, "Level", HouseData[houseid][Level]);
		cache_get_value_name_int(0, "Seguro", HouseData[houseid][Lock]);
		cache_get_value_name_int(0, "Price", HouseData[houseid][Price]);
		cache_get_value_name_int(0, "Bombas", HouseData[houseid][Bombas]);
		cache_get_value_name_int(0, "Deposito", HouseData[houseid][Deposito]);
		cache_get_value_name_int(0, "Materiales", HouseData[houseid][Materiales]);
		cache_get_value_name_int(0, "StationID", HouseData[houseid][StationID]);
		cache_get_value_name_int(0, "ArmarioLock", HouseData[houseid][ArmarioLock]);
		cache_get_value_name_int(0, "RefrigeradorLock", HouseData[houseid][RefrigeradorLock]);
		cache_get_value_name_int(0, "GavetaLock", HouseData[houseid][GavetaLock]);
		cache_get_value_name_int(0, "GavetaObjects0", HouseData[houseid][GavetaObjects][0]);
		cache_get_value_name_int(0, "GavetaObjects1", HouseData[houseid][GavetaObjects][1]);
		cache_get_value_name_int(0, "GavetaObjects2", HouseData[houseid][GavetaObjects][2]);
		cache_get_value_name_int(0, "GavetaObjects3", HouseData[houseid][GavetaObjects][3]);
		cache_get_value_name_int(0, "GavetaObjects4", HouseData[houseid][GavetaObjects][4]);
		cache_get_value_name_int(0, "GavetaObjects5", HouseData[houseid][GavetaObjects][5]);
		cache_get_value_name_int(0, "GavetaObjects6", HouseData[houseid][GavetaObjects][6]);
		cache_get_value_name_int(0, "GavetaObjects7", HouseData[houseid][GavetaObjects][7]);

		if(HouseData[houseid][PosX])
		{
			HouseData[houseid][World] = houseid;
			UpdateHouse(houseid);

			////////////////////////////////////Weapons
			mysql_format(dataBase, query, 100, "SELECT * FROM %s WHERE house_id=%d;", DIR_HOUSES_WEAPONS, houseid);
			casaData = mysql_query(dataBase, query);
			cache_get_row_count(rowCount);

			if(rowCount){
				if(rowCount > 7) rowCount = 7;
				for(new i; i!=rowCount; i++){
					cache_get_value_index_int(i, 3, HouseData[houseid][ArmarioWeapon][i]);
					cache_get_value_index_int(i, 4, HouseData[houseid][ArmarioAmmo][i]);
				}
			}
			else printf("[%s]: Error al cargar armas de la casa %d", DIR_HOUSES_WEAPONS, houseid);
			cache_delete(casaData);

			////////////////////////////////////Refrigerador
			mysql_format(dataBase, query, 100, "SELECT * FROM %s WHERE house_id=%d;", DIR_HOUSES_FRIDGE, houseid);
			casaData = mysql_query(dataBase, query);
			cache_get_row_count(rowCount);

			if(rowCount){
				if(rowCount > MAX_REFRIGERADOR_SLOTS_COUNT) rowCount = MAX_REFRIGERADOR_SLOTS_COUNT;
				for(new i; i!=rowCount; i++){
					cache_get_value_index_int(i, 3, Refrigerador[houseid][Articulo][i]);
					cache_get_value_index_int(i, 4, Refrigerador[houseid][Cantidad][i]);
				}
			}
			else printf("[%s]: Error al cargar refrigerador de la casa %d", DIR_HOUSES_FRIDGE, houseid);
			cache_delete(casaData);

			////////////////////////////////////Amigos
			mysql_format(dataBase, query, 100, "SELECT * FROM %s WHERE house_id=%d;", DIR_HOUSES_FRIENDS, houseid);
			casaData = mysql_query(dataBase, query);
			cache_get_row_count(rowCount);

			if(rowCount){
				if(rowCount > MAX_HOUSE_FRIENDS) rowCount = MAX_HOUSE_FRIENDS;
				for(new i; i!=rowCount; i++){
					cache_get_value_index(i, 3, HouseFriends[houseid][i][Name], MAX_PLAYER_NAME);
				}
			}
			else printf("[%s]: Error al cargar llaves amigos de la casa %d", DIR_HOUSES_FRIENDS, houseid);
			cache_delete(casaData);

			////////////////////////////////////Garages
			mysql_format(dataBase, query, 100, "SELECT * FROM %s WHERE house_id=%d;", DIR_HOUSES_GARAGES, houseid);
			casaData = mysql_query(dataBase, query);
			cache_get_row_count(rowCount);

			if(rowCount){
				if(rowCount > MAX_GARAGE_FOR_HOUSE) rowCount = MAX_GARAGE_FOR_HOUSE;
				for(new i; i!=rowCount; i++){
					cache_get_value_index_float(i, 3, Garages[houseid][i][Xg]);
					cache_get_value_index_float(i, 4, Garages[houseid][i][Yg]);
					cache_get_value_index_float(i, 5, Garages[houseid][i][Zg]);
					cache_get_value_index_float(i, 6, Garages[houseid][i][ZZg]);
					cache_get_value_index_float(i, 7, Garages[houseid][i][XgIn]);
					cache_get_value_index_float(i, 8, Garages[houseid][i][YgIn]);
					cache_get_value_index_float(i, 9, Garages[houseid][i][ZgIn]);
					cache_get_value_index_float(i, 10, Garages[houseid][i][ZZgIn]);
					cache_get_value_index_float(i, 11, Garages[houseid][i][XgOut]);
					cache_get_value_index_float(i, 12, Garages[houseid][i][YgOut]);
					cache_get_value_index_float(i, 13, Garages[houseid][i][ZgOut]);
					cache_get_value_index_float(i, 14, Garages[houseid][i][ZZgOut]);
					cache_get_value_index_int(i, 15, Garages[houseid][i][LockIn]);
					cache_get_value_index_int(i, 16, Garages[houseid][i][LockOut]);
					cache_get_value_index_int(i, 17, Garages[houseid][i][TypeGarageE]);
					cache_get_value_index_int(i, 18, Garages[houseid][i][WorldG]);
					if ( Garages[houseid][i][WorldG] )
					{
						UpdateGarageHouse(houseid, i);
						MAX_GARAGES++;
					}
				}
			}
			else printf("[%s]: Error al cargar garages de la casa %d", DIR_HOUSES_GARAGES, houseid);
			cache_delete(casaData);
			////////////////////////////////////
		}
		else casaExiste = false;
	}
	cache_delete(cacheid);
	return casaExiste;
}

SaveHouseAll(houseid)
{
	new i;
	new query[1000], Cache:cacheid, casaExiste, Cache:houseData, rowCount;
	mysql_format(dataBase, query, 100, "SELECT `ID` FROM `%s` WHERE `ID`='%i';", DIR_HOUSES, houseid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(casaExiste);
	cache_delete(cacheid);

	if (!casaExiste && HouseData[houseid][PosX])
	{
		format(query, 100, "INSERT INTO `%s` (`ID`) VALUES ('%i');", DIR_HOUSES, houseid);
		mysql_query(dataBase, query, false);
		casaExiste = true;
	}
	if(casaExiste){
		format(query, 100, "UPDATE `%s` SET ", DIR_HOUSES);
		strcat(query, "`Dueno`='%e',`Chaleco`='%f',`Drogas`='%i',`Ganzuas`='%i',`PosX`='%f',`PosY`='%f',`PosZ`='%f',`PosZZ`='%f',`Interior`='%i',`TypeHouseId`='%i',");
		strcat(query, "`PriceRent`='%i',`Level`='%i',`Seguro`='%i',`Price`='%i',`Bombas`='%i',`Deposito`='%i',`Materiales`='%i',`ArmarioLock`='%i'");
		strcat(query, " WHERE `ID`='%i';");
		mysql_format(dataBase, query, 1000, query,
			HouseData[houseid][Dueno],
			HouseData[houseid][Chaleco],
			HouseData[houseid][Drogas],
			HouseData[houseid][Ganzuas],
			HouseData[houseid][PosX],
			HouseData[houseid][PosY],
			HouseData[houseid][PosZ],
			HouseData[houseid][PosZZ],
			HouseData[houseid][Interior],
			HouseData[houseid][TypeHouseId],

			HouseData[houseid][PriceRent],
			HouseData[houseid][Level],
			HouseData[houseid][Lock],
			HouseData[houseid][Price],
			HouseData[houseid][Bombas],
			HouseData[houseid][Deposito],
			HouseData[houseid][Materiales],
			HouseData[houseid][ArmarioLock],

			houseid);
		mysql_query(dataBase, query, false);

		format(query, 100, "UPDATE `%s` SET ", DIR_HOUSES);
		strcat(query, "`RefrigeradorLock`='%i',`StationID`='%i',");
		strcat(query, "`GavetaLock`='%i',`GavetaObjects0`='%i',`GavetaObjects1`='%i',`GavetaObjects2`='%i',`GavetaObjects3`='%i',");
		strcat(query, "`GavetaObjects4`='%i',`GavetaObjects5`='%i',`GavetaObjects6`='%i',`GavetaObjects7`='%i'");
		strcat(query, " WHERE `ID`='%i';");
		mysql_format(dataBase, query, 1000, query,

			HouseData[houseid][RefrigeradorLock],
			HouseData[houseid][StationID],
			HouseData[houseid][GavetaLock],
			HouseData[houseid][GavetaObjects][0],
			HouseData[houseid][GavetaObjects][1],
			HouseData[houseid][GavetaObjects][2],
			HouseData[houseid][GavetaObjects][3],

			HouseData[houseid][GavetaObjects][4],
			HouseData[houseid][GavetaObjects][5],
			HouseData[houseid][GavetaObjects][6],
			HouseData[houseid][GavetaObjects][7],

			houseid);
		mysql_query(dataBase, query, false);

		////////////////////////////////////Weapons
		mysql_format(dataBase, query, 100, "SELECT ID FROM %s WHERE house_id=%d;", DIR_HOUSES_WEAPONS, houseid);
		houseData = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(houseData);

		if(rowCount < 7){
			i = (!rowCount) ? (0) : (rowCount);
			mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s (house_id,slot_id,weapon,ammo) VALUES ", DIR_HOUSES_WEAPONS);
			for(; i!=7; i++){
				if(i == 6)
				mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,%d,%d)", query, houseid, i, HouseData[houseid][ArmarioWeapon][i], HouseData[houseid][ArmarioAmmo][i]);
				else
				mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,%d,%d),", query, houseid, i, HouseData[houseid][ArmarioWeapon][i], HouseData[houseid][ArmarioAmmo][i]);
			}
			mysql_query(dataBase, query, false);
		}
		else{
			for(i = 0; i!=7; i++){
				mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
					weapon=%d,ammo=%d WHERE house_id=%d AND slot_id=%d;", DIR_HOUSES_WEAPONS, HouseData[houseid][ArmarioWeapon][i], HouseData[houseid][ArmarioAmmo][i], houseid, i);
				mysql_query(dataBase, query, false);
			}
		}

		////////////////////////////////////Refrigerador
		mysql_format(dataBase, query, 100, "SELECT ID FROM %s WHERE house_id=%d;", DIR_HOUSES_FRIDGE, houseid);
		houseData = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(houseData);

		if(rowCount < MAX_REFRIGERADOR_SLOTS_COUNT){
			i = (!rowCount) ? (0) : (rowCount);
			const limit = MAX_REFRIGERADOR_SLOTS_COUNT - 1;
			mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s (house_id,slot_id,article,amount) VALUES ", DIR_HOUSES_FRIDGE);
			for(; i!=MAX_REFRIGERADOR_SLOTS_COUNT; i++){
				if(i == limit)
				mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,%d,%d)", query, houseid, i, Refrigerador[houseid][Articulo][i], Refrigerador[houseid][Cantidad][i]);
				else
				mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,%d,%d),", query, houseid, i, Refrigerador[houseid][Articulo][i], Refrigerador[houseid][Cantidad][i]);
			}
			mysql_query(dataBase, query, false);
		}
		else{
			for(i = 0; i!=MAX_REFRIGERADOR_SLOTS_COUNT; i++){
				mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
					article=%d,amount=%d WHERE house_id=%d AND slot_id=%d;", DIR_HOUSES_FRIDGE, Refrigerador[houseid][Articulo][i], Refrigerador[houseid][Cantidad][i], houseid, i);
				mysql_query(dataBase, query, false);
			}
		}

		////////////////////////////////////Amigos
		mysql_format(dataBase, query, 100, "SELECT ID FROM %s WHERE house_id=%d;", DIR_HOUSES_FRIENDS, houseid);
		houseData = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(houseData);

		if(rowCount < MAX_HOUSE_FRIENDS){
			i = (!rowCount) ? (0) : (rowCount);
			const limit = MAX_HOUSE_FRIENDS - 1;
			mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s (house_id,friend_slot,friend) VALUES ", DIR_HOUSES_FRIENDS);
			for(; i!=MAX_HOUSE_FRIENDS; i++){
				if(i == limit)
				mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,'%e')", query, houseid, i, HouseFriends[houseid][i][Name]);
				else
				mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,'%e'),", query, houseid, i, HouseFriends[houseid][i][Name]);
			}
			mysql_query(dataBase, query, false);
		}
		else{
			for(i = 0; i!=MAX_HOUSE_FRIENDS; i++){
				mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
					friend='%e' WHERE house_id=%d AND friend_slot=%d;", DIR_HOUSES_FRIENDS, HouseFriends[houseid][i][Name], houseid, i);
				mysql_query(dataBase, query, false);
			}
		}

		////////////////////////////////////Garages
		mysql_format(dataBase, query, 100, "SELECT ID FROM %s WHERE house_id=%d;", DIR_HOUSES_GARAGES, houseid);
		houseData = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(houseData);

		if(rowCount < MAX_GARAGE_FOR_HOUSE){
			i = (!rowCount) ? (0) : (rowCount);
			for(; i!=MAX_GARAGE_FOR_HOUSE; i++){
				mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s \
					(house_id,garage_id,Xg,Yg,Zg,ZZg,XgIn,YgIn,ZgIn,ZZgIn,XgOut,YgOut,ZgOut,ZZgOut,LockIn,LockOut,TypeGarageE,World) VALUES \
					(%d,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%i,%i,%i,%i);", DIR_HOUSES_GARAGES,
					houseid, i, 
					Garages[houseid][i][Xg],
					Garages[houseid][i][Yg],
					Garages[houseid][i][Zg],
					Garages[houseid][i][ZZg],
					Garages[houseid][i][XgIn],
					Garages[houseid][i][YgIn],
					Garages[houseid][i][ZgIn],
					Garages[houseid][i][ZZgIn],
					Garages[houseid][i][XgOut],
					Garages[houseid][i][YgOut],
					Garages[houseid][i][ZgOut],
					Garages[houseid][i][ZZgOut],
					Garages[houseid][i][LockIn],
					Garages[houseid][i][LockOut],
					Garages[houseid][i][TypeGarageE],
					Garages[houseid][i][WorldG]);
				mysql_query(dataBase, query, false);
			}
		}
		else{
			for(i = 0; i!=MAX_GARAGE_FOR_HOUSE; i++){
				mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
					Xg=%f,Yg=%f,Zg=%f,ZZg=%f,\
					XgIn=%f,YgIn=%f,ZgIn=%f,ZZgIn=%f,\
					XgOut=%f,YgOut=%f,ZgOut=%f,ZZgOut=%f,\
					LockIn=%i,LockOut=%i,TypeGarageE=%i,World=%i \
					WHERE house_id=%d AND garage_id=%d;", DIR_HOUSES_GARAGES, 
					Garages[houseid][i][Xg],
					Garages[houseid][i][Yg],
					Garages[houseid][i][Zg],
					Garages[houseid][i][ZZg],

					Garages[houseid][i][XgIn],
					Garages[houseid][i][YgIn],
					Garages[houseid][i][ZgIn],
					Garages[houseid][i][ZZgIn],

					Garages[houseid][i][XgOut],
					Garages[houseid][i][YgOut],
					Garages[houseid][i][ZgOut],
					Garages[houseid][i][ZZgOut],

					Garages[houseid][i][LockIn],
					Garages[houseid][i][LockOut],
					Garages[houseid][i][TypeGarageE],
					Garages[houseid][i][WorldG],
					houseid, i);
				mysql_query(dataBase, query, false);
			}
		}
	}
}

SaveHouse(houseid)
{
	new query[1000], Cache:cacheid, rowCount;
	mysql_format(dataBase, query, 100, "SELECT `ID` FROM `%s` WHERE `ID`='%i';", DIR_HOUSES, houseid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(rowCount);
	cache_delete(cacheid);

	if (!rowCount && HouseData[houseid][PosX])
	{
		SaveHouseAll(houseid);
		return 2;
	}
	if(rowCount){
		format(query, 100, "UPDATE `%s` SET ", DIR_HOUSES);
		strcat(query, "`Dueno`='%e',`Chaleco`='%f',`Drogas`='%i',`Ganzuas`='%i',`PosX`='%f',`PosY`='%f',`PosZ`='%f',`PosZZ`='%f',`Interior`='%i',`TypeHouseId`='%i',");
		strcat(query, "`PriceRent`='%i',`Level`='%i',`Seguro`='%i',`Price`='%i',`Bombas`='%i',`Deposito`='%i',`Materiales`='%i',`ArmarioLock`='%i',");
		strcat(query, "`RefrigeradorLock`='%i',`StationID`='%i'");
		strcat(query, " WHERE `ID`='%i';");
		mysql_format(dataBase, query, 1000, query,
			HouseData[houseid][Dueno],
			HouseData[houseid][Chaleco],
			HouseData[houseid][Drogas],
			HouseData[houseid][Ganzuas],
			HouseData[houseid][PosX],
			HouseData[houseid][PosY],
			HouseData[houseid][PosZ],
			HouseData[houseid][PosZZ],
			HouseData[houseid][Interior],
			HouseData[houseid][TypeHouseId],

			HouseData[houseid][PriceRent],
			HouseData[houseid][Level],
			HouseData[houseid][Lock],
			HouseData[houseid][Price],
			HouseData[houseid][Bombas],
			HouseData[houseid][Deposito],
			HouseData[houseid][Materiales],
			HouseData[houseid][ArmarioLock],

			HouseData[houseid][RefrigeradorLock],
			HouseData[houseid][StationID], 
			houseid);
		mysql_query(dataBase, query, false);
	}
	return 1;
}

SaveHouseGaveta(houseid)
{
	new query[1000], Cache:cacheid, rowCount;
	mysql_format(dataBase, query, 100, "SELECT `ID` FROM `%s` WHERE `ID`='%i';", DIR_HOUSES, houseid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(rowCount);
	cache_delete(cacheid);

	if (!rowCount && HouseData[houseid][PosX])
	{
		SaveHouseAll(houseid);
		return 2;
	}
	if(rowCount){
		format(query, 100, "UPDATE `%s` SET ", DIR_HOUSES);
		strcat(query, "`GavetaLock`='%i',`GavetaObjects0`='%i',`GavetaObjects1`='%i',`GavetaObjects2`='%i',`GavetaObjects3`='%i',");
		strcat(query, "`GavetaObjects4`='%i',`GavetaObjects5`='%i',`GavetaObjects6`='%i',`GavetaObjects7`='%i'");
		strcat(query, " WHERE `ID`='%i';");
		mysql_format(dataBase, query, 1000, query,
			HouseData[houseid][GavetaLock],
			HouseData[houseid][GavetaObjects][0],
			HouseData[houseid][GavetaObjects][1],
			HouseData[houseid][GavetaObjects][2],
			HouseData[houseid][GavetaObjects][3],

			HouseData[houseid][GavetaObjects][4],
			HouseData[houseid][GavetaObjects][5],
			HouseData[houseid][GavetaObjects][6],
			HouseData[houseid][GavetaObjects][7],

			houseid);
		mysql_query(dataBase, query, false);
	}
	return 1;
}

SaveHouseWeaponEx(houseid, slotid)
{
	new query[1000], Cache:cacheid, rowCount;
	mysql_format(dataBase, query, 100, "SELECT `ID` FROM `%s` WHERE `ID`='%i';", DIR_HOUSES, houseid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(rowCount);
	cache_delete(cacheid);

	if (!rowCount && HouseData[houseid][PosX])
	{
		SaveHouseAll(houseid);
		return 2;
	}
	if(rowCount){
		////////////////////////////////////Weapons
		mysql_format(dataBase, query, 100, "SELECT ID FROM %s WHERE house_id=%d;", DIR_HOUSES_WEAPONS, houseid);
		cacheid = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(cacheid);

		if(rowCount < 7){
			new i = (!rowCount) ? (0) : (rowCount);
			mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s (house_id,slot_id,weapon,ammo) VALUES ", DIR_HOUSES_WEAPONS);
			for(; i!=7; i++){
				if(i == 6)
				mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,%d,%d)", query, houseid, i, HouseData[houseid][ArmarioWeapon][i], HouseData[houseid][ArmarioAmmo][i]);
				else
				mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,%d,%d),", query, houseid, i, HouseData[houseid][ArmarioWeapon][i], HouseData[houseid][ArmarioAmmo][i]);
			}
			mysql_query(dataBase, query, false);
		}
		else{
			mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
				weapon=%d,ammo=%d WHERE house_id=%d AND slot_id=%d;", DIR_HOUSES_WEAPONS, HouseData[houseid][ArmarioWeapon][slotid], HouseData[houseid][ArmarioAmmo][slotid], houseid, slotid);
			mysql_query(dataBase, query, false);
		}
	}
	return 1;
}

SaveHouseFriendEx(houseid, slotid)
{
	new query[1000], Cache:cacheid, rowCount;
	mysql_format(dataBase, query, 100, "SELECT `ID` FROM `%s` WHERE `ID`='%i';", DIR_HOUSES, houseid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(rowCount);
	cache_delete(cacheid);

	if (!rowCount && HouseData[houseid][PosX])
	{
		SaveHouseAll(houseid);
		return 2;
	}
	if(rowCount){
		////////////////////////////////////Amigos
		mysql_format(dataBase, query, 100, "SELECT ID FROM %s WHERE house_id=%d;", DIR_HOUSES_FRIENDS, houseid);
		cacheid = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(cacheid);

		if(rowCount < MAX_HOUSE_FRIENDS){
			new i = (!rowCount) ? (0) : (rowCount);
			const limit = MAX_HOUSE_FRIENDS - 1;
			mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s (house_id,friend_slot,friend) VALUES ", DIR_HOUSES_FRIENDS);
			for(; i!=MAX_HOUSE_FRIENDS; i++){
				if(i == limit)
				mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,'%e')", query, houseid, i, HouseFriends[houseid][i][Name]);
				else
				mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,'%e'),", query, houseid, i, HouseFriends[houseid][i][Name]);
			}
			mysql_query(dataBase, query, false);
		}
		else{
			mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
				friend='%e' WHERE house_id=%d AND friend_slot=%d;", DIR_HOUSES_FRIENDS, HouseFriends[houseid][slotid][Name], houseid, slotid);
			mysql_query(dataBase, query, false);
		}
	}
	return 1;
}


LoadTypeHouse()
{
	// 0 ///////////////////////////////////////////////////////////////////////// Typo: Cuatro Cuartos
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Cuatro Cuartos");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 2365.3381;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = -1135.3933;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1050.8750;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 1.2460;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 8;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 1 ///////////////////////////////////////////////////////////////////////// Typo: Un Cuarto
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Un Cuarto");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 2308.7741699219;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = -1212.9265136719;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1049.0234375;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 2.8829;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 6;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 2 ///////////////////////////////////////////////////////////////////////// Typo: Bungalows Clase I
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Bungalows Clase I");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 2468.6477;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = -1698.2053;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1013.5078;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 91.2169;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 2;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 3 ///////////////////////////////////////////////////////////////////////// Typo: Bungalows Clase I
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Bungalows Clase I");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 2524.0813;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = -1679.4822;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1015.4986;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 268.9842;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 1;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 4 ///////////////////////////////////////////////////////////////////////// Typo: Estudio
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Estudio");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 266.7592;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 305.0596;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 999.1484;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 270.5936;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 2;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 5 ///////////////////////////////////////////////////////////////////////// Typo: Trailer
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Trailer");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 2.0276;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = -3.0860;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 999.4284;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 83.7629;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 2;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 6 ///////////////////////////////////////////////////////////////////////// Typo: Tres Cuartos
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Tres Cuartos");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 2233.7747;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = -1115.0977;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1050.8828;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 355.3266;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 5;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 7 ///////////////////////////////////////////////////////////////////////// Typo: Dos Cuartos
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Dos Cuartos");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 2259.5925;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = -1136.0444;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1050.6328;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 271.6231;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 10;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 8 ///////////////////////////////////////////////////////////////////////// Typo: Chalet
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Chalet");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 235.3826;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1186.8677;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1080.2578;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 358.2490;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 3;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 9 ///////////////////////////////////////////////////////////////////////// Typo: Bungalows Clase II
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Bungalows Clase II");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 226.1616;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1239.9657;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1082.1406;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 87.6160;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 2;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 10 ///////////////////////////////////////////////////////////////////////// Typo: Un Cuarto
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Un Cuarto");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 223.2299;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1287.2865;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1082.1406;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 2.1973;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 1;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 11 ///////////////////////////////////////////////////////////////////////// Typo: Finca
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Finca");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 226.6335;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1114.3988;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1080.9946;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 270.7229;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 5;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 12 ///////////////////////////////////////////////////////////////////////// Typo: Cuatro Cuartos
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Cuatro Cuartos");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 295.1449;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1472.2834;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1080.2578;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 1.6496;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 15;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);


	// 13 ///////////////////////////////////////////////////////////////////////// Typo: Bungalows Clase III
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Bungalows Clase III");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 446.9776;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1397.3701;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1084.3047;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 359.0408;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 2;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 14 ///////////////////////////////////////////////////////////////////////// Typo: Bungalows Clase II
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Bungalows Clase II");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 261.1623;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1284.5057;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1080.2578;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 359.4435;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 4;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 15 ///////////////////////////////////////////////////////////////////////// Typo: Bungalows Clase III
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Bungalows Clase III");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 24.1222;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1340.2295;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1084.3750;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 4.1435;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 10;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 16 ///////////////////////////////////////////////////////////////////////// Typo: Bungalows Clase I
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Bungalows Clase I");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 221.8144;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1140.5055;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1082.6094;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 5.8735;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 4;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);


	// 17 ///////////////////////////////////////////////////////////////////////// Typo: Un Cuarto
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Un Cuarto");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 446.71649169922;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 506.32403564453;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1001.4194946289;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 271.9994;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 12;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 18 ///////////////////////////////////////////////////////////////////////// Typo: Chalet
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Chalet");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = -260.6692;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1456.6316;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1084.3672;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 91.0199;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 4;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 19 ///////////////////////////////////////////////////////////////////////// Typo: Bungalows Clase III
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Bungalows Clase III");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 22.8068;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1403.4597;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1084.4370;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 355.7854;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 5;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 20 ///////////////////////////////////////////////////////////////////////// Typo: Mansion
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Mansion");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 140.5783;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1366.0577;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1083.8594;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 0.5053;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 5;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 21 ///////////////////////////////////////////////////////////////////////// Typo: Mansion
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Mansion");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 234.1057;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1063.8470;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1084.2120;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 355.3038;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 6;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 22 ///////////////////////////////////////////////////////////////////////// Typo: Bungalows Clase II
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Bungalows Clase II");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = -68.7345;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1351.7261;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1080.2109;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 356.4911;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 6;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 23 ///////////////////////////////////////////////////////////////////////// Typo: Finca
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Finca");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = -283.5833;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1471.1552;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1084.3750;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 89.1725;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 15;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 24 ///////////////////////////////////////////////////////////////////////// Typo: Tres Cuartos
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Tres Cuartos");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 2218.2312;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = -1076.3168;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1050.4844;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 90.4850;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 1;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 25 ///////////////////////////////////////////////////////////////////////// Typo: Bungalows Clase II
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Bungalows Clase II");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 2237.5933;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = -1081.4789;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1049.0234;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 1.4616;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 2;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 26 ///////////////////////////////////////////////////////////////////////// Typo: Cuatro Cuartos
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Cuatro Cuartos");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = -42.6557;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1412.5956;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1084.4297;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 178.7076;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 8;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 27 ///////////////////////////////////////////////////////////////////////// Typo: Finca
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Finca");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 83.1146;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1322.4788;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1083.8662;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 1.0887;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 9;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);

	// 28 ///////////////////////////////////////////////////////////////////////// Typo: Bungalows Clase II
	MAX_HOUSE_TYPE++;
	format(TypeHouse[MAX_HOUSE_TYPE][TypeName], MAX_PLAYER_NAME, "Bungalows Clase II");
	TypeHouse[MAX_HOUSE_TYPE][PosX]    = 260.8197;
	TypeHouse[MAX_HOUSE_TYPE][PosY]    = 1237.4691;
	TypeHouse[MAX_HOUSE_TYPE][PosZ]    = 1084.2578;
	TypeHouse[MAX_HOUSE_TYPE][PosZZ]    = 3.2391;
	TypeHouse[MAX_HOUSE_TYPE][Interior] = 9;
	TypeHouse[MAX_HOUSE_TYPE][PickupId] = CreateCasaTipoDynamicPickup(MAX_HOUSE_TYPE, TypeHouse[MAX_HOUSE_TYPE][PosX], TypeHouse[MAX_HOUSE_TYPE][PosY], TypeHouse[MAX_HOUSE_TYPE][PosZ], -1);
}

GetMyNextHouse()
{
	for (new i = 1; i < MAX_HOUSE_COUNT; i++)
	{
	    if(!HouseData[i][PosX]) return i;
	}
	return false;
}

UpdateHouse(houseid)
{
	if(!HouseData[houseid][PosX]) return false;
	new TextLabelText[300];

	new pickupModel = PICKUP_MODEL_CASA_FOR_SALE;
	if ( strlen(HouseData[houseid][Dueno]) != 2 )
	{
		format(TextLabelText, sizeof(TextLabelText),
			"Lugar: {"COLOR_CREMA"}Casa PC-%i\n\
			{"COLOR_VERDE"}Tipo: {"COLOR_CREMA"}%s\n\
			{"COLOR_VERDE"}Garage: {"COLOR_CREMA"}%s",

			houseid,
			TypeHouse[HouseData[houseid][TypeHouseId]][TypeName],
			SiOrNo[ExistGarageInHouse(houseid)]
		);

		pickupModel = PICKUP_MODEL_CASA_SOLD;
		if ( HouseData[houseid][PriceRent] != 0 )
		{
			format(TextLabelText, sizeof(TextLabelText), "%s\n{"COLOR_VERDE"}Renta: {"COLOR_CREMA"}$%i", TextLabelText, HouseData[houseid][PriceRent]);

			pickupModel = PICKUP_MODEL_CASA_RENT;
		}
	}
	else
	{
		format(TextLabelText, sizeof(TextLabelText),
			"Lugar: {"COLOR_CREMA"}Casa PC-%i\n\
			{"COLOR_VERDE"}Tipo: {"COLOR_CREMA"}%s\n\
			{"COLOR_VERDE"}Garage: {"COLOR_CREMA"}%s\n\
			{"COLOR_VERDE"}Precio: {"COLOR_CREMA"}$%i\n\
			{"COLOR_VERDE"}Use: {"COLOR_ROJO"}/Comprar Casa",
			houseid,
	        TypeHouse[HouseData[houseid][TypeHouseId]][TypeName],
	        SiOrNo[ExistGarageInHouse(houseid)],
			HouseData[houseid][Price]
		);
	}
	if ( IsValidDynamic3DTextLabel(HouseData[houseid][TextLabel])) DestroyDynamic3DTextLabel(HouseData[houseid][TextLabel]);
	HouseData[houseid][TextLabel] = CreateDynamic3DTextLabel(TextLabelText, 0x00A5FFFF, HouseData[houseid][PosX], HouseData[houseid][PosY], HouseData[houseid][PosZ],
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, WORLD_NORMAL, 0);

	if(IsValidDynamicPickup(HouseData[houseid][PickupId])) DestroyDynamicPickup(HouseData[houseid][PickupId]);
	HouseData[houseid][PickupId] = CreateCasaDynamicPickup(houseid, pickupModel, HouseData[houseid][PosX], HouseData[houseid][PosY], HouseData[houseid][PosZ]);
	return true;
}

CreateCasaDynamicPickup(houseid, modelid, Float:X, Float:Y, Float:Z){
	new pickupid = CreateDynamicPickup(modelid, 1, X, Y, Z, WORLD_NORMAL, 0, -1, MAX_HOUSE_PICKUP_DISTANCE);
	PickupIndex[pickupid][Tipo] = PICKUP_TYPE_CASA;
	PickupIndex[pickupid][Tipoid] = houseid;
	return pickupid;
}

IsMyHouse(playerid, houseid)
{
	if( PlayersData[playerid][House] == houseid ) return true;
	if( strfind(HouseData[houseid][Dueno], PlayersDataOnline[playerid][NameOnline], true) == 0 && strlen(HouseData[houseid][Dueno]) == strlen(PlayersDataOnline[playerid][NameOnline]) )
	{
	    return true;
    }
    else
    {
		return false;
	}
}

IsOpenCloset(playerid, houseid)
{
	if ( !HouseData[houseid][ArmarioLock] )
	{
	    return true;
	}
	else
	{
		Error(playerid, "El armario se encuentra cerrado!");
	    return false;
	}
}

IsOpenGaveta(playerid, houseid)
{
	if ( !HouseData[houseid][GavetaLock] )
	{
	    return true;
	}
	else
	{
		Error(playerid, "La gaveta se encuentra cerrada!");
	    return false;
	}
}

CheckIsPlayerRentAndRemove(playerid, houseid)
{
	if ( IsPlayerLogued(playerid) )
	{
		if ( PlayersData[playerid][Alquiler] == houseid && strlen(HouseData[houseid][Dueno]) == 2 || PlayersData[playerid][Alquiler] == houseid && !HouseData[houseid][PriceRent])
		{
			PlayersData[playerid][Alquiler] = -1;
			PlayersData[playerid][House] 	= -1;
			DataUserSave(playerid);
			Importante(playerid, "Ha sido desalojado de su alquiler");
		}
	}
}

GetHouseidIdByWorld(world)
{
    for( new h=1; h < MAX_HOUSE_COUNT;h++ )
    {
		if(!HouseData[h][PosX]) continue;
		for ( new i; i < MAX_GARAGE_FOR_HOUSE; i++ )
		{
	        if ( Garages[h][i][PickupidIn] && Garages[h][i][WorldG] == world )
			{
			    return h;
	        }
        }
	}
	return false;
}
//Musica
PlayAudioPlayerHouse(playerid)
{
	if (HouseData[PlayersData[playerid][IsPlayerInHouse]][StationID] != -1)
	{
	    PlayAudioStreamForPlayer(playerid, Stations[ HouseData[PlayersData[playerid][IsPlayerInHouse]][StationID] ][1]);
	}
}
ChangeMusicOnHouse(houseid)
{
	for ( new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && PlayersData[i][IsPlayerInHouse] == houseid )
		{
			PlayAudioPlayerHouse(i);
		}
	}
}
StopMusicOnHouse(houseid)
{
	for ( new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && PlayersData[i][IsPlayerInHouse] == houseid )
		{
		    StopAudioStreamForPlayer(i);
		}
	}
}
ChangeHouseOrOther(playerid, newhouse)
{
	if ( PlayersData[playerid][IsPlayerInHouse] )
	{
		StopAudioStreamForPlayer(playerid);
	}
	PlayersData[playerid][IsPlayerInHouse] = newhouse;
	if ( newhouse )
	{
		PlayAudioPlayerHouse(playerid);
	}
}
OnPlayerEnterInHouse(playerid)
{
	PlayAudioPlayerHouse(playerid);
}
OnPlayerExitHouse(playerid)
{
    StopAudioStreamForPlayer(playerid);
}
//MusicaEnd
RemoveDuenoOfHouse(houseid)
{
	for( new i,j=GetPlayerPoolSize(); i <= j; i++ )
	{
		if( !IsPlayerLogued(i) ) continue;
		if( PlayersData[i][House] == houseid )
		{
			PlayersData[i][House] = -1;
			PlayersData[i][Alquiler] = -1;
			continue;
		}
		if( PlayersData[i][Alquiler] == houseid )
		{
			PlayersData[i][Alquiler] = -1;
			PlayersData[i][House] 	= -1;
			Importante(i, "Ha sido desalojado de su alquiler!");
		}
	}
	new query[150];
	mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET House=-1,Alquiler=-1 WHERE House=%d OR Alquiler=%d;", DIR_USERS, houseid, houseid);
	mysql_query(dataBase, query, false);

    format(HouseData[houseid][Dueno], MAX_PLAYER_NAME, "No");
    HouseData[houseid][Lock] = true;
    SaveHouse(houseid); UpdateHouse(houseid);

	for( new i; i < MAX_HOUSE_FRIENDS; i++ )
	{
		format(HouseFriends[houseid][i][Name], MAX_PLAYER_NAME, "No");
		SaveHouseFriendEx(houseid, i);
	}
}
ClearHouseData(h){
	format(HouseData[h][Dueno], MAX_PLAYER_NAME, "No");
	HouseData[h][Chaleco] = 0;
	HouseData[h][Drogas] = 0;
	HouseData[h][Ganzuas] = 0;
	HouseData[h][Bombas] = 0;
	HouseData[h][PosX] = 0;
	HouseData[h][PosY] = 0;
	HouseData[h][PosZ] = 0;
	HouseData[h][PosZZ] = 0;
	HouseData[h][Interior] = 0;
	HouseData[h][TypeHouseId] = 0;
	DestroyDynamicPickup(HouseData[h][PickupId]); HouseData[h][PickupId] = 0;
	DestroyDynamic3DTextLabel(HouseData[h][TextLabel]); HouseData[h][TextLabel] = INVALID_3DTEXT_ID;
	HouseData[h][PriceRent] = 0;
	HouseData[h][Level] = 0;
	HouseData[h][World] = 0;
	HouseData[h][Lock] = 1;
	HouseData[h][Price] = 0;
	HouseData[h][Deposito] = 0;
	HouseData[h][Materiales] = 0;
	HouseData[h][ArmarioLock] = 0;
	HouseData[h][RefrigeradorLock] = 1;
	HouseData[h][RingHouseTime] = 0;
	HouseData[h][StationID] = -1;
	HouseData[h][GavetaLock] = true;
	for(new i=0; i != MAX_REFRIGERADOR_SLOTS_COUNT; i++)
	{
		Refrigerador[h][Articulo][i] = 0;
		Refrigerador[h][Cantidad][i] = 0;
	}
	for(new i; i!=MAX_GUANTERA_GAVETA_SLOTS; i++){
		HouseData[h][GavetaObjects] = 0;
	}
	for(new i; i!=7; i++){
		HouseData[h][ArmarioWeapon] = 0;
		HouseData[h][ArmarioAmmo] = 0;
	}
	for (new i = 0; i < MAX_HOUSE_FRIENDS; i++){
		format(HouseFriends[h][i][Name], MAX_PLAYER_NAME, "No");
	}
	RemoveAllGarage(h);
	SaveHouseAll(h);
}
//Llaves Amigos
ShowHouseFriends(playerid, houseid)
{
	new HouseFriendsDialog[700];
	for (new i = 0; i < MAX_HOUSE_FRIENDS; i++)
	{
		if ( strlen(HouseFriends[houseid][i][Name]) > 2 )
		{
			format(HouseFriendsDialog, sizeof(HouseFriendsDialog), "%s{"COLOR_VERDE"}Llave %i:\t{"COLOR_AZUL"}%s\n", HouseFriendsDialog, i + 1, HouseFriends[houseid][i][Name]);
		}
		else
		{
			format(HouseFriendsDialog, sizeof(HouseFriendsDialog), "%s{"COLOR_VERDE"}Llave %i:\t{"COLOR_ROJO"}Nadie\n", HouseFriendsDialog, i + 1);
		}
	}
	ShowPlayerDialogEx(playerid, 70, DIALOG_STYLE_TABLIST, "{"COLOR_AZUL"}Casa - Llaves de los Amigos", HouseFriendsDialog, "Quitar", "Salir");
    PlayersDataOnline[playerid][SaveAfterAgenda][0] = houseid;
}
IsPlayerInHouseFriend(playerid, houseid)
{
	for ( new i = 0;i < MAX_HOUSE_FRIENDS; i++)
	{
		if ( strfind(HouseFriends[houseid][i][Name], PlayersDataOnline[playerid][NameOnline], false) == 0 && strlen(HouseFriends[houseid][i][Name]) == strlen(PlayersDataOnline[playerid][NameOnline]) )
		{
		    return i;
		}
	}
	return -1;
}
RemoveAllHouseFriend(houseid)
{
	for ( new i = 0;i < MAX_HOUSE_FRIENDS; i++)
	{
		RemovePlayerHouseFriend(houseid, i);
	}
}
RemovePlayerHouseFriend(houseid, housefriendid)
{
	if ( strlen(HouseFriends[houseid][housefriendid][Name]) > 2 )
	{
	    new LastFriend[MAX_PLAYER_NAME];
		format(LastFriend, MAX_PLAYER_NAME, "%s", HouseFriends[houseid][housefriendid][Name]);
		format(HouseFriends[houseid][housefriendid][Name], MAX_PLAYER_NAME, "No");
		SaveHouseFriendEx(houseid, housefriendid);
		new FriendID = IsPlayerConnectedEx(LastFriend);
		if ( FriendID != -1 )
		{
		    UpdateSpawnPlayer(FriendID);
		}
		return true;
	}
	else
	{
	    return false;
	}
}
AddPlayerHouseFriend(playerid, houseid)
{
	for ( new i = 0;i < MAX_HOUSE_FRIENDS; i++)
	{
	    if ( strlen(HouseFriends[houseid][i][Name]) <= 2 )
	    {
			format(HouseFriends[houseid][i][Name], MAX_PLAYER_NAME, "%s", PlayersDataOnline[playerid][NameOnline]);
			SaveHouseFriendEx(houseid, i);
	        return true;
	    }
	}
	return false;
}
//Llaves AmigosEnd

CreateCasaTipoDynamicPickup(casatipo, Float:x, Float:y, Float:z, worldid)
{
	new pickupid = CreateDynamicPickup(19606, 1, x, y, z - 1, worldid, TypeHouse[casatipo][Interior]);
    PickupIndex[pickupid][Tipo] = PICKUP_TYPE_CASA_TYPE;
	PickupIndex[pickupid][Tipoid] = casatipo;
	return pickupid;
}

ShowHouseTypes(playerid)
{
	new string[128];
	Advise(playerid, "Tipos de casas:");
	for( new i; i <= MAX_HOUSE_TYPE; i++ ){
		if( strlen(string) + 9 + strlen(TypeHouse[i][TypeName]) > 128){
			Info(playerid, "%s", string);
			format(string, sizeof(string), "");
		}
		format(string, sizeof(string), "%s%d: %s | ", string, i, TypeHouse[i][TypeName]);
	}
	Info(playerid, "%s", string);
}

GetMyNextGarage(houseid)
{
	for ( new i = 0; i < MAX_GARAGE_FOR_HOUSE; i++ )
	{
	    if (!Garages[houseid][i][WorldG])
	    {
	        return i;
		}
	}
	return -1;
}
IsWorldOfGarage(world)
{
	for (new h = 1; h < MAX_HOUSE_COUNT; h++)
	{
		if(!HouseData[h][PosX]) continue;
		for ( new i = 0; i < MAX_GARAGE_FOR_HOUSE; i++ )
		{
		    if (Garages[h][i][WorldG] && Garages[h][i][WorldG] == world )
		    {
		        return true;
			}
		}
	}
	return false;
}
RemoveAllGarage(houseid)
{
	for ( new i = 0; i < MAX_GARAGE_FOR_HOUSE; i++ )
	{
        RemoveGarage(houseid, i);
	}
}
RemoveGarage(houseid, garageid)
{
	if(IsValidDynamicPickup(Garages[houseid][garageid][PickupidOut])){
		DestroyDynamicPickup(Garages[houseid][garageid][PickupidOut]);
		Garages[houseid][garageid][PickupidOut] = INVALID_PICKUP;
	}
	if(IsValidDynamicPickup(Garages[houseid][garageid][PickupidIn])){
		DestroyDynamicPickup(Garages[houseid][garageid][PickupidIn]);
		Garages[houseid][garageid][PickupidIn] = INVALID_PICKUP;
	}
    Garages[houseid][garageid][Xg]  = 0;
    Garages[houseid][garageid][Yg]  = 0;
    Garages[houseid][garageid][Zg]  = 0;
    Garages[houseid][garageid][ZZg] = 0;

    Garages[houseid][garageid][XgIn]  = 0;
    Garages[houseid][garageid][YgIn]  = 0;
    Garages[houseid][garageid][ZgIn]  = 0;
    Garages[houseid][garageid][ZZgIn] = 0;

    Garages[houseid][garageid][XgOut]  = 0;
    Garages[houseid][garageid][YgOut]  = 0;
    Garages[houseid][garageid][ZgOut]  = 0;
    Garages[houseid][garageid][ZZgOut] = 0;

    Garages[houseid][garageid][WorldG] = 0;
    Garages[houseid][garageid][TypeGarageE] = 0;

	MAX_GARAGES--;
	SaveHouseGarageEx(houseid, garageid);
}

UpdateGarageHouse(houseid, garageid){
	new pickupid,
		interiorcasa = TypeHouse[ HouseData[houseid][TypeHouseId] ][Interior];

	if(IsValidDynamicPickup(Garages[houseid][garageid][PickupidOut])) DestroyDynamicPickup(Garages[houseid][garageid][PickupidOut]);
	pickupid = CreateDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, 1, Garages[houseid][garageid][Xg], Garages[houseid][garageid][Yg], Garages[houseid][garageid][Zg], WORLD_NORMAL, 0);
	PickupIndex[pickupid][Tipo] = PICKUP_TYPE_GARAGE_CASA;
	PickupIndex[pickupid][Tipoid] = garageid;
	PickupIndex[pickupid][Tipoidextra] = houseid;
	Garages[houseid][garageid][PickupidOut] = pickupid;

	if(IsValidDynamicPickup(Garages[houseid][garageid][PickupidIn])) DestroyDynamicPickup(Garages[houseid][garageid][PickupidIn]);
	pickupid = CreateDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, 1, Garages[houseid][garageid][XgIn], Garages[houseid][garageid][YgIn], Garages[houseid][garageid][ZgIn], houseid, interiorcasa);
	PickupIndex[pickupid][Tipo] = PICKUP_TYPE_GARAGE_CASA;
	PickupIndex[pickupid][Tipoid] = garageid;
	PickupIndex[pickupid][Tipoidextra] = houseid;
	Garages[houseid][garageid][PickupidIn] = pickupid;
}
bool:IsGarageDesignValidForHouse(playerid, houseid, desingid)
{
	if( GaragesDesing[desingid][Xg] && GaragesDesing[desingid][XgIn] && GaragesDesing[desingid][XgOut] )
	{
		//Afuera a Pie
		if( GetPointDistanceFromPoint(GaragesDesing[desingid][Xg], GaragesDesing[desingid][Yg], GaragesDesing[desingid][Zg], HouseData[houseid][PosX], HouseData[houseid][PosY], HouseData[houseid][PosZ]) <= 40.0 )
		{
			//Afuera a vehiculo
			if( GetPointDistanceFromPoint(GaragesDesing[desingid][XgOut], GaragesDesing[desingid][YgOut], GaragesDesing[desingid][ZgOut], GaragesDesing[desingid][Xg], GaragesDesing[desingid][Yg], GaragesDesing[desingid][Zg]) <= 10.0 )
			{
				//Dentro Casa
				new houseType = HouseData[houseid][TypeHouseId];
				if( GetPointDistanceFromPoint(GaragesDesing[desingid][XgIn], GaragesDesing[desingid][YgIn], GaragesDesing[desingid][ZgIn], TypeHouse[houseType][PosX], TypeHouse[houseType][PosY], TypeHouse[houseType][PosZ]) <= 40.0 )
				{
					return true;
				}
				else Error(playerid, "La posicion dentro de la casa se encuentra aparentemente no en la misma! (/Dg D)");
			}
			else Error(playerid, "La posicion de salida del vehiculo se encuentra demasiado lejos de la salida del garage! (/Dg C)");
		}
		else Error(playerid, "La posicion de salida del garage se encuentra demasiado lejos de la casa! (/Dg A)");
	}
	else Error(playerid, "El Design Garage que esta utilizando no esta configurado correctamente! (/Ver Design)");
	return false;
}
CreateGarage(playerid, houseid, desingid, TypeGarageEC)
{
	new NextGarage = GetMyNextGarage(houseid);
	if( NextGarage != -1 )
	{
		if( IsGarageDesignValidForHouse(playerid, houseid, desingid) )
		{
			Garages[houseid][NextGarage][Xg]  = GaragesDesing[desingid][Xg];
			Garages[houseid][NextGarage][Yg]  = GaragesDesing[desingid][Yg];
			Garages[houseid][NextGarage][Zg]  = GaragesDesing[desingid][Zg];
			Garages[houseid][NextGarage][ZZg] = GaragesDesing[desingid][ZZg];

			Garages[houseid][NextGarage][XgIn]  = GaragesDesing[desingid][XgIn];
			Garages[houseid][NextGarage][YgIn]  = GaragesDesing[desingid][YgIn];
			Garages[houseid][NextGarage][ZgIn]  = GaragesDesing[desingid][ZgIn];
			Garages[houseid][NextGarage][ZZgIn] = GaragesDesing[desingid][ZZgIn];

			Garages[houseid][NextGarage][XgOut]  = GaragesDesing[desingid][XgOut];
			Garages[houseid][NextGarage][YgOut]  = GaragesDesing[desingid][YgOut];
			Garages[houseid][NextGarage][ZgOut]  = GaragesDesing[desingid][ZgOut];
			Garages[houseid][NextGarage][ZZgOut] = GaragesDesing[desingid][ZZgOut];

			Garages[houseid][NextGarage][LockOut]   = true;
			Garages[houseid][NextGarage][LockIn] 	= true;

			Garages[houseid][NextGarage][TypeGarageE] = TypeGarageEC;
			Garages[houseid][NextGarage][WorldG] = random(999999 + 1000);
			
			MAX_GARAGES++;
			UpdateGarageHouse(houseid, NextGarage);
			SaveHouseGarageEx(houseid, NextGarage);
			return true;
		}
		else return false;
	}
	else
	{
		Error(playerid, "Ha esta casa no se le puede agregar mas garages!");
		return false;
	}
}
ShowGarages(playerid, houseid)
{
	new GarageDialog[700];
	new ConteoGarages;
	for( new i; i < MAX_GARAGE_FOR_HOUSE; i++ )
	{
	    if ( Garages[houseid][i][WorldG] )
	    {
			format(GarageDialog, sizeof(GarageDialog), "%s{"COLOR_VERDE"}Garage ID[%i]\n", GarageDialog, i);
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoGarages] = i;
	        ConteoGarages++;
        }
	}
	if( ConteoGarages )
	{
		new caption[64];
		format(caption, sizeof(caption), "{"COLOR_AZUL"}Garages - Casa %d", houseid);
		ShowPlayerDialogEx(playerid,68,DIALOG_STYLE_LIST,caption, GarageDialog, "Ver", "Salir");
        PlayersDataOnline[playerid][SaveAfterAgenda][MAX_GARAGE_FOR_HOUSE] = houseid;
	}
	else
	{
		ShowPlayerDialogEx(playerid,999,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Garages - informacion", "{"COLOR_TEXTO_DIALOGS"}No se encontraron garages para esta casa.", "Aceptar", "");
	}
}
ShowDetailsGarage(playerid, houseid, garageid)
{
	new GarageDialog[700];
	format(GarageDialog, sizeof(GarageDialog), "{"COLOR_VERDE"}Garage ID[%i]\n{"COLOR_VERDE"}World ID[%i]\n{"COLOR_VERDE"}X_Afuera: %f | Y_Afuera: %f  | Z_Afuera: %f | ZZ_Afuera: %f\n{"COLOR_VERDE"}X_Afuera_C: %f | Y_Afuera_C: %f  | Z_Afuera_C: %f | ZZ_Afuera_C: %f\n{"COLOR_VERDE"}X_Dentro: %f | Y_Dentro: %f  | Z_Dentro: %f | ZZ_Dentro: %f ",
	garageid,
	Garages[houseid][garageid][WorldG],
 	Garages[houseid][garageid][Xg],
	Garages[houseid][garageid][Yg],
	Garages[houseid][garageid][Zg],
	Garages[houseid][garageid][ZZg],
	Garages[houseid][garageid][XgOut],
	Garages[houseid][garageid][YgOut],
	Garages[houseid][garageid][ZgOut],
	Garages[houseid][garageid][ZZgOut],
	Garages[houseid][garageid][XgIn],
	Garages[houseid][garageid][YgIn],
	Garages[houseid][garageid][ZgIn],
	Garages[houseid][garageid][ZZgIn]);
	ShowPlayerDialogEx(playerid,69,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Garages - Detalles", GarageDialog, "Ir", "Volver");
}
IsPlayerInGarageFun(playerid, &housesave, &garagesave)
{
    housesave 	= -1;
    garagesave 	= -1;

    if (!IsPlayerInAnyVehicle(playerid))
    {
        if (PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipo] == PICKUP_TYPE_GARAGE_CASA)
	    {
			garagesave = PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipoid];
			housesave = PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipoidextra];
		    return true;
		}
	    else if ( PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipo] == PICKUP_TYPE_GARAGE_CASA_TYPE )
	    {
		    garagesave = PlayersData[playerid][IsPlayerInGarage];
			housesave = PlayersData[playerid][IsPlayerInHouse];
	        return true;
	    }
	    if ( garagesave != -1 )
	    {
	        return true;
		}
    }
	else
	{
	    if (PlayersData[playerid][IsPlayerInGarage] != -1 && PlayersData[playerid][IsPlayerInHouse])
        {
	        garagesave = PlayersData[playerid][IsPlayerInGarage];
			housesave = PlayersData[playerid][IsPlayerInHouse];
		    return true;
        }
        else
        {
            for (new h = 1; h < MAX_HOUSE_COUNT; h++)
			{
				if(!HouseData[h][PosX]) continue;
				for ( new i = 0; i < MAX_GARAGE_FOR_HOUSE; i++ )
				{
			        if ( Garages[h][i][PickupidIn] )
					{
						if ( IsPlayerInRangeOfPoint(playerid, 3.0, Garages[h][i][XgOut], Garages[h][i][YgOut], Garages[h][i][ZgOut]))
						{
						    garagesave = i;
							housesave = h;
						    return true;
						}
					}
				}
			}
        }
	}
	Error(playerid, "No te encuentras en ningun garage");
    return false;
}
ExistGarageInHouse(houseid)
{
	for ( new i = 0; i < MAX_GARAGE_FOR_HOUSE; i++ )
	{
	    if ( Garages[houseid][i][Xg] != 0)
	    {
	        return true;
		}
	}
	return false;
}
IsPlayerNearGarage(vehicleIndex, playerid)
{
	new MyWorld = GetPlayerVirtualWorld(playerid),
		vehicleid = DataCars[vehicleIndex][VehicleID];
	for (new h = 1; h < MAX_HOUSE_COUNT; h++)
	{
		if(!HouseData[h][PosX]) continue;
		for ( new i = 0; i < MAX_GARAGE_FOR_HOUSE; i++ )
		{
	        if ( Garages[h][i][PickupidIn] )
			{
				if ( IsPlayerInRangeOfPoint(playerid, 3.0,
								 Garages[h][i][XgOut],
								 Garages[h][i][YgOut],
								 Garages[h][i][ZgOut]) ||
				 	 IsPlayerInRangeOfPoint(playerid, 3.0,
								 TypeGarage[Garages[h][i][TypeGarageE]][PosXc],
								 TypeGarage[Garages[h][i][TypeGarageE]][PosYc],
								 TypeGarage[Garages[h][i][TypeGarageE]][PosZc])
								 &&
								 MyWorld == Garages[h][i][WorldG] &&
								 PlayersData[playerid][IsPlayerInHouse] &&
								 PlayersData[playerid][IsPlayerInGarage] >= 0 )
				 {
		            if ( !Garages[h][i][LockOut] || (PlayersDataOnline[playerid][AdminOn] && PlayersData[playerid][Admin] >= 4) )
		            {
						if ( IsPlayerInRangeOfPoint(playerid, 3.0,
										 TypeGarage[Garages[h][i][TypeGarageE]][PosXc],
										 TypeGarage[Garages[h][i][TypeGarageE]][PosYc],
										 TypeGarage[Garages[h][i][TypeGarageE]][PosZc])
										 &&
										 MyWorld == Garages[h][i][WorldG] &&
										 PlayersData[playerid][IsPlayerInHouse] &&
										 PlayersData[playerid][IsPlayerInGarage] >= 0 )
						{
							for (new s = 0; s < MAX_PLAYERS;s++)
							{
							    if ( IsPlayerConnected(s) && IsPlayerInVehicle(s, vehicleid) )
							    {
						        	SetPlayerVirtualWorldEx(s, 0);
						        	SetPlayerInteriorEx(s, 0);
						            PlayersData[s][IsPlayerInHouse]  =  0;
				                    PlayersData[s][IsPlayerInGarage] =  -1;
				                    OnPlayerExitHouse(s);
							    }
							}
				        	SetVehicleVirtualWorldEx(vehicleIndex, 0);
				        	LinkVehicleToInteriorEx(vehicleIndex, 0);
							SetVehiclePos(vehicleid, Garages[h][i][XgOut], Garages[h][i][YgOut],Garages[h][i][ZgOut]);
							SetVehicleZAngle(vehicleid, Garages[h][i][ZZgOut]);
			        	}
			        	else if ( MyWorld == 0 )
			        	{
							for (new s = 0; s < MAX_PLAYERS;s++)
							{
							    if ( IsPlayerConnected(s) && IsPlayerInVehicle(s, vehicleid) )
							    {
						        	SetPlayerVirtualWorldEx(s, Garages[h][i][WorldG]);
						        	SetPlayerInteriorEx(s, TypeGarage[Garages[h][i][TypeGarageE]][Interior]);
				            		PlayersData[s][IsPlayerInHouse]  = h;
		                    		PlayersData[s][IsPlayerInGarage] = i;
									OnPlayerEnterInHouse(s);
							    }
							}
				        	SetVehicleVirtualWorldEx(vehicleIndex, Garages[h][i][WorldG]);
				        	LinkVehicleToInteriorEx(vehicleIndex, TypeGarage[Garages[h][i][TypeGarageE]][Interior]);
							SetVehiclePos(vehicleid, TypeGarage[Garages[h][i][TypeGarageE]][PosXc], TypeGarage[Garages[h][i][TypeGarageE]][PosYc], TypeGarage[Garages[h][i][TypeGarageE]][PosZc]);
							SetVehicleZAngle(vehicleid, TypeGarage[Garages[h][i][TypeGarageE]][PosZZc]);
			        	}
						return true;
		        	}
		        	else
		        	{
						GameTextForPlayer(playerid, "~W~Garage ~R~Cerrado!", 1000, 6);
						break;
					}
				}
			}
		}
	}
	return false;
}
ExistGarageForHouse(houseid, garageid)
{
    if ( Garages[houseid][garageid][WorldG] )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}
GetGarageIdByWorld(houseid, world)
{
	for ( new i = 0; i < MAX_GARAGE_FOR_HOUSE; i++ )
	{
        if ( Garages[houseid][i][WorldG] == world )
		{
		    return i;
        }
    }
	return -1;
}


CreateGarageTipoDynamicPickup(modelid, garagetipo, Float:x, Float:y, Float:z)
{
	new pickupid = CreateDynamicPickup(modelid, 1, x, y, z, -1, TypeGarage[garagetipo][Interior], -1, 20.0);
    PickupIndex[pickupid][Tipo] = PICKUP_TYPE_GARAGE_CASA_TYPE;
	PickupIndex[pickupid][Tipoid] = garagetipo;
	return pickupid;
}

LoadGarageType()
{
	// 0
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2903.1259765625;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2437.4750976563;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.85000038147;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 180;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2905.6140136719;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2430.2329101563;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.85000038147;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 90;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2902.9169921875;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2430.9912109375;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.857509613037;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 0;

	TypeGarage[MAX_GARAGE_TYPE][Interior] = 1;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 1
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2784.8108;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2629.8093;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.8203;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 90;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2779.5432128906;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2624.3771972656;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.8203125;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 0;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2779.5859375;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2628.2490234375;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.62031269073;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 270;

	TypeGarage[MAX_GARAGE_TYPE][Interior] =  2;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 2
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2783.6885;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2587.9719;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.8271;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 0;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2784.5083007813;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2596.9426269531;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.8203125;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 180;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2783.9020996094;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2592.9458007813;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.620312690735;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 180;

	TypeGarage[MAX_GARAGE_TYPE][Interior] = 3;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 3
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2748.0764;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2636.8281;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 11.4423;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 90;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2742.8395996094;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2631.3056640625;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 11.442255020142;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 0;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2742.7019042969;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2635.9318847656;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 11.242255210876;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 270;

	TypeGarage[MAX_GARAGE_TYPE][Interior] = 4;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 4
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2748.6401;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2612.3386;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 11.3118;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 90;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2743.3200683594;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2617.4396972656;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 11.311784744263;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 180;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2742.7180175781;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2613.1538085938;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 11.111784934998;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 270;

	TypeGarage[MAX_GARAGE_TYPE][Interior] = 5;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 5
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2748.9348;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2604.1074;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 11.4423;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 270;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2754.2883300781;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2599.0959472656;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 11.442255020142;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 0;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2753.4196777344;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2603.6960449219;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 11.242255210876;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 270;

	TypeGarage[MAX_GARAGE_TYPE][Interior] = 6;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 6
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2796.1863;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2636.2778;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.8206;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 90;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2788.9365234375;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2640.2585449219;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.820586204529;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 180;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2790.9309082031;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2637.2875976563;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.620586395264;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 270;

	TypeGarage[MAX_GARAGE_TYPE][Interior] =  7;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 7
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2767.0764;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2637.9668;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.9840;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 180;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2763.6127929688;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2635.6181640625;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.984013557434;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 180;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2767.2465820313;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2632.2570800781;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.784013748169;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 0;

	TypeGarage[MAX_GARAGE_TYPE][Interior] = 8;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 8
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2822.1416;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2629.0002;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.8764;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 0;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2820.4426269531;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2638.3657226563;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.876442909241;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 180;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2823.1149902344;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2634.6164550781;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.676443099976;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 180;

	TypeGarage[MAX_GARAGE_TYPE][Interior] =  9;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 9
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2838.9561;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2630.1169,
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.8291;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 360;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2837.3527832031;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2638.9331054688;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.836480140686;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 180;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2839.4033203125;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2635.3623046875;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.636480331421;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 180;

	TypeGarage[MAX_GARAGE_TYPE][Interior] =  10;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 10
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2846.4050;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2618.3450;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.8322;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 0;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2843.1896972656;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2625.0754394531;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.832187652588;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 270;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2846.3708496094;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2624.4382324219;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.632187843323;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 180;

	TypeGarage[MAX_GARAGE_TYPE][Interior] =  11;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 11
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2807.9485;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2599.8291;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.9433;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 0;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2806.212890625;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2607.0744628906;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 13.935888290405;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 90;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2807.5671386719;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2602.951171875;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.73588848114;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 180;

	TypeGarage[MAX_GARAGE_TYPE][Interior] =  12;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 12
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2771.7998;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2523.4099;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.9007;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 360;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2767.9108886719;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2532.8200683594;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.893434524536;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 270;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2771.2622070313;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2530.3293457031;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.693676948547;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 180;

	TypeGarage[MAX_GARAGE_TYPE][Interior] =  13;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 13
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2762.2847;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2582.6541;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.8351;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 180;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2758.4755859375;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2576.1965332031;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.835094451904;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 270;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2762.6628417969;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2576.6296386719;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.635094642639;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 0;

	TypeGarage[MAX_GARAGE_TYPE][Interior] =  14;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 14
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2770.2546;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2567.5901;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.8380;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 180;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2777.4428710938;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2566.0651855469;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.837955474854;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 90;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2770.2780761719;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2563.0756835938;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.637955665588;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 0;

	TypeGarage[MAX_GARAGE_TYPE][Interior] =  15;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 15
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2755.8137;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2562.5759;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.8329;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 90;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2750.3881835938;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2557.6606445313;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.832948684692;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 0;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2750.2775878906;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2562.1689453125;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.632948875427;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 270;

	TypeGarage[MAX_GARAGE_TYPE][Interior] =  16;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 16
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2755.1431;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2512.7124;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 11.0956;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 180;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2753.5578613281;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2503.6491699219;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 11.095604896545;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 0;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2755.2993164063;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2507.4792480469;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.902544021606;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 0;

	TypeGarage[MAX_GARAGE_TYPE][Interior] = 17;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 17
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2743.9014;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2529.9314;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.8694;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 180;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2740.2314453125;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2524.5197753906;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.862500190735;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 270;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2744.126953125;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2525.2817382813;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.66250038147;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 0;

	TypeGarage[MAX_GARAGE_TYPE][Interior] = 18;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 18
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2768.0227;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2446.9446;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.9000;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 270;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2773.4025878906;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2442.4389648438;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.89999961853;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 0;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2773.2446289063;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2447.0495605469;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.699999809265;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 90;

	TypeGarage[MAX_GARAGE_TYPE][Interior] = 19;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;

	// 19
	TypeGarage[MAX_GARAGE_TYPE][PosX] = 2788.6536;
	TypeGarage[MAX_GARAGE_TYPE][PosY] = 2421.3318;
	TypeGarage[MAX_GARAGE_TYPE][PosZ] = 10.8548;
	TypeGarage[MAX_GARAGE_TYPE][PosZZ] = 0;

	TypeGarage[MAX_GARAGE_TYPE][PosXh] = 2784.8806152344;
	TypeGarage[MAX_GARAGE_TYPE][PosYh] = 2424.8825683594;
	TypeGarage[MAX_GARAGE_TYPE][PosZh] = 10.862500190735;
	TypeGarage[MAX_GARAGE_TYPE][PosZZh] = 270;

	TypeGarage[MAX_GARAGE_TYPE][PosXc] = 2788.6831054688;
	TypeGarage[MAX_GARAGE_TYPE][PosYc] = 2427.4235839844;
	TypeGarage[MAX_GARAGE_TYPE][PosZc] = 10.66250038147;
	TypeGarage[MAX_GARAGE_TYPE][PosZZc] = 180;

	TypeGarage[MAX_GARAGE_TYPE][Interior] = 1;

	TypeGarage[MAX_GARAGE_TYPE][PickupId] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_VEHICLE, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosX], TypeGarage[MAX_GARAGE_TYPE][PosY], TypeGarage[MAX_GARAGE_TYPE][PosZ]);
	TypeGarage[MAX_GARAGE_TYPE][PickupIdh] = CreateGarageTipoDynamicPickup(PICKUP_MODEL_GARAGE_CASA_ON_FOOT, MAX_GARAGE_TYPE, TypeGarage[MAX_GARAGE_TYPE][PosXh], TypeGarage[MAX_GARAGE_TYPE][PosYh], TypeGarage[MAX_GARAGE_TYPE][PosZh]);
	MAX_GARAGE_TYPE++;
}


SaveHouseGarageEx(houseid, garageid)
{
	new query[1000], Cache:cacheid, rowCount;
	mysql_format(dataBase, query, 100, "SELECT `ID` FROM `%s` WHERE `ID`='%i';", DIR_HOUSES, houseid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(rowCount);
	cache_delete(cacheid);

	if (!rowCount && HouseData[houseid][PosX])
	{
		SaveHouseAll(houseid);
		return 2;
	}
	if(rowCount){
		////////////////////////////////////Garages
		mysql_format(dataBase, query, 100, "SELECT ID FROM %s WHERE house_id=%d;", DIR_HOUSES_GARAGES, houseid);
		cacheid = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(cacheid);

		if(rowCount < MAX_GARAGE_FOR_HOUSE){
			new i = (!rowCount) ? (0) : (rowCount);
			for(; i!=MAX_GARAGE_FOR_HOUSE; i++){
				mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s \
					(house_id,garage_id,Xg,Yg,Zg,ZZg,XgIn,YgIn,ZgIn,ZZgIn,XgOut,YgOut,ZgOut,ZZgOut,LockIn,LockOut,TypeGarageE,World) VALUES \
					(%d,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%i,%i,%i,%i);", DIR_HOUSES_GARAGES,
					houseid, i, 
					Garages[houseid][i][Xg],
					Garages[houseid][i][Yg],
					Garages[houseid][i][Zg],
					Garages[houseid][i][ZZg],
					Garages[houseid][i][XgIn],
					Garages[houseid][i][YgIn],
					Garages[houseid][i][ZgIn],
					Garages[houseid][i][ZZgIn],
					Garages[houseid][i][XgOut],
					Garages[houseid][i][YgOut],
					Garages[houseid][i][ZgOut],
					Garages[houseid][i][ZZgOut],
					Garages[houseid][i][LockIn],
					Garages[houseid][i][LockOut],
					Garages[houseid][i][TypeGarageE],
					Garages[houseid][i][WorldG]);
				mysql_query(dataBase, query, false);
			}
		}
		else{
			mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
				Xg=%f,Yg=%f,Zg=%f,ZZg=%f,\
				XgIn=%f,YgIn=%f,ZgIn=%f,ZZgIn=%f,\
				XgOut=%f,YgOut=%f,ZgOut=%f,ZZgOut=%f,\
				LockIn=%i,LockOut=%i,TypeGarageE=%i,World=%i \
				WHERE house_id=%d AND garage_id=%d;", DIR_HOUSES_GARAGES, 
				Garages[houseid][garageid][Xg],
				Garages[houseid][garageid][Yg],
				Garages[houseid][garageid][Zg],
				Garages[houseid][garageid][ZZg],

				Garages[houseid][garageid][XgIn],
				Garages[houseid][garageid][YgIn],
				Garages[houseid][garageid][ZgIn],
				Garages[houseid][garageid][ZZgIn],

				Garages[houseid][garageid][XgOut],
				Garages[houseid][garageid][YgOut],
				Garages[houseid][garageid][ZgOut],
				Garages[houseid][garageid][ZZgOut],

				Garages[houseid][garageid][LockIn],
				Garages[houseid][garageid][LockOut],
				Garages[houseid][garageid][TypeGarageE],
				Garages[houseid][garageid][WorldG],
				houseid, garageid);
			mysql_query(dataBase, query, false);
		}
	}
	return 1;
}

IsOpenRefrigerador(playerid, houseid)
{
	if ( !HouseData[houseid][RefrigeradorLock] )
	{
	    return true;
	}
	else
	{
		Error(playerid, "El refrigerador se encuentra cerrado!");
	    return false;
	}
}
AddArticleRefrigeradorFun(playerid, houseid, bolsaid)
{
	if( !PlayersData[playerid][HaveBolsa] ) return Error(playerid, "Usted no tiene bolsa!");
	if( bolsaid < 1 || bolsaid > 4 ) return Error(playerid, "El numero de Slot de bolsa debe estar comprendido entre 1 y 4");
	bolsaid--;
	if( !PlayersData[playerid][Bolsa][bolsaid] ) return Error(playerid, "No tienes nada en esa parte de la bolsa!");
	for( new i; i < MAX_REFRIGERADOR_SLOTS_COUNT; i++ )
	{
		if (!Refrigerador[houseid][Articulo][i])
		{
			new MsgGiveArticle[128];
			format(MsgGiveArticle, sizeof(MsgGiveArticle), "deja %s en el refrigerador", Articulos[PlayersData[playerid][Bolsa][bolsaid]][NameA]);
			Acciones(playerid, 8, MsgGiveArticle);
			Info(playerid, "has dejado %i %s en el refrigerador.", PlayersData[playerid][BolsaC][bolsaid], Articulos[PlayersData[playerid][Bolsa][bolsaid]][NameA]);

			Refrigerador[houseid][Articulo][i] = PlayersData[playerid][Bolsa][bolsaid];
			Refrigerador[houseid][Cantidad][i] += PlayersData[playerid][BolsaC][bolsaid];
			SaveHouseFridgeEx(houseid, i);
			RemoveArticuloBolsa(playerid, bolsaid);
			return true;
		}
	}
	Error(playerid, "El refrigerador se encuentra lleno!");
	return false;
}
RemoveArticleRefrigeradorFun(playerid, houseid, refrigeradorid)
{
	if( !PlayersData[playerid][HaveBolsa] ) return Error(playerid, "Usted no tiene bolsa!");
	if( refrigeradorid < 1 || refrigeradorid > 10 ) return Error(playerid, "El numero de Slot del refrigerador debe estar comprendido entre 1 y 10");
	refrigeradorid--;
	if( !Refrigerador[houseid][Articulo][refrigeradorid] ) return Error(playerid, "No hay nada en esa parte del refrigerador!");
	switch( AddArticuloBolsa(playerid, Refrigerador[houseid][Articulo][refrigeradorid], Refrigerador[houseid][Cantidad][refrigeradorid]) )
	{
		case 0:
		{
			Error(playerid, "La bolsa se encuentra llena!");
		}
		case 1:
		{
			new MsgGiveArticle[128];
			format(MsgGiveArticle, sizeof(MsgGiveArticle), "coge %s del refrigerador", Articulos[Refrigerador[houseid][Articulo][refrigeradorid]][NameA]);
			Acciones(playerid, 8, MsgGiveArticle);
			Info(playerid, "has cogido %i %s del refrigerador.", Refrigerador[houseid][Cantidad][refrigeradorid], Articulos[Refrigerador[houseid][Articulo][refrigeradorid]][NameA]);

			Refrigerador[houseid][Articulo][refrigeradorid] = false;
			Refrigerador[houseid][Cantidad][refrigeradorid] = 0;
			SaveHouseFridgeEx(houseid, refrigeradorid);
			return true;
		}
		case 2:
		{
			Error(playerid, "No te caben mas de esos articulos en la bolsa!");
		}
	}
	return false;
}
EatArticleRefrigerador(playerid, houseid, refrigeradorid)
{
	if( refrigeradorid < 1 || refrigeradorid > 10 ) return Error(playerid, "El numero de Slot del refrigerador debe estar comprendido entre 1 y 10");
	refrigeradorid--;
	if( !Refrigerador[houseid][Articulo][refrigeradorid] ) return Error(playerid, "No hay nada en esa parte del refrigerador!");
	if( UseAritcle(playerid, Refrigerador[houseid][Articulo][refrigeradorid]) )
	{
		Refrigerador[houseid][Cantidad][refrigeradorid]--;
		if( !Refrigerador[houseid][Cantidad][refrigeradorid] )
		{
			Refrigerador[houseid][Articulo][refrigeradorid] = false;
		}
		SaveHouseFridgeEx(houseid, refrigeradorid);
		return true;
	}
	return false;
}
Cocinar(playerid, houseid, refrigeradorid)
{
	if( refrigeradorid < 1 || refrigeradorid > 10 ) return Error(playerid, "El numero de Slot de bolsa debe estar comprendido entre 1 y 4");
	refrigeradorid--;
	if( !Refrigerador[houseid][Articulo][refrigeradorid] ) return Error(playerid, "No hay nada en esa parte del refrigerador!");
	new ArticuloN = Refrigerador[houseid][Articulo][refrigeradorid];
	if( ArticuloN == A_POLLO ||
		ArticuloN == A_PAPAS ||
		ArticuloN == A_ARROZ )
	{
		if( AddArticleRefrigeradorCocinar(houseid, refrigeradorid, ArticuloN + 1) )
		{
			new MsgGiveArticle[128];
			format(MsgGiveArticle, sizeof(MsgGiveArticle), "cocina %s", Articulos[ArticuloN][NameA]);
			Acciones(playerid, 8, MsgGiveArticle);
			return true;
		}
		else
		{
			Error(playerid, "No hay mas espacio para guardar la comida cocinada en el refrigerador!");
		}
	}
	else
	{
		Error(playerid, "Este articulo no se puede cocinar!");
	}
	return false;
}
AddArticleRefrigeradorCocinar(houseid, lastrefrigeradorid, articleid)
{
	for( new i; i < MAX_REFRIGERADOR_SLOTS_COUNT; i++ )
	{
		if( !Refrigerador[houseid][Articulo][i] )
		{
			Refrigerador[houseid][Articulo][i] = articleid;
			Refrigerador[houseid][Cantidad][i] += 1;
			SaveHouseFridgeEx(houseid, i);
			
			Refrigerador[houseid][Cantidad][lastrefrigeradorid]--;
			if ( !Refrigerador[houseid][Cantidad][lastrefrigeradorid] )
			{
				Refrigerador[houseid][Articulo][lastrefrigeradorid] = false;
			}
			SaveHouseFridgeEx(houseid, lastrefrigeradorid);
			return true;
		}
	}
	return false;
}




OnPlayerCommandHouseFridge(playerid, const cmdtext[])
{
	// COMANDO: /Llaves Refrigerador
	if( !strcmp("/Llaves Refrigerador", cmdtext, true) )
	{
		if( !PlayersData[playerid][IsPlayerInHouse] ) return Error(playerid, "No te encuentras en ninguna casa");
		new houseID = PlayersData[playerid][IsPlayerInHouse];
		if( PlayersData[playerid][House] == houseID ||
			PlayersData[playerid][Alquiler] == houseID ||
			IsPlayerInHouseFriend(playerid, houseID) != -1 )
		{
			if( HouseData[houseID][RefrigeradorLock] )
			{
				HouseData[houseID][RefrigeradorLock] = false;
				Info(playerid, "Refrigerador abierto");
				GameTextForPlayer(playerid, "~W~Refrigerador ~G~Abierto!", 1000, 6);
			}
			else
			{
				HouseData[houseID][RefrigeradorLock] = true;
				Info(playerid, "Refrigerador cerrado");
				GameTextForPlayer(playerid, "~W~Refrigerador ~R~Cerrado!", 1000, 6);
			}
			SaveHouse(houseID);
			PlayPlayerStreamSound(playerid, 1002);
		}
		else
		{
			Error(playerid, "No tienes las llaves de esta casa");
		}
		return true;
	}
	// COMANDO: /Refrigerador
	else if( !strcmp("/Refrigerador", cmdtext, true) )
	{
		if( !PlayersData[playerid][IsPlayerInHouse] ) return Error(playerid, "No se encuentra dentro de una casa");
		new houseID = PlayersData[playerid][IsPlayerInHouse];
		if( IsOpenRefrigerador(playerid, houseID) )
		{
			Acciones(playerid, 8, "mira dentro del refrigerador");
			SendClientMessage(playerid, COLOR_MALETERO_ARMARIO_CAJA_FUERTE,
				">>>>>>>>>> .:Refrigerador:. <<<<<<<<<");
			for( new i; i < MAX_REFRIGERADOR_SLOTS_COUNT; i++ )
			{
				SendClientMessage(playerid, COLOR_MALETERO_ARMARIO_CAJA_FUERTE,	"** Refrigerador Articulo %i: %s (%i)", i + 1, Articulos[Refrigerador[houseID][Articulo][i]][NameA], Refrigerador[houseID][Cantidad][i]);
			}
			PlayerPlaySound(playerid, 1002);
		}
		return true;
	}
	// COMANDO: /Coger Articulo [ID_Refrigerador]
	else if( strfind(cmdtext, "/Coger Articulo", true) == 0 )
	{
		new slotID;
		if( strlen(cmdtext) <= 16 || sscanf(cmdtext[16], "d", slotID) ) return SendSyntaxError(playerid, "Coger Articulo [ID_Refrigerador]", "Coger Articulo 1");
		if( !PlayersData[playerid][IsPlayerInHouse] ) return Error(playerid, "No se encuentra dentro de una casa");
		new houseID = PlayersData[playerid][IsPlayerInHouse];

		if( IsOpenRefrigerador(playerid, houseID) )
		{
			RemoveArticleRefrigeradorFun(playerid, houseID, slotID);
		}
		return true;
	}
	// COMANDO: /Dejar Articulo [ID_Bolsa]
	else if( strfind(cmdtext, "/Dejar Articulo", true) == 0 )
	{
		new slotID;
		if( strlen(cmdtext) <= 16 || sscanf(cmdtext[16], "d", slotID) ) return SendSyntaxError(playerid, "Dejar Articulo [ID_Bolsa]", "Dejar Articulo 1");
		if( !PlayersData[playerid][IsPlayerInHouse] ) return Error(playerid, "No se encuentra dentro de una casa");
		new houseID = PlayersData[playerid][IsPlayerInHouse];
		if( IsOpenRefrigerador(playerid, houseID) )
		{
			AddArticleRefrigeradorFun(playerid, houseID, slotID);
		}
		return true;
	}
	// COMANDO: /Cocinar [ID_Refrigerador]
	else if( strfind(cmdtext, "/Cocinar", true) == 0 )
	{
		new slotID;
		if( strlen(cmdtext) <= 9 || sscanf(cmdtext[9], "d", slotID) ) return SendSyntaxError(playerid, "Cocinar [ID_Refrigerador]", "Cocinar 1");

		if( PlayersData[playerid][IsPlayerInHouse] ) return Error(playerid, "No te encuentras en una casa");

		if( IsOpenRefrigerador(playerid, PlayersData[playerid][IsPlayerInHouse]) )
		{
			Cocinar(playerid, PlayersData[playerid][IsPlayerInHouse], slotID);
		}
		return true;
	}
	// COMANDO: /Usar Refrigerador [ID_Refrigerador]
	else if( strfind(cmdtext, "/Usar Refrigerador", true) == 0 )
	{
		new slotID;
		if( strlen(cmdtext) <= 19 || sscanf(cmdtext[19], "d", slotID) ) return SendSyntaxError(playerid, "Usar Refrigerador [ID_Refrigerador]", "Usar Refrigerador 1");
		if( PlayersData[playerid][IsPlayerInHouse] ) return Error(playerid, "No te encuentras en una casa");

		if( IsOpenRefrigerador(playerid, PlayersData[playerid][IsPlayerInHouse]) )
		{
			EatArticleRefrigerador(playerid, PlayersData[playerid][IsPlayerInHouse], slotID);
		}
		return true;
	}
	return false;
}

SaveHouseFridgeEx(houseid, slotid)
{
	new query[1000], Cache:cacheid, rowCount;
	mysql_format(dataBase, query, 100, "SELECT `ID` FROM `%s` WHERE `ID`='%i';", DIR_HOUSES, houseid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(rowCount);
	cache_delete(cacheid);

	if (!rowCount && HouseData[houseid][PosX])
	{
		SaveHouseAll(houseid);
		return 2;
	}
	if(rowCount){
		////////////////////////////////////Refrigerador
		mysql_format(dataBase, query, 100, "SELECT ID FROM %s WHERE house_id=%d;", DIR_HOUSES_FRIDGE, houseid);
		cacheid = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(cacheid);

		if(rowCount < MAX_REFRIGERADOR_SLOTS_COUNT){
			new i = (!rowCount) ? (0) : (rowCount);
			const limit = MAX_REFRIGERADOR_SLOTS_COUNT - 1;
			mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s (house_id,slot_id,article,amount) VALUES ", DIR_HOUSES_FRIDGE);
			for(; i!=MAX_REFRIGERADOR_SLOTS_COUNT; i++){
				if(i == limit)
				mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,%d,%d)", query, houseid, i, Refrigerador[houseid][Articulo][i], Refrigerador[houseid][Cantidad][i]);
				else
				mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,%d,%d),", query, houseid, i, Refrigerador[houseid][Articulo][i], Refrigerador[houseid][Cantidad][i]);
			}
			mysql_query(dataBase, query, false);
		}
		else{
			mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
				article=%d,amount=%d WHERE house_id=%d AND slot_id=%d;", DIR_HOUSES_FRIDGE, Refrigerador[houseid][Articulo][slotid], Refrigerador[houseid][Cantidad][slotid], houseid, slotid);
			mysql_query(dataBase, query, false);
		}
	}
	return 1;
}

OnPlayerCommandHouseGarage(playerid, const cmdtext[])
{	
	//////////--- /Info GarageC [ID]              - VER informacion DE UNA CASA
	if( !strcmp("/Info GarageC", cmdtext, true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		{
			new GarageID, HouseID; IsPlayerInGarageFun(playerid, HouseID, GarageID);
			if ( GarageID != -1 )
			{
				Advise(playerid, "Garage ID[%i], tipo [%i] pertenece a la casa [%i]", GarageID, Garages[HouseID][GarageID][TypeGarageE], HouseID);
			}
		}
		return true;
	}
	//////////--- /Gtipo [ID]              - CAMBIAR EL TIPO DE UNA CASA
	else if( !strfind(cmdtext, "/Gtipo", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		if( strlen(cmdtext) < 7 ) return SendSyntaxError(playerid, "GTipo [ID_Tipo]", "GTipo 1");
		new typeID = strval(cmdtext[7]);
		if ( 0 <= typeID < MAX_GARAGE_TYPE )
		{
			
			if ( PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipo] == PICKUP_TYPE_GARAGE_CASA )
			{
				new GarageID = PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipoid];
				new HouseID = PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipoidextra];
				ImportanteEx(playerid, "Cambiaste el garage [%d] de la casa [%d] a tipo %d. Antes: %d", GarageID, HouseID, typeID, Garages[HouseID][GarageID][TypeGarageE]);
				Garages[HouseID][GarageID][TypeGarageE] = typeID;
				SaveHouseGarageEx(HouseID, GarageID);
			}
			else{
				SetPlayerInteriorEx(playerid, TypeGarage[typeID][Interior]);
				SetPlayerPos(playerid, TypeGarage[typeID][PosX], TypeGarage[typeID][PosY], TypeGarage[typeID][PosZ]);
				SetPlayerFacingAngle(playerid, TypeGarage[typeID][PosZZ]);
				Advise(playerid, "Fuiste al tipo de garage de casa %d", typeID);
			}
		}
		else
		{
			Error(playerid, "La ID del tipo de garage debe estar comprendida entre 0 y %d", (MAX_GARAGE_TYPE - 1));
		}
		return true;
	}
	//////////--- /Design Garage [ID]            - COMENZAR A DISEÑAR UN GARAGE
	else if( !strfind(cmdtext, "/Design Garage", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		if( strlen(cmdtext) < 15 ) return SendSyntaxError(playerid, "Design Garage [ID_Design]", "Design Garage 0");
		new designID = strval(cmdtext[15]);
		if ( 0 <= designID < MAX_GARAGES_DESING )
		{
			PlayersDataOnline[playerid][DesignGarageId] = designID;
			Advise(playerid, "Ahora tienes el ID %d como Design Garage.", designID);
		}
		else
		{
			Error(playerid, "El númmero de Design introducido debe estar comprendido entre 0 y %d", (MAX_GARAGES_DESING - 1));
		}
		return true;
	}
	//////////--- /Dg Rand
	else if( !strfind(cmdtext, "/Dg Rand", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		{
			new IdHouse = -1, IdGarage = -1;
			if( strlen(cmdtext) < 9 || sscanf(cmdtext[9], "dd", IdHouse, IdGarage) ) return SendSyntaxError(playerid, "Dg Rand [ID_Casa] [ID_Garage]", "Dg Rand 1 0");
			if( IdHouse <= 0 || IdHouse >= MAX_HOUSE_COUNT ) return Error(playerid, "ID de casa invalida!");
			if( !HouseData[IdHouse][PosX] ) return Error(playerid, "El ID de casa introducido no existe!");
			if( IdGarage < 0 || IdGarage >= MAX_GARAGE_FOR_HOUSE ) return Error(playerid, "El ID de garage debe estar comprendido entre 0 y %d", (MAX_GARAGE_FOR_HOUSE - 1));
			if( ExistGarageForHouse(IdHouse, IdGarage) )
			{
				new newWorld = random(999999 + 1000);
				ImportanteEx(playerid, "Nuevo mundo random (%d) para el garage [%d] de la casa [%d]. Antes: mundo %d", newWorld, IdGarage, IdHouse, Garages[IdHouse][IdGarage][WorldG]);

				Garages[IdHouse][IdGarage][WorldG] = newWorld;
				SaveHouseGarageEx(IdHouse, IdGarage);
			}
			else
			{
				Error(playerid, "Esta casa no tiene este ID de Garage creado! /Garages %d", IdHouse);
			}
		}
		return true;
	}
	//////////--- /Dg a
	else if( strcmp("/Dg a", cmdtext, true, 5) == 0 && strlen(cmdtext) == 5)
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		if( PlayersDataOnline[playerid][DesignGarageId] == -1 ) return Error(playerid, "Debe asignar un ID de design para comenzar a crear un garage! (/Design Garage)");
		if( !IsPlayerInExterior(playerid) ) return Error(playerid, "Debes de estar en el exterior para usar este comando!");
		new designID = PlayersDataOnline[playerid][DesignGarageId];
		GetPlayerPos(playerid, GaragesDesing[designID][Xg], GaragesDesing[designID][Yg], GaragesDesing[designID][Zg]);
		GetPlayerFacingAngle(playerid, GaragesDesing[designID][ZZg]);

		Advise(playerid, "Nueva POS Desing ID[%i] \"AFUERA A PIE\"", designID);
		Advise(playerid, "X_Afuera: %f | Y_Afuera: %f  | Z_Afuera: %f | ZZ_Afuera: %f", GaragesDesing[designID][Xg], GaragesDesing[designID][Yg], GaragesDesing[designID][Zg], GaragesDesing[designID][ZZg]);
		return true;
	}
	//////////--- /Dg aP
	else if( !strfind(cmdtext, "/Dg aP", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		new IdHouse, IdGarage;
		if( strlen(cmdtext) < 7 || sscanf(cmdtext[7], "dd", IdHouse, IdGarage) ) return SendSyntaxError(playerid, "Dg Ap [ID_Casa] [ID_Garage]", "Dg Ap 1 0");
		if( IdHouse <= 0 || IdHouse >= MAX_HOUSE_COUNT ) return Error(playerid, "ID de casa invalida!");
		if( !HouseData[IdHouse][PosX] ) return Error(playerid, "La ID de casa introducida no existe!");
		if( IdGarage < 0 || IdGarage >= MAX_GARAGE_FOR_HOUSE ) return Error(playerid, "El ID de garage debe estar comprendido entre 0 y %d", (MAX_GARAGE_FOR_HOUSE - 1));
		if( ExistGarageForHouse(IdHouse, IdGarage) )
		{
			if( !IsPlayerInExterior(playerid) ) return Error(playerid, "Debes de estar en el exterior para usar este comando!");
			GetPlayerPos(playerid, Garages[IdHouse][IdGarage][Xg], Garages[IdHouse][IdGarage][Yg], Garages[IdHouse][IdGarage][Zg]);
			GetPlayerFacingAngle(playerid, Garages[IdHouse][IdGarage][ZZg]);
			UpdateGarageHouse(IdHouse, IdGarage);
			SaveHouseGarageEx(IdHouse, IdGarage);

			ImportanteEx(playerid, "Nueva POS MODIFICADA \"AFUERA A PIE\" GARAGEID[%i] PARA LA CASA ID[%i]", IdGarage, IdHouse);
			ImportanteEx(playerid, "X_Afuera: %f | Y_Afuera: %f  | Z_Afuera: %f | ZZ_Afuera: %f", Garages[IdHouse][IdGarage][Xg], Garages[IdHouse][IdGarage][Yg], Garages[IdHouse][IdGarage][Zg], Garages[IdHouse][IdGarage][ZZg]);
		}
		else
		{
			Error(playerid, "Esta casa no tiene este ID de Garage creado! /Garages %d", IdHouse);
		}
		return true;
	}
	//////////--- //Dg c
	else if( strcmp("/Dg c", cmdtext, true, 5) == 0 && strlen(cmdtext) == 5)
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		if( PlayersDataOnline[playerid][DesignGarageId] == -1 ) return Error(playerid, "Debe asignar un ID de design para comenzar a crear un garage! (/Design Garage)");
		if( !IsPlayerInExterior(playerid) ) return Error(playerid, "Debes de estar en el exterior para usar este comando!");
		new designID = PlayersDataOnline[playerid][DesignGarageId];
		GetPlayerPos(playerid, GaragesDesing[designID][XgOut], GaragesDesing[designID][YgOut], GaragesDesing[designID][ZgOut]);
		GetPlayerFacingAngle(playerid, GaragesDesing[designID][ZZgOut]);

		Advise(playerid, "Nueva POS Desing ID[%i] \"AFUERA COCHE\"", designID);
		Advise(playerid, "X_Afuera_C: %f | Y_Afuera_C: %f  | Z_Afuera_C: %f | ZZ_Afuera_C: %f", GaragesDesing[designID][XgOut], GaragesDesing[designID][YgOut], GaragesDesing[designID][ZgOut], GaragesDesing[designID][ZZgOut]);
		return true;
	}
	//////////--- /Dg cP
	else if( !strfind(cmdtext, "/Dg cP", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		new IdHouse, IdGarage;
		if( strlen(cmdtext) < 7 || sscanf(cmdtext[7], "dd", IdHouse, IdGarage) ) return SendSyntaxError(playerid, "Dg cP [ID_Casa] [ID_Garage]", "Dg cP 1 0");
		if( IdHouse <= 0 || IdHouse >= MAX_HOUSE_COUNT ) return Error(playerid, "ID de casa invalida!");
		if( !HouseData[IdHouse][PosX] ) return Error(playerid, "La ID de casa introducida no existe!");
		if( IdGarage < 0 || IdGarage >= MAX_GARAGE_FOR_HOUSE ) return Error(playerid, "El ID de garage debe estar comprendido entre 0 y %d", (MAX_GARAGE_FOR_HOUSE - 1));
		if( ExistGarageForHouse(IdHouse, IdGarage) )
		{
			if( !IsPlayerInExterior(playerid) ) return Error(playerid, "Debes de estar en el exterior para usar este comando!");
			GetPlayerPos(playerid, Garages[IdHouse][IdGarage][XgOut], Garages[IdHouse][IdGarage][YgOut], Garages[IdHouse][IdGarage][ZgOut]);
			GetPlayerFacingAngle(playerid, Garages[IdHouse][IdGarage][ZZgOut]);
			SaveHouseGarageEx(IdHouse, IdGarage);

			ImportanteEx(playerid, "Nueva POS MODIFICADA \"AFUERA COCHE\" GARAGEID[%i] PARA LA CASA ID[%i]", IdGarage, IdHouse);
			ImportanteEx(playerid, "X_Afuera_C: %f | Y_Afuera_C: %f  | Z_Afuera_C: %f | ZZ_Afuera_C: %f", Garages[IdHouse][IdGarage][XgOut], Garages[IdHouse][IdGarage][YgOut], Garages[IdHouse][IdGarage][ZgOut], Garages[IdHouse][IdGarage][ZZgOut]);
		}
		else
		{
			Error(playerid, "Esta casa no tiene este ID de Garage creado! /Garages %d", IdHouse);
		}
		return true;
	}
	//////////--- //Dg d
	else if( strcmp("/Dg d", cmdtext, true, 5) == 0 && strlen(cmdtext) == 5)
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		if( PlayersDataOnline[playerid][DesignGarageId] == -1 ) return Error(playerid, "Debe asignar un ID de design para comenzar a crear un garage! (/Design Garage)");
		if( !PlayersData[playerid][IsPlayerInHouse] ) return Error(playerid, "Debe de estar dentro de la casa para establecer esta posicion!");
		new designID = PlayersDataOnline[playerid][DesignGarageId];
		GetPlayerPos(playerid, GaragesDesing[designID][XgIn], GaragesDesing[designID][YgIn], GaragesDesing[designID][ZgIn]);
		GetPlayerFacingAngle(playerid, GaragesDesing[designID][ZZgIn]);

		Advise(playerid, "Nueva POS Desing ID[%i] \"DENTRO CASA\"", designID);
		Advise(playerid, "X_Dentro: %f | Y_Dentro: %f  | Z_Dentro: %f | ZZ_Dentro: %f", GaragesDesing[designID][XgIn], GaragesDesing[designID][YgIn], GaragesDesing[designID][ZgIn], GaragesDesing[designID][ZZgIn]);
		return true;
	}
	//////////--- /Dg dP
	else if( !strfind(cmdtext, "/Dg dP", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if ( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		new IdHouse, IdGarage;
		if( strlen(cmdtext) < 7 || sscanf(cmdtext[7], "dd", IdHouse, IdGarage) ) return SendSyntaxError(playerid, "Dg dP [ID_Casa] [ID_Garage]", "Dg dP 1 0");
		if( IdHouse <= 0 || IdHouse >= MAX_HOUSE_COUNT ) return Error(playerid, "ID de casa invalida!");
		if( !HouseData[IdHouse][PosX] ) return Error(playerid, "La ID de casa introducida no existe!");
		if( IdGarage < 0 || IdGarage >= MAX_GARAGE_FOR_HOUSE ) return Error(playerid, "El ID de garage debe estar comprendido entre 0 y %d", (MAX_GARAGE_FOR_HOUSE - 1));
		if ( ExistGarageForHouse(IdHouse, IdGarage) )
		{
			if( !PlayersData[playerid][IsPlayerInHouse] ) return Error(playerid, "Debe de estar dentro de la casa para establecer esta posicion!");
			GetPlayerPos(playerid, Garages[IdHouse][IdGarage][XgIn], Garages[IdHouse][IdGarage][YgIn], Garages[IdHouse][IdGarage][ZgIn]);
			GetPlayerFacingAngle(playerid, Garages[IdHouse][IdGarage][ZZgIn]);
			UpdateGarageHouse(IdHouse, IdGarage);
			SaveHouseGarageEx(IdHouse, IdGarage);

			ImportanteEx(playerid, "Nueva POS MODIFICADA \"DENTRO CASA\" GARAGE ID[%i]  PARA LA CASA ID[%i]", IdGarage, IdHouse);
			ImportanteEx(playerid, "X_Dentro: %f | Y_Dentro: %f  | Z_Dentro: %f | ZZ_Dentro: %f", Garages[IdHouse][IdGarage][XgIn], Garages[IdHouse][IdGarage][YgIn], Garages[IdHouse][IdGarage][ZgIn], Garages[IdHouse][IdGarage][ZZgIn]);
		}
		else
		{
			Error(playerid, "Esta casa no tiene este ID de Garage creado! /Garages %d", IdHouse);
		}
		return true;
	}
	//////////--- /Ver Design
	else if( strcmp("/Ver Design", cmdtext, true, 11) == 0 && strlen(cmdtext) == 11)
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		{
			if( PlayersDataOnline[playerid][DesignGarageId] == -1 ) return Error(playerid, "Debe asignar un ID de design para comenzar a crear un garage! (/Design Garage)");
	        new designID = PlayersDataOnline[playerid][DesignGarageId];
			Advise(playerid, "Desing ID [%i]", designID);
			Advise(playerid, "X_Afuera: %f | Y_Afuera: %f  | Z_Afuera: %f | ZZ_Afuera: %f (/Dg A)", GaragesDesing[designID][Xg], GaragesDesing[designID][Yg], GaragesDesing[designID][Zg], GaragesDesing[designID][ZZg]);
			Advise(playerid, "X_Afuera_C: %f | Y_Afuera_C: %f  | Z_Afuera_C: %f | ZZ_Afuera_C: %f (/Dg C)", GaragesDesing[designID][XgOut], GaragesDesing[designID][YgOut], GaragesDesing[designID][ZgOut], GaragesDesing[designID][ZZgOut]);
			Advise(playerid, "X_Dentro: %f | Y_Dentro: %f  | Z_Dentro: %f | ZZ_Dentro: %f (/Dg D)", GaragesDesing[designID][XgIn], GaragesDesing[designID][YgIn], GaragesDesing[designID][ZgIn], GaragesDesing[designID][ZZgIn]);
		}
		return true;
	}
	//////////--- /Crear GarageC [ID_Casa] [Tipo_Garage]            - COMENZAR A DISEÑAR UN GARAGE
	else if( !strfind(cmdtext, "/Crear GarageC", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		new IdHouse, TypeGarageS;
		if( strlen(cmdtext) > 15 && !sscanf(cmdtext[15], "dd", IdHouse, TypeGarageS) )
		{
			if( IdHouse <= 0 || IdHouse >= MAX_HOUSE_COUNT ) return Error(playerid, "ID de casa invalida!");
			if( !HouseData[IdHouse][PosX] ) return Error(playerid, "El ID de casa introducido no existe!");
			if( TypeGarageS < 0 || TypeGarageS >= MAX_GARAGE_TYPE ) return Error(playerid, "La ID del tipo de garage debe estar comprendida entre 0 y %d", (MAX_GARAGE_TYPE - 1));
			if( PlayersDataOnline[playerid][DesignGarageId] == -1 ) return SendInfoMessage(playerid, 0, "", "Debe asignar un ID de design para comenzar a crear un garage! (/Design Garage)");
			if( CreateGarage(playerid, IdHouse, PlayersDataOnline[playerid][DesignGarageId], TypeGarageS) )
			{
				ImportanteEx(playerid, "Creaste un garage tipo [%d] para la Casa [%d] con el Desing ID [%d]", TypeGarageS, IdHouse, PlayersDataOnline[playerid][DesignGarageId]);
			}
		}
		else SendSyntaxError(playerid, "Crear GarageC [ID_Casa] [Tipo_Garage]", "Crear GarageC 1 0");
		return 1;
	}
	//////////--- /Garages [ID_Casa]            - VER GARAGES DE UNA CASA
	else if( !strfind(cmdtext, "/Garages", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		if( strlen(cmdtext) < 9 ) return SendSyntaxError(playerid, "Garages [ID_Casa]", "Garages 1");
		new IdHouse = strval(cmdtext[9]);
		if ( 0 < IdHouse < MAX_HOUSE_COUNT )
		{
			if( !HouseData[IdHouse][PosX] ) return Error(playerid, "La ID de casa introducido no existe!");
			ShowGarages(playerid, IdHouse);
		}
		else
		{
			Error(playerid, "ID de casa invalida!");
		}
		return 1;
	}
	// COMANDO: /Llaves Garage
	else if( strcmp("/Llaves Garage", cmdtext, true, 14) == 0 && strlen(cmdtext) == 14)
	{
		new GarageID, HouseID; IsPlayerInGarageFun(playerid, HouseID, GarageID);
		if ( GarageID != -1 )
		{
			if( PlayersData[playerid][House] == HouseID ||
				PlayersData[playerid][Alquiler] == HouseID ||
				IsPlayerInHouseFriend(playerid, HouseID) != -1 )
			{
				//Garage<->Exterior
				if( PlayersDataOnline[playerid][InPickup] == TypeGarage[Garages[HouseID][GarageID][TypeGarageE]][PickupId] ||
					PlayersDataOnline[playerid][InPickup] == Garages[HouseID][GarageID][PickupidOut] || IsPlayerInAnyVehicle(playerid) )
				{
					if ( Garages[HouseID][GarageID][LockOut] )
					{
						Garages[HouseID][GarageID][LockOut] = false;
						GameTextForPlayer(playerid, "~W~Garage ~G~Abierto!", 1000, 6);
						Info(playerid, "Garage abierto");
						PlayersDataOnline[playerid][MyPickupLock] = false;
					}
					else
					{
						Garages[HouseID][GarageID][LockOut] = true;
						GameTextForPlayer(playerid, "~W~Garage ~R~Cerrado!", 1000, 6);
						Info(playerid, "Garage cerrado");
						PlayersDataOnline[playerid][MyPickupLock] = true;
					}
				}
				//Garage<->Casa
				else if( PlayersDataOnline[playerid][InPickup] == TypeGarage[Garages[HouseID][GarageID][TypeGarageE]][PickupIdh] ||
						PlayersDataOnline[playerid][InPickup] == Garages[HouseID][GarageID][PickupidIn] )
				{
					if ( Garages[HouseID][GarageID][LockIn] )
					{
						Garages[HouseID][GarageID][LockIn] = false;
						GameTextForPlayer(playerid, "~W~Puerta ~G~Abierta!", 1000, 6);
						PlayersDataOnline[playerid][MyPickupLock] = false;
					}
					else
					{
						Garages[HouseID][GarageID][LockIn] = true;
						GameTextForPlayer(playerid, "~W~Puerta ~R~Cerrada!", 1000, 6);
						PlayersDataOnline[playerid][MyPickupLock] = true;
					}
				}
				SaveHouseGarageEx(HouseID, GarageID);
				PlayPlayerStreamSound(playerid, 1027);
			}
			else
			{
				Error(playerid, "Usted no tiene las llaves de este garage");
			}
		}
		return true;
	}
	// /Borrar Garage
	else if( !strcmp("/Borrar Garage", cmdtext, true) )
	{
		if( PlayersData[playerid][Admin] < 9 ) return SendAccessError(playerid, cmdtext);
		if( PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipo] == PICKUP_TYPE_GARAGE_CASA )
		{
			new garageid = PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipoid];
			new houseid = PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipoidextra];
			ImportanteEx(playerid, "Borraste el garage %d tipo [%d] de la casa [%d]", garageid, Garages[houseid][garageid][TypeGarageE], houseid);
			RemoveGarage(houseid, garageid);
		}
		else Error(playerid, "No te enceuntras en ningun garage de casa!");
		return true;
	}
	return false;
}

OnPlayerCommandHouse(playerid, const cmdtext[])
{
	new houseid;
	if( OnPlayerCommandHouseGarage(playerid, cmdtext) ) return 1;
	else if( OnPlayerCommandHouseFridge(playerid, cmdtext) ) return 1;
	//////////--- /Crear Incendio [ID]              - CREAR UN INCENDIO
	else if( !strfind(cmdtext, "/Crear Incendio", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 7 ) return SendAccessError(playerid, cmdtext);
		if( strlen(cmdtext) <= 16 ) return SendSyntaxError(playerid, "Crear Incendio [ID_Casa]", "Crear Incendio 1");
		new houseID = strval(cmdtext[16]);
		if( houseID <= 0 || houseID >= MAX_HOUSE_COUNT ) return Error(playerid, "ID de casa invalida!");
		if( !HouseData[houseID][PosX] ) return Error(playerid, "El ID de casa introducido no existe!");
		new nextFire = GetFireNext();
		if( CreateFire(houseID, nextFire) )
		{
			ImportanteEx(playerid, "Has creado un incendio en la casa ID %d, ID incendio: %d (/Incendios)", houseID, nextFire);
		}
		else
		{
			Error(playerid, "Se ha alcanzado el numero maximo de /incendios");
		}
		return 1;
	}
	//////////--- /Crear Casa [ID]              - CREAR UNA CASA
	else if( strfind(cmdtext, "/Crear Casa", true) == 0 )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		if( GetPlayerInterior(playerid) || GetPlayerVirtualWorld(playerid) ) return Error(playerid, "Solo puede crear casas en el exterior!");
		new TypeHouseC, PrecioC;
		if( strlen(cmdtext) <= 12 || sscanf( cmdtext[12], "dD(-1)", TypeHouseC, PrecioC ) ) return SendSyntaxError(playerid, "Crear Casa [ID_Tipo] [Precio (Opcional)]", "Crear Casa 1 150000");
		if( TypeHouseC < 0 || TypeHouseC > MAX_HOUSE_TYPE ){
			Error(playerid, "El numero del tipo de casa debe estar comprendido entre 0 y %d", MAX_HOUSE_TYPE);
			ShowHouseTypes(playerid);
			return 1;
		}
		if( PrecioC == -1 ) PrecioC = 150000;
		if( PrecioC <= 0 || PrecioC > 1000000) return Error(playerid, "El precio de la casa debe estar comprendido entre $1 y $1,000,000");

		new MyNextHouse = GetMyNextHouse();
		if( !MyNextHouse ) return Error(playerid, "Ya no se pueden agregar mas casas, se ha alcanzado el limite!");
		new Float:PlayerPosHouse[4];
		GetPlayerPos(playerid, PlayerPosHouse[0], PlayerPosHouse[1], PlayerPosHouse[2]);
		GetPlayerFacingAngle(playerid, PlayerPosHouse[3]);

		format(HouseData[MyNextHouse][Dueno], MAX_PLAYER_NAME, "No");
		HouseData[MyNextHouse][PosX] = PlayerPosHouse[0];
		HouseData[MyNextHouse][PosY] = PlayerPosHouse[1];
		HouseData[MyNextHouse][PosZ] = PlayerPosHouse[2];
		HouseData[MyNextHouse][PosZZ] = PlayerPosHouse[3];
		HouseData[MyNextHouse][TypeHouseId]	= TypeHouseC;
		HouseData[MyNextHouse][PriceRent] = 0;
		HouseData[MyNextHouse][World] = MyNextHouse;
		HouseData[MyNextHouse][Level] = 0;
		HouseData[MyNextHouse][Lock] = true;
		HouseData[MyNextHouse][Price] = PrecioC;
		MAX_HOUSE++;
		SaveHouseAll(MyNextHouse);
		UpdateHouse(MyNextHouse);

		ImportanteEx(playerid, "Has creado una casa tipo \"%s\" [%d] con ID %d, Precio: $%d", TypeHouse[TypeHouseC][TypeName], TypeHouseC, MyNextHouse, HouseData[MyNextHouse][Price]);
		printf("%s[%d-%d] creo una casa tipo \"%s\" [%d] con ID %d, Precio: $%d", PlayersDataOnline[playerid][NameOnline], PlayersData[playerid][DB_ID], playerid, TypeHouse[TypeHouseC][TypeName], TypeHouseC, MyNextHouse, HouseData[MyNextHouse][Price]);
		return 1;
	}
	// COMANDO: /Timbre
	else if( strcmp("/Timbre", cmdtext, true, 7) == 0 && strlen(cmdtext) == 7 )
	{
		if( PlayersDataOnline[playerid][InPickupCasa] )
		{
			houseid = PlayersDataOnline[playerid][InPickupCasa];
			
			if( gettime() - HouseData[houseid][RingHouseTime] >= 20 )
			{
				const Float:radioTimbre = 30.0;
				for( new i,j=GetPlayerPoolSize(); i <= j; i++ )
				{
					if( !IsPlayerLogued(i) ) continue;
					if( PlayersData[i][IsPlayerInHouse] == houseid)
					{
						SendClientMessage(i, COLOR_DE_WISPEO, "** TIMBRE: RING RING!!!");
						PlayerPlaySound(i, 31000);
					}
					else if( !GetPlayerInteriorEx(i) && !GetPlayerVirtualWorld(i) && IsPlayerInRangeOfPoint(i, radioTimbre, HouseData[houseid][PosX], HouseData[houseid][PosY], HouseData[houseid][PosZ]) )
					{
						PlayerPlaySound(i, 31000, HouseData[houseid][PosX], HouseData[houseid][PosY], HouseData[houseid][PosZ]);
					}
				}
				Acciones(playerid, 8, "tocó el timbre de la casa");
				HouseData[houseid][RingHouseTime] = gettime();
			}
			else
			{
				Error(playerid, "El timbre de esta casa ha sido tocado recientemente, tiene que esperar %i segundos para volver a usarlo", 20 - (gettime() - HouseData[houseid][RingHouseTime]));
			}
		}
		else
		{
			Error(playerid, "No te encuentras en la puerta de ninguna casa");
		}
		return 1;
	}
	// COMANDO: /Música
	else if( strcmp("/Musica", cmdtext, true, 7) == 0 && strlen(cmdtext) == 7 )
	{
		if( PlayersData[playerid][IsPlayerInHouse] )
		{
			if( PlayersData[playerid][House] == PlayersData[playerid][IsPlayerInHouse] ||
				PlayersData[playerid][Alquiler] == PlayersData[playerid][IsPlayerInHouse] ||
				IsPlayerInHouseFriend(playerid, PlayersData[playerid][IsPlayerInHouse]) != -1 ||
				PlayersData[playerid][Admin] >= 7 && PlayersDataOnline[playerid][AdminOn])
			{
				ShowStations(playerid, HouseData[PlayersData[playerid][IsPlayerInHouse]][StationID], 1);
			}
			else
			{
				Error(playerid, "Esta no es su casa");
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ninguna casa");
		}
		return 1;
	}
	// COMANDO: /Alquilar
	else if( strcmp("/Alquilar", cmdtext, true, 9) == 0 && strlen(cmdtext) == 9 )
	{
		if( PlayersDataOnline[playerid][InPickupCasa] )
		{
			houseid = PlayersDataOnline[playerid][InPickupCasa];
			if( PlayersData[playerid][House] == -1 )
			{
				if( PlayersData[playerid][Alquiler] == -1 )
				{
					if( strlen(HouseData[houseid][Dueno]) != 2 && HouseData[houseid][PriceRent] != 0)
					{
						if( PlayersData[playerid][Dinero] >= HouseData[houseid][PriceRent] )
						{
							Importante(playerid, "Te has rentado en esta casa por $%i", HouseData[houseid][PriceRent]);
							PlayersData[playerid][Alquiler] = houseid;
							GivePlayerMoneyEx(playerid, -HouseData[houseid][PriceRent]);
							HouseData[houseid][Deposito] = HouseData[houseid][Deposito] + HouseData[houseid][PriceRent];
							SaveHouse(houseid);
							DataUserSave(playerid);
						}
						else
						{
							Error(playerid, "No tienes suficiente dinero para alquilarte en esta Casa!");
						}
					}
					else
					{
						Error(playerid, "Esta casa no esta en renta!");
					}
				}
				else if( PlayersData[playerid][Alquiler] == houseid )
				{
					SendInfoMessage(playerid, 3, "0", "Has salido de este alquiler existosamente!");
					PlayersData[playerid][Alquiler] = -1;
					PlayersData[playerid][House] 	= -1;
					DataUserSave(playerid);
				}
				else
				{
					Error(playerid, "Debe salir del alquiler de la casa donde vive, para poder alquilar esta");
				}
			}
			else
			{
				Error(playerid, "Debe vender su casa, para poder alquilar esta");
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ninguna casa");
		}
		return 1;
	}
	// COMANDO: /Llaves Casa
	else if( strcmp("/Llaves Casa", cmdtext, true, 12) == 0 && strlen(cmdtext) == 12 )
	{
		if( PlayersDataOnline[playerid][InPickupCasa] ||
			PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipo] == PICKUP_TYPE_CASA_TYPE )
		{
			houseid = (PlayersData[playerid][IsPlayerInHouse]) ? (PlayersData[playerid][IsPlayerInHouse]) : (PlayersDataOnline[playerid][InPickupCasa]);

			if( PlayersData[playerid][House] == houseid ||
				PlayersData[playerid][Alquiler] == houseid ||
				IsPlayerInHouseFriend(playerid, houseid) != -1)
			{
				if( HouseData[houseid][Lock] )
				{
					HouseData[houseid][Lock] = false;
					Info(playerid, "Casa abierta");
					GameTextForPlayer(playerid, "~W~Puerta ~G~Abierta!", 1000, 6);
				}
				else
				{
					HouseData[houseid][Lock] = true;
					Info(playerid, "Casa cerrada");
					GameTextForPlayer(playerid, "~W~Puerta ~R~Cerrada!", 1000, 6);
				}
				SaveHouse(houseid);
				PlayPlayerStreamSound(playerid, 1027);
				UpdateLockDoorForPlayer(HouseData[houseid][PickupId], HouseData[houseid][Lock], TypeHouse[HouseData[houseid][TypeHouseId]][PickupId]);
			}
			else
			{
				Error(playerid, "Esta no es su casa");
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ninguna casa");
		}
		return 1;
	}
	// COMANDO: /Llaves Armario
	else if( strcmp("/Llaves Armario", cmdtext, true, 15) == 0 && strlen(cmdtext) == 15 )
	{
		if( PlayersData[playerid][IsPlayerInHouse] )
		{
			if( PlayersData[playerid][House] == PlayersData[playerid][IsPlayerInHouse] ||
					PlayersData[playerid][Alquiler] == PlayersData[playerid][IsPlayerInHouse] ||
					IsPlayerInHouseFriend(playerid, PlayersData[playerid][IsPlayerInHouse]) != -1 )
			{
				if( HouseData[PlayersData[playerid][IsPlayerInHouse]][ArmarioLock] )
				{
					HouseData[PlayersData[playerid][IsPlayerInHouse]][ArmarioLock] = false;
					Info(playerid, "Armario abierto");
					GameTextForPlayer(playerid, "~W~Armario ~G~Abierto!", 1000, 6);
				}
				else
				{
					HouseData[PlayersData[playerid][IsPlayerInHouse]][ArmarioLock] = true;
					Info(playerid, "Armario cerrado");
					GameTextForPlayer(playerid, "~W~Armario ~R~Cerrado!", 1000, 6);
				}
				SaveHouse(PlayersData[playerid][IsPlayerInHouse]);
				PlayPlayerStreamSound(playerid, 1027);
			}
			else
			{
				Error(playerid, "Esta no es su casa");
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ninguna casa");
		}
		return 1;
	}
	// COMANDO: /Llaves Guantera
	else if( strcmp("/Llaves Gaveta", cmdtext, true, 14) == 0 && strlen(cmdtext) == 14 )
	{
		if( PlayersData[playerid][IsPlayerInHouse] )
		{
			if( PlayersData[playerid][House] == PlayersData[playerid][IsPlayerInHouse] ||
					PlayersData[playerid][Alquiler] == PlayersData[playerid][IsPlayerInHouse] ||
					IsPlayerInHouseFriend(playerid, PlayersData[playerid][IsPlayerInHouse]) != -1 )
			{
				if( HouseData[PlayersData[playerid][IsPlayerInHouse]][GavetaLock] )
				{
					HouseData[PlayersData[playerid][IsPlayerInHouse]][GavetaLock] = false;
					Info(playerid, "Gaveta abierta");
					GameTextForPlayer(playerid, "~W~Gaveta ~G~Abierta!", 1000, 6);
				}
				else
				{
					HouseData[PlayersData[playerid][IsPlayerInHouse]][GavetaLock] = true;
					Info(playerid, "Gaveta cerrada");
					GameTextForPlayer(playerid, "~W~Gaveta ~R~Cerrada!", 1000, 6);
				}
				SaveHouseGaveta(PlayersData[playerid][IsPlayerInHouse]);
				PlayPlayerStreamSound(playerid, 1002);
			}
			else
			{
				Error(playerid, "Esta no es su casa");
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ninguna casa");
		}
		return 1;
	}
	// COMANDO: /Llaves Amigos
	else if( strcmp("/Llaves Amigos", cmdtext, true, 14) == 0 && strlen(cmdtext) == 14 )
	{
		if( PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipo] == PICKUP_TYPE_CASA)
		{
			new HouseId = PlayersDataOnline[playerid][InPickupCasa];
			if( IsMyHouse(playerid, HouseId) || PlayersData[playerid][Admin] >= 8)
			{
				ShowHouseFriends(playerid, HouseId);
			}
			else
			{
				Error(playerid, "Esta no es su casa");
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ninguna casa.");
		}
		return true;
	}
	// COMANDO: /Dar Llaves Amigo [ID]
	else if( !strfind(cmdtext, "/Dar Llaves Amigo", true) )
	{
		new getid;
		if( strlen(cmdtext) <= 18 || sscanf(cmdtext[18], "u", getid) ) return SendSyntaxError(playerid, "Dar Llaves Amigo [ID/Nombre]", "Dar Llaves Amigo 12.");
		if( !PlayersDataOnline[playerid][InPickupCasa] ) return Error(playerid, "No te encuentras en ninguna casa");
		new houseID = PlayersDataOnline[playerid][InPickupCasa];
		if( !IsMyHouse(playerid, houseID) ) return Error(playerid, "Esta no es su casa");
		if( !IsPlayerNear(playerid, getid) ) return true;
		if( IsPlayerInHouseFriend(getid, houseID) == -1 )
		{
			AddPlayerHouseFriend(getid, houseID);

			new MsgLlavesCasaMe[128];
			format(MsgLlavesCasaMe, sizeof(MsgLlavesCasaMe), "le da una copia de llaves de su casa a %s", PlayersDataOnline[getid][NameOnlineFix]);
			Acciones(playerid, 8, MsgLlavesCasaMe);

			Importante(playerid, "Le diste una copia de las llaves de tu casa a %s (( /Llaves Amigos ))", PlayersDataOnline[getid][NameOnlineFix]);
			Importante(getid, "%s te dio una copia de las llaves de su casa", PlayersDataOnline[playerid][NameOnlineFix]);
		}
		else
		{
			Error(playerid, "Ya este jugador tiene las llaves de tu casa");
		}
		return 1;
	}
	// COMANDO: /Cambiar Precio Alquiler [Nuevo_Precio]
	else if( !strfind(cmdtext, "/Cambiar Precio Alquiler", true) )
	{
		if( strlen(cmdtext) <= 25 ) return SendSyntaxError(playerid, "Cambiar Precio Alquiler [Precio (0 = No se renta)]", "Cambiar Precio Alquiler 1500");
		new priceRentC = strval(cmdtext[25]);
		if( !PlayersDataOnline[playerid][InPickupCasa] ) return Error(playerid, "No te encuentras en ninguna casa");
		houseid = PlayersDataOnline[playerid][InPickupCasa];
		
		if( !IsMyHouse(playerid, houseid) ) return Error(playerid, "Esta no es su casa");
		if( 0 <= priceRentC <= 20000)
		{
			if( HouseData[houseid][PriceRent] == priceRentC ){
				if( !priceRentC ) return Error(playerid, "Ya su casa no esta en renta! Use \"/Cambiar Precio Alquier\" para arrendarla");
				else return Error(playerid, "Ya su casa tiene ese precio de alquiler!");
			}
			HouseData[houseid][PriceRent] = priceRentC;
			SaveHouse(houseid); UpdateHouse(houseid);
			if( !priceRentC )
			{
				new count;
				for ( new i, j=GetPlayerPoolSize(); i <= j; i++)
				{
					if( i != playerid && IsPlayerLogued(i) && PlayersData[i][Alquiler] == PlayersData[playerid][House] )
					{
						PlayersData[i][Alquiler] = -1;
						PlayersData[i][House] = -1;
						DataUserSave(i);
						Importante(i, "Ha sido desalojado de su alquiler!");
						count++;
					}
				}
				new Cache:cacheid, query[200];
				mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET House=-1,Alquiler=-1 WHERE Alquiler=%d;", DIR_USERS, PlayersData[playerid][House]);
				cacheid = mysql_query(dataBase, query);
				count += cache_affected_rows();
				cache_delete(cacheid);
				if( count ) Importante(playerid, "Ahora su casa ya no esta en renta, se desalojaron a %i arrendadores", count);
				else Importante(playerid, "Ahora su casa ya no esta en renta");
			}
			else Importante(playerid, "Has modificado el precio de alquiler de la casa");
		}
		else
		{
			Error(playerid, "El precio de alquiler minimo es $1 y maximo $20000 (0 = No se renta)");
		}
		return 1;
	}
	// COMANDO: /Retirar Casa
	else if( strcmp("/Retirar Casa", cmdtext, true, 13) == 0 && strlen(cmdtext) == 13 )
	{
		if( PlayersDataOnline[playerid][InPickupCasa] )
		{
			houseid = PlayersDataOnline[playerid][InPickupCasa];
			if( IsMyHouse(playerid, houseid) )
			{
				if( HouseData[houseid][Deposito] > 0 )
				{
					GivePlayerMoneyEx(playerid, HouseData[houseid][Deposito]);

					Importante(playerid, "Has retirado $%i de ganancias de el alquiler", HouseData[houseid][Deposito]);
					HouseData[houseid][Deposito] = 0;
					SaveHouse(houseid);
				}
				else
				{
					Error(playerid, "No hay dinero para retirar del alquiler");
				}
			}
			else
			{
				Error(playerid, "Esta no es su casa");
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ninguna casa");
		}
		return 1;
	}
	// COMANDO: /Consultar Extorsion
	else if( strcmp("/Consultar Casa", cmdtext, true, 15) == 0 && strlen(cmdtext) == 15 )
	{
		if( PlayersDataOnline[playerid][InPickupCasa] )
		{
			houseid = PlayersDataOnline[playerid][InPickupCasa];
			if( IsMyHouse(playerid, houseid) )
			{
				new MsgCasaConsultar[MAX_TEXT_CHAT];
				format(MsgCasaConsultar, sizeof(MsgCasaConsultar), "Tiene $%i ganancias de alquiler en la casa", HouseData[houseid][Deposito]);
				SendInfoMessage(playerid, 1, " ", "|___________________ Casa ___________________|");
				SendInfoMessage(playerid, 1, MsgCasaConsultar, "Casa: ");
				SendInfoMessage(playerid, 1, " ", "|_____________________ Fin ____________________|");
			}
			else
			{
				Error(playerid, "Esta no es su casa");
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ninguna casa");
		}
		return 1;
	}
	else if( strcmp("/Comprar Casa", cmdtext, true, 13) == 0 && strlen(cmdtext) == 13 )
	{
		if( PlayersDataOnline[playerid][InPickupCasa] )
		{
			new HouseId = PlayersDataOnline[playerid][InPickupCasa];
			if( strlen(HouseData[HouseId][Dueno]) == 2 )
			{
				if( PlayersData[playerid][House] == -1 && PlayersData[playerid][Alquiler] == -1 )
				{
					if( PlayersData[playerid][Dinero] >= HouseData[HouseId][Price] )
					{
						format(HouseData[HouseId][Dueno], MAX_PLAYER_NAME, "%s", PlayersDataOnline[playerid][NameOnline]);
						SaveHouse(HouseId); UpdateHouse(HouseId);
						GivePlayerMoneyEx(playerid, -HouseData[HouseId][Price]);
						GameTextForPlayer(playerid, "~B~Has ~G~comprado una Casa!", 2000, 0);
						Importante(playerid, "Compraste una casa tipo \"%s\" por $%d", TypeHouse[ HouseData[HouseId][TypeHouseId] ][TypeName], HouseData[HouseId][Price]);
						printf("%s[%d-%d] compro la casa id %d, Tipo: \"%s\"[%d], Precio: $%d", PlayersDataOnline[playerid][NameOnline], PlayersData[playerid][DB_ID], playerid, HouseId, TypeHouse[ HouseData[HouseId][TypeHouseId] ][TypeName], HouseData[HouseId][TypeHouseId], HouseData[HouseId][Price]);
						PlayersData[playerid][House] = HouseId;
						PlayersData[playerid][Alquiler] = -1;
						DataUserSave(playerid);
					}
					else
					{
						Error(playerid, "No tienes suficiente dinero para comprar esta Casa!");
					}
				}
				else
				{
					Error(playerid, "Debe vender o salir de su actual alquiler de la casa donde vive, para poder comprar esta");
				}
			}
			else
			{
				Error(playerid, "Esta casa ya tiene dueño");
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ninguna casa");
		}
		return 1;
	}
	// COMANDO: /Vender Casa
	else if( strcmp("/Vender Casa", cmdtext, true, 12) == 0 && strlen(cmdtext) == 12 )
	{
		if( PlayersDataOnline[playerid][InPickupCasa] )
		{
			new HouseId = PlayersDataOnline[playerid][InPickupCasa];
			if( IsMyHouse(playerid, HouseId) )
			{
				PlayersDataOnline[playerid][MyPickupLock] = true;
				format(HouseData[HouseId][Dueno], MAX_PLAYER_NAME, "No");
				HouseData[HouseId][Lock] = true;
				SaveHouse(HouseId); UpdateHouse(HouseId);
				GivePlayerMoneyEx(playerid, HouseData[HouseId][Price]);
				GameTextForPlayer(playerid, "~B~Ha ~R~vendido su casa!", 2000, 0);
				Importante(playerid, "Vendiste tu casa por $%d", HouseData[HouseId][Price]);
				printf("%s[%d-%d] vendio su casa id %d, Tipo: \"%s\"[%d], Precio: $%d", PlayersDataOnline[playerid][NameOnline], PlayersData[playerid][DB_ID], playerid, HouseId, TypeHouse[ HouseData[HouseId][TypeHouseId] ][TypeName], HouseData[HouseId][TypeHouseId], HouseData[HouseId][Price]);
				PlayersData[playerid][House] = -1;
				PlayersData[playerid][Alquiler] = -1;
				DataUserSave(playerid);

				for ( new i = 0; i < MAX_PLAYERS; i++)
				{
					CheckIsPlayerRentAndRemove(i, HouseId);
				}
				RemoveAllHouseFriend(HouseId);
			}
			else
			{
				Error(playerid, "Esta no es su casa");
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ninguna casa");
		}
		return 1;
	}
	//////////--- /CPos [ID]              - CAMBIAR LA POSICION DE UNA CASA
	else if( !strfind(cmdtext, "/CPos", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		if( strlen(cmdtext) <= 6 ) return SendSyntaxError(playerid, "CPos [ID_Casa]", "CPos 1");
		new houseID = strval(cmdtext[6]);
		if( 0 < houseID < MAX_HOUSE_COUNT )
		{
			if( !HouseData[houseID][PosX] ) return Error(playerid, "El ID de casa introducido no existe!");
			if( GetPlayerInterior(playerid) || GetPlayerVirtualWorld(playerid) ) return Error(playerid, "Debe de estar en el exterior para usar este comando!");
			new Float:PlayerPosHouse[4];
			GetPlayerPos(playerid, PlayerPosHouse[0], PlayerPosHouse[1], PlayerPosHouse[2]);
			GetPlayerFacingAngle(playerid, PlayerPosHouse[3]);
			HouseData[houseID][PosX] = PlayerPosHouse[0];
			HouseData[houseID][PosY] = PlayerPosHouse[1];
			HouseData[houseID][PosZ] = PlayerPosHouse[2];
			HouseData[houseID][PosZZ] = PlayerPosHouse[3];
			SaveHouse(houseID); UpdateHouse(houseID);

			ImportanteEx(playerid, "Cambiaste la posicion de la casa %d a la: ( X: %.2f Y: %.2f Z: %.2f ZZ: %.2f )", houseID, PlayerPosHouse[0], PlayerPosHouse[1], PlayerPosHouse[2], PlayerPosHouse[3]);
			printf("%s[%d-%d] cambio la posicion de la casa %d a la: ( X: %.2f Y: %.2f Z: %.2f ZZ: %.2f )", PlayersDataOnline[playerid][NameOnline], PlayersData[playerid][DB_ID], playerid, houseID, PlayerPosHouse[0], PlayerPosHouse[1], PlayerPosHouse[2], PlayerPosHouse[3]);
		}
		else
		{
			Error(playerid, "ID de casa invalida!");
		}
		return 1;
	}
	//////////--- /Cprecio [ID]              - CAMBIAR EL PRECIO DE UNA CASA
	else if( !strfind(cmdtext, "/Cprecio", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		if( strlen(cmdtext) < 9 ) return SendSyntaxError(playerid, "CPrecio [Precio]", "Cprecio 150000");
		new cPrecio = strval(cmdtext[9]);
		if( cPrecio < 0 || cPrecio > 1000000 ) return Error(playerid, "El precio de la casa introducído tiene que estar entre $0 y $1000000");
		houseid = PlayersDataOnline[playerid][InPickupCasa];
		if( !houseid ) return Error(playerid, "No te encuentras en ninguna casa");

		ImportanteEx(playerid, "Cambiaste el precio de esta casa a: $%d. Antes: $%d", cPrecio, HouseData[houseid][Price]);
		HouseData[houseid][Price] = cPrecio;
		SaveHouse(houseid); UpdateHouse(houseid);
		return 1;
	}
	//////////--- /Cnivel [ID]              - CAMBIAR EL NIVEL DE UNA CASA
	else if( strfind(cmdtext, "/Cnivel ", true) == 0 )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 7 ) return SendAccessError(playerid, "CNivel");
		if( PlayersDataOnline[playerid][InPickupCasa] )
		{
			houseid = PlayersDataOnline[playerid][InPickupCasa];

			if( strval(cmdtext[8]) >= 0 && strval(cmdtext[8]) <= 50 )
			{
				HouseData[houseid][Level] = strval(cmdtext[8]);
				new MsgChangeType[MAX_TEXT_CHAT];
				format(MsgChangeType, sizeof(MsgChangeType), "Cambiaste el nivel a esta casa a: %i", strval(cmdtext[8]));
				SendInfoMessage(playerid, 2, "0", MsgChangeType);
				Info(playerid, "Comando deshabilitado proximamente");

				SaveHouse(houseid); UpdateHouse(houseid);
			}
			else
			{
				Error(playerid, "El nivel de casa introducído tiene que estar entre 0 y 50");
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ninguna casa");
		}	
		return 1;
	}
	//////////--- /Ctipo [ID]              - CAMBIAR/VER EL TIPO DE UNA CASA
	else if( strfind(cmdtext, "/Ctipo", true) == 0 )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext);
		if( strlen(cmdtext) < 7 ) return SendSyntaxError(playerid, "CTipo [ID]", "CTipo 0");
		new cTipo = strval(cmdtext[7]);
		if( cTipo < 0 || cTipo > MAX_HOUSE_TYPE ){
			Error(playerid, "El numero del tipo de casa debe estar comprendido entre 0 y %d", MAX_HOUSE_TYPE);
			ShowHouseTypes(playerid);
			return 1;
		}
		if( PlayersDataOnline[playerid][InPickupCasa] )
		{
			houseid = PlayersDataOnline[playerid][InPickupCasa];
			if( HouseData[houseid][TypeHouseId] == cTipo ) return Error(playerid, "Ya esta casa es del mismo tipo!");
			ImportanteEx(playerid, "Cambiaste el tipo de esta casa a tipo \"%s\" [%d]. Antes: \"%s\" [%d]", TypeHouse[cTipo][TypeName], cTipo, TypeHouse[ HouseData[houseid][TypeHouseId] ][TypeName], HouseData[houseid][TypeHouseId]);
			printf("%s[%d-%d] cambio el tipo de la casa %d a tipo \"%s\" [%d]. Antes: \"%s\" [%d]", PlayersDataOnline[playerid][NameOnline], PlayersData[playerid][DB_ID], playerid, houseid, TypeHouse[cTipo][TypeName], cTipo, TypeHouse[ HouseData[houseid][TypeHouseId] ][TypeName], HouseData[houseid][TypeHouseId]);
			HouseData[houseid][TypeHouseId] = cTipo;
			RemoveAllGarage(houseid);
			SaveHouse(houseid); UpdateHouse(houseid);
		}
		else
		{
			SetPlayerInteriorEx(playerid, TypeHouse[cTipo][Interior]);
			SetPlayerVirtualWorldEx(playerid, 0);
			SetPlayerPos(playerid, TypeHouse[cTipo][PosX], TypeHouse[cTipo][PosY], TypeHouse[cTipo][PosZ]);
			SetPlayerFacingAngle(playerid, TypeHouse[cTipo][PosZZ]);
			Advise(playerid, "Fuiste al tipo de casa \"%s\" [%d]. Use este comando en la puerta de una, para cambiar su interior", TypeHouse[cTipo][TypeName], cTipo);
		}
		return 1;
	}
	//////////--- /VCasa              - VENDER UNA CASA
	else if( strcmp("/VCasa", cmdtext, true, 6) == 0 && strlen(cmdtext) == 6 )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] >= 8 )
		{
			if( PlayersDataOnline[playerid][InPickupCasa] )
			{
				houseid = PlayersDataOnline[playerid][InPickupCasa];
				if( strlen(HouseData[houseid][Dueno]) != 2 )
				{
					ImportanteEx(playerid, "Has vendido esta casa al estado, erá propiedad de %s", HouseData[houseid][Dueno]);
					RemoveDuenoOfHouse(houseid);
				}
				else
				{
					Error(playerid, "Esta casa no tiene dueño");
				}
			}
			else
			{
				Error(playerid, "No te encuentras en ninguna casa");
			}
		}
		else
		{
			Error(playerid, "No tienes acceso al comando /Vcasa");
		}
		return 1;
	}
	//			/IrCa [ID]					- Ir a una casa
	else if( !strfind(cmdtext, "/IrCa", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if(PlayersData[playerid][Admin] < 7) return SendAccessError(playerid, cmdtext);
		if( strlen(cmdtext) < 6 ) return SendSyntaxError(playerid, "IrCa", "IrCa [ID_Casa]");
		new houseID = strval(cmdtext[GetPosSpace(cmdtext, 1)]);
		if( 0 < houseID < MAX_HOUSE_COUNT )
		{
			if(!HouseData[houseID][PosX]) return Error(playerid, "El ID de casa introducido no existe!");
			SetPlayerInteriorEx(playerid, 0);
			SetPlayerVirtualWorldEx(playerid, 0);
			ChangeHouseOrOther(playerid, 0);
			SetPlayerPos(playerid, HouseData[houseID][PosX], HouseData[houseID][PosY], HouseData[houseID][PosZ]);
			SetPlayerFacingAngle(playerid, HouseData[houseID][PosZZ]);
			Advise(playerid, "Fuiste a la casa %d", houseID);
		}
		else
		{
			Error(playerid, "ID de casa invalida!");
		}
		return 1;
	}
	else if( !strcmp("/Borrar Casa", cmdtext, true) ){
		if(PlayersData[playerid][Admin] < 9) return SendAccessError(playerid, "Borrar Casa");
		new h = PlayersDataOnline[playerid][InPickupCasa];
		if(!h) return Error(playerid, "No te encuentras en la puerta de ninguna casa");

		ImportanteEx(playerid, "Borraste la casa ID %d, Tipo: \"%s\" [%i], Precio: %d", h, TypeHouse[HouseData[h][TypeHouseId]][TypeName], HouseData[h][TypeHouseId], HouseData[h][Price]);

		if( strlen(HouseData[h][Dueno]) != 2 )
		{
			RemoveDuenoOfHouse(h);
		}
		ClearHouseData(h);
		return true;
	}
	// COMANDO: /Info Casa
	else if( strcmp("/Info Casa", cmdtext, true, 10) == 0 && strlen(cmdtext) == 10 )
	{
		if( PlayersDataOnline[playerid][InPickupCasa] )
		{
			houseid = PlayersDataOnline[playerid][InPickupCasa];
			if( IsMyHouse(playerid, houseid) || PlayersData[playerid][Admin] >= 7)
			{
				new MsgInfoCasa[4][MAX_TEXT_CHAT];
				format(MsgInfoCasa[0], MAX_TEXT_CHAT, "(( ID de la Casa: %i Tipo: %i))", houseid, HouseData[houseid][TypeHouseId]);
				format(MsgInfoCasa[1], MAX_TEXT_CHAT, "Precio Alquiler: $%i (0  = Deshabilitado)", HouseData[houseid][PriceRent]);
				format(MsgInfoCasa[2], MAX_TEXT_CHAT, "Dinero del Alquiler: $%i", HouseData[houseid][Deposito]);
				format(MsgInfoCasa[3], MAX_TEXT_CHAT, "Precio de la Casa: $%i", HouseData[houseid][Price]);

				SendInfoMessage(playerid, 1, " ", "|____________________ Casa ___________________|");
				SendInfoMessage(playerid, 1, MsgInfoCasa[0], "Casa: ");
				SendInfoMessage(playerid, 1, MsgInfoCasa[1], "Casa: ");
				SendInfoMessage(playerid, 1, MsgInfoCasa[2], "Casa: ");
				SendInfoMessage(playerid, 1, MsgInfoCasa[3], "Casa: ");
				SendInfoMessage(playerid, 1, " ", "|_____________________ Fin ____________________|");
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ninguna casa");
		}
		return 1;
	}
	// COMANDO: /Armario
	else if( strcmp("/Armario", cmdtext, true, 8) == 0 && strlen(cmdtext) == 8 )
	{
		if( PlayersData[playerid][IsPlayerInHouse] )
		{
			new HouseId = PlayersData[playerid][IsPlayerInHouse];
			if( IsOpenCloset(playerid, HouseId) )
			{
				new MsgsArmario[MAX_TEXT_CHAT];
				Acciones(playerid, 8, "mira hacia dentro del armario");
				SendClientMessage(playerid, COLOR_MALETERO_ARMARIO_CAJA_FUERTE, ">>>>>>>>>> .:Armario:. <<<<<<<<<");
				for (new i = 0; i < 7; i++)
				{
					if( HouseData[HouseId][ArmarioWeapon][i] == 0 )
					{
						format(MsgsArmario, sizeof(MsgsArmario), "** Armario Slot %i: Vacío", i + 1);
					}
					else
					{
						format( MsgsArmario, sizeof(MsgsArmario), "** Armario Slot %i: %s ::: Municion: %i", i + 1, SlotNameWeapon[HouseData[HouseId][ArmarioWeapon][i]],
						HouseData[HouseId][ArmarioAmmo][i] );
					}
					SendClientMessage(playerid, COLOR_MALETERO_ARMARIO_CAJA_FUERTE,
					MsgsArmario);
				}
				format(MsgsArmario, sizeof(MsgsArmario), "** Armario Chaleco: %.2f | Drogas: %i | Ganzuas: %i | Materiales: %i | Bombas: %i",
				HouseData[HouseId][Chaleco],
				HouseData[HouseId][Drogas],
				HouseData[HouseId][Ganzuas],
				HouseData[HouseId][Materiales],
				HouseData[HouseId][Bombas]);

				SendClientMessage(playerid, COLOR_MALETERO_ARMARIO_CAJA_FUERTE,
				MsgsArmario);
				PlayerPlaySound(playerid, 1002);
			}
		}
		else
		{
			Error(playerid, "No se encuentra dentro de una casa");
		}
		return true;
	}
	// COMANDO: /Gaveta
	else if( strcmp("/Gaveta", cmdtext, true, 7) == 0 && strlen(cmdtext) == 7 )
	{
		if( PlayersData[playerid][IsPlayerInHouse] )
		{
			new Houseid = PlayersData[playerid][IsPlayerInHouse];
			if( IsOpenGaveta(playerid, Houseid) )
			{
				new MsgGaveta[MAX_TEXT_CHAT];
				Acciones(playerid, 8, "mira dentro de la gaveta");
				SendClientMessage(playerid, COLOR_MALETERO_ARMARIO_CAJA_FUERTE, ">>>>>>>>>> .:Gaveta:. <<<<<<<<<");
				for (new i = 0; i < MAX_GUANTERA_GAVETA_SLOTS; i++)
				{
					if( !HouseData[Houseid][GavetaObjects][i] )
					{
						format(MsgGaveta, sizeof(MsgGaveta), "** Gaveta Slot %i: %s", i + 1, ObjectsNames[0]);
					}
					else
					{
						format( MsgGaveta, sizeof(MsgGaveta), "** Gaveta Slot %i: %s", i + 1, ObjectsNames[GetTypeObjectEx(HouseData[Houseid][GavetaObjects][i])]);
					}
					SendClientMessage(playerid, COLOR_MALETERO_ARMARIO_CAJA_FUERTE,	MsgGaveta);
				}
				PlayerPlaySound(playerid, 1002);
			}
		}
		else
		{
			Error(playerid, "No se encuentra dentro de una casa");
		}
		return true;
	}
	return 0;
}

OnPlayerCommandArmarioHouse(playerid, const cmdtext[], houseID)
{
	// COGER CASAS
	if( !strfind(cmdtext, "/Coger ", true) )
	{
		// COMANDO: /Coger Chaleco
		if( strcmp("/Coger Chaleco", cmdtext, true, 14) == 0 && strlen(cmdtext) == 14 )
		{
			if( IsOpenCloset(playerid, houseID) )
			{
				if( HouseData[houseID][Chaleco] != 0 )
				{
					SetPlayerArmourEx(playerid, HouseData[houseID][Chaleco]);
					HouseData[houseID][Chaleco] = 0;
					SaveHouse(houseID);
					Acciones(playerid, 8, "ha cogido un chaleco del armario");
					Info(playerid, "Has cogido un chaleco del armario.");
				}
				else
				{
					Error(playerid, "En el armario no hay ningun chaleco.");
				}
			}
			return true;
		}
		// COMANDO: /Coger Arma
		else if( strcmp("/Coger Arma", cmdtext, true, 11) == 0 && strlen(cmdtext) == 11 )
		{
			if( IsOpenCloset(playerid, houseID) )
			{
				new EmpySlot = -1;
				for (new i = 0; i < 7; i++)
				{
					if( HouseData[houseID][ArmarioWeapon][i] != 0 )
					{
						EmpySlot = i;
						break;
					}
				}
				if( CheckWeapondCheat(playerid) && EmpySlot != -1 )
				{
					GivePlayerWeaponEx(playerid, HouseData[houseID][ArmarioWeapon][EmpySlot], HouseData[houseID][ArmarioAmmo][EmpySlot]);
					HouseData[houseID][ArmarioWeapon][EmpySlot] = 0;
					HouseData[houseID][ArmarioAmmo][EmpySlot] = 0;
					SaveHouseWeaponEx(houseID, EmpySlot);

					new MsgCogerMe[MAX_TEXT_CHAT];
					format(MsgCogerMe, sizeof(MsgCogerMe), "ha cogido %s del armario", SlotNameWeapon[HouseData[houseID][ArmarioWeapon][EmpySlot]]);
					Acciones(playerid, 8, MsgCogerMe);
					Info(playerid, "Has cogido un %s del armario.", SlotNameWeapon[HouseData[houseID][ArmarioWeapon][EmpySlot]]);
				}
				else
				{
					Error(playerid, "El armario se encuentra vacío!");
				}
			}
			return true;
		}
		// COMANDO: /Coger ArmaEx [ID_Slot]
		else if( !strfind(cmdtext, "/Coger ArmaEx", true) )
		{
			if( strlen(cmdtext) < 14 ) return SendSyntaxError(playerid, "/Coger ArmaEx [ID_Slot]", "Coger ArmaEx 4");
			new slotID = strval(cmdtext[14]);
			if( IsOpenCloset(playerid, houseID) )
			{
				if( slotID >= 1 && slotID <= 7 )
				{
					if( CheckWeapondCheat(playerid) && HouseData[houseID][ArmarioWeapon][slotID - 1] != 0 )
					{
						slotID--;
						GivePlayerWeaponEx(playerid, HouseData[houseID][ArmarioWeapon][slotID], HouseData[houseID][ArmarioAmmo][slotID]);
						HouseData[houseID][ArmarioWeapon][slotID] = 0;
						HouseData[houseID][ArmarioAmmo][slotID] = 0;
						SaveHouseWeaponEx(houseID, slotID);
						new MsgCogerMe[128];
						format(MsgCogerMe, sizeof(MsgCogerMe), "ha cogido %s del armario", SlotNameWeapon[HouseData[houseID][ArmarioWeapon][slotID]]);
						Acciones(playerid, 8, MsgCogerMe);
						Info(playerid, "Has cogido %s del armario.", SlotNameWeapon[HouseData[houseID][ArmarioWeapon][slotID]]);
					}
					else
					{
						Error(playerid, "El Slot numero \"%d\" esta vacio", slotID );
					}
				}
				else
				{
					Error(playerid, "La ID de el Slot a coger el arma tiene que estar comprendia entre 1 y 7");
				}
			}
			return true;
		}
		// COMANDO: /Coger Drogas [Cantidad]
		else if( !strfind(cmdtext, "/Coger Drogas", true) )
		{
			if( strlen(cmdtext) < 14 ) return SendSyntaxError(playerid, "Coger Drogas [Cantidad]", "Coger Drogas 1");
			new amount = strval(cmdtext[14]);
			if( IsOpenCloset(playerid, houseID) )
			{
				if( amount > 0 && HouseData[houseID][Drogas] >= amount )
				{
					PlayersData[playerid][Drogas] = PlayersData[playerid][Drogas] + amount;
					HouseData[houseID][Drogas] = HouseData[houseID][Drogas] - amount;
					SaveHouse(houseID);

					Acciones(playerid, 8, "ha cogido drogas del armario");
					Info(playerid, "Has cogido %i drogas del armario.", amount);
				}
				else
				{
					Error(playerid, "El armario no tiene esa cantidad de drogas a coger!");
				}
			}
			return true;
		}
		// COMANDO: /Coger Ganzuas [Cantidad]
		else if( !strfind(cmdtext, "/Coger Ganzuas", true) )
		{
			if( strlen(cmdtext) < 15 ) return SendSyntaxError(playerid, "Coger Ganzuas [Cantidad]", "Coger Ganzuas 1");
			new amount = strval(cmdtext[15]);
			if( IsOpenCloset(playerid, houseID) )
			{
				if( amount > 0 && HouseData[houseID][Ganzuas] >= amount )
				{
					PlayersData[playerid][Ganzuas] = PlayersData[playerid][Ganzuas] + amount;
					HouseData[houseID][Ganzuas] = HouseData[houseID][Ganzuas] - amount;
					SaveHouse(houseID);
					
					Acciones(playerid, 8, "ha cogido ganzuas del armario");
					Info(playerid, "Has cogido %i ganzuas del armario.", amount);
				}
				else
				{
					Error(playerid, "El armario no tiene esa cantidad de ganzuas a coger!");
				}
			}
			return true;
		}
		// COMANDO: /Coger Materiales [Cantidad]
		else if( !strfind(cmdtext, "/Coger Materiales", true) )
		{
			if( strlen(cmdtext) < 18 ) return SendSyntaxError(playerid, "Coger Materiales [Cantidad]", "Coger Materiales 1");
			new amount = strval(cmdtext[18]);
			if( IsOpenCloset(playerid, houseID) )
			{
				if( amount > 0 && HouseData[houseID][Materiales] >= amount )
				{
					if( IsNotFullMaterialsPlayer(playerid, amount) )
					{
						PlayersData[playerid][Materiales] = PlayersData[playerid][Materiales] + amount;
						HouseData[houseID][Materiales] = HouseData[houseID][Materiales] - amount;
						SaveHouse(houseID);

						Acciones(playerid, 8, "ha cogido materiales del armario");
						Info(playerid, "Has cogido %i materiales del armario.", amount);
					}
					else
					{
						Error(playerid, "No puedes cargar esa cantidad de materiales encima! Recuerda que el maximo es 2500");
					}
				}
				else
				{
					Error(playerid, "El almacen no tiene esa cantidad de materiales a coger!");
				}
			}
			return true;
		}
		// COMANDO: /Coger Bombas [Cantidad]
		else if( !strfind(cmdtext, "/Coger Bombas", true) )
		{
			if( strlen(cmdtext) < 14 ) return SendSyntaxError(playerid, "Coger Bombas [Cantidad]", "Coger Bombas 1");
			new amount = strval(cmdtext[14]);
			if( IsOpenCloset(playerid, houseID) )
			{
				if( HouseData[houseID][Bombas] > 0 && HouseData[houseID][Bombas] >= amount )
				{
					PlayersData[playerid][Bombas] = PlayersData[playerid][Bombas] + amount;
					HouseData[houseID][Bombas] = HouseData[houseID][Bombas] - amount;
					SaveHouse(houseID);

					Acciones(playerid, 8, "ha cogido bombas del armario");
					Info(playerid, "Has cogido %i bombas del armario.", amount);
				}
				else
				{
					Error(playerid, "El armario no tiene esa cantidad de bombas a coger!");
				}
			}
			return true;
		}
		else{
			Error(playerid, "Quizas quiso decir: /Coger {Arma, ArmaEx [ID_SLOT], Chaleco, Drogas [Cantidad], Bombas [Cantidad], Ganzuas [Cantidad]}");
			Error(playerid, "Quizas quiso decir: /Coger {Materiales [Cantidad], Articulo [ID_Refrigerador], Objeto, ObjetoEx [ID_SLOT]}");
		}
	}
	// DEJAR CASAS
	else if( strfind(cmdtext, "/Dejar ", true) == 0 )
	{
		// COMANDO: /Dejar Chaleco
		if( strcmp("/Dejar Chaleco", cmdtext, true, 14) == 0 && strlen(cmdtext) == 14 )
		{
			if( IsOpenCloset(playerid, houseID) )
			{
				new Float:Chaleco1;
				GetPlayerArmour(playerid, Chaleco1);
				if( Chaleco1 != 0.0 )
				{
					HouseData[houseID][Chaleco] = PlayersData[playerid][Chaleco];
					SaveHouse(houseID);
					SetPlayerArmourEx(playerid, -Chaleco1);
					Acciones(playerid, 8, "ha dejado un chaleco en el armario");
					Info(playerid, "Has dejado un chaleco en el armario");
				}
				else
				{
					Error(playerid, "Usted no tienes ningun chaleco puesto encima.");
				}
			}
			return true;
		}
		// COMANDO: /Dejar Arma
		else if( strcmp("/Dejar Arma", cmdtext, true, 11) == 0 && strlen(cmdtext) == 11 )
		{
			if( IsOpenCloset(playerid, houseID) )
			{
				new MyWeapons, MyAmmo; MyWeapons = GetPlayerWeapon(playerid); MyAmmo = GetPlayerAmmo(playerid);
				if( MyWeapons != 0 )
				{
					new EmpySlot = -1;
					for (new i = 0; i < 7; i++)
					{
						if( HouseData[houseID][ArmarioWeapon][i] == 0 )
						{
							EmpySlot = i;
							break;
						}
					}
					if( EmpySlot != -1 )
					{
						HouseData[houseID][ArmarioWeapon][EmpySlot] = MyWeapons;
						HouseData[houseID][ArmarioAmmo][EmpySlot] 	= MyAmmo;
						SaveHouseWeaponEx(houseID, EmpySlot);
						RemovePlayerWeapond(playerid, MyWeapons);

						new MsgDejarMe[MAX_TEXT_CHAT];
						format(MsgDejarMe, sizeof(MsgDejarMe), "ha dejado %s en el armario", SlotNameWeapon[MyWeapons]);
						Acciones(playerid, 8, MsgDejarMe);
						Info(playerid, "Has dejado un %s en el armario", SlotNameWeapon[MyWeapons]);
					}
					else
					{
						Error(playerid, "El armario se encuentra lleno!");
					}
				}
				else
				{
					Error(playerid, "No tienes un arma en las manos!");
				}
			}
			return true;
		}
		// COMANDO: /Dejar ArmaEx [ID_Slot]
		else if( !strfind(cmdtext, "/Dejar ArmaEx", true) )
		{
			if( strlen(cmdtext) < 14 ) return SendSyntaxError(playerid, "/Dejar ArmaEx [ID_SLOT]", "Dejar ArmaEx 4");
			new slotID = strval(cmdtext[14]);
			if( IsOpenCloset(playerid, houseID) )
			{
				new MyWeapons, MyAmmo; MyWeapons = GetPlayerWeapon(playerid); MyAmmo = GetPlayerAmmo(playerid);
				if( MyWeapons != 0 )
				{
					if( slotID >= 1 && slotID <= 7 )
					{
						if( HouseData[houseID][ArmarioWeapon][slotID - 1] == 0 )
						{
							slotID--;
							HouseData[houseID][ArmarioWeapon][slotID] = MyWeapons;
							HouseData[houseID][ArmarioAmmo][slotID] = MyAmmo;
							SaveHouseWeaponEx(houseID, slotID);
							RemovePlayerWeapond(playerid, MyWeapons);

							new MsgDejarMe[128];
							format(MsgDejarMe, sizeof(MsgDejarMe), "ha dejado %s en el armario", SlotNameWeapon[MyWeapons]);
							Acciones(playerid, 8, MsgDejarMe);
							Info(playerid, "Has dejado un %s en el armario", SlotNameWeapon[MyWeapons]);
						}
						else
						{
							Error(playerid, "El Slot numero \"%d\" ya esta ocupado por otra arma", slotID);
						}
					}
					else
					{
						Error(playerid, "La ID de el Slot a dejar el arma tiene que estar comprendia entre 1 y 7");
					}
				}
				else
				{
					Error(playerid, "No tienes un arma en las manos!");
				}
			}
			return true;
		}
		// COMANDO: /Dejar Drogas [Cantidad]
		else if( !strfind(cmdtext, "/Dejar Drogas", true) )
		{
			if( strlen(cmdtext) < 14 ) return SendSyntaxError(playerid, "Dejar Drogas [Cantidad]", "Dejar Drogas 1");
			new amount = strval(cmdtext[14]);
			if( IsOpenCloset(playerid, houseID) )
			{
				if( amount > 0 && PlayersData[playerid][Drogas] >= amount )
				{
					HouseData[houseID][Drogas] = HouseData[houseID][Drogas] + amount;
					SaveHouse(houseID);
					PlayersData[playerid][Drogas] = PlayersData[playerid][Drogas] - amount;
					Acciones(playerid, 8, "ha dejado drogas en el armario");
					Info(playerid, "Has dejado %i drogas en el armario", amount);
				}
				else
				{
					Error(playerid, "No tienes esa cantidad de drogas para dejar!");
				}
			}
			return true;
		}
		// COMANDO: /Dejar Ganzuas [Cantidad]
		else if( !strfind(cmdtext, "/Dejar Ganzuas", true) )
		{
			if( strlen(cmdtext) < 15 ) return SendSyntaxError(playerid, "Dejar Ganzuas [Cantidad]", "Dejar Ganzuas 1");
			new amount = strval(cmdtext[15]);
			if( IsOpenCloset(playerid, houseID) )
			{
				if( amount> 0 && PlayersData[playerid][Ganzuas] >= amount )
				{
					HouseData[houseID][Ganzuas] = HouseData[houseID][Ganzuas] + amount;
					SaveHouse(houseID);
					PlayersData[playerid][Ganzuas] = PlayersData[playerid][Ganzuas] - amount;
					Acciones(playerid, 8, "ha dejado ganzuas en el armario");
					Info(playerid, "Has dejado %i ganzuas en el armario.", amount);
				}
				else
				{
					Error(playerid, "No tienes esa cantidad de ganzuas para dejar!");
				}
			}
			return true;
		}
		// COMANDO: /Dejar Materiales [Cantidad]
		else if( !strfind(cmdtext, "/Dejar Materiales", true) )
		{
			if( strlen(cmdtext) < 18 ) return SendSyntaxError(playerid, "Dejar Materiales [Cantidad]", "Dejar Materiales 1");
			new amount = strval(cmdtext[18]);
			if( IsOpenCloset(playerid, houseID) )
			{
				if( amount > 0 && PlayersData[playerid][Materiales] >= amount )
				{
					HouseData[houseID][Materiales] = HouseData[houseID][Materiales] + amount;
					SaveHouse(houseID);
					PlayersData[playerid][Materiales] = PlayersData[playerid][Materiales] - amount;
					Acciones(playerid, 8, "ha dejado materiales en el armario");
					Info(playerid, "Has dejado %i materiales en el armario.", amount);
				}
				else
				{
					Error(playerid, "No tienes esa cantidad de materiales para dejar!");
				}
			}
			return true;
		}
		// COMANDO: /Dejar Bombas [Cantidad]
		else if( !strfind(cmdtext, "/Dejar Bombas", true) )
		{
			if( strlen(cmdtext) < 14 ) return SendSyntaxError(playerid, "Dejar Bombas [Cantidad]", "Dejar Bombas 1");
			new amount = strval(cmdtext[14]);
			if( IsOpenCloset(playerid, houseID) )
			{
				if( amount > 0 && PlayersData[playerid][Bombas] >= amount )
				{
					HouseData[houseID][Bombas] = HouseData[houseID][Bombas] + amount;
					SaveHouse(houseID);
					PlayersData[playerid][Bombas] = PlayersData[playerid][Bombas] - amount;
					Acciones(playerid, 8, "ha dejado bombas en el armario");
					Info(playerid, "Has dejado %i bombas en el armario.", amount);
				}
				else
				{
					Error(playerid, "No tienes esa cantidad de bombas para dejar!");
				}
			}
			return true;
		}
		else{
			Error(playerid, "Quizas quiso decir: /Dejar {Arma, ArmaEx [ID_SLOT], Chaleco [ID_SLOT], Drogas [Cantidad], Ganzuas [Cantidad]}");
			Error(playerid, "Quizas quiso decir: /Dejar {Materiales [Cantidad], Bombas [Cantidad], Articulo [ID_Bolsa]}");
		}
	}
	return true;
}