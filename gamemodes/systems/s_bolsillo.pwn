IsNotFullBolsillo(playeridError, playerid, const error[])
{
	for(new i = 0; i<=4; i++)
	{
	    if (PlayersData[playerid][Bolsillos][i] == 0)
	    {
			return true;
		}
	}
	SendInfoMessage(playeridError, 0, "1020", error);
	return false;
}
IsObjectInBolsillo(playerid, objectid)
{
	for(new i = 0; i<=4; i++)
	{
	    if (PlayersData[playerid][Bolsillos][i] == objectid)
	    {
	        return true;
		}
	}
	return false;
}
RemoveObjectBolsillo(playerid, objectid)
{
	for(new i = 0; i<=4; i++)
	{
	    if (PlayersData[playerid][Bolsillos][i] == objectid)
	    {
	        PlayersData[playerid][Bolsillos][i] = 0;
			return true;
		}
	}
	return false;
}
AddObjectBolsillo(playerid, objectid)
{
	for(new i = 0; i<=4; i++)
	{
	    if (PlayersData[playerid][Bolsillos][i] == 0)
	    {
	        PlayersData[playerid][Bolsillos][i] = objectid;
			return true;
		}
	}
	return false;
}
ShowBolsillosToPlayer(playerid, playeridshow)
{
    new MsgBolsillos[MAX_TEXT_CHAT];
	SendClientMessage(playeridshow, COLOR_MALETERO_ARMARIO_CAJA_FUERTE,
	 ">>>>>>>>>> .:Bolsillos:. <<<<<<<<<");
	for (new i = 0; i<=4;i++)
	{
		format(MsgBolsillos, sizeof(MsgBolsillos), "Bolsillo %i: %s", i + 1, ObjetosBolsillosNombres[PlayersData[playerid][Bolsillos][i]]);
		SendClientMessage(playeridshow, COLOR_MALETERO_ARMARIO_CAJA_FUERTE, MsgBolsillos);
	}
}