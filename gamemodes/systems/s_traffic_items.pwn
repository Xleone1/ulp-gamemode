
LoadVCP()
{
	new TempDirSVCP[256];
    new objectModelID, ObjectIDT;
	new Float:objectX, Float:objectY, Float:objectZ, Float:objectZRot;
    new total_vcp_cargados = 0;

	for (new i=0; i < MAX_OBJECTS_VALLAS_CONOS_PINCHOS; i++)
	{
		mysql_format(dataBase,TempDirSVCP, sizeof(TempDirSVCP), 
		"SELECT id_objectModel, ObjectX, ObjectY, ObjectZ, ObjectZRot \
		FROM %s WHERE id = %d", 
		DIR_VCP, i);

		new Cache:result = mysql_query(dataBase, TempDirSVCP);
		new rows = cache_num_rows();
		
		if(rows > 0){
			cache_get_value_name_int(0, "id_objectModel", objectModelID);
			cache_get_value_name_float(0, "ObjectX", objectX);
			cache_get_value_name_float(0, "ObjectY", objectY);
			cache_get_value_name_float(0, "ObjectZ", objectZ);
			cache_get_value_name_float(0, "ObjectZRot", objectZRot);
		}

		ObjectIDT = objectModelID;

		if ( ObjectIDT != -1 )
		{
			AddVCP(-1, objectModelID, objectX, objectY, objectZ, objectZRot);
			total_vcp_cargados++;
		}
		cache_delete(result);
	}
	printf("[map_objects_vcp]: Se han cargado un total de %d VCP (MAX: %d)", total_vcp_cargados, MAX_OBJECTS_VALLAS_CONOS_PINCHOS);
}

LoadBombas()
{
	new TempDirBombas[256];
    new TypeBomb, ModelIDBomb, ObjectIDOBomb, BombaType;
	new Float:PosXBomb, Float:PosYBomb, Float:PosZBomb;
	new totalBombsLoading = 0;

	for (new i = 0; i < MAX_BOMBAS_COUNT; i++ )
	{
	    mysql_format(dataBase, TempDirBombas, sizeof(TempDirBombas), 
		"SELECT typeBomb, model_id, pos_x, pos_y, pos_z, object_id \
		FROM %s WHERE id = %d", 
		DIR_BOMBAS, i);
		
		new Cache:result = mysql_query(dataBase, TempDirBombas);
		new rows = cache_num_rows();

		if(rows > 0){
			cache_get_value_name_int(0, "typeBomb", TypeBomb);
			cache_get_value_name_int(0, "model_id", ModelIDBomb);
			cache_get_value_name_float(0, "pos_x", PosXBomb);
			cache_get_value_name_float(0, "pos_y", PosYBomb);
			cache_get_value_name_float(0, "pos_z", PosZBomb);
			cache_get_value_name_int(0, "object_id", ObjectIDOBomb);
		}
		BombaType = TypeBomb;
		if ( BombaType != BOMBA_TYPE_NONE )
		{
			// nota: AddBomba espera vehicleSQLID (3er param), objectid (7mo param)
			// en DB: model_id = modelo visual, object_id = vehicle/samp-id segun tipo
			AddBomba(-1, BombaType, ObjectIDOBomb, PosXBomb, PosYBomb, PosZBomb, ModelIDBomb);
			totalBombsLoading++;
		}
		cache_delete(result);
	}
	printf("[map_objects_bombas]: Se han cargado un total de %d Bombas (MAX: %d)", totalBombsLoading, MAX_BOMBAS_COUNT);
}

IsNearVCP(playerid)
{
	for (new i=0; i < MAX_OBJECTS_VALLAS_CONOS_PINCHOS; i++)
	{
	    if ( VCP[i][objectid_vcp] != -1 && IsPlayerInRangeOfPoint(playerid, 2.0, VCP[i][ObjX], VCP[i][ObjY], VCP[i][ObjZ])  )
	    {
			return i;
	    }
    }
	return -1;
}

CleanVCP()
{
	for (new i=0; i < MAX_OBJECTS_VALLAS_CONOS_PINCHOS; i++)
	{
	    VCP[i][objectid_vcp] = -1;
	    VCP[i][objectmodel] = -1;
	    VCP[i][pickupidVCP] = -1;
	}
}

AddVCP(playerid, objectid, Float:Xv, Float:Yv, Float:Zv, Float:ZZv)
{
	new TempDirVCP[356];
	for (new i=0; i < MAX_OBJECTS_VALLAS_CONOS_PINCHOS; i++)
	{
	    if ( VCP[i][objectid_vcp] == -1 )
	    {
	        if ( playerid != -1 )
	        {
				GetPlayerPos(playerid, VCP[i][ObjX], VCP[i][ObjY], VCP[i][ObjZ]); GetPlayerFacingAngle(playerid, VCP[i][ObjZRot]);
			}
			else
			{
			    VCP[i][ObjX] 	= Xv;
			    VCP[i][ObjY] 	= Yv;
			    VCP[i][ObjZ] 	= Zv;
			    VCP[i][ObjZRot] = ZZv;
			}
		    VCP[i][objectmodel] = objectid;
		    if ( playerid != -1 )
			{
				if ( objectid == PINCHO)
				{
					VCP[i][ObjZ] = VCP[i][ObjZ] - 0.9;
		    	}
		    	else if ( objectid == CONO )
		    	{
					VCP[i][ObjZ] = VCP[i][ObjZ] - 0.7;
				}
		    	else if ( objectid == VALLA )
		    	{
			    	VCP[i][ObjZ] = VCP[i][ObjZ] - 0.4;
				}
			}
			if ( objectid == PINCHO)
			{
				new pickupid = CreateDynamicPickup(1247, 1, VCP[i][ObjX], VCP[i][ObjY], VCP[i][ObjZ] - 1, WORLD_NORMAL, 0);
				PickupIndex[pickupid][Tipo] = PICKUP_TYPE_PINCHO;
				PickupIndex[pickupid][Tipoid] = i;

				VCP[i][pickupidVCP] = pickupid;
			}
	    	VCP[i][objectid_vcp] = CreateDynamicObject(objectid, VCP[i][ObjX], VCP[i][ObjY], VCP[i][ObjZ], 0, 0, VCP[i][ObjZRot], -1, -1, -1, MAX_RADIO_STREAM);
			if ( playerid != -1 )
	        {
		    	SetPlayerPos(playerid, VCP[i][ObjX], VCP[i][ObjY], VCP[i][ObjZ] + 0.5);
	    	}
					
			mysql_format(dataBase, TempDirVCP, sizeof(TempDirVCP), "UPDATE %s SET id_objectModel = %d, ObjectX = %f, ObjectY= %f, ObjectZ = %f, ObjectZRot = %f WHERE id = %d",
			DIR_VCP,
			VCP[i][objectmodel],
			VCP[i][ObjX],
			VCP[i][ObjY],
			VCP[i][ObjZ],
			VCP[i][ObjZRot],
			i);
			mysql_query(dataBase, TempDirVCP, false);
	        return true;
		}
	}
	if ( playerid != -1 )
	{
		SendInfoMessage(playerid, 0, "840", "Han llegado al limite de 100 objetos que pueden usar entre: Vallas, Conos y Pinchos");
	}
	return false;
}

RemoveVCP(objectid)
{
	new TempDirVCP[256];

	mysql_format(dataBase, TempDirVCP, sizeof(TempDirVCP), "UPDATE %s SET id_objectModel = -1, ObjectX = 0, ObjectY= 0, ObjectZ = 0, ObjectZRot = 0 WHERE id = %d",
	DIR_VCP,
	objectid);

    if ( VCP[objectid][pickupidVCP] != -1 )
	{
	    new pickupid = VCP[objectid][pickupidVCP];
		DestroyDynamicPickup(pickupid);
		PickupIndex[pickupid][Tipo] = PICKUP_TYPE_NINGUNO;
		PickupIndex[pickupid][Tipoid] = 0;
	}
	DestroyDynamicObject(VCP[objectid][objectid_vcp]);
	mysql_query(dataBase, TempDirVCP);
   	VCP[objectid][objectid_vcp] = -1;
    VCP[objectid][objectmodel] = -1;
    VCP[objectid][pickupidVCP] = -1;
}