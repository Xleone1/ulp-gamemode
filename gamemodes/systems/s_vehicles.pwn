IsPlayerInNearVehicle(playerid)
{
	if ( !IsPlayerInAnyVehicle(playerid) )
	{
	    new TheVehicle;
	    new i;
	    new Float:RangoC;
	    new Float:X, Float:Y, Float:Z;
		new MyWorld = GetPlayerVirtualWorld(playerid);
	    do
	    {
		    RangoC++;
			i = 0;
			for (; i != MAX_CAR; i++)
			{
				if(!DataCars[i][VehicleID]) continue;
			    GetVehiclePos(DataCars[i][VehicleID], X, Y, Z);
				if (IsPlayerInRangeOfPoint(playerid, RangoC,
					X,
					Y,
					Z) && MyWorld == DataCars[i][WorldLast])
				{
				    TheVehicle = DataCars[i][VehicleID];
				    RangoC = 5.0;
				    break;
				}
			}
		}
		while( RangoC != 5.0 );

		if ( TheVehicle && coches_Todos_Type[GetVehicleModel(TheVehicle) - 400] != BICI )
		{
		    return TheVehicle;
		}
		else
		{
			SendInfoMessage(playerid, 0, "222", "No hay ningun vehiculo a su alrededor");
		}
		return false;
	}
	else
	{
		return GetPlayerVehicleID(playerid);
	}
}
IsPlayerInNearVehicleEx(playerid)
{
	if ( !IsPlayerInAnyVehicle(playerid) )
	{
	    new TheVehicle;
	    new i;
	    new Float:RangoC;
	    new Float:X, Float:Y, Float:Z;
	    do
	    {
		    RangoC++;
			i = 1;
			for (; i <= MAX_CAR; i++)
			{
			    GetVehiclePos(i, X, Y, Z);
				if (IsPlayerInRangeOfPoint(playerid, RangoC,
					X,
					Y,
					Z) )
				{
				    TheVehicle = i;
				    RangoC = 5.0;
					break;
				}
			}
		}
		while( RangoC != 5.0 );

		if ( !TheVehicle )
		{
			SendInfoMessage(playerid, 0, "216", "No hay ningun vehiculo a su alrededor");
		}
		return TheVehicle;
	}
	else
	{
		return GetPlayerVehicleID(playerid);
	}
}
AparcarVehicle(playerid, vehicleIndex)
{
	for (new i = 1; i <= MAX_CAR; i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, 4.0,
			DataCars[i][PosX],
			DataCars[i][PosY],
			DataCars[i][PosZ]) &&
			DataCars[i][World] == DataCars[vehicleIndex][World]
			&&
			DataCars[i][Interior] == DataCars[vehicleIndex][Interior])
		{
		    SendInfoMessage(playerid, 0, "223", "Parqueo ocupado, por favor busque otro lugar!");
		    return false;
		}
	}
	GameTextForPlayer(playerid, "~W~Coche ~B~Aparcado!", 1000, 6);
    new Float:X, Float:Y, Float:Z, Float:ZZ;
    GetVehiclePos(DataCars[vehicleIndex][VehicleID], X, Y, Z);
	GetVehicleZAngle(DataCars[vehicleIndex][VehicleID], ZZ);


	DataCars[vehicleIndex][PosX] = X;
	DataCars[vehicleIndex][PosY] = Y;
	DataCars[vehicleIndex][PosZ] = Z;
	DataCars[vehicleIndex][PosZZ]= ZZ;

	DataCars[vehicleIndex][Interior] = GetPlayerInteriorEx(playerid);
	DataCars[vehicleIndex][World]    = GetPlayerVirtualWorld(playerid);

	SaveDataVehicle(vehicleIndex);
    return true;
}
LockVehicle(playerid)
{
    new MyNearCar;
    if (!PlayersData[playerid][IsPlayerInVehInt])
    {
		MyNearCar = IsPlayerInNearVehicle(playerid);
	}
	else if (PickupInfo[PickupidAmbulance][PickupId] == PlayersDataOnline[playerid][InPickup] ||
			 PickupInfo[PickupidFurgoCNN][PickupId] == PlayersDataOnline[playerid][InPickup] ||
			 PickupInfo[PickupidPoliceFurgo][PickupId] == PlayersDataOnline[playerid][InPickup])
	{
		MyNearCar = PlayersData[playerid][IsPlayerInVehInt];
	}

	new vehicleIndex = GetVehicleIndexByVehicleID(MyNearCar);
	if (vehicleIndex == -1) return false;
	if (IsVehicleMyVehicle(playerid, vehicleIndex) ||
		IsVehicleMyFaccion(playerid, vehicleIndex) && PlayersData[playerid][Rango] <= 1 ||
		IsVehicleMyFaccion(playerid, vehicleIndex) && IsMyCarAsignados(playerid, vehicleIndex))
	{
		new MsgLock[MAX_TEXT_CHAT];
		if ( DataCars[vehicleIndex][Lock] )
		{
			DataCars[vehicleIndex][Lock] = false;
			GameTextForPlayer(playerid, "~w~Coche ~g~Abierto", 1000, 3);
		}
		else
		{
			DataCars[vehicleIndex][Lock] = true;
			GameTextForPlayer(playerid, "~w~Coche ~r~Cerrado", 1000, 3);
		}
		LockTrain(vehicleIndex, DataCars[vehicleIndex][Lock]);

		if (DataCars[vehicleIndex][FactionId] != 0) 
		{
			format(MsgLock, 50, "%s un vehiculo de faccion.", NamesLook[DataCars[vehicleIndex][Lock]]);
			for (new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i) && PlayersData[playerid][Faccion] == PlayersData[i][Faccion])
				{
					SetVehicleParamsForPlayer(DataCars[vehicleIndex][VehicleID], i, 0, DataCars[vehicleIndex][Lock]);
				}
			}
		}
		else
		{
			format(MsgLock, 50, "%s su vehiculo.", NamesLook[DataCars[vehicleIndex][Lock]]);
			for (new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					SetVehicleParamsForPlayer(DataCars[vehicleIndex][VehicleID], i, 0, DataCars[vehicleIndex][Lock]);
				}
			}
		}
		SendInfoMessage(playerid, 2, "0", MsgLock);
		PlayPlayerStreamSound(playerid, SOUND_ALARM_CAR);
		return true;
	}
	else
	{
		SendInfoMessage(playerid, 0, "217", "Este no es su vehiculo");
		return false;
	}
}
IsVehicleMyVehicle(playerid, vehicleIndex)
{
	return DataCars[vehicleIndex][OwnerId] == PlayersData[playerid][DB_ID];
}
IsVehicleMyFaccion(playerid, vehicleIndex)
{
	return PlayersData[playerid][Faccion] != 0 && PlayersData[playerid][Faccion] == DataCars[vehicleIndex][FactionId];
}

IsVehicleMyJob(playerid, vehicleIndex)
{
	return PlayersData[playerid][Job] != 0 && PlayersData[playerid][Job] == DataCars[vehicleIndex][JobId];
}
SetPlayerLockAllVehicles(playerid)
{
	for (new i = 1; i <= MAX_CAR; i++)
	{
		SetVehicleParamsForPlayer(i, playerid, 0, 0);
	}
}
IsFixBikeEnter(playerid, vehicleIndex)
{
    if ( coches_Todos_Type[GetVehicleModel(DataCars[vehicleIndex][VehicleID]) - 400] == MOTO 
		|| coches_Todos_Type[GetVehicleModel(DataCars[vehicleIndex][VehicleID]) - 400] == TREN 
		|| coches_Todos_Type[GetVehicleModel(DataCars[vehicleIndex][VehicleID]) - 400] == BOTE)
	{
	    new Float:PosFixVeh[3]; 
		GetPlayerPos(playerid, PosFixVeh[0], PosFixVeh[1], PosFixVeh[2]);
	    SetPlayerPos(playerid, PosFixVeh[0], PosFixVeh[1], PosFixVeh[2] + 2);
	    return true;
	}
	else
	{
	    return false;
	}
}
IsGuanteraOpen(playerid)
{
	new VehicleInside = IsPlayerInsideVehicle(playerid);
	new vehicleIndex = GetVehicleIndexByVehicleID(VehicleInside);
	if ( vehicleIndex >= 0 )
	{
		if (DataCars[vehicleIndex][GuanteraLock] || !IsVehicleHasOwner(vehicleIndex) )
		{
		    return VehicleInside;
		}
		else
		{
			SendInfoMessage(playerid, 0, "1581", "La guantera de este vehiculo se encuentra cerrada!");
		}
	}
	return false;
}
IsMaleteroOpen(playerid)
{
    if ( !IsPlayerInAnyVehicle(playerid) )
    {
	    new MyNearCar = IsPlayerInNearVehicle(playerid);
		new vehicleIndex = GetVehicleIndexByVehicleID(MyNearCar);
		if ( vehicleIndex >= 0 )
		{
			if (DataCars[MyNearCar][MaleteroState] || !IsVehicleHasOwner(vehicleIndex))
			{
			    return MyNearCar;
			}
			else
			{
				SendInfoMessage(playerid, 0, "251", "El maletero de este vehiculo se encuentra cerrado!");
			}
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "250", "Desde adentro del vehiculo no puedes acceder al maletero");
	}
	return false;
}



IsValidVehicleModelId(modelid) {
	return modelid >= 400 && modelid <= 611;
}

GetVehicleIndexByVehicleID(vehicleid)
{
	for (new i = 0; i <= MAX_CAR; i++)
	{
		if (DataCars[i][ID] > 0 && DataCars[i][VehicleID] == vehicleid)
		{
			return i;
		}
	}
	return -1;
}

GetVehicleIndexBySQLID(vehicleSQLID)
{
	for (new i = 0; i <= MAX_CAR; i++)
	{
		if (DataCars[i][ID] == vehicleSQLID)
		{
			return i;
		}
	}
	return 0;
}

CreateVehicleEx(model, Float:Xc, Float:Yc, Float:Zc, Float:ZZc, color1, color2, vehicleIndex)
{
	// printf("CreateVehicleEx(%d, %f, %f, %f, %f, %d, %d, %d)", model, Xc, Yc, Zc, ZZc, color1, color2, vehicleIndex);

	new vehicleID;
	if ( coches_Todos_Type[model - 400] != TREN )
	{
   		vehicleID = CreateVehicle(model, Xc, Yc, Zc, ZZc, color1, color2, -1, false);
   	}
   	else
   	{
   		if ( model == 538 || model == 449 )
   		{
	   		vehicleID = AddStaticVehicle(model, Xc, Yc, Zc, ZZc, color1, color2);

			DataCars[vehicleIndex][Gas] = MAX_GAS_VEHICLE;
			DataCars[vehicleIndex][Oil] = MAX_OIL_VEHICLE;

	   		if ( model == 538 )
	   		{
	   			MAX_TRAIN++;
		   		TrainGroups[MAX_TRAIN][0] = vehicleID;
		   		TrainGroups[MAX_TRAIN][1] = vehicleID + 1;
		   		TrainGroups[MAX_TRAIN][2] = vehicleID + 2;
		   		TrainGroups[MAX_TRAIN][3] = vehicleID + 3;
	   		}
   		}
	}

	SetVehicleNumberPlate(vehicleID, DataCars[vehicleIndex][MatriculaString]);

	if (DataCars[vehicleIndex][OwnerId] == 0 && !DataCars[vehicleIndex][JobId] && !DataCars[vehicleIndex][FactionId])
	{
		DataCars[vehicleIndex][AlarmOn] = true;
	}
	else
	{
		DataCars[vehicleIndex][AlarmOn] = false;
	}
	if ( coches_Todos_Type[GetVehicleModel(vehicleID) - 400] != BICI )
	{
		DataCars[vehicleIndex][StateEncendido] = false;
	}
	else
	{
		DataCars[vehicleIndex][StateEncendido] = true;
		IsVehicleOff(vehicleIndex);
	}
	if (GetVehicleModel(vehicleID) == 483)
	{
		ChangeVehiclePaintjob(vehicleID, 0);
	}

	SetVehicleParamsEx(vehicleID, DataCars[vehicleIndex][StateEncendido], DataCars[vehicleIndex][LightState], false, false, DataCars[vehicleIndex][CapoState], DataCars[vehicleIndex][MaleteroState], false);

	SetVehicleVirtualWorld(vehicleID, DataCars[vehicleIndex][World]);
	LinkVehicleToInterior(vehicleID, DataCars[vehicleIndex][Interior]);
	DataCars[vehicleIndex][VehicleID] = vehicleID;
	// printf("Vehicle SQLID: %d created with ID: %d, Index: %d", DataCars[vehicleIndex][ID], vehicleID, vehicleIndex);

	return vehicleIndex;
}

IsVehicleOff(vehicleIndex)
{
	new EngineC, LightsC, AlarmC, DoorsC, BonnetC, BootC, ObjectiveC;
	GetVehicleParamsEx(DataCars[vehicleIndex][VehicleID], EngineC, LightsC, AlarmC, DoorsC, BonnetC, BootC, ObjectiveC);
	SetVehicleParamsEx(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][StateEncendido], DataCars[vehicleIndex][LightState], DataCars[vehicleIndex][AlarmOn], DoorsC, DataCars[vehicleIndex][CapoState], DataCars[vehicleIndex][MaleteroState], ObjectiveC);
}

ChangeVehiclePlate(vehicleIndex, newplate)
{
	if (!newplate)
	{
		do
		{
			DataCars[vehicleIndex][Matricula] = random(999999) + 100000;
		} while ( !ExistPlate(DataCars[vehicleIndex][Matricula]) );
	}
	else
	{
		DataCars[vehicleIndex][Matricula] = newplate;
	}
	format(DataCars[vehicleIndex][MatriculaString], VEHICLE_PLATE_LENGTH, "%i", DataCars[vehicleIndex][Matricula]);

	ChangeVehicle(-1, vehicleIndex, DataCars[vehicleIndex][Modelo], DataCars[vehicleIndex][WorldLast], DataCars[vehicleIndex][InteriorLast]);
}

ChangeVehicle(playerid, vehicleIndex, modelid, worldid, interiorid)
{
	new vehicleid = DataCars[vehicleIndex][VehicleID];
	new Float:VelocityVehicle[3], Float:PosVehicle[4];
	new PosSeat[4]; PosSeat[0] = -1; PosSeat[1] = -1; PosSeat[2] = -1; PosSeat[3] = -1;
	new VEHICLE_PANEL_STATUS:PanelesV, VEHICLE_DOOR_STATUS:PuertasV, VEHICLE_LIGHT_STATUS:LucesV, VEHICLE_TIRE_STATUS:GomasV;
	new LastAlarma = DataCars[vehicleIndex][AlarmOn];
	new LastEncendido = DataCars[vehicleIndex][StateEncendido];
	new LastPuente = DataCars[vehicleIndex][Puente];

	GetVehicleDamageStatus(vehicleid, PanelesV, PuertasV, LucesV, GomasV);

	GetVehicleVelocity(vehicleid, VelocityVehicle[0], VelocityVehicle[1], VelocityVehicle[2]);
	GetVehiclePos(vehicleid, PosVehicle[0], PosVehicle[1], PosVehicle[2]);
	GetVehicleZAngle(vehicleid, PosVehicle[3]);

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == vehicleid )
		{
            if ( GetPlayerVehicleSeat(i) != 127 )
            {
            	PosSeat[GetPlayerVehicleSeat(i)] = i;
        	}
        	else
        	{
				for (new p = 1; p < sizeof(PosSeat); p++)
				{
				    if ( PosSeat[p] == -1 )
				    {
	            		PosSeat[p] = i;
	            		break;
            		}
				}
			}
		}
	}
	if ( playerid != -1 )
	{
        new MsgChangeVehicle[MAX_TEXT_CHAT];
		format(MsgChangeVehicle, sizeof(MsgChangeVehicle), "%s Has cambiado el vehiculo con ID[%i] del modelo \"%s\" por el \"%s\"", LOGO_STAFF, vehicleid, coches_Todos_Nombres[DataCars[vehicleIndex][Modelo] - 400], coches_Todos_Nombres[modelid - 400]);
        SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, MsgChangeVehicle);
    	CleanTunningSlots(vehicleIndex);
    }

	DataCars[vehicleIndex][Modelo] = modelid;
	DestroyVehicle(DataCars[vehicleIndex][VehicleID]);
	CreateVehicleEx(modelid,
		PosVehicle[0],
		PosVehicle[1],
		PosVehicle[2],
		PosVehicle[3],
		DataCars[vehicleIndex][Color1],
		DataCars[vehicleIndex][Color2], vehicleIndex);

	SetVehicleVirtualWorldEx(vehicleIndex, worldid);
	LinkVehicleToInteriorEx(vehicleIndex, interiorid);

	if ( playerid != -1 )
	{
		DataCars[vehicleIndex][AlarmOn] = false;
		DataCars[vehicleIndex][StateEncendido] = true;
		DataCars[vehicleIndex][Puente] = false;
	}
	else
	{
		DataCars[vehicleIndex][AlarmOn] = LastAlarma;
		DataCars[vehicleIndex][StateEncendido] = LastEncendido;
		DataCars[vehicleIndex][Puente] = LastPuente;
	}
	IsVehicleOff(vehicleIndex);
	for (new i = 0; i < sizeof(PosSeat); i++)
	{
	    if ( PosSeat[i] != -1 )
	    {
    		PutPlayerInVehicle(PosSeat[i], DataCars[vehicleIndex][VehicleID], i);
		}
	}
	SetVehicleVelocity(vehicleid, VelocityVehicle[0], VelocityVehicle[1], VelocityVehicle[2]);

	if ( playerid != -1 )
	{
		RepairVehicle(DataCars[vehicleIndex][VehicleID]);
		DataCars[vehicleIndex][Gas] = MAX_GAS_VEHICLE;
		DataCars[vehicleIndex][Oil] = MAX_OIL_VEHICLE;
		DataCars[vehicleIndex][LastDamage] = 1000.0;
	    SetVehicleHealthEx(vehicleIndex, DataCars[vehicleIndex][LastDamage]);
	}
	else
	{
	    SetVehicleHealthEx(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][LastDamage]);
		UpdateVehicleDamageStatus(DataCars[vehicleIndex][VehicleID], PanelesV, PuertasV, LucesV, GomasV);
		for (new t = 0; t < 14; t++ )
		{
		    if ( DataCars[vehicleIndex][SlotsTunning][t] )
		    {
				AddVehicleComponentEx(vehicleIndex, DataCars[vehicleIndex][SlotsTunning][t]);
			}
		}

		if ( DataCars[vehicleIndex][Vinillo] != -1 && IsValidVehiclePaintJob(DataCars[vehicleIndex][Modelo]) )
		{
			ChangeVehiclePaintjob(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][Vinillo]);
		}
		else
		{
			DataCars[vehicleIndex][Vinillo] = -1;
		}
	}
	if ( playerid != -1 && PlayersDataOnline[playerid][InCarId] )
	{
    	UpdateDamage(playerid, DataCars[vehicleIndex][LastDamage], vehicleIndex);
		
	}
}
SetVehicleHealthEx(vehicleIndex, Float:health)
{
    DataCars[vehicleIndex][VehicleAnticheat] = gettime() + 5;
    SetVehicleHealth(DataCars[vehicleIndex][VehicleID], health);
}

IsVehicleNotBici(playerid, vehicleIndex)
{
    if (coches_Todos_Type[GetVehicleModel(DataCars[vehicleIndex][VehicleID]) - 400] != BICI && GetVehicleModel(DataCars[vehicleIndex][VehicleID]) != 570)
    {
        return true;
    }
    else
    {
		SendInfoMessage(playerid, 0, "951", "No puede utilizar ese comando con este vehiculo");
		return false;
	}
}

GetVehicleComponentInSlotEx(vehicleIndex, slotid)
{
	return DataCars[vehicleIndex][SlotsTunning][slotid];
}

AddVehicleCommponentTaller(vehicleIndex, componentid)
{
	if ( GetVehicleComponentInSlotEx(vehicleIndex, GetVehicleComponentType(componentid)) )
	{
	    RemoveVehicleComponentEx(vehicleIndex, componentid);
	}
	else
	{
	    AddVehicleComponentEx(vehicleIndex, componentid);
	}
}

RemoveVehicleComponentEx(vehicleIndex, componentid)
{
	RemoveVehicleComponent(DataCars[vehicleIndex][VehicleID], componentid);
	DataCars[vehicleIndex][SlotsTunning][GetVehicleComponentType(componentid)] = 0;
}

IsVehicleFaction(vehicleIndex)
{
	return DataCars[vehicleIndex][FactionId] > 0;
}

IsVehicleJob(vehicleIndex)
{
	return DataCars[vehicleIndex][JobId] > 0;
}

IsVehicleHasOwner(vehicleIndex)
{
	return DataCars[vehicleIndex][OwnerId] > 0 || IsVehicleFaction(vehicleIndex) || IsVehicleJob(vehicleIndex);
}

GetVehiclePrice(vehicleIndex) 
{
	return coches_Todos_Precios[DataCars[vehicleIndex][Modelo] - 400];
}

IsVehicleOpen(playerid, vehicleIndex, ispassenger)
{
	return (!DataCars[vehicleIndex][Lock] && DataCars[vehicleIndex][OwnerId] > 0) // Esta abierto
		|| (DataCars[vehicleIndex][OwnerId] == 0 && DataCars[vehicleIndex][FactionId] == 0 && DataCars[vehicleIndex][JobId] == 0) // No es de faccion, ni de job y sin dueño
		|| (!DataCars[vehicleIndex][Lock] && IsVehicleMyFaccion(playerid, vehicleIndex)) // Es de mi faccion y esta abierto
		|| (IsVehicleMyJob(playerid, vehicleIndex)) // Es de mi job
		|| (!DataCars[vehicleIndex][Lock] && DataCars[vehicleIndex][FactionId] > 0 && ispassenger != 0); // O es mi vehiculo de faccion y es pasajero
}

IsVehicleWithInterior(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new vehicleIndex = GetVehicleIndexByVehicleID(vehicleid);
	if (GetPlayerVehicleSeat(playerid) >= 2 && DataCars[vehicleIndex][FactionId] != 0)
	{
		if (GetVehicleModel(vehicleid) == 582) // Carro de CNN
		{
			SetPlayerVirtualWorldEx(playerid, vehicleid);
			SetPlayerPos(playerid, PickupInfo[PickupidFurgoCNN][PosInfoX], PickupInfo[PickupidFurgoCNN][PosInfoY], PickupInfo[PickupidFurgoCNN][PosInfoZ]);
			SetPlayerInteriorEx(playerid, 3);
			SetPlayerFacingAngle(playerid, 359.5986);
			SetCameraBehindPlayer(playerid);
			return true;
		}
		else if (GetVehicleModel(vehicleid) == 427) // Camion de police
		{
			SetPlayerVirtualWorldEx(playerid, vehicleid);
			SetPlayerPos(playerid, PickupInfo[PickupidPoliceFurgo][PosInfoX], PickupInfo[PickupidPoliceFurgo][PosInfoY], PickupInfo[PickupidPoliceFurgo][PosInfoZ]);
			SetPlayerInteriorEx(playerid, 3);
			SetPlayerFacingAngle(playerid, 0);
			SetCameraBehindPlayer(playerid);
			return true;
		}
		else if (GetVehicleModel(vehicleid) == 416) // Ambulancia
		{
			SetPlayerVirtualWorldEx(playerid, vehicleid);
			SetPlayerPos(playerid, PickupInfo[PickupidAmbulance][PosInfoX], PickupInfo[PickupidAmbulance][PosInfoY], PickupInfo[PickupidAmbulance][PosInfoZ]);
			SetPlayerInteriorEx(playerid, 3);
			SetPlayerFacingAngle(playerid, 359.5986);
			SetCameraBehindPlayer(playerid);
			return true;
		}
	}
	return false;
}

IntermitenteIzquierdo(playerid)
{
	new vehicleIndex = GetVehicleIndexByVehicleID(GetPlayerVehicleID(playerid));
	if ( IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0 && DataCars[vehicleIndex][IsIntermitente] != 1 )
	{
		new VEHICLE_PANEL_STATUS:Panels, VEHICLE_DOOR_STATUS:Doors1, VEHICLE_LIGHT_STATUS:Lights, VEHICLE_TIRE_STATUS:Tires;
		GetVehicleDamageStatus(GetPlayerVehicleID(playerid), Panels, Doors1, Lights, Tires);
		UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), Panels, Doors1, VEHICLE_LIGHT_STATUS:0b00000001, Tires);
		if (!DataCars[vehicleIndex][IsIntermitente])
		{
		    SetTimerEx("TimerIntermitentes", 500, false, "d", vehicleIndex);
	    }
	    DataCars[vehicleIndex][IsIntermitente] = 1;
	    DataCars[vehicleIndex][ConteoIntermitente] = false;
	}
}
IntermitenteDerecho(playerid)
{
	new vehicleIndex = GetVehicleIndexByVehicleID(GetPlayerVehicleID(playerid));
	if ( IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0 && DataCars[vehicleIndex][IsIntermitente] != 2 )
	{
		new VEHICLE_PANEL_STATUS:Panels, VEHICLE_DOOR_STATUS:Doors1, VEHICLE_LIGHT_STATUS:Lights, VEHICLE_TIRE_STATUS:Tires;
		GetVehicleDamageStatus(GetPlayerVehicleID(playerid), Panels, Doors1, Lights, Tires);
		UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), Panels, Doors1, VEHICLE_LIGHT_STATUS:0b00000100, Tires);
		if (!DataCars[vehicleIndex][IsIntermitente])
		{
		    SetTimerEx("TimerIntermitentes", 500, false, "d", vehicleIndex);
	    }
	    DataCars[vehicleIndex][IsIntermitente] = 2;
	    DataCars[vehicleIndex][ConteoIntermitente] = false;
	}
}
IntermitenteEstacionamiento(playerid)
{
	new vehicleIndex = GetVehicleIndexByVehicleID(GetPlayerVehicleID(playerid));
	if ( IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0 && DataCars[vehicleIndex][IsIntermitente] != 3 )
	{
		new VEHICLE_PANEL_STATUS:Panels, VEHICLE_DOOR_STATUS:Doors1, VEHICLE_LIGHT_STATUS:Lights, VEHICLE_TIRE_STATUS:Tires;
		GetVehicleDamageStatus(GetPlayerVehicleID(playerid), Panels, Doors1, Lights, Tires);
		UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), Panels, Doors1, VEHICLE_LIGHT_STATUS:0b00000101, Tires);
		if (!DataCars[vehicleIndex][IsIntermitente])
		{
		    SetTimerEx("TimerIntermitentes", 500, false, "d", vehicleIndex);
	    }
	    DataCars[vehicleIndex][IsIntermitente] = 3;
	    DataCars[vehicleIndex][ConteoIntermitente] = false;
	}
}
IntermitenteEncendido(playerid)
{
	if (!IsPlayerInAnyVehicle(playerid)) return 1;

	new vehicleIndex = GetVehicleIndexByVehicleID(GetPlayerVehicleID(playerid));
	if (GetPlayerVehicleSeat(playerid) == 0 && DataCars[vehicleIndex][IsIntermitente] == 0 )
	{
	    if ( DataCars[vehicleIndex][LightState] )
	    {
	        DataCars[vehicleIndex][LightState] = false;
		}
		else
		{
			DataCars[vehicleIndex][LightState] = true;
		}
	    IsVehicleOff(vehicleIndex);
	}
	else if (GetPlayerVehicleSeat(playerid) == 0 && DataCars[vehicleIndex][StateEncendido] && DataCars[vehicleIndex][IsIntermitente])
	{
	    DataCars[vehicleIndex][IsIntermitente] = 0;
	}
	return 1;
}

ShowPapelesToPlayer(playerid, playeridshow)
{
	new MsgPapeles[MAX_TEXT_CHAT];
	SendClientMessage(playeridshow, COLOR_MESSAGES[2], "|___________ PAPELES DEL VEHICULO ___________|");
	format(MsgPapeles, sizeof(MsgPapeles), "Propietario: %s", PlayersDataOnline[playerid][NameOnlineFix]);
	SendClientMessage(playeridshow, COLOR_MESSAGES[2], MsgPapeles);
	format(MsgPapeles, sizeof(MsgPapeles), "Modelo: %s", coches_Todos_Nombres[GetVehicleModel(PlayersData[playerid][Car]) - 400]);
	SendClientMessage(playeridshow, COLOR_MESSAGES[2], MsgPapeles);
	format(MsgPapeles, sizeof(MsgPapeles), "Caduca: En %i días y %i horas", DataCars[PlayersData[playerid][Car]][Time] / 24, DataCars[PlayersData[playerid][Car]][Time] % 24);
	SendClientMessage(playeridshow, COLOR_MESSAGES[2], MsgPapeles);
	format(MsgPapeles, sizeof(MsgPapeles), "Matrícula: %i",DataCars[PlayersData[playerid][Car]][Matricula]);
	SendClientMessage(playeridshow, COLOR_MESSAGES[2], MsgPapeles);
}
VerificarCochesVencidos()
{
	for (new i = 1; i <= MAX_CAR; i++ )
	{
		if (IsVehicleHasOwner(i))
		{
		    if ( DataCars[i][Time] <= 1 )
		    {
				RemoveDuenoOfVehicle(i, 3);
			}
			else
			{
				DataCars[i][Time]--;
			}
		}
	}
}
RemoveDuenoOfVehicle(vehicleIndex, option)
{
	// TODO: Revisar implementación de los vehiculos vencidos.
	new playerid = 499;
	format(PlayersDataOnline[playerid][NameOnline], MAX_PLAYER_NAME, "%s", DataCars[vehicleIndex][Dueno]);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && IsVehicleMyVehicle(i, vehicleIndex) )
		{
			playerid = i;
			break;
		}
	}
	if ( playerid == 499 )
	{
		PlayersDataOnline[playerid][Spawn] = false;
		DataUserLoad(playerid);
	}
	DataCars[vehicleIndex][Lock] = false;
	format(DataCars[vehicleIndex][Dueno], MAX_PLAYER_NAME, "0");
	PlayersData[playerid][Car] = -1;
	DataUserSave(playerid);
	GetVehiclePos(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][PosX], DataCars[vehicleIndex][PosY], DataCars[vehicleIndex][PosZ]);
	GetVehicleZAngle(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][PosZZ]);
	DataCars[vehicleIndex][Interior] = GetVehicleInterior(DataCars[vehicleIndex][VehicleID]);
	DataCars[vehicleIndex][World]    = GetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID]);
	SaveDataVehicle(vehicleIndex);
	printf("Vehiculo con SQLID[%i] vencido. Opcion: %i", DataCars[vehicleIndex][ID], option);
	return playerid;
}
EncenderVehicle(playerid)
{
	if ( IsPlayerInAnyVehicle(playerid) && (PlayersDataOnline[playerid][InCarId] || PlayersDataOnline[playerid][InVehicle]) )
	{
	    new MyVehicleID = GetPlayerVehicleID(playerid);
		new vehicleIndex = GetVehicleIndexByVehicleID(MyVehicleID);
		
		if (vehicleIndex == -1) return 1;
	    if ( IsVehicleNotBici(playerid, vehicleIndex) )
	    {
			if ( !DataCars[vehicleIndex][StateEncendido] )
			{
			    if (   !DataCars[vehicleIndex][Puente] // No esta en estado puente
					|| DataCars[vehicleIndex][OwnerId] // Tiene dueño
					|| (IsVehicleMyFaccion(playerid, vehicleIndex) && PlayersData[playerid][Rango] <= 1) // Es lider y es de su fac
					||( IsVehicleMyFaccion(playerid, vehicleIndex) && IsMyCarAsignados(playerid, vehicleIndex))) // Es de su fac y lo tiene asignado
			    {
			        if ( !DataCars[vehicleIndex][LlenandoGas] )
			        {
			            if ( DataCars[vehicleIndex][Oil] < 1)
					    {
							SendInfoMessage(playerid, 2, "0", "Vehiculo sin aceite! Use (Enter) para salir del mismo.");
							return 1;
					    }
			            if ( DataCars[vehicleIndex][Gas] < 1)
					    {
					        SendInfoMessage(playerid, 2, "0", "Vehiculo sin gas! Use (Enter) para salir del mismo.");
							return 1;
						}
				        new Float:VidaVehiculo;
						GetVehicleHealth(MyVehicleID, VidaVehiculo);
			            new IntentarText[100];
			            new puedeArrancar;

		            	if (GetPlayerVehicleSeat(playerid) == 0)
						format(IntentarText, sizeof(IntentarText), "encender el vehiculo");
						else
						format(IntentarText, sizeof(IntentarText), "ayudar a encender el vehiculo");

						if ( VidaVehiculo >= 650.0 )
						{
						    if (GetPlayerVehicleSeat(playerid) == 0)
						    {
						        Acciones(playerid, 0, "encendio el motor del vehiculo.");
						        puedeArrancar = true;
						    }
						    else if (IntentarAccion(playerid, IntentarText, random(5)))
						    {
						        puedeArrancar = true;
						    }
						}
						else
						{
						    new RandNum;
							if ( VidaVehiculo >= 550.0 )
							RandNum = 4;
							else
							RandNum = 2;
							if (IntentarAccion(playerid, IntentarText, random(RandNum)))
							puedeArrancar = true;
						}
			            if (puedeArrancar)
			            {
			                DataCars[vehicleIndex][StateEncendido] = true;
						    Acciones(playerid, 7, "Vehiculo: Encendido...");
	    					DataCars[vehicleIndex][TimeGas] = gettime();
							IsVehicleOff(vehicleIndex);
							new IsBomb = IsVehicleHaveBomba(DataCars[vehicleIndex][VehicleID]);
							if ( IsBomb != -1 )
							{
							    ActivarBomba(IsBomb, 20);
								SetVehicleHealthEx(vehicleIndex, 0.0);
							}
			            }

					}
					else
					{
						SendInfoMessage(playerid, 0, "1057", "Este vehiculo esta llenando el deposito, espere que termine para encenderlo!");
					}
			    }
			}
			else
			{
				SendInfoMessage(playerid, 0, "833", "Este vehiculo ya se encuentra encendido!");
			}
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "834", "Suba al vehiculo que desea encender y use (/Encender o N)");
	}
	return 1;
}
ApagarVehicle(playerid)
{
	if ( IsPlayerInAnyVehicle(playerid) )
	{
	    new MyVehicleID = GetPlayerVehicleID(playerid);
		new vehicleIndex = GetVehicleIndexByVehicleID(MyVehicleID);
	    if ( IsVehicleNotBici(playerid, vehicleIndex) )
	    {
			if ( DataCars[vehicleIndex][StateEncendido] )
			{
			    if ( GetPlayerVehicleSeat(playerid) == 0 )
			    {
					if ( coches_Todos_Type[GetVehicleModel(MyVehicleID) - 400] != MOTO )
				  	{
						ApplyPlayerAnimCustom(playerid,
							"PED",
							PED_ANIMATIONS[63], false);
					}
					Acciones(playerid, 8, "apaga el motor del vehiculo");
				    Acciones(playerid, 7, "Vehiculo: Apagado...");
					DataCars[vehicleIndex][StateEncendido] = false;
					IsVehicleOff(vehicleIndex);

				}
				else
				{
					SendInfoMessage(playerid, 0, "829", "Solo puede apagar el vehiculo desde el asiento del conductor!");
				}
			}
			else
			{
				SendInfoMessage(playerid, 0, "860", "Este vehiculo ya se encuentra apagado!");
			}
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "861", "Suba al vehiculo que desea apagar y use (/Apagar)");
	}
}
SetVehicleHidden(vehicleIndex)
{
	if ( GetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID]) != 999 )
	{
		SetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID], 999);
		DataCars[vehicleIndex][RespawnTimerId] = SetTimerEx("SetVehicleShow", MAX_TIME_VEHICLE_HIDDEN, false, "d", vehicleIndex);
		DataCars[vehicleIndex][WorldLast] 		= DataCars[vehicleIndex][World];
		DataCars[vehicleIndex][InteriorLast]	= DataCars[vehicleIndex][Interior];
	}
}

RemoveVehicleHidden(vehicleIndex)
{
	if (GetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID]) == 999 )
	{
		KillTimer(DataCars[vehicleIndex][RespawnTimerId]);
		SetVehicleShow(vehicleIndex);
	}
}

IsAlarmaBug(vehicleIndex)
{
	new EngineC, LightsC, AlarmC, DoorsC, BonnetC, BootC, ObjectiveC;
	GetVehicleParamsEx(DataCars[vehicleIndex][VehicleID], EngineC, LightsC, AlarmC, DoorsC, BonnetC, BootC, ObjectiveC);
	if ( AlarmC && DataCars[vehicleIndex][AlarmOn] )
	{
		SetVehicleParamsEx(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][StateEncendido], DataCars[vehicleIndex][LightState], DataCars[vehicleIndex][AlarmOn], DoorsC, DataCars[vehicleIndex][CapoState], DataCars[vehicleIndex][MaleteroState], ObjectiveC);
	}
}

LockAlarma(playerid)
{
	new MyNearCar = IsPlayerInNearVehicle(playerid);
	new vehicleIndex = GetVehicleIndexByVehicleID(MyNearCar);

	if (vehicleIndex == -1) 
		return false;

	if (IsVehicleMyVehicle(playerid, vehicleIndex) ||
		IsVehicleMyFaccion(playerid, vehicleIndex) && PlayersData[playerid][Rango] <= 1 ||
		IsVehicleMyFaccion(playerid, vehicleIndex) && IsMyCarAsignados(playerid, vehicleIndex))
	{
		new MsgAlarm[MAX_TEXT_CHAT];
		if (DataCars[vehicleIndex][AlarmOn])
		{
			DataCars[vehicleIndex][AlarmOn] = false;
			GameTextForPlayer(playerid, "~w~Alarma ~R~Desactivada", 1000, 3);
			IsVehicleOff(vehicleIndex);
			Acciones(playerid, 8, "desactiva la alarma del vehiculo");
		}
		else
		{
			DataCars[vehicleIndex][AlarmOn] = true;
			GameTextForPlayer(playerid, "~w~Alarma ~G~Activada", 1000, 3);
			Acciones(playerid, 8, "activa la alarma del vehiculo");
		}

		if (!DataCars[vehicleIndex][FactionId])
		{
			format(MsgAlarm, sizeof(MsgAlarm), "%s la alarma de su vehiculo.", NamesAlarma[DataCars[vehicleIndex][AlarmOn]]);
		}
		else
		{
			format(MsgAlarm, sizeof(MsgAlarm), "%s la alarma a un vehiculo de faccion.", NamesAlarma[DataCars[vehicleIndex][AlarmOn]]);
		}
		SendInfoMessage(playerid, 2, "0", MsgAlarm);
		PlayPlayerStreamSound(playerid, 1147);
		return true;
	}
	else
	{
		SendInfoMessage(playerid, 0, "1006", "Este no es su vehiculo");
		return false;
	}
}
LockGuantera(playerid)
{
	new MyLockVehicle = IsPlayerInsideVehicle(playerid);
	new vehicleIndex = GetVehicleIndexByVehicleID(MyLockVehicle);
	if ( vehicleIndex != -1 )
	{
		if (IsVehicleMyVehicle(playerid, vehicleIndex) ||
			IsVehicleMyFaccion(playerid, vehicleIndex) && PlayersData[playerid][Rango] <= 1 ||
			IsVehicleMyFaccion(playerid, vehicleIndex) && IsMyCarAsignados(playerid, vehicleIndex))
		{
		    new MsgLock[MAX_TEXT_CHAT];
		    if ( DataCars[vehicleIndex][GuanteraLock] )
		    {
		    	DataCars[vehicleIndex][GuanteraLock] = false;
				GameTextForPlayer(playerid, "~w~Guantera ~R~Cerrada", 1000, 3);
	    	}
	    	else
	    	{
		    	DataCars[vehicleIndex][GuanteraLock] = true;
				GameTextForPlayer(playerid, "~w~Guantera ~G~Abierta", 1000, 3);
			}

			if (!DataCars[vehicleIndex][FactionId])
			{
				format(MsgLock, sizeof(MsgLock), "%s la guantera de su vehiculo.", NamesLookReverse[DataCars[vehicleIndex][GuanteraLock]]);
			}
			else
			{
				format(MsgLock, sizeof(MsgLock), "%s la guantera de un vehiculo de faccion.", NamesLookReverse[DataCars[vehicleIndex][GuanteraLock]]);
			}
		    SendInfoMessage(playerid, 2, "0", MsgLock);
		    return true;
	    }
	    else
		{
			SendInfoMessage(playerid, 0, "747", "Este no es su vehiculo");
		    return false;
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "748", "No se encuentra dentro del vehiculo");
	    return false;
	}
}
IsPlayerInsideVehicle(playerid)
{
	if ( PlayersDataOnline[playerid][InCarId] )
	{
	    return PlayersDataOnline[playerid][InCarId];
	}
	else if ( PlayersDataOnline[playerid][InVehicle] )
	{
	    return PlayersDataOnline[playerid][InVehicle];
	}
	return false;
}
LockMaletero(playerid)
{
	new MyNearCar = IsPlayerInNearVehicle(playerid);
	new vehicleIndex = GetVehicleIndexByVehicleID(MyNearCar);
	if ( vehicleIndex != -1 )
	{
		if (IsVehicleMyVehicle(playerid, vehicleIndex) ||
			IsVehicleMyFaccion(playerid, vehicleIndex) && PlayersData[playerid][Rango] <= 1 ||
			IsVehicleMyFaccion(playerid, vehicleIndex) && IsMyCarAsignados(playerid, vehicleIndex))
		{
		    new MsgLock[MAX_TEXT_CHAT];
		    if ( DataCars[vehicleIndex][MaleteroState] )
		    {
		    	DataCars[vehicleIndex][MaleteroState] = false;
				GameTextForPlayer(playerid, "~w~Maletero ~R~Cerrado", 1000, 3);
	    	}
	    	else
	    	{
		    	DataCars[vehicleIndex][MaleteroState] = true;
				GameTextForPlayer(playerid, "~w~Maletero ~G~Abierto", 1000, 3);
			}

			if (!DataCars[vehicleIndex][FactionId])
			{
				format(MsgLock, sizeof(MsgLock), "%s el maletero de su vehiculo.", NamesLookReverse[DataCars[vehicleIndex][MaleteroState]]);
			}
			else
			{
				format(MsgLock, sizeof(MsgLock), "%s el maletero a un vehiculo de faccion.", NamesLookReverse[DataCars[vehicleIndex][MaleteroState]]);
			}
		    SendInfoMessage(playerid, 2, "0", MsgLock);
			IsVehicleOff(vehicleIndex);
		    return true;
	    }
	    else
		{
			SendInfoMessage(playerid, 0, "1007", "Este no es su vehiculo");
		    return false;
		}
	}
	else
	{
	    return false;
	}
}

UpdatePlayerVehicleStatus(vehicleIndex , Float:Healt)
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == DataCars[vehicleIndex][VehicleID] )
		{
			SetPlayerHealthEx(i, -Healt);
			if ( coches_Todos_Type[GetVehicleModel(GetPlayerVehicleID(i)) - 400] != MOTO )
			{
				ApplyPlayerAnimCustom(i,
				"PED",
				PED_ANIMATIONS[23], false);
				if ( GetPlayerVehicleSeat(i) == 0 )
				{
				    SetTimerEx("ApplyPlayerAnimAccidentD", 1000, false, "d",i);
				}
				else
				{
				    SetTimerEx("ApplyPlayerAnimAccident", 1000, false, "d",i);
				}
			}
		    if ( Healt >= 20 )
		    {
			    SetPlayerWeather(i, -15);
			    SetPlayerDrunkLevel(i, 50000);
				SetTimerEx("ReturnPlayerNormalState", 15000, false, "d", i);
		    }
		}
	}
}
IsTunningForVehicle(modelid)
{
	for ( new i = 0; i < sizeof(ListTRANSFENDEREscape);i++)
	{
	    if ( ListTRANSFENDEREscape[i] == modelid )
	    {
	        return 1;
		}
	}
	for ( new i = 0; i < sizeof(ListTRANSFENDERSentinel);i++)
	{
	    if ( ListTRANSFENDERSentinel[i] == modelid )
	    {
	        return 2;
		}
	}
	for ( new i = 0; i < sizeof(ListTRANSFENDER);i++)
	{
	    if ( ListTRANSFENDER[i] == modelid )
	    {
	        return 3;
		}
	}
	return false;
}
CleanTunningSlots(vehicleIndex)
{
	for (new t = 0; t < 14; t++ )
	{
		DataCars[vehicleIndex][SlotsTunning][t] = 0;
    }
    DataCars[vehicleIndex][Vinillo] = -1;
}
SetLastSettingVehicle(vehicleIndex)
{
	new vehicleid = DataCars[vehicleIndex][VehicleID];
	CreateVehicleEx(DataCars[vehicleIndex][Modelo], DataCars[vehicleIndex][LastX], DataCars[vehicleIndex][LastY], DataCars[vehicleIndex][LastZ], DataCars[vehicleIndex][LastZZ], DataCars[vehicleIndex][Color1], DataCars[vehicleIndex][Color2], vehicleIndex);
	UpdateVehicleDamageStatus(vehicleid, DataCars[vehicleIndex][PanelS], DataCars[vehicleIndex][DoorS], DataCars[vehicleIndex][LightS], DataCars[vehicleIndex][TiresS]);
	if ( DataCars[vehicleIndex][Vinillo] != -1 && IsValidVehiclePaintJob(DataCars[vehicleIndex][Modelo]) )
	{
		ChangeVehiclePaintjob(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][Vinillo]);
	}
	else
	{
		DataCars[vehicleIndex][Vinillo] = -1;
	}
	for (new t = 0; t < 14; t++ )
	{
	    if ( DataCars[vehicleIndex][SlotsTunning][t] )
	    {
			AddVehicleComponentEx(vehicleIndex, DataCars[vehicleIndex][SlotsTunning][t]);
		}
	}
	if ( DataCars[vehicleIndex][LastDamage] >= 250.0 )
	{
		SetVehicleHealthEx(vehicleIndex, DataCars[vehicleIndex][LastDamage]);
		GetVehicleHealth(vehicleid, DataCars[vehicleIndex][LastDamage]);
	}
	SetVehicleVirtualWorld(vehicleid, DataCars[vehicleIndex][WorldLast]);
	LinkVehicleToInterior(vehicleid, DataCars[vehicleIndex][InteriorLast]);
}
AddVehicleComponentEx(vehicleIndex, componentid)
{
	AddVehicleComponent(DataCars[vehicleIndex][VehicleID], componentid);
	DataCars[vehicleIndex][SlotsTunning][GetVehicleComponentType(componentid)] = componentid;
}
SetVehicleToRespawnEx(vehicleIndex)
{
	new vehicleid = DataCars[vehicleIndex][VehicleID];
	if ( coches_Todos_Type[DataCars[vehicleIndex][Modelo] - 400] != TREN )
	{
		RemoveVehicleHidden(vehicleIndex);
		DestroyVehicle(vehicleid);
		CleanTunningSlots(vehicleIndex);
		CreateVehicleEx(DataCars[vehicleIndex][Modelo],
			DataCars[vehicleIndex][PosX],
			DataCars[vehicleIndex][PosY],
			DataCars[vehicleIndex][PosZ],
			DataCars[vehicleIndex][PosZZ],
			DataCars[vehicleIndex][Color1],
			DataCars[vehicleIndex][Color2], vehicleIndex);
	}
	else
	{
	    SetVehicleToRespawn(vehicleid);
	}
	vehicleid = DataCars[vehicleIndex][VehicleID];
	if ( DataCars[vehicleIndex][VehicleDeath] )
	{
		DataCars[vehicleIndex][VehicleDeath] = false;
		KillTimer(DataCars[vehicleIndex][TimerIdBug]);
	}
	GetVehicleHealth(vehicleid, DataCars[vehicleIndex][LastDamage]);
    DataCars[vehicleIndex][WorldLast]    = DataCars[vehicleIndex][World];
    DataCars[vehicleIndex][InteriorLast] = DataCars[vehicleIndex][Interior];
    GetVehiclePos(vehicleid, DataCars[vehicleIndex][LastX], DataCars[vehicleIndex][LastY], DataCars[vehicleIndex][LastZ]);
    GetVehicleZAngle(vehicleid, DataCars[vehicleIndex][LastZZ]);
}
SetVehicleToRespawnExTwo(vehicleIndex)
{
	new vehicleid = DataCars[vehicleIndex][VehicleID];
	if ( coches_Todos_Type[DataCars[vehicleIndex][Modelo] - 400] != TREN )
	{
		RemoveVehicleHidden(vehicleIndex);
		DestroyVehicle(vehicleid);

		CreateVehicleEx(DataCars[vehicleIndex][Modelo],
			DataCars[vehicleIndex][PosX],
			DataCars[vehicleIndex][PosY],
			DataCars[vehicleIndex][PosZ],
			DataCars[vehicleIndex][PosZZ],
			DataCars[vehicleIndex][Color1],
			DataCars[vehicleIndex][Color2], vehicleIndex);

		if ( DataCars[vehicleIndex][Vinillo] != -1 && IsValidVehiclePaintJob(DataCars[vehicleIndex][Modelo]) )
		{
			ChangeVehiclePaintjob(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][Vinillo]);
		}
		else
		{
			DataCars[vehicleIndex][Vinillo] = -1;
		}
		for (new t = 0; t < 14; t++ )
		{
		    if ( DataCars[vehicleIndex][SlotsTunning][t] )
		    {
				AddVehicleComponentEx(vehicleIndex, DataCars[vehicleIndex][SlotsTunning][t]);
			}
		}
	}
	else
	{
	    SetVehicleToRespawn(vehicleid);
	}
	if ( DataCars[vehicleIndex][VehicleDeath] )
	{
		DataCars[vehicleIndex][VehicleDeath] = false;
		KillTimer(DataCars[vehicleIndex][TimerIdBug]);
	}
	GetVehicleHealth(vehicleid, DataCars[vehicleIndex][LastDamage]);
    DataCars[vehicleIndex][WorldLast]    = DataCars[vehicleIndex][World];
    DataCars[vehicleIndex][InteriorLast] = DataCars[vehicleIndex][Interior];
    GetVehiclePos(vehicleid, DataCars[vehicleIndex][LastX], DataCars[vehicleIndex][LastY], DataCars[vehicleIndex][LastZ]);
    GetVehicleZAngle(vehicleid, DataCars[vehicleIndex][LastZZ]);
}
LockTrain(vehicleid, LockV)
{
	for ( new t = 0; t <= MAX_TRAIN; t++ )
	{
		for ( new i = 0; i < 4; i++ )
		{
	    	if ( TrainGroups[t][i] == vehicleid )
	    	{
				for ( new f = 0; f < 4; f++ )
				{
				    DataCars[TrainGroups[t][f]][Lock] = LockV;
				}
				break;
			}
	   	}
   	}
}
GetTrainByVehicleID(vehicleid)
{
	for ( new t = 0; t <= MAX_TRAIN; t++ )
	{
		for ( new i = 0; i < 4; i++ )
		{
	    	if ( TrainGroups[t][i] == vehicleid )
	    	{
				return TrainGroups[t][0];
			}
	   	}
   	}
   	return false;
}
GetVagonByVehicleID(vehicleid)
{
	for ( new t = 0; t <= MAX_TRAIN; t++ )
	{
		for ( new i = 0; i < 4; i++ )
		{
	    	if ( TrainGroups[t][i] == vehicleid )
	    	{
				return i;
			}
	   	}
   	}
   	return false;
}
LinkVehicleToInteriorEx(vehicleIndex, interiorid)
{
    LinkVehicleToInterior(DataCars[vehicleIndex][VehicleID], interiorid);
	DataCars[vehicleIndex][InteriorLast] = interiorid;
}
SetVehicleVirtualWorldEx(vehicleIndex, worldid)
{
    SetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID], worldid);
	DataCars[vehicleIndex][WorldLast] = worldid;
}

ExistPlate(plate)
{
	for (new i = 0; i <= MAX_CAR; i++ )
	{
		if ( DataCars[i][Matricula] == plate )
		{
		    return true;
	    }
	}
	return false;
}

RemovePlayerFromVehicleEx(playerid, seat, time)
{
	if (!seat)
	{
		new vehicleIndex = GetVehicleIndexByVehicleID(PlayersDataOnline[playerid][InCarId]);
	    if ( !PlayersDataOnline[playerid][StateDeath] && PlayersData[playerid][IsInJail] == -1 )
	    {
			if ( PlayersDataOnline[playerid][StateMoneyPass] <= time )
			{
			    if ( !DataCars[vehicleIndex][VehicleDeath] )
			    {
					new Float:PlayerPos[3]; 
					GetPlayerPos(playerid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);
					new Float:VehiclePos[3]; 
					GetVehiclePos(DataCars[vehicleIndex][VehicleID], VehiclePos[0], VehiclePos[1], VehiclePos[2]);
					if ( !IsPointFromPoint(50.0, PlayerPos[0], PlayerPos[1], PlayerPos[2], VehiclePos[0], VehiclePos[1], VehiclePos[2]) )
					{
				    	SetVehiclePos(DataCars[vehicleIndex][VehicleID], PlayerPos[0], PlayerPos[1] + 1, PlayerPos[2]);
			    	}
		    	}
			}
		}

		// nuevo velocimetro - eliminado hide de sistema viejo
		PlayersDataOnline[playerid][InCarId] = false;
		TogglePlayerControllableEx(playerid, true);

	}
	else
	{
		if ( PlayersDataOnline[playerid][IsTaxi] != -1 )
		{
			PayTaxi(playerid, true);
		}
    	PlayersDataOnline[playerid][InVehicle] = false;
	}
}

PlayAudioPlayerVehicle(playerid, vehicleIndex)
{
	if (DataCars[vehicleIndex][StationID] != -1)
	{
	    PlayAudioStreamForPlayer(playerid, Stations[DataCars[vehicleIndex][StationID]][1]);
	}
}

StopMusicOnVehicle(vehicleIndex)
{
	for ( new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && (PlayersDataOnline[i][InVehicle] == DataCars[vehicleIndex][VehicleID] || PlayersDataOnline[i][InCarId] == DataCars[vehicleIndex][VehicleID]) )
		{
		    StopAudioStreamForPlayer(i);
		}
	}
}

ChangeMusicOnVehicle(vehicleIndex)
{
	for ( new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && (PlayersDataOnline[i][InVehicle] == DataCars[vehicleIndex][VehicleID] || PlayersDataOnline[i][InCarId] == DataCars[vehicleIndex][VehicleID]) )
		{
			PlayAudioPlayerVehicle(i, vehicleIndex);
		}
	}
}
ShowAndHideSirena(playerid, vehicleIndex)
{
	if ( DataCars[vehicleIndex][AttachObjectID] )
	{
	    DestroyObject(DataCars[vehicleIndex][AttachObjectID]);
		DataCars[vehicleIndex][AttachObjectID] = false;
		SendInfoMessage(playerid, 2, "0", "Sirena desactivada!");
	}
	else
	{
	    DataCars[vehicleIndex][AttachObjectID] = CreateObject(18646, -1000, -1000, -1000, -1000, -1000, 500, 300.0);
		AttachObjectToVehicle(DataCars[vehicleIndex][AttachObjectID], DataCars[vehicleIndex][VehicleID], 0.4, 0.6, 0.3, 0, 0, 0);
		SendInfoMessage(playerid, 2, "0", "Sirena encendida!");
	}
}

IsVehicleBug(vehicleIndex, SpawnBug)
{
	if ( GetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID]) != 999 )
	{
		if ( DataCars[vehicleIndex][WorldLast] > 999 )
		{
			new HouseID = GetHouseidIdByWorld(DataCars[vehicleIndex][WorldLast]);
			if ( HouseID )
			{
				new GarageID = GetGarageIdByWorld(HouseID, DataCars[vehicleIndex][WorldLast]);
				if ( GarageID != -1 )
				{
				    new Float:VehiclePosBug[3]; 
					GetVehiclePos(DataCars[vehicleIndex][VehicleID], VehiclePosBug[0], VehiclePosBug[1], VehiclePosBug[2]);
					if ( GetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID]) != DataCars[vehicleIndex][WorldLast] || !IsPointFromPoint(30.0, VehiclePosBug[0], VehiclePosBug[1], VehiclePosBug[2], TypeGarage[Garages[HouseID][GarageID][TypeGarageE]][PosXc], TypeGarage[Garages[HouseID][GarageID][TypeGarageE]][PosYc], TypeGarage[Garages[HouseID][GarageID][TypeGarageE]][PosZc]) )
					{
					    if ( SpawnBug )
					    {
							new MsgAviso[MAX_TEXT_CHAT];
						    format(MsgAviso, sizeof(MsgAviso), "%s Bug Report - El vehiculo con ID[%i] se ha desbugueado automaticamente (Tipo de debug: Pos)", LOGO_STAFF, DataCars[vehicleIndex][VehicleID]);
							MsgCheatsReportsToAdmins(MsgAviso);

							SetVehicleVirtualWorldEx(vehicleIndex, Garages[HouseID][GarageID][WorldG]);
							LinkVehicleToInteriorEx(vehicleIndex, TypeGarage[Garages[HouseID][GarageID][TypeGarageE]][Interior]);
							SetVehiclePos(DataCars[vehicleIndex][VehicleID], TypeGarage[Garages[HouseID][GarageID][TypeGarageE]][PosXc], TypeGarage[Garages[HouseID][GarageID][TypeGarageE]][PosYc], TypeGarage[Garages[HouseID][GarageID][TypeGarageE]][PosZc]);
							SetVehicleZAngle(DataCars[vehicleIndex][VehicleID], TypeGarage[Garages[HouseID][GarageID][TypeGarageE]][PosZZc]);
						}
						return true;
					}
	   			}
			}
		}
		else if ( DataCars[vehicleIndex][WorldLast] != GetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID]) )
		{
		    if ( SpawnBug )
		    {
				new MsgAviso[MAX_TEXT_CHAT];
			    format(MsgAviso, sizeof(MsgAviso), "%s Bug Report - El vehiculo con ID[%i] se ha desbugueado automaticamente (Tipo de debug: Spawn)", LOGO_STAFF, DataCars[vehicleIndex][VehicleID]);
				MsgCheatsReportsToAdmins(MsgAviso);
	        	SetVehicleToRespawnExTwo(vehicleIndex);
        	}
	        return true;
		}
   }
	return false;
}

UpdateTextDrawVehicle(playerid, vehicleIndex)
{
	new Float:Velocity[3], vehicleid = DataCars[vehicleIndex][VehicleID];
	GetVehicleVelocity(vehicleid, Velocity[0], Velocity[1], Velocity[2]);
	new VelocityInt = floatround(floatsqroot(floatpower(floatabs(Velocity[0]), 2.0) + floatpower(floatabs(Velocity[1]), 2.0) + floatpower(floatabs(Velocity[2]), 2.0)) * 120.0);

	new Float:Estado;
	GetVehicleHealth(vehicleid, Estado);
	if ( coches_Todos_Velocidad[DataCars[vehicleIndex][Modelo] - 400] )
	{
	    new TextTempId;
	    if (Estado >= 650.0)
	    TextTempId = floatround((10 * float(VelocityInt) / (float(coches_Todos_Velocidad[DataCars[vehicleIndex][Modelo] - 400]) / float(100)) / 100));
	    else if (Estado >= 550.0)
	    TextTempId = floatround((20 * float(VelocityInt) / (float(coches_Todos_Velocidad[DataCars[vehicleIndex][Modelo] - 400]) / float(100)) / 100));
	    else
		TextTempId = floatround((40 * float(VelocityInt) / (float(coches_Todos_Velocidad[DataCars[vehicleIndex][Modelo] - 400]) / float(100)) / 100));
		if ( TextTempId <= coches_Todos_Velocidad[DataCars[vehicleIndex][Modelo] - 400] )
		{
			if ( TextTempId >= 40 )
			{
			    if ( !DataCars[vehicleIndex][TemperaturaC] )
			    {
			        if ( gettime() > DataCars[vehicleIndex][TimeCalentamiento] && DataCars[vehicleIndex][TimeCalentamiento])
			        {
				        DataCars[vehicleid][TemperaturaC] = true;
			        	SetVehicleHealthEx(vehicleIndex, Estado - 50);
			        	DataCars[vehicleid][LastDamage] = DataCars[vehicleid][LastDamage] - 50;
			        	Estado -= 50;
		        	}
		        	else
		        	{
			        	PlayPlayerStreamSound(playerid, 1056);
						if ( !DataCars[vehicleIndex][TimeCalentamiento] )
						{
		        	    	DataCars[vehicleIndex][TimeCalentamiento] = gettime() + 5;
	        	    	}
					}
				}
        	}
        	else
        	{
        	    DataCars[vehicleIndex][TimeCalentamiento] = 0;
	        	DataCars[vehicleIndex][TemperaturaC] = false;
			}
	    }
	}
	if ( (DataCars[vehicleIndex][LastDamage] - Estado) != 0 )
	{
	    if ( (DataCars[vehicleIndex][LastDamage] - Estado) > 0.0 )
	    {
			if ( PlayersDataOnline[playerid][PistaIDp] != -1 && Pistas[PlayersDataOnline[playerid][PistaIDp]][Repair] )
			{
				RepairVehicle(vehicleid);
				SetVehicleHealthEx(vehicleIndex, 1000.0);
				Estado = 1000.0;
			}
			else if ( !DataCars[vehicleIndex][TemperaturaC] )
			{
			    if ( !PlayersDataOnline[playerid][AdminOn] )
			    {
					UpdatePlayerVehicleStatus(vehicleIndex, (DataCars[vehicleIndex][LastDamage] - Estado) / 10);
			    }
			}
		}
		UpdateDamage(playerid, Estado, vehicleIndex);
	}
	DataCars[vehicleIndex][LastDamage] 		= Estado;
	return true;
}
UpdateDamage(playerid, &Float:newdamage, vehicleIndex)
{
	if ( newdamage > DataCars[vehicleIndex][LastDamage] && DataCars[vehicleIndex][VehicleAnticheat] <= gettime() )
	{
		SetVehicleHealth(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][LastDamage]);
		UpdateVehicleDamageStatus(DataCars[vehicleIndex][VehicleID], DataCars[PlayersDataOnline[playerid][InCarId]][PanelS], DataCars[PlayersDataOnline[playerid][InCarId]][DoorS], DataCars[vehicleIndex][LightS], DataCars[PlayersDataOnline[playerid][InCarId]][TiresS]);
		newdamage = DataCars[vehicleIndex][LastDamage];
		new MsgAviso[MAX_TEXT_CHAT];
		format(MsgAviso, sizeof(MsgAviso), "%s AntiCheat-Repair - %s[%i] posible cheat de repair vehicle. Datos: ID del vehiculo %i", LOGO_STAFF, PlayersDataOnline[playerid][NameOnline], playerid, DataCars[vehicleIndex][VehicleID]);
		MsgCheatsReportsToAdmins(MsgAviso);
	}
	else
	{
		GetVehicleDamageStatus(DataCars[vehicleIndex][VehicleID], DataCars[PlayersDataOnline[playerid][InCarId]][PanelS], DataCars[PlayersDataOnline[playerid][InCarId]][DoorS], DataCars[PlayersDataOnline[playerid][InCarId]][LightS], DataCars[PlayersDataOnline[playerid][InCarId]][TiresS]);
	}
}
LoadVehicles()
{
	new Cache:result = mysql_query(dataBase, "SELECT * FROM vehicles");
	new rows = cache_num_rows();
	
	for (new i = 0; i < rows; i++) 
	{
		cache_get_value_name_int(i, "ID", DataCars[i][ID]);
		cache_get_value_name_int(i, "Modelo", DataCars[i][Modelo]);
		cache_get_value_name_float(i, "PosX", DataCars[i][PosX]);
		cache_get_value_name_float(i, "PosY", DataCars[i][PosY]);
		cache_get_value_name_float(i, "PosZ", DataCars[i][PosZ]);
		cache_get_value_name_float(i, "PosZZ", DataCars[i][PosZZ]);

		cache_get_value_name_int(i, "Modelo", DataCars[i][Modelo]);

		cache_get_value_name_int(i, "Color1", DataCars[i][Color1]);
		cache_get_value_name_int(i, "Color2", DataCars[i][Color2]);
		cache_get_value_name(i, "Dueno", DataCars[i][Dueno], MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "Seguro", DataCars[i][Lock]);
		cache_get_value_name_int(i, "Time", DataCars[i][Time]);
		cache_get_value_name_int(i, "Matricula", DataCars[i][Matricula]);
		format(DataCars[i][MatriculaString], 32, "%i", DataCars[i][Matricula]);
		cache_get_value_name_int(i, "LockPolice", DataCars[i][LockPolice]);
		cache_get_value_name(i, "ReasonLock", DataCars[i][ReasonLock], 50);
		cache_get_value_name_int(i, "Maletero_0_0", coches_Todos_Maleteros[i][0][0]);
		cache_get_value_name_int(i, "Maletero_0_1", coches_Todos_Maleteros[i][0][1]);
		cache_get_value_name_int(i, "Maletero_1_0", coches_Todos_Maleteros[i][1][0]);
		cache_get_value_name_int(i, "Maletero_1_1", coches_Todos_Maleteros[i][1][1]);
		cache_get_value_name_int(i, "Maletero_2_0", coches_Todos_Maleteros[i][2][0]);
		cache_get_value_name_int(i, "Maletero_2_1", coches_Todos_Maleteros[i][2][1]);
		cache_get_value_name_int(i, "Maletero_3_0", coches_Todos_Maleteros[i][3][0]);
		cache_get_value_name_int(i, "Maletero_3_1", coches_Todos_Maleteros[i][3][1]);
		cache_get_value_name_int(i, "Maletero_4_0", coches_Todos_Maleteros[i][4][0]);
		cache_get_value_name_int(i, "Maletero_4_1", coches_Todos_Maleteros[i][4][1]);
		cache_get_value_name_int(i, "Maletero_5_0", coches_Todos_Maleteros[i][5][0]);
		cache_get_value_name_int(i, "Maletero_5_1", coches_Todos_Maleteros[i][5][1]);
		cache_get_value_name_int(i, "Maletero_6_0", coches_Todos_Maleteros[i][6][0]);
		cache_get_value_name_int(i, "Maletero_6_1", coches_Todos_Maleteros[i][6][1]);
		cache_get_value_name_int(i, "Maletero_7", coches_Todos_Maleteros[i][7][0]);
		cache_get_value_name_int(i, "Maletero_8", coches_Todos_Maleteros[i][8][0]);
		cache_get_value_name_int(i, "Maletero_9", coches_Todos_Maleteros[i][9][0]);
		cache_get_value_name_int(i, "Maletero_10", coches_Todos_Maleteros[i][10][0]);
		cache_get_value_name_int(i, "Maletero_11", coches_Todos_Maleteros[i][11][0]);
		cache_get_value_name_int(i, "MaleteroState", DataCars[i][MaleteroState]);
		cache_get_value_name_int(i, "Oil", DataCars[i][Oil]);
		cache_get_value_name_int(i, "Gas", DataCars[i][Gas]);
		cache_get_value_name_float(i, "LastX", DataCars[i][LastX]);
		cache_get_value_name_float(i, "LastY", DataCars[i][LastY]);
		cache_get_value_name_float(i, "LastZ", DataCars[i][LastZ]);
		cache_get_value_name_float(i, "LastZZ", DataCars[i][LastZZ]);
		cache_get_value_name_float(i, "LastDamage", DataCars[i][LastDamage]);
		cache_get_value_name_int(i, "PanelS", DataCars[i][PanelS]);
		cache_get_value_name_int(i, "DoorS", DataCars[i][DoorS]);
		cache_get_value_name_int(i, "LightS", DataCars[i][LightS]);
		cache_get_value_name_int(i, "TiresS", DataCars[i][TiresS]);
		cache_get_value_name_int(i, "SlotsTunning_0", DataCars[i][SlotsTunning][0]);
		cache_get_value_name_int(i, "SlotsTunning_1", DataCars[i][SlotsTunning][1]);
		cache_get_value_name_int(i, "SlotsTunning_2", DataCars[i][SlotsTunning][2]);
		cache_get_value_name_int(i, "SlotsTunning_3", DataCars[i][SlotsTunning][3]);
		cache_get_value_name_int(i, "SlotsTunning_4", DataCars[i][SlotsTunning][4]);
		cache_get_value_name_int(i, "SlotsTunning_5", DataCars[i][SlotsTunning][5]);
		cache_get_value_name_int(i, "SlotsTunning_6", DataCars[i][SlotsTunning][6]);
		cache_get_value_name_int(i, "SlotsTunning_7", DataCars[i][SlotsTunning][7]);
		cache_get_value_name_int(i, "SlotsTunning_8", DataCars[i][SlotsTunning][8]);
		cache_get_value_name_int(i, "SlotsTunning_9", DataCars[i][SlotsTunning][9]);
		cache_get_value_name_int(i, "SlotsTunning_10", DataCars[i][SlotsTunning][10]);
		cache_get_value_name_int(i, "SlotsTunning_11", DataCars[i][SlotsTunning][11]);
		cache_get_value_name_int(i, "SlotsTunning_12", DataCars[i][SlotsTunning][12]);
		cache_get_value_name_int(i, "SlotsTunning_13", DataCars[i][SlotsTunning][13]);
		cache_get_value_name_int(i, "Vinillo", DataCars[i][Vinillo]);
		cache_get_value_name_int(i, "Interior", DataCars[i][Interior]);
		cache_get_value_name_int(i, "InteriorLast", DataCars[i][InteriorLast]);
		cache_get_value_name_int(i, "World", DataCars[i][World]);
		cache_get_value_name_int(i, "WorldLast", DataCars[i][WorldLast]);
		cache_get_value_name_int(i, "StationID", DataCars[i][StationID]);
		cache_get_value_name_int(i, "GuanteraLock", DataCars[i][GuanteraLock]);
		cache_get_value_name_int(i, "GuanteraObjects_0", DataCars[i][GuanteraObjects][0]);
		cache_get_value_name_int(i, "GuanteraObjects_1", DataCars[i][GuanteraObjects][1]);
		cache_get_value_name_int(i, "GuanteraObjects_2", DataCars[i][GuanteraObjects][2]);
		cache_get_value_name_int(i, "GuanteraObjects_3", DataCars[i][GuanteraObjects][3]);
		cache_get_value_name_int(i, "GuanteraObjects_4", DataCars[i][GuanteraObjects][4]);
		cache_get_value_name_int(i, "GuanteraObjects_5", DataCars[i][GuanteraObjects][5]);
		cache_get_value_name_int(i, "GuanteraObjects_6", DataCars[i][GuanteraObjects][6]);
		cache_get_value_name_int(i, "GuanteraObjects_7", DataCars[i][GuanteraObjects][7]);
		cache_get_value_name_int(i, "Freno", DataCars[i][Freno]);
		cache_get_value_name_int(i, "OwnerId", DataCars[i][OwnerId]);
		cache_get_value_name_int(i, "FactionId", DataCars[i][FactionId]);
		cache_get_value_name_int(i, "JobId", DataCars[i][JobId]);

		DataCars[i][VehicleDeath] = false;
		DataCars[i][Puente] = true;
		DataCars[i][StateEncendido] = false;
        DataCars[i][StationID] = -1;
        
        CreateVehicleEx(DataCars[i][Modelo], DataCars[i][PosX], DataCars[i][PosY], DataCars[i][PosZ], DataCars[i][PosZZ], DataCars[i][Color1], DataCars[i][Color2], i);
		UpdateVehicleDamageStatus(DataCars[i][VehicleID], DataCars[i][PanelS], DataCars[i][DoorS], DataCars[i][LightS], DataCars[i][TiresS]);
		
		if (DataCars[i][Vinillo] != -1 && IsValidVehiclePaintJob(DataCars[i][Modelo]))
		{
			ChangeVehiclePaintjob(DataCars[i][VehicleID], DataCars[i][Vinillo]);
		}
		else
		{
			DataCars[i][Vinillo] = -1;
		}
		for (new t = 0; t < 14; t++ )
		{
			if ( DataCars[i][SlotsTunning][t] )
			{
				AddVehicleComponentEx(i, DataCars[i][SlotsTunning][t]);
			}
		}
		if ( DataCars[i][LastDamage] >= 250.0 )
		{
			SetVehicleHealthEx(i, DataCars[i][LastDamage]);
			GetVehicleHealth(DataCars[i][VehicleID], DataCars[i][LastDamage]);
		}
		SetVehicleVirtualWorld(DataCars[i][VehicleID], DataCars[i][WorldLast]);
		LinkVehicleToInterior(DataCars[i][VehicleID], DataCars[i][InteriorLast]);
		MAX_CAR++;
	}

    MAX_CAR_DUENO = rows - 1;
    // MAX_CAR = rows - 1;
	cache_delete(result);

	printf("[DB] Cargados %i vehículos desde la base de datos.", rows + 1);
}

SaveDataVehicle(vehicleIndex)
{
	if (!DataCars[vehicleIndex][ID] || !DataCars[vehicleIndex][Modelo]) return 1;

	new query[2000];
	mysql_format(dataBase, query, sizeof(query), "UPDATE `vehicles` SET `PosX`='%f',`PosY`='%f',`PosZ`='%f',`PosZZ`='%f',`Modelo`='%i',`Color1`='%i',`Color2`='%i',\
			`Dueno`='%e',`Seguro`='%i',`Time`='%i',`Matricula`='%i',`LockPolice`='%i',`ReasonLock`='%e',`Maletero_0_0`='%i',\
			`Maletero_0_1`='%i',`Maletero_1_0`='%i',`Maletero_1_1`='%i',`Maletero_2_0`='%i',`Maletero_2_1`='%i',\
			`Maletero_3_0`='%i',`Maletero_3_1`='%i',`Maletero_4_0`='%i',`Maletero_4_1`='%i',`Maletero_5_0`='%i',\
			`Maletero_5_1`='%i',`Maletero_6_0`='%i',`Maletero_6_1`='%i',`Maletero_7`='%i',`Maletero_8`='%i',\
			`Maletero_9`='%i',`Maletero_10`='%i',`Maletero_11`='%i',`MaleteroState`='%i',`Oil`='%i',`Gas`='%i',\
			`LastX`='%f',`LastY`='%f',`LastZ`='%f',`LastZZ`='%f',`LastDamage`='%f',`PanelS`='%i',\
			`DoorS`='%i',`LightS`='%i',`TiresS`='%i',`SlotsTunning_0`='%i',`SlotsTunning_1`='%i',`SlotsTunning_2`='%i',\
			`SlotsTunning_3`='%i',`SlotsTunning_4`='%i',`SlotsTunning_5`='%i',`SlotsTunning_6`='%i',`SlotsTunning_7`='%i',\
			`SlotsTunning_8`='%i',`SlotsTunning_9`='%i',`SlotsTunning_10`='%i',`SlotsTunning_11`='%i',`SlotsTunning_12`='%i',\
			`SlotsTunning_13`='%i',`Vinillo`='%i',`Interior`='%i',`InteriorLast`='%i',`World`='%i',`WorldLast`='%i',`StationID`='%i',\
			`GuanteraLock`='%i',`GuanteraObjects_0`='%i',`GuanteraObjects_1`='%i',`GuanteraObjects_2`='%i',`GuanteraObjects_3`='%i',\
			`GuanteraObjects_4`='%i',`GuanteraObjects_5`='%i',`GuanteraObjects_6`='%i',`GuanteraObjects_7`='%i',\
			`Freno`='%i',OwnerId=%i,FactionId=%i,JobId=%i WHERE `ID`='%i'",
			DataCars[vehicleIndex][PosX],
			DataCars[vehicleIndex][PosY],
			DataCars[vehicleIndex][PosZ],
			DataCars[vehicleIndex][PosZZ],
			DataCars[vehicleIndex][Modelo],
			DataCars[vehicleIndex][Color1],
			DataCars[vehicleIndex][Color2],
			DataCars[vehicleIndex][Dueno],
			DataCars[vehicleIndex][Lock],
			DataCars[vehicleIndex][Time],
			DataCars[vehicleIndex][Matricula],
			DataCars[vehicleIndex][LockPolice],
			DataCars[vehicleIndex][ReasonLock],
			coches_Todos_Maleteros[vehicleIndex][0][0],
			coches_Todos_Maleteros[vehicleIndex][0][1],
			coches_Todos_Maleteros[vehicleIndex][1][0],
			coches_Todos_Maleteros[vehicleIndex][1][1],
			coches_Todos_Maleteros[vehicleIndex][2][0],
			coches_Todos_Maleteros[vehicleIndex][2][1],
			coches_Todos_Maleteros[vehicleIndex][3][0],
			coches_Todos_Maleteros[vehicleIndex][3][1],
			coches_Todos_Maleteros[vehicleIndex][4][0],
			coches_Todos_Maleteros[vehicleIndex][4][1],
			coches_Todos_Maleteros[vehicleIndex][5][0],
			coches_Todos_Maleteros[vehicleIndex][5][1],
			coches_Todos_Maleteros[vehicleIndex][6][0],
			coches_Todos_Maleteros[vehicleIndex][6][1],
			coches_Todos_Maleteros[vehicleIndex][7][0],
			coches_Todos_Maleteros[vehicleIndex][8][0],
			coches_Todos_Maleteros[vehicleIndex][9][0],
			coches_Todos_Maleteros[vehicleIndex][10][0],
			coches_Todos_Maleteros[vehicleIndex][11][0],
			DataCars[vehicleIndex][MaleteroState],
			DataCars[vehicleIndex][Oil],
			DataCars[vehicleIndex][Gas],
			DataCars[vehicleIndex][LastX],
			DataCars[vehicleIndex][LastY],
			DataCars[vehicleIndex][LastZ],
			DataCars[vehicleIndex][LastZZ],
			DataCars[vehicleIndex][LastDamage],
			DataCars[vehicleIndex][PanelS],
			DataCars[vehicleIndex][DoorS],
			DataCars[vehicleIndex][LightS],
			DataCars[vehicleIndex][TiresS],
			DataCars[vehicleIndex][SlotsTunning][0],
			DataCars[vehicleIndex][SlotsTunning][1],
			DataCars[vehicleIndex][SlotsTunning][2],
			DataCars[vehicleIndex][SlotsTunning][3],
			DataCars[vehicleIndex][SlotsTunning][4],
			DataCars[vehicleIndex][SlotsTunning][5],
			DataCars[vehicleIndex][SlotsTunning][6],
			DataCars[vehicleIndex][SlotsTunning][7],
			DataCars[vehicleIndex][SlotsTunning][8],
			DataCars[vehicleIndex][SlotsTunning][9],
			DataCars[vehicleIndex][SlotsTunning][10],
			DataCars[vehicleIndex][SlotsTunning][11],
			DataCars[vehicleIndex][SlotsTunning][12],
			DataCars[vehicleIndex][SlotsTunning][13],
			DataCars[vehicleIndex][Vinillo],
			DataCars[vehicleIndex][Interior],
			DataCars[vehicleIndex][InteriorLast],
			DataCars[vehicleIndex][World],
			DataCars[vehicleIndex][WorldLast],
			DataCars[vehicleIndex][StationID],
			DataCars[vehicleIndex][GuanteraLock],
			DataCars[vehicleIndex][GuanteraObjects][0],
			DataCars[vehicleIndex][GuanteraObjects][1],
			DataCars[vehicleIndex][GuanteraObjects][2],
			DataCars[vehicleIndex][GuanteraObjects][3],
			DataCars[vehicleIndex][GuanteraObjects][4],
			DataCars[vehicleIndex][GuanteraObjects][5],
			DataCars[vehicleIndex][GuanteraObjects][6],
			DataCars[vehicleIndex][GuanteraObjects][7],
			DataCars[vehicleIndex][Freno], DataCars[vehicleIndex][OwnerId], DataCars[vehicleIndex][FactionId], DataCars[vehicleIndex][JobId],
			DataCars[vehicleIndex][ID]);
	mysql_query(dataBase, query, false);
	return 0;
}

OnPlayerCommandVehicles(playerid, const cmdtext[])
{
    //      /Crear Vehiculo [Modelo] [color1] [color2]
    if( !strfind(cmdtext, "/Crear Vehiculo", true) )
    {
        MsgAdminUseCommands(9, playerid, cmdtext);
        if(PlayersData[playerid][Admin] < ADMIN_LEVEL_CREATE_VEHICLE) return SendAccessError(playerid, "Crear Vehiculo");

        new modelid, color1, color2;
        if(strlen(cmdtext) <= 16 || sscanf(cmdtext[16], "iii", modelid, color1, color2)) return SendInfoMessage(playerid, 0, "1615", "Ha introducido mal el sintaxis del comando /Crear Vehiculo. Ejemplo correcto: /Crear Vehiculo 411 1 1");
        if(!IsValidVehicleModelId(modelid)) return SendInfoMessage(playerid, 0, "", "Modelo de vehículo inválido.");

        if(color1 < 0)
        {
            color1 = random(157);
        }
        if(color2 < 0)
        {
            color2 = random(157);
        }

        new query[128];
        mysql_format(dataBase, query, sizeof(query), "INSERT INTO vehicles (Modelo, Color1, Color2) VALUES (%i, %i, %i)", modelid, color1, color2);
        mysql_tquery(dataBase, query, "OnVehicleCreatedDB", "iiii", playerid, modelid, color1, color2);
        MAX_CAR_DUENO++;
        return 1;
    }
    //      /IrC [ID]					- Ir a un Coche
    else if( !strfind(cmdtext, "/IrC ", true) )
    {
        MsgAdminUseCommands(9, playerid, cmdtext);
        if(PlayersData[playerid][Admin] < 7) return SendAccessError(playerid, "/IrC");

        new vehicleid;
        if(sscanf(cmdtext[5], "i", vehicleid)) return SendSyntaxError(playerid, "IrC", "IrC [ID Vehiculo]");

        new vehicleIndex = GetVehicleIndexByVehicleID(vehicleid);
        if(vehicleIndex == -1) return SendInfoMessage(playerid, 0, "553", "El ID el vehiculo introducído no existe.");


        new Float:VehiclePoss[3];
        GetVehiclePos(vehicleid, VehiclePoss[0], VehiclePoss[1], VehiclePoss[2]);
        SetPlayerPos(playerid, VehiclePoss[0], VehiclePoss[1], VehiclePoss[2] + 2);

        SetPlayerInteriorEx(playerid, DataCars[vehicleIndex][InteriorLast]);
        SetPlayerVirtualWorldEx(playerid, DataCars[vehicleIndex][WorldLast]);

        if(DataCars[vehicleIndex][WorldLast] > 999){
            new houseId = GetHouseidIdByWorld(DataCars[vehicleIndex][WorldLast]);
            if(houseId){
                PlayersData[playerid][IsPlayerInHouse] = houseId;
                OnPlayerEnterInHouse(playerid);
                for (new i; i < MAX_GARAGE_FOR_HOUSE; i++ )
                {
                    if( Garages[houseId][i][PickupidIn] && Garages[houseId][i][WorldG] == DataCars[vehicleIndex][WorldLast] )
                    {
                        PlayersData[playerid][IsPlayerInGarage] = i;
                        break;
                    }
                }
            }
        }
        return 1;
    }
    //			/TraerC [ID]					- Traer un coche
    else if( !strfind(cmdtext, "/TraerC ", true) )
    {
        MsgAdminUseCommands(9, playerid, cmdtext);
        if(PlayersData[playerid][Admin] < 7) return SendAccessError(playerid, "/TraerC");

        new vehicleid;
        if(sscanf(cmdtext[8], "i", vehicleid)) return SendSyntaxError(playerid, "TraerC", "TraerC [ID]");

        new vehicleIndex = GetVehicleIndexByVehicleID(vehicleid);
        if(vehicleIndex == -1) return SendInfoMessage(playerid, 0, "1447", "El vehiculo que desea traer no existe.");

        RemoveVehicleHidden(vehicleIndex);
        new Float:MyPoss[3];
        GetPlayerPos(playerid, MyPoss[0], MyPoss[1], MyPoss[2]);
        SetVehiclePos(DataCars[vehicleIndex][VehicleID],  MyPoss[0] + 3, MyPoss[1], MyPoss[2]);

        LinkVehicleToInteriorEx(vehicleIndex, GetPlayerInteriorEx(playerid));
        SetVehicleVirtualWorldEx(vehicleIndex, GetPlayerVirtualWorld(playerid));
        GetVehiclePos(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][LastX], DataCars[vehicleIndex][LastY], DataCars[vehicleIndex][LastZ]);
        GetVehicleZAngle(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][LastZZ]);
        
        for (new j = 0, k = GetPlayerPoolSize(); j <= k; j++)
        {
            if(IsPlayerConnected(j) && IsPlayerInVehicle(j, DataCars[vehicleIndex][VehicleID]))
            {
                SetPlayerVirtualWorldEx(j, GetPlayerVirtualWorld(playerid));
                SetPlayerInteriorEx(j, GetPlayerInteriorEx(playerid));
            }
        }
        return 1;
    }
    // COMANDO: /Papeles [ID]
    else if( !strfind(cmdtext, "/Papeles ", true)  )
    {
        new MyNearCar = IsPlayerInNearVehicle(playerid);
        new vehicleIndex = GetVehicleIndexByVehicleID(MyNearCar);
        if(vehicleIndex != -1)
        {
            if(DataCars[vehicleIndex][OwnerId] != PlayersData[playerid][DB_ID])
                return SendInfoMessage(playerid, 0, "413", "Este no es su vehiculo");

            new toplayerid;
            if(sscanf(cmdtext, "u", toplayerid))
            {
                Acciones(playerid, 8, "mira los papeles de su vehiculo");
                ShowPapelesToPlayer(playerid, playerid);
            }
            else 
            {
                if(toplayerid == playerid)
                {
                    Acciones(playerid, 8, "mira los papeles de su vehiculo");
                    ShowPapelesToPlayer(playerid, playerid);
                }
                else if( IsPlayerNearEx(playerid, toplayerid,
                        "410",
                        "411",
                        "412",
                        "El jugador que desea mostrarle los papeles del vehiculo no se encuentra conectado",
                        "El jugador que desea mostrarle los papeles del vehiculo no se encuentra logueado",
                        "El jugador que desea mostrarle los papeles del vehiculo no se encuentra cerca de ti") )
                {
                    new MsgPapelesMe[MAX_TEXT_CHAT];
                    format(MsgPapelesMe, sizeof(MsgPapelesMe), "le muestra los papeles de su vehiculo a %s", PlayersDataOnline[toplayerid][NameOnlineFix]);
                    Acciones(playerid, 8, MsgPapelesMe);
                    ShowPapelesToPlayer(playerid, toplayerid);
                }			
            }
        }
        return 1;	
    }
    // COMANDO: /Aparcar
    else if( !strcmp("/Aparcar", cmdtext, true) )
    {
        if(!IsPlayerInAnyVehicle(playerid))
            return SendInfoMessage(playerid, 0, "332", "Suba a su vehiculo para poder aparcarlo");

        new vehicleIndex = GetVehicleIndexByVehicleID(GetPlayerVehicleID(playerid));
        if(!IsVehicleMyVehicle(playerid, vehicleIndex))
            return SendInfoMessage(playerid, 0, "331", "Este no es su vehiculo");

        AparcarVehicle(playerid, vehicleIndex);
        return 1;
    }
    // COMANDO: /Vender Mi Coche
    else if( !strcmp("/Vender Mi Coche", cmdtext, true) )
    {
        if(!IsPlayerInAnyVehicle(playerid))
            return SendInfoMessage(playerid, 0, "218", "Suba a su vehiculo para poder venderlo");

        new vehicleIndex = GetVehicleIndexByVehicleID(GetPlayerVehicleID(playerid));
        if(!IsVehicleMyVehicle(playerid, vehicleIndex))
            return SendInfoMessage(playerid, 0, "221", "Este no es su vehiculo");

        ShowPlayerDialogEx(playerid, 6, DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Venta de su vehiculo al estado", "{"COLOR_TEXTO_DIALOGS"}¿Seguro que desea vender su vehiculo?\n{"COLOR_ROJO"}IMPORTANTE: No obtendrá nada a cambio!", "Si", "No");
        return 1;
    }
    // COMANDO: /Dar Llaves [ID]
    else if( !strfind(cmdtext, "/Dar Llaves ", true) )
    {
        new toplayerid;
        if(sscanf(cmdtext, "u", toplayerid))
            return SendSyntaxError(playerid, "/Dar Llaves", "/Dar Llaves [ID_Jugador]");

        new MyNearCar = IsPlayerInNearVehicle(playerid);
        new vehicleIndex = GetVehicleIndexByVehicleID(MyNearCar);
        if(vehicleIndex == -1) return 0;

        if(!IsVehicleMyVehicle(playerid, vehicleIndex))
            return SendInfoMessage(playerid, 0, "338", "Este no es su vehiculo");

        if(IsPlayerNearEx(playerid, toplayerid,
                "340",
                "341",
                "342",
                "El jugador que le deseas dar las llaves de su vehiculo no se encuentra conectado",
                "El jugador que le deseas dar las llaves de su vehiculo no se ha logueado",
                "El jugador que le deseas dar las llaves de su vehiculo no se encuentra cerca de ti") )
        {
            if( PlayersData[toplayerid][Car] == -1 )
            {
                PlayersDataOnline[playerid][DarLlaves] = toplayerid;
                new MsgDialogDarLlaves[MAX_TEXT_CHAT];
                format( MsgDialogDarLlaves , sizeof(MsgDialogDarLlaves), "{"COLOR_TEXTO_DIALOGS"}¿Seguro que quiere darle las llaves de su vehiculo a %s?\n{"COLOR_ROJO"}IMPORTANTE: Perderá totalemnte el control de su vehiculo!", PlayersDataOnline[toplayerid][NameOnlineFix]);
                ShowPlayerDialogEx(playerid, 7, DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Pasar llaves de jugador a jugador", MsgDialogDarLlaves, "Si", "No");
            }
            else
            {
                SendInfoMessage(playerid, 0, "339", "El jugador que le desea dar las llaves de su vehiculo, ya tiene uno");
            }
        }
        return 1;
    }
    else if( !strcmp("/Freno", cmdtext, true) )
    {
        if(IsPlayerInAnyVehicle(playerid) && PlayersDataOnline[playerid][InCarId] && coches_Todos_Type[GetVehicleModel(PlayersDataOnline[playerid][InCarId]) - 400] == COCHE)
        {
            new vehicleid = PlayersDataOnline[playerid][InCarId];
            new vehicleIndex = GetVehicleIndexByVehicleID(vehicleid);
            new Float:Speed[3];
            GetVehicleVelocity(vehicleid, Speed[0], Speed[1], Speed[2]);

            if(!DataCars[vehicleIndex][Freno] && Speed[0] != 0.0 && Speed[1] != 0.0 && Speed[2]!= 0.0 )
            {
                SendInfoMessage(playerid, 0, "1620", "El vehiculo no debe estar en movimiento para aplicar el freno.");
                return 1;
            }

            if(DataCars[vehicleIndex][Freno])
                SendInfoMessage(playerid, 2, "0", "Sacaste el freno de mano al vehiculo.");
            else
                SendInfoMessage(playerid, 2, "0", "Pusiste freno de mano al vehiculo.");

            PlayerPlaySound(playerid, 1131, 0.0, 0.0, 0.0);
            GetVehiclePos(vehicleid, DataCars[vehicleIndex][LastX], DataCars[vehicleIndex][LastY], DataCars[vehicleIndex][LastZ]);
            GetVehicleZAngle(vehicleid, DataCars[vehicleIndex][LastZZ]);
            DataCars[vehicleIndex][Freno] = !DataCars[vehicleIndex][Freno];
            return 1;
        }
        else SendInfoMessage(playerid, 0, "1610", "Debes estar en un coche para usar /Freno.");
        return 1;
    }
    else if( !strfind(cmdtext, "/Editar Vehiculo", true) )
    {
        if(PlayersData[playerid][Admin] < 8) return SendAccessError(playerid, "Editar Vehiculo");
        if( !strfind(cmdtext, "/Editar Vehiculo Faccion ", true) )
        {
            new factionid;
            if(!IsPlayerInAnyVehicle(playerid)) 
                return SendInfoMessage(playerid, 0, "", "Tienes que estar dentro de un vehículo.");
            if(sscanf(cmdtext[25], "i", factionid)) return SendSyntaxError(playerid, "Editar Vehiculo Faccion", "Editar Vehiculo Faccion 1");
            if(factionid < 0 || factionid > MAX_FACCION)
                return SendInfoMessage(playerid, 0, "", "ID de facción inválido");

            new vehicleIndex = GetVehicleIndexByVehicleID(GetPlayerVehicleID(playerid));

            if(factionid > 0) 
            {
                RemoveDuenoOfVehicle(vehicleIndex, 4);
            }
            DataCars[vehicleIndex][FactionId] = factionid;
            GetVehiclePos(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][PosX], DataCars[vehicleIndex][PosY], DataCars[vehicleIndex][PosZ]);
            GetVehicleZAngle(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][PosZZ]);
            DataCars[vehicleIndex][Interior] = GetVehicleInterior(DataCars[vehicleIndex][VehicleID]);
            DataCars[vehicleIndex][World]    = GetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID]);
            SaveDataVehicle(vehicleIndex);

            new string[MAX_TEXT_CHAT], vehName[32];
            GetVehicleName(vehicleIndex, vehName, sizeof(vehName));
            format(string, sizeof(string), "El vehículo \"%s\" ID: %i [UID: %i] ahora es de la facción \"%s\"", vehName, DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][ID], FaccionData[factionid][NameFaccion]);
            SendInfoMessage(playerid, 3, "", string);
            return 1;
        }
        else if( !strfind(cmdtext, "/Editar Vehiculo Trabajo ", true) )
        {
            new jobid;
            if(!IsPlayerInAnyVehicle(playerid)) 
                return SendInfoMessage(playerid, 0, "", "Tienes que estar dentro de un vehículo.");
            if(sscanf(cmdtext[25], "i", jobid)) return SendSyntaxError(playerid, "Editar Vehiculo Trabajo", "Editar Vehiculo Trabajo 1");
            if(jobid < 0 || jobid >= MAX_JOB)
                return SendInfoMessage(playerid, 0, "", "ID del trabajo inválido");

            new vehicleIndex = GetVehicleIndexByVehicleID(GetPlayerVehicleID(playerid));

            if(jobid > 0) 
            {
                RemoveDuenoOfVehicle(vehicleIndex, 4);
            }
            DataCars[vehicleIndex][JobId] = jobid;

            GetVehiclePos(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][PosX], DataCars[vehicleIndex][PosY], DataCars[vehicleIndex][PosZ]);
            GetVehicleZAngle(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][PosZZ]);
            DataCars[vehicleIndex][Interior] = GetVehicleInterior(DataCars[vehicleIndex][VehicleID]);
            DataCars[vehicleIndex][World]    = GetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID]);
            SaveDataVehicle(vehicleIndex);

            new string[MAX_TEXT_CHAT], vehName[32];
            GetVehicleName(vehicleIndex, vehName, sizeof(vehName));
            format(string, sizeof(string), "El vehículo \"%s\" ID: %i [UID: %i] ahora esta asignado al trabajo \"%s\"", vehName, DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][ID], Jobs[jobid][NameJob]);
            SendInfoMessage(playerid, 3, "", string);
        }
        else
        {
            Error(playerid, "Quizas quiso decir: /Editar Vehiculo {Faccion, Trabajo}");
        }
        return 1;
    }
    return false;
}

LoadPriceAndNameVehicles()
{
 // Todo + 400
	new NEXT = 0; coches_Todos_Precios    [0]     = 1000;      coches_Todos_Nombres    [0] 	= "Landstalker"; 	coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:400
	NEXT++; coches_Todos_Precios    [1]     = 1000;      coches_Todos_Nombres    [1] 	= "Bravura"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 98; 		// Nombre: NINGUNO       ID:401
	NEXT++; coches_Todos_Precios    [2]     = 3000;      coches_Todos_Nombres    [2] 	= "Buffalo";     		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 124; 	// Nombre: NINGUNO       ID:402
	NEXT++; coches_Todos_Precios    [3]     = 1000;      coches_Todos_Nombres    [3] 	= "Linerunner"; 		coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 75; 	// Nombre: NINGUNO       ID:403
	NEXT++; coches_Todos_Precios    [4]     = 1000;      coches_Todos_Nombres    [4] 	= "Perenniel"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:404
	NEXT++; coches_Todos_Precios    [5]     = 1500;      coches_Todos_Nombres    [5] 	= "Sentinel";    		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 109;	// Nombre: NINGUNO       ID:405
	NEXT++; coches_Todos_Precios    [6]     = 1000;      coches_Todos_Nombres    [6] 	= "Dumper"; 			coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:406
	NEXT++; coches_Todos_Precios    [7]     = 1000;      coches_Todos_Nombres    [7] 	= "Firetruck"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:407
	NEXT++; coches_Todos_Precios    [8]     = 1000;      coches_Todos_Nombres    [8] 	= "Trashmaster"; 		coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0;	 	// Nombre: NINGUNO       ID:408
	NEXT++; coches_Todos_Precios    [9]     = 1000;      coches_Todos_Nombres    [9]	= "Stretch"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:409
	NEXT++; coches_Todos_Precios    [10]     = 1000;     coches_Todos_Nombres    [10] 	= "Manana";       		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 86; 	// Nombre: NINGUNO       ID:410
	NEXT++; coches_Todos_Precios    [11]     = 3000;     coches_Todos_Nombres    [11] 	= "Infernus";   		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 148; 	// Nombre: NINGUNO       ID:411
	NEXT++; coches_Todos_Precios    [12]     = 1000;     coches_Todos_Nombres    [12] 	= "Voodoo"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 112; 	// Nombre: NINGUNO       ID:412
	NEXT++; coches_Todos_Precios    [13]     = 1000;     coches_Todos_Nombres    [13] 	= "Pony"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 73; 	// Nombre: NINGUNO       ID:413
	NEXT++; coches_Todos_Precios    [14]     = 1000;     coches_Todos_Nombres    [14] 	= "Mule";				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 70; 	// Nombre: NINGUNO       ID:414
	NEXT++; coches_Todos_Precios    [15]     = 3000;     coches_Todos_Nombres    [15] 	= "Cheetah";			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 128; 	// Nombre: NINGUNO       ID:415
	NEXT++; coches_Todos_Precios    [16]     = 1000;     coches_Todos_Nombres    [16] 	= "Ambulance"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 103; 	// Nombre: NINGUNO       ID:416
	NEXT++; coches_Todos_Precios    [17]     = 1000;     coches_Todos_Nombres    [17]	= "Leviathan";			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0;		// Nombre: NINGUNO       ID:417
	NEXT++; coches_Todos_Precios    [18]     = 1000;     coches_Todos_Nombres    [18] 	= "Moonbeam"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 77; 	// Nombre: NINGUNO       ID:418
	NEXT++; coches_Todos_Precios    [19]     = 1000;     coches_Todos_Nombres    [19] 	= "Esperanto"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 99; 	// Nombre: NINGUNO       ID:419
	NEXT++; coches_Todos_Precios    [20]     = 1000;     coches_Todos_Nombres    [20] 	= "Taxi"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 97; 	// Nombre: NINGUNO       ID:420
	NEXT++; coches_Todos_Precios    [21]     = 1500;     coches_Todos_Nombres    [21] 	= "Washington"; 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 102; 	// Nombre: NINGUNO       ID:421
	NEXT++; coches_Todos_Precios    [22]     = 1500;     coches_Todos_Nombres    [22] 	= "Bobcat";      		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 97; 	// Nombre: NINGUNO       ID:422
	NEXT++; coches_Todos_Precios    [23]     = 1000;     coches_Todos_Nombres    [23] 	= "Mr Whoopee"; 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:423
	NEXT++; coches_Todos_Precios    [24]     = 1500;     coches_Todos_Nombres    [24] 	= "Bfinject";  			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 90; 	// Nombre: NINGUNO       ID:424
	NEXT++; coches_Todos_Precios    [25]     = 1000;     coches_Todos_Nombres    [25]	= "Hunter"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:425
	NEXT++; coches_Todos_Precios    [26]     = 1500;     coches_Todos_Nombres    [26] 	= "Premier"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 116; 	// Nombre: NINGUNO       ID:426
	NEXT++; coches_Todos_Precios    [27]     = 1000;     coches_Todos_Nombres    [27] 	= "Enforcer"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 110; 	// Nombre: NINGUNO       ID:427
	NEXT++; coches_Todos_Precios    [28]     = 1000;     coches_Todos_Nombres    [28] 	= "Securicar"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:428
	NEXT++; coches_Todos_Precios    [29]     = 3000;     coches_Todos_Nombres    [29] 	= "Banshee";    		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 134; 	// Nombre: NINGUNO       ID:429
	NEXT++; coches_Todos_Precios    [30]     = 1000;     coches_Todos_Nombres    [30] 	= "Predator"; 			coches_Todos_Type	[NEXT] = BOTE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:430
	NEXT++; coches_Todos_Precios    [31]     = 1000;     coches_Todos_Nombres    [31] 	= "Bus"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 87; 	// Nombre: NINGUNO       ID:431
	NEXT++; coches_Todos_Precios    [32]     = 1000;     coches_Todos_Nombres    [32] 	= "Rhino"; 				coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:432
	NEXT++; coches_Todos_Precios    [33]     = 1000;     coches_Todos_Nombres    [33] 	= "Barracks"; 			coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:433
	NEXT++; coches_Todos_Precios    [34]     = 2000;     coches_Todos_Nombres    [34] 	= "Hotknife"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 111; 	// Nombre: NINGUNO       ID:434
	NEXT++; coches_Todos_Precios    [35]     = 1000;     coches_Todos_Nombres    [35] 	= "Article Trailer"; 	coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:435
	NEXT++; coches_Todos_Precios    [36]     = 1500;     coches_Todos_Nombres    [36] 	= "Previon";   			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 96; 	// Nombre: NINGUNO       ID:436
	NEXT++; coches_Todos_Precios    [37]     = 1000;     coches_Todos_Nombres    [37]	= "Coach"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:437
	NEXT++; coches_Todos_Precios    [38]     = 1000;     coches_Todos_Nombres    [38] 	= "Cabbie"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:438
	NEXT++; coches_Todos_Precios    [39]     = 1500;     coches_Todos_Nombres    [39]	= "Stallion"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 112; 	// Nombre: NINGUNO       ID:439
	NEXT++; coches_Todos_Precios    [40]     = 1000;     coches_Todos_Nombres    [40] 	= "Rumpo"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 91; 	// Nombre: NINGUNO       ID:440
	NEXT++; coches_Todos_Precios    [41]     = 1000;     coches_Todos_Nombres    [41] 	= "RC bandit";			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:441
	NEXT++; coches_Todos_Precios    [42]     = 1000;     coches_Todos_Nombres    [42] 	= "Romero"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 93; 	// Nombre: NINGUNO       ID:442
	NEXT++; coches_Todos_Precios    [43]     = 1000;     coches_Todos_Nombres    [43] 	= "Packer"; 			coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 84; 	// Nombre: NINGUNO       ID:443
	NEXT++; coches_Todos_Precios    [44]     = 1000;     coches_Todos_Nombres    [44] 	= "Monster"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 74; 	// Nombre: NINGUNO       ID:444
	NEXT++; coches_Todos_Precios    [45]     = 1500;     coches_Todos_Nombres    [45] 	= "Admiral";	 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 109; 	// Nombre: NINGUNO       ID:445
	NEXT++; coches_Todos_Precios    [46]     = 1000;     coches_Todos_Nombres    [46] 	= "Squallo";			coches_Todos_Type	[NEXT] = BOTE; 			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:446
	NEXT++; coches_Todos_Precios    [47]     = 1000;     coches_Todos_Nombres    [47] 	= "Seasparrow"; 		coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:447
	NEXT++; coches_Todos_Precios    [48]     = 1000;     coches_Todos_Nombres    [48] 	= "Pizzaboy";   		coches_Todos_Type	[NEXT] = MOTO; 			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:448
	NEXT++; coches_Todos_Precios    [49]     = 1000;     coches_Todos_Nombres    [49] 	= "Tram";				coches_Todos_Type	[NEXT] = TREN; 			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:449
	NEXT++; coches_Todos_Precios    [50]     = 1000;     coches_Todos_Nombres    [50] 	= "Article Trailer 2";	coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:450
	NEXT++; coches_Todos_Precios    [51]     = 3000;     coches_Todos_Nombres    [51] 	= "Turismo";  			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 129; 	// Nombre: NINGUNO       ID:451
	NEXT++; coches_Todos_Precios    [52]     = 1000;     coches_Todos_Nombres    [52] 	= "Speeder";			coches_Todos_Type	[NEXT] = BOTE; 			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:452
	NEXT++; coches_Todos_Precios    [53]     = 1000;     coches_Todos_Nombres    [53] 	= "Reefer"; 			coches_Todos_Type	[NEXT] = BOTE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:453
	NEXT++; coches_Todos_Precios    [54]     = 1000;     coches_Todos_Nombres    [54] 	= "Tropic"; 			coches_Todos_Type	[NEXT] = BOTE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:454
	NEXT++; coches_Todos_Precios    [55]     = 1000;     coches_Todos_Nombres    [55] 	= "Flatbed"; 			coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:455
	NEXT++; coches_Todos_Precios    [56]     = 1000;     coches_Todos_Nombres    [56] 	= "Yankee"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:456
	NEXT++; coches_Todos_Precios    [57]     = 1000;     coches_Todos_Nombres    [57] 	= "Caddy"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:457
	NEXT++; coches_Todos_Precios    [58]     = 2000;     coches_Todos_Nombres    [58] 	= "Solair";				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:458
	NEXT++; coches_Todos_Precios    [59]     = 1000;     coches_Todos_Nombres    [59] 	= "Berkley's RC Van";	coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0;	 	// Nombre: NINGUNO       ID:459
	NEXT++; coches_Todos_Precios    [60]     = 1000;     coches_Todos_Nombres    [60] 	= "Skimmer"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:460
	NEXT++; coches_Todos_Precios    [61]     = 2000;     coches_Todos_Nombres    [61] 	= "PCJ-600";     		coches_Todos_Type	[NEXT] = MOTO;			coches_Todos_Velocidad [NEXT] = 109; 	// Nombre: NINGUNO       ID:461
	NEXT++; coches_Todos_Precios    [62]     = 1000;     coches_Todos_Nombres    [62] 	= "Faggio";       		coches_Todos_Type	[NEXT] = MOTO;			coches_Todos_Velocidad [NEXT] = 50; 	// Nombre: NINGUNO       ID:462
	NEXT++; coches_Todos_Precios    [63]     = 2000;     coches_Todos_Nombres    [63] 	= "Freeway";    		coches_Todos_Type	[NEXT] = MOTO;			coches_Todos_Velocidad [NEXT] = 93; 	// Nombre: NINGUNO       ID:463
	NEXT++; coches_Todos_Precios    [64]     = 1000;     coches_Todos_Nombres    [64] 	= "RC Baron"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:464
	NEXT++; coches_Todos_Precios    [65]     = 1000;     coches_Todos_Nombres    [65] 	= "RC Raider"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:465
	NEXT++; coches_Todos_Precios    [66]     = 1000;     coches_Todos_Nombres    [66] 	= "Glendale";    		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 98; 	// Nombre: NINGUNO       ID:466
	NEXT++; coches_Todos_Precios    [67]     = 1000;     coches_Todos_Nombres    [67] 	= "Oceanic";     		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 94; 	// Nombre: NINGUNO       ID:467
	NEXT++; coches_Todos_Precios    [68]     = 2000;     coches_Todos_Nombres    [68] 	= "Sanchez";     		coches_Todos_Type	[NEXT] = MOTO;			coches_Todos_Velocidad [NEXT] = 93; 	// Nombre: NINGUNO       ID:468
	NEXT++; coches_Todos_Precios    [69]     = 1000;     coches_Todos_Nombres    [69] 	= "Sparrow"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:469
	NEXT++; coches_Todos_Precios    [70]     = 1000;     coches_Todos_Nombres    [70] 	= "Patriot"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:470
	NEXT++; coches_Todos_Precios    [71]     = 1000;     coches_Todos_Nombres    [71] 	= "Quad";       		coches_Todos_Type	[NEXT] = MOTO;			coches_Todos_Velocidad [NEXT] = 74; 	// Nombre: NINGUNO       ID:471
	NEXT++; coches_Todos_Precios    [72]     = 1000;     coches_Todos_Nombres    [72] 	= "Coastguard"; 		coches_Todos_Type	[NEXT] = BOTE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:472
	NEXT++; coches_Todos_Precios    [73]     = 1000;     coches_Todos_Nombres    [73] 	= "Dinghy"; 			coches_Todos_Type	[NEXT] = BOTE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:473
	NEXT++; coches_Todos_Precios    [74]     = 1500;     coches_Todos_Nombres    [74] 	= "Hermes"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 99; 	// Nombre: NINGUNO       ID:474
	NEXT++; coches_Todos_Precios    [75]     = 1500;     coches_Todos_Nombres    [75] 	= "Sabre"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 115; 	// Nombre: NINGUNO       ID:475
	NEXT++; coches_Todos_Precios    [76]     = 1000;     coches_Todos_Nombres    [76] 	= "Rustler"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:476
	NEXT++; coches_Todos_Precios    [77]     = 2500;     coches_Todos_Nombres    [77] 	= "ZR-350"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 124; 	// Nombre: NINGUNO       ID:477
	NEXT++; coches_Todos_Precios    [78]     = 1000;     coches_Todos_Nombres    [78] 	= "Walton"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 78; 	// Nombre: NINGUNO       ID:478
	NEXT++; coches_Todos_Precios    [79]     = 1000;     coches_Todos_Nombres    [79] 	= "Regina"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 93; 	// Nombre: NINGUNO       ID:479
	NEXT++; coches_Todos_Precios    [80]     = 2500;     coches_Todos_Nombres    [80] 	= "Comet";       		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 123; 	// Nombre: NINGUNO       ID:480
	NEXT++; coches_Todos_Precios    [81]     = 1000;     coches_Todos_Nombres    [81]	= "BMX"; 				coches_Todos_Type	[NEXT] = BICI;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:481
	NEXT++; coches_Todos_Precios    [82]     = 1000;     coches_Todos_Nombres    [82] 	= "Burrito"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 104; 	// Nombre: NINGUNO       ID:482
	NEXT++; coches_Todos_Precios    [83]     = 1000;     coches_Todos_Nombres    [83] 	= "Camper"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:483
	NEXT++; coches_Todos_Precios    [84]     = 1000;     coches_Todos_Nombres    [84] 	= "Marquis"; 			coches_Todos_Type	[NEXT] = BOTE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:484
	NEXT++; coches_Todos_Precios    [85]     = 1000;     coches_Todos_Nombres    [85] 	= "Baggage"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:485
	NEXT++; coches_Todos_Precios    [86]     = 1000;     coches_Todos_Nombres    [86] 	= "Dozer"; 				coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:486
	NEXT++; coches_Todos_Precios    [87]     = 1000;     coches_Todos_Nombres    [87] 	= "Maverick"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:487
	NEXT++; coches_Todos_Precios    [88]     = 1000;     coches_Todos_Nombres    [88] 	= "SAN News Maverick"; 	coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:488
	NEXT++; coches_Todos_Precios    [89]     = 1500;     coches_Todos_Nombres    [89] 	= "Rancher"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 93; 	// Nombre: NINGUNO       ID:489
	NEXT++; coches_Todos_Precios    [90]     = 1000;     coches_Todos_Nombres    [90] 	= "FBI Rancher"; 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:490
	NEXT++; coches_Todos_Precios    [91]     = 1500;     coches_Todos_Nombres    [91] 	= "Virgo"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 99; 	// Nombre: NINGUNO       ID:491
	NEXT++; coches_Todos_Precios    [92]     = 1500;     coches_Todos_Nombres    [92] 	= "Greenwoo";    		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 94; 	// Nombre: NINGUNO       ID:492
	NEXT++; coches_Todos_Precios    [93]     = 1000;     coches_Todos_Nombres    [93] 	= "Jetmax"; 			coches_Todos_Type	[NEXT] = BOTE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:493
	NEXT++; coches_Todos_Precios    [94]     = 1000;     coches_Todos_Nombres    [94] 	= "Hotring Racer"; 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:494
	NEXT++; coches_Todos_Precios    [95]     = 1000;     coches_Todos_Nombres    [95] 	= "Sandking"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 118; 	// Nombre: NINGUNO       ID:495
	NEXT++; coches_Todos_Precios    [96]     = 1500;     coches_Todos_Nombres    [96] 	= "Blistac";       		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 108; 	// Nombre: NINGUNO       ID:496
	NEXT++; coches_Todos_Precios    [97]     = 1000;     coches_Todos_Nombres    [97] 	= "Police Maverick"; 	coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:497
	NEXT++; coches_Todos_Precios    [98]     = 1000;     coches_Todos_Nombres    [98] 	= "Boxville"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:498
	NEXT++; coches_Todos_Precios    [99]     = 1000;     coches_Todos_Nombres    [99] 	= "Benson"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:499
	NEXT++; coches_Todos_Precios    [100]    = 1500;     coches_Todos_Nombres    [100] 	= "Mesa"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 94; 	// Nombre: NINGUNO       ID:500
	NEXT++; coches_Todos_Precios    [101]    = 1000;     coches_Todos_Nombres    [101] 	= "RC Goblin"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:501
	NEXT++; coches_Todos_Precios    [102]    = 1000;     coches_Todos_Nombres    [102] 	= "Hotring Racer"; 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:502
	NEXT++; coches_Todos_Precios    [103]    = 1000;     coches_Todos_Nombres    [103] 	= "Hotring Racer"; 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:503
	NEXT++; coches_Todos_Precios    [104]    = 1500;     coches_Todos_Nombres    [104] 	= "Bloodra";     		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 115; 	// Nombre: NINGUNO       ID:504
	NEXT++; coches_Todos_Precios    [105]    = 1500;     coches_Todos_Nombres    [105] 	= "Rancher"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 93; 	// Nombre: NINGUNO       ID:505
	NEXT++; coches_Todos_Precios    [106]    = 2500;     coches_Todos_Nombres    [106] 	= "Super GT";     		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 119; 	// Nombre: NINGUNO       ID:506
	NEXT++; coches_Todos_Precios    [107]    = 1000;     coches_Todos_Nombres    [107] 	= "Elegant";     		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 120; 	// Nombre: NINGUNO       ID:507
	NEXT++; coches_Todos_Precios    [108]    = 1000;     coches_Todos_Nombres    [108] 	= "Journey"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 72; 	// Nombre: NINGUNO       ID:508
	NEXT++; coches_Todos_Precios    [109]    = 1000;     coches_Todos_Nombres    [109] 	= "Bike"; 				coches_Todos_Type	[NEXT] = BICI;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:509
	NEXT++; coches_Todos_Precios    [110]    = 1000;     coches_Todos_Nombres    [110]	= "Mountain Bike"; 		coches_Todos_Type	[NEXT] = BICI;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:510
	NEXT++; coches_Todos_Precios    [111]    = 1000;     coches_Todos_Nombres    [111]  = "Beagle"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:511
	NEXT++; coches_Todos_Precios    [112]    = 1000;     coches_Todos_Nombres    [112] 	= "Cropduster"; 		coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:512
	NEXT++; coches_Todos_Precios    [113]    = 1000;     coches_Todos_Nombres    [113] 	= "Stuntplane"; 		coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:513
	NEXT++; coches_Todos_Precios    [114]    = 1000;     coches_Todos_Nombres    [114] 	= "Tanker";				coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 80; 	// Nombre: NINGUNO       ID:514
	NEXT++; coches_Todos_Precios    [115]    = 1000;     coches_Todos_Nombres    [115] 	= "Roadtrain"; 			coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 95; 	// Nombre: NINGUNO       ID:515
	NEXT++; coches_Todos_Precios    [116]    = 1500;     coches_Todos_Nombres    [116] 	= "Nebula";      		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:516
	NEXT++; coches_Todos_Precios    [117]    = 1000;     coches_Todos_Nombres    [117] 	= "Majestic";    		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:517
	NEXT++; coches_Todos_Precios    [118]    = 1500;     coches_Todos_Nombres    [118] 	= "Buccanee";     		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 110; 	// Nombre: NINGUNO       ID:518
	NEXT++; coches_Todos_Precios    [119]    = 1000;     coches_Todos_Nombres    [119] 	= "Shamal"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:519
	NEXT++; coches_Todos_Precios    [120]    = 1000;     coches_Todos_Nombres    [120] 	= "Hydra"; 				coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:520
	NEXT++; coches_Todos_Precios    [121]    = 2000;     coches_Todos_Nombres    [121] 	= "FCR-900";     		coches_Todos_Type	[NEXT] = MOTO;			coches_Todos_Velocidad [NEXT] = 115; 	// Nombre: NINGUNO       ID:521
	NEXT++; coches_Todos_Precios    [122]    = 2000;     coches_Todos_Nombres    [122] 	= "NRG-500";     		coches_Todos_Type	[NEXT] = MOTO;			coches_Todos_Velocidad [NEXT] = 120; 	// Nombre: NINGUNO       ID:522
	NEXT++; coches_Todos_Precios    [123]    = 1000;     coches_Todos_Nombres    [123] 	= "CopBike";     		coches_Todos_Type	[NEXT] = MOTO;			coches_Todos_Velocidad [NEXT] = 117; 	// Nombre: NINGUNO       ID:523
	NEXT++; coches_Todos_Precios    [124]    = 1000;     coches_Todos_Nombres    [124] 	= "Cement Truck"; 		coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:524
	NEXT++; coches_Todos_Precios    [125]    = 1000;     coches_Todos_Nombres    [125] 	= "Towtruck"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 107; 	// Nombre: NINGUNO       ID:525
	NEXT++; coches_Todos_Precios    [126]    = 1000;     coches_Todos_Nombres    [126] 	= "Fortune";     		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:526
	NEXT++; coches_Todos_Precios    [127]    = 1000;     coches_Todos_Nombres    [127] 	= "Cadrona";     		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 99; 	// Nombre: NINGUNO       ID:527
	NEXT++; coches_Todos_Precios    [128]    = 1000;     coches_Todos_Nombres    [128] 	= "FBI Truck"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 118; 	// Nombre: NINGUNO       ID:528
	NEXT++; coches_Todos_Precios    [129]    = 1000;     coches_Todos_Nombres    [129] 	= "Williard";    		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 99; 	// Nombre: NINGUNO       ID:529
	NEXT++; coches_Todos_Precios    [130]    = 1000;     coches_Todos_Nombres    [130] 	= "Forklift"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:530
	NEXT++; coches_Todos_Precios    [131]    = 1000;     coches_Todos_Nombres    [131] 	= "Tractor";			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:531
	NEXT++; coches_Todos_Precios    [132]    = 1000;     coches_Todos_Nombres    [132] 	= "Combine Harvester"; 	coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:532
	NEXT++; coches_Todos_Precios    [133]    = 1500;     coches_Todos_Nombres    [133] 	= "Felzer";      		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 111; 	// Nombre: NINGUNO       ID:533
	NEXT++; coches_Todos_Precios    [134]    = 1000;     coches_Todos_Nombres    [134] 	= "Remington"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 112; 	// Nombre: NINGUNO       ID:534
	NEXT++; coches_Todos_Precios    [135]    = 2000;     coches_Todos_Nombres    [135] 	= "Slamvan"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:535
	NEXT++; coches_Todos_Precios    [136]    = 1500;     coches_Todos_Nombres    [136] 	= "Blade";         		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 115; 	// Nombre: NINGUNO       ID:536
	NEXT++; coches_Todos_Precios    [137]    = 1000;     coches_Todos_Nombres    [137] 	= "Freight"; 			coches_Todos_Type	[NEXT] = TREN;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:537
	NEXT++; coches_Todos_Precios    [138]    = 1000;     coches_Todos_Nombres    [138] 	= "Brownstreak"; 		coches_Todos_Type	[NEXT] = TREN;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:538
	NEXT++; coches_Todos_Precios    [139]    = 1000;     coches_Todos_Nombres    [139] 	= "Vortex";				coches_Todos_Type	[NEXT] = BOTE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:539
	NEXT++; coches_Todos_Precios    [140]    = 1000;     coches_Todos_Nombres    [140] 	= "Vincent"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 99; 	// Nombre: NINGUNO       ID:540
	NEXT++; coches_Todos_Precios    [141]    = 3000;     coches_Todos_Nombres    [141] 	= "Bullet";      		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 135; 	// Nombre: NINGUNO       ID:541
	NEXT++; coches_Todos_Precios    [142]    = 1500;     coches_Todos_Nombres    [142] 	= "Clover";      		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 109; 	// Nombre: NINGUNO       ID:542
	NEXT++; coches_Todos_Precios    [143]    = 1000;     coches_Todos_Nombres    [143] 	= "Sadler"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 110; 	// Nombre: NINGUNO       ID:543
	NEXT++; coches_Todos_Precios    [144]    = 1000;     coches_Todos_Nombres    [144] 	= "Firetruck"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:544
	NEXT++; coches_Todos_Precios    [145]    = 1000;     coches_Todos_Nombres    [145] 	= "Hustler"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 100; 	// Nombre: NINGUNO       ID:545
	NEXT++; coches_Todos_Precios    [146]    = 1000;     coches_Todos_Nombres    [146] 	= "Intruder";    		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 99; 	// Nombre: NINGUNO       ID:546
	NEXT++; coches_Todos_Precios    [147]    = 1000;     coches_Todos_Nombres    [147] 	= "Primo"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 95; 	// Nombre: NINGUNO       ID:547
	NEXT++; coches_Todos_Precios    [148]    = 1000;     coches_Todos_Nombres    [148] 	= "Cargobob";			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 95; 	// Nombre: NINGUNO       ID:548
	NEXT++; coches_Todos_Precios    [149]    = 1500;     coches_Todos_Nombres    [149] 	= "Tampa";      		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 102; 	// Nombre: NINGUNO       ID:549
	NEXT++; coches_Todos_Precios    [150]    = 1500;     coches_Todos_Nombres    [150] 	= "Sunrise"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 97; 	// Nombre: NINGUNO       ID:550
	NEXT++; coches_Todos_Precios    [151]    = 1500;     coches_Todos_Nombres    [151] 	= "Merit"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:551
	NEXT++; coches_Todos_Precios    [152]    = 1000;     coches_Todos_Nombres    [152] 	= "Utility"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:552
	NEXT++; coches_Todos_Precios    [153]    = 1000;     coches_Todos_Nombres    [153] 	= "Nevada"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:553
	NEXT++; coches_Todos_Precios    [154]    = 1500;     coches_Todos_Nombres    [154] 	= "Yosemite";			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 96; 	// Nombre: NINGUNO       ID:554
	NEXT++; coches_Todos_Precios    [155]    = 1500;     coches_Todos_Nombres    [155] 	= "Windsor";   			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:555
	NEXT++; coches_Todos_Precios    [156]    = 1000;     coches_Todos_Nombres    [156] 	= "Monster A"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:556
	NEXT++; coches_Todos_Precios    [157]    = 1000;     coches_Todos_Nombres    [157] 	= "Monster B"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:557
	NEXT++; coches_Todos_Precios    [158]    = 2000;     coches_Todos_Nombres    [158] 	= "Uranus";      		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 104; 	// Nombre: NINGUNO       ID:558
	NEXT++; coches_Todos_Precios    [159]    = 2500;     coches_Todos_Nombres    [159] 	= "Jester"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 118; 	// Nombre: NINGUNO       ID:559
	NEXT++; coches_Todos_Precios    [160]    = 2500;     coches_Todos_Nombres    [160] 	= "Sultan";      		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 103; 	// Nombre: NINGUNO       ID:560
	NEXT++; coches_Todos_Precios    [161]    = 2000;     coches_Todos_Nombres    [161] 	= "Stratum";     		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 103; 	// Nombre: NINGUNO       ID:561
	NEXT++; coches_Todos_Precios    [162]    = 2500;     coches_Todos_Nombres    [162] 	= "Elegy";       		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 118; 	// Nombre: NINGUNO       ID:562
	NEXT++; coches_Todos_Precios    [163]    = 1000;     coches_Todos_Nombres    [163] 	= "Raindance"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:563
	NEXT++; coches_Todos_Precios    [164]    = 1000;     coches_Todos_Nombres    [164]	= "RC Tiger"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:564
	NEXT++; coches_Todos_Precios    [165]    = 2000;     coches_Todos_Nombres    [165] 	= "Flash";       		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 110; 	// Nombre: NINGUNO       ID:565
	NEXT++; coches_Todos_Precios    [166]    = 1000;     coches_Todos_Nombres    [166] 	= "Tahoma"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 107; 	// Nombre: NINGUNO       ID:566
	NEXT++; coches_Todos_Precios    [167]    = 1000;     coches_Todos_Nombres    [167] 	= "Savanna"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 115; 	// Nombre: NINGUNO       ID:567
	NEXT++; coches_Todos_Precios    [168]    = 1000;     coches_Todos_Nombres    [168] 	= "Bandito"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:568
	NEXT++; coches_Todos_Precios    [169]    = 1000;     coches_Todos_Nombres    [169] 	= "Freight Flat Trailer";coches_Todos_Type	[NEXT] = TREN;  		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:569
	NEXT++; coches_Todos_Precios    [170]    = 1000;     coches_Todos_Nombres    [170] 	= "Streak Trailer"; 	coches_Todos_Type	[NEXT] = TREN;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:570
	NEXT++; coches_Todos_Precios    [171]    = 1000;     coches_Todos_Nombres    [171] 	= "Kart"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:571
	NEXT++; coches_Todos_Precios    [172]    = 1000;     coches_Todos_Nombres    [172] 	= "Mower"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:572
	NEXT++; coches_Todos_Precios    [173]    = 1000;     coches_Todos_Nombres    [173] 	= "Dune";				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:573
	NEXT++; coches_Todos_Precios    [174]    = 1000;     coches_Todos_Nombres    [174] 	= "Sweeper"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:574
	NEXT++; coches_Todos_Precios    [175]    = 1000;     coches_Todos_Nombres    [175] 	= "Broadway";			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:575
	NEXT++; coches_Todos_Precios    [176]    = 1000;     coches_Todos_Nombres    [176] 	= "Tornado";			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:576
	NEXT++; coches_Todos_Precios    [177]    = 1000;     coches_Todos_Nombres    [177] 	= "AT400"; 				coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:577
	NEXT++; coches_Todos_Precios    [178]    = 1000;     coches_Todos_Nombres    [178] 	= "DFT-30"; 			coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 87; 	// Nombre: NINGUNO       ID:578
	NEXT++; coches_Todos_Precios    [179]    = 1000;     coches_Todos_Nombres    [179] 	= "Huntley";			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:579
	NEXT++; coches_Todos_Precios    [180]    = 1500;     coches_Todos_Nombres    [180] 	= "Stafford"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 102; 	// Nombre: NINGUNO       ID:580
	NEXT++; coches_Todos_Precios    [181]    = 2000;     coches_Todos_Nombres    [181] 	= "BF-400";      		coches_Todos_Type	[NEXT] = MOTO;			coches_Todos_Velocidad [NEXT] = 100; 	// Nombre: NINGUNO       ID:581
	NEXT++; coches_Todos_Precios    [182]    = 1000;     coches_Todos_Nombres    [182] 	= "Newsvan";     		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 81; 	// Nombre: NINGUNO       ID:582
	NEXT++; coches_Todos_Precios    [183]    = 1000;     coches_Todos_Nombres    [183] 	= "Tug"; 				coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:583
	NEXT++; coches_Todos_Precios    [184]    = 1000;     coches_Todos_Nombres    [184] 	= "Petrol Trailer"; 	coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:584
	NEXT++; coches_Todos_Precios    [185]    = 1000;     coches_Todos_Nombres    [185] 	= "Emperor"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 102; 	// Nombre: NINGUNO       ID:585
	NEXT++; coches_Todos_Precios    [186]    = 2000;     coches_Todos_Nombres    [186] 	= "Wayfarer";     		coches_Todos_Type	[NEXT] = MOTO;			coches_Todos_Velocidad [NEXT] = 95; 	// Nombre: NINGUNO       ID:586
	NEXT++; coches_Todos_Precios    [187]    = 2500;     coches_Todos_Nombres    [187] 	= "Euros";        		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 110; 	// Nombre: NINGUNO       ID:587
	NEXT++; coches_Todos_Precios    [188]    = 1000;     coches_Todos_Nombres    [188] 	= "Hotdog"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:588
	NEXT++; coches_Todos_Precios    [189]    = 1500;     coches_Todos_Nombres    [189] 	= "Club";        		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 108; 	// Nombre: NINGUNO       ID:589
	NEXT++; coches_Todos_Precios    [190]    = 1000;     coches_Todos_Nombres    [190] 	= "Freight Box Trailer";coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:590
	NEXT++; coches_Todos_Precios    [191]    = 1000;     coches_Todos_Nombres    [191] 	= "Article Trailer 3"; 	coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:591
	NEXT++; coches_Todos_Precios    [192]    = 1000;     coches_Todos_Nombres    [192] 	= "Andromada"; 			coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:592
	NEXT++; coches_Todos_Precios    [193]    = 1000;     coches_Todos_Nombres    [193] 	= "Dodo"; 				coches_Todos_Type	[NEXT] = VUELO;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:593
	NEXT++; coches_Todos_Precios    [194]    = 1000;     coches_Todos_Nombres    [194] 	= "RC Cam"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:594
	NEXT++; coches_Todos_Precios    [195]    = 1000;     coches_Todos_Nombres    [195] 	= "Launch"; 			coches_Todos_Type	[NEXT] = BOTE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:595
	NEXT++; coches_Todos_Precios    [196]    = 1000;     coches_Todos_Nombres    [196] 	= "Police Car"; 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 117; 	// Nombre: NINGUNO       ID:596
	NEXT++; coches_Todos_Precios    [197]    = 1000;     coches_Todos_Nombres    [197] 	= "Police Car"; 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 117; 	// Nombre: NINGUNO       ID:597
	NEXT++; coches_Todos_Precios    [198]    = 1000;     coches_Todos_Nombres    [198] 	= "Police Car"; 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 117; 	// Nombre: NINGUNO       ID:598
	NEXT++; coches_Todos_Precios    [199]    = 1000;     coches_Todos_Nombres    [199] 	= "Police Ranger"; 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 105; 	// Nombre: NINGUNO       ID:599
	NEXT++; coches_Todos_Precios    [200]    = 1500;     coches_Todos_Nombres    [200] 	= "Picador";    		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 101; 	// Nombre: NINGUNO       ID:600
	NEXT++; coches_Todos_Precios    [201]    = 1000;     coches_Todos_Nombres    [201] 	= "S.W.A.T."; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 74; 	// Nombre: NINGUNO       ID:601
	NEXT++; coches_Todos_Precios    [202]    = 2000;     coches_Todos_Nombres    [202] 	= "Alpha";        		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 113; 	// Nombre: NINGUNO       ID:602
	NEXT++; coches_Todos_Precios    [203]    = 2000;     coches_Todos_Nombres    [203] 	= "Phoenix";     		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 114; 	// Nombre: NINGUNO       ID:603
	NEXT++; coches_Todos_Precios    [204]    = 1000;     coches_Todos_Nombres    [204] 	= "Glendale Shit"; 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:604
	NEXT++; coches_Todos_Precios    [205]    = 1000;     coches_Todos_Nombres    [205] 	= "Sadler Shit"; 		coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:605
	NEXT++; coches_Todos_Precios    [206]    = 1000;     coches_Todos_Nombres    [206] 	= "Baggage Trailer A"; 	coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:606
	NEXT++; coches_Todos_Precios    [207]    = 1000;     coches_Todos_Nombres    [207] 	= "Baggage Trailer B"; 	coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:607
	NEXT++; coches_Todos_Precios    [208]    = 1000;     coches_Todos_Nombres    [208] 	= "Tug Stairs Trailer"; coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:608
	NEXT++; coches_Todos_Precios    [209]    = 1000;     coches_Todos_Nombres    [209] 	= "Boxville"; 			coches_Todos_Type	[NEXT] = COCHE;			coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:609
	NEXT++; coches_Todos_Precios    [210]    = 1000;     coches_Todos_Nombres    [210] 	= "Farm Trailer"; 		coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:610
	NEXT++; coches_Todos_Precios    [211]    = 1000;     coches_Todos_Nombres    [211] 	= "Utility Trailer"; 	coches_Todos_Type	[NEXT] = CAMION;		coches_Todos_Velocidad [NEXT] = 0; 		// Nombre: NINGUNO       ID:611
}
GetMySecondNearVehicle(playerid)
{
    new MyVehicle = GetPlayerVehicleID(playerid);
    new Float:X, Float:Y, Float:Z;
	for (new i = 1; i <= MAX_CAR; i++)
	{
	    GetVehiclePos(i, X, Y, Z);
		if (IsPlayerInRangeOfPoint(playerid, 9.0,
			X,
			Y,
			Z) && i != MyVehicle)
		{
		    return i;
		}
	}
	return false;
}
IsPlayerInTrain(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if ( GetTrainByVehicleID(vehicleid) )
	{
	    new Vagonid = GetVagonByVehicleID(vehicleid);
	    if ( Vagonid )
	    {
		    SetPlayerVirtualWorldEx(playerid, GetTrainByVehicleID(vehicleid));
		    SetPlayerPos(playerid, PickupInfo[PickupExitVagones[Vagonid - 1]][PosInfoX], PickupInfo[PickupExitVagones[Vagonid - 1]][PosInfoY], PickupInfo[PickupExitVagones[Vagonid - 1]][PosInfoZ]);
		    SetPlayerInteriorEx(playerid, 3);
			SetPlayerFacingAngle(playerid, 180.0);
			SetCameraBehindPlayer(playerid);
			return true;
		}
	}
	return false;
}

IsPlayerInPincho(playerid, pickupid)
{
	if ( PickupIndex[pickupid][Tipo] == PICKUP_TYPE_PINCHO && IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0)
	{
	    new pinchoid = PickupIndex[pickupid][Tipoid];
	    if (VCP[pinchoid][objectid_vcp] != -1 && VCP[pinchoid][pickupidVCP] == pickupid)
	    {
	        new MyVehicle = GetPlayerVehicleID(playerid);
			new 
				VEHICLE_PANEL_STATUS:Vpanel,
				VEHICLE_DOOR_STATUS:Vdoors,
				VEHICLE_LIGHT_STATUS:Vlights,
				VEHICLE_TYRE_STATUS:Vtires;
			GetVehicleDamageStatus(MyVehicle, Vpanel, Vdoors, Vlights, Vtires);
			UpdateVehicleDamageStatus(MyVehicle, Vpanel, Vdoors, Vlights, VEHICLE_TYRE_STATUS:0b1111);
	    }
	}
}

stock SetVehicleTaxi(vehicleid)
{
	TaxisTaximetro[MAX_TAXIS][TaxiVehicleid] = vehicleid;
	SetTaxiReadyTextDraw(MAX_TAXIS, 0);
	SetTaxiReadyTextDraw(MAX_TAXIS, 1);
	SetTaxiReadyTextDraw(MAX_TAXIS, 2);
	MAX_TAXIS++;
}
stock SetTaxiReadyTextDraw(taxiid, textdrawid)
{
	TaxisTaximetro[taxiid][Seats][textdrawid] = TextDrawCreateEx(524.0, 395.0,"Empty");
	TextDrawUseBox(TaxisTaximetro[taxiid][Seats][textdrawid], true);
	TextDrawBackgroundColour(TaxisTaximetro[taxiid][Seats][textdrawid], 0x000000A3);
	TextDrawColour(TaxisTaximetro[taxiid][Seats][textdrawid], 0x2DFF00FF);
	TextDrawBoxColour(TaxisTaximetro[taxiid][Seats][textdrawid], 0x000000A1);
	TextDrawTextSize(TaxisTaximetro[taxiid][Seats][textdrawid], 625, 400.0);
	TextDrawSetShadow(TaxisTaximetro[taxiid][Seats][textdrawid], 1);
	TextDrawLetterSize(TaxisTaximetro[taxiid][Seats][textdrawid], 0.3 , 1.0);
	TextDrawFont(TaxisTaximetro[taxiid][Seats][textdrawid], TEXT_DRAW_FONT_2);
}
IsVehicleTaxi(vehicleid)
{
	for ( new i = 0; i < MAX_TAXIS; i++)
	{
	    if ( TaxisTaximetro[i][TaxiVehicleid] == vehicleid )
	    {
	        return i;
		}
	}
	return -1;
}
bool:IsValidVehicleEx(vehiclemodel){
	if ( coches_Todos_Type[vehiclemodel - 400] != BICI &&
		 coches_Todos_Type[vehiclemodel - 400] != MOTO &&
		 coches_Todos_Type[vehiclemodel - 400] != CAMION &&
		 coches_Todos_Type[vehiclemodel - 400] != VUELO )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}
IsValidVehiclePaintJob(vehiclemodel)
{
	if ( vehiclemodel == 560 ||
		 vehiclemodel == 561 ||
		 vehiclemodel == 567 ||
		 vehiclemodel == 562 ||
		 vehiclemodel == 565 ||
		 vehiclemodel == 569 ||
		 vehiclemodel == 568 ||
		 vehiclemodel == 434 ||
		 vehiclemodel == 535 ||
		 vehiclemodel == 536 ||
 		 vehiclemodel == 558 ||
 		 vehiclemodel == 545 ||
 		 vehiclemodel == 559
	   )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}
IsVehicleExplotion(playerid, vehicleid, Float:damage, seat)
{
	new Salte;
	if ( damage < 250.0 )
	{
		if ( !PlayersDataOnline[playerid][CountIntentarVehicle] )
		{
		    if ( IntentarAccion(playerid, "salir del vehiculo", random(2)) )
		    {
				PlayersDataOnline[playerid][CountIntentarVehicle] = 1;
			}
			else
			{
				Salte = true;
				PlayersDataOnline[playerid][CountIntentarVehicle] = 2;
			}
		}
		else if ( PlayersDataOnline[playerid][CountIntentarVehicle] == 2 )
		{
	    	Salte = true;
	    }

		if ( Salte )
		{
			ForcePutPlayerInVehicle(playerid, vehicleid, seat);
		}
	}
}
ForcePutPlayerInVehicle(playerid, vehicleid, seat)
{
	if (!seat)
	{
		new Float:PlayerPos[3]; GetPlayerPos(playerid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);
		SetPlayerPos(playerid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);
	}
	PutPlayerInVehicle(playerid, vehicleid, seat);
}
IsValidSeatTaxi(seatid)
{
	if ( seatid >= 1 && seatid <= 3 )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}
CheckValidPlayerToTaxi(playerid, taxiid)
{
	if ( GetPlayerVehicleID(playerid) == TaxisTaximetro[taxiid][TaxiVehicleid] &&
		 PlayersDataOnline[playerid][IsTaxi] == -1 &&
		 IsValidSeatTaxi(GetPlayerVehicleSeat(playerid)) )
	{
	    return true;
    }
    else
    {
        return false;
	}
}
SetPlayerTaxi(playerid, taxiid, seat)
{
    seat--;
	PlayersDataOnline[playerid][IsTaxi] = taxiid;
    PlayersDataOnline[playerid][SeatTaxi] = seat;
	TextDrawShowForPlayer(playerid, TaxisTaximetro[taxiid][Seats][seat]);
    TaxisTaximetro[taxiid][TaxiTime][seat] = gettime();
}
UpdateTaximetroSeat(playerid)
{
//      \x98 = A Con tilde
// 		\x9e = E con tilde
//      \xa2 = I Con tilde
//		\xa6 = O Con tilde

	new TimeNow = gettime();
	new TaxiStringUpdate[100];
	new MinutesT;
	new SecondsT;
	if ( (TimeNow - TaxisTaximetro[PlayersDataOnline[playerid][IsTaxi]][TaxiTime][PlayersDataOnline[playerid][SeatTaxi]]) <= 59 )
	{
        SecondsT = (TimeNow - TaxisTaximetro[PlayersDataOnline[playerid][IsTaxi]][TaxiTime][PlayersDataOnline[playerid][SeatTaxi]]);
	}
	else
	{
        SecondsT = (TimeNow - TaxisTaximetro[PlayersDataOnline[playerid][IsTaxi]][TaxiTime][PlayersDataOnline[playerid][SeatTaxi]]) % 60;
	}
	if ( (TimeNow - TaxisTaximetro[PlayersDataOnline[playerid][IsTaxi]][TaxiTime][PlayersDataOnline[playerid][SeatTaxi]]) <= 3600 )
	{
        MinutesT = (TimeNow - TaxisTaximetro[PlayersDataOnline[playerid][IsTaxi]][TaxiTime][PlayersDataOnline[playerid][SeatTaxi]]) / 60;
	}
	else
	{
        MinutesT = ((TimeNow - TaxisTaximetro[PlayersDataOnline[playerid][IsTaxi]][TaxiTime][PlayersDataOnline[playerid][SeatTaxi]]) % 3600) / 60;
	}
	format(TaxiStringUpdate, sizeof(TaxiStringUpdate), "  ~R~.::Tax\xa2~R~metro::.~N~~N~~B~ Tiempo:~W~%2i:%2i:%2i~N~~B~    Pagar: ~G~$%4i",

	(TimeNow - TaxisTaximetro[PlayersDataOnline[playerid][IsTaxi]][TaxiTime][PlayersDataOnline[playerid][SeatTaxi]]) / 3600,
	MinutesT,
	SecondsT,
	CalcularTaxiMoney(playerid)
	);
	TextDrawSetString(TaxisTaximetro[PlayersDataOnline[playerid][IsTaxi]][Seats][PlayersDataOnline[playerid][SeatTaxi]], TaxiStringUpdate);

	if ( PlayersData[playerid][Dinero] <= CalcularTaxiMoney(playerid) )
	{
	    PayTaxi(playerid, true);
	    RemovePlayerFromVehicle(playerid);
		SendClientMessage(playerid, COLOR_MESSAGES[0], " No tienes dinero para pagar el taxi!");
	}
	else if ( !TaxisTaximetro[PlayersDataOnline[playerid][IsTaxi]][TaxiOn] )
	{
		PayTaxi(playerid, true);
	}
}
PayTaxi(playerid, option)
{
	if ( PlayersDataOnline[playerid][IsTaxi] != -1 )
	{
	    new MoneyTaxi = CalcularTaxiMoney(playerid);
	    new NoPay;
	    GivePlayerMoneyEx(playerid, -MoneyTaxi);
	    for ( new i = 0; i < MAX_PLAYERS; i++ )
	    {
			if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 &&
				 IsPlayerInAnyVehicle(i) &&
				 GetPlayerVehicleID(i) == TaxisTaximetro[PlayersDataOnline[playerid][IsTaxi]][TaxiVehicleid] &&
				 GetPlayerVehicleSeat(playerid) == 0 &&
				 PlayersData[playerid][Faccion] == TAXI )
			{
				GivePlayerMoneyEx(i, MoneyTaxi);
				NoPay = true;
				break;
			}
	    }
	    if ( !NoPay )
	    {
	    	FaccionData[TAXI][Deposito] += MoneyTaxi;
    	}
		if ( option )
		{
			TextDrawHideForPlayer(playerid, TaxisTaximetro[PlayersDataOnline[playerid][IsTaxi]][Seats][PlayersDataOnline[playerid][SeatTaxi]]);
			if ( MoneyTaxi > 0 )
			{
				new MsgPayTaxi[MAX_TEXT_CHAT];
				format(MsgPayTaxi, sizeof(MsgPayTaxi), "Has pagado $%i por el servicio del taxi.", MoneyTaxi);
				SendInfoMessage(playerid, 3, "0", MsgPayTaxi);
			}
		}
	    PlayersDataOnline[playerid][IsTaxi] = -1;
	}
}
CalcularTaxiMoney(playerid)
{
	return ((gettime() - TaxisTaximetro[PlayersDataOnline[playerid][IsTaxi]][TaxiTime][PlayersDataOnline[playerid][SeatTaxi]]) / SECONDS_TAXI);
}

GetVehicleName(vehicleIndex, name[], len)
{
	new modelid = GetVehicleModel(DataCars[vehicleIndex][VehicleID]);
	if (modelid < 400 || modelid > 611) return 0;
	format(name, len, "%s", coches_Todos_Nombres[modelid - 400]);
	return 1;
}


ShowVehicleInfo(playerid, vehicleIndex)
{
	new MsgDatos[MAX_TEXT_CHAT];
	new vehicleName[32];
	GetVehicleName(vehicleIndex, vehicleName, sizeof(vehicleName));
	format(MsgDatos, sizeof(MsgDatos), "ID: %i (UID: %i) || Vehiculo: %s Modelo ID:(%i) Mundo Spawn: (%i) Interior Spawn: (%i)", 
		DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][ID], vehicleName, GetVehicleModel(DataCars[vehicleIndex][ID]), DataCars[vehicleIndex][World], DataCars[vehicleIndex][Interior]);
	SendInfoMessage(playerid, 1, MsgDatos, "Datos: ");
	format(MsgDatos, sizeof(MsgDatos), "Mundo Actual: (%i) | Interior Actual: (%i)", DataCars[vehicleIndex][WorldLast], DataCars[vehicleIndex][InteriorLast]);
	SendInfoMessage(playerid, 1, MsgDatos, "Datos: ");
	if (DataCars[vehicleIndex][OwnerId] != 0)
	{
		format(MsgDatos, sizeof(MsgDatos), "Matrícula: %i ", DataCars[vehicleIndex][Matricula]);
		SendInfoMessage(playerid, 1, MsgDatos, "Datos: ");
		format(MsgDatos, sizeof(MsgDatos), "Dueño: %s (UID: %i)", DataCars[vehicleIndex][Dueno], DataCars[vehicleIndex][OwnerId]);
		SendInfoMessage(playerid, 1, MsgDatos, "Datos: ");
		format(MsgDatos, sizeof(MsgDatos), "Tiempo: %i", DataCars[vehicleIndex][Time]);
		SendInfoMessage(playerid, 1, MsgDatos, "Datos: ");
	}
	if (DataCars[vehicleIndex][JobId] != 0)
	{
		format(MsgDatos, sizeof(MsgDatos), "Trabajo: %s ", Jobs[DataCars[vehicleIndex][JobId]][NameJob]);
		SendInfoMessage(playerid, 1, MsgDatos, "Datos: ");
	}
	if (DataCars[vehicleIndex][FactionId] != 0)
	{
		format(MsgDatos, sizeof(MsgDatos), "Faccion: %s", FaccionData[DataCars[vehicleIndex][FactionId]][NameFaccion]);
		SendInfoMessage(playerid, 1, MsgDatos, "Datos: ");
	}
	return 1;
}



function ApplyPlayerAnimAccident(playerid)
{
	if ( IsPlayerInAnyVehicle(playerid) )
	{
		ApplyPlayerAnimCustom(playerid,
		"PED",
		PED_ANIMATIONS[59], false);
	}
}

function ApplyPlayerAnimAccidentD(playerid)
{
	if ( IsPlayerInAnyVehicle(playerid) )
	{
		ApplyPlayerAnimCustom(playerid,
		"PED",
		PED_ANIMATIONS[63], false);
	}
}

function ReturnPlayerNormalState(playerid)
{
	if (IsPlayerConnected(playerid) && IsPlayerInAnyVehicle(playerid))
	{
	    SetPlayerDrunkLevel(playerid, 4000);
	    SetPlayerWeather(playerid, WeatherCurrent);
	}
}

function CheckVehicleGas()
{
	new CheckTimeVehicle = gettime();
	for (new i = 0; i <= MAX_CAR; i++)
	{
		if (!DataCars[i][VehicleID]) 
			continue;

	    if ( coches_Todos_Type[DataCars[i][Modelo] - 400] != TREN && coches_Todos_Type[DataCars[i][Modelo] - 400] != VUELO)
	    {
			IsVehicleBug(i, true);
			if ( DataCars[i][StateEncendido] && (CheckTimeVehicle - DataCars[i][TimeGas]) >= (TIME_CHECK_GAS_VEHICLES / 1000))
			{
			    if ( DataCars[i][Gas] >= 1 )
			    {
			        DataCars[i][Gas]--;
			 	}
			    if ( DataCars[i][ConteoOil] >= 8 && DataCars[i][Oil] >= 1 )
			    {
			        DataCars[i][Oil]--;
			        DataCars[i][ConteoOil] = false;
			 	}

			 	DataCars[i][ConteoOil]++;

		        DataCars[i][TimeGas] = CheckTimeVehicle;


			}
			IsAlarmaBug(i);
		}
	}

    for(new i=0;i<MAX_PLAYERS;i++)
    {
        if (IsPlayerConnected(i)&&PlayersDataOnline[i][StateChannelOOC]&&PlayersDataOnline[i][State] == 3&&!PlayersData[i][Enfermedad])
        {
            if (PlayersDataOnline[i][VidaOn]<=VIDA_CRACK || PlayersData[i][Cansansio]<=1 )
            {
	            if ( random(30) == 15 )
	            {
					new RandomEnfermedad = random(4);
					switch ( RandomEnfermedad )
					{
					    case 0:
					    {
							ChangeEnfermedad(i, 1);
						}
					    case 1:
					    {
							ChangeEnfermedad(i, 2);
						}
					    case 2:
					    {
							ChangeEnfermedad(i, 4);
						}
						case 3:
						{
							ChangeEnfermedad(i, 5);
						}
					}
	       		}
       		}
        }
	}
	SetTimer("CheckVehicleGas", TIME_CHECK_GAS_VEHICLES, false);
}

function TimerIntermitentes(vehicleIndex)
{
	if ( DataCars[vehicleIndex][IsIntermitente] )
	{
		new 
			VEHICLE_PANEL_STATUS:Panels,
			VEHICLE_DOOR_STATUS:Doors1,
			VEHICLE_LIGHT_STATUS:Lights,
			VEHICLE_TYRE_STATUS:Tires;
		GetVehicleDamageStatus(DataCars[vehicleIndex][VehicleID], Panels, Doors1, Lights, Tires);
		if (DataCars[vehicleIndex][ConteoIntermitente])
		{
		    DataCars[vehicleIndex][ConteoIntermitente] = false;
			if (DataCars[vehicleIndex][IsIntermitente] == 1) // Izquierda
			{
				UpdateVehicleDamageStatus(DataCars[vehicleIndex][VehicleID], Panels, Doors1, VEHICLE_LIGHT_STATUS:0b00000001, Tires);
			}
			else if (DataCars[vehicleIndex][IsIntermitente] == 2) // Derecha
			{
				UpdateVehicleDamageStatus(DataCars[vehicleIndex][VehicleID], Panels, Doors1, VEHICLE_LIGHT_STATUS:0b00000100, Tires);
			}
			else if (DataCars[vehicleIndex][IsIntermitente] == 3) // Ambos
			{
				DataCars[vehicleIndex][LightState] = false;
				IsVehicleOff(vehicleIndex);
				UpdateVehicleDamageStatus(DataCars[vehicleIndex][VehicleID], Panels, Doors1, VEHICLE_LIGHT_STATUS:0b00000101, Tires);
			}
		}
		else
		{
		    DataCars[vehicleIndex][ConteoIntermitente] = true;
			DataCars[vehicleIndex][LightState] = true;
			IsVehicleOff(vehicleIndex);
			UpdateVehicleDamageStatus(DataCars[vehicleIndex][VehicleID], Panels, Doors1, VEHICLE_LIGHT_STATUS:0b00000000, Tires);
		}
	    SetTimerEx("TimerIntermitentes", 500, false, "d", vehicleIndex);
	}
	else
	{
		DataCars[vehicleIndex][LightState] = true;
		IsVehicleOff(vehicleIndex);
		new 
			VEHICLE_PANEL_STATUS:Panels,
			VEHICLE_DOOR_STATUS:Doors1,
			VEHICLE_LIGHT_STATUS:Lights,
			VEHICLE_TYRE_STATUS:Tires;
		GetVehicleDamageStatus(DataCars[vehicleIndex][VehicleID], Panels, Doors1, Lights, Tires);
		UpdateVehicleDamageStatus(DataCars[vehicleIndex][VehicleID], Panels, Doors1, VEHICLE_LIGHT_STATUS:0b00000000, Tires);
	}
}

function FillVehicleGas(vehicleIndex)
{
	if ( DataCars[vehicleIndex][Gas] < DataCars[vehicleIndex][LlenandoGas] )
	{
		DataCars[vehicleIndex][Gas]++;
		SetTimerEx("FillVehicleGas", 1000, false, "d", vehicleIndex);
		
	}
	else
	{
 	    DataCars[vehicleIndex][LlenandoGas] = false;
	}
}

function SetVehicleShow(vehicleIndex)
{
	SetVehicleVirtualWorldEx(vehicleIndex, DataCars[vehicleIndex][World]);
	LinkVehicleToInteriorEx(vehicleIndex, DataCars[vehicleIndex][Interior]);
}

function SetVehicleBugToRespawn(vehicleIndex)
{
    DataCars[vehicleIndex][VehicleDeath] = false;
    SetVehicleToRespawnEx(vehicleIndex);
	SetVehicleHidden(vehicleIndex);
}

function PlayerRestoreVarExitedVehicle(playerid)
{
	PlayersDataOnline[playerid][ExitedVehicle] = false;
}

function OnVehicleCreatedDB(playerid, model, color1, color2)
{
	new Float: x, Float: y, Float: z, Float: r;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, r);

	new vehicleIndex = MAX_CAR + 1;	
	for (new i = 0; i < MAX_VEHICLE_COUNT; i++)
	{
		if (!DataCars[i][ID])
		{
			vehicleIndex = i;
			break;
		}
	}
	vehicleIndex = CreateVehicleEx(model, x, y, z, r, color1, color2, vehicleIndex);

	DataCars[vehicleIndex][ID] = cache_insert_id();
	DataCars[vehicleIndex][Modelo] = model;
	DataCars[vehicleIndex][PosX] = x;
	DataCars[vehicleIndex][PosY] = y;
	DataCars[vehicleIndex][PosZ] = z;
	DataCars[vehicleIndex][PosZZ] = r;
	DataCars[vehicleIndex][Color1] = color1;
	DataCars[vehicleIndex][Color2] = color2;
	DataCars[vehicleIndex][Interior] = GetPlayerInterior(playerid);
	DataCars[vehicleIndex][World] = GetPlayerVirtualWorld(playerid);
	DataCars[vehicleIndex][Gas] = MAX_GAS_VEHICLE;
	DataCars[vehicleIndex][Oil] = MAX_OIL_VEHICLE;
	// DataCars[vehicleIndex][TypeCar] = 0;
	DataCars[vehicleIndex][FactionId] = 0;
	DataCars[vehicleIndex][JobId] = 0;
	DataCars[vehicleIndex][OwnerId] = 0;
	DataCars[vehicleIndex][Time] = MAX_VEHICLE_TIME;
	DataCars[vehicleIndex][Lock] = false;
	DataCars[vehicleIndex][WorldLast] = DataCars[vehicleIndex][World];
	DataCars[vehicleIndex][InteriorLast] = DataCars[vehicleIndex][Interior];
	DataCars[vehicleIndex][Puente] = true;
	DataCars[vehicleIndex][LastDamage] = 1000.0;
	DataCars[vehicleIndex][StationID] = -1;
	DataCars[vehicleIndex][AlarmOn] = false;
	SetVehicleHealthEx(vehicleIndex, 1000.0);
	ChangeVehiclePaintjob(DataCars[vehicleIndex][VehicleID], 3);
	DataCars[vehicleIndex][Vinillo] = 3;
	
	ChangeVehiclePlate(vehicleIndex, 0);

	SetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][World]);
	LinkVehicleToInterior(DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][Interior]);

	if ( coches_Todos_Type[model - 400] != BICI )
	{
		DataCars[vehicleIndex][StateEncendido] = false;
	}
	else
	{
		DataCars[vehicleIndex][StateEncendido] = true;
	}
	IsVehicleOff(vehicleIndex);
	new string[150], carName[32];
	GetVehicleName(vehicleIndex, carName, sizeof(carName));
	format(string, sizeof(string), "Creaste el vehículo \"%s\" ID: %d [SQLID: %i], ahora está disponible para la venta.", carName, DataCars[vehicleIndex][VehicleID], DataCars[vehicleIndex][ID]);
	SendInfoMessage(playerid, 3, "0", string);
	SaveDataVehicle(vehicleIndex);
	MAX_CAR++;
}