// logica core del velocimetro digital
// usa PlayerTextDraw para eficiencia

#define SPEEDO_BAR_LEFT   505.0
#define SPEEDO_BAR_RIGHT  615.0
#define SPEEDO_GAS_Y      384.0
#define SPEEDO_OIL_Y      412.0
#define SPEEDO_BAR_H      0.5

forward UpdateGlobalSpeedo();
public UpdateGlobalSpeedo()
{
	for (new i = 0, maxid = GetPlayerPoolSize(); i <= maxid; i++)
	{
		if (!IsPlayerConnected(i))
			continue;

		if (GetPlayerState(i) != PLAYER_STATE_DRIVER)
			continue;

		new vehicleIndex = GetVehicleIndexByVehicleID(PlayersDataOnline[i][InCarId]);
		if (vehicleIndex == -1)
			continue;

		new Float:x, Float:y, Float:z;
		GetVehicleVelocity(PlayersDataOnline[i][InCarId], x, y, z);
		new vel = floatround(floatsqroot(x * x + y * y + z * z) * 100.0 * 1.8);

		new str[8];
		format(str, sizeof(str), "%03d", vel);
		PlayerTextDrawSetString(i, GetSpeedoPTD(i, 1), str);

		new Float:barW = SPEEDO_BAR_RIGHT - SPEEDO_BAR_LEFT;

		new Float:gasFillX = SPEEDO_BAR_LEFT + barW * float(DataCars[vehicleIndex][Gas]) / float(MAX_GAS_VEHICLE);
		PlayerTextDrawTextSize(i, GetSpeedoPTD(i, 5), gasFillX, SPEEDO_GAS_Y);
		PlayerTextDrawShow(i, GetSpeedoPTD(i, 5));

		new Float:oilFillX = SPEEDO_BAR_LEFT + barW * float(DataCars[vehicleIndex][Oil]) / float(MAX_OIL_VEHICLE);
		PlayerTextDrawTextSize(i, GetSpeedoPTD(i, 8), oilFillX, SPEEDO_OIL_Y);
		PlayerTextDrawShow(i, GetSpeedoPTD(i, 8));
	}
	return 1;
}

CreateSpeedoTDForPlayer(playerid)
{
	// contenedor: gris oscuro semitransparente
	SetSpeedoPTD(playerid, 0, CreatePlayerTextDraw(playerid, 465.0, 370.0, "_"));
	PlayerTextDrawUseBox(playerid, GetSpeedoPTD(playerid, 0), true);
	PlayerTextDrawBoxColour(playerid, GetSpeedoPTD(playerid, 0), 0x3C3C3C96);
	PlayerTextDrawTextSize(playerid, GetSpeedoPTD(playerid, 0), 625.0, 440.0);
	PlayerTextDrawColour(playerid, GetSpeedoPTD(playerid, 0), 0x00000000);
	PlayerTextDrawBackgroundColour(playerid, GetSpeedoPTD(playerid, 0), 0x00000000);
	PlayerTextDrawLetterSize(playerid, GetSpeedoPTD(playerid, 0), 0.0, 0.0);

	// numero velocidad: grande, blanco, font pricedown
	SetSpeedoPTD(playerid, 1, CreatePlayerTextDraw(playerid, 470.0, 372.0, "000"));
	PlayerTextDrawFont(playerid, GetSpeedoPTD(playerid, 1), TEXT_DRAW_FONT_3);
	PlayerTextDrawLetterSize(playerid, GetSpeedoPTD(playerid, 1), 0.5, 2.0);
	PlayerTextDrawColour(playerid, GetSpeedoPTD(playerid, 1), 0xFFFFFFFF);
	PlayerTextDrawBackgroundColour(playerid, GetSpeedoPTD(playerid, 1), 0x00000000);
	PlayerTextDrawAlignment(playerid, GetSpeedoPTD(playerid, 1), TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawSetShadow(playerid, GetSpeedoPTD(playerid, 1), 0);
	PlayerTextDrawSetOutline(playerid, GetSpeedoPTD(playerid, 1), 1);

	// unidad km/h: chica, gris claro
	SetSpeedoPTD(playerid, 2, CreatePlayerTextDraw(playerid, 470.0, 397.0, "KM/H"));
	PlayerTextDrawFont(playerid, GetSpeedoPTD(playerid, 2), TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, GetSpeedoPTD(playerid, 2), 0.18, 0.8);
	PlayerTextDrawColour(playerid, GetSpeedoPTD(playerid, 2), 0xA0A0A0FF);
	PlayerTextDrawBackgroundColour(playerid, GetSpeedoPTD(playerid, 2), 0x00000000);
	PlayerTextDrawAlignment(playerid, GetSpeedoPTD(playerid, 2), TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawSetShadow(playerid, GetSpeedoPTD(playerid, 2), 0);
	PlayerTextDrawSetOutline(playerid, GetSpeedoPTD(playerid, 2), 0);

	// label gas: centrado arriba de la barra
	SetSpeedoPTD(playerid, 3, CreatePlayerTextDraw(playerid, 560.0, 374.0, "GAS"));
	PlayerTextDrawFont(playerid, GetSpeedoPTD(playerid, 3), TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, GetSpeedoPTD(playerid, 3), 0.15, 0.7);
	PlayerTextDrawColour(playerid, GetSpeedoPTD(playerid, 3), 0xFFFFFFFF);
	PlayerTextDrawBackgroundColour(playerid, GetSpeedoPTD(playerid, 3), 0x00000000);
	PlayerTextDrawAlignment(playerid, GetSpeedoPTD(playerid, 3), TEXT_DRAW_ALIGN_CENTRE);
	PlayerTextDrawSetShadow(playerid, GetSpeedoPTD(playerid, 3), 0);
	PlayerTextDrawSetOutline(playerid, GetSpeedoPTD(playerid, 3), 0);

	// fondo barra gas: gris
	SetSpeedoPTD(playerid, 4, CreatePlayerTextDraw(playerid, SPEEDO_BAR_LEFT, SPEEDO_GAS_Y, "_"));
	PlayerTextDrawUseBox(playerid, GetSpeedoPTD(playerid, 4), true);
	PlayerTextDrawBoxColour(playerid, GetSpeedoPTD(playerid, 4), 0x7E7E7EFF);
	PlayerTextDrawTextSize(playerid, GetSpeedoPTD(playerid, 4), SPEEDO_BAR_RIGHT, SPEEDO_GAS_Y);
	PlayerTextDrawColour(playerid, GetSpeedoPTD(playerid, 4), 0x00000000);
	PlayerTextDrawBackgroundColour(playerid, GetSpeedoPTD(playerid, 4), 0x00000000);
	PlayerTextDrawLetterSize(playerid, GetSpeedoPTD(playerid, 4), 0.0, SPEEDO_BAR_H);

	// relleno barra gas: verde, ancho dinamico
	SetSpeedoPTD(playerid, 5, CreatePlayerTextDraw(playerid, SPEEDO_BAR_LEFT, SPEEDO_GAS_Y, "_"));
	PlayerTextDrawUseBox(playerid, GetSpeedoPTD(playerid, 5), true);
	PlayerTextDrawBoxColour(playerid, GetSpeedoPTD(playerid, 5), 0x41D83DFF);
	PlayerTextDrawTextSize(playerid, GetSpeedoPTD(playerid, 5), SPEEDO_BAR_LEFT, SPEEDO_GAS_Y);
	PlayerTextDrawColour(playerid, GetSpeedoPTD(playerid, 5), 0x00000000);
	PlayerTextDrawBackgroundColour(playerid, GetSpeedoPTD(playerid, 5), 0x00000000);
	PlayerTextDrawLetterSize(playerid, GetSpeedoPTD(playerid, 5), 0.0, SPEEDO_BAR_H);

	// label aceite: centrado arriba de la barra
	SetSpeedoPTD(playerid, 6, CreatePlayerTextDraw(playerid, 560.0, 402.0, "ACEITE"));
	PlayerTextDrawFont(playerid, GetSpeedoPTD(playerid, 6), TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, GetSpeedoPTD(playerid, 6), 0.15, 0.7);
	PlayerTextDrawColour(playerid, GetSpeedoPTD(playerid, 6), 0xFFFFFFFF);
	PlayerTextDrawBackgroundColour(playerid, GetSpeedoPTD(playerid, 6), 0x00000000);
	PlayerTextDrawAlignment(playerid, GetSpeedoPTD(playerid, 6), TEXT_DRAW_ALIGN_CENTRE);
	PlayerTextDrawSetShadow(playerid, GetSpeedoPTD(playerid, 6), 0);
	PlayerTextDrawSetOutline(playerid, GetSpeedoPTD(playerid, 6), 0);

	// fondo barra aceite: gris
	SetSpeedoPTD(playerid, 7, CreatePlayerTextDraw(playerid, SPEEDO_BAR_LEFT, SPEEDO_OIL_Y, "_"));
	PlayerTextDrawUseBox(playerid, GetSpeedoPTD(playerid, 7), true);
	PlayerTextDrawBoxColour(playerid, GetSpeedoPTD(playerid, 7), 0x7E7E7EFF);
	PlayerTextDrawTextSize(playerid, GetSpeedoPTD(playerid, 7), SPEEDO_BAR_RIGHT, SPEEDO_OIL_Y);
	PlayerTextDrawColour(playerid, GetSpeedoPTD(playerid, 7), 0x00000000);
	PlayerTextDrawBackgroundColour(playerid, GetSpeedoPTD(playerid, 7), 0x00000000);
	PlayerTextDrawLetterSize(playerid, GetSpeedoPTD(playerid, 7), 0.0, SPEEDO_BAR_H);

	// relleno barra aceite: rojo, ancho dinamico
	SetSpeedoPTD(playerid, 8, CreatePlayerTextDraw(playerid, SPEEDO_BAR_LEFT, SPEEDO_OIL_Y, "_"));
	PlayerTextDrawUseBox(playerid, GetSpeedoPTD(playerid, 8), true);
	PlayerTextDrawBoxColour(playerid, GetSpeedoPTD(playerid, 8), 0xD84040FF);
	PlayerTextDrawTextSize(playerid, GetSpeedoPTD(playerid, 8), SPEEDO_BAR_LEFT, SPEEDO_OIL_Y);
	PlayerTextDrawColour(playerid, GetSpeedoPTD(playerid, 8), 0x00000000);
	PlayerTextDrawBackgroundColour(playerid, GetSpeedoPTD(playerid, 8), 0x00000000);
	PlayerTextDrawLetterSize(playerid, GetSpeedoPTD(playerid, 8), 0.0, SPEEDO_BAR_H);

	// indicador izquierdo: circulo metalico
	SetSpeedoPTD(playerid, 9, CreatePlayerTextDraw(playerid, 498.0, 414.0, "o"));
	PlayerTextDrawFont(playerid, GetSpeedoPTD(playerid, 9), TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, GetSpeedoPTD(playerid, 9), 0.15, 0.7);
	PlayerTextDrawColour(playerid, GetSpeedoPTD(playerid, 9), 0xB0B0B0FF);
	PlayerTextDrawBackgroundColour(playerid, GetSpeedoPTD(playerid, 9), 0x00000000);
	PlayerTextDrawAlignment(playerid, GetSpeedoPTD(playerid, 9), TEXT_DRAW_ALIGN_CENTRE);
	PlayerTextDrawSetShadow(playerid, GetSpeedoPTD(playerid, 9), 0);
	PlayerTextDrawSetOutline(playerid, GetSpeedoPTD(playerid, 9), 0);

	// indicador derecho: circulo metalico
	SetSpeedoPTD(playerid, 10, CreatePlayerTextDraw(playerid, 622.0, 414.0, "o"));
	PlayerTextDrawFont(playerid, GetSpeedoPTD(playerid, 10), TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, GetSpeedoPTD(playerid, 10), 0.15, 0.7);
	PlayerTextDrawColour(playerid, GetSpeedoPTD(playerid, 10), 0xB0B0B0FF);
	PlayerTextDrawBackgroundColour(playerid, GetSpeedoPTD(playerid, 10), 0x00000000);
	PlayerTextDrawAlignment(playerid, GetSpeedoPTD(playerid, 10), TEXT_DRAW_ALIGN_CENTRE);
	PlayerTextDrawSetShadow(playerid, GetSpeedoPTD(playerid, 10), 0);
	PlayerTextDrawSetOutline(playerid, GetSpeedoPTD(playerid, 10), 0);
}

DestroySpeedoTDForPlayer(playerid)
{
	for (new i = 0; i < 11; i++)
	{
		PlayerTextDrawDestroy(playerid, GetSpeedoPTD(playerid, i));
		SetSpeedoPTD(playerid, i, PlayerText:INVALID_TEXT_DRAW);
	}
}

ShowSpeedoForPlayer(playerid)
{
	for (new i = 0; i < 11; i++)
	{
		PlayerTextDrawShow(playerid, GetSpeedoPTD(playerid, i));
	}
}

HideSpeedoForPlayer(playerid)
{
	for (new i = 0; i < 11; i++)
	{
		PlayerTextDrawHide(playerid, GetSpeedoPTD(playerid, i));
	}
}

StartSpeedo(playerid, vehicleIndex)
{
	PlayerTextDrawSetString(playerid, GetSpeedoPTD(playerid, 1), "000");

	new Float:barW = SPEEDO_BAR_RIGHT - SPEEDO_BAR_LEFT;

	new Float:gasFillX = SPEEDO_BAR_LEFT + barW * float(DataCars[vehicleIndex][Gas]) / float(MAX_GAS_VEHICLE);
	PlayerTextDrawTextSize(playerid, GetSpeedoPTD(playerid, 5), gasFillX, SPEEDO_GAS_Y);
	PlayerTextDrawShow(playerid, GetSpeedoPTD(playerid, 5));

	new Float:oilFillX = SPEEDO_BAR_LEFT + barW * float(DataCars[vehicleIndex][Oil]) / float(MAX_OIL_VEHICLE);
	PlayerTextDrawTextSize(playerid, GetSpeedoPTD(playerid, 8), oilFillX, SPEEDO_OIL_Y);
	PlayerTextDrawShow(playerid, GetSpeedoPTD(playerid, 8));

	ShowSpeedoForPlayer(playerid);
}

StopSpeedo(playerid)
{
	HideSpeedoForPlayer(playerid);
}
