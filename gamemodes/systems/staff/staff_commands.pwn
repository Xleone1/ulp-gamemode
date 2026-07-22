SetPlayerJail(playerid)
{
	ResetPlayerWeaponsEx(playerid);
	SetPlayerPos(playerid,
	JailsType[PlayersData[playerid][IsInJail]][PosX_Preso],
	JailsType[PlayersData[playerid][IsInJail]][PosY_Preso],
	JailsType[PlayersData[playerid][IsInJail]][PosZ_Preso]);
	SetPlayerFacingAngle(playerid, 	JailsType[PlayersData[playerid][IsInJail]][PosZZ_Preso]);
	SetPlayerInteriorEx(playerid, JailsType[PlayersData[playerid][IsInJail]][Interior_Preso]);
	SetSpawnInfo(playerid, -1, PlayersData[playerid][Skin],
	JailsType[PlayersData[playerid][IsInJail]][PosX_Liberado],
	JailsType[PlayersData[playerid][IsInJail]][PosY_Liberado],
	JailsType[PlayersData[playerid][IsInJail]][PosZ_Liberado],
	JailsType[PlayersData[playerid][IsInJail]][PosZZ_Liberado], WEAPON:0, 0, WEAPON:0, 0, WEAPON:0, 0);
    SetCameraBehindPlayer(playerid);
    SetPlayerVirtualWorldEx(playerid, WORLD_DEFAULT_INTERIOR);
}

SetPlayerSpectateToPlayer(playerid, spectateplayerid)
{
	if (PlayersDataOnline[playerid][Espectando] == -1 )
    {
        PlayersDataOnline[playerid][Spawn]      = false;
        GetSpawnInfoEx(playerid);
		PlayersDataOnline[playerid][StateDeath] = true;
		TogglePlayerSpectating(playerid, true);
	}
	else
	{
		new IdLast = PlayersDataOnline[playerid][Espectando];
		PlayersDataOnline[spectateplayerid][IsEspectando] = true;
		CheckSpectToPlayer(IdLast);
	}
    PlayersDataOnline[playerid][Espectando] = spectateplayerid;
    SetPlayerVirtualWorldEx(playerid, GetPlayerVirtualWorld(spectateplayerid));
    SetPlayerInteriorEx(playerid, GetPlayerInteriorEx(spectateplayerid));
    if ( IsPlayerInAnyVehicle(spectateplayerid) && PlayersDataOnline[playerid][EspectVehOrPlayer])
    {
        PlayersDataOnline[playerid][EspectVehOrPlayer] = false;
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(spectateplayerid));
	}
	else
	{
        PlayersDataOnline[playerid][EspectVehOrPlayer] = true;
		PlayerSpectatePlayer(playerid, spectateplayerid);
	}
	if ( PlayersData[spectateplayerid][Admin] == 9 )
	{
	    new MsgPerNivel9[MAX_TEXT_CHAT];
	    format(MsgPerNivel9, sizeof(MsgPerNivel9), "%s %s esta espectado a %s", LOGO_STAFF, PlayersDataOnline[playerid][NameOnlineFix], PlayersDataOnline[spectateplayerid][NameOnlineFix]);
	    MsgCheatsReportsToAdminsEx(MsgPerNivel9, 9);
	}
}
RemoveSpectatePlayer(playerid)
{
	if ( PlayersDataOnline[playerid][Espectando] != -1 )
	{
        PlayersDataOnline[playerid][Spawn]      = true;
		PlayersDataOnline[playerid][StateDeath] = true;
    	TogglePlayerSpectating(playerid, false);
    	SetSpawnInfoEx(playerid);
    	CheckSpectToPlayer(PlayersDataOnline[playerid][Espectando]);
	    PlayersDataOnline[playerid][Espectando] = -1;
	    return true;
	}
	else
	{
	    return false;
	}
}
CheckSpectToPlayer(playerid)
{
	for ( new i = 0; i < MAX_PLAYERS; i++)
	{
	    if ( PlayersDataOnline[i][Espectando] == playerid )
	    {
			PlayersDataOnline[playerid][IsEspectando] = true;
			return true;
		}
	}
	PlayersDataOnline[playerid][IsEspectando] = false;
	return true;
}
UpdateSpectatedPlayers(playerid, death, interiorid, world)
{
	for ( new i = 0; i < MAX_PLAYERS; i++)
	{
	    if ( PlayersDataOnline[i][Espectando] == playerid )
	    {
	        if ( !death )
	        {
			    SetPlayerVirtualWorldEx(i, world);
			    SetPlayerInteriorEx(i, interiorid);
	    		PlayerSpectatePlayer(i, playerid);
			}
			else
			{
	        	RemoveSpectatePlayer(i);
			}
		}
	}
}
NextPlayerSpect(playerid)
{
	if ( PlayersDataOnline[playerid][Espectando] != -1 )
	{
		new i = PlayersDataOnline[playerid][Espectando] + 1;
		if ( i > 499 )
		{
		    i = 0;
		}
		for (; i < MAX_PLAYERS; i++)
		{
			if ( i == PlayersDataOnline[playerid][Espectando] )
			{
			    return true;
			}
			if ( i != playerid && IsPlayerConnected(i) && PlayersDataOnline[i][StateDeath] != 2 )
			{
			    SetPlayerSpectateToPlayer(playerid, i);
			    return true;
			}
			if ( i == 499 )
			{
			    i = -1;
			}
		}
	}
	return false;
}
LastPlayerSpect(playerid)
{
	if ( PlayersDataOnline[playerid][Espectando] != -1 )
	{
		new i = PlayersDataOnline[playerid][Espectando] - 1;
		if ( i < 0 )
		{
		    i = 499;
		}
		for (; i < MAX_PLAYERS; i--)
		{
			if ( i == PlayersDataOnline[playerid][Espectando] )
			{
			    return true;
			}
			if ( i != playerid && IsPlayerConnected(i) && PlayersDataOnline[i][StateDeath] != 2)
			{
			    SetPlayerSpectateToPlayer(playerid, i);
			    return true;
			}
			if ( i == 0 )
			{
			    i = 500;
			}
		}
	}
	return false;
}


MsgAdminUseCommands(level, playerid, const commands[])
{
	if ( PlayersData[playerid][Admin] != 9 )
	{
	    new MsgPerNivel9[256];
	    if ( PlayersData[playerid][Admin] )
	    {
	    	format(MsgPerNivel9, sizeof(MsgPerNivel9), "{A49C00}%s %s[%i] ha usado el comando: %s", LOGO_STAFF, PlayersDataOnline[playerid][NameOnlineFix], playerid, commands);
	   	}
	   	else
	   	{
	    	format(MsgPerNivel9, sizeof(MsgPerNivel9), "{A49C00}%s %s[%i] {B90000}(NO ES ADMIN) {A49C00}ha usado el comando: %s", LOGO_STAFF, PlayersDataOnline[playerid][NameOnlineFix], playerid, commands);
	   	}
		for (new e = 0; e < MAX_PLAYERS; e++)
		{
		    if ( IsPlayerConnected(e) && PlayersData[e][Admin] == level && PlayersDataOnline[e][State] == 3 && PlayersDataOnline[e][SendCommands] )
		    {
		        SendClientMessage(e, COLOR_CHEATS_REPORTES, MsgPerNivel9);
		    }
	    }
		printf("%s", MsgPerNivel9);
	}
}
MsgCheatsReportsToAdminsEx(const text[], level)
{
	for (new e = 0; e < MAX_PLAYERS; e++)
	{
	    if ( IsPlayerConnected(e) && PlayersData[e][Admin] == level && PlayersDataOnline[e][State] == 3 )
	    {
	        SendClientMessage(e, COLOR_CHEATS_REPORTES, text);
	    }
    }
	printf("%s", text);
}
MsgCheatsReportsToAdmins(const text[])
{
	for (new e = 0; e < MAX_PLAYERS; e++)
	{
	    if ( IsPlayerConnected(e) && PlayersData[e][Admin] >= 1 && PlayersDataOnline[e][State] == 3)
	    {
	        SendClientMessage(e, COLOR_CHEATS_REPORTES, text);
	    }
    }
	printf("%s", text);
}
MsgKBJWReportsToAdmins(playerid, const text[])
{
	for (new e = 0; e < MAX_PLAYERS; e++)
	{
	    if ( IsPlayerConnected(e) && PlayersDataOnline[e][State] == 3 && ( PlayersData[e][Admin] >= 1 || playerid == e ) )
	    {
	        SendClientMessage(e, COLOR_KICK_JAIL_BAN, text);
	    }
    }
	printf("%s", text);
}
MsgHelperChat(const text[])
{
	for (new e = 0; e < MAX_PLAYERS; e++)
	{
	    if ( IsPlayerConnected(e) && PlayersDataOnline[e][State] == 3 && (PlayersData[e][Ayudante] || PlayersData[e][Admin]) )
	    {
	        SendClientMessage(e, COLOR_MESSAGES[0], text);
	    }
    }
}
AreHelpersOnline()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && (PlayersData[i][Ayudante] || PlayersData[i][Admin]))
		{
			return true;
		}
	}
	return false;
}
ShowDudasDialog(playerid)
{
	ShowPlayerDialogEx(playerid,136,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Envianos tu duda", "{"COLOR_TEXTO_DIALOGS"}Recuerde que puede consultar cualquier comando en {"COLOR_VERDE"}/Ayuda", "Enviar", "Salir");
}
Comandos_Admin(Comando, playerid, playeridAC, LV, Cantidad_o_Tipo, const String[])
{
	///////// COMANDOS DE LA ADMINISTRACION
	switch (Comando)
	{
	    //		/ADMINON                		- Activarse como Admin
	    case 1:
	    {
	        SetPlayerColor(playerid, 0x0FFF00FF); // VERDE FOFORESENTE
			return 1;
		//		/A [TEXTO]              		- Canal de la administracion
        }
        case 2:
        {

			new StringFormat[120];
			format(StringFormat, sizeof(StringFormat), "%s %s: %s",LOGO_STAFF, PlayersDataOnline[playerid][NameOnline], String);

			for (new i = 0; i < MAX_PLAYERS; i++)
			{
			    if ( IsPlayerConnected(i) && PlayersData[i][Admin] >= 1 && PlayersDataOnline[i][State] == 3 )
			    {
			        SendClientMessage(i, COLOR_OWNED_CHAT, StringFormat);
			    }
		    }
		    print(StringFormat);
			return 1;
        }
        //      /VIDA [ID]						- Llevar la vida a un jugador
        case 3:
        {
			new StringFormat[120];
			format(StringFormat, sizeof(StringFormat), "%s Has llenado la vida a %s[%i].", LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], playeridAC);
			SetPlayerHealthEx(playeridAC, 100);
			if (playerid != playeridAC)
			{
                SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormat);
   	        }
   	        else
   	        {
   	            new msglife[120];
   	            format(msglife, sizeof(msglife), "%s Te has llenado la vida Tu mismo.", LOGO_STAFF);
   	        	SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, msglife);
   	        }

	       	return 1;
        }
        // 		/CHALECO [ID]					- Llenar el chaleco a un jugador
        case 4:
  		{
			new StringFormat[120];
			format(StringFormat, sizeof(StringFormat), "%s Has llenado el chaleco a %s[%i].", LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], playeridAC);

			SetPlayerArmourEx(playeridAC, 85);
			if (playerid != playeridAC)
			{
                SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormat);
   	        }
   	        else
   	        {
   	            new msgammon[120];
   	            format(msgammon, sizeof(msgammon), "%s Te has llenado el chaleco Tu mismo.", LOGO_STAFF);
   	        	SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, msgammon);
   	        }

			return 1;
        }
        // 		/ESPECTAR [ID]					- Espectar a un jugador
        case 5:
        {       // 01 - Espectando
                // 02 - Desactivar espectar
            if (Cantidad_o_Tipo == 1)
            {
				SetPlayerSpectateToPlayer(playerid, playeridAC);
			}
			else if (Cantidad_o_Tipo == 2)
			{
			    if ( !RemoveSpectatePlayer(playerid) )
			    {
	    			SendInfoMessage(playerid, 0, "214", "No estas espectando a nadie, el comando [/Espectar] sin ID, indica volver a tu posicion.");
			    }
			}
			return 1;
        }
        // 		/JAIL [ID] [RAZON]				- Jaliar a un jugador
        case 6:
        {
			new StringFormat[350];
			new StringFormatEX[350];
			if ( PlayersData[playeridAC][Jail] == 0 )
			{
				format(StringFormat, sizeof(StringFormat), "%s Han jaliado %i minutos a %s por %s. Razon: %s",LOGO_STAFF, Cantidad_o_Tipo, PlayersDataOnline[playeridAC][NameOnline], PlayersDataOnline[playerid][NameOnline], String);
				format(StringFormatEX, sizeof(StringFormatEX), "%s Has jaliado a %s[%i].",LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], playeridAC);
			}
			else if ( Cantidad_o_Tipo != 0)
			{
				format(StringFormat, sizeof(StringFormat), "%s Han modificado el jail de %s a %i minutos por %s. Razon: %s",LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], Cantidad_o_Tipo, PlayersDataOnline[playerid][NameOnline], String);
				format(StringFormatEX, sizeof(StringFormatEX), "%s Has modificado el jail de %s[%i].",LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], playeridAC);
			}
			else if ( Cantidad_o_Tipo == 0)
			{
				format(StringFormat, sizeof(StringFormat), "%s Han quitado el jail a %s por %s. Razon: %s",LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], PlayersDataOnline[playerid][NameOnline], String);
				format(StringFormatEX, sizeof(StringFormatEX), "%s Has quitado el jail a %s[%i].",LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], playeridAC);
			}
            MsgKBJWReportsToAdmins(playeridAC, StringFormat);
            SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormatEX);
			ChangeHouseOrOther(playerid, 0);
			PlayersData[playeridAC][Jail] = gettime() + (Cantidad_o_Tipo * 60);
			PlayersData[playeridAC][IsInJail] = 2;
			SetPlayerJail(playeridAC);
        }
		//		/BAN [ID] [Razon]				- Banear a un jugador
        case 8:
        {
			new StringFormat[250];
			new StringFormatEX[100];
			format(StringFormat, sizeof(StringFormat), "%s Han baneado a %s por %s. Razon: %s",LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], PlayersDataOnline[playerid][NameOnline], String);
			format(StringFormatEX, sizeof(StringFormatEX), "%s Has baneado a %s[%i].",LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], playeridAC);
            MsgKBJWReportsToAdmins(playeridAC, StringFormat);
            SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormatEX);
            SendClientMessage(playeridAC, COLOR_MENSAJES_DE_AVISOS, "Ayuda: Recuerda sacar una Screen/Foto en este momento presionando la tecla \"F8\" sera de mucha ayuda en su desban.");

			PlayersData[playeridAC][AccountState] = 3;
			BanEx(playeridAC, StringFormat);

            return 1;
        }
		// /REVISAR [ID]					- Revisar a un jugador
        case 9:
        {
   			new StringFormat9[350];
            new Float:Chaleco1;
   		    new Float:Vida1;
   		    new IPName[30];
			new WEAPON:Armas[13][2];
			for (new i = 0; i < 13; i++)
			{
				GetPlayerWeaponData(playeridAC, WEAPON_SLOT:i, Armas[i][0], Armas[i][1]);
				format(StringFormat9, sizeof(StringFormat9), "SLOT [%i] Arma: %s || Municion: %i", i, SlotNameWeapon[Armas[i][0]], Armas[i][1]);
				SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormat9);
			}
			GetPlayerHealth(playeridAC, Vida1);
			GetPlayerArmour(playeridAC, Chaleco1);
			GetPlayerIp(playeridAC, IPName, sizeof(IPName));

			format(StringFormat9, sizeof(StringFormat9), "ID: [%i] || Nombre: %s || IP: %s ||Vida: %.2f || Chaleco: %.2f",
			playeridAC,
			PlayersDataOnline[playeridAC][NameOnline],
			IPName,
			Vida1,
			Chaleco1);
			SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormat9);
			format(StringFormat9, sizeof(StringFormat9), "Dinero: %i || Banco: %i || faccion: %s || Rango: %s",
			GetPlayerMoney(playeridAC),
			PlayersData[playeridAC][Banco],
			FaccionData[PlayersData[playeridAC][Faccion]][NameFaccion],
			FaccionesRangos[PlayersData[playeridAC][Faccion]][PlayersData[playeridAC][Rango]]);
			SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormat9);
			return 1;
        }
		// 		/TRAER [ID]						- Traer un jugador a tu posicion
        case 10:
        {
			new StringFormat[120];
			new StringFormatEX[100];
			format(StringFormat, sizeof(StringFormat), "%s %s te ha teletrasportado a su posicion.",LOGO_STAFF, PlayersDataOnline[playerid][NameOnline]);
			format(StringFormatEX, sizeof(StringFormatEX), "%s Has traido hacia a ti a %s [%i]",LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], playeridAC);

			new Float:acX, Float:acY, Float:acZ;
			GetPlayerPos(playerid, acX, acY, acZ);
			if ( IsPlayerInAnyVehicle(playeridAC) && GetPlayerVehicleSeat(playeridAC) == 0)
			{
				new CocheTraer = GetPlayerVehicleID(playeridAC);
				SetVehiclePos(CocheTraer, acX, acY + 2, acZ + 1);
				LinkVehicleToInterior(CocheTraer, GetPlayerInteriorEx(playerid));
				SetVehicleVirtualWorldEx(CocheTraer, GetPlayerVirtualWorld(playerid));
				
				for (new j=0, k=GetPlayerPoolSize(); j <= k; j++)
				{
				    if ( IsPlayerConnected(j) && IsPlayerInVehicle(j, CocheTraer))
				    {
			        	SetPlayerVirtualWorldEx(j, GetPlayerVirtualWorld(playerid));
			        	SetPlayerInteriorEx(j, GetPlayerInteriorEx(playerid));
				    }
				}
			}
			else
			{
			    if (IsPlayerInAnyVehicle(playeridAC))
			    {
				    PlayersDataOnline[playeridAC][StateMoneyPass] 	= gettime() + 5;
				}
				SetPlayerPos(playeridAC, acX, acY + 2, acZ + 1);
			}

			PlayersData[playeridAC][IsPlayerInBizz] = PlayersData[playerid][IsPlayerInBizz];
			ChangeHouseOrOther(playeridAC, PlayersData[playerid][IsPlayerInHouse]);
			PlayersData[playeridAC][IsPlayerInBank] = PlayersData[playerid][IsPlayerInBank];
			PlayersData[playeridAC][IsPlayerInGarage] = PlayersData[playerid][IsPlayerInGarage];
			PlayersData[playeridAC][IsPlayerInVehInt] = PlayersData[playerid][IsPlayerInVehInt];

			SetPlayerInteriorEx(playeridAC, GetPlayerInteriorEx(playerid));
			SetPlayerVirtualWorldEx(playeridAC, GetPlayerVirtualWorld(playerid));

            SendClientMessage(playeridAC, COLOR_MENSAJES_DE_AVISOS, StringFormat);
            SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormatEX);
			return 1;
        }
		//		/IR [ID]						- Ir a la poicion de un jugador
        case 11:
        {
			new StringFormat[120];
			new StringFormatEX[100];
			format(StringFormat, sizeof(StringFormat), "%s %s se ha teletrasportado a tu posicion.",LOGO_STAFF, PlayersDataOnline[playerid][NameOnline]);
			format(StringFormatEX, sizeof(StringFormatEX), "%s Has ido hacia %s [%i]",LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], playeridAC);


            new Float:meX, Float:meY, Float:meZ;
			GetPlayerPos(playeridAC, meX, meY, meZ);

			if ( IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0)
			{
				new CocheTraer = GetPlayerVehicleID(playerid);
				SetVehiclePos(CocheTraer, meX, meY + 2, meZ + 1);
				LinkVehicleToInterior(CocheTraer, GetPlayerInteriorEx(playeridAC));
				SetVehicleVirtualWorldEx(CocheTraer, GetPlayerVirtualWorld(playeridAC));

				for (new j=0, k=GetPlayerPoolSize(); j <= k; j++)
				{
				    if ( IsPlayerConnected(j) && IsPlayerInVehicle(j, CocheTraer))
				    {
			        	SetPlayerVirtualWorldEx(j, GetPlayerVirtualWorld(playeridAC));
			        	SetPlayerInteriorEx(j, GetPlayerInteriorEx(playeridAC));
				    }
				}
			}
			else
			{
			    if (IsPlayerInAnyVehicle(playerid))
			    {
				    PlayersDataOnline[playerid][StateMoneyPass] 	= gettime() + 5;
				}
				SetPlayerPos(playerid, meX, meY + 2, meZ + 1);
			}

			PlayersData[playerid][IsPlayerInBizz] = PlayersData[playeridAC][IsPlayerInBizz];
			ChangeHouseOrOther(playerid, PlayersData[playeridAC][IsPlayerInHouse]);
			PlayersData[playerid][IsPlayerInBank] = PlayersData[playeridAC][IsPlayerInBank];
			PlayersData[playerid][IsPlayerInGarage] = PlayersData[playeridAC][IsPlayerInGarage];
			PlayersData[playerid][IsPlayerInVehInt] = PlayersData[playeridAC][IsPlayerInVehInt];


            SetPlayerInteriorEx(playerid, GetPlayerInteriorEx(playeridAC));
			SetPlayerVirtualWorldEx(playerid, GetPlayerVirtualWorld(playeridAC));

            SendClientMessage(playeridAC, COLOR_MENSAJES_DE_AVISOS, StringFormat);
            SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormatEX);
			return 1;
        }
		//		/LIMPIAR[ID]                   - Quitar todas las armas a un jugador
		case 12:
		{
			new StringFormat[120];
			new StringFormatEX[100];
			format(StringFormat, sizeof(StringFormat), "%s %s te ha limpiado todas las armas.",LOGO_STAFF, PlayersDataOnline[playerid][NameOnline]);
			format(StringFormatEX, sizeof(StringFormatEX), "%s Has limpiado a %s [%i]",LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], playeridAC);
            SendClientMessage(playeridAC, COLOR_MENSAJES_DE_AVISOS, StringFormat);
            SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormatEX);

            ResetPlayerWeaponsEx(playeridAC);
			// si tenia el taser toggleado, lo apagamos para no quedar inconsistente
			if ( PlayersDataOnline[playeridAC][IsTaserEquipped] )
			{
				PlayersDataOnline[playeridAC][IsTaserEquipped] = false;
				PlayersDataOnline[playeridAC][TaserSavedWeapon] = 0;
				PlayersDataOnline[playeridAC][TaserSavedAmmo] = 0;
			}

            return 1;
		}
		//		/Matar [ID]                - Matar a un jugador
		case 14:
		{
			new StringFormat[120];
			new StringFormatEX[100];

			if ( playeridAC != playerid)
			{
				format(StringFormat, sizeof(StringFormat), "%s te ha matado %s con el comando /Matar [ID].",LOGO_STAFF, PlayersDataOnline[playerid][NameOnline]);
				format(StringFormatEX, sizeof(StringFormatEX), "%s has matado a %s [%i] con el comando /Matar [ID].",LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], playeridAC);
	            SendClientMessage(playeridAC, COLOR_MENSAJES_DE_AVISOS, StringFormat);
			}
			else
			{
				format(StringFormatEX, sizeof(StringFormatEX), "%s Te has matado Tu mismo con el comando /Matar [ID].",LOGO_STAFF);
			}

            SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormatEX);

			// Asignamos 0 de vida para matar a el jugador
			SetPlayerHealthEx(playeridAC, -100);
			return 1;
		}
		//		/Estado Todos [ID]                 		- Cerrar y Abrir el canal /o (Todos)
		case 15:
		{
			new MensajeCanalTodosCerradoAbierto[50];
			new MensajeATodos[70];

			if ( !CanalOOC )
			{
			    CanalOOC = true;
		        format(MensajeCanalTodosCerradoAbierto, sizeof(MensajeCanalTodosCerradoAbierto), "%s Has abierto el canal /O (OOC).", LOGO_STAFF);
				format(MensajeATodos, sizeof(MensajeATodos), "%s El canal /O (OOC) ha sido abierto.", LOGO_STAFF);
 			}
 			else if  ( CanalOOC  )
 			{
				CanalOOC = false;
		        format(MensajeCanalTodosCerradoAbierto, sizeof(MensajeCanalTodosCerradoAbierto), "%s Has cerrado el canal /O (OOC).", LOGO_STAFF);
				format(MensajeATodos, sizeof(MensajeATodos), "%s El canal /O (OOC) ha sido cerrado.", LOGO_STAFF);
 			}

	        SendClientMessageToAll(COLOR_MENSAJES_DE_AVISOS, MensajeATodos);
	        SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, MensajeCanalTodosCerradoAbierto);

			return 1;
		}
		//      /Estado Wisper                  - Cierra y Abre los wisper
		case 16:
		{
			new MensajeWisperCerradoAbierto[50];
			if ( PlayersDataOnline[playerid][Wispers] )
			{
			    PlayersDataOnline[playerid][Wispers] = false;
		        format(MensajeWisperCerradoAbierto, sizeof(MensajeWisperCerradoAbierto), "%s Has cerrado los whispers.", LOGO_STAFF);
 			}
 			else if  ( !PlayersDataOnline[playerid][Wispers] )
 			{
				PlayersDataOnline[playerid][Wispers] = true;
		        format(MensajeWisperCerradoAbierto, sizeof(MensajeWisperCerradoAbierto), "%s Has abierto los whispers.", LOGO_STAFF);
 			}
	        SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, MensajeWisperCerradoAbierto);
	        return 1;
  		}
		// 		/VER							- Ver los miembros del Staff que esten Online
		case 17:
		{
		    new StringFormat[120];

			for (new i = 0; i < MAX_PLAYERS; i++)
			{
			    if ( IsPlayerConnected(i) && ( PlayersData[i][Admin] >= 1 && PlayersData[i][Admin] <= 8 && PlayersData[playerid][Admin] <= 8 || PlayersData[i][Admin] >= 1 && PlayersData[playerid][Admin] == 9 ) )
			    {
					format(StringFormat, sizeof(StringFormat), "%s %s Nivel(%i) [%i] Owned conectado!",LOGO_STAFF, PlayersDataOnline[i][NameOnline], PlayersData[i][Admin], i);
		            SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS,  StringFormat);
				}
		    }
		    return 1;
		}
		// 		/RESPAWN [ID]					- Respawear un coche
		case 18:
		{
			new StringFormat[120];
			format(StringFormat, sizeof(StringFormat), "%s Has echo spawn a un vehiculo con ID[%i].",LOGO_STAFF, DataCars[Cantidad_o_Tipo][VehicleID]);
            SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormat);

          	SetVehicleToRespawnExTwo(Cantidad_o_Tipo);
          	return 1;
		}
		//		/RESPAWN TODOS					- Respawear todos los coches
		case 19:
		{
			new StringFormat[120];
			format(StringFormat, sizeof(StringFormat), "%s Has echo un respawn general.",LOGO_STAFF);
            SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormat);

			new IsRespawn[MAX_VEHICLE_COUNT];
			for (new i = 0; i < MAX_PLAYERS; i++)
			{
				if( IsPlayerConnected(i) == true && IsPlayerInAnyVehicle(i) == true && GetPlayerVehicleSeat(i) == 0 )
				{
				    IsRespawn[GetPlayerVehicleID(i)] = 1;
				}
			}

			for (new i = 0; i < MAX_CAR; i++)
			{
			    if ( IsRespawn[i] != 1 )
			    {
					SetVehicleToRespawnExTwo(i);
				}
		    }

		    return 1;
		}
		//		/Clima [Tipo]					- Cambiar el clima
		case 20:
		{
			new StringFormat[120];
			format(StringFormat, sizeof(StringFormat), "%s Has cambiado el clima a ID[%i].", LOGO_STAFF, Cantidad_o_Tipo);
            SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormat);

            SetWeather(Cantidad_o_Tipo);
            WeatherCurrent = Cantidad_o_Tipo;

            return 1;
		}
		//		/MsgEX [Estilo] [Texto]         - Mensaje EX
		case 21:
		{
			GameTextForAll( String, 5000, Cantidad_o_Tipo);
			return 1;
		}
		//		/Staff [ID] [Nivel]				- Dar un nivel a un miembro de el Staff
		case 22:
		{
			new StringFormat[120];
			new StringFormatEX[100];

   		    if (PlayersData[playeridAC][Admin] == 0)
   		    {
				format(StringFormat, sizeof(StringFormat), "%s %s ahora estas Owned! Welcome to the Team!.", LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline]);
				format(StringFormatEX, sizeof(StringFormatEX), "%s Has metido a ser parte del Staff a %s [%i] con nivel %i ",LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], playeridAC, Cantidad_o_Tipo);
			}
			else if (Cantidad_o_Tipo == 0)
			{
				format(StringFormatEX, sizeof(StringFormatEX), "%s has expulsado del Staff a %s [%i] ", LOGO_STAFF, PlayersDataOnline[playeridAC][NameOnline], Cantidad_o_Tipo);
  				format(StringFormat, sizeof(StringFormat), "%s %s Te ha expulsado del Staff!", LOGO_STAFF, PlayersDataOnline[playerid][NameOnline]);
			}
			else
			{
				format(StringFormatEX, sizeof(StringFormatEX), "%s Has asignado el nivel %i a %s [%i] ", LOGO_STAFF, Cantidad_o_Tipo, PlayersDataOnline[playeridAC][NameOnline], playeridAC);
  				format(StringFormat, sizeof(StringFormat), "%s %s te han asignado el nivel %i de Staff", LOGO_STAFF, PlayersDataOnline[playerid][NameOnline], Cantidad_o_Tipo);
			}

			PlayersData[playeridAC][Admin] = Cantidad_o_Tipo;
            SendClientMessage(playeridAC, COLOR_MENSAJES_DE_AVISOS, StringFormat);
            SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormatEX);

            return 1;
		}
	}
	// LOGO_STAFF

	//COLOR_OWNED_CHAT
	//COLOR_MENSAJES_DE_AVISOS
	//COLOR_KICK_JAIL_BAN
    return LV;
}