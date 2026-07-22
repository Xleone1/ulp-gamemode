#include "systems/facciones/f_taller.pwn"
#include "systems/facciones/f_traficantes.pwn"
#include "systems/facciones/f_nfs.pwn"

GetNearFaccion(playerid)
{
	if ( PlayersDataOnline[playerid][InPickup] )
	{
	    if (PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipo] == PICKUP_TYPE_FACCION)
	    {
	        if ( PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipoid] == PlayersDataOnline[playerid][InPickupFaccion])
	        {
				return PlayersDataOnline[playerid][InPickupFaccion];
			}
	    }
	}
	SendInfoMessage(playerid, 0, "382", "Aqui no esta su faccion");
    return -1;
}
CheckAsignados(playerid)
{
	if ( PlayersData[playerid][Faccion] != CIVIL )
	{
		for (new i = 0; i < 3;i++)
		{
			if (PlayersData[playerid][Asignados][i] && !IsVehicleMyFaccion(playerid, GetVehicleIndexBySQLID(PlayersData[playerid][Asignados][i])))
			{
				PlayersData[playerid][Asignados][i] = 0;
			}
		}
	}
	else
	{
		PlayersData[playerid][Asignados][0] = 0;
		PlayersData[playerid][Asignados][1] = 0;
		PlayersData[playerid][Asignados][2] = 0;
	}
}
IsMyCarAsignados(playerid, vehicleIndex)
{
	for (new i = 0; i < 3;i++)
	{
		if ( PlayersData[playerid][Asignados][i] == DataCars[vehicleIndex][ID])
		{
			return true;
		}
	}
	return false;
}
AddAsignados(playerid, vehicleIndex)
{
	for (new i = 0; i < 3; i++)
	{
	    if (PlayersData[playerid][Asignados][i] == DataCars[vehicleIndex][ID])
	    {
	        return 2;
		}
		if (!PlayersData[playerid][Asignados][i])
		{
		    PlayersData[playerid][Asignados][i] = DataCars[vehicleIndex][ID];
			return true;
		}
	}
	return false;
}
RemoveAsignados(playerid, asignarid)
{
	if (!PlayersData[playerid][Asignados][asignarid]) return -1;

	new TempvehicleidA = PlayersData[playerid][Asignados][asignarid];
	PlayersData[playerid][Asignados][asignarid] = 0;
	return GetVehicleIndexBySQLID(TempvehicleidA);
}
ShowAsignados(playerid, playeridshow)
{
	new MsgAsignadosShow[MAX_TEXT_CHAT];
	SendClientMessage(playeridshow, COLOR_MESSAGES[3], "............:::::vehiculos Autorizados:::::............");
	for (new i = 0; i < 3; i++)
	{
		new vehicleIndex = GetVehicleIndexBySQLID(PlayersData[playerid][Asignados][i]);
	    format(MsgAsignadosShow, sizeof(MsgAsignadosShow), "Vehiculo %i: %s", i + 1, DataCars[vehicleIndex][MatriculaString]);
	    SendClientMessage(playeridshow, COLOR_MESSAGES[3], MsgAsignadosShow);
	}
}
GetMaxPlayersByFaccion(faccionid)
{
	new countf;
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && PlayersData[i][Faccion] == faccionid)
		{
		    countf++;
		}
	}
 	return countf;
}

UpdateFaccionLeader(faccionid)
{
	new TempDirFaccion[100];

	mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), "UPDATE %s SET lider='%s' WHERE faccionid = %d", DIR_FACCIONES,
	FaccionData[faccionid][Lider],
	faccionid);

	mysql_query(dataBase, TempDirFaccion);
}

UpdateFaccionDeposit(faccionid)
{
	new TempDirFaccion[100];

	mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), "UPDATE %s SET Deposito = %d WHERE faccionid = %d", DIR_FACCIONES,
	FaccionData[faccionid][Deposito],
	faccionid);

	mysql_query(dataBase, TempDirFaccion);
}

UpdateDataBombas(faccionid, almacen_index)
{
	new TempDirFaccion[356];

	new arrayIndex = almacen_index + 1;

	if(arrayIndex < 0 || arrayIndex >= MAX_ALMACENES){
		printf("UpdateDataBombas: index invalido para almacen_index: %d", almacen_index);
		return 0;
	}

	mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), "UPDATE almacen_faccion a \
	INNER JOIN armas_faccion w ON a.almacen_armas = w.idweapons \
	SET w.Bombas = %d \
	WHERE a.faccionid = %d AND a.almacen_index = %d",
	FaccionData[faccionid][Bombas][almacen_index],
	faccionid, arrayIndex);

	mysql_query(dataBase, TempDirFaccion);
	return 1;
}
UpdateDataGanzuas(faccionid, almacen_index)
{
	new TempDirFaccion[356];

	new arrayIndex = almacen_index + 1;

	if(arrayIndex < 0 || arrayIndex >= MAX_ALMACENES){
		printf("UpdateDataGanzuas: index invalido para almacen_index: %d", almacen_index);
		return 0;
	}

	mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), "UPDATE almacen_faccion a \
	INNER JOIN armas_faccion w ON a.almacen_armas = w.idweapons \
	SET w.Ganzuas = %d \
	WHERE a.faccionid = %d AND a.almacen_index = %d",
	FaccionData[faccionid][Ganzuas][almacen_index],
	faccionid, arrayIndex);

	mysql_query(dataBase, TempDirFaccion);
	return 1;
}

UpdateDataDrogas(faccionid, almacen_index)
{
	new TempDirFaccion[356];

	new arrayIndex = almacen_index + 1;

	if(arrayIndex < 0 || arrayIndex >= MAX_ALMACENES){
		printf("UpdateDataDrogas: index invalido para almacen_index: %d", almacen_index);
		return 0;
	}

	mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), "UPDATE almacen_faccion a \
	INNER JOIN armas_faccion w ON a.almacen_armas = w.idweapons \
	SET w.Drogas = %d \
	WHERE a.faccionid = %d AND a.almacen_index = %d",
	FaccionData[faccionid][Drogas][almacen_index],
	faccionid, arrayIndex);

	mysql_query(dataBase, TempDirFaccion);
	return 1;
}

UpdateDataMateriales(faccionid, almacen_index)
{
	new TempDirFaccion[356];

	new arrayIndex = almacen_index + 1;

	if(arrayIndex < 0 || arrayIndex >= MAX_ALMACENES){
		printf("UpdateDataMateriales: index invalido para almacen_index: %d", almacen_index);
		return 0;
	}

	mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), "UPDATE almacen_faccion a \
	INNER JOIN armas_faccion w ON a.almacen_armas = w.idweapons \
	SET w.Materiales = %d \
	WHERE a.faccionid = %d AND a.almacen_index = %d",
	FaccionData[faccionid][Almacen][almacen_index],
	faccionid, arrayIndex);

	mysql_query(dataBase, TempDirFaccion);
	return 1;
}

UpdateDataLockAlmacen(faccionid, almacen_index)
{
	new TempDirFaccion[100];

	new arrayIndex = almacen_index + 1;

	if(arrayIndex < 0 || arrayIndex >= MAX_ALMACENES){
		printf("UpdateDataLockAlmacen: index invalido para almacen_index: %d", almacen_index);
		return 0;
	}

	mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), "UPDATE almacen_faccion a SET a.LockA = %d WHERE a.faccionid = %d AND a.almacen_index = %d;", 
	FaccionData[faccionid][LockA][almacen_index],
	faccionid, arrayIndex);

	mysql_query(dataBase, TempDirFaccion);
	return 1;
}

UpdateDataWeapons(faccionid, almacen_index)
{
	new TempDirFaccion[456];

	new arrayIndex = almacen_index + 1;

	if(arrayIndex < 0 || arrayIndex >= MAX_ALMACENES){
		printf("UpdateDataWeapons: index invalido para almacen_index: %d", almacen_index);
		return 0;
	}

    mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), "UPDATE almacen_faccion a INNER JOIN armas_faccion w ON a.almacen_armas = w.idweapons \
	SET w.slot_0 = %d, w.slot_1 = %d, w.slot_2 = %d, w.slot_3 = %d, w.slot_4 = %d, w.slot_5 = %d, w.slot_6 = %d, w.slot_7 = %d, w.slot_8 = %d, w.slot_9 = %d, \
	w.Ammo_0 = %d, w.Ammo_1 = %d, w.Ammo_2 = %d, w.Ammo_3 = %d, w.Ammo_4 = %d, w.Ammo_5 = %d, w.Ammo_6 = %d, w.Ammo_7 = %d, w.Ammo_8 = %d, w.Ammo_9 = %d \
	WHERE a.faccionid = %d AND a.almacen_index = %d", 
	WeaponsFaccion[faccionid][almacen_index][0],
	WeaponsFaccion[faccionid][almacen_index][1],
	WeaponsFaccion[faccionid][almacen_index][2],
	WeaponsFaccion[faccionid][almacen_index][3],
	WeaponsFaccion[faccionid][almacen_index][4],
	WeaponsFaccion[faccionid][almacen_index][5],
	WeaponsFaccion[faccionid][almacen_index][6],
	WeaponsFaccion[faccionid][almacen_index][7],
	WeaponsFaccion[faccionid][almacen_index][8],
	WeaponsFaccion[faccionid][almacen_index][9],
	AmmoFaccion[faccionid][almacen_index][0],
	AmmoFaccion[faccionid][almacen_index][1],
	AmmoFaccion[faccionid][almacen_index][2],
	AmmoFaccion[faccionid][almacen_index][3],
	AmmoFaccion[faccionid][almacen_index][4],
	AmmoFaccion[faccionid][almacen_index][5],
	AmmoFaccion[faccionid][almacen_index][6],
	AmmoFaccion[faccionid][almacen_index][7],
	AmmoFaccion[faccionid][almacen_index][8],
	AmmoFaccion[faccionid][almacen_index][9],
	faccionid,
	arrayIndex 
    );

	mysql_query(dataBase, TempDirFaccion);
	return 1;
}

UpdateDataChalecos(faccionid, almacen_index)
{
	new TempDirFaccion[256];

	new arrayIndex = almacen_index + 1;

	if(arrayIndex < 0 || arrayIndex >= MAX_ALMACENES){
		printf("UpdateDataChalecos: index invalido para almacen_index: %d", almacen_index);
		return 0;
	}

	mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), "UPDATE almacen_faccion a \
	INNER JOIN chalecos_faccion c ON a.almacen_chalecos = c.idchalecos \
	SET c.Chaleco_0 = %f, c.Chaleco_1 = %f, c.Chaleco_2 = %f, c.Chaleco_3 = %f \
	WHERE a.faccionid = %d AND a.almacen_index = %d", 
	FaccionesChaleco[faccionid][almacen_index][0],
	FaccionesChaleco[faccionid][almacen_index][1],
	FaccionesChaleco[faccionid][almacen_index][2],
	FaccionesChaleco[faccionid][almacen_index][3],
	faccionid,
	arrayIndex 
    );

	mysql_query(dataBase, TempDirFaccion);
	return 1;
}

UpdateFaccionTextLabel(faccionid, update)
{
	if (faccionid == CIVIL) return 1;
    new string[100];
	if ( strlen(FaccionData[faccionid][Lider]) > 2 )
	{
	    format(string, sizeof(string), "Lugar: {"COLOR_CREMA"}%s \n{"COLOR_VERDE"}Propietario: {"COLOR_CREMA"}%s", FaccionData[faccionid][NameFaccion], FaccionData[faccionid][Lider]);
	}
	else
	{
		if (strcmp(FaccionData[faccionid][Lider], "", false) == 0)
		{
			format(FaccionData[faccionid][Lider], MAX_PLAYER_NAME, "Nadie");
		}
		format(string, sizeof(string), "Lugar: {"COLOR_CREMA"}%s \n{"COLOR_VERDE"}Propietario: {"COLOR_CREMA"}%s", FaccionData[faccionid][NameFaccion], FaccionData[faccionid][Lider]);
		UpdateFaccionLeader(faccionid);
	}
	if (!update)
	{
	    FaccionData[faccionid][TextLabelOut] =
		CreateDynamic3DTextLabel(string, 0x00A5FFFF, FaccionData[faccionid][PickupOut_X], FaccionData[faccionid][PickupOut_Y], FaccionData[faccionid][PickupOut_Z],
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, WORLD_NORMAL, 0);

		FaccionData[faccionid][TextLabelIn] =
		CreateDynamic3DTextLabel(string, 0x00A5FFFF, FaccionData[faccionid][PickupIn_X], FaccionData[faccionid][PickupIn_Y], FaccionData[faccionid][PickupIn_Z],
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, WORLD_DEFAULT_INTERIOR, FaccionData[faccionid][InteriorFaccion]);
	}
	else
	{
	    if (IsValidDynamic3DTextLabel(FaccionData[faccionid][TextLabelOut]))
	    UpdateDynamic3DTextLabelText(FaccionData[faccionid][TextLabelOut], 0x00A5FFFF, string);

	    if (IsValidDynamic3DTextLabel(FaccionData[faccionid][TextLabelIn]))
	    UpdateDynamic3DTextLabelText(FaccionData[faccionid][TextLabelIn], 0x00A5FFFF, string);
	}
	return 1;
}
LoadDataFaccion(faccionid)
{
	new TempDirFaccion[256];
	
	mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), 
	"SELECT f.* FROM %s f \
	WHERE f.faccionid = %d", DIR_FACCIONES, faccionid);

 	new Cache:result = mysql_query(dataBase, TempDirFaccion);
	new rows = cache_num_rows();

	if(rows > 0)
	{
	cache_get_value_name(0, "faccion_name", FaccionData[faccionid][NameFaccion], MAX_PLAYER_NAME);
	cache_get_value_name(0, "lider", FaccionData[faccionid][Lider], MAX_PLAYER_NAME);
	cache_get_value_name_int(0, "Deposito", FaccionData[faccionid][Deposito]);
	cache_get_value_name_int(0, "Extorsion", FaccionData[faccionid][Extorsion]);
	cache_get_value_name_int(0, "InteriorSpawn", FaccionData[faccionid][InteriorSpawn]);
	cache_get_value_name_float(0, "Spawn_X", FaccionData[faccionid][Spawn_X][0]);
	cache_get_value_name_float(0, "Spawn_Y", FaccionData[faccionid][Spawn_Y][0]);
	cache_get_value_name_float(0, "Spawn_Z", FaccionData[faccionid][Spawn_Z][0]);
	cache_get_value_name_float(0, "Spawn_ZZ", FaccionData[faccionid][Spawn_ZZ][0]);
	cache_get_value_name_float(0, "Spawn2_X", FaccionData[faccionid][Spawn_X][1]);
	cache_get_value_name_float(0, "Spawn2_Y", FaccionData[faccionid][Spawn_Y][1]);
	cache_get_value_name_float(0, "Spawn2_Z", FaccionData[faccionid][Spawn_Z][1]);
	cache_get_value_name_float(0, "Spawn2_ZZ", FaccionData[faccionid][Spawn_ZZ][1]);
	cache_get_value_name_int(0, "PrecioFaccion", FaccionData[faccionid][PrecioFaccion]);
	cache_get_value_name_int(0, "Radio", FaccionData[faccionid][Radio]);
	cache_get_value_name_int(0, "Family", FaccionData[faccionid][Family]);

	if(faccionid >= 22){
	printf("[data_facciones]: Se cargaron %d facciones (MAX: %d). ", faccionid, MAX_FACCION_COUNT);
	}
	}
	cache_delete(result);
	LoadRangosSkins(faccionid);
	LoadFaccionPickup(faccionid);
	LoadDataAlmacen(faccionid);
}

LoadRangosSkins(faccionid)
{
	new TempDirFaccion[512];

	mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), 
	"SELECT r.rango, r.paga, s.* FROM rangos_faccion r \
	LEFT JOIN skins_faccion s ON r.skins_groupid = s.groupid  \
	WHERE r.faccionid = %d \
	ORDER BY r.idrango, faccionid;", faccionid);

	new Cache:result = mysql_query(dataBase, TempDirFaccion);
	new rows = cache_num_rows();

    if(rows > 0) 
    {
        for(new i = 0; i < rows; i++) 
        {
            cache_get_value_name(i, "rango", FaccionesRangos[faccionid][i], MAX_FACCION_NAME);
			cache_get_value_name_int(i, "paga", FaccionData[faccionid][Paga][i]);
            for(new s = 0; s < 6; s++) 
            {
                new field[15];
                format(field, sizeof(field), "skin_%02d", s);
                cache_get_value_name_int(i, field, RangosSkins[faccionid][i][s]);
            }
        }
    }
	cache_delete(result);
}

LoadFaccionPickup(faccionid)
{
	new TempDirFaccion[256];

	mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), 
	"SELECT p.PickupIn_X, p.PickupIn_Y, p.PickupIn_Z, p.PickupIn_ZZ, p.PickupOut_X, p.PickupOut_Y, p.PickupOut_Z,  p.PickupOut_ZZ, p.LockP, p.World, p.InteriorFaccion \
	FROM pickup_faccion p \
	WHERE p.faccionid = %d", faccionid);

    new Cache:result = mysql_query(dataBase,TempDirFaccion);
    new rows = cache_num_rows();

    if (rows > 0)
    {
            cache_get_value_name_float(0, "PickupIn_X", FaccionData[faccionid][PickupIn_X]);
            cache_get_value_name_float(0, "PickupIn_Y", FaccionData[faccionid][PickupIn_Y]);
            cache_get_value_name_float(0, "PickupIn_Z", FaccionData[faccionid][PickupIn_Z]);
			cache_get_value_name_float(0, "PickupIn_ZZ", FaccionData[faccionid][PickupIn_ZZ]);
            cache_get_value_name_float(0, "PickupOut_X", FaccionData[faccionid][PickupOut_X]);
            cache_get_value_name_float(0, "PickupOut_Y",  FaccionData[faccionid][PickupOut_Y]);
            cache_get_value_name_float(0, "PickupOut_Z",  FaccionData[faccionid][PickupOut_Z]);
			cache_get_value_name_float(0, "PickupOut_ZZ",  FaccionData[faccionid][PickupOut_ZZ]);
            cache_get_value_name_int(0, "InteriorFaccion", FaccionData[faccionid][InteriorFaccion]);
			cache_get_value_name_int(0, "LockP", FaccionData[faccionid][Lock]);
			cache_get_value_name_int(0, "World", FaccionData[faccionid][World]);

			if (faccionid < 0 || faccionid >= MAX_FACCION_COUNT){
				printf("ERROR: faccionid invalida: %d", faccionid);
			}

			if(FaccionData[faccionid][PickupOut_X] != 0 && FaccionData[faccionid][PickupIn_X] != 0){
				FaccionData[faccionid][PickupidOutF] = CreateFaccionDynamicPickup(1239, faccionid, FaccionData[faccionid][PickupOut_X], FaccionData[faccionid][PickupOut_Y], FaccionData[faccionid][PickupOut_Z], WORLD_NORMAL, 0, -1, MAX_PICKUP_DISTANCE);
				FaccionData[faccionid][PickupidInF] = CreateFaccionDynamicPickup(1239, faccionid, FaccionData[faccionid][PickupIn_X], FaccionData[faccionid][PickupIn_Y], FaccionData[faccionid][PickupIn_Z], WORLD_DEFAULT_INTERIOR, FaccionData[faccionid][InteriorFaccion], -1, MAX_PICKUP_DISTANCE);
				UpdateFaccionTextLabel(faccionid, false);
			}
			
    }
	cache_delete(result);
}

LoadDataAlmacen(faccionid){
	
	new TempDirFaccion[656];

	mysql_format(dataBase, TempDirFaccion, sizeof(TempDirFaccion), 
	"SELECT a.almacen_index,a.AlmacenX, a.AlmacenY, a.AlmacenZ, a.AlmacenWorld, a.LockA, w.slot_0, w.slot_1, w.slot_2, w.slot_3,w.slot_4, w.slot_5, w.slot_6, w.slot_7, w.slot_8, w.slot_9, \
	w.Ammo_0, w.Ammo_1, w.Ammo_2, w.Ammo_3,w.Ammo_4, w.Ammo_5, w.Ammo_6, w.Ammo_7, w.Ammo_8, w.Ammo_9, w.Drogas, w.Ganzuas, w.Bombas, w.Materiales, c.Chaleco_0,  c.Chaleco_1,  c.Chaleco_2, \
	c.Chaleco_3 FROM almacen_faccion a \
	LEFT JOIN chalecos_faccion c on a.almacen_chalecos = c.idchalecos \
	LEFT JOIN armas_faccion w on a.almacen_armas = w.idweapons \
	WHERE a.faccionid = %d", faccionid);

    new Cache:result = mysql_query(dataBase,TempDirFaccion);
    new rows = cache_num_rows();

	if (rows > 0){
	//Datos Almacen
		for (new i = 0; i < rows; i++){

			new almacen_index;
			cache_set_result(i);
			cache_get_value_name_int(i, "almacen_index", almacen_index);
			new arrayIndex = almacen_index - 1;

			//printf("DEBUG: FaccionID: %d - Cache Row: %d - Conversion arrayIndex: %d - almacen_index: %d",faccionid, i, arrayIndex, almacen_index);

			if(arrayIndex >= 0 && arrayIndex < MAX_ALMACENES){
				cache_get_value_name_float(i, "AlmacenX", FaccionData[faccionid][AlmacenX][arrayIndex]);
				cache_get_value_name_float(i, "AlmacenY", FaccionData[faccionid][AlmacenY][arrayIndex]);
				cache_get_value_name_float(i, "AlmacenZ", FaccionData[faccionid][AlmacenZ][arrayIndex]);
				cache_get_value_name_int(i, "AlmacenWorld", FaccionData[faccionid][AlmacenWorld][arrayIndex]);
				cache_get_value_name_int(i, "LockA", FaccionData[faccionid][LockA][arrayIndex]);
				cache_get_value_name_int(i, "slot_0", WeaponsFaccion[faccionid][arrayIndex][0]);
				cache_get_value_name_int(i, "slot_1", WeaponsFaccion[faccionid][arrayIndex][1]);
				cache_get_value_name_int(i, "slot_2", WeaponsFaccion[faccionid][arrayIndex][2]);
				cache_get_value_name_int(i, "slot_3", WeaponsFaccion[faccionid][arrayIndex][3]);
				cache_get_value_name_int(i, "slot_4", WeaponsFaccion[faccionid][arrayIndex][4]);
				cache_get_value_name_int(i, "slot_5", WeaponsFaccion[faccionid][arrayIndex][5]);
				cache_get_value_name_int(i, "slot_6", WeaponsFaccion[faccionid][arrayIndex][6]);
				cache_get_value_name_int(i, "slot_7", WeaponsFaccion[faccionid][arrayIndex][7]);
				cache_get_value_name_int(i, "slot_8", WeaponsFaccion[faccionid][arrayIndex][8]);
				cache_get_value_name_int(i, "slot_9", WeaponsFaccion[faccionid][arrayIndex][9]);
				cache_get_value_name_int(i, "Ammo_0", AmmoFaccion[faccionid][arrayIndex][0]);
				cache_get_value_name_int(i, "Ammo_1", AmmoFaccion[faccionid][arrayIndex][1]);
				cache_get_value_name_int(i, "Ammo_2", AmmoFaccion[faccionid][arrayIndex][2]);
				cache_get_value_name_int(i, "Ammo_3", AmmoFaccion[faccionid][arrayIndex][3]);
				cache_get_value_name_int(i, "Ammo_4", AmmoFaccion[faccionid][arrayIndex][4]);
				cache_get_value_name_int(i, "Ammo_5", AmmoFaccion[faccionid][arrayIndex][5]);
				cache_get_value_name_int(i, "Ammo_6", AmmoFaccion[faccionid][arrayIndex][6]);
				cache_get_value_name_int(i, "Ammo_7", AmmoFaccion[faccionid][arrayIndex][7]);
				cache_get_value_name_int(i, "Ammo_8", AmmoFaccion[faccionid][arrayIndex][8]);
				cache_get_value_name_int(i, "Ammo_9", AmmoFaccion[faccionid][arrayIndex][9]);
				cache_get_value_name_float(i, "Chaleco_0", FaccionesChaleco[faccionid][arrayIndex][0]);
				cache_get_value_name_float(i, "Chaleco_1", FaccionesChaleco[faccionid][arrayIndex][1]);
				cache_get_value_name_float(i, "Chaleco_2", FaccionesChaleco[faccionid][arrayIndex][2]);
				cache_get_value_name_float(i, "Chaleco_3", FaccionesChaleco[faccionid][arrayIndex][3]);
				cache_get_value_name_int(i, "Drogas", FaccionData[faccionid][Drogas][arrayIndex]);
				cache_get_value_name_int(i, "Ganzuas", FaccionData[faccionid][Ganzuas][arrayIndex]);
				cache_get_value_name_int(i, "Bombas", FaccionData[faccionid][Bombas][arrayIndex]);
				cache_get_value_name_int(i, "Materiales", FaccionData[faccionid][Almacen][arrayIndex]);
			}
		}
	}
	cache_delete(result);
	LoadPickupsAlmacenes(faccionid);
}

CreateFaccionDynamicPickup(modelid, faccionid, Float:x, Float:y, Float:z, worldid, interiorid, playerid, Float:streamdistance)
{
    new pickupid = CreateDynamicPickup(modelid, 1, x, y, z, worldid, interiorid, playerid, streamdistance);
	PickupIndex[pickupid][Tipo] = PICKUP_TYPE_FACCION;
	PickupIndex[pickupid][Tipoid] = faccionid;
    return pickupid;
}

SetPlayerFaccion(playerid, const cmdfaccion[])
{
    if (PlayersData[playerid][Admin] >= 7)
    {
		if ( strlen(cmdfaccion) > 10)
		{

			new Datos_PicadosFaccion[3][MAX_PLAYER_NAME];
			            	// 00  	= 	"/Jail"
							// 01	= 	ID
							// 02   =   ID_FACCION
		       // DatosOriginales   =   RANGO

			new DatosOriginales[150];
			format(DatosOriginales, sizeof(DatosOriginales), "%s ", cmdfaccion);
			new wPos;
   			for (new i = 0; i < 3; i++)
    		{
				wPos = strfind(DatosOriginales, " ", false); // HOLAÂ³QUEÂ³PASAÂ³
				strmid(Datos_PicadosFaccion[i], DatosOriginales, 0, wPos, sizeof(DatosOriginales));
				strdel(DatosOriginales, 0, wPos + 1);
			}

			new faccionID = GetFaccionByName(Datos_PicadosFaccion[2]);

			if ( IsPlayerConnected(strval(Datos_PicadosFaccion[1])) )
			{
				if ( faccionID >= CIVIL && faccionID <= MAX_FACCION )
				{
					if ( strval(DatosOriginales) <= GetMaxFaccionRango(faccionID) || faccionID == 0 )
					{
					    if( PlayersData[strval(Datos_PicadosFaccion[1])][Rango] == 0)
						{
						    format(FaccionData[PlayersData[strval(Datos_PicadosFaccion[1])][Faccion]][Lider], 2, "");
						    UpdateFaccionTextLabel(PlayersData[strval(Datos_PicadosFaccion[1])][Faccion], true);
						}
                        PlayersData[strval(Datos_PicadosFaccion[1])][Faccion] = faccionID;
                        PlayersData[strval(Datos_PicadosFaccion[1])][HorasWork] = 0;
                        PlayersData[strval(Datos_PicadosFaccion[1])][SpawnFac] = 0;

						if ( faccionID != CIVIL )
						{
	                        PlayersData[strval(Datos_PicadosFaccion[1])][Rango]  = strval(DatosOriginales);
							PlayersData[strval(Datos_PicadosFaccion[1])][Skin] = RangosSkins[PlayersData[strval(Datos_PicadosFaccion[1])][Faccion]][PlayersData[strval(Datos_PicadosFaccion[1])][Rango]][0];
							SetPlayerSkinEx(strval(Datos_PicadosFaccion[1]), RangosSkins[PlayersData[strval(Datos_PicadosFaccion[1])][Faccion]][PlayersData[strval(Datos_PicadosFaccion[1])][Rango]][0]);

							if( PlayersData[strval(Datos_PicadosFaccion[1])][Rango] == 0)
							{
							    format(FaccionData[faccionID][Lider], MAX_PLAYER_NAME, "%s", PlayersDataOnline[strval(Datos_PicadosFaccion[1])][NameOnline]);
							    UpdateFaccionTextLabel(faccionID, true);
								UpdateFaccionLeader(faccionID);
							}
						}
						else
						{
		                    PlayersData[strval(Datos_PicadosFaccion[1])][Rango]   = 0;
						    PlayersData[strval(Datos_PicadosFaccion[1])][Skin] = 26;
						    SetPlayerSkinEx(strval(Datos_PicadosFaccion[1]), 26);
							format(FaccionData[faccionID][Lider], MAX_PLAYER_NAME, "Nadie"); 
							UpdateFaccionLeader( faccionID);
						}

						new MsgAcceptUser[MAX_TEXT_CHAT]; format(MsgAcceptUser, sizeof(MsgAcceptUser), "Metiste a %s a la faccion \"%s\" con rango \"%s\"", PlayersDataOnline[strval(Datos_PicadosFaccion[1])][NameOnline], FaccionData[faccionID][NameFaccion], FaccionesRangos[faccionID][PlayersData[strval(Datos_PicadosFaccion[1])][Rango]]);
						new MsgAcceptMe[MAX_TEXT_CHAT]; format(MsgAcceptMe, sizeof(MsgAcceptMe), "El administrador %s te ha metido a la faccion \"%s\" con rango \"%s\"", PlayersDataOnline[playerid][NameOnline], FaccionData[faccionID][NameFaccion], FaccionesRangos[faccionID][PlayersData[strval(Datos_PicadosFaccion[1])][Rango]]);
                        SendInfoMessage(strval(Datos_PicadosFaccion[1]), 3, "0", MsgAcceptMe);
                        SendInfoMessage(playerid, 3, "0", MsgAcceptUser);

						CheckAsignados(strval(Datos_PicadosFaccion[1]));
						SetPlayerLockAllVehicles(strval(Datos_PicadosFaccion[1]));
						UpdateSpawnPlayer(strval(Datos_PicadosFaccion[1]));
					}
					else
					{
						SendInfoMessage(playerid, 0, "139", "El rango que introdujo no existe para esa faccion");
					}
				}
				else
				{
					SendInfoMessage(playerid, 0, "140", "La faccion que introdujo no existe");
				}
			}
			else
			{
				SendInfoMessage(playerid, 0, "141", "El jugador que desea cambiar de faccion no se encuentra conectado");
			}
		}
		else
		{
			SendInfoMessage(playerid, 0, "142", "Ha introducído mal el sintaxis del comando /faccion. Ejemplo correcto: /faccion 2 8 2.");
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "143", "Tu no tienes acceso a el comando /faccion.");
	}
}

SetPlayerFaccionEx(playerid, const command[])
{
    if (PlayersData[playerid][Admin] >= 7)
    {
		if ( strlen(command) > 15)
		{

			new NameF[MAX_PLAYER_NAME];
			strmid(NameF, command, GetPosSpace(command, 1) + 1, GetPosSpace(command, 2));

			new FaccionID = strval(command[GetPosSpace(command, 2)]);
			new RangoID = strval(command[GetPosSpace(command, 3)]);

			if ( IsPlayerConnectedEx(NameF) == -1)
			{
				if ( FaccionID >= CIVIL && FaccionID <= MAX_FACCION )
				{
					if ( RangoID <= GetMaxFaccionRango(FaccionID) || FaccionID == 0 )
					{
					    new playeridF = 499;
					    format(PlayersDataOnline[playeridF][NameOnline], MAX_PLAYER_NAME, "%s", NameF);
						if (DataUserLoad(playeridF))
						{
						    new LastFaccion = PlayersData[playeridF][Faccion];
						    new LastRango = PlayersData[playeridF][Rango];
							PlayersData[playeridF][Faccion] = FaccionID;
						    PlayersData[playeridF][HorasWork] = 0;
                            PlayersData[playeridF][SpawnFac] = 0;
							if ( FaccionID != CIVIL )
							{
								PlayersData[playeridF][Rango]   = RangoID;
								PlayersData[playeridF][Skin] = RangosSkins[PlayersData[playeridF][Faccion]][PlayersData[playeridF][Rango]][0];

								if ( PlayersData[playeridF][Job] == VENDEDOR_MOVIL )
								{
								    PlayersData[playeridF][Job] = NINGUNO;
								}
							}
							else
							{
							    PlayersData[playeridF][Rango]   = 7;
							    PlayersData[playeridF][Skin] = 26;
							}
							CheckAsignados(playeridF);

							new MsgAcceptUser[256];
							format(MsgAcceptUser, sizeof(MsgAcceptUser), "Metiste a %s a la faccion \"%s\" con rango \"%s\" estaba en la faccion \"%s\" con rango \"%s\"",
							PlayersDataOnline[playeridF][NameOnline],
							FaccionData[FaccionID][NameFaccion],
							FaccionesRangos[FaccionID][PlayersData[playeridF][Rango]],
							FaccionData[LastFaccion][NameFaccion],
							FaccionesRangos[LastFaccion][LastRango]);

	                        SendInfoMessage(playerid, 3, "0", MsgAcceptUser);

							PlayersDataOnline[playeridF][Spawn] = false;
							DataUserSave(playeridF);
						}
						else
						{
							SendInfoMessage(playerid, 0, "956", "No existe ese jugador en la base de datos!");
						}
					}
					else
					{
						SendInfoMessage(playerid, 0, "957", "La rango que introdujo no existe para esa faccion");
					}
				}
				else
				{
					SendInfoMessage(playerid, 0, "958", "La faccion que introdujo no existe");
				}
			}
			else
			{
				SendInfoMessage(playerid, 0, "959", "El jugador que desea cambiar de faccion se encuentra conectado, utilize /faccion");
			}
		}
		else
		{
			SendInfoMessage(playerid, 0, "960", "Ha introducído mal el sintaxis del comando /faccionEx. Ejemplo correcto: /faccionEx Ikki_Katsu 5 0.");
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "961", "Tu no tienes acceso a el comando /faccionEx.");
	}
}

LoadPickupsAlmacenes(faccionid)
{
	for (new a=0; a!=MAX_ALMACENES; a++)
	{
	    if ( FaccionData[faccionid][AlmacenX][a] != 0)
	    {
	        new pickupid = CreateDynamicPickup(1575, 1, FaccionData[faccionid][AlmacenX][a], FaccionData[faccionid][AlmacenY][a], FaccionData[faccionid][AlmacenZ][a], FaccionData[faccionid][AlmacenWorld][a]);
	        PickupIndex[pickupid][Tipo] = PICKUP_TYPE_FACCION_ALMACEN;
			PickupIndex[pickupid][Tipoid] = faccionid;
		}
	}
}

GetMaxFaccionRango(faccionid)
{
    new max_rango = -1;
    for (new i = 0; i < MAX_FACCION_RANGOS; i++) {
        if (strcmp(FaccionesRangos[faccionid][i], "0") != 0 && FaccionesRangos[faccionid][i][0] != '\0') {
            max_rango = i; 
        }
    }
    return max_rango;
}

IsPlayerInAlmacen(playerid, option)
{
	if ( FaccionData[PlayersData[playerid][Faccion]][AlmacenX] != 0.0 )
	{
	    for ( new i = 0; i < MAX_ALMACENES; i++ )
	    {
			if ( IsPlayerInRangeOfPoint(playerid, 3.0,
			FaccionData[PlayersData[playerid][Faccion]][AlmacenX][i],
			FaccionData[PlayersData[playerid][Faccion]][AlmacenY][i],
			FaccionData[PlayersData[playerid][Faccion]][AlmacenZ][i]) &&
			FaccionData[PlayersData[playerid][Faccion]][AlmacenWorld][i] == GetPlayerVirtualWorld(playerid) )
			{
				return i;
			}
		}
		if ( option )
		{
			SendInfoMessage(playerid, 0, "732", "No se encuentra cerca del almacen");
		}
	}
	else
	{
	    if ( option )
	    {
			SendInfoMessage(playerid, 0, "733", "Su faccion no tiene almacen");
		}
	}
	return -1;

}

LoadPointsExtraction()
{
	FaccionesMercancias[CAMIONEROS][PosX] = 275.2802;
	FaccionesMercancias[CAMIONEROS][PosY] = 1371.9243;
	FaccionesMercancias[CAMIONEROS][PosZ] = 10.5859;
	CreateDynamicPickup(1210, 1, FaccionesMercancias[CAMIONEROS][PosX], FaccionesMercancias[CAMIONEROS][PosY], FaccionesMercancias[CAMIONEROS][PosZ], WORLD_NORMAL, 0);

	FaccionesMercancias[CONTRABANDISTAS][PosX] = 417.6441;
	FaccionesMercancias[CONTRABANDISTAS][PosY] = 2541.6646;
	FaccionesMercancias[CONTRABANDISTAS][PosZ] = 10.0000;
	CreateDynamicPickup(1210, 1, FaccionesMercancias[CONTRABANDISTAS][PosX], FaccionesMercancias[CONTRABANDISTAS][PosY], FaccionesMercancias[CONTRABANDISTAS][PosZ]);

	FaccionesMercancias[TRAFICANTES][PosX] = -1421.7528;
	FaccionesMercancias[TRAFICANTES][PosY] = -964.7759;
	FaccionesMercancias[TRAFICANTES][PosZ] = 200.7651;
 	CreateDynamicPickup(1210, 1, FaccionesMercancias[TRAFICANTES][PosX], FaccionesMercancias[TRAFICANTES][PosY], FaccionesMercancias[TRAFICANTES][PosZ], WORLD_NORMAL, 0);
}

GetFaccionByName(const fName[])
{
	for(new i; i<=MAX_FACCION; i++){
		if(strfind(FaccionData[i][NameFaccion], fName, true) != -1){
			return i;
		}
	}
	return strval(fName);
}