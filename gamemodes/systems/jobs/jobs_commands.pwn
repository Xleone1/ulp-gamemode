// comandos de trabajos extraidos de main.pwn

OnPlayerCommandJobs(playerid, const cmdtext[])
{
	if (strcmp("/Ayuda Trabajo", cmdtext, true, 14) == 0 && strlen(cmdtext) == 14)
	{
		ShowJobHelp(playerid);
		return 1;
	}
	else if (strcmp("/Trabajar", cmdtext, true, 9) == 0 && strlen(cmdtext) == 9)
	{
		TogglePlayerJob(playerid);
		return 1;
	}
	else if (strcmp("/Pescar", cmdtext, true, 7) == 0 && strlen(cmdtext) == 7)
	{
		Fish(playerid);
		return 1;
	}
	else if (strcmp("/Vender Peces", cmdtext, true, 13) == 0 && strlen(cmdtext) == 13)
	{
		SellFish(playerid);
		return 1;
	}
	else if (strfind(cmdtext, "/Vender Movil ", true) == 0 || strfind(cmdtext, "/Vender Movil ", true) == 0)
	{
		OfferPhone(playerid, cmdtext);
		return 1;
	}
	else if (strcmp("/Aceptar Movil", cmdtext, true, 14) == 0 && strlen(cmdtext) == 14 || strcmp("/Aceptar Movil", cmdtext, true, 14) == 0 && strlen(cmdtext) == 14)
	{
		AcceptPhoneOffer(playerid);
		return 1;
	}
	return 0;
}
