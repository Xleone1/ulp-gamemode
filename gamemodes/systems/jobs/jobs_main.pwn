// logica core de trabajos

LoadJobs()
{
	format(Jobs[NINGUNO][NameJob], MAX_FACCION_NAME, "Ninguno");

	format(Jobs[PESCA][NameJob], MAX_FACCION_NAME, "Pescador");
	format(Jobs[VENDEDOR_MOVIL][NameJob], MAX_FACCION_NAME, "Vendedor de Moviles");
}

IncrementWorkHours(playerid)
{
	if ( PlayersData[playerid][Faccion] != CIVIL )
	{
		PlayersData[playerid][HorasWork]++;
	}
}

ShowJobHelp(playerid)
{
	if ( PlayersData[playerid][Job] != NINGUNO )
	{
		SendClientMessage(playerid, COLOR_TITULO_DE_AYUDA, TITULO_AYUDA);
		if ( PlayersData[playerid][Job] == PESCA )
		{
			SendInfoMessage(playerid, 1, "/Pescar - /Vender Peces", "Pesca: ");
		}
		else if ( PlayersData[playerid][Job] == VENDEDOR_MOVIL )
		{
			SendInfoMessage(playerid, 1, "/Vender Movil [ID] [Precio] [Numero]", "Vendedor de Moviles: ");
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "963", "Tu no tienes trabajo");
	}
}

TogglePlayerJob(playerid)
{
	new FoundJob;
	for(new i=1;i<MAX_JOB;i++)
	{
		if ( Jobs[i][pickupidGet] == PlayersDataOnline[playerid][InPickup] )
		{
			FoundJob = true;
			if ( PlayersData[playerid][Job] == NINGUNO || PlayersData[playerid][Job] == i)
			{
				if ( PlayersData[playerid][Job] == i )
				{
					PlayersData[playerid][Job] = NINGUNO;
					SendInfoMessage(playerid, 3, "0", "Has dejado el trabajo, ahora no desempeñaras ninguna labor.");
				}
				else
				{
					if ( i == VENDEDOR_MOVIL && GetPlayerScore(playerid) <= 2 )
					{
						SendInfoMessage(playerid, 0, "967", "Debes ser mayor de nivel 2 para ser vendedor de moviles.");
						return 1;
					}
					else if ( i == VENDEDOR_MOVIL && PlayersData[playerid][Faccion] != CIVIL )
					{
						SendInfoMessage(playerid, 0, "1287", "Debes ser civil para poder trabajar como vendedor de telefonos.");
						return 1;
					}
					PlayersData[playerid][Job] = i;
					new MsgJob[MAX_TEXT_CHAT];
					format(MsgJob, sizeof(MsgJob), "Ahora tienes un nuevo trabajo, seras: %s.", Jobs[i][NameJob]);
					SendInfoMessage(playerid, 3, "0", MsgJob);
				}
			}
			else
			{
				SendInfoMessage(playerid, 0, "967", "Ya tienes un trabajo, debes dejarlo antes de entrar en otro.");
			}
			break;
		}
	}
	if ( !FoundJob )
	{
		SendInfoMessage(playerid, 0, "968", "No te encuetras en ningun trabajo!");
	}
	return 1;
}

AcceptPhoneOffer(playerid)
{
	if ( PlayersDataOnline[playerid][VPhone][0] != -1 )
	{
		if ( IsPlayerNearEx(playerid, PlayersDataOnline[playerid][VPhone][0], "1470", "1471", "1472", "El jugador que le iva a comprar un movil se a desconectado", "El jugador que le iva a comprar un movil no se ha logueado", "El jugador que le iva a comprar un movil no se encuentra cerca de ti") )
		{
			if ( !PlayersData[playerid][Phone] )
			{
				if ( PlayersData[playerid][Dinero] >= PlayersDataOnline[playerid][VPhone][1] )
				{
					if ( PlayersDataOnline[playerid][VPhone][2] == 0 && BuyPhone(playerid) || BuyPhoneNow(playerid, PlayersDataOnline[playerid][VPhone][2]) )
					{
						new MsgMovil[MAX_TEXT_CHAT];
						new MsgMovilToPlayer[MAX_TEXT_CHAT];
						format(MsgMovil, sizeof(MsgMovil), "Has comprado un movil a el vendedor de moviles %s, por $%i", PlayersDataOnline[PlayersDataOnline[playerid][VPhone][0]][NameOnlineFix], PlayersDataOnline[playerid][VPhone][1]);
						format(MsgMovilToPlayer, sizeof(MsgMovilToPlayer), "%s te ha comprado un movil por $%i", PlayersDataOnline[playerid][NameOnlineFix], PlayersDataOnline[playerid][VPhone][1]);
						SendInfoMessage(playerid, 3, "0", MsgMovil);
						SendInfoMessage(PlayersDataOnline[playerid][VPhone][0],3, "0", MsgMovilToPlayer);
						GivePlayerMoneyEx(playerid, -PlayersDataOnline[playerid][VPhone][1]);
						GivePlayerMoneyEx(PlayersDataOnline[playerid][VPhone][0], PlayersDataOnline[playerid][VPhone][1]);
					}
					else
					{
						SendInfoMessage(playerid, 0, "1473", "El movil que deseabas comprar ya fue comprado! Intenta comprar otro!");
					}
				}
				else
				{
					SendInfoMessage(playerid, 0, "1474", "No tienes suficiente dinero para comprar ese movil!");
				}
			}
			else
			{
				SendInfoMessage(playerid, 0, "1475", "Ya usted tiene un movil! Deshagase de el si quiere comprar uno nuevo");
			}
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "1476", "No has recibido ninguna oferta para comprar un movil!");
	}
	PlayersDataOnline[playerid][VPhone][0] = -1;
	PlayersDataOnline[playerid][VPhone][1] = -1;
	PlayersDataOnline[playerid][VPhone][2] = -1;
}

SellFish(playerid)
{
	if ( PlayersData[playerid][Job] == PESCA )
	{
		if ( PlayersDataOnline[playerid][InPickup] == PickupInfo[JobsData[PESCA_PickupidVender]][PickupId] )
		{
			if ( PlayersDataOnline[playerid][JobBonus] )
			{
				SendInfoMessage(playerid, 3, "0", "Haz vendido los peces por $800!");
				PlayersDataOnline[playerid][JobBonus] = false;
				GivePlayerMoneyEx(playerid, 800);
			}
			else
			{
				SendInfoMessage(playerid, 0, "969", "No tienes peces para vender!");
			}
		}
		else
		{
			SendInfoMessage(playerid, 0, "970", "No estas en el punto de venta!");
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "971", "No eres pescador!");
	}
}

OfferPhone(playerid, const cmdtext[])
{
	if ( PlayersData[playerid][Job] == VENDEDOR_MOVIL )
	{
		new playerSell = strval(cmdtext[GetPosSpace(cmdtext, 2)]);
		new priceSell = strval(cmdtext[GetPosSpace(cmdtext, 3)]);
		new phoneNumber = strval(cmdtext[GetPosSpace(cmdtext, 4)]);
		if ( IsPlayerNearEx(playerid, playerSell, "1477", "1478", "1479", "El jugador que desea venderle un movil no se encuentra conectado", "El jugador que desea venderle un movil no se encuentra logueado", "El jugador que desea venderle un movil no se encuentra cerca de ti") )
		{
			if ( priceSell >= 100 && priceSell <= 20000 )
			{
				if ( phoneNumber == 0 || phoneNumber > 1000 && phoneNumber <= 99999 && CheckNumberAvalible(phoneNumber) )
				{
					new MsgMovil[MAX_TEXT_CHAT];
					new MsgMovilToPlayer[MAX_TEXT_CHAT];
					if ( phoneNumber == 0 )
					{
						format(MsgMovil, sizeof(MsgMovil), "Ofresiste a %s venderle un movil con numero aleatorio por $%i", PlayersDataOnline[playerSell][NameOnlineFix], priceSell);
						format(MsgMovilToPlayer, sizeof(MsgMovilToPlayer), "%s quiere venderte un movil con numero aleatorio por $%i. Use (/Aceptar Movil)", PlayersDataOnline[playerid][NameOnlineFix], priceSell);
					}
					else
					{
						format(MsgMovil, sizeof(MsgMovil), "Ofresiste a %s venderle un movil con numero personalizado (%i) por $%i", PlayersDataOnline[playerSell][NameOnlineFix], phoneNumber, priceSell);
						format(MsgMovilToPlayer, sizeof(MsgMovilToPlayer), "%s quiere venderte un movil con numero personalizado (%i) por $%i. Use (/Aceptar Movil)", PlayersDataOnline[playerid][NameOnlineFix], phoneNumber, priceSell);
					}
					SendInfoMessage(playerid, 3, "0", MsgMovil);
					SendInfoMessage(playerSell, 3, "0", MsgMovilToPlayer);
					PlayersDataOnline[playerSell][VPhone][0] = playerid;
					PlayersDataOnline[playerSell][VPhone][1] = priceSell;
					PlayersDataOnline[playerSell][VPhone][2] = phoneNumber;
				}
				else
				{
					SendInfoMessage(playerid, 0, "1480", "El numero introducido no esta disponible, recuerde que debe estar comprendido entre 1000 y 99999");
				}
			}
			else
			{
				SendInfoMessage(playerid, 0, "1481", "El precio del movil debe ser como minimo $100 y maximo $20000");
			}
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "1482", "Usted no es vendedor de moviles");
	}
}

Fish(playerid)
{
	if ( PlayersData[playerid][Job] == PESCA )
	{
		if ( PlayersDataOnline[playerid][InPickup] == PickupInfo[JobsData[PESCA_PickupidPescar]][PickupId] )
		{
			if ( !PlayersDataOnline[playerid][JobBonus] )
			{
				if ( IntentarAccion(playerid, "pescar algo", random(3)) )
				{
					PlayersDataOnline[playerid][JobBonus] = true;
					SendInfoMessage(playerid, 3, "0", "Haz capturado unos peces! Ahora puedes ir a venderlos!");
					SetPlayerCheckpoint(playerid, PickupInfo[JobsData[PESCA_PickupidVender]][PosInfoX], PickupInfo[JobsData[PESCA_PickupidVender]][PosInfoY], PickupInfo[JobsData[PESCA_PickupidVender]][PosInfoZ], 1.0);
				}
			}
			else
			{
				SendInfoMessage(playerid, 0, "964", "Ya tienes peces, vende esos antes de pescar mas");
			}
		}
		else
		{
			SendInfoMessage(playerid, 0, "965", "No te encuentras en la zona de pesca!");
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "966", "No eres pescador!");
	}
}
