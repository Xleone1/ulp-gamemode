// helpers puros de teles sin side effects

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

GetNextTeleID()
{
	for (new i=0; i!=MAX_TELES_COUNT; i++)
	{
	    if (Teles[i][PickupID] == 0) return i;
	}
	return -1;
}

GetNextGarageID(){
	for(new g; g!=MAX_GARAGES_EX_COUNT; g++){
		if(!GaragesEx[g][Creado]) return g;
	}
	return -1;
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

