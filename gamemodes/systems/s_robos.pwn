LoadRobosInfo()
{
	// Cotls
    RobosInfo[COLTS_R][FaccionIDR] 	= COLTS;
	RobosInfo[COLTS_R][TimerID] 	= -1;

	// AK
	MAX_ROBOS++;
	RobosInfo[AK_R][FaccionIDR] 		= AK;
	RobosInfo[AK_R][TimerID] 		= -1;

	// VELTRAN
	MAX_ROBOS++;
	RobosInfo[VELTRAN_R][FaccionIDR] 		= VELTRAN;
	RobosInfo[VELTRAN_R][TimerID] 		= -1;

	// HEORS
	MAX_ROBOS++;
	RobosInfo[HEORS_R][FaccionIDR] 		= HEORS;
	RobosInfo[HEORS_R][TimerID] 		= -1;
}

CancelRobo(roboid)
{
	RobosInfo[roboid][BizzIDR] 	 = false;
	RobosInfo[roboid][RoboState] = false;
	RobosInfo[roboid][ConteoR]   = false;

	if ( RobosInfo[roboid][TimerID] != -1 )
	{
	    KillTimer(RobosInfo[roboid][TimerID]);
	}
	RobosInfo[roboid][TimerID] 		= -1;
}

AddRobo(roboid, bizzid)
{
	RobosInfo[roboid][BizzIDR] = bizzid;
	RobosInfo[roboid][TimerID] = SetTimerEx("SendAvisoRobo", 180000, true, "i", roboid);
	SendMessageRobosFaccion(RobosInfo[roboid][FaccionIDR], "[Robo]: Ha comenzado el robo! A robar sin que nos pillen!");
	SendAvisoRobo(roboid);
}

ShowAlarmas(playerid)
{
	new AlarmasDialog[700];
	new TempConvert[100];
	new ConteoAlarmas = -1;
    new SaveCityReal;
	for (new i = 0; i <= MAX_ROBOS; i++)
	{
	    if ( RobosInfo[i][BizzIDR] )
	    {
		    if ( RobosInfo[i][City] == LSPD )
		    {
		        SaveCityReal = false;
		    }
		    else
		    {
		        SaveCityReal = true;
			}
			if ( ConteoAlarmas != -1 )
			{
		    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_VERDE"}Negocio: %s  - {"COLOR_AZUL"}Ciudad: %s",
		    	NegociosTipo[NegociosData[RobosInfo[i][BizzIDR]][Type]],
				Ciudades[SaveCityReal]);
	    	}
			else
			{
		    	format(TempConvert, sizeof(TempConvert), "{"COLOR_VERDE"}Negocio: %s  - {"COLOR_AZUL"}Ciudad: %s",
		    	NegociosTipo[NegociosData[RobosInfo[i][BizzIDR]][Type]],
				Ciudades[SaveCityReal]);
			}
	        strcat(AlarmasDialog, TempConvert, sizeof(AlarmasDialog));
	        ConteoAlarmas++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoAlarmas] = i;
        }
	}
	if (ConteoAlarmas != -1)
	{
		ShowPlayerDialogEx(playerid,137,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Alarmas SA - Alarmas activadas", AlarmasDialog, "Ver", "Salir");
	}
	else
	{
		ShowPlayerDialogEx(playerid,9999,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Alarmas - informacion", "{"COLOR_TEXTO_DIALOGS"}No hay alarmas activadas en la ciudad.", "Aceptar", "");
	}
}

function SendAvisoRobo(roboid)
{
	RobosInfo[roboid][ConteoR]++;
    if ( !RobosInfo[roboid][RoboState] )
    {
	    new SaveCityReal;
	    if ( RobosInfo[roboid][City] == LSPD)
	    {
	        SaveCityReal = false;
	    }
	    else
	    {
	        SaveCityReal = true;
		}
		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 )
			{
			    if ( IsMyBizz(i, RobosInfo[roboid][BizzIDR], false) || IsMyExtorsion(i, RobosInfo[roboid][BizzIDR]) )
			    {
				    new MsgRoboSMSReason[MAX_TEXT_CHAT];
			        format(MsgRoboSMSReason, sizeof(MsgRoboSMSReason), "[Alarma] Aviso %i - Esta sonando la alarma de el local \"%s\" localizado en %s", RobosInfo[roboid][ConteoR], NegociosTipo[NegociosData[RobosInfo[roboid][BizzIDR]][Type]], Ciudades[SaveCityReal]);
			        AddSMS(i, 911, MsgRoboSMSReason);
			        format(MsgRoboSMSReason, sizeof(MsgRoboSMSReason), "[SMS] Recibido de SAPD 911: %s", MsgRoboSMSReason);
					Acciones(i, 8, "recibe un SMS en el movil");
				    SendClientMessage(i, COLOR_INFO_MOVIL, MsgRoboSMSReason);
				}
				if ( PlayersData[i][Faccion] == RobosInfo[roboid][City] )
				{
					SendClientMessage(i, 0x0069FFFF, "[Avisos Alarmas SA]: La alarma de un local se ha activado! Se solicita personal urgente! Use (/Alarmas)");
				}
			}
		}
	}
	if ( RobosInfo[roboid][ConteoR] >= 5 )
	{
	    RobosInfo[roboid][RoboState] = true;
	    KillTimer(RobosInfo[roboid][TimerID]);
		SendMessageRobosFaccion(RobosInfo[roboid][FaccionIDR], "[Robo]: Ya pueden terminar el robo al negocio! Usen (/Terminar Robo)");
		RobosInfo[roboid][TimerID] = SetTimerEx("RobarConteo", 60000, false, "i", roboid);
	}
}


SendMessageRobosFaccion(faccionid, const text[])
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && PlayersData[i][Faccion] == faccionid)
		{
		    SendClientMessage(i, 0x006500FF, text); // 0x00FF0A50
		}
	}
}

IsBizzOnRobo(playerid, bizzid)
{
	for ( new i = 0; i <=  MAX_ROBOS; i++ )
	{
		if ( RobosInfo[i][BizzIDR] == bizzid )
		{
			SendInfoMessage(playerid, 0, "1499", "No puedes utilizar este comando mientras tu negocio o extorsion esta en medio de un robo!");
    		return true;
   		}
	}
	return false;
}

function RobarConteo(roboid)
{
	SendMessageRobosFaccion(RobosInfo[roboid][FaccionIDR], "[Robo]: Han tardado demasiado para robar el negocio! Para la proxima sera...");
	CancelRobo(roboid);
}