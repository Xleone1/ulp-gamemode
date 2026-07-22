IsTunnigContinue(playerid)
{
	if ( PlayersDataOnline[playerid][MyIDVehicleTunning] == IsPlayerInNearVehicle(playerid) )
	{
	    return true;
	}
	else
	{
		TogglePlayerControllableEx(playerid, true);
		SendInfoMessage(playerid, 0, "677", "Acerquese o suba al vehiculo que estaba tunenado!");
	    return false;
	}
}
IsPlayerInTaller(playerid)
{
	if ( IsPlayerInRangeOfPoint(playerid, 30.0, -2973.7065,470.3227,4.9141) &&
         PlayersData[playerid][Faccion] == TALLER_SF ||
		 IsPlayerInRangeOfPoint(playerid, 30.0, 615.3417,-10.6391,1000.9219) &&
         PlayersData[playerid][Faccion] == TALLER_SF ||
		 IsPlayerInRangeOfPoint(playerid, 30.0, 1794.7306,-2037.6821,13.5245) &&
         PlayersData[playerid][Faccion] == TALLER_LS ||
		 IsPlayerInRangeOfPoint(playerid, 30.0, 1751.9133,-2021.4797,20.6677) &&
         PlayersData[playerid][Faccion] == TALLER_LS  )
	{
	    return true;
	}
	else
	{
		SendInfoMessage(playerid, 0, "682", "No se encuentra en el taller!");
	    return false;
	}
}
IsPlayerInTallerEx(playerid)
{
	if ( IsPlayerInRangeOfPoint(playerid, 30.0, -2973.7065,470.3227,4.9141) ||
		 IsPlayerInRangeOfPoint(playerid, 30.0, 615.3417,-10.6391,1000.9219) ||
		 IsPlayerInRangeOfPoint(playerid, 30.0, 1794.7306,-2037.6821,13.5245) ||
		 IsPlayerInRangeOfPoint(playerid, 30.0, 1751.9133,-2021.4797,20.6677) )
	{
	    return true;
	}
	else
	{
		SendInfoMessage(playerid, 0, "682", "No se encuentra en el taller!");
	    return false;
	}
}
ShowChangePlate(playerid)
{
	ShowPlayerDialogEx(playerid, 79, DIALOG_STYLE_INPUT, "{"COLOR_AZUL"}Taller - Cambio de matricula", "{"COLOR_TEXTO_DIALOGS"}Ingrese el numero de matricula que\ndesea para este vehiculo.", "A gusto", "Aleatoria");
}