SetPlayerDescolgar(playerid)
{
	PlayPlayerStreamSound(playerid, 3600);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	if ( MovilesObjects[PlayersData[playerid][TypePhone]] == 330 )
	{
		SetPlayerAttachedObject(playerid, 9, MovilesObjects[PlayersData[playerid][TypePhone]], 6);
	}
	else
	{
		SetPlayerAttachedObject(playerid, 9, MovilesObjects[PlayersData[playerid][TypePhone]], 6, 0.079999, -0.004999, -0.009999, 270.000000, 0.000000, 180.000000, 1.000000, 1.000000, 1.000000);
	 //   0.079999, -0.004999, -0.009999, 270.000000, 0.000000, 180.000000, 1.000000, 1.000000, 1.000000
	}
}
SetPlayerCall(playerid, numberphone)
{
	if ( PlayersData[playerid][Phone] != 0)
	{
	    if ( !IsPlayerInCall(playerid) )
	    {
	        if ( PlayersData[playerid][Phone] != numberphone )
	        {
	            if ( numberphone > 0 )
	            {
	                if ( PlayersDataOnline[playerid][PhoneOnline] )
	                {
			            for (new i = 0; i < MAX_PLAYERS; i++)
			            {
							if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && PlayersData[i][Phone] == numberphone && PlayersDataOnline[i][PhoneOnline] && IsNotPhoneInBlackList(i, PlayersData[playerid][Phone]) )
							{
								if ( PlayersDataOnline[i][InCall] == -1 )
								{
								    if ( PlayersData[playerid][Saldo] >= 1 )
								    {
								    	if ( PlayersDataOnline[playerid][CallTime] < gettime() )
								    	{
									        PlayersDataOnline[playerid][CallTime] = gettime() + 5;
										    PlayersDataOnline[playerid][Altavoz] = false;
									        PlayersDataOnline[playerid][ICall] = true;
										    PlayersDataOnline[playerid][InCall] = i;
										    PlayersDataOnline[i][InCall] = playerid;

										    new MsgToMe[MAX_TEXT_CHAT];
										    new MsgToPlayer[MAX_TEXT_CHAT];
										    new IsAgenda = IsInAgendaNumber(playerid, numberphone);
										    new IsAgendaYou = IsInAgendaNumber(i, PlayersData[playerid][Phone]);

											if ( IsAgenda != -1)
											{
												format(MsgToMe, sizeof(MsgToMe), " Esta llamando a %s al numero %i, use \"/C\" (Colgar).",  AgendaData[playerid][IsAgenda][NameC], PlayersData[i][Phone]);
											}
											else
											{
									            format(MsgToMe, sizeof(MsgToMe), " Esta dando timbre el numero %i use \"/C\" (Colgar).", PlayersData[i][Phone]);
								            }

										    if (PlayersData[i][Admin] >= 1)
										    {
												if ( IsAgendaYou != -1)
												{
		           								    format(MsgToPlayer, sizeof(MsgToPlayer), " Esta recibiendo una llamada de %s numero %i use \"/D\" (Descolgar) o \"/C\" (Colgar) (([%i]))", AgendaData[i][IsAgendaYou][NameC], PlayersData[playerid][Phone], playerid);
		       								    }
		       								    else
		       								    {
		           								    format(MsgToPlayer, sizeof(MsgToPlayer), " Esta recibiendo una llamada del numero %i use \"/D\" (Descolgar) o \"/C\" (Colgar) (([%i]))", PlayersData[playerid][Phone], playerid);
												}
										    }
										    else
										    {
												if ( IsAgendaYou != -1)
												{
		           								    format(MsgToPlayer, sizeof(MsgToPlayer), " Esta recibiendo una llamada de %s numero %i use \"/D\" (Descolgar) o \"/C\" (Colgar)", AgendaData[i][IsAgendaYou][NameC], PlayersData[playerid][Phone]);
		       								    }
		       								    else
		       								    {
		           								    format(MsgToPlayer, sizeof(MsgToPlayer), " Esta recibiendo una llamada del numero %i use \"/D\" (Descolgar) o \"/C\" (Colgar)", PlayersData[playerid][Phone]);
												}
											}
											Acciones(playerid, 8, "saca su movil y marca unos numeros");
											Acciones(i, 8, "le suena el movil");

											SendClientMessage(playerid, COLOR_INFO_MOVIL, MsgToMe);
											SendClientMessage(i, COLOR_INFO_MOVIL, MsgToPlayer);
											PlayersDataOnline[playerid][IsDescolgado] 	= true;
											PlayersDataOnline[i][IsDescolgado] 			= false;

											SetPlayerDescolgar(playerid);
											return true;
									    }
									    else
									    {
											SendInfoMessage(playerid, 0, "1219", "Tienes que esperar 5 segundos entre cada llamada!");
										}
								    }
								    else
								    {
										SendInfoMessage(playerid, 0, "1021", "No tienes saldo para realizar una llamada!");
									}
								}
								else
								{
									SendInfoMessage(playerid, 0, "393", "El movil que llama se encuentra ocupado!");
								}
							    return false;
							}
						}
						SendInfoMessage(playerid, 0, "394", "El movil que llama se encuentra apagado o no existe!");
					}
					else
					{
						SendInfoMessage(playerid, 0, "894", "Tiene el movil apagado, enciendelo si desea realizar una llamada!");
					}
				}
				else
				{
					SendInfoMessage(playerid, 0, "395", "El numero que introdujo no existe");
				}
			}
	        else
	        {
				SendInfoMessage(playerid, 0, "396", "Ha introducido su mismo numero de movil");
			}
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "398", "Tu no tienes movil");
	}
	return false;
}
IsPlayerInCall(playerid)
{
    if ( PlayersDataOnline[playerid][InCall] == -1 )
    {
        return false;
	}
	else
	{
		SendInfoMessage(playerid, 0, "397", "Finalize su llamada telefonica actual, antes de realizar otra");
	    return true;
	}
}
RemoveRallaName(playerid)
{
	new h = strlen(PlayersDataOnline[playerid][NameOnline]);
    for( new i = 0; i < h; i++)
    {
        if ( PlayersDataOnline[playerid][NameOnline][i] == '_')
        {
			format(PlayersDataOnline[playerid][NameOnlineFix], MAX_PLAYER_NAME, "%s", PlayersDataOnline[playerid][NameOnline]);
			PlayersDataOnline[playerid][NameOnlineFix][i] = ' ';
			return true;
		}
	}
	format(PlayersDataOnline[playerid][NameOnlineFix], MAX_PLAYER_NAME, "%s", PlayersDataOnline[playerid][NameOnline]);
	return false;
}
SendMessageToCallCNN(playerid)
{
	new MsgLlamar[MAX_TEXT_CHAT];
	format(MsgLlamar, sizeof(MsgLlamar), "Ha entrado una llamada via telefonica a CNN. Numero: %i", PlayersData[playerid][Phone]);
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && PlayersData[i][Faccion] == CNN)
		{
			SendInfoMessage(i, 3, "0", MsgLlamar);
		}
	}
}
IsReadyCallPublic(playerid)
{
	if ( gettime() - PlayersDataOnline[playerid][TimeCallPublics] >= 30 )
	{
		PlayersDataOnline[playerid][TimeCallPublics] = gettime();
		return true;
	}
	else
	{
		new MsgDinamicCallP[MAX_TEXT_CHAT];
		format(MsgDinamicCallP, sizeof(MsgDinamicCallP), "No puedes volver a llamar a un telefono de servicios publicos hasta dentro de %i segundos.", 30 - (gettime() - PlayersDataOnline[playerid][TimeCallPublics]));
		SendInfoMessage(playerid, 0, "979", MsgDinamicCallP);
		return false;
	}
}
PayCall(playerid)
{
	if ( PlayersDataOnline[playerid][IsDescolgado] && CallCNN == playerid ||
		 IsPlayerConnected(playerid) && PlayersDataOnline[playerid][IsDescolgado] && PlayersDataOnline[playerid][InCall] != -1 && PlayersDataOnline[playerid][InCall] != 888 && PlayersDataOnline[PlayersDataOnline[playerid][InCall]][IsDescolgado] )
	{
	    if ( PlayersDataOnline[playerid][ICall] )
	    {
			new MenosSaldo = (gettime() - PlayersDataOnline[playerid][TimeCall]) / 5;
			/* Debug System */
			if ( MenosSaldo >= 1000 )
			{
				new MsgAvisoWeapon[256];
			    if ( PlayersDataOnline[playerid][InCall] != 888 )
			    {
				    format(MsgAvisoWeapon, sizeof(MsgAvisoWeapon), "%s Debug-System - Type: Movil Saldo Multiple. Usuario bugueado: %s[%i]. Usuario involucrado: %s[%i]. Saldo: %i", LOGO_STAFF, PlayersDataOnline[playerid][NameOnline], playerid, PlayersDataOnline[PlayersDataOnline[playerid][InCall]][NameOnline], PlayersDataOnline[playerid][InCall], MenosSaldo);
			    }
			    else
			    {
				    format(MsgAvisoWeapon, sizeof(MsgAvisoWeapon), "%s Debug-System Type: Movil Saldo Solo. Usuario bugueado: %s[%i]. Usuario involucrado: %s[%i]. Saldo: %i", LOGO_STAFF, PlayersDataOnline[playerid][NameOnline], playerid, PlayersDataOnline[PlayersDataOnline[playerid][InCall]][NameOnline], PlayersDataOnline[playerid][InCall], MenosSaldo);
			    }
				MsgCheatsReportsToAdmins(MsgAvisoWeapon);
			    printf("%s", MsgAvisoWeapon);
			}
			else
			{
			/* Debug System */

				if ( MenosSaldo == 0 )
				{
			    	PlayersData[playerid][Saldo]--;
			    	MenosSaldo = 1;
			   	}
			   	else
			   	{
					PlayersData[playerid][Saldo] = PlayersData[playerid][Saldo] - MenosSaldo;
				}
			}
		    PlayersDataOnline[playerid][ICall] = false;
			if (IsPlayerConnected(playerid))
			{
				SetGameTextMoneyMin(playerid, MenosSaldo);
			}
			FaccionData[GOBIERNO][Deposito] = FaccionData[GOBIERNO][Deposito] + MenosSaldo;
		}
	}
}
SetGameTextMoneyMin(playerid, money)
{
	new MsgExToPlayer[MAX_TEXT_CHAT];
	format(MsgExToPlayer, sizeof(MsgExToPlayer), "~W~-~R~%i", money);
	GameTextForPlayer(playerid, MsgExToPlayer, 3000, 1);
}
SendAlertCallRequestSAMD(type, const text[], faccionid)
{
	for ( new i = 0; i < MAX_PLAYERS; i++ )
	{
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && PlayersData[i][Faccion] == faccionid )
		{
		    if ( !type )
		    {
				if ( PlayersData[i][Rango] == 5 ||
			 	PlayersData[i][Rango] <= 2 )
			 	{
					SendInfoMessage(i, 3, "0", text);
				}
		    }
		    else
		    {
		        if ( PlayersData[i][Rango] != 5 )
		        {
					SendInfoMessage(i, 3, "0", text);
				}
			}
		}
	}
}
SendAlertCallRequest(faccionid, const text[])
{
	for ( new i = 0; i < MAX_PLAYERS; i++ )
	{
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && PlayersData[i][Faccion] == faccionid)
		{
			SendInfoMessage(i, 3, "0", text);
		}
	}
}
RemoveCall(callid, departament)
{
	CallPolice[callid][departament][Number] 			= 0;
	format(CallPolice[callid][departament][NameC], MAX_PLAYER_NAME, "");
	format(CallPolice[callid][departament][ReasonC], MAX_TEXT_CHAT, "");
	CallPolice[callid][departament][TimeCall][0] = false;
	CallPolice[callid][departament][TimeCall][1] = false;
	CallPolice[callid][departament][TimeCall][2] = false;
}
AddCall(number, const name[], const reason[], departament)
{
	new callid;
    for ( new i = 0; i < MAX_CALL_POLICE_COUNT; i++ )
    {
		if ( !CallPolice[i][departament][Number] )
		{
		    callid = i;
		    break;
		}
	}
	CallPolice[callid][departament][Number] 			= number;
	format(CallPolice[callid][departament][NameC], MAX_PLAYER_NAME, "%s", name);
	format(CallPolice[callid][departament][ReasonC], MAX_TEXT_CHAT, "%s", reason);
	gettime(CallPolice[callid][departament][TimeCall][0], CallPolice[callid][departament][TimeCall][1], CallPolice[callid][departament][TimeCall][2]);
}
ShowConnectedPolice(playerid)
{
	if ( !PlayersDataOnline[playerid][NumberCallPublic] )
	{
		ShowPlayerDialogEx(playerid,53,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}LSPD - Reporte Policial", "{"COLOR_TEXTO_DIALOGS"}Bienvenido a el departamento de denuncias de la {"COLOR_AMARILLO"}LSPD", "Comenzar", "Colgar");
	}
	else
	{
		ShowPlayerDialogEx(playerid,53,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}SFPD - Reporte Policial", "{"COLOR_TEXTO_DIALOGS"}Bienvenido a el departamento de denuncias de la {"COLOR_AMARILLO"}SFPD", "Comenzar", "Colgar");
	}
}
ShowNamePolice(playerid)
{
	if ( !PlayersDataOnline[playerid][NumberCallPublic] )
	{
		ShowPlayerDialogEx(playerid,54,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}LSPD - Reporte Policial", "{"COLOR_TEXTO_DIALOGS"}Diganos su nombre para proceder.\n\n Si no desea darnos su nombre diga que \"No\"", "Seguir", "No");
	}
	else
	{
		ShowPlayerDialogEx(playerid,54,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}SFPD - Reporte Policial", "{"COLOR_TEXTO_DIALOGS"}Diganos su nombre para proceder.\n\n Si no desea darnos su nombre diga que \"No\"", "Seguir", "No");
	}
}
ShowReasonPolice(playerid)
{
	if ( !PlayersDataOnline[playerid][NumberCallPublic])
	{
		ShowPlayerDialogEx(playerid,55,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}LSPD - Reporte Policial", "{"COLOR_TEXTO_DIALOGS"}Ingrese la razón de su denuncia\n\n{"COLOR_TEXTO_DIALOGS"}Por favor, sea breve y claro en su reporte policial.", "Reportar", "Colgar");
	}
	else
	{
		ShowPlayerDialogEx(playerid,55,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}SFPD - Reporte Policial", "{"COLOR_TEXTO_DIALOGS"}Ingrese la razón de su denuncia\n\n{"COLOR_TEXTO_DIALOGS"}Por favor, sea breve y claro en su reporte policial.", "Reportar", "Colgar");
	}
}
ShowDetailsCall(playerid, callid)
{
	new CallDialog[300];
	new NowTime[3]; gettime(NowTime[0], NowTime[1], NowTime[2]);
	format(CallDialog ,sizeof(CallDialog), "   {"COLOR_ROJO"}REPORTE POLICIAL\n   {"COLOR_CREMA"}Hora actual: {"COLOR_AZUL"}%i:%i:%i\n\n {"COLOR_VERDE"}Nombre: {"COLOR_AMARILLO"}%s\n\n {"COLOR_VERDE"}Numero: {"COLOR_AMARILLO"}%i\n\n {"COLOR_VERDE"}Hora: {"COLOR_AMARILLO"}%i:%i:%i\n\n {"COLOR_VERDE"}Razón: {"COLOR_AMARILLO"}%s",
	NowTime[0],
	NowTime[1],
	NowTime[2],
	CallPolice[callid][PlayersDataOnline[playerid][NumberCallPublic]][NameC],
	CallPolice[callid][PlayersDataOnline[playerid][NumberCallPublic]][Number],
	CallPolice[callid][PlayersDataOnline[playerid][NumberCallPublic]][TimeCall][0],
	CallPolice[callid][PlayersDataOnline[playerid][NumberCallPublic]][TimeCall][1],
	CallPolice[callid][PlayersDataOnline[playerid][NumberCallPublic]][TimeCall][2],
	CallPolice[callid][PlayersDataOnline[playerid][NumberCallPublic]][ReasonC]);

	ShowPlayerDialogEx(playerid,58,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Detalles - Reporte Policial", CallDialog, "Atender", "Volver");
}
ShowCallPolice(playerid)
{
	new CallDialog[700];
	new TempConvert[35];
	new ReasonShort[10];
	new ConteoCall = -1;
	for (new i = 0; i < MAX_CALL_POLICE_COUNT; i++)
	{
	    if ( CallPolice[i][PlayersDataOnline[playerid][NumberCallPublic]][Number] )
	    {
		    format(ReasonShort, sizeof(ReasonShort), "%s", CallPolice[i][PlayersDataOnline[playerid][NumberCallPublic]][ReasonC]);
			if ( ConteoCall != -1 )
			{
		    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}%i - [%s...]",
				CallPolice[i][PlayersDataOnline[playerid][NumberCallPublic]][Number],
		    	ReasonShort
				);
	    	}
			else
			{
		    	format(TempConvert, sizeof(TempConvert), "{"COLOR_CREMA"}%i - [%s...]",
				CallPolice[i][PlayersDataOnline[playerid][NumberCallPublic]][Number],
		    	ReasonShort
				);
			}
	        strcat(CallDialog, TempConvert, sizeof(CallDialog));
	        ConteoCall++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoCall] = i;
        }
	}
	if (ConteoCall != -1)
	{
		if ( !PlayersDataOnline[playerid][NumberCallPublic] )
		{
			ShowPlayerDialogEx(playerid,57,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}LSPD - Reportes policiales", CallDialog, "Ver", "Salir");
		}
		else
		{
			ShowPlayerDialogEx(playerid,57,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}SFPD - Reportes policiales", CallDialog, "Ver", "Salir");
		}
	}
	else
	{
		ShowPlayerDialogEx(playerid,9999,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Policia - informacion", "{"COLOR_TEXTO_DIALOGS"}No se encontraron reportes policiales! Intente mas tarde.", "Aceptar", "");
	}
}
GetNumberID(number)
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && PlayersData[i][Phone] == number && PlayersDataOnline[i][PhoneOnline] )
		{
		    return i;
		}
	}
	return -1;
}
AddCallPublics(playerid, number, departament)
{
	new callid;
    for ( new i = 0; i < MAX_CALL_POLICE_COUNT; i++ )
    {
		if ( !CallPublics[i][departament][Number] )
		{
		    CallPublics[i][departament][City] = GetMyNearCity(playerid);
		    callid = i;
		    break;
		}
	}
	CallPublics[callid][departament][Number] 			= number;
}
RemoveCallPublics(callid, departament)
{
	CallPublics[callid][departament][Number] 			= 0;
}
ShowCallPublics(playerid)
{
	new CallDialog[750];
	new TempConvert[45];
	new ConteoCall = -1;
	for (new i = 0; i < MAX_CALL_POLICE_COUNT; i++)
	{
	    if ( CallPublics[i][PlayersDataOnline[playerid][NumberCallPublic]][Number] )
	    {
			if ( ConteoCall != -1 )
			{
		    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}Numero: {"COLOR_VERDE"}%i (%s)",
				CallPublics[i][PlayersDataOnline[playerid][NumberCallPublic]][Number],
				Ciudades[CallPublics[i][PlayersDataOnline[playerid][NumberCallPublic]][City]]
				);
	    	}
			else
			{
		    	format(TempConvert, sizeof(TempConvert), "{"COLOR_CREMA"}Numero: {"COLOR_VERDE"}%i (%s)",
				CallPublics[i][PlayersDataOnline[playerid][NumberCallPublic]][Number],
			    Ciudades[CallPublics[i][PlayersDataOnline[playerid][NumberCallPublic]][City]]
				);
			}
	        strcat(CallDialog, TempConvert, sizeof(CallDialog));
	        ConteoCall++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoCall] = i;
        }
	}
	if (ConteoCall != -1)
	{
	    switch ( PlayersDataOnline[playerid][NumberCallPublic] )
	    {
			case 0:
			{
				ShowPlayerDialogEx(playerid,59,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Taxistas - Centro de Llamadas", CallDialog, "Atender", "Salir");
			}
			case 1:
			{
				ShowPlayerDialogEx(playerid,59,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Taller San Fierro - Centro de Llamadas", CallDialog, "Atender", "Salir");
			}
			case 2:
			{
				ShowPlayerDialogEx(playerid,59,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Taller Los Santos - Centro de Llamadas", CallDialog, "Atender", "Salir");
			}
		}
	}
	else
	{
		ShowPlayerDialogEx(playerid,9999,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Centro de Llamadas - informacion", "{"COLOR_TEXTO_DIALOGS"}No se encontraron llamadas! Intente mas tarde.", "Aceptar", "");
	}
}

IsFoundCallSAMD(number, type, samdid)
{
    for ( new i = 0; i < MAX_CALL_POLICE_COUNT; i++ )
    {
		if ( CallSAMD[samdid][i][Number] && CallSAMD[samdid][i][Number] == number && type == CallSAMD[samdid][i][Type])
		{
			return i;
		}
	}
	return -1;
}
IsFoundCall(number, departament)
{
    for ( new i = 0; i < MAX_CALL_POLICE_COUNT; i++ )
    {
		if ( CallPublics[i][departament][Number] && CallPublics[i][departament][Number] == number)
		{
			return i;
		}
	}
	return -1;
}
RemoveCallSAMD(callid, samdid)
{
	CallSAMD[samdid][callid][Number] 			= 0;
}
AddCallSAMD(departament, city, number, type)
{
	new callid;
    for ( new i = 0; i < MAX_CALL_POLICE_COUNT; i++ )
    {
		if ( !CallSAMD[departament][i][Number] )
		{
		    CallSAMD[departament][i][City] = city;
		    CallSAMD[departament][i][Type] = type;
		    callid = i;
		    break;
		}
	}
	CallSAMD[departament][callid][Number] = number;
}
ShowConnectedRequest(playerid)
{
	if ( PlayersDataOnline[playerid][SaveAfterAgenda][50] )
	{
		ShowPlayerDialogEx(playerid,73,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}LSMD - Emergencias", "{"COLOR_TEXTO_DIALOGS"}¿Qué servicio necesita?\n\n{"COLOR_AMARILLO"}LSMD {"COLOR_TEXTO_DIALOGS"}presta los siguientes servicios:", "Medico", "Bombero");
	}
	else
	{
		ShowPlayerDialogEx(playerid,73,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}SFMD - Emergencias", "{"COLOR_TEXTO_DIALOGS"}¿Qué servicio necesita?\n\n{"COLOR_AMARILLO"}SFMD {"COLOR_TEXTO_DIALOGS"}presta los siguientes servicios:", "Medico", "Bombero");
	}
}
ShowConnectedSAMD(playerid)
{
	if ( PlayersDataOnline[playerid][SaveAfterAgenda][50] )
	{
		ShowPlayerDialogEx(playerid,72,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}LSMD - Emergencias", "{"COLOR_TEXTO_DIALOGS"}Bienvenido a el departamento de emergencias {"COLOR_AMARILLO"}LSMD", "Comenzar", "Colgar");
	}
	else
	{
		ShowPlayerDialogEx(playerid,72,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}SFMD - Emergencias", "{"COLOR_TEXTO_DIALOGS"}Bienvenido a el departamento de emergencias {"COLOR_AMARILLO"}SFMD", "Comenzar", "Colgar");
	}
}
ShowCallSAMD(playerid)
{
	new CallDialog[750];
	new TempConvert[45];
	new ConteoCall = -1;
	for (new i = 0; i < MAX_CALL_POLICE_COUNT; i++)
	{
	    if ( CallSAMD[PlayersDataOnline[playerid][SaveAfterAgenda][50]][i][Number] && PlayersDataOnline[playerid][NumberCallPublic] == CallSAMD[PlayersDataOnline[playerid][SaveAfterAgenda][50]][i][Type] )
	    {
			if ( ConteoCall != -1 )
			{
		    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}Numero: {"COLOR_VERDE"}%i (%s)",
				CallSAMD[PlayersDataOnline[playerid][SaveAfterAgenda][50]][i][Number],
				Ciudades[CallPublics[i][PlayersDataOnline[playerid][NumberCallPublic]][City]]
				);
	    	}
			else
			{
		    	format(TempConvert, sizeof(TempConvert), "{"COLOR_CREMA"}Numero: {"COLOR_VERDE"}%i (%s)",
				CallSAMD[PlayersDataOnline[playerid][SaveAfterAgenda][50]][i][Number],
			    Ciudades[CallPublics[i][PlayersDataOnline[playerid][NumberCallPublic]][City]]
				);
			}
	        strcat(CallDialog, TempConvert, sizeof(CallDialog));
	        ConteoCall++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoCall] = i;
        }
	}
	if (ConteoCall != -1)
	{
	    if ( PlayersDataOnline[playerid][NumberCallPublic] )
	    {
			ShowPlayerDialogEx(playerid,139,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Medicos - Centro de Llamadas", CallDialog, "Opciones", "Salir");
		}
		else
		{
			ShowPlayerDialogEx(playerid,139,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Bomberos - Centro de Llamadas", CallDialog, "Opciones", "Salir");
		}
	}
	else
	{
	    if  ( PlayersDataOnline[playerid][SaveAfterAgenda][50] )
	    {
			ShowPlayerDialogEx(playerid,9999,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Centro de Llamadas - LSMD", "{"COLOR_TEXTO_DIALOGS"}No se encontraron llamadas! Intente mas tarde.", "Aceptar", "");
		}
		else
		{
			ShowPlayerDialogEx(playerid,9999,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Centro de Llamadas - SFMD", "{"COLOR_TEXTO_DIALOGS"}No se encontraron llamadas! Intente mas tarde.", "Aceptar", "");
		}
	}
}
BuyPhone(playerid)
{
	new Go = true;
	do
	{
	    new savehere = random(99999) + 1000;
        if ( CheckNumberAvalible(savehere) )
        {
			BuyPhoneNow(playerid, savehere);
			Go = false;
		}
	}
	while( Go );
	return true;
}
CheckNumberAvalible(number)
{
    new query[200], Cache:cacheid, numberExist;
	format(query, 200, "SELECT `Phone` FROM `%s` WHERE `Phone`='%i';", DIR_USERS, number);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(numberExist);
	cache_delete(cacheid);
	if ( !numberExist )
	{
		return true;
	}
	else return false;
}
BuyPhoneNow(playerid, number)
{
    if ( CheckNumberAvalible(number) )
    {
		new query[200];
		PlayersData[playerid][Phone] = number;
        mysql_format(dataBase, query, 200, "UPDATE `%s` SET `Phone`='%i' WHERE `Nombre`='%e';", DIR_USERS, PlayersData[playerid][Phone], PlayersDataOnline[playerid][NameOnline]);
		mysql_query(dataBase, query, false);
		return true;
	}
	else
	{
	    return false;
	}
}
SendSMS(playerid, number, const text[])
{
    if ( PlayersData[playerid][Phone] != 0)
    {
	    if ( PlayersDataOnline[playerid][PhoneOnline] )
	    {
	        if ( PlayersDataOnline[playerid][InCall] == -1 )
	        {
	            if ( PlayersData[playerid][Phone] != number )
	            {
	                if ( number > 0 )
	                {
						if (PlayersData[playerid][Saldo] >= strlen(text) )
						{
						    if ( strlen(text) >= 1 )
						    {
					            for (new i = 0; i < MAX_PLAYERS; i++)
					            {
									if ( IsPlayerLogued(i) && PlayersData[i][Phone] == number && PlayersDataOnline[i][PhoneOnline] && IsNotPhoneInBlackList(i, PlayersData[playerid][Phone]) )
									{
									    new MsgToMe[MAX_TEXT_CHAT];
									    new MsgToPlayer[MAX_TEXT_CHAT];
									    new IsAgenda = IsInAgendaNumber(playerid, PlayersData[i][Phone]);
									    new IsAgendaYou = IsInAgendaNumber(i, PlayersData[playerid][Phone]);

										if ( IsAgenda != -1)
										{
									   		format(MsgToMe, sizeof(MsgToMe), "[SMS] Enviado a %s al numero %i: %s", AgendaData[playerid][IsAgenda][NameC], PlayersData[i][Phone], text);
								   		}
								   		else
								   		{
									   		format(MsgToMe, sizeof(MsgToMe), "[SMS] Enviado al numero %i: %s", PlayersData[i][Phone], text);
										}
									    if (IsAgendaYou != -1)
									    {
										    format(MsgToPlayer, sizeof(MsgToPlayer), " [SMS] Recibido de %s numero %i: %s", AgendaData[i][IsAgendaYou][NameC], PlayersData[playerid][Phone], text, playerid);
									    }
									    else
									    {
										    format(MsgToPlayer, sizeof(MsgToPlayer), " [SMS] Recibido del numero %i: %s", PlayersData[playerid][Phone], text);
										}

										if ( PlayersData[i][Admin] >= 1 )
										{
										    format(MsgToPlayer, sizeof(MsgToPlayer), "%s (([%i]))",MsgToPlayer, playerid);
										}

										Acciones(playerid, 8, "saca su movil y envia un SMS");
										Acciones(i, 8, "recibe un SMS en el movil");

										SendClientMessage(playerid, COLOR_INFO_MOVIL, MsgToMe);
										SendClientMessage(i, COLOR_INFO_MOVIL, MsgToPlayer);
										SetPlayerDescolgar(playerid);
										SetTimerEx("SetPlayerColgar", 3000, false, "d", playerid);

										AddSMS(i, PlayersData[playerid][Phone], text);

										PlayersData[playerid][Saldo] = PlayersData[playerid][Saldo]  -strlen(text);
									    FaccionData[GOBIERNO][Deposito] = FaccionData[GOBIERNO][Deposito] + strlen(text);
									    return true;
									}
								}
								SendInfoMessage(playerid, 0, "819", "El movil que desea enviar un SMS se encuentra apagado o no existe!");
								return true;
							}
							else
							{
								SendInfoMessage(playerid, 0, "826", "Minimo utilza un caracter para el SMS");
							}
						}
						else
						{
							SendInfoMessage(playerid, 0, "824", "No tiene suficiente saldo para enviar un SMS");
						}
					}
					else
					{
						SendInfoMessage(playerid, 0, "820", "El numero que introdujo no existe");
					}
				}
	            else
	            {
					SendInfoMessage(playerid, 0, "821", "Ha introducido su mismo numero de movil");
				}
			}
			else
			{
				SendInfoMessage(playerid, 0, "822", "Finalize su llamada telefonica actual antes de enviar un SMS");
			}
		}
		else
		{
			SendInfoMessage(playerid, 0, "1520", "Tiene el movil apagado, enciendelo si desea realizar enviar un SMS!");
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "823", "Tu no tienes movil");
	}
	return false;
}
LoadPlayerSMS(playerid)
{
    CleanSMS(playerid);
	new query[100], Cache:CACHE, rowExist;
	format(query, sizeof(query), "SELECT * FROM %s WHERE user_id=%d;", DIR_SMS, PlayersData[playerid][DB_ID]);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowExist);

	if(rowExist){
		for (new i = 0; i < MAX_SMS_COUNT; i++)
		{
			/*
				Para no andar poniendo el nombre de las columnas con format y crear strings 
				( new fieldName[2][12]; for(i...) format(fieldName[0], 12, "Number_%d", i)... ) lo dejo asi
			*/
			cache_get_value_index_int(0, i*2+1, SMS[playerid][i][Number]);
			cache_get_value_index(0, i*2+2, SMS[playerid][i][SMSText], MAX_TEXT_SMS);
		}
	}
	cache_delete(CACHE);
}
SavePlayerSMS(playerid)
{
	new query[1024], Cache:CACHE, rowExist;
	format(query, 100, "SELECT user_id FROM %s WHERE user_id=%d;", DIR_SMS, PlayersData[playerid][DB_ID]);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowExist);
	cache_delete(CACHE);

	if(!rowExist){
		mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s (user_id) VALUES ('%d');", DIR_SMS, PlayersData[playerid][DB_ID]);
		mysql_query(dataBase, query, false);
	}

	format(query, sizeof(query), "UPDATE %s SET ", DIR_SMS);
	for (new i = 0; i < MAX_SMS_COUNT; i++)
	{
		if(i == (MAX_SMS_COUNT - 1))
		{
			mysql_format(dataBase, query, sizeof(query), "%s`Number_%d`='%d',`SMSText_%d`='%e'", query,
				i, SMS[playerid][i][Number],
				i, SMS[playerid][i][SMSText]);
		}
		else
		{
			mysql_format(dataBase, query, sizeof(query), "%s`Number_%d`='%d',`SMSText_%d`='%e',", query,
				i, SMS[playerid][i][Number],
				i, SMS[playerid][i][SMSText]);
		}
	}
	mysql_format(dataBase, query, sizeof(query), "%s WHERE user_id=%d;", query, PlayersData[playerid][DB_ID]);
	mysql_query(dataBase, query, false);
}
AddSMS(playerid, number, const text[])
{
	for (new i = 0; i < MAX_SMS_COUNT;i++)
	{
	    if ( !SMS[playerid][i][Number] )
	    {
	        SMS[playerid][i][Number] = number;
	        format(SMS[playerid][i][SMSText], MAX_TEXT_SMS, "%s", text);
			SavePlayerSMS(playerid);
	        return true;
        }
	}
    SendInfoMessage(playerid, 2, "0", "No se estan almacenando los SMS en la Agenda, debido a que esta llena!");
	return false;
}
CleanSMS(playerid)
{
	for (new i = 0; i < MAX_SMS_COUNT;i++)
	{
		SMS[playerid][i][Number] = 0;
		format(SMS[playerid][i][SMSText], MAX_TEXT_SMS, "0");
	}
}
RemoveSMS(playerid, smsid)
{
	SMS[playerid][smsid][Number] = 0;
	format(SMS[playerid][smsid][SMSText], MAX_TEXT_SMS, "0");
	SavePlayerSMS(playerid);
}
ShowSMSToPlayer(playerid)
{
	new SMSDialog[750];
	new Msg10Char[10];
	new TempConvert[50];
	new ConteoSMS = -1;
	for (new i = 0; i < MAX_SMS_COUNT; i++)
	{
	    if ( SMS[playerid][i][Number] )
	    {
	    	new IsAgenda = IsInAgendaNumber(playerid, SMS[playerid][i][Number]);
		    format(Msg10Char, sizeof(Msg10Char), "%s", SMS[playerid][i][SMSText]);
			if ( ConteoSMS != -1 )
			{
    	    	if ( IsAgenda != -1 )
    	    	{
			    	format(TempConvert, sizeof(TempConvert), "\r\n%i (%s) - {"COLOR_AMARILLO"}[%s...]", SMS[playerid][i][Number], AgendaData[playerid][IsAgenda][NameC],  Msg10Char);
	    		}
	    		else
	    		{
			    	format(TempConvert, sizeof(TempConvert), "\r\n%i - {"COLOR_AMARILLO"}[%s...]", SMS[playerid][i][Number], Msg10Char);
				}
	    	}
			else
			{
    	    	if ( IsAgenda != -1 )
    	    	{
			    	format(TempConvert, sizeof(TempConvert), "%i (%s) - {"COLOR_AMARILLO"}[%s...]", SMS[playerid][i][Number], AgendaData[playerid][IsAgenda][NameC],  Msg10Char);
		    	}
		    	else
		    	{
			    	format(TempConvert, sizeof(TempConvert), "%i - {"COLOR_AMARILLO"}[%s...]", SMS[playerid][i][Number], Msg10Char);
				}
			}
	        strcat(SMSDialog, TempConvert, sizeof(SMSDialog));
	        ConteoSMS++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoSMS] = i;
        }
	}
	if (ConteoSMS != -1)
	{
		ShowPlayerDialogEx(playerid,62,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Agenda - SMS", SMSDialog, "Opciones", "Volver");
	}
	else
	{
		ShowPlayerDialogEx(playerid,21,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Agenda - informacion", "{"COLOR_TEXTO_DIALOGS"}No se encontraron SMS.", "Aceptar", "Volver");
	}
}
ShowSMSOptionsToPlayer(playerid, smsid)
{
	PlayersDataOnline[playerid][SaveAfterAgenda][0] = smsid;
	ShowPlayerDialogEx(playerid,61,DIALOG_STYLE_LIST, "{"COLOR_AZUL"}Agenda - SMS {"COLOR_AMARILLO"}Opciones", "{"COLOR_AZUL"}1 - {"COLOR_CREMA"}Leer\r\n{"COLOR_AZUL"}2 - {"COLOR_CREMA"}Responder\r\n{"COLOR_AZUL"}3 - {"COLOR_CREMA"}Llamar\r\n{"COLOR_AZUL"}4 - {"COLOR_CREMA"}Borrar", "Seleccionar", "Volver");
}
ShowReadSMS(playerid, smsid)
{
	new MsgRead[350];
   	new IsAgenda = IsInAgendaNumber(playerid, SMS[playerid][smsid][Number]);
   	if ( IsAgenda != -1 )
   	{
		format(MsgRead, sizeof(MsgRead), "{"COLOR_VERDE"}Numero: {"COLOR_CREMA"}%i (%s)\n\n{"COLOR_VERDE"}Contenido:\n{"COLOR_CREMA"}%s", SMS[playerid][smsid][Number], AgendaData[playerid][IsAgenda][NameC], SMS[playerid][smsid][SMSText]);
	}
	else
	{
		format(MsgRead, sizeof(MsgRead), "{"COLOR_VERDE"}Numero: {"COLOR_CREMA"}%i\n\n{"COLOR_VERDE"}Contenido:\n{"COLOR_CREMA"}%s", SMS[playerid][smsid][Number], SMS[playerid][smsid][SMSText]);
	}

	ShowPlayerDialogEx(playerid,63,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Agenda - SMS {"COLOR_AMARILLO"}Leer", MsgRead, "Aceptar", "Volver");
}
ShowReplySMS(playerid, smsid)
{
	new MsgTitleDialog[150];
   	new IsAgenda = IsInAgendaNumber(playerid, SMS[playerid][smsid][Number]);
   	if ( IsAgenda != -1 )
   	{
		format(MsgTitleDialog, sizeof(MsgTitleDialog), "{"COLOR_TEXTO_DIALOGS"}Escriba lo que desea responderle a {"COLOR_AMARILLO"}%s {"COLOR_TEXTO_DIALOGS"}({"COLOR_VERDE"}%i{"COLOR_TEXTO_DIALOGS"})", AgendaData[playerid][IsAgenda][NameC], SMS[playerid][smsid][Number]);
	}
	else
	{
		format(MsgTitleDialog, sizeof(MsgTitleDialog), "{"COLOR_TEXTO_DIALOGS"}Escriba lo que desea responder al numero {"COLOR_VERDE"}%i", SMS[playerid][smsid][Number]);
	}
	ShowPlayerDialogEx(playerid,64,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Agenda - SMS {"COLOR_AMARILLO"}Responder", MsgTitleDialog, "Enviar", "Volver");
}
ShowRemoveSMS(playerid, smsid)
{
	ShowPlayerDialogEx(playerid,21,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Agenda - informacion", "{"COLOR_TEXTO_DIALOGS"}Ha eliminado con exito este SMS.", "Aceptar", "Inicio");
	RemoveSMS(playerid, smsid);
}

ShowSendSMSAgenda(playerid, agendaid)
{
	PlayersDataOnline[playerid][SaveAfterAgenda][0] = agendaid;
	new TempFormat1[256];
	new TempFormat[35];

	format(TempFormat1, sizeof(TempFormat1),"{"COLOR_TEXTO_DIALOGS"}Ingrese el contenido del SMS que desea enviarle a {"COLOR_AMARILLO"}%s {"COLOR_VERDE"}(%i)",
	AgendaData[playerid][agendaid][NameC],
	AgendaData[playerid][agendaid][NumberC]);
	format(TempFormat, sizeof(TempFormat), "{"COLOR_AZUL"}Agenda - %s",
	AgendaData[playerid][agendaid][NameC]);

	ShowPlayerDialogEx(playerid,128,DIALOG_STYLE_INPUT, TempFormat, TempFormat1, "Enviar", "Cancelar");
}

ShowBuscarAgenda(playerid)
{
	ShowPlayerDialogEx(playerid,129,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Agenda - Buscar", "{"COLOR_TEXTO_DIALOGS"}Ingrese la frase que desea buscar.", "Buscar", "Volver");
}
ShowBuscarResultAgenda(playerid, const text[])
{
	new AgendaDialog[2150];
	new TempConvert[50];
	new ConteoAgenda = -1;
	for (new i = 0; i < MAX_PLAYER_CONTACT; i++)
	{
	    if ( strlen(AgendaData[playerid][i][NameC]) >= 2 )
	    {
	        format(TempConvert, sizeof(TempConvert), "%i", AgendaData[playerid][i][NumberC]);
	        if ( strfind(TempConvert, text, true) != -1 || strfind(AgendaData[playerid][i][NameC], text, true) != -1)
	        {
				if ( ConteoAgenda != -1 )
				{
			    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_VERDE"}%i - %s", AgendaData[playerid][i][NumberC], AgendaData[playerid][i][NameC]);
		    	}
				else
				{
				    format(TempConvert, sizeof(TempConvert), "{"COLOR_VERDE"}%i - %s", AgendaData[playerid][i][NumberC], AgendaData[playerid][i][NameC]);
				}
		        strcat(AgendaDialog, TempConvert, sizeof(AgendaDialog));
		        ConteoAgenda++;
		        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoAgenda] = i;
	        }
        }
	}
	if (ConteoAgenda != -1)
	{
		ShowPlayerDialogEx(playerid,130,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Agenda - Resultados de la Busqueda", AgendaDialog, "Opciones", "Inicio");
	}
	else
	{
	    format(AgendaDialog, sizeof(AgendaDialog), "{"COLOR_TEXTO_DIALOGS"}No se encontraron resultados\n{"COLOR_TEXTO_DIALOGS"}en la busqueda para {"COLOR_ROJO"}%s", text);
		ShowPlayerDialogEx(playerid,21,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Agenda - informacion", AgendaDialog, "Aceptar", "Volver");
	}
}

ConfirmDeletedAllSMS(playerid)
{
	ShowPlayerDialogEx(playerid,66,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Agenda - SMS {"COLOR_AMARILLO"}Borrar Todos","{"COLOR_CREMA"}Esta seguro que desea {"COLOR_ROJO"}BORRAR TODOS{"COLOR_AZUL"} los SMS?", "Borrarlos", "Volver");
}

LoadAgenda(playerid)
{
	CleanAgenda(playerid);
	new query[80], Cache:CACHE, rowCount;
	format(query, sizeof(query), "SELECT * FROM %s WHERE user_id=%d;", DIR_CONTACTS, PlayersData[playerid][DB_ID]);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowCount);

	if ( rowCount )
	{
		rowCount = (rowCount > MAX_PLAYER_CONTACT) ? (MAX_PLAYER_CONTACT):(rowCount);
		for(new i; i != rowCount; i++){
			cache_get_value_index(i, 3, AgendaData[playerid][i][NameC], MAX_AGENDA_NAME);
			cache_get_value_index_int(i, 4, AgendaData[playerid][i][NumberC]);
			cache_get_value_index_int(i, 5, AgendaData[playerid][i][IsBlackList]);
		}
	}
	else printf("[%s]: Error al cargar contactos de la agenda de %s", DIR_CONTACTS, PlayersDataOnline[playerid][NameOnline]);
	cache_delete(CACHE);
}
SaveAgenda(playerid)
{
	new query[1024], Cache:CACHE, rowCount;
	format(query, 200, "SELECT * FROM %s WHERE user_id=%d;", DIR_CONTACTS, PlayersData[playerid][DB_ID]);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowCount);
	cache_delete(CACHE);

	if(rowCount < MAX_PLAYER_CONTACT){//Sistema actualizable si se incrementa el maximo de contactos ( cosa que no creo xd )
		new i = (!rowCount) ? (0) : (rowCount);
		const limit = MAX_PLAYER_CONTACT - 1;
		mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s (user_id,contact_id,NameC,NumberC,IsBlackList) VALUES ", DIR_CONTACTS);
		for(; i != MAX_PLAYER_CONTACT; i++){
			if(i == limit)
			mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,'%e',%d,%d)", query, PlayersData[playerid][DB_ID], i, AgendaData[playerid][i][NameC], AgendaData[playerid][i][NumberC], AgendaData[playerid][i][IsBlackList]);
			else
			mysql_format(dataBase, query, sizeof(query), "%s(%d,%d,'%e',%d,%d),", query, PlayersData[playerid][DB_ID], i, AgendaData[playerid][i][NameC], AgendaData[playerid][i][NumberC], AgendaData[playerid][i][IsBlackList]);
		}
		mysql_query(dataBase, query, false);
	}
	else{
		for(new i; i != MAX_PLAYER_CONTACT; i++){
			mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET NameC='%e',NumberC='%d',IsBlackList='%d' WHERE user_id=%d AND contact_id=%d;", DIR_CONTACTS, 
				AgendaData[playerid][i][NameC], 
				AgendaData[playerid][i][NumberC], 
				AgendaData[playerid][i][IsBlackList],
				PlayersData[playerid][DB_ID], i);
			mysql_query(dataBase, query, false);
		}
	}
}
SaveAgendaEx(playerid, contact_id)
{
	new query[1024], Cache:CACHE, rowCount;
	format(query, 200, "SELECT * FROM %s WHERE user_id=%d;", DIR_CONTACTS, PlayersData[playerid][DB_ID]);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(rowCount);
	cache_delete(CACHE);

	if(rowCount < MAX_PLAYER_CONTACT){
		SaveAgenda(playerid);
		return true;
	}
	else{
		mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET NameC='%e',NumberC='%d',IsBlackList='%d' WHERE user_id=%d AND contact_id=%d;", DIR_CONTACTS, 
			AgendaData[playerid][contact_id][NameC], 
			AgendaData[playerid][contact_id][NumberC], 
			AgendaData[playerid][contact_id][IsBlackList],
			PlayersData[playerid][DB_ID], contact_id);
		mysql_query(dataBase, query, false);
	}
	return true;
}
CleanAgenda(playerid)
{
	for (new i = 0; i < MAX_PLAYER_CONTACT; i++)
	{
	    format(AgendaData[playerid][i][NameC], MAX_AGENDA_NAME, "");
	    AgendaData[playerid][i][NumberC] 		= 0;
	    AgendaData[playerid][i][IsBlackList] 	= false;
    }
}
ShowHomeAgenda(playerid)
{
	ShowPlayerDialogEx(playerid,19,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Agenda - Inicio", "{"COLOR_VERDE"}1- {"COLOR_CREMA"}Contactos \r\n{"COLOR_VERDE"}2- {"COLOR_CREMA"}Agregar \r\n{"COLOR_VERDE"}3- {"COLOR_CREMA"}Eliminar\r\n{"COLOR_AZUL"}4- {"COLOR_CREMA"}Contactos Bloqueados\r\n{"COLOR_AZUL"}5- {"COLOR_CREMA"}Bloquear\r\n{"COLOR_AZUL"}6- {"COLOR_CREMA"}Desbloquear\r\n{"COLOR_AMARILLO"}7- {"COLOR_CREMA"}SMS\r\n{"COLOR_AMARILLO"}8- {"COLOR_CREMA"}SMS Borrar Todos\r\n{"COLOR_AZUL_OSCURO"}9- {"COLOR_CREMA"}Buscar", "Ir", "Salir");
}
ShowHomeAgendaOptions(playerid, agendaid)
{
	PlayersDataOnline[playerid][SaveAfterAgenda][0] = agendaid;
	new TempFormat[35];
	format(TempFormat, sizeof(TempFormat), "{"COLOR_AZUL"}Agenda - %s", AgendaData[playerid][agendaid][NameC]);
	if ( AgendaData[playerid][agendaid][IsBlackList] )
	{
		ShowPlayerDialogEx(playerid,127,DIALOG_STYLE_LIST, TempFormat,"{"COLOR_VERDE"}1- {"COLOR_CREMA"}Llamar\r\n{"COLOR_VERDE"}2- {"COLOR_CREMA"}Enviar SMS\r\n{"COLOR_VERDE"}3- {"COLOR_VERDE"}Desbloquear\r\n{"COLOR_VERDE"}4- {"COLOR_CREMA"}Eliminar", "Seleccionar", "Atras");
	}
	else
	{
		ShowPlayerDialogEx(playerid,127,DIALOG_STYLE_LIST, TempFormat,"{"COLOR_VERDE"}1- {"COLOR_CREMA"}Llamar\r\n{"COLOR_VERDE"}2- {"COLOR_CREMA"}Enviar SMS\r\n{"COLOR_VERDE"}3- {"COLOR_ROJO"}Bloquear\r\n{"COLOR_VERDE"}4- {"COLOR_CREMA"}Eliminar", "Seleccionar", "Atras");
	}
}
ShowContactosAgenda(playerid)
{
	new AgendaDialog[2150];
	new TempConvert[50];
	new ConteoAgenda = -1;
	for (new i = 0; i < MAX_PLAYER_CONTACT; i++)
	{
	    if ( strlen(AgendaData[playerid][i][NameC]) >= 2 )
	    {
			if ( ConteoAgenda != -1 )
			{
		    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}%i - %s", AgendaData[playerid][i][NumberC], AgendaData[playerid][i][NameC]);
	    	}
			else
			{
			    format(TempConvert, sizeof(TempConvert), "{"COLOR_CREMA"}%i - %s", AgendaData[playerid][i][NumberC], AgendaData[playerid][i][NameC]);
			}
	        strcat(AgendaDialog, TempConvert, sizeof(AgendaDialog));
	        ConteoAgenda++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoAgenda] = i;
        }
	}
	if (ConteoAgenda != -1)
	{
		ShowPlayerDialogEx(playerid,20,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Agenda - Contactos", AgendaDialog, "Opciones", "Volver");
	}
	else
	{
		ShowPlayerDialogEx(playerid,21,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Agenda - informacion", "{"COLOR_TEXTO_DIALOGS"}No se encontraron contactos en la agenda.", "Aceptar", "Volver");
	}
}
ShowAgregarAgenda(playerid, option)
{
	switch(option)
	{
		// Agregar Nombre
		case 0:
		{
			ShowPlayerDialogEx(playerid,22,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Agenda - Agregar Nombre", "{"COLOR_TEXTO_DIALOGS"}Introduzca un nombre para su contacto", "Siguiente", "Inicio");
		}
		// Agregar Numero
		case 1:
		{
			ShowPlayerDialogEx(playerid,23,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Agenda - Agregar Numero", "{"COLOR_TEXTO_DIALOGS"}Introduzca el numero para su contacto", "Agregar", "Inicio");
		}
	}
}
ShowEliminarAgenda(playerid)
{
	new AgendaDialog[2150];
	new TempConvert[50];
	new ConteoAgenda = -1;
	for (new i = 0; i < MAX_PLAYER_CONTACT; i++)
	{
	    if ( strlen(AgendaData[playerid][i][NameC]) >= 2 )
	    {
			if ( ConteoAgenda != -1 )
			{
		    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}%i - %s", AgendaData[playerid][i][NumberC], AgendaData[playerid][i][NameC]);
	    	}
			else
			{
			    format(TempConvert, sizeof(TempConvert), "{"COLOR_CREMA"}%i - %s", AgendaData[playerid][i][NumberC], AgendaData[playerid][i][NameC]);
			}
	        strcat(AgendaDialog, TempConvert, sizeof(AgendaDialog));
	        ConteoAgenda++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoAgenda] = i;
        }
	}
	if (ConteoAgenda != -1)
	{
		ShowPlayerDialogEx(playerid,26,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Agenda - Eliminar Contacto", AgendaDialog, "Eliminar", "Volver");
	}
	else
	{
		ShowPlayerDialogEx(playerid,21,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Agenda - informacion", "{"COLOR_TEXTO_DIALOGS"}No se encontraron contactos en la agenda.", "Aceptar", "Volver");
	}
}
AddNumberToAgenda(playerid, const name[], number)
{
	new found;
	for (new i = 0; i < MAX_PLAYER_CONTACT; i++)
	{
	    if ( strlen(AgendaData[playerid][i][NameC]) <= 1 )
	    {
	        format(AgendaData[playerid][i][NameC], MAX_AGENDA_NAME, "%s", name);
	        AgendaData[playerid][i][NumberC] = number;
	        AgendaData[playerid][i][IsBlackList] = false;
	        found = true;
			SaveAgendaEx(playerid, i);
	        break;
	    }
    }
    if ( !found )
    {
		ShowPlayerDialogEx(playerid,21,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Agenda - informacion", "{"COLOR_TEXTO_DIALOGS"}Agenda llena.", "Aceptar", "Volver");
		return false;
	}
	else
	{
	    return true;
	}
}
RemoveNumberToAgenda(playerid, agendaid)
{
    format(AgendaData[playerid][agendaid][NameC], MAX_AGENDA_NAME, "");
    AgendaData[playerid][agendaid][NumberC] = 0;
    AgendaData[playerid][playerid][IsBlackList]    = false;
	SaveAgendaEx(playerid, agendaid);
}
IsNotPhoneInBlackList(playerid, number)
{
	for (new i = 0; i < MAX_PLAYER_CONTACT; i++)
	{
	    if ( strlen(AgendaData[playerid][i][NameC]) >= 2 && AgendaData[playerid][i][NumberC] == number && AgendaData[playerid][i][IsBlackList] )
	    {
	        return false;
	    }
    }
    return true;
}
ShowContactosBloqueados(playerid)
{
	new AgendaDialog[2150];
	new TempConvert[50];
	new ConteoAgenda = -1;
	for (new i = 0; i < MAX_PLAYER_CONTACT; i++)
	{
	    if ( strlen(AgendaData[playerid][i][NameC]) >= 2 && AgendaData[playerid][i][IsBlackList])
	    {
			if ( ConteoAgenda != -1 )
			{
		    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}%i - %s", AgendaData[playerid][i][NumberC], AgendaData[playerid][i][NameC]);
	    	}
			else
			{
			    format(TempConvert, sizeof(TempConvert), "{"COLOR_CREMA"}%i - %s", AgendaData[playerid][i][NumberC], AgendaData[playerid][i][NameC]);
			}
	        strcat(AgendaDialog, TempConvert, sizeof(AgendaDialog));
	        ConteoAgenda++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoAgenda] = i;
        }
	}
	if (ConteoAgenda != -1)
	{
		ShowPlayerDialogEx(playerid,21,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Agenda - Lista de loqueados", AgendaDialog, "Aceptar", "Volver");
	}
	else
	{
		ShowPlayerDialogEx(playerid,21,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Agenda - informacion", "{"COLOR_TEXTO_DIALOGS"}No se encontraron contactos bloqueados en la agenda.", "Aceptar", "Volver");
	}
}
ShowAgregarBloqueado(playerid)
{
	new AgendaDialog[2150];
	new TempConvert[50];
	new ConteoAgenda = -1;
	for (new i = 0; i < MAX_PLAYER_CONTACT; i++)
	{
	    if ( strlen(AgendaData[playerid][i][NameC]) >= 2 && !AgendaData[playerid][i][IsBlackList])
	    {
			if ( ConteoAgenda != -1 )
			{
		    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_ROJO"}%i - %s", AgendaData[playerid][i][NumberC], AgendaData[playerid][i][NameC]);
	    	}
			else
			{
			    format(TempConvert, sizeof(TempConvert), "{"COLOR_ROJO"}%i - %s", AgendaData[playerid][i][NumberC], AgendaData[playerid][i][NameC]);
			}
	        strcat(AgendaDialog, TempConvert, sizeof(AgendaDialog));
	        ConteoAgenda++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoAgenda] = i;
        }
	}
	if (ConteoAgenda != -1)
	{
		ShowPlayerDialogEx(playerid,51,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Agenda - Bloquear", AgendaDialog, "Bloquear", "Volver");
	}
	else
	{
		ShowPlayerDialogEx(playerid,21,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Agenda - informacion", "{"COLOR_TEXTO_DIALOGS"}No se encontraron contactos desbloqueados en la agenda.", "Aceptar", "Volver");
	}
}
ShowEliminarBloqueado(playerid)
{
	new AgendaDialog[2150];
	new TempConvert[50];
	new ConteoAgenda = -1;
	for (new i = 0; i < MAX_PLAYER_CONTACT; i++)
	{
	    if ( strlen(AgendaData[playerid][i][NameC]) >= 2 && AgendaData[playerid][i][IsBlackList])
	    {
			if ( ConteoAgenda != -1 )
			{
		    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_ROJO"}%i - %s", AgendaData[playerid][i][NumberC], AgendaData[playerid][i][NameC]);
	    	}
			else
			{
			    format(TempConvert, sizeof(TempConvert), "{"COLOR_ROJO"}%i - %s", AgendaData[playerid][i][NumberC], AgendaData[playerid][i][NameC]);
			}
	        strcat(AgendaDialog, TempConvert, sizeof(AgendaDialog));
	        ConteoAgenda++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoAgenda] = i;
        }
	}
	if (ConteoAgenda != -1)
	{
		ShowPlayerDialogEx(playerid,52,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Agenda - Desbloquear", AgendaDialog, "Desbloquear", "Volver");
	}
	else
	{
		ShowPlayerDialogEx(playerid,21,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Agenda - informacion", "{"COLOR_TEXTO_DIALOGS"}No se encontraron contactos bloqueados en la agenda.", "Aceptar", "Volver");
	}
}
AddContactToBlock(playerid, agendaid)
{
    AgendaData[playerid][agendaid][IsBlackList] = true;
	SaveAgendaEx(playerid, agendaid);
	new MsgDialog[MAX_TEXT_CHAT];
	format(MsgDialog, sizeof(MsgDialog), "{"COLOR_TEXTO_DIALOGS"}El contacto:\n\n{"COLOR_VERDE"}Nombre: {"COLOR_AMARILLO"}%s\n{"COLOR_VERDE"}Numero: {"COLOR_AMARILLO"}%i\n\n{"COLOR_TEXTO_DIALOGS"}Fue {"COLOR_ROJO"}BLOQUEADO {"COLOR_TEXTO_DIALOGS"}con exito!", AgendaData[playerid][agendaid][NameC], AgendaData[playerid][agendaid][NumberC]);
	ShowPlayerDialogEx(playerid,21,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Agenda - informacion", MsgDialog, "Aceptar", "Volver");
}
RemoveContactToBlock(playerid, agendaid)
{
    AgendaData[playerid][agendaid][IsBlackList] = false;
	SaveAgendaEx(playerid, agendaid);
	new MsgDialog[MAX_TEXT_CHAT];
	format(MsgDialog, sizeof(MsgDialog), "{"COLOR_TEXTO_DIALOGS"}El contacto:\n\n{"COLOR_VERDE"}Nombre: {"COLOR_AMARILLO"}%s\n{"COLOR_VERDE"}Numero: {"COLOR_AMARILLO"}%i\n\n{"COLOR_TEXTO_DIALOGS"}Fue {"COLOR_VERDE"}DESBLOQUEADO {"COLOR_TEXTO_DIALOGS"}con exito!", AgendaData[playerid][agendaid][NameC], AgendaData[playerid][agendaid][NumberC]);
	ShowPlayerDialogEx(playerid,21,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Agenda - informacion", MsgDialog, "Aceptar", "Volver");
}
IsInAgendaNumber(playerid, number)
{
	if ( IsObjectInBolsillo(playerid, 4) )
	{
		for (new i = 0; i < MAX_PLAYER_CONTACT; i++)
		{
		    if ( AgendaData[playerid][i][NumberC] == number)
		    {
				return i;
		    }
	    }
	}
    return -1;
}

function SetPlayerColgar(playerid)
{
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	RemovePlayerAttachedObject(playerid, 9);
}