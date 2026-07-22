IsPlayerLogued(playerid)
{
	if (IsPlayerConnected(playerid))
	{
	    if (PlayersDataOnline[playerid][State] == 3)
	    {
	        return 1;
	    }
	}
	return 0;
}

IsPlayerLoguedEx(playerid, playeridCheck)
{
	if (IsPlayerConnected(playeridCheck))
	{
	    if (PlayersDataOnline[playeridCheck][State] == 3)
	    {
	        return 1;
	    }
	    else
		{
		    SendClientMessage(playerid, COLOR_MESSAGES[0], "El jugador no se encuentra logueado.");
		    return 0;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_MESSAGES[0], "El jugador no se encuentra conectado.");
		return 0;
	}
}

IsPlayerConnectedEx(const playername[])
{
	for( new i, j=GetPlayerPoolSize(); i <= j; i++ )
	{
		if ( IsPlayerLogued(i) && strfind(playername, PlayersDataOnline[i][NameOnline], true) == 0 && strlen(playername) == strlen(PlayersDataOnline[i][NameOnline]) )
		{
		    return i;
		}
    }
	return -1;
}

bool:IsAccountExist(const accountName[])
{
	new query[100], Cache:result, accountExist = false;
	mysql_format(dataBase, query, sizeof(query), "SELECT `ID` FROM %s WHERE Nombre='%e';", DIR_USERS, accountName);
	result = mysql_query(dataBase, query);
	cache_get_row_count(accountExist);
	cache_delete(result);
	return bool:accountExist;
}

IsPlayerNear(myplayerid, playerid)
{
	if (IsPlayerLoguedEx(myplayerid, playerid))
	{
	    new Float:MyPos[3];
	    GetPlayerPos(myplayerid, MyPos[0], MyPos[1], MyPos[2]);
	    if ( IsPlayerInRangeOfPoint(playerid, 4.0, MyPos[0], MyPos[1], MyPos[2]) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(myplayerid)  )
	    {
	        return true;
		}
		else
		{
		    SendClientMessage(myplayerid, COLOR_MESSAGES[0], "El jugador no se encuentra cerca de ti");
		    return false;
		}
	}
	else return false;
}

IsPlayerNearEx(myplayerid, playerid, const iderror1[], const iderror2[], const iderror3[], const stringerror1[], const stringerror2[], const stringerror3[])
{
	if ( myplayerid != playerid )
	{
		if ( IsPlayerConnected(playerid) )
		{
			if (PlayersDataOnline[playerid][State] == 3)
			{
			    new Float:MyPos[3];
			    GetPlayerPos(myplayerid, MyPos[0], MyPos[1], MyPos[2]);
			    if ( IsPlayerInRangeOfPoint(playerid, 4.0, MyPos[0], MyPos[1], MyPos[2]) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(myplayerid)  )
			    {
			        return true;
	   			}
	   			else
	   			{
					SendInfoMessage(myplayerid, 0, iderror3, stringerror3);
				}
			}
			else
			{
				SendInfoMessage(myplayerid, 0, iderror2, stringerror2);
			}
		}
		else
		{
			SendInfoMessage(myplayerid, 0, iderror1, stringerror1);
		}
	}
	else
	{
		SendInfoMessage(myplayerid, 0, "213", "Has introducido tu misma ID");
	}
	return false;
}

// nivel L requiere 2*L*(L+1) horas en total
// (4 + 8 + 12 + ... + 4*L = 4*L*(L+1)/2 = 2*L*(L+1))
// nivel 0 = 0h, nivel 1 = 4h, nivel 2 = 12h, nivel 3 = 24h, nivel 4 = 40h
GetLevelFromHours(hours)
{
	new level = 0;
	new required = 4;
	while (hours >= required)
	{
		level++;
		required += 4 * (level + 1);
	}
	return level;
}

GetPlayerScoreEx(playerid)
{
	return GetLevelFromHours(PlayersData[playerid][HoursPlaying]);
}

GetPlayerScoreMax(playerid)
{
	return 4 * (GetLevelFromHours(PlayersData[playerid][HoursPlaying]) + 1);
}

GetPlayerScoreMin(playerid)
{
	new hours = PlayersData[playerid][HoursPlaying];
	new level = GetLevelFromHours(hours);
	return hours - 2 * level * (level + 1);
}

IsNotFullMaterialsPlayer(playerid, newamount)
{
	if ( (PlayersData[playerid][Materiales] + newamount) <= 2500 )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}

bool:IsPlayerInExterior(playerid)
{
    return ( GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0 );
}

SetPlayerHealthEx(playerid, Float:Health)
{
	if ( PlayersDataOnline[playerid][VidaOn] + Health >= 100.0 )
	{
	    PlayersDataOnline[playerid][VidaOn] = 100.0;
	}
	else
	{
		PlayersDataOnline[playerid][VidaOn] = PlayersDataOnline[playerid][VidaOn] + Health;
	}
	PlayersDataOnline[playerid][ChangeVC] = 10;
}

SetPlayerArmourEx(playerid, Float:Armour)
{
	if ( PlayersDataOnline[playerid][ChalecoOn] + Armour >= 85.0 )
	{
	    PlayersDataOnline[playerid][ChalecoOn] = 85.0;
	}
	else
	{
		PlayersDataOnline[playerid][ChalecoOn] = PlayersDataOnline[playerid][ChalecoOn] + Armour;
	}
	PlayersDataOnline[playerid][ChangeVC] = 10;
}
GivePlayerMoneyEx(playerid, money)
{
	PlayersDataOnline[playerid][StateMoneyPass] = gettime() + 5;
    PlayersData[playerid][Dinero] += money;
}



// lista de contraseñas comunes rechazadas
static const CommonPasswords[][] =
{
	"1234567890", "123456789", "12345678", "1234567",
	"123456", "12345", "1234",
	"password", "password1", "password123",
	"qwerty", "qwerty123", "qwertyuiop",
	"abc123", "abcdef", "abcdefg",
	"111111", "000000", "666666",
	"iloveyou", "princess", "sunshine",
	"dragon", "monkey", "football",
	"baseball", "welcome", "admin",
	"letmein", "trustno1", "master",
	"login", "starwars", "access",
	"passw0rd", "p@ssword", "p@ssw0rd",
	"contraseña", "contrasena", "clave",
	"mipassword", "miclave"
};

// valida la contraseña del registro
// devuelve 0 si es valida, o un codigo de error
ValidatePlayerPassword(const password[])
{
	new len = strlen(password);

	// minimo 10 caracteres
	if (len < 10)
		return 1;

	// maximo 25 caracteres (limite existente)
	if (len > 25)
		return 2;

	new hasLetter = 0;
	new hasDigit = 0;
	new hasSpecial = 0;

	for (new i = 0; i < len; i++)
	{
		new ch = password[i];

		if ('a' <= ch <= 'z' || 'A' <= ch <= 'Z')
			hasLetter = 1;
		else if ('0' <= ch <= '9')
			hasDigit = 1;
		else
			hasSpecial = 1;
	}

	// al menos una letra
	if (!hasLetter)
		return 3;

	// al menos un digito
	if (!hasDigit)
		return 4;

	// al menos un caracter especial
	if (!hasSpecial)
		return 5;

	// rechazar contraseñas obvias
	for (new i = 0; i < sizeof(CommonPasswords); i++)
	{
		if (strcmp(password, CommonPasswords[i], true) == 0)
			return 6;
	}

	return 0;
}

// devuelve el mensaje de error correspondiente al codigo
GetPasswordErrorText(errorCode, reason[], reasonSize = sizeof(reason))
{
	switch (errorCode)
	{
		case 1: format(reason, reasonSize, "La clave debe tener al menos 10 caracteres.");
		case 2: format(reason, reasonSize, "La clave no puede tener mas de 25 caracteres.");
		case 3: format(reason, reasonSize, "La clave debe contener al menos una letra.");
		case 4: format(reason, reasonSize, "La clave debe contener al menos un numero.");
		case 5: format(reason, reasonSize, "La clave debe contener al menos un caracter especial (ej: !@#$%%^&*).");
		case 6: format(reason, reasonSize, "La clave ingresada es muy comun, elija una mas segura.");
		default: format(reason, reasonSize, "Error desconocido al validar la clave.");
	}
}

IsValidEmail(playerid, const email[])
{
   /*
	new StrRequestHTTP[400];
	format(StrRequestHTTP, sizeof(StrRequestHTTP), ""URL_WEB"/IsValidEmail.php?email=%s",
			email);

	printf("%s", StrRequestHTTP);

	HTTP(playerid, HTTP_POST, StrRequestHTTP, "", "ValidingEmail");
	*/
	printf("IsValidEmail: %s", email);

	new len = strlen(email);
	new atCount = 0;
	new atPos = -1;
	new lastDotPos = -1;
	new firstDotAfterAt = -1;

	// validar formato caracter por caracter
	for (new i = 0; i < len; i++)
	{
		new ch = email[i];

		// no se permiten espacios
		if (ch == ' ')
		{
			ValidingEmail(playerid, HTTP_ERROR_MALFORMED_RESPONSE, " ");
			return 1;
		}

		if (ch == '@')
		{
			atCount++;
			atPos = i;
		}

		if (ch == '.')
		{
			lastDotPos = i;
			// primer "." que aparece despues del "@", solo se setea una vez
			if (atPos != -1 && i > atPos && firstDotAfterAt == -1)
				firstDotAfterAt = i;
		}
	}

	// exactamente un "@" y al menos 1 caracter antes
	if (atCount != 1 || atPos < 1)
	{
		ValidingEmail(playerid, HTTP_ERROR_MALFORMED_RESPONSE, " ");
		return 1;
	}

	// al menos 1 caracter entre el "@" y el primer "." posterior
	if (firstDotAfterAt == -1 || firstDotAfterAt - atPos < 2)
	{
		ValidingEmail(playerid, HTTP_ERROR_MALFORMED_RESPONSE, " ");
		return 1;
	}

	// al menos 2 caracteres despues del ultimo "."
	if (len - lastDotPos - 1 < 2)
	{
		ValidingEmail(playerid, HTTP_ERROR_MALFORMED_RESPONSE, " ");
		return 1;
	}

	// limite minimo existente
	if (len < 14)
	{
		ValidingEmail(playerid, HTTP_ERROR_MALFORMED_RESPONSE, " ");
		return 1;
	}

	new query[200], Cache:cacheid, emailInUse;
	mysql_format(dataBase, query, 200, "SELECT `Email` FROM `%s` WHERE `Email`='%e';", DIR_USERS, email);
	mysql_query(dataBase, query);
	cache_get_row_count(emailInUse);
	cache_delete(cacheid);
	if (emailInUse)
	{
	    SendInfoMessage(playerid, 0, "1606", "E-mail en uso.");
	    ShowPlayerEmailChange(playerid, 1);
	}
	else
	{
		// formato valido y no duplicado: pedir confirmacion antes de guardar
		format(PlayersDataOnline[playerid][TempEmail], 60, "%s", email);
		ShowPlayerDialogEx(playerid, 142, DIALOG_STYLE_INPUT, "{"COLOR_AZUL"}Confirmar E-mail", "{"COLOR_TEXTO_DIALOGS"}Vuelva a escribir su E-mail para confirmar:", "Confirmar", "Volver");
	}
	return 1;
}

GetUserIDBySQLID(sqlID)
{
	for( new i; i < MAX_PLAYERS; i++ ){
		if( IsPlayerLogued(i) && PlayersData[i][DB_ID] == sqlID ){
			return i;
		}
	}
	return -1;
}