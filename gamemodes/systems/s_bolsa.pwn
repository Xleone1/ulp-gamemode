ShowBolsaToPlayer(playerid, playeridshow)
{
    new MsgBolsa[MAX_TEXT_CHAT];
	SendClientMessage(playeridshow, COLOR_MALETERO_ARMARIO_CAJA_FUERTE,
	 ">>>>>>>>>> .:Bolsa:. <<<<<<<<<");
	for (new i = 0; i<4;i++)
	{
		format(MsgBolsa, sizeof(MsgBolsa), "Bolsa %i: %s (%i)", i + 1, Articulos[PlayersData[playerid][Bolsa][i]][NameA], PlayersData[playerid][BolsaC][i]);
		SendClientMessage(playeridshow, COLOR_MALETERO_ARMARIO_CAJA_FUERTE, MsgBolsa);
	}
}
LoadTypeArticulosR()
{
	format(Articulos[A_NADA][NameA], MAX_PLAYER_NAME, "Nada");
	Articulos[A_NADA][Vida] = 0.0;

	format(Articulos[A_CERVEZA][NameA], MAX_PLAYER_NAME, "Cerveza");
	Articulos[A_CERVEZA][Vida] = 20.0;

	format(Articulos[A_VODKA][NameA], MAX_PLAYER_NAME, "Vodka");
	Articulos[A_VODKA][Vida] = 15.0;

	format(Articulos[A_REFRESCO][NameA], MAX_PLAYER_NAME, "Refresco");
	Articulos[A_REFRESCO][Vida] = 10.0;

	format(Articulos[A_POLLO][NameA], MAX_PLAYER_NAME, "Pollo crudo");
	Articulos[A_POLLO][Vida] = 0.0;

	format(Articulos[A_POLLO_C][NameA], MAX_PLAYER_NAME, "Pollo cocinado");
	Articulos[A_POLLO_C][Vida] = 30.0;

	format(Articulos[A_PAPAS][NameA], MAX_PLAYER_NAME, "Papas");
	Articulos[A_PAPAS][Vida] = 0.0;

	format(Articulos[A_PAPAS_C][NameA], MAX_PLAYER_NAME, "Papas cocinadas");
	Articulos[A_PAPAS_C][Vida] = 15.0;

	format(Articulos[A_ARROZ][NameA], MAX_PLAYER_NAME, "Arroz");
	Articulos[A_ARROZ][Vida] = 0.0;

	format(Articulos[A_ARROZ_C][NameA], MAX_PLAYER_NAME, "Arroz Cocinado");
	Articulos[A_ARROZ_C][Vida] = 35.0;
}
AddArticuloBolsa(playerid, articuloid, cantidad)
{
	new AritcleEmpty = IsArticuloInBolsa(playerid, articuloid);
	if ( AritcleEmpty == -1 )
	{
		for(new i = 0; i<4; i++)
		{
		    if (!PlayersData[playerid][Bolsa][i])
		    {
	 			PlayersData[playerid][Bolsa][i] = articuloid;
			    PlayersData[playerid][BolsaC][i] += cantidad;
				return true;
			}
		}
	}
	else
	{
        if ( IsNotFullBolsa(playerid, AritcleEmpty) )
        {
		    PlayersData[playerid][Bolsa][AritcleEmpty] = articuloid;
		    PlayersData[playerid][BolsaC][AritcleEmpty] += cantidad;
		    return true;
	    }
	    else
	    {
	        return 2;
		}
	}
	return false;
}
RemoveArticuloBolsa(playerid, bolsaid)
{
	PlayersData[playerid][Bolsa][bolsaid] = false;
	PlayersData[playerid][BolsaC][bolsaid] = 0;
}
IsArticuloInBolsa(playerid, articuloid)
{
	for(new i = 0; i<4; i++)
	{
	    if (PlayersData[playerid][Bolsa][i] == articuloid)
	    {
			return i;
		}
	}
	return -1;
}
CleanArticulosBolsa(playerid)
{
	for(new i = 0; i<4; i++)
	{
		RemoveArticuloBolsa(playerid, i);
	}
	return false;
}
IsNotFullBolsa(playerid, bolsaid)
{
	if ( PlayersData[playerid][BolsaC][bolsaid] < 16 )
	{
		return true;
	}
	else
	{
	    return false;
	}
}
GiveArticlePlayerToPlayer(playerid, playeridtogive, bolsaid)
{
	if ( PlayersData[playerid][HaveBolsa] )
	{
		if ( PlayersData[playeridtogive][HaveBolsa] )
		{
			if ( bolsaid > 0 && bolsaid  < 5 )
   			{
			    bolsaid--;
			    if ( PlayersData[playerid][Bolsa][bolsaid] )
			    {
				    switch (AddArticuloBolsa(playeridtogive, PlayersData[playerid][Bolsa][bolsaid], PlayersData[playerid][BolsaC][bolsaid]))
				    {
				        case 0:
				        {
							SendInfoMessage(playerid, 0, "1236", "Al jugador que desea darle un articulo, tiene la bolsa llena!");
						}
						case 1:
						{
							new MsgGiveArticle[MAX_TEXT_CHAT];
							new MsgGiveArticleME[MAX_TEXT_CHAT];
							new MsgGiveArticleYOU[MAX_TEXT_CHAT];
					        format(MsgGiveArticle, sizeof(MsgGiveArticle), "le da %s a %s", Articulos[PlayersData[playerid][Bolsa][bolsaid]][NameA], PlayersDataOnline[playeridtogive][NameOnlineFix]);
					        format(MsgGiveArticleME, sizeof(MsgGiveArticleME), "Le has dado %i %s a %s.", PlayersData[playerid][BolsaC][bolsaid], Articulos[PlayersData[playerid][Bolsa][bolsaid]][NameA], PlayersDataOnline[playeridtogive][NameOnlineFix]);
					        format(MsgGiveArticleYOU, sizeof(MsgGiveArticleYOU), "%s te ha dado %i %s", PlayersDataOnline[playerid][NameOnlineFix], PlayersData[playerid][BolsaC][bolsaid], Articulos[PlayersData[playerid][Bolsa][bolsaid]][NameA]);
					        Acciones(playerid, 8, MsgGiveArticle);
					        SendInfoMessage(playerid, 2, "0", MsgGiveArticleME);
					        SendInfoMessage(playeridtogive, 2, "0", MsgGiveArticleYOU);
					        RemoveArticuloBolsa(playerid, bolsaid);
						}
						case 2:
						{
		       				SendInfoMessage(playerid, 0, "1245", "Al jugador que le deseas dar este articulo ya no puede llevar mas de esos en su bolsa");
						}
					}
				}
				else
				{
					SendInfoMessage(playerid, 0, "1237", "No tienes nada en esa parte de la bolsa!");
				}
			}
			else
			{
				SendInfoMessage(playerid, 0, "1242", "El numero de Slot de bolsa debe estar comprendido entre 1 y 4");
			}
		}
		else
		{
			SendInfoMessage(playerid, 0, "1238", "Al jugador que desea darle un articulo no tiene bolsa");
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "1239", "Usted no tiene bolsa!");
	}
}
DropArticlePlayerToPlayer(playerid, bolsaid)
{
	if ( PlayersData[playerid][HaveBolsa] )
	{
		if ( bolsaid > 0 && bolsaid  < 5 )
		{
		    bolsaid--;
		    if ( PlayersData[playerid][Bolsa][bolsaid] )
		    {
				new MsgGiveArticle[MAX_TEXT_CHAT];
				new MsgGiveArticleME[MAX_TEXT_CHAT];
		        format(MsgGiveArticle, sizeof(MsgGiveArticle), "ha tirado %s al suelo", Articulos[PlayersData[playerid][Bolsa][bolsaid]][NameA]);
		        format(MsgGiveArticleME, sizeof(MsgGiveArticleME), "Tiraste %i %s al suelo.", PlayersData[playerid][BolsaC][bolsaid], Articulos[PlayersData[playerid][Bolsa][bolsaid]][NameA]);
		        Acciones(playerid, 8, MsgGiveArticle);
		        SendInfoMessage(playerid, 2, "0", MsgGiveArticleME);
		        RemoveArticuloBolsa(playerid, bolsaid);
			}
			else
			{
				SendInfoMessage(playerid, 0, "1240", "No tienes nada en esa parte de la bolsa!");
			}
		}
		else
		{
			SendInfoMessage(playerid, 0, "1243", "El numero de Slot de bolsa debe estar comprendido entre 1 y 4");
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "1241", "Usted no tiene bolsa!");
	}
}
EatArticle(playerid, bolsaid)
{
	if ( PlayersData[playerid][HaveBolsa] )
	{
	    if ( GetPlayerInteriorEx(playerid) !=  WORLD_NORMAL )
	    {
			if ( bolsaid > 0 && bolsaid  < 5 )
			{
			    bolsaid--;
			    if ( PlayersData[playerid][Bolsa][bolsaid] )
			    {
			        if ( UseAritcle(playerid, PlayersData[playerid][Bolsa][bolsaid]) )
			        {
		                PlayersData[playerid][BolsaC][bolsaid]--;
		                if ( !PlayersData[playerid][BolsaC][bolsaid] )
		                {
		                    RemoveArticuloBolsa(playerid, bolsaid);
		                    return true;
						}
					}
				}
				else
				{
					SendInfoMessage(playerid, 0, "1257", "No hay nada en esa parte de la bolsa!");
				}
			}
			else
			{
				SendInfoMessage(playerid, 0, "1256", "El numero de Slot de bolsa debe estar comprendido entre 1 y 4");
			}
		}
		else
		{
			SendInfoMessage(playerid, 0, "1369", "Solo puedes usar articulos de la bolsa en interiores.");
		}

	}
	else
	{
		SendInfoMessage(playerid, 0, "1255", "Usted no tiene bolsa!");
	}
	return false;
}
UseAritcle(playerid, articleid)
{
	switch(articleid)
	{
	    case A_CERVEZA:
	    {
	        Acciones(playerid, 8, "abre una cerveza");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE); // CERVEZA
		}
	    case A_VODKA:
	    {
	        Acciones(playerid, 8, "abre una botella vodka");
	        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE); // WINE
		}
	    case A_REFRESCO:
	    {
	        Acciones(playerid, 8, "abre un refresco");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK); // SPUNK
		}
	    case A_POLLO_C:
	    {
	        Acciones(playerid, 8, "come pollo");
		}
	    case A_PAPAS_C:
	    {
	        Acciones(playerid, 8, "come papas");
		}
	    case A_ARROZ_C:
	    {
	        Acciones(playerid, 8, "come arroz");
		}
		default:
		{
			SendInfoMessage(playerid, 0, "1260", "Este articulo no se puede usar!");
			return false;
		}
	}
    SetPlayerHealthEx(playerid, Articulos[A_POLLO_C][Vida]);
	return true;
}
