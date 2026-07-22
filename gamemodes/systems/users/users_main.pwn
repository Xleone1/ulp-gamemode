#include "systems/users/users_data.pwn"
#include "systems/users/users_utils.pwn"

// forward: users_api.pwn se incluye despues (desde s_main.pwn).
// necesitamos llamarlas desde SaveDatosPlayerDisconnect.
forward bool:UsersApi_IsEnabled();
forward usersApi_SaveCharacter(playerid);

DataUserClean(playerid)
{
	if ( !PlayersDataOnline[playerid][MarcaZZ] )
	{
		new MsgAviso[MAX_TEXT_CHAT];
	    format(MsgAviso, sizeof(MsgAviso), "%s Debug Data Error - Jugador: %s[%i] - ID %i.", LOGO_STAFF, PlayersDataOnline[playerid][NameOnline], playerid, gettime());
	    MsgCheatsReportsToAdmins(MsgAviso);
	}
	else
	{
		PlayersDataOnline[playerid][MarcaZZ] = false;
	}
	// DATA USERS
    PlayersData[playerid][EmailTime]  	 = 0;
    format(PlayersData[playerid][Email], 25, "No");
    format(PlayersData[playerid][Password], 25, "0");
    PlayersData[playerid][AccountState] = 0;
    PlayersData[playerid][Spawn_X] 		= 0;
    PlayersData[playerid][Spawn_Y] 		= 0;
    PlayersData[playerid][Spawn_Z] 		= 0;
    PlayersData[playerid][Spawn_ZZ]		= 0;
    PlayersData[playerid][HoursPlaying] = 0;
    PlayersData[playerid][DeahtCount] 	= 0;
    PlayersData[playerid][KilledCount]  = 0;
    PlayersData[playerid][Phone] 		= 0;
    PlayersData[playerid][House] 		= -1;
    PlayersData[playerid][Negocio] 		= 0;
    PlayersData[playerid][Car] 			= -1;
    PlayersData[playerid][Faccion] 		= 0;
    PlayersData[playerid][Rango] 		= 0;
    format(PlayersData[playerid][GirlFreind], MAX_PLAYER_NAME, "No");
    PlayersData[playerid][Bolsillos][0]	= 0;
    PlayersData[playerid][Bolsillos][1]	= 0;
    PlayersData[playerid][Bolsillos][2]	= 0;
    PlayersData[playerid][Bolsillos][3]	= 0;
	PlayersData[playerid][Bolsillos][4]	= 0;

    PlayersData[playerid][Habilidad] 	= 0;
    PlayersData[playerid][Warn]	= 0;
    PlayersData[playerid][Ciudad] 		= 1;
    PlayersData[playerid][Vida] 		= 80;
    PlayersData[playerid][Chaleco] 		= 0;
    PlayersData[playerid][Cansansio]	= 40;
    PlayersData[playerid][Dinero] 		= 0;
    PlayersData[playerid][Banco] 		= 1200;
    PlayersData[playerid][Jail] 		= 0;
    PlayersData[playerid][Admin]		= 0;
    PlayersData[playerid][World]		= 0;
    PlayersData[playerid][Interior]		= 0;
    PlayersData[playerid][Skin]			= 26;
    PlayersData[playerid][Drogas]		= 0;
    PlayersData[playerid][Materiales]	= 0;
    PlayersData[playerid][Lata]			= false;
    PlayersData[playerid][Ganzuas]		= 0;
    PlayersData[playerid][Alquiler]		= -1;
    PlayersData[playerid][Bombas]		= 0;
    PlayersData[playerid][Sexo]			= 0;

    PlayersData[playerid][Idiomas][0]	= false;
    PlayersData[playerid][Idiomas][1]	= false;
    PlayersData[playerid][Idiomas][2]	= false;
    PlayersData[playerid][Idiomas][3]	= false;
    PlayersData[playerid][Idiomas][4]	= false;
    PlayersData[playerid][Idiomas][5]	= false;

    PlayersData[playerid][Licencias][0]	= false;
    PlayersData[playerid][Licencias][1]	= false;
    PlayersData[playerid][Licencias][2]	= false;
    PlayersData[playerid][Licencias][3]	= false;
    PlayersData[playerid][Licencias][4]	= false;
    PlayersData[playerid][Licencias][5]	= false;
    PlayersData[playerid][Licencias][6]	= false;

    PlayersData[playerid][IsInJail]			= -1;
    PlayersData[playerid][Nacer]			= false;
    PlayersData[playerid][TimeRequestBank]	= 0;
    PlayersData[playerid][MyBonus]			= 0;
	PlayersData[playerid][InTutorial]		= false;
    PlayersData[playerid][Edad]				= 0;
    PlayersData[playerid][IsPlayerInHouse]	= false;
    PlayersData[playerid][TimeEquipo]		= 0;
    PlayersData[playerid][SpawnAmigo]		= 0;
    PlayersData[playerid][IsPaga]			= 0;
	format(PlayersData[playerid][MyIP], 16, "0");
    PlayersData[playerid][Job]				= 0;
	PlayersData[playerid][MyStyleWalk]		= 0;
	PlayersData[playerid][Saldo]			= 50;
	PlayersData[playerid][LicenciaPesca]	= 0;
	PlayersData[playerid][IntermitentState]= false;
	PlayersData[playerid][MyStyleTalk]		= 0;
	PlayersData[playerid][IsPlayerInBizz]	= false;
	PlayersData[playerid][IsPlayerInGarage]	= -1;

    PlayersData[playerid][WeaponS][0] 	= WEAPON:0;
    PlayersData[playerid][WeaponS][1] 	= WEAPON:0;
    PlayersData[playerid][WeaponS][2]   = WEAPON:0;
    PlayersData[playerid][WeaponS][3]   = WEAPON:0;
    PlayersData[playerid][WeaponS][4]	= WEAPON:0;
    PlayersData[playerid][WeaponS][5]	= WEAPON:0;
    PlayersData[playerid][WeaponS][6]	= WEAPON:0;
    PlayersData[playerid][WeaponS][7]	= WEAPON:0;
    PlayersData[playerid][WeaponS][8]   = WEAPON:0;
    PlayersData[playerid][WeaponS][9]  	= WEAPON:0;
    PlayersData[playerid][WeaponS][10]   = WEAPON:0;
    PlayersData[playerid][WeaponS][11] 	= WEAPON:0;
    PlayersData[playerid][WeaponS][12] 	= WEAPON:0;
    PlayersData[playerid][AmmoS][0]  = 0;
    PlayersData[playerid][AmmoS][1]  = 0;
    PlayersData[playerid][AmmoS][2]  = 0;
    PlayersData[playerid][AmmoS][3]	 = 0;
    PlayersData[playerid][AmmoS][4]	 = 0;
    PlayersData[playerid][AmmoS][5]	 = 0;
    PlayersData[playerid][AmmoS][6]	 = 0;
    PlayersData[playerid][AmmoS][7]	 = 0;
	PlayersData[playerid][AmmoS][8]	 = 0;
    PlayersData[playerid][AmmoS][9]  = 0;
    PlayersData[playerid][AmmoS][10] = 0;
    PlayersData[playerid][AmmoS][11] = 0;
    PlayersData[playerid][AmmoS][12] = 0;
    PlayersData[playerid][Asignados][0] 	= 0;
    PlayersData[playerid][Asignados][1]		= 0;
    PlayersData[playerid][Asignados][2] 	= 0;
    PlayersData[playerid][Bolsa][0]	= 0;
    PlayersData[playerid][Bolsa][1]	= 0;
    PlayersData[playerid][Bolsa][2]	= 0;
    PlayersData[playerid][Bolsa][3] = 0;
    PlayersData[playerid][BolsaC][0]= 0;
    PlayersData[playerid][BolsaC][1]= 0;
    PlayersData[playerid][BolsaC][2]= 0;
    PlayersData[playerid][BolsaC][3]= 0;
    PlayersData[playerid][HaveBolsa]= false;
    PlayersData[playerid][IsPlayerInVehInt]	= false;
    PlayersData[playerid][Cartera][0]	= 0;
    PlayersData[playerid][Cartera][1]   = 0;
    PlayersData[playerid][Cartera][2]   = 0;
    PlayersData[playerid][Cartera][3]   = 0;
    PlayersData[playerid][Cartera][4]   = 0;
    PlayersData[playerid][Cartera][5]   = 0;
    PlayersData[playerid][CarteraC][0]	= 0;
    PlayersData[playerid][CarteraC][1]  = 0;
    PlayersData[playerid][CarteraC][2]  = 0;
    PlayersData[playerid][CarteraC][3]  = 0;
    PlayersData[playerid][CarteraC][4]  = 0;
    PlayersData[playerid][CarteraC][5]  = 0;
    PlayersData[playerid][CarteraT][0]	= 0;
    PlayersData[playerid][CarteraT][1]  = 0;
    PlayersData[playerid][CarteraT][2]  = 0;
    PlayersData[playerid][CarteraT][3]  = 0;
    PlayersData[playerid][CarteraT][4]  = 0;
    PlayersData[playerid][CarteraT][5]  = 0;
    PlayersData[playerid][AccountBankingOpen] = 0;
    PlayersData[playerid][CarteraI][0]  = 0;
    PlayersData[playerid][CarteraI][1]  = 0;
    PlayersData[playerid][CarteraI][2]  = 0;
    PlayersData[playerid][CarteraI][3]  = 0;
    PlayersData[playerid][CarteraI][4]  = 0;
    PlayersData[playerid][CarteraI][5]  = 0;
	PlayersData[playerid][IsPlayerInBank]= false;
    PlayersData[playerid][AlertSMSBank]	= false;
    PlayersData[playerid][HorasWork]	= 0;
	PlayersData[playerid][CameraLogin]	= 0;
	PlayersData[playerid][Enfermedad]	= 0;
    PlayersData[playerid][Description]  = 0;
	PlayersData[playerid][EnableDescription]= false;
	format(PlayersData[playerid][DescriptionString], MAX_TEXT_DESCRIPTION, "Ninguna");
	PlayersData[playerid][DescriptionColor]		= 0;
	PlayersData[playerid][DescriptionSelect]	= 0;
	PlayersData[playerid][SpawnFac]		= 0;

	// Nuevos 77
	PlayersData[playerid][Objetos][0]	= 0;
	PlayersData[playerid][Objetos][1]	= 0;
	PlayersData[playerid][Objetos][2]	= 0;
	PlayersData[playerid][Objetos][3]	= 0;
	PlayersData[playerid][Objetos][4]	= 0;
	PlayersData[playerid][Objetos][5]		= 0;
	PlayersData[playerid][Objetos][6]		= 0;
	PlayersData[playerid][Objetos][7]		= 0;
	PlayersData[playerid][Objetos][8]		= 0;
	PlayersData[playerid][ObjetosVision][0]		= 0;
	PlayersData[playerid][ObjetosVision][1]		= 0;
	PlayersData[playerid][ObjetosVision][2]		= 0;
	PlayersData[playerid][ObjetosVision][3]		= 0;
	PlayersData[playerid][ObjetosVision][4]		= 0;
	PlayersData[playerid][ObjetosVision][5]		= 0;
	PlayersData[playerid][ObjetosVision][6]		= 0;
	PlayersData[playerid][ObjetosVision][7]		= 0;
	PlayersData[playerid][ObjetosVision][8]		= 0;
	PlayersData[playerid][TypePhone]			= 0;
	PlayersData[playerid][Ayudante] = 0;
	PlayersData[playerid][Mapper] = 0;


    // DATA USERS ONLINE
	PlayersDataOnline[playerid][CurrentDialog]		= 999;
	PlayersDataOnline[playerid][State]  			= 0;
	PlayersDataOnline[playerid][LoginTime]  		= 0;
	PlayersDataOnline[playerid][Spawn]  			= true;
	PlayersDataOnline[playerid][Espectando]			= -1;
    //format(PlayersDataOnline[playerid][NameOnline], MAX_PLAYER_NAME, "0");
	PlayersDataOnline[playerid][Intentar]  			= 0;
	PlayersDataOnline[playerid][StateMoneyPass]  	= true;
	PlayersDataOnline[playerid][StateChannelOOC]  	= true;
	PlayersDataOnline[playerid][StateChannelFamily] = true;
	PlayersDataOnline[playerid][StateChannelRadio]  = true;
	PlayersDataOnline[playerid][StateChannelCNN]  	= true;
	PlayersDataOnline[playerid][CallTime]		  	= true;
	PlayersDataOnline[playerid][StateJob] 			= false;
	PlayersDataOnline[playerid][Paga] 				= false;
	PlayersDataOnline[playerid][InPickup] 			= 0;
	PlayersDataOnline[playerid][InPickupFaccion]    = 0;
	PlayersDataOnline[playerid][InPickupTele]		= -1;
	PlayersDataOnline[playerid][InPickupNegocio]	= 0;
	PlayersDataOnline[playerid][InPickupCasa]		= 0;
	PlayersDataOnline[playerid][MyPickupX] 			= 0;
	PlayersDataOnline[playerid][MyPickupY] 			= 0;
	PlayersDataOnline[playerid][MyPickupZ] 			= 0;
	PlayersDataOnline[playerid][MyPickupZZ]			= 0;
	PlayersDataOnline[playerid][MyPickupWorld]		= 0;
	PlayersDataOnline[playerid][MyPickupLock]	   	= true;
	PlayersDataOnline[playerid][MyPickupX_Now] 		= 0;
	PlayersDataOnline[playerid][MyPickupY_Now] 		= 0;
	PlayersDataOnline[playerid][MyPickupZ_Now] 		= 0;
	PlayersDataOnline[playerid][MyPickupInterior]	= 0;
	PlayersDataOnline[playerid][InCall]				= -1;
	PlayersDataOnline[playerid][SendCommands]		= false;
	PlayersDataOnline[playerid][IsDescolgado]		= false;
	PlayersDataOnline[playerid][IsPagaO]			= gettime();
	PlayersDataOnline[playerid][PhoneOnline]		= true;
	PlayersDataOnline[playerid][InSleep]			= false;
	PlayersDataOnline[playerid][CansansioConteo]	= 0;
	PlayersDataOnline[playerid][InCarId]			= 0;
	PlayersDataOnline[playerid][InVehicle]			= false;
	PlayersDataOnline[playerid][MyLastIdReport]		= 0;
	PlayersDataOnline[playerid][IsEntrevistado]		= false;
	PlayersDataOnline[playerid][SubAfterMenuRow] 	= 0;
	PlayersDataOnline[playerid][AfterMenuRow] 	 	= 0;

	PlayersDataOnline[playerid][InvitePlayer]  		= 0;
	PlayersDataOnline[playerid][InviteFaccion] 		= 0;
	PlayersDataOnline[playerid][Frecuencia]    		= 0;
	PlayersDataOnline[playerid][AdminOn]       		= false;
	PlayersDataOnline[playerid][Freeze]        		= false;
	PlayersDataOnline[playerid][Wispers]       		= true;
	PlayersDataOnline[playerid][RowSkin]       		= 0;
	PlayersDataOnline[playerid][RowHair]       		= 0;
	PlayersDataOnline[playerid][TypeBuy]       		= 0;
	PlayersDataOnline[playerid][IsPlayerInHotel]    = false;
	PlayersDataOnline[playerid][IsTaxi]    			= -1;
	PlayersDataOnline[playerid][SeatTaxi]           = false;
	PlayersDataOnline[playerid][IsAtado]    		= false;
	PlayersDataOnline[playerid][IsEsposas]    		= false;
	PlayersDataOnline[playerid][IsTeazer]    		= 0;
	PlayersDataOnline[playerid][IsTaserEquipped]    = false;
	PlayersDataOnline[playerid][TaserSavedWeapon]   = 0;
	PlayersDataOnline[playerid][TaserSavedAmmo]     = 0;
	PlayersDataOnline[playerid][LastInterior]    		= false;
	PlayersDataOnline[playerid][StateDeath]    			= false;
	PlayersDataOnline[playerid][IsNotSilenciado]    	= true;
	PlayersDataOnline[playerid][ModeDM]   				= false;
	PlayersDataOnline[playerid][IsAFK]    			= false;
	PlayersDataOnline[playerid][JobBonus]  			= false;
 	PlayersDataOnline[playerid][IsCheckCheat]    	= false;
	PlayersDataOnline[playerid][InWalk]             = false;
	PlayersDataOnline[playerid][InCarId]            = false;
	PlayersDataOnline[playerid][TimeCallPublics]    = 0;
	PlayersDataOnline[playerid][ICall]			    = false;
	PlayersDataOnline[playerid][Altavoz]            = false;
	PlayersDataOnline[playerid][ChangeVC]           = false;
	PlayersDataOnline[playerid][InCamera]           = false;
	PlayersDataOnline[playerid][VidaOn]	          	= 100.0;
	PlayersDataOnline[playerid][ChalecoOn]          = 0;
	PlayersDataOnline[playerid][TimeLata]          	= 0;
	// PlayersDataOnline[playerid][LastDamageInt]     	= 0; // nuevo velocimetro - eliminado sistema viejo
	// PlayersDataOnline[playerid][LastGas]     		= 0;
	// PlayersDataOnline[playerid][LastOil]     		= 0;
	PlayersDataOnline[playerid][PistaIDp]           = -1;
	PlayersDataOnline[playerid][PosIDp]           	= -1;
	PlayersDataOnline[playerid][LicenciaTest]     	= false;
	PlayersDataOnline[playerid][PointDm]     		= false;
	PlayersDataOnline[playerid][DesignGarageId] 	= -1;
	PlayersDataOnline[playerid][EspectVehOrPlayer]	= false;
	PlayersDataOnline[playerid][IsEspectando]  		= false;
	PlayersDataOnline[playerid][ExitedVehicle] 		= false;
	PlayersDataOnline[playerid][PendingEmailGate]	= false;
	PlayersDataOnline[playerid][PlayerSexo]    		= -1;
	PlayersDataOnline[playerid][VCoche][0]     		= -1; 	PlayersDataOnline[playerid][VCoche][1]    	= -1;
	PlayersDataOnline[playerid][VFactura][0]   		= -1; 	PlayersDataOnline[playerid][VFactura][1]   	= -1;
	PlayersDataOnline[playerid][VServicio][0]  		= -1; 	PlayersDataOnline[playerid][VServicio][1]  	= -1;
	PlayersDataOnline[playerid][VMulta][0]   		= -1; 	PlayersDataOnline[playerid][VMulta][1]   	= -1;
	PlayersDataOnline[playerid][VRepair][0]    		= -1; 	PlayersDataOnline[playerid][VRepair][1]     = -1;
	PlayersDataOnline[playerid][VAceite][0]    		= -1; 	PlayersDataOnline[playerid][VAceite][1]     = -1;
	PlayersDataOnline[playerid][Contrato][0]    	= -1; 	PlayersDataOnline[playerid][Contrato][1]    = -1;
	PlayersDataOnline[playerid][VArma][0]     		= -1; 	PlayersDataOnline[playerid][VArma][1]     	= -1;
	PlayersDataOnline[playerid][VDrogas][0]     	= -1; 	PlayersDataOnline[playerid][VDrogas][1]     = -1; 	PlayersDataOnline[playerid][VDrogas][2]     = -1;
	PlayersDataOnline[playerid][VPhone][0]     		= -1; 	PlayersDataOnline[playerid][VPhone][1]      = -1; 	PlayersDataOnline[playerid][VPhone][2]     = -1;
	PlayersDataOnline[playerid][VGanzuas][0]    	= -1; 	PlayersDataOnline[playerid][VGanzuas][1]    = -1;
	PlayersDataOnline[playerid][VProteger][0]   	= -1; 	PlayersDataOnline[playerid][VProteger][1]   = -1;
	PlayersDataOnline[playerid][EditingType] = 0;
	PlayersDataOnline[playerid][EditingMapeo] = 0;
	PlayersDataOnline[playerid][EditingObjectID] = 0;
	PlayersDataOnline[playerid][EditingIndex] = 0;
	PlayersDataOnline[playerid][EditingOption] = 0;
	PlayersDataOnline[playerid][EditingMovement] = 0;
	PlayersDataOnline[playerid][TeleCreate] = 0;
	PlayersDataOnline[playerid][GarageCreate] = 0;
	PlayersDataOnline[playerid][IsLookingGas] = 0;

	format(PlayersDataOnline[playerid][TempPassword], 25, "");
	format(PlayersDataOnline[playerid][TempEmail], 60, "");
	format(PlayersDataOnline[playerid][TempRegisterPwd], 25, "");
	PlayersDataOnline[playerid][WaitingPwdConfirm] = false;
	PlayersDataOnline[playerid][TempSexo] = -1;
	PlayersDataOnline[playerid][TempEdad] = 0;

	TempAccountID[playerid] = 0;
	ApiCharacterID[playerid] = 0;
	for (new i = 0; i < MAX_CHARS_PER_ACCOUNT; i++)
	{
		TempCharIDs[playerid][i] = 0;
		TempCharList[playerid][i][0] = EOS;
		TempCharLevel[playerid][i] = 0;
	}

	PlayersDataOnline[playerid][CountCheat]			= 0;

	Banking[playerid][Balance] 						= 0;
}

SaveDatosPlayerDisconnect(playerid)
{
	if ( IsPlayerConnected(playerid) )
	{
	    if ( PlayersDataOnline[playerid][State] == 3 )
	    {
			RemovePlayerDescription(playerid, false, false);
		    new MyTime = gettime();
			if ( PlayersData[playerid][Jail] != 0 )
			{
				PlayersData[playerid][Jail] = PlayersData[playerid][Jail] - MyTime;
			}
			PlayersData[playerid][IsPaga] = (MyTime - PlayersDataOnline[playerid][IsPagaO]) + PlayersData[playerid][IsPaga];
			if ( PlayersData[playerid][IsPaga] < 0 )
			{
				PlayersData[playerid][IsPaga] = 0;
			}
			if ( PlayersDataOnline[playerid][IsTaxi] != -1 )
			{
				PayTaxi(playerid, false);
			}
		    if ( PlayersData[playerid][Phone] != 0 && PlayersDataOnline[playerid][InCall] != -1 )
		    {
				PayCall(playerid);
				if ( PlayersDataOnline[playerid][InCall] != 888 )
				{
					PayCall(PlayersDataOnline[playerid][InCall]);
			        PlayersDataOnline[PlayersDataOnline[playerid][InCall]][InCall] = -1;
					Acciones(PlayersDataOnline[playerid][InCall], 8, "guarda su movil");
					SendClientMessage(PlayersDataOnline[playerid][InCall], COLOR_COLGAR_DESCOLGAR, " Han colgado!");
			        PlayersDataOnline[PlayersDataOnline[playerid][InCall]][IsDescolgado] = false;
					SetPlayerColgar(PlayersDataOnline[playerid][InCall]);
				}
				else
				{
					if ( CallCNN == playerid )
					{
						SendClientMessageToAll(0x0FFF00FF, "* CNN: Conexion telefonica finalizada.");
					    CallCNN = -1;
					}
				}
		        PlayersDataOnline[playerid][IsDescolgado] = false;
		        PlayersDataOnline[playerid][InCall] = -1;
			}
			if ( PlayersData[playerid][InTutorial] )
			{
				KillTimer(PlayersDataOnline[playerid][TimerTutorialId]);
				KillTimer(PlayersDataOnline[playerid][TimerCamaraId]);
			}
		    if ( PlayersDataOnline[playerid][PistaIDp] != -1 )
		    {
		        new PistasDialogText[MAX_TEXT_CHAT];
			    format(PistasDialogText, sizeof(PistasDialogText), "{"COLOR_AMARILLO"}%s{"COLOR_VERDE"} ha salido de la carrera ((Se desconecto)).", PlayersDataOnline[playerid][NameOnlineFix]);
				SendMessageToRaceChat(playerid, PistasDialogText, true);
				RemovePlayerToRace(playerid, false, true, STATE_RACE_EXIT_DISCONNECT);
			}
			DataUserSave(playerid);
			// si la API esta habilitada, ademas de la persistencia local hacemos
			// PUT contra el backend externo para que el estado completo del
			// personaje (vida, armadura, posicion, etc) quede en la API.
			if ( UsersApi_IsEnabled() )
			{
				usersApi_SaveCharacter(playerid);
			}
			// SaveAgenda(playerid); Ahora se actualiza al modificar.
			SavePlayerSMS(playerid);
			SaveAccountBanking(playerid);
			ResetPlayerWeapons(playerid);
			printf("%s[%i] se desconecto.", PlayersDataOnline[playerid][NameOnline], playerid);
			PlayersDataOnline[playerid][MarcaZZ] = true;
		}
		else
		{
			PlayersDataOnline[playerid][MarcaZZ] = true;
		}
	}
	else
	{
	    printf("Error! Jugador no conectado! %s[%i]", PlayersDataOnline[playerid][NameOnline], playerid);
	}
}

GivePlayerWeaponReturn(playerid)
{
	ResetPlayerWeapons(playerid);
	for (new i = 0; i < 13; i++)
	{
	    if ( IsValidWeapon(playerid, PlayersData[playerid][WeaponS][i]) && PlayersData[playerid][WeaponS][i] != WEAPON:0 && PlayersData[playerid][AmmoS][i] > 0 )
	    {
			GivePlayerWeapon(playerid, PlayersData[playerid][WeaponS][i], PlayersData[playerid][AmmoS][i]);
		}
		else
		{
			PlayersData[playerid][WeaponS][i] = WEAPON:0;
			PlayersData[playerid][AmmoS][i] = 0;
		}
	}
}

GivePlayerWeaponEx(playerid, weaponid, ammo)
{
	if ( IsValidWeapon(playerid, weaponid) )
	{
		PlayersDataOnline[playerid][StateWeaponPass] 	= gettime() + 5;
		PlayersData[playerid][WeaponS][SlotIDWeapon[weaponid]] = WEAPON:weaponid;
	    PlayersData[playerid][AmmoS][SlotIDWeapon[weaponid]] = PlayersData[playerid][AmmoS][SlotIDWeapon[weaponid]] + ammo;
		GivePlayerWeapon(playerid, WEAPON:weaponid, ammo);
	}
}

IsValidWeapon(playerid, weaponid)
{
	if ( weaponid >= 0 &&
	 	 weaponid <= 46 &&
	 	 weaponid != 19 &&
	 	 weaponid != 20 &&
	 	 weaponid != 21 )
	{
	    return true;
    }
    else
    {
		new MsgAvisoBug[MAX_TEXT_CHAT];
	    format(MsgAvisoBug, sizeof(MsgAvisoBug), "%s Bugs Owned - El jugador %s[%i] se le bugueo un arma ID: %i.", LOGO_STAFF, PlayersDataOnline[playerid][NameOnline], playerid, weaponid);
		MsgCheatsReportsToAdmins(MsgAvisoBug);
        return false;
	}
}

RemovePlayerWeapond(playerid, weaponsid)
{
	ResetPlayerWeapons(playerid);
	PlayersData[playerid][WeaponS][SlotIDWeapon[weaponsid]] = WEAPON:0;
	PlayersData[playerid][AmmoS][SlotIDWeapon[weaponsid]] = 0;
	for (new i = 0; i < 13; i++)
	{
	    if ( PlayersData[playerid][WeaponS][i] != WEAPON:0 && PlayersData[playerid][AmmoS][i] > 0)
	    {
			GivePlayerWeapon(playerid, PlayersData[playerid][WeaponS][i], PlayersData[playerid][AmmoS][i]);
		}
		else
		{
			PlayersData[playerid][WeaponS][i] = WEAPON:0;
			PlayersData[playerid][AmmoS][i] = 0;
		}
	}
}

ResetPlayerWeaponsEx(playerid)
{
	for (new i = 0; i < 13; i++)
	{
		PlayersData[playerid][WeaponS][i] = WEAPON:0;
		PlayersData[playerid][AmmoS][i] = 0;
	}
	ResetPlayerWeapons(playerid);
}

GetSpawnInfoEx(playerid)
{
	if ( !PlayersDataOnline[playerid][ModeDM] )
	{
		CheckWeapondCheat(playerid);
	}
	else
	{
		ResetPlayerWeaponsEx(playerid);
	}


	PlayersData[playerid][Chaleco] = PlayersDataOnline[playerid][ChalecoOn];
	PlayersData[playerid][Vida] = PlayersDataOnline[playerid][VidaOn];

 	GetPlayerPos(playerid, PlayersData[playerid][Spawn_X], PlayersData[playerid][Spawn_Y], PlayersData[playerid][Spawn_Z]);
    GetPlayerFacingAngle(playerid, PlayersData[playerid][Spawn_ZZ]);

  	PlayersData[playerid][Interior] = GetPlayerInteriorEx(playerid);
	PlayersData[playerid][World] = GetPlayerVirtualWorld(playerid);
}

SetSpawnInfoEx(playerid)
{
	if ( CheckWeapondCheat(playerid) )
	{
		PlayersDataOnline[playerid][StateWeaponPass] 	= gettime() + 5;
		GivePlayerWeaponReturn(playerid);
	}
	PlayersDataOnline[playerid][ChalecoOn] = PlayersData[playerid][Chaleco];
	PlayersDataOnline[playerid][VidaOn] = PlayersData[playerid][Vida];
 	SetPlayerPos(playerid, PlayersData[playerid][Spawn_X], PlayersData[playerid][Spawn_Y], PlayersData[playerid][Spawn_Z]);
    SetPlayerFacingAngle(playerid, PlayersData[playerid][Spawn_ZZ]);
	SetPlayerInteriorEx(playerid, PlayersData[playerid][Interior]);
	SetPlayerVirtualWorldEx(playerid, PlayersData[playerid][World]);
}

GetPlayerStats(playerid, playeridshow)
{
	new info[1500];

    strcat(info, "{"COLOR_AZUL"}ID\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Nombre\t%s\n");
    strcat(info, "{"COLOR_AZUL"}Interior\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Mundo\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Warns\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Nivel\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Falta\t[%i/%i]\n");
    
    strcat(info, "{"COLOR_AZUL"}Horas Jugadas\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Edad\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Cansansio\t%i/54\n");
    strcat(info, "{"COLOR_AZUL"}Movil\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Ciudad\t%s\n");
    
    strcat(info, "{"COLOR_AZUL"}Sexo\t%s\n");
    strcat(info, "{"COLOR_AZUL"}Skin\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Ganzuas\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Drogas\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Materiales\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Lata\t%s\n");
    strcat(info, "{"COLOR_AZUL"}Bombas\t%i\n");
    
	format(info, sizeof(info), info,
		playerid,
		PlayersDataOnline[playerid][NameOnline],
		GetPlayerInteriorEx(playerid),
		GetPlayerVirtualWorld(playerid),
		PlayersData[playerid][Warn],
		GetPlayerScoreEx(playerid),
        GetPlayerScoreMin(playerid),
        GetPlayerScoreMax(playerid),

		PlayersData[playerid][HoursPlaying],
		PlayersData[playerid][Edad],
		PlayersData[playerid][Cansansio],
		PlayersData[playerid][Phone],
		Ciudades[PlayersData[playerid][Ciudad]],
		
		Sexos[PlayersData[playerid][Sexo]],
		PlayersData[playerid][Skin],
		PlayersData[playerid][Ganzuas],
		PlayersData[playerid][Drogas],
		PlayersData[playerid][Materiales],
		LataName[PlayersData[playerid][Lata]],
		PlayersData[playerid][Bombas]);
		
	strcat(info, "{"COLOR_AZUL"}Faccion\t%s\n");
    strcat(info, "{"COLOR_AZUL"}Rango\t%s\n");
    strcat(info, "{"COLOR_AZUL"}Dinero\t$%i\n");
    strcat(info, "{"COLOR_AZUL"}Cuenta de Ahorros\t$%i\n");
    strcat(info, "{"COLOR_AZUL"}Cuenta de Cheques\t$%i\n");

    strcat(info, "{"COLOR_AZUL"}Habilidad\t%s\n");
    strcat(info, "{"COLOR_AZUL"}Casado\t%s\n");
    strcat(info, "{"COLOR_AZUL"}Hablar\t%s\n");
    strcat(info, "{"COLOR_AZUL"}Caminar\t%s\n");
    strcat(info, "{"COLOR_AZUL"}Saldo\t$%i\n");
    strcat(info, "{"COLOR_AZUL"}Bolsa\t%s\n");
    
    strcat(info, "{"COLOR_AZUL"}Muerto\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Muertos\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Vehiculo 1\t%s\n");
    strcat(info, "{"COLOR_AZUL"}Vehiculo 2\t%s\n");
    strcat(info, "{"COLOR_AZUL"}Vehiculo 3\t%s\n");

	new vehicleIndex1 = GetVehicleIndexBySQLID(PlayersData[playerid][Asignados][0]);
	new vehicleIndex2 = GetVehicleIndexBySQLID(PlayersData[playerid][Asignados][1]);
	new vehicleIndex3 = GetVehicleIndexBySQLID(PlayersData[playerid][Asignados][2]);
    
    format(info, sizeof(info), info,
    	FaccionData[PlayersData[playerid][Faccion]][NameFaccion],
		FaccionesRangos[PlayersData[playerid][Faccion]][PlayersData[playerid][Rango]],
		PlayersData[playerid][Dinero],
		PlayersData[playerid][Banco],
		Banking[playerid][Balance],
		
		HabilidadesName[PlayersData[playerid][Habilidad]],
		PlayersData[playerid][GirlFreind],
		ModeTalkName[PlayersData[playerid][MyStyleTalk]],
		ModeWalkName[PlayersData[playerid][MyStyleWalk]],
		PlayersData[playerid][Saldo],
		SiOrNo[PlayersData[playerid][HaveBolsa]],
		
		PlayersData[playerid][DeahtCount],
		PlayersData[playerid][KilledCount],
		DataCars[vehicleIndex1][MatriculaString],
		DataCars[vehicleIndex2][MatriculaString],
		DataCars[vehicleIndex3][MatriculaString]);

    strcat(info, "{"COLOR_AZUL"}Enfermedad\t%s%s\n");
    strcat(info, "{"COLOR_AZUL"}Horas de trabajo\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Email\t%s\n");
    strcat(info, "{"COLOR_AZUL"}Trabajo\t%s\n");
    
    strcat(info, "{"COLOR_AZUL"}Spawn Faccion\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Cuenta Bancaria\t%i\n");
    strcat(info, "{"COLOR_AZUL"}Casa\t%i\n");
    //strcat(info, "{"COLOR_AZUL"}\t%i\n");
    
    format(info, sizeof(info), info,
        EnfermedadColores[PlayersData[playerid][Enfermedad]], EnfermedadName[PlayersData[playerid][Enfermedad]],
		PlayersData[playerid][HorasWork],
		PlayersData[playerid][Email],
		Jobs[PlayersData[playerid][Job]][NameJob],
		
		PlayersData[playerid][SpawnFac] + 1,
		PlayersData[playerid][AccountBankingOpen],	
		PlayersData[playerid][House]);
		
	ShowPlayerDialogEx(playeridshow, 999, DIALOG_STYLE_TABLIST, "{"COLOR_AZUL"}Estadisticas", info, "Cerrar", "");
}

CleanDataDeath(playerid)
{
    StopAudioStreamForPlayer(playerid);
	PlayersData[playerid][IsPlayerInBizz] = false;
	PlayersData[playerid][IsPlayerInHouse] = false;
	PlayersData[playerid][IsPlayerInBank] = false;

	PlayersDataOnline[playerid][JobBonus] = false;
	PlayersDataOnline[playerid][IsTeazer] = false;
	PlayersData[playerid][MyBonus] = false;
	PlayersData[playerid][IsPlayerInVehInt] = false;
	DisablePlayerCheckpoint(playerid);
	PlayersDataOnline[playerid][SubAfterMenuRow] = 0;
	PlayersDataOnline[playerid][AfterMenuRow] = 0;
	SetPlayerDrunkLevel(playerid, 0);

	new CallID;
	for (new i = 0; i <= 2;i++)
	{
		CallID = IsFoundCall(PlayersData[playerid][Phone], i);
		if ( CallID != -1 )
		{
			RemoveCallPublics(CallID, i);
		}
		if ( i <= 1 )
		{
			CallID = IsFoundCallSAMD(PlayersData[playerid][Phone], 1, 0);
			if ( CallID != -1 )
			{
				RemoveCallSAMD(CallID, 0);
			}
			CallID = IsFoundCallSAMD(PlayersData[playerid][Phone], 1, 1);
			if ( CallID != -1 )
			{
				RemoveCallSAMD(CallID, 1);
			}
		}
	}
}

ShowPasaporteToPlayer(playerid, playeridshow)
{
	new MsgPasaporteShow[MAX_TEXT_CHAT];
	SendClientMessage(playeridshow, COLOR_MESSAGES[3], "............:::::PASAPORTE:::::............");
	format(MsgPasaporteShow, MAX_TEXT_CHAT, "Nombre: %s", PlayersDataOnline[playerid][NameOnlineFix]);
	SendClientMessage(playeridshow, COLOR_MESSAGES[3], MsgPasaporteShow);
	format(MsgPasaporteShow, MAX_TEXT_CHAT, "Edad: %i", PlayersData[playerid][Edad]);
	SendClientMessage(playeridshow, COLOR_MESSAGES[3], MsgPasaporteShow);
	format(MsgPasaporteShow, MAX_TEXT_CHAT, "Ciudad: %s", Ciudades[PlayersData[playerid][Ciudad]]);
	SendClientMessage(playeridshow, COLOR_MESSAGES[3], MsgPasaporteShow);
	if ( PlayersData[playerid][Faccion] != YKZ &&
		 PlayersData[playerid][Faccion] != LCN &&
		 PlayersData[playerid][Faccion] != SICARIOS &&
		 PlayersData[playerid][Faccion] != CONTRABANDISTAS &&
		 PlayersData[playerid][Faccion] != TRAFICANTES &&
		 PlayersData[playerid][Faccion] != COLTS &&
		 PlayersData[playerid][Faccion] != AK &&
		 PlayersData[playerid][Faccion] != VELTRAN &&
		 PlayersData[playerid][Faccion] != HEORS &&
		 PlayersData[playerid][Faccion] != CIVIL)
	{
		format(MsgPasaporteShow, MAX_TEXT_CHAT, "Trabajo: %s", FaccionData[PlayersData[playerid][Faccion]][NameFaccion]);
		SendClientMessage(playeridshow, COLOR_MESSAGES[3], MsgPasaporteShow);
		format(MsgPasaporteShow, MAX_TEXT_CHAT, "Cargo: %s", FaccionesRangos[PlayersData[playerid][Faccion]][PlayersData[playerid][Rango]]);
		SendClientMessage(playeridshow, COLOR_MESSAGES[3], MsgPasaporteShow);
	}
	else if ( PlayersData[playerid][Faccion] != CIVIL )
	{
		SendClientMessage(playeridshow, COLOR_MESSAGES[3], "Trabajo: Desconocido");
		SendClientMessage(playeridshow, COLOR_MESSAGES[3], "Cargo: Desconocido");
	}
	else
	{
		SendClientMessage(playeridshow, COLOR_MESSAGES[3], "Trabajo: Ninguno");
		SendClientMessage(playeridshow, COLOR_MESSAGES[3], "Cargo: Ninguno");
	}

	format(MsgPasaporteShow, MAX_TEXT_CHAT, "Sexo: %s", Sexos[PlayersData[playerid][Sexo]]);
	SendClientMessage(playeridshow, COLOR_MESSAGES[3], MsgPasaporteShow);
	format(MsgPasaporteShow, MAX_TEXT_CHAT, "Casado: %s", PlayersData[playerid][GirlFreind]);
	SendClientMessage(playeridshow, COLOR_MESSAGES[3], MsgPasaporteShow);

}

ShowLicenciasToPlayer(playerid, playeridshow)
{
	new MsgLicenciasShow[MAX_TEXT_CHAT];
	SendClientMessage(playeridshow, COLOR_MESSAGES[3], "............:::::Licencias:::::............");
	for (new i = 0; i <= 6; i++)
	{
	    format(MsgLicenciasShow, sizeof(MsgLicenciasShow), "%s: %s", LicenciasNames[i], SiOrNo[PlayersData[playerid][Licencias][i]]);
	    SendClientMessage(playeridshow, COLOR_MESSAGES[3], MsgLicenciasShow);
	}
    format(MsgLicenciasShow, sizeof(MsgLicenciasShow), "%s: %s", LicenciasNames[7], SiOrNo[PlayersData[playerid][LicenciaPesca]]);
    SendClientMessage(playeridshow, COLOR_MESSAGES[3], MsgLicenciasShow);
}

ShowIdiomasToPlayer(playerid, playeridshow)
{
	new MsgIdiomasShow[MAX_TEXT_CHAT];
	SendClientMessage(playeridshow, COLOR_MESSAGES[3], "............:::::Idiomas:::::............");
	for (new i = 0; i <= 5; i++)
	{
	    format(MsgIdiomasShow, sizeof(MsgIdiomasShow), "%s: %s", IdiomasNames[i], SiOrNo[PlayersData[playerid][Idiomas][i]]);
	    SendClientMessage(playeridshow, COLOR_MESSAGES[3], MsgIdiomasShow);
	}
}

UnBanUser(playerid_admin, const playeridname[], option)
{
	new playerid = 499;
	format(PlayersDataOnline[playerid][NameOnline], MAX_PLAYER_NAME, "%s", playeridname);

	if ( DataUserLoad(playerid) )
	{
	    new MsgDesban[MAX_TEXT_CHAT];
	    if ( PlayersData[playerid][Admin] == 9 )
	    {
			SendInfoMessage(playerid_admin, 0, "1451", "No existe ese jugador en la base de datos!");
			return false;
		}
	    if ( !option )
	    {
			if ( PlayersData[playerid][AccountState] == 3 )
			{
			    PlayersData[playerid][AccountState] = 0;
				PlayersDataOnline[playerid][Spawn] = false;
				format(MsgDesban, sizeof(MsgDesban), "Has desbaneado a %s", playeridname);
				new UnBanIpCommand[MAX_TEXT_CHAT];
				format(UnBanIpCommand, sizeof(UnBanIpCommand), "unbanip %s", PlayersData[playerid][MyIP]);
				SendRconCommand(UnBanIpCommand);
				SendInfoMessage(playerid_admin, 3, "0", MsgDesban);
				DataUserSave(playerid);
			}
			else
			{
				format(MsgDesban, sizeof(MsgDesban), "El jugador %s no se encuentra baneado", playeridname);
				SendInfoMessage(playerid_admin, 0, "673", MsgDesban);
			}
		}
		else
		{
			if ( PlayersData[playerid][AccountState] != 3 )
			{
			    PlayersData[playerid][AccountState] = 3;
				PlayersDataOnline[playerid][Spawn] = false;
				format(MsgDesban, sizeof(MsgDesban), "Has baneado a %s", playeridname);
				new BanIpCommand[MAX_TEXT_CHAT];
				format(BanIpCommand, sizeof(BanIpCommand), "banip %s", PlayersData[playerid][MyIP]);
				SendRconCommand(BanIpCommand);
				SendInfoMessage(playerid_admin, 3, "0", MsgDesban);
				DataUserSave(playerid);
			}
			else
			{
				format(MsgDesban, sizeof(MsgDesban), "El jugador %s ya se encuentra baneado", playeridname);
				SendInfoMessage(playerid_admin, 0, "972", MsgDesban);
			}
		}
	}
	else
	{
		SendInfoMessage(playerid_admin, 0, "212", "No existe ese jugador en la base de datos!");
	}
	return true;
}

UpdateSpawnPlayer(playerid)
{
	if ( PlayersData[playerid][Nacer] == 1 && PlayersData[playerid][House] != -1 ||
		 PlayersData[playerid][Nacer] == 1 && PlayersData[playerid][Alquiler] != -1 ||
		 PlayersData[playerid][Nacer] == 2 && IsPlayerInHouseFriend(playerid, PlayersData[playerid][SpawnAmigo]) != -1
		 )
	{
	    new HouseId;
	    if ( PlayersData[playerid][Nacer] == 1 )
	    {
		    if ( PlayersData[playerid][Alquiler] != -1 )
		    {
		        HouseId = PlayersData[playerid][Alquiler];
			}
			else
			{
			    HouseId = PlayersData[playerid][House];
			}
		}
		else
		{
		    HouseId = PlayersData[playerid][SpawnAmigo];
		}
		SetSpawnInfo(playerid, -1, PlayersData[playerid][Skin],	HouseData[HouseId][PosX], HouseData[HouseId][PosY], HouseData[HouseId][PosZ], HouseData[HouseId][PosZZ], WEAPON:0, 0, WEAPON:0, 0, WEAPON:0, 0);
	}
	else
	{
	    if ( !PlayersData[playerid][Ciudad] && PlayersData[playerid][Faccion] == CIVIL || PlayersData[playerid][Faccion] != CIVIL)
	    {
			SetSpawnInfo(playerid, -1, PlayersData[playerid][Skin],	FaccionData[PlayersData[playerid][Faccion]][Spawn_X][PlayersData[playerid][SpawnFac]], FaccionData[PlayersData[playerid][Faccion]][Spawn_Y][PlayersData[playerid][SpawnFac]], FaccionData[PlayersData[playerid][Faccion]][Spawn_Z][PlayersData[playerid][SpawnFac]], FaccionData[PlayersData[playerid][Faccion]][Spawn_ZZ][PlayersData[playerid][SpawnFac]], WEAPON:0, 0, WEAPON:0, 0, WEAPON:0, 0);
		}
		else
		{
			SetSpawnInfo(playerid, -1, PlayersData[playerid][Skin],	-2049.9419,461.4292,35.1719,312.4388, WEAPON:0, 0, WEAPON:0, 0, WEAPON:0, 0);
		}
	}
}

ShowPlayerMenuSelectWalk(playerid)
{
	new ListDialog[350];
	for (new i = 0; i < sizeof(ModeWalkID); i++)
	{
	    if ( i != 0 )
	    {
	    	strcat(ListDialog, "\r\n{"COLOR_CREMA"}", sizeof(ListDialog));
		}
	    if ( PlayersData[playerid][MyStyleWalk] == i)
	    {
	    	strcat(ListDialog, "{"COLOR_VERDE"}> ", sizeof(ListDialog));
	    	strcat(ListDialog, ModeWalkName[i], sizeof(ListDialog));
    	}
    	else
    	{
	    	strcat(ListDialog, ModeWalkName[i], sizeof(ListDialog));
		}
	}
	ShowPlayerDialogEx(playerid,27,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Seleccionar mi estilo de caminar", ListDialog, "Seleccionar", "Cancelar");
}

ShowPlayerMenuSelectTalk(playerid)
{
	new ListDialog[350];
	for (new i = 0; i < sizeof(ModeTalkName); i++)
	{
	    if ( i != 0 )
	    {
	    	strcat(ListDialog, "\r\n{"COLOR_CREMA"}", sizeof(ListDialog));
		}
	    if ( PlayersData[playerid][MyStyleTalk] == i)
	    {
	    	strcat(ListDialog, "{"COLOR_VERDE"}> ", sizeof(ListDialog));
	    	strcat(ListDialog, ModeTalkName[i], sizeof(ListDialog));
    	}
    	else
    	{
	    	strcat(ListDialog, ModeTalkName[i], sizeof(ListDialog));
		}
	}
	ShowPlayerDialogEx(playerid,60,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Seleccionar mi estilo de hablar", ListDialog, "Seleccionar", "Cancelar");
}

/*
ShowPlayerMenuSelectSprint(playerid)
{
	new ListDialog[350];
	for (new i = 0; i < sizeof(ModeSprintName); i++)
	{
	    if ( i != 0 )
	    {
	    	strcat(ListDialog, "\r\n{"COLOR_CREMA"}", sizeof(ListDialog));
		}
	    if ( PlayersData[playerid][MyStyleSprint] == i)
	    {
	    	strcat(ListDialog, "{"COLOR_VERDE"}> ", sizeof(ListDialog));
	    	strcat(ListDialog, ModeSprintName[i], sizeof(ListDialog));
    	}
    	else
    	{
	    	strcat(ListDialog, ModeSprintName[i], sizeof(ListDialog));
		}
	}
	ShowPlayerDialogEx(playerid,61,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Seleccionar mi estilo de correr", ListDialog, "Seleccionar", "Cancelar");
}
*/

ShowDialogAccount(playerid)
{
	new ListDialog[350];
	format(ListDialog, sizeof(ListDialog),
	"{"COLOR_VERDE"}1- {"COLOR_CREMA"}Cambiar Clave\r\n{"COLOR_VERDE"}2- {"COLOR_CREMA"}Sexo\r\n{"COLOR_VERDE"}3- {"COLOR_CREMA"}Edad\r\n{"COLOR_VERDE"}4- {"COLOR_CREMA"}Email({"COLOR_AMARILLO"}%s{"COLOR_CREMA"})\r\n{"COLOR_VERDE"}5- {"COLOR_CREMA"}Opciones",
		PlayersData[playerid][Email]
	);
	ShowPlayerDialogEx(playerid,18,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Configuracion de mi Cuenta", ListDialog, "Seleccionar", "Salir");
}

ShowDialogAccountOptions(playerid)
{
	new ListDialog[500];

	format(ListDialog, sizeof(ListDialog),
		"{"COLOR_VERDE"}1- {"COLOR_CREMA"}Intermitentes: %s{"COLOR_VERDE"}",
		NameConfigutionUser[PlayersData[playerid][IntermitentState]]
	);

	ShowPlayerDialogEx(playerid,49,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Opciones de mi Cuenta", ListDialog, "Seleccionar", "Volver");
}
ShowPlayerVerifiquedEmail(playerid, option)
{
    if ( option )
    {
		ShowPlayerDialogEx(playerid, 91, DIALOG_STYLE_INPUT, "{"COLOR_AZUL"}Confirmar E-mail", "{"COLOR_TEXTO_DIALOGS"}Introduzca el E-mail que figura en\n{"COLOR_TEXTO_DIALOGS"}su configuracion, luego pulse en \"Verificar\"", "Verificar", "Volver");
		PlayersDataOnline[playerid][SaveAfterAgenda][0] = false;
   	}
   	else
   	{
		PlayersDataOnline[playerid][SaveAfterAgenda][0] = true;
		ShowPlayerDialogEx(playerid, 91, DIALOG_STYLE_INPUT, "{"COLOR_AZUL"}Confirmar E-mail", "{"COLOR_TEXTO_DIALOGS"}Intente nuevamente introducir su\n{"COLOR_TEXTO_DIALOGS"}E-mail y pulse en ingresar \"Verificar\"", "Verificar", "Volver");
	}
}
forward ShowPlayerLoginApi(playerid, option);
ShowPlayerLogin(playerid, option)
{
	new MsgWelcome[64];
	format(MsgWelcome, sizeof(MsgWelcome), "{"COLOR_AZUL"}Login - %s", PlayersDataOnline[playerid][NameOnlineFix]);

    if ( option )
    {
		ShowPlayerDialogEx(playerid, 1, DIALOG_STYLE_PASSWORD, MsgWelcome, "{"COLOR_TEXTO_DIALOGS"}Escriba su Clave y pulse en \"Ingresar\"", "Ingresar", "Cancelar");
		PlayersDataOnline[playerid][SaveAfterAgenda][0] = false;
   	}
   	else
   	{
		PlayersDataOnline[playerid][SaveAfterAgenda][0] = true;
		ShowPlayerDialogEx(playerid, 1, DIALOG_STYLE_PASSWORD, MsgWelcome, "{"COLOR_TEXTO_DIALOGS"}Intente nuevamente ingresar su Clave y pulse en \"Ingresar\"\n\n{"COLOR_ROJO"}NOTA: {"COLOR_TEXTO_DIALOGS"}Si ha olvidado su Clave puede solicitarla mediante un E-mail pulsando en \"Recuperar\"\n{"COLOR_TEXTO_DIALOGS"}o tratando directamente en el centro de soporte ("URL_WEB"/Soporte)", "Ingresar", "Recuperar");
	}
}
ShowPlayerLoginApi(playerid, option)
{
	// dialog unificado de password: el cliente no distingue login vs registro,
	// la API decide segun si la cuenta existe o no.
	new MsgWelcome[64];
	format(MsgWelcome, sizeof(MsgWelcome), "{"COLOR_AZUL"}Login - %s", PlayersDataOnline[playerid][NameOnlineFix]);

	if ( option )
	{
		ShowPlayerDialogEx(playerid, 1, DIALOG_STYLE_PASSWORD, MsgWelcome, "{"COLOR_TEXTO_DIALOGS"}Ingrese una contrasena para registrarse o iniciar sesion.", "Ingresar", "Cancelar");
		PlayersDataOnline[playerid][SaveAfterAgenda][0] = false;
	}
	else
	{
		ShowPlayerDialogEx(playerid, 1, DIALOG_STYLE_PASSWORD, MsgWelcome, "{"COLOR_TEXTO_DIALOGS"}Ingrese una contrasena para registrarse o iniciar sesion.", "Ingresar", "Cancelar");
	}
}
ShowPlayerRegister(playerid, option)
{
	new MsgWelcome[50];
    format(MsgWelcome, sizeof(MsgWelcome), "{"COLOR_AZUL"}Registrese %s!", PlayersDataOnline[playerid][NameOnlineFix]);

    if ( option )
    {
    	ShowPlayerDialogEx(playerid, 2, DIALOG_STYLE_PASSWORD, MsgWelcome, "{"COLOR_TEXTO_DIALOGS"}Ingresar una Clave para registrarse!", "Registrar", "Cancelar");
   	}
   	else
   	{
		ShowPlayerDialogEx(playerid, 2, DIALOG_STYLE_PASSWORD, MsgWelcome, "{"COLOR_TEXTO_DIALOGS"}Escribe una Clave mayor de 4 caracteres y menor de 25!", "Registrar", "Cancelar");
	}
}
SendRequestPasswordRecovery(playerid)
{
	/*
	new StrRequestHTTP[400];
	format(StrRequestHTTP, sizeof(StrRequestHTTP), ""URL_WEB"/recuperar_password_samp.php?passwordPass=%s&passwordUser=%s&EmailSend=%s&UserName=%s",
			PASSWORD_EMAIL,
			PlayersData[playerid][Password],
			PlayersData[playerid][Email],
			PlayersDataOnline[playerid][NameOnline]);

	printf("%s", StrRequestHTTP);

	HTTP(playerid, HTTP_POST, StrRequestHTTP, "", "RecoveryEmailPlayer");
	*/
	return playerid;
}
stock RecoveryEmailPlayer(playerid, response_code, const data[])
{
	if ( IsPlayerConnected(playerid) )
	{
	    printf("RecoveryEmailPlayer || %s[%i] || Error HTTP: %i || Data: %s", PlayersDataOnline[playerid][NameOnline], playerid, response_code, data);
		if ( response_code == 200 && strval(data) || response_code == 6 && strval(data) )
		{
		    new MsgEmailSend[400];
		    format(MsgEmailSend, sizeof(MsgEmailSend), "{"COLOR_TEXTO_DIALOGS"}El proceso se ha realizado con exito!\n\nSe ha enviado un E-mail con su Clave actual a la siguiente direccion:\n{"COLOR_AMARILLO"}%s\n\n{"COLOR_TEXTO_DIALOGS"}Revise la bandeja de Spam si no encuentra el E-mail.", PlayersData[playerid][Email]);
		    strcat(MsgEmailSend, "\n\n{"COLOR_TEXTO_DIALOGS"}Cualquier duda no olvide dirigirse al centro de soporte en:\n{"COLOR_AMARILLO"}"URL_WEB"/Soporte\n\n\n\n{"COLOR_AZUL"}Saludos Cordiales\n{"COLOR_AZUL"}Equipo de "SERVER_NAME".", sizeof(MsgEmailSend));
	        ShowPlayerDialogEx(playerid, 999, DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}informacion - Recuperacion de Clave", MsgEmailSend, "Ok", "");

	        PlayersData[playerid][EmailTime] = gettime() + 7200;
		}
		else
		{
	        ShowPlayerDialogEx(playerid, 999, DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}informacion - Error! (Recuperacion de Clave)", "{"COLOR_ROJO"}Oops, un error ha ocurrido!\n\n{"COLOR_TEXTO_DIALOGS"}Porfavor intente luego realizar esta operacion\n{"COLOR_TEXTO_DIALOGS"}Si el problema llega a persistir, nos puede contar el inconveniente en: {"COLOR_AMARILLO"}"URL_WEB"/Soporte\n\n\n{"COLOR_TEXTO_DIALOGS"}Disculpar las molestias.", "Ok", "");
		}
        KickEx(playerid, 9);
	}
}
ValidingEmail(playerid, response_code, const data[])
{
	if ( IsPlayerConnected(playerid) )
	{
	    printf("ValidingEmail || %s[%i] || Error HTTP: %i || Data: %s", PlayersDataOnline[playerid][NameOnline], playerid, response_code, data);
		if ( response_code == 200 || response_code == 6  )
		{
		    if ( strlen(data) > 1 )
		    {
		        new query[200];

				format(PlayersData[playerid][Email], 60, "%s", data);
				mysql_format(dataBase, query, 200, "UPDATE `%s` SET `Email`='%e' WHERE `Nombre`='%e';", DIR_USERS, data, PlayersDataOnline[playerid][NameOnline]);
				mysql_query(dataBase, query, false);

			    new MsgNewEmail[MAX_TEXT_CHAT];

				// primera vez (gate de login o registro) vs cambio normal
				if (PlayersDataOnline[playerid][PendingEmailGate] || PlayersDataOnline[playerid][State] == 2)
				{
					format(MsgNewEmail, sizeof(MsgNewEmail), "Ha establecido su E-mail satisfactoriamente. Su E-mail es: %s", data);
				}
				else
				{
					format(MsgNewEmail, sizeof(MsgNewEmail), "Ha cambiado su E-mail satisfactoriamente. Su nuevo E-mail es: %s", data);
				}

				SendInfoMessage(playerid, 3, "0", MsgNewEmail);

				// sale del gate de login y completa el flujo
				if (PlayersDataOnline[playerid][PendingEmailGate])
				{
					PlayersDataOnline[playerid][PendingEmailGate] = false;
					ContinueLoginFlow(playerid);
				}
				// primera vez del registro, crea la cuenta del foro y continua a sexo
				else if (PlayersDataOnline[playerid][State] == 2)
				{
					Forum_CreateUser(playerid);
					ShowPlayerDialogEx(playerid, 3, DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Sexo", "{"COLOR_TEXTO_DIALOGS"}Cual es el sexo de su personaje?", Sexos[1], Sexos[0]);
				}
				// cambio normal desde la cuenta
				else
				{
					ShowDialogAccount(playerid);
				}
			}
			else
			{
				ShowPlayerEmailChange(playerid, false);
			}
		}
		else
		{
			ShowPlayerEmailChange(playerid, false);
		}
	}
}
ShowPlayerEmailChange(playerid, option)
{
	if ( option == 1 )
	{
		ShowPlayerDialogEx(playerid, 90, DIALOG_STYLE_INPUT, "{"COLOR_AZUL"}Nuevo E-mail", "{"COLOR_TEXTO_DIALOGS"}Ingrese un nuevo Email para su cuenta", "Cambiar", "Volver");
	}
	else if ( option == 2 )
	{
		ShowPlayerDialogEx(playerid, 90, DIALOG_STYLE_INPUT, "{"COLOR_AZUL"}Nuevo E-mail", "{"COLOR_TEXTO_DIALOGS"}Por favor ingrese un correo electronico valido para completar su registro", "Cambiar", "Volver");
	}
	else
	{
		ShowPlayerDialogEx(playerid, 90, DIALOG_STYLE_INPUT, "{"COLOR_AZUL"}Nuevo E-mail", "{"COLOR_TEXTO_DIALOGS"}El E-mail introducido ni es valido, porfavor, revise el mismo.", "Cambiar", "Volver");
	}
}
AddPlayerDescription(playerid, option)
{
	if ( PlayersData[playerid][EnableDescription])
	{
	    if ( option )
	    {
	        Delete3DTextLabelEx(playerid, PlayersDataOnline[playerid][Description3D]);
		}
		if ( PlayersData[playerid][DescriptionSelect] )
		{
			PlayersDataOnline[playerid][Description3D] = Create3DTextLabel(PlayersData[playerid][DescriptionString], DescriptionsPerColors[PlayersData[playerid][DescriptionColor]],0.0, 0.0, 0.0, NAME_TAG_DISTANCE_DEFAULT, GetPlayerVirtualWorld(playerid), true);
		}
		else
		{
			PlayersDataOnline[playerid][Description3D] = Create3DTextLabel(DescriptionsText[PlayersData[playerid][Description]], DescriptionsColors[PlayersData[playerid][Description]],0.0, 0.0, 0.0, NAME_TAG_DISTANCE_DEFAULT, GetPlayerVirtualWorld(playerid), true);
		}
		Attach3DTextLabelToPlayer(PlayersDataOnline[playerid][Description3D], playerid, 0.0, 0.0, 0.3);
		return true;
	}
    return false;
}
RemovePlayerDescription(playerid, option, optiontwo)
{
	if ( PlayersData[playerid][EnableDescription] || optiontwo )
	{
		if ( option )
		{
	    	PlayersData[playerid][EnableDescription] = false;
    	}
        Delete3DTextLabelEx(playerid, PlayersDataOnline[playerid][Description3D]);
        return true;
	}
	else
	{
	    return false;
	}
}
Delete3DTextLabelEx(playerid, Text3D:id)
{
	if ( !Delete3DTextLabel(id) )
	{
		new MsgAviso[MAX_TEXT_CHAT];
	    format(MsgAviso, sizeof(MsgAviso), "%s Debuguer - Text3D Jugador bugueado %s[%i].", LOGO_STAFF, PlayersDataOnline[playerid][NameOnline], playerid);
	    MsgCheatsReportsToAdmins(MsgAviso);
	}
}
ShowMenuDescription(playerid)
{
	new DialogDescription[700];
	if ( PlayersData[playerid][EnableDescription] )
	{
	    format(DialogDescription, sizeof(DialogDescription), "{"COLOR_AZUL"}Estado Estatica:  {"COLOR_AMARILLO"}%s\r\n{"COLOR_AZUL"}Estado Personalizado:  {"COLOR_AMARILLO"}%s\r\n{"COLOR_AZUL"}Usando: {"COLOR_VERDE"}%s\r\n{"COLOR_VERDE"}1- {"COLOR_CREMA"}Modificar Estatica\r\n{"COLOR_VERDE"}2- {"COLOR_CREMA"}Modificar Personalizada\r\n{"COLOR_VERDE"}3- {"COLOR_CREMA"}Estado: {"COLOR_VERDE"}Habilitada",
	    DescriptionsText[PlayersData[playerid][Description]],
		PlayersData[playerid][DescriptionString],
     	DescriptionsPerType[PlayersData[playerid][DescriptionSelect]]	);
	}
	else
	{
	    format(DialogDescription, sizeof(DialogDescription), "{"COLOR_AZUL"}Estado Estatica:  {"COLOR_AMARILLO"}%s\r\n{"COLOR_AZUL"}Estado Personalizado:  {"COLOR_AMARILLO"}%s\r\n{"COLOR_AZUL"}Usando: {"COLOR_VERDE"}%s\r\n{"COLOR_VERDE"}1- {"COLOR_CREMA"}Modificar Estatica\r\n{"COLOR_VERDE"}2- {"COLOR_CREMA"}Modificar Personalizada\r\n{"COLOR_VERDE"}3- {"COLOR_CREMA"}Estado: {"COLOR_ROJO"}Deshabilitada",
	    DescriptionsText[PlayersData[playerid][Description]],
		PlayersData[playerid][DescriptionString],
     	DescriptionsPerType[PlayersData[playerid][DescriptionSelect]]	);
	}
	ShowPlayerDialogEx(playerid,131,DIALOG_STYLE_LIST, "{"COLOR_AZUL"}Estado - Configuracion",DialogDescription, "Seleccionar", "Salir");
}
ShowMenuDescriptionChange(playerid)
{
	new DialogDescription[800];
	new TempConvert[30];
	for ( new i = 0;i < sizeof(DescriptionsText); i++)
	{
	    if ( i )
	    {
			format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_AMARILLO"}%s", DescriptionsText[i]);
		}
		else
		{
			format(TempConvert, sizeof(TempConvert), "{"COLOR_AMARILLO"}%s", DescriptionsText[i]);
		}
	    strcat(DialogDescription, TempConvert, sizeof(DialogDescription));
	}
	ShowPlayerDialogEx(playerid,132,DIALOG_STYLE_LIST, "{"COLOR_AZUL"}Estado - Modificar Estatico",DialogDescription, "Cambiar", "Volver");
}
ShowMenuDescriptionChangePer(playerid)
{
	new DialogDescription[200];
	format(DialogDescription, sizeof(DialogDescription),  "{"COLOR_VERDE"}1- {"COLOR_CREMA"}Color: {%s}%s\r\n{"COLOR_VERDE"}2- {"COLOR_CREMA"}Cambiar Texto", DescriptionsPerColorsHTML[PlayersData[playerid][DescriptionColor]], DescriptionsPerNames[PlayersData[playerid][DescriptionColor]]);
	ShowPlayerDialogEx(playerid,133,DIALOG_STYLE_LIST, "{"COLOR_AZUL"}Estado - Modificar Personalizado", DialogDescription, "Seleccionar", "Volver");
}
ShowMenuDescriptionChangeColors(playerid)
{
	new DialogDescription[700];
	new TempConvert[50];
	for ( new i = 0;i < sizeof(DescriptionsPerNames); i++)
	{
	    if ( i )
	    {
			format(TempConvert, sizeof(TempConvert), "\r\n{%s}%s", DescriptionsPerColorsHTML[i], DescriptionsPerNames[i]);
		}
		else
		{
			format(TempConvert, sizeof(TempConvert), "{%s}%s", DescriptionsPerColorsHTML[i], DescriptionsPerNames[i]);
		}
	    strcat(DialogDescription, TempConvert, sizeof(DialogDescription));
	}
	ShowPlayerDialogEx(playerid,134,DIALOG_STYLE_LIST, "{"COLOR_AZUL"}Estado - Escoger Color",DialogDescription, "Escoger", "Volver");
}
ShowMenuDescriptionChangeText(playerid)
{
	ShowPlayerDialogEx(playerid,135,DIALOG_STYLE_INPUT, "{"COLOR_AZUL"}Estado - Escoger Color","{"COLOR_CREMA"}Introduzca un texto para su estado", "Cambiar", "Volver");
}


IsPlayerNotFullObjects(playerid, msg)
{
	for (new i = 0; i < MAX_OBJECTS_PLAYERS; i++)
	{
	    if ( !PlayersData[playerid][Objetos][i] )
	    {
	        return i;
	    }
	}
	if ( msg )
	{
		SendInfoMessage(playerid, 0, "1575", "No puedes llevar mas objetos encima!");
	}
	return -1;
}
AddObjectHoldToPlayer(playerid, objectid)
{
	new SaveNotFull = IsPlayerNotFullObjects(playerid, false);
	if ( SaveNotFull != -1 )
	{
	    PlayersData[playerid][Objetos][SaveNotFull] = objectid;
		if ( AllowForItSkin(PlayersData[playerid][Skin], GetTypeObjectEx(objectid)) )
		{
	    	PlayersData[playerid][ObjetosVision][SaveNotFull]       = false;
    	}
    	else
    	{
			PlayersData[playerid][ObjetosVision][SaveNotFull]       = true;
    	}
		SetObjectHoldToPlayer(playerid, objectid, SaveNotFull);
		return true;
	}
	else
	{
	    return false;
	}
}
RemoveObjectHoldToPlayer(playerid, objectid, index)
{
    RemovePlayerAttachedObject(playerid, index);
	if ( objectid != -1 )
	{
	    index = HaveObjectPlayer(playerid, objectid);
	    if ( index == -1 )
	    {
	        return false;
        }
	}
    PlayersData[playerid][Objetos][index] = false;
    return true;
}
GetObjectByType(playerid, type)
{
	new TypeSaveTemp;
	for (new i = 0; i < MAX_OBJECTS_PLAYERS; i++)
	{
	    if ( PlayersData[playerid][Objetos][i] )
	    {
            TypeSaveTemp = GetTypeObject(PlayersData[playerid][Objetos][i]);
            if ( type == ObjectPlayersInt[TypeSaveTemp][2] )
            {
                return i;
            }
	    }
    }
    return -1;
}
HaveObjectPlayer(playerid, objectid)
{
	for (new i = 0; i < MAX_OBJECTS_PLAYERS; i++)
	{
	    if ( PlayersData[playerid][Objetos][i] == objectid )
	    {
	        return i;
	    }
	}
	return -1;
}
AllowForItSkin(skinid, type)
{
	if ( type == TYPE_PELO && !IsAllowItSkinForHair(skinid) ||
	     type == TYPE_BOINA && !IsAllowItSkinForBoina(skinid) ||
		 type == TYPE_GORRAS && !IsAllowItSkinForGorras(skinid) ||
		 type == TYPE_RELOJES && !IsAllowItSkinForRelojes(skinid) ||
		 type == TYPE_GAFAS && !IsAllowItSkinForGafas(skinid) ||
		 type == TYPE_CASCO && !IsAllowItSkinForCasco(skinid))
	{
	    return false;
	}
	else
	{
	    return true;
	}
}
ReturnObjetsToPlayer(playerid)
{
	for (new i = 0; i < MAX_OBJECTS_PLAYERS; i++)
	{
	    if ( PlayersData[playerid][Objetos][i] )
	    {
	        if ( !AllowForItSkin(PlayersData[playerid][Skin], GetTypeObjectEx(PlayersData[playerid][Objetos][i])) )
	        {
				if ( !PlayersData[playerid][ObjetosVision][i] )
				{
					PlayersData[playerid][ObjetosVision][i] = true;
					RemovePlayerAttachedObject(playerid, i);
				}
	            continue;
           	}
           	SetObjectHoldToPlayer(playerid, PlayersData[playerid][Objetos][i], i);
	    }
    }
}
SetObjectHoldToPlayer(playerid, objectid, index)
{
	if ( !PlayersData[playerid][ObjetosVision][index] )
	{
		new Float:OffsetsPos[9];
		new SaveRowID = GetTypeObject(objectid);
		if ( SaveRowID != -1 )
		{
			switch (ObjectPlayersInt[SaveRowID][2])
			{
			    case TYPE_MALETIN:
			    {
			        for ( new i = 0; i < sizeof(OffsetsPos); i++ )
			        {
		            	OffsetsPos[i] = ObjectsPlayers[0][i];
	            	}
				}
			    case TYPE_GAFAS:
			    {
			        for ( new i = 0; i < sizeof(OffsetsPos) - 3; i++ )
			        {
		            	OffsetsPos[i] = SkinesGlasesPos[PlayersData[playerid][Skin]][i];
	            	}
	            	OffsetsPos[6] = 1;
	            	OffsetsPos[7] = 1;
	            	OffsetsPos[8] = 1;
			    }
			    case TYPE_PELO:
			    {
			        for ( new i = 0; i < sizeof(OffsetsPos) - 3; i++ )
			        {
		            	OffsetsPos[i] = SkinesHairPos[PlayersData[playerid][Skin]][i];
	            	}
	            	OffsetsPos[6] = SkinesHairPos[PlayersData[playerid][Skin]][8];
	            	OffsetsPos[7] = SkinesHairPos[PlayersData[playerid][Skin]][8];
	            	OffsetsPos[8] = SkinesHairPos[PlayersData[playerid][Skin]][8];
		        }
			    case TYPE_BOINA:
			    {
			        for ( new i = 0; i < sizeof(OffsetsPos); i++ )
			        {
		            	OffsetsPos[i] = SkinesBoina[PlayersData[playerid][Skin]][i];
	            	}
		        }
			    case TYPE_GORRAS:
			    {
			        for ( new i = 0; i < sizeof(OffsetsPos); i++ )
			        {
		            	OffsetsPos[i] = SkinesGorras[PlayersData[playerid][Skin]][i];
	            	}
		        }
			    case TYPE_RELOJES:
			    {
			        for ( new i = 0; i < sizeof(OffsetsPos); i++ )
			        {
		            	OffsetsPos[i] = SkinesRelojes[PlayersData[playerid][Skin]][i];
	            	}
		        }
			    case TYPE_CASCO:
			    {
			        for ( new i = 0; i < sizeof(OffsetsPos); i++ )
			        {
		            	OffsetsPos[i] = SkinesCascos[PlayersData[playerid][Skin]][i];
	            	}
		        }
			    case TYPE_TASER:
			    {
			        for ( new i = 0; i < sizeof(OffsetsPos); i++ )
			        {
		            	OffsetsPos[i] = ObjectsPlayers[1][i];
	            	}
				}
			}
			SetPlayerAttachedObject(playerid, index, objectid, ObjectPlayersInt[SaveRowID][1], OffsetsPos[0],OffsetsPos[1],OffsetsPos[2],OffsetsPos[3],OffsetsPos[4],OffsetsPos[5],OffsetsPos[6],OffsetsPos[7],OffsetsPos[8]);
			return true;
		}
	}
	return false;
}
GetTypeObject(objectid)
{
	for (new i = 0; i < sizeof(ObjectPlayersInt); i++)
	{
		if ( ObjectPlayersInt[i][0] == objectid )
		{
		    return i;
		}
	}
	return -1;
}
GetTypeObjectEx(objectid)
{
	for (new i = 0; i < sizeof(ObjectPlayersInt); i++)
	{
		if ( ObjectPlayersInt[i][0] == objectid )
		{
		    return ObjectPlayersInt[i][2];
		}
	}
	return -1;
}
IsAllowItSkinForCasco(skinid)
{
	if ( SkinesCascos[skinid][0] != 0.0 )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}
IsAllowItSkinForHair(skinid)
{
	if ( SkinesHairPos[skinid][8] != 0.0 )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}
IsAllowItSkinForBoina(skinid)
{
	if ( SkinesBoina[skinid][0] != 0.0 )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}
IsAllowItSkinForGorras(skinid)
{
	if ( SkinesGorras[skinid][0] != 0.0 )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}
IsAllowItSkinForRelojes(skinid)
{
	if ( SkinesRelojes[skinid][8] != 0.0 )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}
IsAllowItSkinForGafas(skinid)
{
	if ( SkinesGlasesPos[skinid][0] != 0.0 )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}
ShowObjectos(playerid)
{
	new ObjetosDialog[500];
	new TempConvert[50];
	new ConteoObjetos = -1;
	for (new i = 0; i < MAX_OBJECTS_PLAYERS; i++)
	{
	    if ( PlayersData[playerid][Objetos][i] )
	    {
			if ( ConteoObjetos != -1 )
			{
			    if ( PlayersData[playerid][ObjetosVision][i] )
			    {
			    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_AZUL"}%s", ObjectsNames[GetTypeObjectEx(PlayersData[playerid][Objetos][i])]);
		    	}
		    	else
		    	{
			    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_VERDE"}%s", ObjectsNames[GetTypeObjectEx(PlayersData[playerid][Objetos][i])]);
		    	}
	    	}
			else
			{
			    if ( PlayersData[playerid][ObjetosVision][i] )
			    {
			    	format(TempConvert, sizeof(TempConvert), "{"COLOR_AZUL"}%s", ObjectsNames[GetTypeObjectEx(PlayersData[playerid][Objetos][i])]);
		    	}
		    	else
		    	{
			    	format(TempConvert, sizeof(TempConvert), "{"COLOR_VERDE"}%s", ObjectsNames[GetTypeObjectEx(PlayersData[playerid][Objetos][i])]);
		    	}
			}
	        strcat(ObjetosDialog, TempConvert, sizeof(ObjetosDialog));
	        ConteoObjetos++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoObjetos] = i;
        }
	}
	if (ConteoObjetos != -1)
	{
		ShowPlayerDialogEx(playerid,148,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Objetos - Control de los objetos", ObjetosDialog, "Opciones", "Salir");
	}
	else
	{
		ShowPlayerDialogEx(playerid,999,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Objetos - informacion", "{"COLOR_TEXTO_DIALOGS"}No llevas objetos.", "Aceptar", "");
	}
}
ShowObjetosOpciones(playerid)
{
	new ObjetTitleName[MAX_TEXT_CHAT];
	format(ObjetTitleName, sizeof(ObjetTitleName), "{"COLOR_AZUL"}Objetos - Opciones del {"COLOR_AMARILLO"}%s", ObjectsNames[GetTypeObjectEx(PlayersData[playerid][Objetos][PlayersDataOnline[playerid][SaveAfterAgenda][10]])]);
	if ( !PlayersData[playerid][ObjetosVision][PlayersDataOnline[playerid][SaveAfterAgenda][10]] )
	{
		ShowPlayerDialogEx(playerid,149,DIALOG_STYLE_LIST, ObjetTitleName, "{"COLOR_AZUL"}1 - {"COLOR_TEXTO_DIALOGS"}Dar\r\n{"COLOR_AZUL"}2 - {"COLOR_TEXTO_DIALOGS"}Dejar\r\n{"COLOR_AZUL"}3 - {"COLOR_TEXTO_DIALOGS"}Tirar\r\n{"COLOR_AZUL"}4 - {"COLOR_TEXTO_DIALOGS"}Guardar", "Seleccionar", "Volver");
	}
	else
	{
		ShowPlayerDialogEx(playerid,149,DIALOG_STYLE_LIST, ObjetTitleName, "{"COLOR_AZUL"}1 - {"COLOR_TEXTO_DIALOGS"}Dar\r\n{"COLOR_AZUL"}2 - {"COLOR_TEXTO_DIALOGS"}Dejar\r\n{"COLOR_AZUL"}3 - {"COLOR_TEXTO_DIALOGS"}Tirar\r\n{"COLOR_AZUL"}4 - {"COLOR_TEXTO_DIALOGS"}Sacar", "Seleccionar", "Volver");
	}
}
ShowDejarObjeto(playerid)
{
	ShowPlayerDialogEx(playerid,151,DIALOG_STYLE_LIST, "{"COLOR_AZUL"}Objetos - Dejar", "{"COLOR_AZUL"}1 - {"COLOR_TEXTO_DIALOGS"}Maletero\r\n{"COLOR_AZUL"}2 - {"COLOR_TEXTO_DIALOGS"}Gaveta\r\n{"COLOR_AZUL"}", "Seleccionar", "Volver");
}
ShowDejarObjetoInput(playerid)
{
	ShowPlayerDialogEx(playerid,152,DIALOG_STYLE_INPUT, "{"COLOR_AZUL"}Objetos - Dejar", "{"COLOR_TEXTO_DIALOGS"}Ingrese la ID del slot que desea dejarlo.\nSi desea dejarlo en el primero disponible,\ndeje en blanco el campo de texto.", "Dejar", "Volver");
}
ShowDarObjeto(playerid)
{
	new ObjetTitleName[MAX_TEXT_CHAT];
	format(ObjetTitleName, sizeof(ObjetTitleName), "{"COLOR_AZUL"}Objetos - Dar {"COLOR_AMARILLO"}%s", ObjectsNames[GetTypeObjectEx(PlayersData[playerid][Objetos][PlayersDataOnline[playerid][SaveAfterAgenda][10]])]);
	ShowPlayerDialogEx(playerid,150,DIALOG_STYLE_INPUT, ObjetTitleName, "{"COLOR_TEXTO_DIALOGS"}Ingrese la ID del jugador al que desea dar este objeto.", "Dar", "Volver");
}
HaveObjectByTypeAndShow(playerid, type)
{
	new responseHave = GetObjectByType(playerid, type);
	if ( responseHave != -1 && !PlayersData[playerid][ObjetosVision][responseHave] )
	{
	    return true;
	}
	return false;
}

function SetPlayerPassword(playerid)
{
 	new hash[BCRYPT_HASH_LENGTH];
	bcrypt_get_hash(hash);
	format(PlayersData[playerid][Password], BCRYPT_HASH_LENGTH, "%s", hash);

	// pide el email antes de crear la cuenta del foro (que ya no recibe "No")
	// nota: si despues el jugador cambia el email desde configuracion (State==3),
	// el foro NO se entera del cambio - gap preexistente, fuera del scope de #15
	ShowPlayerEmailChange(playerid, 2);
	PlayerPlaySound(playerid, 1186, -1999.2559, 743.3678, 58.7168);
	return 1;
}

function OnPasswordChecked(playerid, bool:success)
{
	if(success)
	{
		SetPlayerColor(playerid, PLAYERS_COLOR);
		if ( PlayersData[playerid][IsInJail] != -1)
	        {
			PlayersData[playerid][Jail] = gettime() + PlayersData[playerid][Jail];
			SendInfoMessage(playerid, 2, "0", "Todavia te encuentras en jail de la última vez que jugaste.");
		}
		if ( PlayersData[playerid][Alquiler] != -1 )
		{
			CheckIsPlayerRentAndRemove(playerid, PlayersData[playerid][Alquiler]);
		}
	
		new HoraPaga, MinutosPaga, SegundosPaga;
		gettime(HoraPaga, MinutosPaga, SegundosPaga);
	
		if ( MinutosPaga >= 8 && MinutosPaga <= 50 )
		{
			PlayersDataOnline[playerid][Paga] = true;
		}
		else
		{
			PlayersDataOnline[playerid][Paga] = false;
		}
		if ( PlayersData[playerid][Interior] == 0 && PlayersData[playerid][World] == 0)
		{
			PlayersData[playerid][Spawn_Z] = PlayersData[playerid][Spawn_Z] + 2;
		}
	
		GetPlayerIp(playerid, PlayersData[playerid][MyIP],16);
		
		PlayersDataOnline[playerid][State] = 3;
		ContinueLoginFlow(playerid);
		printf("%s[%i] Logueado!", PlayersDataOnline[playerid][NameOnline], playerid);
	}
	else
	{
		ShowPlayerLogin(playerid, false);
		SendInfoMessage(playerid, 0, "209", "Clave incorrecta, vuelva a intentarlo");
	}
}

function ContinueLoginFlow(playerid)
{
	SetPlayerScore(playerid, GetPlayerScoreEx(playerid));
	LoadPlayerFacebook(playerid);
	SetSpawnInfo(playerid, -1, PlayersData[playerid][Skin],	PlayersData[playerid][Spawn_X], PlayersData[playerid][Spawn_Y], PlayersData[playerid][Spawn_Z], PlayersData[playerid][Spawn_ZZ], WEAPON:0, 0, WEAPON:0, 0, WEAPON:0, 0);
	SpawnPlayer(playerid);
	PlayersDataOnline[playerid][ChalecoOn] = PlayersData[playerid][Chaleco];
	PlayersDataOnline[playerid][VidaOn] = PlayersData[playerid][Vida];
	SetPlayerVirtualWorld(playerid, PlayersData[playerid][World]);
	SetPlayerInteriorEx(playerid, PlayersData[playerid][Interior]);
	SetPlayerFightingStyle(playerid, HabilidadesID[PlayersData[playerid][Habilidad]]);
	PlayersDataOnline[playerid][LoginTime] = gettime();
	GivePlayerMoney(playerid, PlayersData[playerid][Dinero]);
	Streamer_UpdateEx(playerid, PlayersData[playerid][Spawn_X], PlayersData[playerid][Spawn_Y], PlayersData[playerid][Spawn_Z]);

	PlayersDataOnline[playerid][StateMoneyPass] 	= gettime() + 5;
	PlayersDataOnline[playerid][StateWeaponPass] 	= gettime() + 5;
	GivePlayerWeaponReturn(playerid);

	CheckAsignados(playerid);
	LoadAgenda(playerid);
	LoadPlayerSMS(playerid);
	LoadAccountBanking(playerid);
	AddPlayerDescription(playerid, false);

	if ( strlen(PlayersData[playerid][DescriptionString]) < 3 )
	{
		format(PlayersData[playerid][DescriptionString], MAX_TEXT_DESCRIPTION, "Ninguno");
	}

	PlayerPlaySound(playerid, 1186, -1999.2559, 743.3678, 58.7168);
	new HiMsg[45];
	format(HiMsg, sizeof(HiMsg), "~W~Buenas!~N~~B~%s", PlayersDataOnline[playerid][NameOnlineFix]);
	GameTextForPlayer(playerid, HiMsg, 1000, 1);

	// Remove
	if ( PlayersData[playerid][Job] == VENDEDOR_MOVIL && PlayersData[playerid][Faccion] != CIVIL )
	{
		PlayersData[playerid][Job] = NINGUNO;
	}

	if ( PlayersData[playerid][InTutorial] )
	{
		PlayersData[playerid][InTutorial] = true;
		TogglePlayerControllableEx(playerid, false);
		PlayersDataOnline[playerid][IsNotSilenciado] = false;
		SetPlayerTutorial(playerid, 7);
	}
}

function IsPasswordMatches(playerid, bool:success)
{
 	if (success)
 	{
		//Cambiar Contraseña o Email
		switch ( PlayersDataOnline[playerid][SaveAfterAgenda][0] )
		{
			case 0:
			{
			    ShowPlayerEmailChange(playerid, 1);
			}
			case 1:
			{
				ShowPlayerDialogEx(playerid, 17, DIALOG_STYLE_PASSWORD, "{"COLOR_AZUL"}Nueva Clave", "{"COLOR_TEXTO_DIALOGS"}Ingrese su nueva Clave\n{"COLOR_TEXTO_DIALOGS"}y ya habra cambiado su Clave", "Cambiar", "Volver");
			}
		}
 	} 
 	else
 	{
		SendInfoMessage(playerid, 0, "871", "La Clave actual no coincide con la que ingreso, intentelo de nuevo");
		ShowPlayerDialogEx(playerid, 16, DIALOG_STYLE_PASSWORD, "{"COLOR_AZUL"}Confirmacion", "{"COLOR_TEXTO_DIALOGS"}Ingrese su Clave actual", "Confirmar", "Volver");
 	}
}

function ChangeMyPassword(playerid, const newPassword[])
{
 	new hash[BCRYPT_HASH_LENGTH];
	bcrypt_get_hash(hash);
	format(PlayersData[playerid][Password], BCRYPT_HASH_LENGTH, "%s", hash);

	Importante(playerid, "Ha cambiado su Clave satisfactoriamente. Su nueva clave es: %s", newPassword);
	ShowDialogAccount(playerid);
	return 1;
}

function ChangeAccountPassword(playerid, const accountName[], const newPassword[])
{	
	new hash[BCRYPT_HASH_LENGTH], query[200];
	bcrypt_get_hash(hash);

	mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET Password='%s' WHERE Nombre='%e';", DIR_USERS, hash, accountName);
	mysql_query(dataBase, query, false);
	
	ImportanteEx(playerid, "Has cambiado la password de %s, recuerda que la password temporal es: %s", newPassword, newPassword);
	printf("Un administrador cambio la password de %s, la password temporal nueva es: %s", accountName, newPassword);
}