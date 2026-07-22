
IsPlayerNearGarageEx(vehicleIndex, playerid)
{
	new MyWorld = GetPlayerVirtualWorld(playerid), 
		MyInt = GetPlayerInterior(playerid), 
		vehicleid = DataCars[vehicleIndex][VehicleID];
	for (new i = 0; i != MAX_GARAGES_EX_COUNT; i++)
	{
		if(!GaragesEx[i][Creado]) continue;

		if( IsPlayerInRangeOfPoint(playerid, 3.0,
				GaragesEx[i][PosXOne],
				GaragesEx[i][PosYOne],
				GaragesEx[i][PosZOne]) && 
				MyWorld == Teles[GaragesEx[i][ID_Tele]][World] && 
				MyInt == Teles[GaragesEx[i][ID_Tele]][Interior] ||
			IsPlayerInRangeOfPoint(playerid, 3.0,
				GaragesEx[i][PosXTwo],
				GaragesEx[i][PosYTwo],
				GaragesEx[i][PosZTwo]) &&
				MyWorld == Teles[Teles[GaragesEx[i][ID_Tele]][PickupIDGo]][World] && 
				MyInt == Teles[Teles[GaragesEx[i][ID_Tele]][PickupIDGo]][Interior])
		{
			if(!IsValidGarageEx(i, GaragesEx[i][ID_Tele], Teles[GaragesEx[i][ID_Tele]][PickupIDGo]))
			{
				SendInfoMessage(playerid, 0, "", "El Garage se encuentra bugeado (La posicion de entrada o salida de vehiculos se encuentra demasiado lejos de la puerta)");
				return false;
			}
			if ( !Teles[GaragesEx[i][ID_Tele]][Lock] || PlayersDataOnline[playerid][AdminOn] )
            {
				if(IsPlayerInRangeOfPoint(playerid, 3.0,
						GaragesEx[i][PosXOne],
						GaragesEx[i][PosYOne],
						GaragesEx[i][PosZOne]) &&
						MyWorld == Teles[GaragesEx[i][ID_Tele]][World] &&
						MyInt == Teles[GaragesEx[i][ID_Tele]][Interior])
				{
		        	SetVehicleVirtualWorldEx(vehicleIndex, Teles[Teles[GaragesEx[i][ID_Tele]][PickupIDGo]][World]);
		        	LinkVehicleToInteriorEx(vehicleIndex, Teles[Teles[GaragesEx[i][ID_Tele]][PickupIDGo]][Interior]);
					SetVehiclePos(vehicleid, GaragesEx[i][PosXTwo], GaragesEx[i][PosYTwo],GaragesEx[i][PosZTwo]);
					SetVehicleZAngle(vehicleid, GaragesEx[i][PosZZTwo]);
					for (new s = 0; s < MAX_PLAYERS;s++)
					{
					    if ( IsPlayerConnected(s) && IsPlayerInVehicle(s, vehicleid) )
					    {
				        	SetPlayerVirtualWorldEx(s, Teles[Teles[GaragesEx[i][ID_Tele]][PickupIDGo]][World]);
				        	SetPlayerInteriorEx(s, Teles[Teles[GaragesEx[i][ID_Tele]][PickupIDGo]][Interior]);
					    }
					}
	        	}
	        	else
	        	{
		        	SetVehicleVirtualWorldEx(vehicleIndex, Teles[GaragesEx[i][ID_Tele]][World]);
		        	LinkVehicleToInteriorEx(vehicleIndex, Teles[GaragesEx[i][ID_Tele]][Interior]);
					SetVehiclePos(vehicleid, GaragesEx[i][PosXOne], GaragesEx[i][PosYOne], GaragesEx[i][PosZOne]);
					SetVehicleZAngle(vehicleid, GaragesEx[i][PosZZOne]);

					for (new s = 0; s < MAX_PLAYERS;s++)
					{
					    if ( IsPlayerConnected(s) && IsPlayerInVehicle(s, vehicleid) )
					    {
				        	SetPlayerVirtualWorldEx(s, Teles[GaragesEx[i][ID_Tele]][World]);
				        	SetPlayerInteriorEx(s, Teles[GaragesEx[i][ID_Tele]][Interior]);
					    }
					}
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
	return false;
}
IsPlayerInGarageEx(playerid)
{
	if ( PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipo] == PICKUP_TYPE_TELE && 
		Teles[PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipoid]][IsGarage])
	{
		return PickupIndex[ PlayersDataOnline[playerid][InPickup] ][Tipoid];
	}
	else if (IsPlayerInAnyVehicle(playerid))
	{
	    new MyWorld = GetPlayerVirtualWorld(playerid), MyInt = GetPlayerInterior(playerid);
	    for (new g=0; g!=MAX_GARAGES_EX_COUNT; g++)
	    {
			if(!GaragesEx[g][Creado]) continue;

	        if (IsPlayerInRangeOfPoint(playerid, 3.0, GaragesEx[g][PosXOne], GaragesEx[g][PosYOne], GaragesEx[g][PosZOne]) &&
					MyWorld == Teles[GaragesEx[g][ID_Tele]][World] && MyInt == Teles[GaragesEx[g][ID_Tele]][Interior] ||
	       		IsPlayerInRangeOfPoint(playerid, 3.0, GaragesEx[g][PosXTwo], GaragesEx[g][PosYTwo], GaragesEx[g][PosZTwo]) 
					&& MyWorld == Teles[Teles[GaragesEx[g][ID_Tele]][PickupIDGo]][World] && MyInt == Teles[Teles[GaragesEx[g][ID_Tele]][PickupIDGo]][Interior])
					
			{
			    return g;
			}
	    }
	}
	return -1;
}

IsVehicleInGarageEx(vehicleIndex)
{
	new Float:PosVehicleE[3]; 
	GetVehiclePos(DataCars[vehicleIndex][VehicleID], PosVehicleE[0], PosVehicleE[1], PosVehicleE[2]);
	new Float:RangeCheck = 10.0, i;
	do {
		i = 0;
		for(; i != MAX_GARAGES_EX_COUNT; i++)
		{
			if (!GaragesEx[i][Creado]) continue;
			if (IsPointFromPoint(RangeCheck, PosVehicleE[0], PosVehicleE[1], PosVehicleE[2], GaragesEx[i][PosXTwo], GaragesEx[i][PosYTwo], GaragesEx[i][PosZTwo]) 
				&& GetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID]) == Teles[Teles[GaragesEx[i][ID_Tele]][PickupIDGo]][World] && DataCars[vehicleIndex][InteriorLast] == Teles[Teles[GaragesEx[i][ID_Tele]][PickupIDGo]][Interior] 
				|| IsPointFromPoint(RangeCheck, PosVehicleE[0], PosVehicleE[1], PosVehicleE[2], GaragesEx[i][PosXOne], GaragesEx[i][PosYOne], GaragesEx[i][PosZOne]) 
				&& GetVehicleVirtualWorld(DataCars[vehicleIndex][VehicleID]) == Teles[GaragesEx[i][ID_Tele]][World] && DataCars[vehicleIndex][InteriorLast] == Teles[GaragesEx[i][ID_Tele]][Interior])
			{
				return i;
			}
		}
		RangeCheck+=10.0;
	} while(RangeCheck != 100.0);
	return -1;
}
SaveTele(teleid, bool:update)
{
    new query[1024], Cache:cacheid, teleExist;
	format(query, sizeof(query), "SELECT ID from %s WHERE ID=%i;", DIR_TELES, teleid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(teleExist);
	cache_delete(cacheid);

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

		if(Teles[teleid][IsGarage])
		SaveGarageEx(Teles[teleid][Garage_ID]);
	}
		
	if (update)
	{
		new pickupid = Teles[teleid][PickupID];
		DestroyDynamicPickup(pickupid);
		PickupIndex[pickupid][Tipo] = PICKUP_TYPE_NINGUNO;
		PickupIndex[pickupid][Tipoid] = 0;
		
		Teles[teleid][PickupID] = CreateTeleDynamicPickup(1239, teleid, Teles[teleid][PosX], Teles[teleid][PosY], Teles[teleid][PosZ], Teles[teleid][World], Teles[teleid][Interior]);
		
		DestroyDynamic3DTextLabel(Teles[teleid][TextLabel]);
		SetText3DTele(teleid, Teles[teleid][LugarText]);
	}
	return 1;
}

LoadTeles()
{
	printf("[%s]: Cargando teles...", DIR_TELES);
	new query[80], Cache:cacheid, exist, count, gcount;
    for (new i=0; i!=MAX_TELES_COUNT; i++)
	{
		format(query, sizeof(query), "SELECT * FROM %s WHERE ID=%i", DIR_TELES, i);
		cacheid = mysql_query(dataBase, query);
		cache_get_row_count(exist);
		if(exist){
			cache_get_value_name_float(0, "PosX", Teles[i][PosX]);
			if(Teles[i][PosX]){
				cache_get_value_name_float(0, "PosY", Teles[i][PosY]);
				cache_get_value_name_float(0, "PosZ", Teles[i][PosZ]);
				cache_get_value_name_float(0, "PosZZ", Teles[i][PosZZ]);
				cache_get_value_name_int(0, "PickupIDGo", Teles[i][PickupIDGo]);
				cache_get_value_name_int(0, "World", Teles[i][World]);
				cache_get_value_name_int(0, "Interior", Teles[i][Interior]);
				cache_get_value_name_int(0, "Seguro", Teles[i][Lock]);
				cache_get_value_name_int(0, "Dueno", Teles[i][Dueno]);
				cache_get_value_name_int(0, "DuenoType", Teles[i][DuenoType]);
				cache_get_value_name_int(0, "IsBankTele", Teles[i][IsBankTele]);
				cache_get_value_name_int(0, "IsHotelTele", Teles[i][IsHotelTele]);
				cache_get_value_name_int(0, "IsNegocioTele", Teles[i][IsNegocioTele]);
				cache_get_value_name_int(0, "IsCasaTele", Teles[i][IsCasaTele]);
				cache_get_value_name_int(0, "IsGarage", Teles[i][IsGarage]);
				cache_get_value_name_int(0, "Garage_ID", Teles[i][Garage_ID]);
				cache_get_value_name_int(0, "PrecioEntrada", Teles[i][PrecioEntrada]);
				cache_get_value_name(0, "LugarText", Teles[i][LugarText]);

				Teles[i][PickupID] = CreateTeleDynamicPickup(1239, i, Teles[i][PosX], Teles[i][PosY], Teles[i][PosZ], Teles[i][World], Teles[i][Interior]);
				SetText3DTele(i, Teles[i][LugarText]);
				
				MAX_TELES++;
				count++;

				if(Teles[i][IsGarage]){
					if(LoadGarageEx(i, Teles[i][Garage_ID]))
					{
						gcount++;
					}
				}
			}
		}
		cache_delete(cacheid);
	}
	printf("[%s]: Se cargaron %i teles ( MAX: %i )", DIR_TELES, count, MAX_TELES_COUNT);
	printf("[%s]: Se cargaron %i garages ( MAX: %i )", DIR_GARAGES_EX, gcount, MAX_GARAGES_EX_COUNT);
	return count;
}

GetNextTeleID()
{
	for (new i=0; i!=MAX_TELES_COUNT; i++)
	{
	    if (Teles[i][PickupID] == 0) return i;
	}
	return -1;
}

CrearTele(playerid)
{
	new teleid = GetNextTeleID();
	if (teleid != -1)
	{
		new string[144], Float:PP[4], myVW, myInt;
		if (PlayersDataOnline[playerid][TeleCreate] == 0){
			PlayersDataOnline[playerid][TeleCreate]++;
			GetPlayerPos(playerid, PP[0], PP[1], PP[2]);
			GetPlayerFacingAngle(playerid, PP[3]);
			myVW = GetPlayerVirtualWorld(playerid);
			myInt = GetPlayerInterior(playerid);
			PlayersDataOnline[playerid][TeleCreatePos][0] = PP[0];
			PlayersDataOnline[playerid][TeleCreatePos][1] = PP[1];
			PlayersDataOnline[playerid][TeleCreatePos][2] = PP[2];
			PlayersDataOnline[playerid][TeleCreatePos][3] = PP[3];
			PlayersDataOnline[playerid][TeleCreateInfo][0] = myVW;
			PlayersDataOnline[playerid][TeleCreateInfo][1] = myInt;
			format(string, sizeof(string), "Estableciste la posicion \"Uno\" para el Tele. X: %.2f | Y: %.2f | Z: %.2f | RZ: %.2f | Mundo: %i | Interior: %i", PP[0], PP[1], PP[2], PP[3], myVW, myInt);
			SendAdviseMessage(playerid, string);
			SendAdviseMessage(playerid, "Use \"/Crear Tele\" nuevamente para establecer la posicion \"Dos\" del Tele.");
		}
		else if (PlayersDataOnline[playerid][TeleCreate] == 1){
			PlayersDataOnline[playerid][TeleCreate] = 0;
			GetPlayerPos(playerid, PP[0], PP[1], PP[2]);
			GetPlayerFacingAngle(playerid, PP[3]);
			myVW = GetPlayerVirtualWorld(playerid);
			myInt = GetPlayerInterior(playerid);

			Teles[teleid][PosX] = PlayersDataOnline[playerid][TeleCreatePos][0];
			Teles[teleid][PosY] = PlayersDataOnline[playerid][TeleCreatePos][1];
			Teles[teleid][PosZ] = PlayersDataOnline[playerid][TeleCreatePos][2];
			Teles[teleid][PosZZ] = PlayersDataOnline[playerid][TeleCreatePos][3];
			Teles[teleid][PickupIDGo] = teleid + 1;
			Teles[teleid][World] = PlayersDataOnline[playerid][TeleCreateInfo][0];
			Teles[teleid][Interior] = PlayersDataOnline[playerid][TeleCreateInfo][1];
			format(Teles[teleid][LugarText], 128, "Desconocido");
			Teles[teleid][PickupID] = CreateTeleDynamicPickup(1239, teleid, Teles[teleid][PosX], Teles[teleid][PosY], Teles[teleid][PosZ], Teles[teleid][World], Teles[teleid][Interior]);
			SetText3DTele(teleid, Teles[teleid][LugarText]);
			SaveTele(teleid, false);
			
			teleid++;
			Teles[teleid][PosX] = PP[0];
			Teles[teleid][PosY] = PP[1];
			Teles[teleid][PosZ] = PP[2];
			Teles[teleid][PosZZ] = PP[3];
			Teles[teleid][PickupIDGo] = teleid - 1;
			Teles[teleid][World] = myVW;
			Teles[teleid][Interior] = myInt;
			format(Teles[teleid][LugarText], 128, "Desconocido");
			Teles[teleid][PickupID] = CreateTeleDynamicPickup(1239, teleid, Teles[teleid][PosX], Teles[teleid][PosY], Teles[teleid][PosZ], Teles[teleid][World], Teles[teleid][Interior]);
			SetText3DTele(teleid, Teles[teleid][LugarText]);
			SaveTele(teleid, false);
			MAX_TELES += 2;

			format(string, sizeof(string), "Estableciste la posicion \"Dos\" para el Tele. X: %.2f | Y: %.2f | Z: %.2f | RZ: %.2f | Mundo: %i | Interior: %i", PP[0], PP[1], PP[2], PP[3], myVW, myInt);
			SendAdviseMessage(playerid, string);
		    format(string, sizeof(string), "Creaste un tele con las ID %i y %i", teleid-1, teleid);
		    SendInfoMessage(playerid, 3, "", string);
			return teleid-1;
		}
	}
	else {
		SendInfoMessage(playerid, 0, "", "Se alcanzo el maximo de teles!");
		PlayersDataOnline[playerid][TeleCreate] = 0;
	}
	return -1;
}

BorrarTele(teleid)
{	
	new teleidGo = Teles[teleid][PickupIDGo];
    new pickupid = Teles[teleidGo][PickupID];
    DestroyDynamicPickup(pickupid);
    PickupIndex[pickupid][Tipo] = PICKUP_TYPE_NINGUNO;
	PickupIndex[pickupid][Tipoid] = 0;
	
	DestroyDynamic3DTextLabel(Teles[teleidGo][TextLabel]);
	
	pickupid = Teles[teleid][PickupID];
    DestroyDynamicPickup(pickupid);
    PickupIndex[pickupid][Tipo] = PICKUP_TYPE_NINGUNO;
	PickupIndex[pickupid][Tipoid] = 0;
	
	DestroyDynamic3DTextLabel(Teles[teleid][TextLabel]);

	if(Teles[teleid][IsGarage]){
		new g = Teles[teleid][Garage_ID];
		GaragesEx[g][Creado] = 0;
		GaragesEx[g][ID_Tele] = -1;
		GaragesEx[g][PosXOne] = 0.0;
		GaragesEx[g][PosYOne] = 0.0;
		GaragesEx[g][PosZOne] = -3000.0;
		GaragesEx[g][PosZZOne] = 0.0;
		GaragesEx[g][PosXTwo] = 0.0;
		GaragesEx[g][PosYTwo] = 0.0;
		GaragesEx[g][PosZTwo] = -3000.0;
		GaragesEx[g][PosZZTwo] = 0.0;
		SaveGarageEx(g);
	}

	Teles[teleidGo][PosX] = 0;
	Teles[teleidGo][PosY] = 0;
	Teles[teleidGo][PosZ] = 0;
	Teles[teleidGo][PosZZ] = 0;
	Teles[teleidGo][PickupID] = 0;
	Teles[teleidGo][PickupIDGo] = 0;
	Teles[teleidGo][TextLabel] = INVALID_3DTEXT_ID;
	Teles[teleidGo][World] = 0;
	Teles[teleidGo][Interior] = 0;
	Teles[teleidGo][Lock] = 0;
	Teles[teleidGo][Dueno] = 0;
	Teles[teleidGo][DuenoType] = 0;
	Teles[teleidGo][IsBankTele] = 0;
	Teles[teleidGo][IsHotelTele] = 0;
	Teles[teleidGo][IsNegocioTele] = 0;
	Teles[teleidGo][IsCasaTele] = 0;
	Teles[teleidGo][IsGarage] = 0;
	Teles[teleidGo][Garage_ID] = -1;
	Teles[teleidGo][PrecioEntrada] = 0;
	format(Teles[teleidGo][LugarText], 2, "");
	SaveTele(teleidGo, false);
	
 	Teles[teleid][PosX] = 0;
	Teles[teleid][PosY] = 0;
	Teles[teleid][PosZ] = 0;
	Teles[teleid][PosZZ] = 0;
	Teles[teleid][PickupID] = 0;
	Teles[teleid][PickupIDGo] = 0;
	Teles[teleid][TextLabel] = INVALID_3DTEXT_ID;
	Teles[teleid][World] = 0;
	Teles[teleid][Interior] = 0;
	Teles[teleid][Lock] = 0;
	Teles[teleid][Dueno] = 0;
	Teles[teleid][DuenoType] = 0;
	Teles[teleid][IsBankTele] = 0;
	Teles[teleid][IsHotelTele] = 0;
	Teles[teleid][IsNegocioTele] = 0;
	Teles[teleid][IsCasaTele] = 0;
	Teles[teleid][IsGarage] = 0;
	Teles[teleid][Garage_ID] = -1;
	Teles[teleid][PrecioEntrada] = 0;
	format(Teles[teleid][LugarText], 2, "");
	SaveTele(teleid, false);
	
	MAX_TELES -= 2;
	return 1;
}

CreateTeleDynamicPickup(modelid, teleid, Float:x, Float:y, Float:z, worldid, interiorid)
{
    new pickupid = CreateDynamicPickup(modelid, 1, x, y, z, worldid, interiorid);
	PickupIndex[pickupid][Tipo] = PICKUP_TYPE_TELE;
	PickupIndex[pickupid][Tipoid] = teleid;
    return pickupid;
}

SetText3DTele(teleid, const text[])
{
	new TextLabelText[128];

	format(TextLabelText, sizeof(TextLabelText), "Lugar: {"COLOR_CREMA"}%s", ConvertToRGBColor(text));

	Teles[teleid][TextLabel] = CreateDynamic3DTextLabel(TextLabelText, 0x00A5FFFF,
		Teles[teleid][PosX], Teles[teleid][PosY], Teles[teleid][PosZ],
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, Teles[teleid][World], Teles[teleid][Interior]);
}

bool:PlayerHaveTeleKeys(playerid, teleid)
{
	new 
		tipo = Teles[teleid][DuenoType],
		tipoid = Teles[teleid][Dueno];
	if (tipo == 0)
	{
	    if (tipoid == CIVIL || PlayersData[playerid][Faccion] == tipoid)
		return true;
	}
	else if (tipo == 1)
	{
	    if (IsMyBizz(playerid, tipoid, false))
	    return true;
	}
	else if (tipo == 2)
	{
	    if ( PlayersData[playerid][House] == tipoid ||
			 PlayersData[playerid][Alquiler] == tipoid ||
			 IsPlayerInHouseFriend(playerid, tipoid) != -1 )
	    return true;
	}
	return false;
}

SaveGarageEx(g)
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

LoadGarageEx(teleid, g)
{
	new teleidGo = Teles[teleid][PickupIDGo];
	new loaded;
	if(teleid < teleidGo){
		new query[1024], Cache:cacheid, garageExist;

		format(query, sizeof(query), "SELECT * FROM %s WHERE ID=%i;", DIR_GARAGES_EX, g);
		cacheid = mysql_query(dataBase, query);
		cache_get_row_count(garageExist);
		if(!garageExist){
			Teles[teleid][IsGarage] = 0;
			Teles[teleid][Garage_ID] = -1;
			format(Teles[teleid][LugarText], 20, "Desconocido");
			SaveTele(teleid, true);
			Teles[teleidGo][IsGarage] = 0;
			Teles[teleidGo][Garage_ID] = -1;
			format(Teles[teleidGo][LugarText], 20, "Desconocido");
			SaveTele(teleidGo, true);
			printf("[%s]: Error el cargar garage %i para el tele_id %i. Eliminando garage...", DIR_GARAGES_EX, g, teleid);
			printf("[%s]: El tele %i y %i ya no son un garage. Renombrar: \"Desconocido\"... Ok.", DIR_TELES, teleid, teleidGo);
		}
		else{
			cache_get_value_name_int(0, "Creado", GaragesEx[g][Creado]);//esto sobra pero bueno
			cache_get_value_name_int(0, "ID_Tele", GaragesEx[g][ID_Tele]);
			cache_get_value_name_float(0, "PosXOne", GaragesEx[g][PosXOne]);
			cache_get_value_name_float(0, "PosYOne", GaragesEx[g][PosYOne]);
			cache_get_value_name_float(0, "PosZOne", GaragesEx[g][PosZOne]);
			cache_get_value_name_float(0, "PosZZOne", GaragesEx[g][PosZZOne]);
			cache_get_value_name_float(0, "PosXTwo", GaragesEx[g][PosXTwo]);
			cache_get_value_name_float(0, "PosYTwo", GaragesEx[g][PosYTwo]);
			cache_get_value_name_float(0, "PosZTwo", GaragesEx[g][PosZTwo]);
			cache_get_value_name_float(0, "PosZZTwo", GaragesEx[g][PosZZTwo]);
			loaded = true;
		}
		cache_delete(cacheid);
	}
	return loaded;
}

GetNextGarageID(){
	for(new g; g!=MAX_GARAGES_EX_COUNT; g++){
		if(!GaragesEx[g][Creado]) return g;
	}
	return -1;
}

CrearGarage(playerid, teleID){
	if(Teles[teleID][IsGarage]) return SendInfoMessage(playerid, 0, "", "Este tele ya es un garage!");
	new garageID = GetNextGarageID();
	if(garageID != -1){
		new string[128],
			myVW = GetPlayerVirtualWorld(playerid),
			myInt = GetPlayerInterior(playerid),
			Float:PP[4];
		GetPlayerPos(playerid, PP[0], PP[1], PP[2]); GetPlayerFacingAngle(playerid, PP[3]);
		if(PlayersDataOnline[playerid][GarageCreate] == 0)
		{
			if(Teles[teleID][Interior] != 0 || Teles[teleID][World] != 0)//Si el Tele ID q puse no esta en un exterior
			{
				if(Teles[Teles[teleID][PickupIDGo]][Interior] != 0 && Teles[Teles[teleID][PickupIDGo]][World] != 0)//Revisa si el tele vinculado lo esta
				{
					SendInfoMessage(playerid, 0, "", "Este tele no lleva a ningun exterior!");//Como no lo esta tira error
					return false;
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 10.0, Teles[teleID][PosX], Teles[teleID][PosY], Teles[teleID][PosZ]) && 
				myVW == Teles[teleID][World] && 
				myInt == Teles[teleID][Interior])
			{
					PlayersDataOnline[playerid][GarageCreate]++;
					PlayersDataOnline[playerid][GarageCreatePos][0] = PP[0];
					PlayersDataOnline[playerid][GarageCreatePos][1] = PP[1];
					PlayersDataOnline[playerid][GarageCreatePos][2] = PP[2];
					PlayersDataOnline[playerid][GarageCreatePos][3] = PP[3];

					if(teleID < Teles[teleID][PickupIDGo])
					format(string, sizeof(string), "Estableciste la posicion \"Uno\" del garage para el tele %i. X: %.2f | Y: %.2f | Z: %.2f | RZ: %.2f", teleID, PP[0], PP[1], PP[2], PP[3]);
					else
					format(string, sizeof(string), "Estableciste la posicion \"Dos\" del garage para el tele %i. X: %.2f | Y: %.2f | Z: %.2f | RZ: %.2f", teleID, PP[0], PP[1], PP[2], PP[3]);
					SendAdviseMessage(playerid, string);
					format(string, sizeof(string), "Entre o salga del Tele y use \"/Crear Garage %i\" nuevamente para establecer la posicion", teleID);
					SendAdviseMessage(playerid, string);
			}
			else SendInfoMessage(playerid, 0, "", "Debe de estar cerca del tele para usar este comando!");
		}
		else if(PlayersDataOnline[playerid][GarageCreate] == 1)
		{
			if(IsPlayerInRangeOfPoint(playerid, 10.0, Teles[Teles[teleID][PickupIDGo]][PosX], Teles[Teles[teleID][PickupIDGo]][PosY], Teles[Teles[teleID][PickupIDGo]][PosZ]) && 
				myVW == Teles[Teles[teleID][PickupIDGo]][World] && 
				myInt == Teles[Teles[teleID][PickupIDGo]][Interior])
			{
					PlayersDataOnline[playerid][GarageCreate] = 0;
					if(teleID < Teles[teleID][PickupIDGo]){
						GaragesEx[garageID][ID_Tele] = teleID;
						GaragesEx[garageID][PosXOne] = PlayersDataOnline[playerid][GarageCreatePos][0];
						GaragesEx[garageID][PosYOne] = PlayersDataOnline[playerid][GarageCreatePos][1];
						GaragesEx[garageID][PosZOne] = PlayersDataOnline[playerid][GarageCreatePos][2];
						GaragesEx[garageID][PosZZOne] = PlayersDataOnline[playerid][GarageCreatePos][3];
						GaragesEx[garageID][PosXTwo] = PP[0];
						GaragesEx[garageID][PosYTwo] = PP[1];
						GaragesEx[garageID][PosZTwo] = PP[2];
						GaragesEx[garageID][PosZZTwo] = PP[3];
						format(string, sizeof(string), "Estableciste la posicion \"Dos\" del garage para el tele %i. X: %.2f | Y: %.2f | Z: %.2f | RZ: %.2f", Teles[teleID][PickupIDGo], PP[0], PP[1], PP[2], PP[3]);
					}
					else{
						GaragesEx[garageID][ID_Tele] = Teles[teleID][PickupIDGo];
						GaragesEx[garageID][PosXOne] = PP[0];
						GaragesEx[garageID][PosYOne] = PP[1];
						GaragesEx[garageID][PosZOne] = PP[2];
						GaragesEx[garageID][PosZZOne] = PP[3];
						GaragesEx[garageID][PosXTwo] = PlayersDataOnline[playerid][GarageCreatePos][0];
						GaragesEx[garageID][PosYTwo] = PlayersDataOnline[playerid][GarageCreatePos][1];
						GaragesEx[garageID][PosZTwo] = PlayersDataOnline[playerid][GarageCreatePos][2];
						GaragesEx[garageID][PosZZTwo] = PlayersDataOnline[playerid][GarageCreatePos][3];
						format(string, sizeof(string), "Estableciste la posicion \"Uno\" del garage para el tele %i. X: %.2f | Y: %.2f | Z: %.2f | RZ: %.2f", Teles[teleID][PickupIDGo], PP[0], PP[1], PP[2], PP[3]);
					}
					GaragesEx[garageID][Creado] = true;
					Teles[teleID][IsGarage] = true;
					Teles[teleID][Garage_ID] = garageID;
					///////////////
					Teles[Teles[teleID][PickupIDGo]][IsGarage] = true;
					Teles[Teles[teleID][PickupIDGo]][Garage_ID] = garageID;

					SendAdviseMessage(playerid, string);
					format(string, sizeof(string), "Creaste un garage con la ID %i para el tele_id %i vinculado al tele_id %i", garageID, teleID, Teles[teleID][PickupIDGo]);
					SendInfoMessage(playerid, 3, "", string);
			}
			else {
				format(string, sizeof(string), "Debe de estar cerca del tele %i que esta vinculado al tele %i para crear este garage!", Teles[teleID][PickupIDGo], teleID);
				SendInfoMessage(playerid, 0, "", string);
			}
		}
	}
	else{
		SendInfoMessage(playerid, 0, "", "Se alcanzo el maximo de garages!");
		PlayersDataOnline[playerid][GarageCreate] = 0;
	}
	return true;
}

ShowDialogEditTele(playerid, teleid)
{
	PlayersDataOnline[playerid][SaveAfterAgenda][0] = teleid;
	new caption[64], info[500],
		teleidGo = Teles[teleid][PickupIDGo];
	if(teleid < teleidGo)
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele {"COLOR_VERDE"}%i {"COLOR_AZUL"}- %i", teleid, teleidGo);
	else
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele %i - {"COLOR_VERDE"}%i", teleidGo, teleid);

	format(info, sizeof(info), "Nombre {"COLOR_VERDE"}%i\t{"COLOR_VERDE"}Editar\n", teleid);
	format(info, sizeof(info), "%sNombre {"COLOR_AZUL"}%i\t{"COLOR_VERDE"}Editar\n", info, teleidGo);
	format(info, sizeof(info), "%sUbicaciones\t{"COLOR_VERDE"}Ver/Editar\n", info);
	format(info, sizeof(info), "%sLlaves\t{"COLOR_VERDE"}Ver/Editar\n", info);
	format(info, sizeof(info), "%s{"COLOR_ROJO"}Eliminar\t\n", info);
	ShowPlayerDialogEx(playerid, 175, DIALOG_STYLE_TABLIST, caption, info, "Seleccionar", "Cerrar");
}

ShowEditTeleNombre(playerid, teleid)
{
	PlayersDataOnline[playerid][SaveAfterAgenda][1] = teleid;
	new caption[64], info[500];
	if(teleid == PlayersDataOnline[playerid][SaveAfterAgenda][0])
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele {"COLOR_VERDE"}%i", teleid);
	else
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele %i", teleid);

	format(info, sizeof(info), "{"COLOR_CREMA"}Nombre Actual:\n{"COLOR_CREMA"}\"%s\"", Teles[teleid][LugarText]);
	ShowPlayerDialogEx(playerid, 176, DIALOG_STYLE_INPUT, caption, info, "Editar", "Cancelar");
}

ShowTeleUbicaciones(playerid, teleid)
{
	new caption[64], info[500],
		teleidGo = Teles[teleid][PickupIDGo];
	if(teleid < teleidGo)
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele {"COLOR_VERDE"}%i {"COLOR_AZUL"}- %i -> Ubicaciones", teleid, teleidGo);
	else
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele %i - {"COLOR_VERDE"}%i  -> Ubicaciones", teleidGo, teleid);

	format(info, sizeof(info), "{"COLOR_CREMA"}Ajustes\tOpciones\n");
	if(Teles[teleid][IsGarage])
	format(info, sizeof(info), "%sGarage\t{"COLOR_VERDE"}Editar/Eliminar\n", info);
	else
	format(info, sizeof(info), "%sGarage\tNo\n", info);
	format(info, sizeof(info), "%s \t \n", info);
	format(info, sizeof(info), "%sUbicacion {"COLOR_VERDE"}%i:\t \n", info, teleid);
	format(info, sizeof(info), "%sPosX: %.2f\t{"COLOR_VERDE"}Editar\n", info, Teles[teleid][PosX]);
	format(info, sizeof(info), "%sPosY: %.2f\t{"COLOR_VERDE"}Editar\n", info, Teles[teleid][PosY]);
	format(info, sizeof(info), "%sPosZ: %.2f\t{"COLOR_VERDE"}Editar\n", info, Teles[teleid][PosZ]);
	format(info, sizeof(info), "%sPosRZ: %.2f\t{"COLOR_VERDE"}Editar\n", info, Teles[teleid][PosZZ]);
	format(info, sizeof(info), "%sMundo: %i\t{"COLOR_VERDE"}Editar\n", info, Teles[teleid][World]);
	format(info, sizeof(info), "%sInterior: %i\t{"COLOR_VERDE"}Editar\n", info, Teles[teleid][Interior]);
	format(info, sizeof(info), "%sMi Ubicacion\t{"COLOR_VERDE"}Mover Aqui\n", info);
	format(info, sizeof(info), "%s \t \n", info);
	format(info, sizeof(info), "%sUbicacion {"COLOR_AZUL"}%i:\t \n", info, teleidGo);
	format(info, sizeof(info), "%sPosX: %.2f\t{"COLOR_VERDE"}Editar\n", info, Teles[teleidGo][PosX]);
	format(info, sizeof(info), "%sPosY: %.2f\t{"COLOR_VERDE"}Editar\n", info, Teles[teleidGo][PosY]);
	format(info, sizeof(info), "%sPosZ: %.2f\t{"COLOR_VERDE"}Editar\n", info, Teles[teleidGo][PosZ]);
	format(info, sizeof(info), "%sPosRZ: %.2f\t{"COLOR_VERDE"}Editar\n", info, Teles[teleidGo][PosZZ]);
	format(info, sizeof(info), "%sMundo: %i\t{"COLOR_VERDE"}Editar\n", info, Teles[teleidGo][World]);
	format(info, sizeof(info), "%sInterior: %i\t{"COLOR_VERDE"}Editar\n", info, Teles[teleidGo][Interior]);
	format(info, sizeof(info), "%sMi Ubicacion\t{"COLOR_VERDE"}Mover Aqui\n", info);
	ShowPlayerDialogEx(playerid, 177, DIALOG_STYLE_TABLIST_HEADERS, caption, info, "Seleccionar", "Volver");
}

ShowTeleGarage(playerid, teleid)
{
	new caption[64], info[500],
		teleidGo = Teles[teleid][PickupIDGo];
	if(teleid < teleidGo)
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele {"COLOR_VERDE"}%i {"COLOR_AZUL"}- %i -> Garage", teleid, teleidGo);
	else
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele %i - {"COLOR_VERDE"}%i -> Garage", teleidGo, teleid);

	format(info, sizeof(info), "{"COLOR_CREMA"}Ajustes\tOpciones\n");
	format(info, sizeof(info), "%sUbicacion 1:\t \n", info);
	format(info, sizeof(info), "%sPosX: %.2f\t{"COLOR_VERDE"}Editar\n", info, GaragesEx[Teles[teleid][Garage_ID]][PosXOne]);
	format(info, sizeof(info), "%sPosY: %.2f\t{"COLOR_VERDE"}Editar\n", info, GaragesEx[Teles[teleid][Garage_ID]][PosYOne]);
	format(info, sizeof(info), "%sPosZ: %.2f\t{"COLOR_VERDE"}Editar\n", info, GaragesEx[Teles[teleid][Garage_ID]][PosZOne]);
	format(info, sizeof(info), "%sPosRZ: %.2f\t{"COLOR_VERDE"}Editar\n", info, GaragesEx[Teles[teleid][Garage_ID]][PosZZOne]);
	format(info, sizeof(info), "%sMi Ubicacion\t{"COLOR_VERDE"}Mover Aqui\n", info);
	format(info, sizeof(info), "%s \t \n", info);
	format(info, sizeof(info), "%sUbicacion 2:\t \n", info);
	format(info, sizeof(info), "%sPosX: %.2f\t{"COLOR_VERDE"}Editar\n", info, GaragesEx[Teles[teleid][Garage_ID]][PosXTwo]);
	format(info, sizeof(info), "%sPosY: %.2f\t{"COLOR_VERDE"}Editar\n", info, GaragesEx[Teles[teleid][Garage_ID]][PosYTwo]);
	format(info, sizeof(info), "%sPosZ: %.2f\t{"COLOR_VERDE"}Editar\n", info, GaragesEx[Teles[teleid][Garage_ID]][PosZTwo]);
	format(info, sizeof(info), "%sPosRZ: %.2f\t{"COLOR_VERDE"}Editar\n", info, GaragesEx[Teles[teleid][Garage_ID]][PosZZTwo]);
	format(info, sizeof(info), "%sMi Ubicacion\t{"COLOR_VERDE"}Mover Aqui\n", info);
	format(info, sizeof(info), "%s \t \n", info);
	format(info, sizeof(info), "%s{"COLOR_ROJO"}Eliminar\t \n", info);
	ShowPlayerDialogEx(playerid, 178, DIALOG_STYLE_TABLIST_HEADERS, caption, info, "Editar", "Volver");
}

ShowEditTeleGarage(playerid, teleid, OneOrTwo, option)
{
	PlayersDataOnline[playerid][SaveAfterAgenda][1] = OneOrTwo;
	PlayersDataOnline[playerid][SaveAfterAgenda][2] = option;
	new caption[64], info[500];
	if(teleid == PlayersDataOnline[playerid][SaveAfterAgenda][0])
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele {"COLOR_VERDE"}%i{"COLOR_AZUL"}", teleid);
	else
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele %i", teleid);
	if(OneOrTwo == 1)
	strcat(caption, " -> Garage 1");
	else
	strcat(caption, " -> Garage 2");
	new g = Teles[teleid][Garage_ID], Float:PosG[4];
	PosG[0] = (OneOrTwo == 1) ? (GaragesEx[g][PosXOne]) : (GaragesEx[g][PosXTwo]);
	PosG[1] = (OneOrTwo == 1) ? (GaragesEx[g][PosYOne]) : (GaragesEx[g][PosYTwo]);
	PosG[2] = (OneOrTwo == 1) ? (GaragesEx[g][PosZOne]) : (GaragesEx[g][PosZTwo]);
	PosG[3] = (OneOrTwo == 1) ? (GaragesEx[g][PosZZOne]) : (GaragesEx[g][PosZZTwo]);

	if(option == 1){
		strcat(caption, " -> Eje X");
		format(info, sizeof(info), "{"COLOR_CREMA"}Coordenadas actuales del Eje X: %.2f\nIngrese las nuevas coordenadas:", PosG[0]);
	}
	else if(option == 2){
		strcat(caption, " -> Eje Y");
		format(info, sizeof(info), "{"COLOR_CREMA"}Coordenadas actuales del Eje Y: %.2f\nIngrese las nuevas coordenadas:", PosG[1]);
	}
	else if(option == 3){
		strcat(caption, " -> Eje Z");
		format(info, sizeof(info), "{"COLOR_CREMA"}Coordenadas actuales del Eje Z: %.2f\nIngrese las nuevas coordenadas:", PosG[2]);
	}
	else if(option == 4){
		strcat(caption, " -> Rotacion");
		format(info, sizeof(info), "{"COLOR_CREMA"}Rotacion actual: %.2f\nIngrese la nueva rotacion:", PosG[3]);
	}
	ShowPlayerDialogEx(playerid, 179, DIALOG_STYLE_INPUT, caption, info, "Editar", "Cancelar");
}

IsValidGarageEdit(teleid, g, OneOrTwo, option, Float:editOption)
{
	new X = (teleid < Teles[teleid][PickupIDGo]) ? (teleid) : (Teles[teleid][PickupIDGo]);
	if(OneOrTwo == 2) X = Teles[teleid][PickupIDGo];
	new Float:GP[3];
	GP[0] = (OneOrTwo == 1) ? (GaragesEx[g][PosXOne]) : (GaragesEx[g][PosXTwo]);
	GP[1] = (OneOrTwo == 1) ? (GaragesEx[g][PosYOne]) : (GaragesEx[g][PosYTwo]);
	GP[2] = (OneOrTwo == 1) ? (GaragesEx[g][PosZOne]) : (GaragesEx[g][PosZTwo]);
	if(option == 1){
		if(IsPointFromPoint(10.0, Teles[X][PosX], Teles[X][PosY], Teles[X][PosZ], editOption, GP[1], GP[2])) return true;
	}
	else if(option == 2){
		if(IsPointFromPoint(10.0, Teles[X][PosX], Teles[X][PosY], Teles[X][PosZ], GP[0], editOption, GP[2])) return true;
	}
	else if(option == 3){
		if(IsPointFromPoint(10.0, Teles[X][PosX], Teles[X][PosY], Teles[X][PosZ], GP[0], GP[1], editOption)) return true;
	}
	else if(option == 4) return true;
	return false;
}

ShowEditTeleUbicaciones(playerid, teleid, option)
{
	PlayersDataOnline[playerid][SaveAfterAgenda][1] = teleid;
	PlayersDataOnline[playerid][SaveAfterAgenda][2] = option;
	new caption[64], info[500];
	if(teleid == PlayersDataOnline[playerid][SaveAfterAgenda][0])
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele {"COLOR_VERDE"}%i{"COLOR_AZUL"}", teleid);
	else
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele %i", teleid);

	if(option == 1){
		strcat(caption, " -> Eje X");
		format(info, sizeof(info), "{"COLOR_CREMA"}Coordenadas actuales del Eje X: %.2f\nIngrese las nuevas coordenadas:", Teles[teleid][PosX]);
	}
	else if(option == 2){
		strcat(caption, " -> Eje Y");
		format(info, sizeof(info), "{"COLOR_CREMA"}Coordenadas actuales del Eje Y: %.2f\nIngrese las nuevas coordenadas:", Teles[teleid][PosY]);
	}
	else if(option == 3){
		strcat(caption, " -> Eje Z");
		format(info, sizeof(info), "{"COLOR_CREMA"}Coordenadas actuales del Eje Z: %.2f\nIngrese las nuevas coordenadas:", Teles[teleid][PosZ]);
	}
	else if(option == 4){
		strcat(caption, " -> Rotacion");
		format(info, sizeof(info), "{"COLOR_CREMA"}Rotacion actual: %.2f\nIngrese la nueva rotacion:", Teles[teleid][PosZZ]);
	}
	else if(option == 5){
		strcat(caption, " -> Mundo");
		format(info, sizeof(info), "{"COLOR_CREMA"}Mundo actual: %i\nIngrese el nuevo Mundo_ID:", Teles[teleid][World]);
	}
	else if(option == 6){
		strcat(caption, " -> Interior");
		format(info, sizeof(info), "{"COLOR_CREMA"}Interior actual: %i\nIngrese el nuevo Interior_ID:", Teles[teleid][Interior]);
	}
	ShowPlayerDialogEx(playerid, 180, DIALOG_STYLE_INPUT, caption, info, "Editar", "Cancelar");
}

ShowTeleKeys(playerid, teleid)
{
	new caption[64], info[500],
		teleidGo = Teles[teleid][PickupIDGo];
	if(teleid < teleidGo)
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele {"COLOR_VERDE"}%i {"COLOR_AZUL"}- %i", teleid, teleidGo);
	else
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele %i - {"COLOR_VERDE"}%i{"COLOR_AZUL"}", teleidGo, teleid);
	strcat(caption, " -> Llaves");

	format(info, sizeof(info), "{"COLOR_CREMA"}Opcion\t{"COLOR_CREMA"}Valor\n");

	format(info, sizeof(info), "%sTipo de Propiedad:\t%s\n", info, TelesDuenoType[Teles[teleid][DuenoType]]);
	if(Teles[teleid][DuenoType] == 0)
	format(info, sizeof(info), "%sID de Faccion:\t%i (%s)\n", info, Teles[teleid][Dueno], FaccionData[Teles[teleid][Dueno]][NameFaccion]);
	else
	format(info, sizeof(info), "%sID de Propiedad:\t%i\n", info, Teles[teleid][Dueno]);
	ShowPlayerDialogEx(playerid, 181, DIALOG_STYLE_TABLIST_HEADERS, caption, info, "Editar", "Volver");
}

ShowEditTeleKeys(playerid, teleid)
{
	new caption[64], info[500],
		teleidGo = Teles[teleid][PickupIDGo];
	if(teleid < teleidGo)
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele {"COLOR_VERDE"}%i {"COLOR_AZUL"}- %i", teleid, teleidGo);
	else
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Tele %i - {"COLOR_VERDE"}%i{"COLOR_AZUL"}", teleidGo, teleid);
	format(caption, sizeof(caption), "%s -> Llaves -> ID_%i", caption, TelesDuenoType[Teles[teleid][DuenoType]]);

	format(info, sizeof(info), "{"COLOR_CREMA"}ID Actual: %i, Ingrese la nueva ID:", Teles[teleid][Dueno]);
	ShowPlayerDialogEx(playerid, 182, DIALOG_STYLE_INPUT, caption, info, "Aceptar", "Cancelar");
}

IsValidGarageEx(g, teleid, teleidGo)
{
	//Por si algun mochi movio el tele y quedo el garage lejos de la puerta ( radio >= 10.0 ) hacemos un fast check
	if(
		IsPointFromPoint(10.0, GaragesEx[g][PosXOne], GaragesEx[g][PosYOne], GaragesEx[g][PosZOne], Teles[teleid][PosX], Teles[teleid][PosY], Teles[teleid][PosZ]) &&
		IsPointFromPoint(10.0, GaragesEx[g][PosXTwo], GaragesEx[g][PosYTwo], GaragesEx[g][PosZTwo], Teles[teleidGo][PosX], Teles[teleidGo][PosY], Teles[teleidGo][PosZ]))
	{
		return true;	
	}
	return false;
}