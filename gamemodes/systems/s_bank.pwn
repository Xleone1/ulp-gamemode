LoadCajeros()
{
	// CAJEROS
	CreateDynamicObject(2942, 1918.806763, -1765.879883, 13.189775, 0, 0, 180, -1, -1, -1, MAX_RADIO_STREAM); 	//Cajero LS 1   # 0
	Cajeros[MAX_CAJEROS][PosX] = 1918.806763;
	Cajeros[MAX_CAJEROS][PosY] = -1765.879883;
	Cajeros[MAX_CAJEROS][PosZ] = 13.189775;

	CreateDynamicObject(2942, 1367.271484, -1307.826904, 13.189775, 0, 0, -89, -1, -1, -1, MAX_RADIO_STREAM); 	//Cajero LS 2   # 1
	MAX_CAJEROS++;
	Cajeros[MAX_CAJEROS][PosX] = 1367.271484;
	Cajeros[MAX_CAJEROS][PosY] = -1307.826904;
	Cajeros[MAX_CAJEROS][PosZ] = 13.189775;

	CreateDynamicObject(2942, 1346.532349, -1759.225220, 13.158481, 0, 0, 180, -1, -1, -1, MAX_RADIO_STREAM); 	//Cajero LS 3   # 2
	MAX_CAJEROS++;
	Cajeros[MAX_CAJEROS][PosX] = 1346.532349;
	Cajeros[MAX_CAJEROS][PosY] = -1759.225220;
	Cajeros[MAX_CAJEROS][PosZ] = 13.158481;

	CreateDynamicObject(2942, -79.300514, -1171.916016, 1.777080, 0, 0, 247, -1, -1, -1, MAX_RADIO_STREAM); 	//Cajero LS/FG  # 3
	MAX_CAJEROS++;
	Cajeros[MAX_CAJEROS][PosX] = -79.300514;
	Cajeros[MAX_CAJEROS][PosY] = -1171.916016;
	Cajeros[MAX_CAJEROS][PosZ] = 1.777080;

	CreateDynamicObject(2942, -2095.375732, -95.220436, 34.806961, 0, 0, 90, -1, -1, -1, MAX_RADIO_STREAM); 	//Cajero SF 1   # 4
	MAX_CAJEROS++;
	Cajeros[MAX_CAJEROS][PosX] = -2095.375732;
	Cajeros[MAX_CAJEROS][PosY] = -95.220436;
	Cajeros[MAX_CAJEROS][PosZ] = 34.806961;

	CreateDynamicObject(2942, -1990.503174, 1345.649414, 6.827043, 0, 0, 0, -1, -1, -1, MAX_RADIO_STREAM); 				//Cajero SF 2   # 5
	MAX_CAJEROS++;
	Cajeros[MAX_CAJEROS][PosX] = -1990.503174;
	Cajeros[MAX_CAJEROS][PosY] = 1345.649414;
	Cajeros[MAX_CAJEROS][PosZ] = 6.827043;
}
IsPlayerNearCajero(playerid)
{
	for (new i=0;i<=MAX_CAJEROS;i++)
	{
	    if (IsPlayerInRangeOfPoint(playerid, 2.0, Cajeros[i][PosX],Cajeros[i][PosY],Cajeros[i][PosZ]))
	    {
	    	return i;
    	}
	}
	SendInfoMessage(playerid, 0, "766", "No se encuentra cerca de un cajero ni en el banco");
	return -1;
}
ShowHomeBanco(playerid)
{
    if ( PlayersData[playerid][IsPlayerInBank] || IsPlayerNearCajero(playerid) != -1 )
    {
		if ( PlayersData[playerid][IsPlayerInBank] )
		{
			ShowPlayerDialogEx(playerid,31,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Banco - Inicio", "{"COLOR_TITULO_DIALOGS"}1- {"COLOR_CREMA"}Consultar\r\n{"COLOR_TITULO_DIALOGS"}2- {"COLOR_CREMA"}Retirar\r\n{"COLOR_TITULO_DIALOGS"}3- {"COLOR_CREMA"}Depositar\r\n{"COLOR_TITULO_DIALOGS"}4- {"COLOR_CREMA"}Cobrar un Cheque\r\n{"COLOR_TITULO_DIALOGS"}5- {"COLOR_CREMA"}Ver mis Cheques\r\n{"COLOR_TITULO_DIALOGS"}6- {"COLOR_CREMA"}Hacer una transferencia\r\n{"COLOR_TITULO_DIALOGS"}{"COLOR_TITULO_DIALOGS"}7- {"COLOR_CREMA"}Controlar mis Cuentas\r\n{"COLOR_TITULO_DIALOGS"}8- {"COLOR_CREMA"}Configuracion", "Ir", "Salir");
		}
		else
		{
			ShowPlayerDialogEx(playerid,31,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Banco - Inicio", "{"COLOR_TITULO_DIALOGS"}1 {"COLOR_CREMA"}Consultar\r\n{"COLOR_TITULO_DIALOGS"}2 {"COLOR_CREMA"}Retirar\r\n{"COLOR_TITULO_DIALOGS"}3 {"COLOR_CREMA"}Depositar", "Ir", "Salir");
		}
	}
}
ShowConsultarBanco(playerid)
{
    if ( PlayersData[playerid][IsPlayerInBank] || IsPlayerNearCajero(playerid) != -1 )
    {
        new MsgConsultarBanco[MAX_TEXT_CHAT];
        format(MsgConsultarBanco, sizeof(MsgConsultarBanco), "{"COLOR_CREMA"}Tiene usted {"COLOR_VERDE"}$%i {"COLOR_CREMA"}en su cuenta bancaria", PlayersData[playerid][Banco]);
		ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Consultar",MsgConsultarBanco, "Aceptar", "Volver");
	}
}
ShowRetirarBanco(playerid)
{
    if ( PlayersData[playerid][IsPlayerInBank] || IsPlayerNearCajero(playerid) != -1 )
    {
		ShowPlayerDialogEx(playerid,33,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Banco - Retirar","{"COLOR_CREMA"}Ingrese la cantidad que desea retirar", "Retirar", "Volver");
	}
}
ShowDepositarBanco(playerid)
{
    if ( PlayersData[playerid][IsPlayerInBank] || IsPlayerNearCajero(playerid) != -1 )
    {
		ShowPlayerDialogEx(playerid,34,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Banco - Depositar","{"COLOR_CREMA"}Ingrese la cantidad que desea depositar", "Depositar", "Volver");
	}
}
ShowRetirarBancoFunction(playerid, option, amount)
{
    if ( PlayersData[playerid][IsPlayerInBank] || IsPlayerNearCajero(playerid) != -1 )
    {
        if (PlayersData[playerid][Banco] >= amount )
        {
            if ( !PlayersData[playerid][IsPlayerInBank] && amount >= 50 && amount <= 250 ||
				 PlayersData[playerid][IsPlayerInBank] )
            {
                if ( !PlayersData[playerid][IsPlayerInBank] && PlayersData[playerid][TimeRequestBank] <= gettime() ||
					 PlayersData[playerid][IsPlayerInBank])
                {
				    if (IsNotZero(playerid, amount))
				    {
			            PlayersData[playerid][Banco] = PlayersData[playerid][Banco] - amount;
			            GivePlayerMoneyEx(playerid, amount);

				        new MsgConsultarBanco[MAX_TEXT_CHAT];
				        if ( option )
				        {
					        format(MsgConsultarBanco, sizeof(MsgConsultarBanco), "Ha retirado $%i del banco, su nuevo balance es: $%i", amount, PlayersData[playerid][Banco]);
			    			SendInfoMessage(playerid, 1, " ", "|___________________  Banco ___________________|");
			    			SendInfoMessage(playerid, 1, MsgConsultarBanco, "Banco: ");
			    			SendInfoMessage(playerid, 1, " ", "|_____________________ Fin ____________________|");
		    			}
		    			else
		    			{
					        format(MsgConsultarBanco, sizeof(MsgConsultarBanco), "{"COLOR_CREMA"}Ha retirado  {"COLOR_ROJO"}$%i  {"COLOR_CREMA"}del banco.\n\n{"COLOR_CREMA"}Su nuevo balance es: {"COLOR_VERDE"}$%i", amount, PlayersData[playerid][Banco]);
							ShowPlayerDialogEx(playerid,35,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Retiro Realizado",MsgConsultarBanco, "Aceptar", "Volver");
						}
						if ( !PlayersData[playerid][IsPlayerInBank] )
						{
                            PlayersData[playerid][TimeRequestBank] = gettime() + 900;
						}
						return true;
					}
    			}
    			else
    			{
    			    new MsgErrorDinamicBank[MAX_TEXT_CHAT];
    			    format(MsgErrorDinamicBank, sizeof(MsgErrorDinamicBank), "Debe esperar %i minutos para volver a retirar dinero de un cajero", (PlayersData[playerid][TimeRequestBank] - gettime()) / 60 );
					SendInfoMessage(playerid, 0, "717", MsgErrorDinamicBank);
				}
			}
			else
			{
				SendInfoMessage(playerid, 0, "716", "Solo puedes retirar $250 maximo y $50 minimo de un cajero cada 15 minutos, vaya al banco si desea retirar mas dinero");
			}
		}
		else
		{
			SendInfoMessage(playerid, 0, "303", "No tienes esa cantidad de dinero para retirar del banco");
		}
        if ( !option )
        {
			ShowPlayerDialogEx(playerid,33,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Banco - Retirar","{"COLOR_CREMA"}Ingrese la cantidad menor a retirar", "Retirar", "Volver");
        }
	}
	return false;
}
ShowDepositarBancoFunction(playerid, option, amount)
{
    if ( PlayersData[playerid][IsPlayerInBank] || IsPlayerNearCajero(playerid) != -1 )
    {
        if (PlayersData[playerid][Dinero] >= amount )
        {
		    if (IsNotZero(playerid, amount))
		    {
	            PlayersData[playerid][Banco] = PlayersData[playerid][Banco] + amount;
	            GivePlayerMoneyEx(playerid, -amount);

		        new MsgDepositarBanco[MAX_TEXT_CHAT];
		        if ( option )
		        {
			        format(MsgDepositarBanco, sizeof(MsgDepositarBanco), "Ha depositado $%i en el banco, su nuevo balance es: $%i", amount, PlayersData[playerid][Banco]);
	    			SendInfoMessage(playerid, 1, " ", "|___________________  Banco ___________________|");
	    			SendInfoMessage(playerid, 1, MsgDepositarBanco, "Banco: ");
	    			SendInfoMessage(playerid, 1, " ", "|_____________________ Fin ____________________|");
    			}
    			else
    			{
			        format(MsgDepositarBanco, sizeof(MsgDepositarBanco), "{"COLOR_CREMA"}Ha depositado  {"COLOR_VERDE"}$%i  {"COLOR_CREMA"}en el banco.\n\n{"COLOR_CREMA"}Su nuevo balance es: {"COLOR_VERDE"}$%i", amount, PlayersData[playerid][Banco]);
					ShowPlayerDialogEx(playerid,36,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Deposito Realizado",MsgDepositarBanco, "Aceptar", "Volver");
				}
				return true;
			}
		}
		else
		{
			SendInfoMessage(playerid, 0, "304", "No tienes esa cantidad de dinero para depositar en el banco");
		}
        if ( !option )
        {
			ShowPlayerDialogEx(playerid,34,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Banco - Reintentar Deposito","{"COLOR_CREMA"}Ingrese una cantidad menor a depositar", "Depositar", "Volver");
        }
	}
	return false;
}
ShowManejarCuentas(playerid)
{
	ShowPlayerDialogEx(playerid,80,DIALOG_STYLE_LIST, "{"COLOR_AZUL"}Banco - Controlar mis cuentas","{"COLOR_TITULO_DIALOGS"}1- {"COLOR_CREMA"}Ver estadisticas\r\n{"COLOR_TITULO_DIALOGS"}2- {"COLOR_CREMA"}Transferir de {"COLOR_VERDE"}CUENTA DE AHORROS {"COLOR_AZUL"}-->> {"COLOR_VERDE"}CUENTA DE CHEQUES\r\n{"COLOR_TITULO_DIALOGS"}3- {"COLOR_CREMA"}Transferir de {"COLOR_VERDE"}CUENTA DE CHEQUES {"COLOR_AZUL"}-->> {"COLOR_VERDE"}CUENTA DE AHORROS", "Seleccionar", "Volver");
}
CreateAccountBank(playerid)
{
	new query[200], Cache:cacheid, bankAccountExist, Go = true;
	new AccountNumber;
	do
	{
	    AccountNumber = random(8999999) + 1000000;
		format(query, 200, "SELECT * FROM `%s` WHERE `AccountNumber`=%i;", DIR_ACCOUNT_BANK, AccountNumber);
		cacheid = mysql_query(dataBase, query);
		cache_get_row_count(bankAccountExist);
		cache_delete(cacheid);
		if (!bankAccountExist) Go = false;
	}
	while( Go );
	PlayersData[playerid][AccountBankingOpen] = AccountNumber;

	CleanPlayerAccountBank(playerid);
	SaveAccountBanking(playerid);
}
IsNotChequesFull(playerid)
	{
	for ( new c = 0; c < MAX_COUNT_CHEQUES; c++ )
	{
	    if ( !Cheques[playerid][c][UniqueID] )
	    {
	        return c;
		}
	}
	return -1;
}
RemoveCheque(playerid, chequeid)
{
	if ( Cheques[playerid][chequeid][UniqueID] )
	{
		Cheques[playerid][chequeid][UniqueID] = 0;
		Cheques[playerid][chequeid][Type] = 0;
		format(Cheques[playerid][chequeid][NombreCh], MAX_PLAYER_NAME, "No");
		Cheques[playerid][chequeid][Ammount] = 0;
		return true;
	}
	else
	{
	    return false;
	}
}
CleanPlayerAccountBank(playerid)
{
	for ( new c = 0; c < MAX_COUNT_CHEQUES; c++ )
	{
		Cheques[playerid][c][UniqueID] = 0;
		Cheques[playerid][c][Type] = 0;
		format(Cheques[playerid][c][NombreCh], MAX_PLAYER_NAME, "No");
		Cheques[playerid][c][Ammount] = 0;
	}
}
LoadAccountBanking(playerid)
{
    if ( PlayersData[playerid][AccountBankingOpen] )
    {
		new query[200], Cache:cacheid, bankAccountExist;
		format(query, 200, "SELECT * FROM `%s` WHERE `AccountNumber`=%i", DIR_ACCOUNT_BANK, PlayersData[playerid][AccountBankingOpen]);
		cacheid = mysql_query(dataBase, query);
		cache_get_row_count(bankAccountExist);

		if (bankAccountExist )
		{
			new ChequesData[700];
			cache_get_value_name(0, "Client", Banking[playerid][Owner], MAX_PLAYER_NAME);
			cache_get_value_name_int(0, "Balance", Banking[playerid][Balance]);
			cache_get_value_name_int(0, "LockIn", Banking[playerid][LockIn]);
			cache_get_value_name_int(0, "LockOut", Banking[playerid][LockOut]);
			cache_get_value_name(0, "Cheques", ChequesData, 700);
		    for ( new c = 0; c < MAX_COUNT_CHEQUES; c++ )
		    {
				new ChequeDataSlot[4][50], SplitPos[2];
				SplitPos[1] = strfind(ChequesData, ",", false);
				for ( new i = 0; i != 4; i++ )
				{
					SplitPos[0] = strfind(ChequesData, "|", false);
					strmid(ChequeDataSlot[i], ChequesData, 0, SplitPos[0]);
					strdel(ChequesData, 0, SplitPos[0]+1);
				}
				strdel(ChequesData, 0, SplitPos[1]+1);

				Cheques[playerid][c][UniqueID] = strval(ChequeDataSlot[0]);
				Cheques[playerid][c][Type]     = strval(ChequeDataSlot[1]);
				format(Cheques[playerid][c][NombreCh], MAX_PLAYER_NAME, "%s", ChequeDataSlot[2]);
				Cheques[playerid][c][Ammount]  = strval(ChequeDataSlot[3]);
			}
		}
		cache_delete(cacheid);
	}
	else
	{
		CreateAccountBank(playerid);
	}
}
SaveAccountBanking(playerid)
{
	new query[1000], Cache:cacheid, bankAccountExist;
	format(query, 500, "SELECT `AccountNumber` FROM `%s` WHERE `AccountNumber`=%i;", DIR_ACCOUNT_BANK, PlayersData[playerid][AccountBankingOpen]);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(bankAccountExist);
	cache_delete(cacheid);

	if (!bankAccountExist)
	{
		format(query, 500, "INSERT INTO `%s` (`AccountNumber`) VALUES ('%i');", DIR_ACCOUNT_BANK, PlayersData[playerid][AccountBankingOpen]);
		mysql_query(dataBase, query, false);
	}

	format(query, 500, "UPDATE `%s` SET ", DIR_ACCOUNT_BANK);
	strcat(query, "`Client`='%e',`Balance`='%i',`LockIn`='%i',`LockOut`='%i'");
	strcat(query, " WHERE `AccountNumber`=%i;");
	mysql_format(dataBase, query, 500, query,
		PlayersDataOnline[playerid][NameOnline],
		Banking[playerid][Balance],
		Banking[playerid][LockIn],
		Banking[playerid][LockOut],
		PlayersData[playerid][AccountBankingOpen]);
	mysql_query(dataBase, query, false);

	format(query, 100, "UPDATE `%s` SET `Cheques`='", DIR_ACCOUNT_BANK);
    for ( new c = 0; c < MAX_COUNT_CHEQUES; c++ )
    {
		new chequesData[60];
		format(chequesData, sizeof(chequesData), "%i|%i|%s|%i|,",
		Cheques[playerid][c][UniqueID],
		Cheques[playerid][c][Type],
		Cheques[playerid][c][NombreCh],
		Cheques[playerid][c][Ammount]);

		strcat(query, chequesData, 1000);
	}
	strcat(query, "' WHERE `AccountNumber`=%i;");
	mysql_format(dataBase, query, 1000, query, PlayersData[playerid][AccountBankingOpen]);
	mysql_query(dataBase, query, false);
}
IsPlayerAccountBankConnected(accountcheck)
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && PlayersData[i][AccountBankingOpen] == accountcheck )
		{
		    return i;
		}
	}
	return -1;
}
ShowVerCheques(playerid)
{
	new ChequesDialog[1200];
	new TempConvert[100];
	new ConteoCheques = -1;
	for (new i = 0; i < MAX_COUNT_CHEQUES; i++)
	{
	    if ( Cheques[playerid][i][UniqueID])
	    {
			if ( ConteoCheques != -1 )
			{
		    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}Cheques #[%i] {"COLOR_AMARILLO"}Tipo: %s",
				Cheques[playerid][i][UniqueID],
				Cheques[playerid][i][NombreCh]);
	    	}
			else
			{
		    	format(TempConvert, sizeof(TempConvert), "{"COLOR_CREMA"}Cheques #[%i] {"COLOR_AMARILLO"}Tipo: %s",
				Cheques[playerid][i][UniqueID],
				Cheques[playerid][i][NombreCh]);
			}
	        strcat(ChequesDialog, TempConvert, sizeof(ChequesDialog));
	        ConteoCheques++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoCheques] = i;
        }
	}
	if (ConteoCheques != -1)
	{
		ShowPlayerDialogEx(playerid,84,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Banco - Cheques", ChequesDialog, "Cancelar", "Volver");
	}
	else
	{
		ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Banco - informacion", "{"COLOR_TEXTO_DIALOGS"}No se encontraron cheques repartidos.", "Aceptar", "Volver");
	}
}
CrearCheque(playerid, giveplayerid, type, amount, chequeid)
{
	new IDCheque[3]; gettime(IDCheque[0], IDCheque[1], IDCheque[2]);
	new ChequeIDStr[10];
	format(ChequeIDStr, sizeof(ChequeIDStr), "%i%i%i%i", random(100) + 1, IDCheque[0], IDCheque[1], IDCheque[2]);
	printf("%s", ChequeIDStr);
	IDCheque[0] = strvalEx(ChequeIDStr);

	Cheques[playerid][chequeid][UniqueID] 	= IDCheque[0];
	Cheques[playerid][chequeid][Type]		= type;
	if ( type )
	{
		format(Cheques[playerid][chequeid][NombreCh], MAX_PLAYER_NAME, "%s", PlayersDataOnline[giveplayerid][NameOnlineFix]);
	}
	else
	{
		format(Cheques[playerid][chequeid][NombreCh], MAX_PLAYER_NAME, "Nadie");
	}
	Cheques[playerid][chequeid][Ammount]    = amount;

	AddObjectToCartera(giveplayerid, CARTERA_TYPE_CHEQUE, amount, IDCheque[0], PlayersData[playerid][AccountBankingOpen]);
}
ShowPayCheque(playerid)
{
	new ChequesDialog[1000];
	new TempConvert[100];
	new ConteoCheques = -1;

	for (new i = 0; i<=5;i++)
	{
	    if ( PlayersData[playerid][Cartera][i] == CARTERA_TYPE_CHEQUE )
	    {
			if ( ConteoCheques != -1 )
			{
		    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}Cantidad $%i (Cheque #[%i]) {"COLOR_AMARILLO"}Cuenta: %i",
				PlayersData[playerid][CarteraC][i],
				PlayersData[playerid][CarteraT][i],
				PlayersData[playerid][CarteraI][i]);
	    	}
			else
			{
		    	format(TempConvert, sizeof(TempConvert), "{"COLOR_CREMA"}Cantidad $%i (Cheque #[%i]) {"COLOR_AMARILLO"}Cuenta: %i",
				PlayersData[playerid][CarteraC][i],
				PlayersData[playerid][CarteraT][i],
				PlayersData[playerid][CarteraI][i]);
			}
	        strcat(ChequesDialog, TempConvert, sizeof(ChequesDialog));
	        ConteoCheques++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoCheques] = i;
        }
	}
	if (ConteoCheques != -1)
	{
		ShowPlayerDialogEx(playerid,85,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Banco - Cobrar un Cheque", ChequesDialog, "Cobrar", "Volver");
	}
	else
	{
		ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Banco - informacion", "{"COLOR_TEXTO_DIALOGS"}No llevas cheques en la cartera para cobrar.", "Aceptar", "Volver");
	}
}
PayCheckToPlayer(playerid, carteraid)
{
	new playeridConnected = IsPlayerAccountBankConnected(PlayersData[playerid][CarteraI][carteraid]);
	if ( playeridConnected != -1 )
	{
	    ////////////////////////////
	    new Cobrado = -1;
	    for ( new c = 0; c < MAX_COUNT_CHEQUES; c++ )
	    {
	        if ( Cheques[playeridConnected][c][UniqueID] == PlayersData[playerid][CarteraT][carteraid] )
	        {
	            Cobrado = c;
				break;
			}
		}
		if ( Cobrado != -1 )
		{
		    if ( Banking[playeridConnected][LockOut] )
		    {
				if ( !Cheques[playeridConnected][Cobrado][Type] || Cheques[playeridConnected][Cobrado][Type] && strfind(Cheques[playeridConnected][Cobrado][NombreCh], PlayersDataOnline[playerid][NameOnlineFix], false) == 0 && strlen(Cheques[playeridConnected][Cobrado][NombreCh]) == strlen(PlayersDataOnline[playerid][NameOnlineFix]) )
				{
				    if ( Banking[playeridConnected][Balance] >= PlayersData[playerid][CarteraC][carteraid] )
				    {
						new StatsBank[400];
						format(StatsBank, sizeof(StatsBank), "{"COLOR_CREMA"}Has cobrado este cheque con exito!\n\n     {"COLOR_AMARILLO"}..::Resumen::..\n{"COLOR_CREMA"}Propietario: {"COLOR_AZUL"}%s\n{"COLOR_CREMA"}# Cuenta: {"COLOR_AMARILLO"}%i\n{"COLOR_CREMA"}# Cheque: {"COLOR_AMARILLO"}%i\n{"COLOR_CREMA"}Cantidad: {"COLOR_VERDE"}$%i",
						Banking[playeridConnected][Owner],
						PlayersData[playerid][CarteraI][carteraid],
						PlayersData[playerid][CarteraT][carteraid],
						PlayersData[playerid][CarteraC][carteraid]);

					    PlayersData[playerid][Banco] 		+= PlayersData[playerid][CarteraC][carteraid];
					    Banking[playeridConnected][Balance] -= PlayersData[playerid][CarteraC][carteraid];
					    if ( PlayersData[playeridConnected][AlertSMSBank] && PlayersDataOnline[playeridConnected][PhoneOnline])
					    {
					        new MsgBankSMS[MAX_TEXT_CHAT];
					        new MsgBankSMSReason[MAX_TEXT_CHAT];
					        format(MsgBankSMSReason, sizeof(MsgBankSMSReason), "Han cobrado un cheque tipo [%s] con #%i por la suma de $%i en su cuenta de cheques.",
							CarteraChequeType[Cheques[playeridConnected][Cobrado][Type]],
							PlayersData[playerid][CarteraT][carteraid],
							PlayersData[playerid][CarteraC][carteraid]
							);
					        format(MsgBankSMS, sizeof(MsgBankSMS), "[SMS] Recibido del BCSA 333: %s", MsgBankSMSReason);
					        AddSMS(playeridConnected, 333, MsgBankSMSReason);
					        printf("%s Cheque Cuenta: %i || %s", PlayersDataOnline[playerid][NameOnline], MsgBankSMSReason);

							Acciones(playeridConnected, 8, "recibe un SMS en el movil");
						    SendClientMessage(playeridConnected, COLOR_INFO_MOVIL, MsgBankSMS);

						    Banking[playeridConnected][Balance] -= 10;
						}
						RemoveCheque(playeridConnected, Cobrado);
						RemoveObjectToCartera(playerid, carteraid);
						ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Cheque Cobrado",StatsBank, "Aceptar", "Volver");
				    }
				    else
				    {
						ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}El cheque no pudo ser cobrado por fondos\ninsuficientes en la cuenta de destino", "Aceptar", "Volver");
					}
				}
				else
				{
					ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}El cheque que intenta cobrar es personal, solo puede ser cobrado por la persona al que fue dado.", "Aceptar", "Volver");
				}
			}
			else
			{
				ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}La cuenta donde intenta cobrar el cheque\ntiene deshabilitado el cobro de cheques", "Aceptar", "Volver");
			}
		}
		else
		{
			ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}Este cheque fue cancelado por el propietario de la cuenta", "Aceptar", "Volver");
		}
	    ////////////////////////////
	}
	else
	{
		new query[200], Cache:cacheid, bankAccountExist;
		format(query, 200, "SELECT * FROM `%s` WHERE `AccountNumber`=%i", DIR_ACCOUNT_BANK, PlayersData[playerid][CarteraI][carteraid]);
		cacheid = mysql_query(dataBase, query);
		cache_get_row_count(bankAccountExist);
		if ( bankAccountExist )
		{
			new BankingPay[AccountBankEnum];
			new ChequesPay[MAX_COUNT_CHEQUES][ChequesEnum];
			new ChequesPayData[700];
			cache_get_value_name(0, "Client", BankingPay[Owner], MAX_PLAYER_NAME);
			cache_get_value_name_int(0, "Balance", BankingPay[Balance]);
			cache_get_value_name_int(0, "LockIn", BankingPay[LockIn]);
			cache_get_value_name_int(0, "LockOut", BankingPay[LockOut]);
			cache_get_value_name(0, "Cheques", ChequesPayData, 700);
		    for ( new chequeid = 0; chequeid < MAX_COUNT_CHEQUES; chequeid++ )
		    {
				new ChequePayDataSlot[4][50], SplitPos[2];
				SplitPos[1] = strfind(ChequesPayData, ",", false);
				for ( new i = 0; i != 4; i++ )
				{
					SplitPos[0] = strfind(ChequesPayData, "|", false);
					strmid(ChequePayDataSlot[i], ChequesPayData, 0, SplitPos[0]);
					strdel(ChequesPayData, 0, SplitPos[0]+1);
				}
				strdel(ChequesPayData, 0, SplitPos[1]+1);

				ChequesPay[chequeid][UniqueID] = strval(ChequePayDataSlot[0]);
				ChequesPay[chequeid][Type]     = strval(ChequePayDataSlot[1]);
				format(ChequesPay[chequeid][NombreCh], MAX_PLAYER_NAME, "%s", ChequePayDataSlot[2]);
				ChequesPay[chequeid][Ammount]  = strval(ChequePayDataSlot[3]);
			}

		    new Cobrado = -1;
		    for ( new c = 0; c < MAX_COUNT_CHEQUES; c++ )
		    {
		        if ( ChequesPay[c][UniqueID] == PlayersData[playerid][CarteraT][carteraid] )
		        {
		            Cobrado = c;
					break;
				}
			}
			if ( Cobrado != -1 )
			{
			    if ( BankingPay[LockOut] )
			    {
					if ( !ChequesPay[Cobrado][Type] || ChequesPay[Cobrado][Type] && strfind(ChequesPay[Cobrado][NombreCh], PlayersDataOnline[playerid][NameOnlineFix], false) == 0 && strlen(ChequesPay[Cobrado][NombreCh]) == strlen(PlayersDataOnline[playerid][NameOnlineFix]) )
					{
					    if ( BankingPay[Balance] >= PlayersData[playerid][CarteraC][carteraid] )
					    {
							new StatsBank[400];
							format(StatsBank, sizeof(StatsBank), "{"COLOR_CREMA"}Has cobrado este cheque con exito!\n\n     {"COLOR_AMARILLO"}..::Resumen::..\n{"COLOR_CREMA"}Propietario: {"COLOR_AZUL"}%s\n{"COLOR_CREMA"}# Cuenta: {"COLOR_AMARILLO"}%i\n{"COLOR_CREMA"}# Cheque: {"COLOR_AMARILLO"}%i\n{"COLOR_CREMA"}Cantidad: {"COLOR_VERDE"}$%i",
							BankingPay[Owner],
							PlayersData[playerid][CarteraI][carteraid],
							PlayersData[playerid][CarteraT][carteraid],
							PlayersData[playerid][CarteraC][carteraid]);

						    PlayersData[playerid][Banco] 		+= PlayersData[playerid][CarteraC][carteraid];
						    BankingPay[Balance] 				-= PlayersData[playerid][CarteraC][carteraid];
						    //
							ChequesPay[Cobrado][UniqueID] = 0;
							ChequesPay[Cobrado][Type] = 0;
							format(ChequesPay[Cobrado][NombreCh], MAX_PLAYER_NAME, "No");
							ChequesPay[Cobrado][Ammount] = 0;
								//RemoveCheque(playeridConnected, Cobrado);
							//
							RemoveObjectToCartera(playerid, carteraid);

							/////////////////////////
							format(query, 500, "UPDATE `%s` SET ", DIR_ACCOUNT_BANK);
							strcat(query, "`Client`='%e',`Balance`='%i',`LockIn`='%i',`LockOut`='%i'");
							strcat(query, " WHERE `AccountNumber`=%i;");
							mysql_format(dataBase, query, 500, query,
								BankingPay[Owner],
								BankingPay[Balance],
								BankingPay[LockIn],
								BankingPay[LockOut],
								PlayersData[playerid][CarteraI][carteraid]);
							mysql_query(dataBase, query, false);

							format(query, 100, "UPDATE `%s` SET `Cheques`='", DIR_ACCOUNT_BANK);
						    for ( new c = 0; c < MAX_COUNT_CHEQUES; c++ )
						    {
								new chequesData[60];
								format(chequesData, sizeof(chequesData), "%i|%i|%s|%i|,",
								ChequesPay[c][UniqueID],
								ChequesPay[c][Type],
								ChequesPay[c][NombreCh],
								ChequesPay[c][Ammount]);

								strcat(query, chequesData, 1000);
							}
							strcat(query, "' WHERE `AccountNumber`=%i;");
							mysql_format(dataBase, query, 1000, query, PlayersData[playerid][CarteraI][carteraid]);
							mysql_query(dataBase, query, false);
							/////////////////////////

							ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Cheque Cobrado",StatsBank, "Aceptar", "Volver");
					    }
					    else
					    {
							ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}El cheque no pudo ser cobrado por fondos\ninsuficientes en la cuenta de destino", "Aceptar", "Volver");
						}
					}
					else
					{
						ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}El cheque que intenta cobrar es personal, solo puede ser cobrado por la persona al que fue dado.", "Aceptar", "Volver");
					}
				}
				else
				{
					ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}La cuenta donde intenta cobrar el cheque\ntiene deshabilitado el cobro de cheques", "Aceptar", "Volver");
				}
			}
			else
			{
				ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}Este cheque fue cancelado por el propietario de la cuenta", "Aceptar", "Volver");
			}
		    ////////////////////////////
		}
		else
		{
			ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}El numero de cuenta donde desea cobrar el cheque no existe!", "Aceptar", "Volver");
		}
		cache_delete(cacheid);
	}
}
TransferirMoney(playerid, account, amount)
{
	new playeridConnected = IsPlayerAccountBankConnected(account);
	if ( playeridConnected != -1 )
	{
	    ////////////////////////////
		if ( Banking[playeridConnected][LockIn] )
		{
		    if ( Banking[playerid][Balance] >= amount )
		    {
				new StatsBank[400];
				format(StatsBank, sizeof(StatsBank), "{"COLOR_CREMA"}Tranferencia realizada con con exito!\n\n     {"COLOR_AMARILLO"}..::Resumen::..\n{"COLOR_CREMA"}# Cuenta origen: {"COLOR_AMARILLO"}%i\n{"COLOR_CREMA"}# Cuenta destino: {"COLOR_AMARILLO"}%i\n{"COLOR_CREMA"}Cantidad: {"COLOR_VERDE"}$%i",
				PlayersData[playerid][AccountBankingOpen],
				account,
				amount);

			    Banking[playerid][Balance] 			-= amount;
			    Banking[playeridConnected][Balance] += amount;

			    if ( PlayersData[playeridConnected][AlertSMSBank] && PlayersDataOnline[playeridConnected][PhoneOnline] )
			    {
			        new MsgBankSMS[MAX_TEXT_CHAT];
			        new MsgBankSMSReason[MAX_TEXT_CHAT];
			        format(MsgBankSMSReason, sizeof(MsgBankSMSReason), "Has recibido una transferencia de la cuenta #%i por la suma de $%i.",
					PlayersData[playerid][AccountBankingOpen],
					amount
					);
			        format(MsgBankSMS, sizeof(MsgBankSMS), "[SMS] Recibido del BCSA 333: %s", MsgBankSMSReason);

			        AddSMS(playeridConnected, 333, MsgBankSMSReason);

					Acciones(playeridConnected, 8, "recibe un SMS en el movil");
				    SendClientMessage(playeridConnected, COLOR_INFO_MOVIL, MsgBankSMS);

				    Banking[playeridConnected][Balance] -= 10;
				}

				ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Transferencia Realizada",StatsBank, "Aceptar", "Volver");
		    }
		    else
		    {
				ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}Su cuenta de cheques no tiene suficientes fondos\npara realizar esta transferencia", "Aceptar", "Volver");
			}
		}
		else
		{
			ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}La cuenta a la que desea realizar una transferencia\ntiene prohibidas las transferencias entrantes.", "Aceptar", "Volver");
		}
	    ////////////////////////////
	}
	else
	{
	    new query[1000], Cache:cacheid, bankAccountExist;
		format(query, 200, "SELECT * FROM `%s` WHERE `AccountNumber`=%i", DIR_ACCOUNT_BANK, account);
		cacheid = mysql_query(dataBase, query);
		cache_get_row_count(bankAccountExist);
		if ( bankAccountExist )
		{
			new BankingPay[AccountBankEnum];
			new ChequesPay[MAX_COUNT_CHEQUES][ChequesEnum];
			new ChequesPayData[700];
			cache_get_value_name(0, "Client", BankingPay[Owner], MAX_PLAYER_NAME);
			cache_get_value_name_int(0, "Balance", BankingPay[Balance]);
			cache_get_value_name_int(0, "LockIn", BankingPay[LockIn]);
			cache_get_value_name_int(0, "LockOut", BankingPay[LockOut]);
			cache_get_value_name(0, "Cheques", ChequesPayData, 700);
		    for ( new c = 0; c < MAX_COUNT_CHEQUES; c++ )
		    {
				new ChequePayDataSlot[4][50], SplitPos[2];
				SplitPos[1] = strfind(ChequesPayData, ",", false);
				for ( new i = 0; i != 4; i++ )
				{
					SplitPos[0] = strfind(ChequesPayData, "|", false);
					strmid(ChequePayDataSlot[i], ChequesPayData, 0, SplitPos[0]);
					strdel(ChequesPayData, 0, SplitPos[0]+1);
				}
				strdel(ChequesPayData, 0, SplitPos[1]+1);

				ChequesPay[c][UniqueID] = strval(ChequePayDataSlot[0]);
				ChequesPay[c][Type]     = strval(ChequePayDataSlot[1]);
				format(ChequesPay[c][NombreCh], MAX_PLAYER_NAME, "%s", ChequePayDataSlot[2]);
				ChequesPay[c][Ammount]  = strval(ChequePayDataSlot[3]);
			}
		    ////////////////////////////
			if ( BankingPay[LockIn] )
			{
			    if ( Banking[playerid][Balance] >= amount )
			    {
   					new StatsBank[400];
					format(StatsBank, sizeof(StatsBank), "{"COLOR_CREMA"}Tranferencia realizada con con exito!\n\n     {"COLOR_AMARILLO"}..::Resumen::..\n{"COLOR_CREMA"}# Cuenta origen: {"COLOR_AMARILLO"}%i\n{"COLOR_CREMA"}# Cuenta destino: {"COLOR_AMARILLO"}%i\n{"COLOR_CREMA"}Cantidad: {"COLOR_VERDE"}$%i",
					PlayersData[playerid][AccountBankingOpen],
					account,
					amount);

				    Banking[playerid][Balance] 			-= amount;
				    BankingPay[Balance] 				+= amount;
					ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Transferencia Realizada",StatsBank, "Aceptar", "Volver");
					/////////////////////////
					format(query, 500, "UPDATE `%s` SET ", DIR_ACCOUNT_BANK);
					strcat(query, "`Client`='%e',`Balance`='%i',`LockIn`='%i',`LockOut`='%i'");
					strcat(query, " WHERE `AccountNumber`=%i;");
					mysql_format(dataBase, query, 500, query,
						BankingPay[Owner],
						BankingPay[Balance],
						BankingPay[LockIn],
						BankingPay[LockOut],
						account);
					mysql_query(dataBase, query, false);

					format(query, 100, "UPDATE `%s` SET `Cheques`='", DIR_ACCOUNT_BANK);
				    for ( new chequeid = 0; chequeid < MAX_COUNT_CHEQUES; chequeid++ )
				    {
						new chequesData[60];
						format(chequesData, sizeof(chequesData), "%i|%i|%s|%i|,",
						ChequesPay[chequeid][UniqueID],
						ChequesPay[chequeid][Type],
						ChequesPay[chequeid][NombreCh],
						ChequesPay[chequeid][Ammount]);

						strcat(query, chequesData, 1000);
					}
					strcat(query, "' WHERE `AccountNumber`=%i;");
					mysql_format(dataBase, query, 1000, query, account);
					mysql_query(dataBase, query, false);
					/////////////////////////
			    }
			    else
			    {
					ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}Su cuenta de cheques no tiene suficientes fondos\npara realizar esta transferencia", "Aceptar", "Volver");
				}
			}
			else
			{
				ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}La cuenta a la que desea realizar una transferencia\ntiene prohibidas las transferencias entrantes.", "Aceptar", "Volver");
			}
		}
		else
		{
			ShowPlayerDialogEx(playerid,32,DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Banco - Error","{"COLOR_ROJO"}El numero de cuenta a donde desea transferir dinero no existe!", "Aceptar", "Volver");
		}
		cache_delete(cacheid);
	}
}
ShowBankConfiguration(playerid)
{
	new ConfigBankDialog[500];
	new TempConvert[100];

	format(TempConvert, sizeof(TempConvert), "{"COLOR_TEXTO_DIALOGS"}Alertas por SMS: %s {"COLOR_AMARILLO"}(Recargo de $10 por aviso)",
	SiOrNoBank[PlayersData[playerid][AlertSMSBank]]);
    strcat(ConfigBankDialog, TempConvert, sizeof(ConfigBankDialog));

	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_TEXTO_DIALOGS"}Aceptar Transferencias Entrantes: %s",
	SiOrNoBank[Banking[playerid][LockIn]]);
    strcat(ConfigBankDialog, TempConvert, sizeof(ConfigBankDialog));

	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_TEXTO_DIALOGS"}Aceptar Cobro de Cheques: %s {"COLOR_TEXTO_DIALOGS"}",
	SiOrNoBank[Banking[playerid][LockOut]]);
    strcat(ConfigBankDialog, TempConvert, sizeof(ConfigBankDialog));


	ShowPlayerDialogEx(playerid,86,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Banco - Configuracion", ConfigBankDialog, "Seleccionar", "Volver");
}
ShowBankTransferencia(playerid)
{
	ShowPlayerDialogEx(playerid,87,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Banco - Hacer una Transferencia", "{"COLOR_TEXTO_DIALOGS"}Ingrese el numero de cuenta a la que desea transferir dinero", "Siguiente", "Volver");
}
ShowBankTransferenciaCantidad(playerid)
{
	ShowPlayerDialogEx(playerid,88,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Banco - Elegir Cantidad", "{"COLOR_TEXTO_DIALOGS"}Ingrese la cantidad de dinero que desea transferir", "Siguiente", "Atras");
}
ShowBankTransferenciaResumen(playerid)
{
	new StatsTrans[400];
	format(StatsTrans, sizeof(StatsTrans), "{"COLOR_CREMA"}Esta a punto de realizar una transferencia!\n\n{"COLOR_CREMA"}Porfavor revise que todos los datos a continuacion estan correctamente:\n{"COLOR_CREMA"}# Cuenta origen: {"COLOR_AMARILLO"}%i\n{"COLOR_CREMA"}# Cuenta destino: {"COLOR_AMARILLO"}%i\n{"COLOR_CREMA"}Cantidad: {"COLOR_VERDE"}$%i\n\n{"COLOR_CREMA"}Si la informacion proporcionada esta correcta pulse en \"Realizar\"",
	PlayersData[playerid][AccountBankingOpen],
	PlayersDataOnline[playerid][SaveAfterAgenda][0],
	PlayersDataOnline[playerid][SaveAfterAgenda][1]);

	ShowPlayerDialogEx(playerid,89,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Banco - Verificar Datos", StatsTrans, "Realizar", "Atras");
}