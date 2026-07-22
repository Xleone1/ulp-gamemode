// datos de pickups de trabajos

LoadJobPickupsPesca()
{
	// PESCA
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = 612.8910;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = -2995.3770;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 7.2706;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], WORLD_NORMAL, 0);
    Jobs[PESCA][pickupidGet] = PickupInfo[MAX_PICKUP_INFO][PickupId];
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "Si desea ser pescador\nUse {"COLOR_ROJO"}/{"COLOR_VERDE"}Trabajar", WORLD_NORMAL, 0);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = -1503.5508;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = 1380.0824;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 3.4375;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], WORLD_NORMAL, 0);
    JobsData[PESCA_PickupidVender] = MAX_PICKUP_INFO;
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "Use {"COLOR_ROJO"}/{"COLOR_VERDE"}Vender Peces", WORLD_NORMAL, 0);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = 565.2724;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = -3035.1536;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 3.0419;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], WORLD_NORMAL, 0);
    JobsData[PESCA_PickupidPescar] = MAX_PICKUP_INFO;
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "Zona de pesca\nUse {"COLOR_ROJO"}/{"COLOR_VERDE"}Pescar", WORLD_NORMAL, 0);

	////////////////////////////////////////////////
	MAX_PICKUP_INFO++;
}

LoadJobPickupsVendedorMovil()
{
    PickupInfo[MAX_PICKUP_INFO][PosInfoX] = -1961.2986;
    PickupInfo[MAX_PICKUP_INFO][PosInfoY] = 438.8855;
    PickupInfo[MAX_PICKUP_INFO][PosInfoZ] = 35.1719;
    PickupInfo[MAX_PICKUP_INFO][PickupId] = CreateInfoPickup(1239, MAX_PICKUP_INFO, PickupInfo[MAX_PICKUP_INFO][PosInfoX], PickupInfo[MAX_PICKUP_INFO][PosInfoY], PickupInfo[MAX_PICKUP_INFO][PosInfoZ], WORLD_NORMAL, 0);
    Jobs[VENDEDOR_MOVIL][pickupidGet] = PickupInfo[MAX_PICKUP_INFO][PickupId];
	CreateTextLabelPickupInfo(MAX_PICKUP_INFO, "Conviertase en un vendedor de moviles!\nUse {"COLOR_ROJO"}/{"COLOR_VERDE"}Trabajar", WORLD_NORMAL, 0);
}
