LoadNonJobPickups()
{
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = 2452.4606933594;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = 1845.6982421875;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 16.32413482666;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], -1, 3);
    PickupidAmbulance = MAX_PICKUP_INFO;
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "Salir de la ambulancia", -1, 3);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = 2643.2592773438;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = 1887.0278320313;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 18.815624237061;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], -1, 3);
    PickupidFurgoCNN = MAX_PICKUP_INFO;
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "Salir de la furgona CNN", -1, 3);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = 1755.9699707031;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = -2670.3698730469;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 13.637499809265;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], -1, 3);
    PickupidPoliceFurgo = MAX_PICKUP_INFO;
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "Salir del camion Swat", -1, 3);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = 2394.7495117188;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = 1159.5728759766;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 34.606250762939;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], -1, 3);
    PickupExitVagones[0] = MAX_PICKUP_INFO;
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "Salida del Vagon 1", -1, 3);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = 2407.3837890625;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = 1136.6993408203;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 34.267810821533;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], -1, 3);
    PickupExitVagones[1] = MAX_PICKUP_INFO;
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "Salida del Vagon 2", -1, 3);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = 2393.4990234375;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = 1113.5131835938;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 34.726249694824;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], -1, 3);
    PickupExitVagones[2] = MAX_PICKUP_INFO;
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "Salida del Vagon 3", -1, 3);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = 2365.8909;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = 1559.6465;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 27.9562;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], WORLD_DEFAULT_INTERIOR, 11);
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "Camaras Los Santos\nUse {"COLOR_ROJO"}/{"COLOR_VERDE"}Camaras", WORLD_DEFAULT_INTERIOR, 11);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = 1961.4952;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = 973.3851;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 21.8714;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], WORLD_DEFAULT_INTERIOR, 7);
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "Camaras San Fierro\nUse {"COLOR_ROJO"}/{"COLOR_VERDE"}Camaras", WORLD_DEFAULT_INTERIOR, 7);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = 1316.2865;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = 1385.0859;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 10.8797;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], WORLD_DEFAULT_INTERIOR, 2);
    SuperMercadosPickupid[0] = MAX_PICKUP_INFO;
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "SuperMercados {"COLOR_AMARILLO"}San {"COLOR_AZUL"}Fierro\n{"COLOR_AZUL"}Use {"COLOR_ROJO"}/{"COLOR_VERDE"}SuperMercado", WORLD_DEFAULT_INTERIOR, 2);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = 1555.6737;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = -2558.0864;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 13.5628;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], WORLD_DEFAULT_INTERIOR, 16);
    SuperMercadosPickupid[1] = MAX_PICKUP_INFO;
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "SuperMercados {"COLOR_AMARILLO"}Los {"COLOR_AZUL"}Santos\n{"COLOR_AZUL"}Use {"COLOR_ROJO"}/{"COLOR_VERDE"}SuperMercado", WORLD_DEFAULT_INTERIOR, 16);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
}

CreateTextLabelPickupInfo(pickupidinfo, const info[], worldid, interiorid)
{
	new string[300];
	format(string, sizeof(string), "Info: {"COLOR_CREMA"}%s", info);
    CreateDynamic3DTextLabel(string, 0x00A5FFFF, PickupInfo[pickupidinfo][PosInfoX], PickupInfo[pickupidinfo][PosInfoY], PickupInfo[pickupidinfo][PosInfoZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true,
    worldid, interiorid);
}

UpdateLockDoorForPlayer(pickupid, lock, pickup2)
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
	    if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 )
	    {
	        if ( PlayersDataOnline[i][InPickup] == pickupid )
	        {
				PlayersDataOnline[i][MyPickupLock] = lock;
			}
			else if ( PlayersDataOnline[i][InPickup] == pickup2 )
			{
				PlayersDataOnline[i][MyPickupLock] = lock;
			}

		}
	}
}
CreateInfoPickup(modelid, pickupinfoid, Float:x, Float:y, Float:z, worldid, interiorid)
{
    new pickupid = CreateDynamicPickup(modelid, 1, x, y, z, worldid, interiorid);
    PickupIndex[pickupid][Tipo] = PICKUP_TYPE_INFO;
    PickupIndex[pickupid][Tipoid] = pickupinfoid;
	return pickupid;
}

ClearPlayerPickups(playerid)
{
    PlayersDataOnline[playerid][InPickup] = 0;
	PlayersDataOnline[playerid][InPickupFaccion] = 0;
	PlayersDataOnline[playerid][InPickupTele] = -1;
	PlayersDataOnline[playerid][InPickupNegocio] = 0;
	PlayersDataOnline[playerid][InPickupCasa] = 0;
}

IsPlayerInPickup(playerid)
{
    if (IsPlayerInRangeOfPoint(playerid, 2.0, PlayersDataOnline[playerid][MyPickupX_Now], PlayersDataOnline[playerid][MyPickupY_Now], PlayersDataOnline[playerid][MyPickupZ_Now]))
    {
        return 1;
    }
    else
    {
		ClearPlayerPickups(playerid);
		return 0;
	}
}
