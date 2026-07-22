ShowMenuDMWeapon(playerid)
{
	new CallDialog[1200];
	new TempConvert[45];
	new ConteoCall = -1;
	for (new i = 0; i < 47; i++)
	{
	    if(i!=19&&i!=20&&i!=21)
	    {
	        if ( WeaponEnableDM[i] )
	        {
				if ( ConteoCall != -1 )
				{
			    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_VERDE"}%s (%i)",
					SlotNameWeapon[i],
					SlotIDWeapon[i]
					);
		    	}
				else
				{
			    	format(TempConvert, sizeof(TempConvert), "{"COLOR_VERDE"}%s (%i)",
				    SlotNameWeapon[i],
				    SlotIDWeapon[i]
					);
				}
			}
			else
			{
				if ( ConteoCall != -1 )
				{
			    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_ROJO"}%s (%i)",
					SlotNameWeapon[i],
					SlotIDWeapon[i]
					);
		    	}
				else
				{
			    	format(TempConvert, sizeof(TempConvert), "{"COLOR_ROJO"}%s (%i)",
				    SlotNameWeapon[i],
				    SlotIDWeapon[i]
					);
				}
			}
	        strcat(CallDialog, TempConvert, sizeof(CallDialog));
	        ConteoCall++;
        }
	}
	ShowPlayerDialogEx(playerid,67,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}DeathMatch Mode - Armas permitidas", CallDialog, "Seleccionar", "Salir");
}

IsWeaponDmExist(weaponid)
{
	for (new i = 0; i < 47; i++)
	{
	    if ( weaponid != i && SlotIDWeapon[weaponid] == SlotIDWeapon[i] && WeaponEnableDM[i] )
	    {
	        WeaponEnableDM[i] = false;
		    return true;
		}
	}
    return false;
}

UpdateTextDrawDM(teamid)
{
	new FreePoints[3]; FreePoints[0] = -1; FreePoints[1] = -1; FreePoints[2] = -1;
	new TotalPointsDM;
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && PlayersDataOnline[i][ModeDM] && PlayersDataOnline[i][TeamDM] == teamid)
		{
		   	TotalPointsDM += PlayersDataOnline[i][PointDm];
		    for ( new s = 0; s < 3; s++ )
			{
				if ( FreePoints[s] != -1 )
				{
					if ( PlayersDataOnline[i][PointDm] > PlayersDataOnline[FreePoints[s]][PointDm] )
					{
					    if ( s == 0 )
					    {
                        	FreePoints[2] = FreePoints[1];
                        	FreePoints[1] = FreePoints[0];
                        	FreePoints[0] = i;
                       	}
					    else if ( s == 1 )
					    {
                        	FreePoints[2] = FreePoints[1];
                        	FreePoints[1] = i;
                       	}
					    else if ( s == 2 )
					    {
                        	FreePoints[2] = i;
                       	}
	    				break;
					}
				}
				else
				{
				    FreePoints[s] = i;
    				break;
				}
			}
		}
	}
	new FreePositions[3][MAX_PLAYER_NAME + 10];
	format(FreePositions[0], MAX_PLAYER_NAME, "]Nadie]");
	format(FreePositions[1], MAX_PLAYER_NAME, "]Nadie]");
	format(FreePositions[2], MAX_PLAYER_NAME, "]Nadie]");
    for ( new i = 0; i < 3; i++ )
	{
		if ( FreePoints[i] != -1 )
		{
			format(FreePositions[i], MAX_PLAYER_NAME + 10, "%s ~W~(%i)", PlayersDataOnline[FreePoints[i]][NameOnline], PlayersDataOnline[FreePoints[i]][PointDm]);
		}
	}
	new TextForDMTextDraw[300];
	if ( teamid )
	{
		format(TextForDMTextDraw, sizeof(TextForDMTextDraw), "              ~R~Equipo %i~N~~W~Jugador   ~G~Puntos~N~~R~%s~N~~Y~%s~N~~P~%s~N~~N~~G~Total: ~W~%i", teamid + 1, FreePositions[0], FreePositions[1], FreePositions[2], TotalPointsDM);
	}
	else
	{
		format(TextForDMTextDraw, sizeof(TextForDMTextDraw), "              ~B~Equipo %i~N~~W~Jugador   ~G~Puntos~N~~R~%s~N~~Y~%s~N~~P~%s~N~~N~~G~Total: ~W~%i", teamid + 1, FreePositions[0], FreePositions[1], FreePositions[2], TotalPointsDM);
	}
	TextDrawSetString(ModeDMTextDraw[teamid], TextForDMTextDraw);
}

AddPlayerToDM(playerid, teamid)
{
	if ( SkinDM[PlayersDataOnline[playerid][TeamDM]] )
	{
		SetPlayerSkin(playerid, SkinDM[PlayersDataOnline[playerid][TeamDM]]);
	}
	ResetPlayerWeaponsEx(playerid);
	TextDrawShowForPlayer(playerid, ModeDMTextDraw[0]);
	TextDrawShowForPlayer(playerid, ModeDMTextDraw[1]);
	PlayersDataOnline[playerid][ModeDM] = true;
	PlayersDataOnline[playerid][TeamDM] = teamid;

	UpdateTextDrawDM(0);
	UpdateTextDrawDM(1);
}

RemovePlayerToDM(playerid)
{
	if ( SkinDM[PlayersDataOnline[playerid][TeamDM]] )
	{
		SetPlayerSkin(playerid, PlayersData[playerid][Skin]);
	}
	ResetPlayerWeaponsEx(playerid);
	TextDrawHideForPlayer(playerid, ModeDMTextDraw[0]);
	TextDrawHideForPlayer(playerid, ModeDMTextDraw[1]);
	PlayersDataOnline[playerid][ModeDM] = false;
	PlayersDataOnline[playerid][PointDm] = false;
	UpdateSpawnPlayer(playerid);

	UpdateTextDrawDM(0);
	UpdateTextDrawDM(1);
}

SendMessageDeathMatch(playerid)
{
	new MsgGameText[MAX_TEXT_CHAT];
	switch ( random(8) )
	{
	    case 0:
	    {
			format(MsgGameText, sizeof(MsgGameText), "~>~~>~ ~r~Asesino ~<~~<~");
		}
	    case 1:
	    {
			format(MsgGameText, sizeof(MsgGameText), "~>~~>~ ~r~Criminal ~<~~<~");
		}
	    case 2:
	    {
			format(MsgGameText, sizeof(MsgGameText), "~>~~>~ ~r~Homicida ~<~~<~");
		}
	    case 3:
	    {
			format(MsgGameText, sizeof(MsgGameText), "~>~~>~ ~r~Playa ~<~~<~");
		}
	    case 4:
	    {
			format(MsgGameText, sizeof(MsgGameText), "~>~~>~ ~r~Owned ~<~~<~");
		}
	    case 5:
	    {
			format(MsgGameText, sizeof(MsgGameText), "~>~~>~ ~r~POwned ~<~~<~");
		}
	    case 6:
	    {
			format(MsgGameText, sizeof(MsgGameText), "~>~~>~ ~r~LOL ~<~~<~");
		}
	    case 7:
	    {
			format(MsgGameText, sizeof(MsgGameText), "~>~~>~ ~r~Serial Kill ~<~~<~");
		}
	}
	GameTextForPlayer(playerid, MsgGameText, 500, 5);
}

SendMessageToPlayerDeathMatch(playerid, killerid)
{
    new MsgDMToAll[MAX_TEXT_CHAT];
    format(MsgDMToAll, sizeof(MsgDMToAll), "{"COLOR_VERDE"}*** DeathMatch: {"COLOR_ROJO"}%s mató a %s.", PlayersDataOnline[killerid][NameOnlineFix], PlayersDataOnline[playerid][NameOnlineFix]);
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
	    if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && PlayersDataOnline[i][ModeDM] )
	    {
			SendClientMessage(i, COLOR_MENSAJES_DE_AVISOS, MsgDMToAll);
	    }
    }
}