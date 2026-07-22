ShowCarteraToPlayer(playerid, playeridshow)
{
    new MsgCartera[MAX_TEXT_CHAT];
	SendClientMessage(playeridshow, COLOR_MALETERO_ARMARIO_CAJA_FUERTE,
	 ">>>>>>>>>> .:Cartera:. <<<<<<<<<");
	for (new i = 0; i<=5;i++)
	{
	    if ( PlayersData[playerid][Cartera][i] != CARTERA_TYPE_NADA )
	    {
	        //if
	        switch ( PlayersData[playerid][Cartera][i] )
	        {
	            case CARTERA_TYPE_CHEQUE:
	            {
					format(MsgCartera, sizeof(MsgCartera), "%Cartera %i: %s [Cantidad: $%i] (Numero del cheque #%i) [Cuenta a cobrar: %i]", i + 1, CarteraNames[PlayersData[playerid][Cartera][i]], PlayersData[playerid][CarteraC][i], PlayersData[playerid][CarteraT][i], PlayersData[playerid][CarteraI][i]);
				}
				case CARTERA_TYPE_CONDONES:
				{
					format(MsgCartera, sizeof(MsgCartera), "Cartera %i: %s %i", i + 1, CarteraNames[PlayersData[playerid][Cartera][i]], PlayersData[playerid][CarteraC][i]);
				}
				default:
				{
					format(MsgCartera, sizeof(MsgCartera), "Cartera %i: %s", i + 1, CarteraNames[PlayersData[playerid][Cartera][i]]);
				}
			}
		}
		else
		{
			format(MsgCartera, sizeof(MsgCartera), "%Cartera %i: %s", i + 1, CarteraNames[PlayersData[playerid][Cartera][i]]);
		}
		SendClientMessage(playeridshow, COLOR_MALETERO_ARMARIO_CAJA_FUERTE, MsgCartera);
	}
}
IsNotFullCartera(playeridError, playerid, const error[])
{
	for(new i = 0; i< MAX_COUNT_CARTERA; i++)
	{
	    if (PlayersData[playerid][Cartera][i] == CARTERA_TYPE_NADA)
	    {
			return true;
		}
	}
	SendInfoMessage(playeridError, 0, "1321", error);
	return false;
}
AddObjectToCartera(playerid, objectid, carteraC, carteraT, carteraI)
{
	for(new i = 0; i < MAX_COUNT_CARTERA; i++)
	{
		if (PlayersData[playerid][Cartera][i] == CARTERA_TYPE_NADA)
		{
		    PlayersData[playerid][Cartera][i] = objectid;
		    PlayersData[playerid][CarteraC][i] = carteraC;
		    PlayersData[playerid][CarteraT][i] = carteraT;
		    PlayersData[playerid][CarteraI][i] = carteraI;

			return i;
		}
	}
	return -1;
}
RemoveObjectToCartera(playerid, carteraid)
{
	if ( PlayersData[playerid][Cartera][carteraid] != CARTERA_TYPE_NADA )
	{
	    new ObjectCartera = PlayersData[playerid][Cartera][carteraid];
		PlayersData[playerid][Cartera][carteraid]  = CARTERA_TYPE_NADA;
	    PlayersData[playerid][CarteraC][carteraid] = 0;
		PlayersData[playerid][CarteraT][carteraid] = 0;
		return ObjectCartera;
	}
	else
	{
	    return -1;
	}
}