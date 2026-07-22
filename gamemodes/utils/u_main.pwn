Float:GetPointDistanceFromPoint(Float:X1, Float:Y1, Float:Z1, Float:X2, Float:Y2, Float:Z2)
{
	//?((x2 - x1)² + (y2 - y1)² + (z2 - z1)²)
	return Float:floatsqroot( floatpower( (X2 - X1), 2 ) + floatpower( (Y2 - Y1), 2 ) + floatpower( (Z2 - Z1), 2 ) );
}

Float:GetPointFromPoint(Float:XpointOne, Float:YpointOne, Float:ZpointOne, Float:XpointTwo, Float:YpointTwo, Float:ZpointTwo)
{
	return (floatabs(XpointOne - XpointTwo) +
		 floatabs(YpointOne - YpointTwo) +
		 floatabs(ZpointOne - ZpointTwo));
}

ConvertToRGBColor(const string[])
{
    new LenGet = strlen(string);
    new stringtemp[200];
    format(stringtemp, 200, "%s", string);
	new go = true, i = 0;
	do
	{
	    if ( stringtemp[i] == '~' && stringtemp[i+2] == '~')
	    {
			if ( stringtemp[i+1] == 'r' || stringtemp[i+1] == 'R' )
			{
			    strdel(stringtemp, i, i+3);
			    strins(stringtemp, "{"COLOR_ROJO"}", i, sizeof(stringtemp));
			    i = -1;
			}
			else if ( stringtemp[i+1] == 'g' || stringtemp[i+1] == 'G' )
			{
			    strdel(stringtemp, i, i+3);
			    strins(stringtemp, "{"COLOR_VERDE"}", i, sizeof(stringtemp));
			    i = -1;
			}
			else if ( stringtemp[i+1] == 'b' || stringtemp[i+1] == 'B' )
			{
			    strdel(stringtemp, i, i+3);
			    strins(stringtemp, "{"COLOR_AZUL"}", i, sizeof(stringtemp));
			    i = -1;
			}
			else if ( stringtemp[i+1] == 'y' || stringtemp[i+1] == 'Y' )
			{
			    strdel(stringtemp, i, i+3);
			    strins(stringtemp, "{"COLOR_AMARILLO"}", i, sizeof(stringtemp));
			    i = -1;
			}
			else if ( stringtemp[i+1] == 'w' || stringtemp[i+1] == 'W' )
			{
			    strdel(stringtemp, i, i+3);
			    strins(stringtemp, "{"COLOR_CREMA"}", i, sizeof(stringtemp));
			    i = -1;
			}
			else if ( stringtemp[i+1] == 'p' || stringtemp[i+1] == 'P' )
			{
			    strdel(stringtemp, i, i+3);
			    strins(stringtemp, "{CC97F2}", i, sizeof(stringtemp));
			    i = -1;
			}
			else if ( stringtemp[i+1] == 'l' || stringtemp[i+1] == 'L' )
			{
			    strdel(stringtemp, i, i+3);
			    strins(stringtemp, "{303030}", i, sizeof(stringtemp));
			    i = -1;
			}
			else if ( stringtemp[i+1] == 'n' || stringtemp[i+1] == 'N' )
			{
			    strdel(stringtemp, i, i+3);
			    strins(stringtemp, "\n", i, sizeof(stringtemp));
			    i = -1;
			}
			LenGet = strlen(stringtemp);
	    }
	    i++;
	    if (i == LenGet) go = false;
	}
	while(go);
	return stringtemp;
}

SendChatStream(playerid, const text[])
{
	new Float:X, Float:Y, Float:Z;
	new MsgSendChat[MAX_TEXT_CHAT];
	GetPlayerPos(playerid,X,Y,Z);
	if ( CallCNN == playerid || PlayersDataOnline[playerid][IsDescolgado] && PlayersDataOnline[playerid][InCall] != -1 && PlayersDataOnline[playerid][InCall] != 888 &&
		 PlayersDataOnline[PlayersDataOnline[playerid][InCall]][IsDescolgado])
	{
	    new MsgSendChatAdmin[MAX_TEXT_CHAT];
	    if ( CallCNN != playerid )
	    {
	        if (PlayersDataOnline[PlayersDataOnline[playerid][InCall]][Altavoz])
	        {
	            new MsgSendChatNormal[MAX_TEXT_CHAT];
				format(MsgSendChatAdmin, sizeof(MsgSendChatAdmin), " [Altavoz]: %s [%s] (([%i]))", text,  PlayersDataOnline[PlayersDataOnline[playerid][InCall]][NameOnlineFix], playerid);
				format(MsgSendChatNormal, sizeof(MsgSendChatNormal), " [Altavoz]: %s [%s]", text, PlayersDataOnline[PlayersDataOnline[playerid][InCall]][NameOnlineFix]);
			    new Float:PosALTAVOZ[3]; GetPlayerPos(PlayersDataOnline[playerid][InCall], PosALTAVOZ[0], PosALTAVOZ[1], PosALTAVOZ[2]);
				for (new i = 0; i < MAX_PLAYERS; i++)
				{
				    if ( IsPlayerConnected(i) && PlayersData[i][Admin] >= 1 && PlayersDataOnline[i][State] == 3)
				    {
			            SendChatStreamAnonymousPlayerid(i, MsgSendChatAdmin, GetPlayerVirtualWorld(PlayersDataOnline[playerid][InCall]), PosALTAVOZ[0], PosALTAVOZ[1], PosALTAVOZ[2]);
				    }
				    else
				    {
			            SendChatStreamAnonymousPlayerid(i, MsgSendChatNormal, GetPlayerVirtualWorld(PlayersDataOnline[playerid][InCall]), PosALTAVOZ[0], PosALTAVOZ[1], PosALTAVOZ[2]);
					}
				}
			}
			else
			{
				format(MsgSendChat, sizeof(MsgSendChat), "[Movil]: %s", text);
				SendSplittedMessage(PlayersDataOnline[playerid][InCall], COLOR_DE_WISPEO, MsgSendChat);
			}
		}
		else
		{
			format(MsgSendChat, sizeof(MsgSendChat), "[Linea Telefonica]: %s", text);
			format(MsgSendChatAdmin, sizeof(MsgSendChatAdmin), "[Linea Telefonica]: %s (([%i]))", text, playerid);
			for (new i = 0; i < MAX_PLAYERS; i++)
			{
				if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && PlayersDataOnline[i][StateChannelCNN])
				{
				    if ( PlayersData[i][Admin] >= 1 )
				    {
				        SendSplittedMessage(i, COLOR_DE_TRANSMISION, MsgSendChatAdmin);
				    }
				    else
				    {
				        SendSplittedMessage(i, COLOR_DE_TRANSMISION, MsgSendChat);
					}
				}
			}
		}
		format(MsgSendChat, sizeof(MsgSendChat), "%s [Movil]: %s", PlayersDataOnline[playerid][NameOnlineFix], text);
	}
	else
	{
		format(MsgSendChat, sizeof(MsgSendChat), "%s dice: %s", PlayersDataOnline[playerid][NameOnlineFix], text);
	}
    new MyWorrld = GetPlayerVirtualWorld(playerid);
	new MyInterior = GetPlayerInterior(playerid);
	new highestPlayerId = GetPlayerPoolSize();
	for (new i = 0; i <= highestPlayerId; i++)
	{
	    if (IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i, 30.0, X, Y, Z) && GetPlayerVirtualWorld(i) == MyWorrld && GetPlayerInterior(i) == MyInterior)
	    {
		    if (IsPlayerInRangeOfPoint(i, 5.0, X, Y, Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[0], MsgSendChat);
			}
		    else if (IsPlayerInRangeOfPoint(i, 10.0, X, Y, Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[1], MsgSendChat);
			}
		    else if (IsPlayerInRangeOfPoint(i, 15.0, X, Y, Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[2], MsgSendChat);
			}
		    else if (IsPlayerInRangeOfPoint(i, 20.0, X, Y, Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[3], MsgSendChat);
			}
		    else if (IsPlayerInRangeOfPoint(i, 25.0, X, Y, Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[4], MsgSendChat);
			}
		    else if (IsPlayerInRangeOfPoint(i, 30.0, X, Y, Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[5], MsgSendChat);
			}
		}
	}
}

SendChatStreamNormal(playerid, const text[], const type[])
{
	new Float:X, Float:Y, Float:Z;
	new MsgSendChat[MAX_TEXT_CHAT];
	GetPlayerPos(playerid,X,Y,Z);
	format(MsgSendChat, sizeof(MsgSendChat), "%s %s %s", PlayersDataOnline[playerid][NameOnlineFix], type, text);
    new MyWorrld = GetPlayerVirtualWorld(playerid);
	for(new i=0;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i,30.0,X,Y,Z) && GetPlayerVirtualWorld(i) == MyWorrld)
	    {
		    if(IsPlayerInRangeOfPoint(i,5.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[0],MsgSendChat);
			}
		    else if(IsPlayerInRangeOfPoint(i,10.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[1],MsgSendChat);
			}
		    else if(IsPlayerInRangeOfPoint(i,15.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[2],MsgSendChat);
			}
		    else if(IsPlayerInRangeOfPoint(i,20.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[3],MsgSendChat);
			}
		    else if(IsPlayerInRangeOfPoint(i,25.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[4],MsgSendChat);
			}
		    else if(IsPlayerInRangeOfPoint(i,30.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[5],MsgSendChat);
			}
		}
	}
}

SendChatStreamAnonymousPlayerid(playerid, const text[], WorldStream, Float:X, Float:Y, Float:Z)
{
    if(IsPlayerConnected(playerid) && IsPlayerInRangeOfPoint(playerid,30.0,X,Y,Z) && GetPlayerVirtualWorld(playerid) == WorldStream && PlayersDataOnline[playerid][State] == 3)
    {
	    if(IsPlayerInRangeOfPoint(playerid,5.0,X,Y,Z))
	    {
	    	SendSplittedMessage(playerid, SendChatStreamColors[0], text);
		}
	    else if(IsPlayerInRangeOfPoint(playerid,10.0,X,Y,Z))
	    {
	    	SendSplittedMessage(playerid, SendChatStreamColors[1],text);
		}
	    else if(IsPlayerInRangeOfPoint(playerid,15.0,X,Y,Z))
	    {
	    	SendSplittedMessage(playerid, SendChatStreamColors[2],text);
		}
	    else if(IsPlayerInRangeOfPoint(playerid,20.0,X,Y,Z))
	    {
	    	SendSplittedMessage(playerid, SendChatStreamColors[3],text);
		}
	    else if(IsPlayerInRangeOfPoint(playerid,25.0,X,Y,Z))
	    {
	    	SendSplittedMessage(playerid, SendChatStreamColors[4],text);
		}
	    else if(IsPlayerInRangeOfPoint(playerid,30.0,X,Y,Z))
	    {
	    	SendSplittedMessage(playerid, SendChatStreamColors[5],text);
		}
	}
}

SendChatStreamGritar(playerid, const text[])
{
    new TextAccion[150];
	format(TextAccion, sizeof(TextAccion), "*%s grita: ¡¡%s!!", PlayersDataOnline[playerid][NameOnlineFix], text);
    new WorldStream = GetPlayerVirtualWorld(playerid);
    new Float:X, Float:Y, Float:Z;  GetPlayerPos(playerid, X, Y, Z);

	for(new i=0;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i,50.0,X,Y,Z) && GetPlayerVirtualWorld(i) == WorldStream && PlayersDataOnline[i][State] == 3)
	    {
		    if(IsPlayerInRangeOfPoint(i,5.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[0],TextAccion);
			}
		    else if(IsPlayerInRangeOfPoint(i,10.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[1],TextAccion);
			}
		    else if(IsPlayerInRangeOfPoint(i,20.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[2],TextAccion);
			}
		    else if(IsPlayerInRangeOfPoint(i,30.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[3],TextAccion);
			}
		    else if(IsPlayerInRangeOfPoint(i,40.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[4],TextAccion);
			}
		    else if(IsPlayerInRangeOfPoint(i,50.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[5],TextAccion);
			}
		}
	}
}

SendChatStreamAnonymous(const text[], WorldStream, Float:X, Float:Y, Float:Z)
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i,30.0,X,Y,Z) && GetPlayerVirtualWorld(i) == WorldStream && PlayersDataOnline[i][State] == 3)
	    {
		    if(IsPlayerInRangeOfPoint(i,5.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[0], text);
			}
		    else if(IsPlayerInRangeOfPoint(i,10.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[1], text);
			}
		    else if(IsPlayerInRangeOfPoint(i,15.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[2], text);
			}
		    else if(IsPlayerInRangeOfPoint(i,20.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[3], text);
			}
		    else if(IsPlayerInRangeOfPoint(i,25.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[4], text);
			}
		    else if(IsPlayerInRangeOfPoint(i,30.0,X,Y,Z))
		    {
		    	SendSplittedMessage(i, SendChatStreamColors[5], text);
			}
		}
	}
}

Acciones(playerid, type, const text[])
{
	new MsgAcciones[150];
	switch (type)
	{
	    case 0: // 0 - ME - LILA
	    {
			format(MsgAcciones, sizeof(MsgAcciones), "* %s %s", PlayersDataOnline[playerid][NameOnlineFix], text);
		}
	    case 1: // 1 - AME - AMARILLO
	    {
			format(MsgAcciones, sizeof(MsgAcciones), "%s [ID:%i]", text, playerid);
		}
	    case 2: // 2 - INTENTAR OK - VERDE
	    {
			format(MsgAcciones, sizeof(MsgAcciones), "* %s intento %s, y consiguio hacerlo!", PlayersDataOnline[playerid][NameOnlineFix], text);
		}
	    case 3: // 3 - INTENTAR FAIL - ROJO
	    {
			format(MsgAcciones, sizeof(MsgAcciones), "* %s intento %s, y no consiguio hacerlo.", PlayersDataOnline[playerid][NameOnlineFix], text);
		}
	    case 4: // 4 - GRITAR - BLANCO
	    {
			format(MsgAcciones, sizeof(MsgAcciones), "* %s Grita: %s!!", PlayersDataOnline[playerid][NameOnlineFix], text);
		}
	    case 5: // 5 - SUSURRAR - BLANCO
	    {
			format(MsgAcciones, sizeof(MsgAcciones), "* %s susurra: %s", PlayersDataOnline[playerid][NameOnlineFix], text);
		}
	    case 6: // 6 - CANAL OOC - MEDIO GRIS
	    {
			format(MsgAcciones, sizeof(MsgAcciones), "[OOC] %s: (( %s ))", PlayersDataOnline[playerid][NameOnlineFix], text);
		}
	    case 7: // 7 - AME FIX - AMARILLO
	    {
			format(MsgAcciones, sizeof(MsgAcciones), "%s [ID:%i]*", text, playerid);
		}
	    case 8: // 8 - ME FIX - LILA
	    {
			format(MsgAcciones, sizeof(MsgAcciones), "** %s %s", PlayersDataOnline[playerid][NameOnlineFix], text);
		}
	    case 9: // 9 - MEGAFONO
	    {
			format(MsgAcciones, sizeof(MsgAcciones), "* %s [Megafono]: %s!!!", PlayersDataOnline[playerid][NameOnlineFix], text);
		}
	}

    new Float:PosMensajeX, Float:PosMensajeY, Float:PosMensajeZ;
    GetPlayerPos(playerid, Float:PosMensajeX, Float:PosMensajeY, Float:PosMensajeZ);
    new MyWorrld = GetPlayerVirtualWorld(playerid);
	for ( new i = 0; i < MAX_PLAYERS; i++ )
	{
		if ( IsPlayerConnected(i) && IsPlayerInRangeOfPoint(
			i,
			AccionesRadios[type],
			Float:PosMensajeX,
			Float:PosMensajeY,
			Float:PosMensajeZ) && GetPlayerVirtualWorld(i) == MyWorrld &&
			PlayersDataOnline[i][State] == 3)
		{
			SendSplittedMessage(i, AccionesColors[type], MsgAcciones);
		}
	}
	print(MsgAcciones);
}

SendMessageRadioGeneral(playerid, const text[])
{
	new MsgRadio[MAX_TEXT_CHAT];
	format(MsgRadio, sizeof(MsgRadio), "***[%s] %s %s Radio General: %s, corto.", FaccionData[PlayersData[playerid][Faccion]][NameFaccion], FaccionesRangos[PlayersData[playerid][Faccion]][PlayersData[playerid][Rango]], PlayersDataOnline[playerid][NameOnlineFix], text);
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( i != playerid && IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && (PlayersData[i][Faccion] == LSPD || PlayersData[i][Faccion] == SFPD) )
		{
			SendClientMessage(i, COLOR_RADIO, MsgRadio);
		}
	}
	SendChatStreamNormal(playerid, text, "[Radio General]:");
	print(MsgRadio);
}

SendMessageRadioGeneralSAMD(playerid, const text[])
{
	new MsgRadio[MAX_TEXT_CHAT];
	format(MsgRadio, sizeof(MsgRadio), "***[%s] %s %s Radio General: %s, corto.", FaccionData[PlayersData[playerid][Faccion]][NameFaccion], FaccionesRangos[PlayersData[playerid][Faccion]][PlayersData[playerid][Rango]], PlayersDataOnline[playerid][NameOnlineFix], text);
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( i != playerid && IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && (PlayersData[i][Faccion] == SFMD || PlayersData[i][Faccion] == LSMD) )
		{
			SendClientMessage(i, COLOR_RADIO, MsgRadio);
		}
	}
	SendChatStreamNormal(playerid, text, "[Radio General]:");
	print(MsgRadio);
}

SendMessageRadioGlobal(playerid, const text[])
{
	new MsgRadio[MAX_TEXT_CHAT];
	format(MsgRadio, sizeof(MsgRadio), "***[%s] %s %s Radio Global: %s, corto.", FaccionData[PlayersData[playerid][Faccion]][NameFaccion], FaccionesRangos[PlayersData[playerid][Faccion]][PlayersData[playerid][Rango]], PlayersDataOnline[playerid][NameOnlineFix], text);
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( 
			i != playerid && IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && 
			(PlayersData[i][Faccion] == SFMD || PlayersData[i][Faccion] == LSMD ||
			PlayersData[i][Faccion] == LSPD || PlayersData[i][Faccion] == SFPD || PlayersData[i][Faccion] == GOBIERNO ) )
		{
			SendClientMessage(i, COLOR_RADIO, MsgRadio);
		}
	}
	SendChatStreamNormal(playerid, text, "[Radio Global]:");
	print(MsgRadio);
}

SendMessageRadio(playerid, frecuencia, const text[])
{
	new MsgRadio[MAX_TEXT_CHAT];
	format(MsgRadio, sizeof(MsgRadio), "*** %s %s radio Frecuencia[%i]: %s, corto.", FaccionesRangos[PlayersData[playerid][Faccion]][PlayersData[playerid][Rango]], PlayersDataOnline[playerid][NameOnlineFix], frecuencia,text);
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( i != playerid && IsPlayerConnected(i) && PlayersData[i][Faccion] == PlayersData[playerid][Faccion] && PlayersDataOnline[i][State] == 3  && PlayersDataOnline[i][StateChannelRadio] && PlayersDataOnline[i][Frecuencia] == frecuencia)
		{
			SendClientMessage(i, COLOR_RADIO, MsgRadio);
		}
	}
	SendChatStreamNormal(playerid, text, "[Radio]:");
	print(MsgRadio);
}

SendMessageDM(playerid, const text[])
{
	new MsgDM[MAX_TEXT_CHAT];
	format(MsgDM, sizeof(MsgDM), "* DM General %s: %s", PlayersDataOnline[playerid][NameOnlineFix], text);
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 && PlayersDataOnline[i][ModeDM] )
		{
			SendClientMessage(i, COLOR_DM, MsgDM);
		}
	}
	print(MsgDM);
}

SendMessageFamily(playerid, const text[])
{
	new MsgFamily[MAX_TEXT_CHAT];
	format(MsgFamily, sizeof(MsgFamily), "*** %s %s: %s", FaccionesRangos[PlayersData[playerid][Faccion]][PlayersData[playerid][Rango]], PlayersDataOnline[playerid][NameOnlineFix], text);
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && PlayersData[i][Faccion] == PlayersData[playerid][Faccion] && PlayersDataOnline[i][State] == 3  && PlayersDataOnline[i][StateChannelFamily])
		{
			SendClientMessage(i, COLOR_FAMILY, MsgFamily);
		}
	}
	print(MsgFamily);
}

PlayPlayerStreamSound(playerid, soundid)
{
	new Float:PlayerPos[3]; GetPlayerPos(playerid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);
	for ( new i = 0; i < MAX_PLAYERS; i++ )
	{
		if ( IsPlayerConnected(i) )
		{
			if ( IsPlayerInRangeOfPoint(i,
			30.0,   				// Radio del sonido
			PlayerPos[0],  			// Coordenadas X
			PlayerPos[1],      		// Coordenadas Y
			PlayerPos[2]) )			// Coordenadas Z
			{
				PlayerPlaySound(i, soundid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);
			}
		}
	}
	return 1;
}

IntentarAccion(playerid, const text[], rndNum)
{
	if ( gettime() - PlayersDataOnline[playerid][Intentar]  >= 5 )
	{
	    PlayersDataOnline[playerid][Intentar] = gettime();
	    if ( rndNum )
	    {
            Acciones(playerid, 2, text);
            return true;
        }
        else
        {
            Acciones(playerid, 3, text);
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "130", "Tiene que esperar 5 segundos entre cada uso de /Intentar [Accion].");
	}
    return false;
}

SendChatStreamIdioma(playerid, const text[], idiomaid)
{
	new Float:X, Float:Y, Float:Z;
	new MsgSendChat[MAX_TEXT_CHAT];
	new MsgSendChatDesconocido[MAX_TEXT_CHAT];
	GetPlayerPos(playerid,X,Y,Z);
	format(MsgSendChat, sizeof(MsgSendChat), "*%s [%s]: %s", PlayersDataOnline[playerid][NameOnlineFix], IdiomasNames[idiomaid], text);
	format(MsgSendChatDesconocido, sizeof(MsgSendChatDesconocido), "*%s [%s]: [No entendiste ninguna palabra]", PlayersDataOnline[playerid][NameOnlineFix], IdiomasNames[idiomaid]);
	for(new i=0;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i,30.0,X,Y,Z))
	    {
		    if(IsPlayerInRangeOfPoint(i,5.0,X,Y,Z))
		    {
		        if ( PlayersData[i][Idiomas][idiomaid] )
		        {
		    		SendClientMessage(i, SendChatStreamColors[0],MsgSendChat);
	    		}
	    		else
	    		{
		    		SendClientMessage(i, SendChatStreamColors[0],MsgSendChatDesconocido);
				}
			}
		    else if(IsPlayerInRangeOfPoint(i,10.0,X,Y,Z))
		    {
		        if ( PlayersData[i][Idiomas][idiomaid] )
		        {
		    		SendClientMessage(i, SendChatStreamColors[1],MsgSendChat);
	    		}
	    		else
	    		{
		    		SendClientMessage(i, SendChatStreamColors[1],MsgSendChatDesconocido);
				}
			}
		    else if(IsPlayerInRangeOfPoint(i,15.0,X,Y,Z))
		    {
		        if ( PlayersData[i][Idiomas][idiomaid] )
		        {
		    		SendClientMessage(i, SendChatStreamColors[2],MsgSendChat);
	    		}
	    		else
	    		{
		    		SendClientMessage(i, SendChatStreamColors[2],MsgSendChatDesconocido);
				}
			}
		    else if(IsPlayerInRangeOfPoint(i,20.0,X,Y,Z))
		    {
		        if ( PlayersData[i][Idiomas][idiomaid] )
		        {
		    		SendClientMessage(i, SendChatStreamColors[3],MsgSendChat);
	    		}
	    		else
	    		{
		    		SendClientMessage(i, SendChatStreamColors[3],MsgSendChatDesconocido);
				}
			}
		    else if(IsPlayerInRangeOfPoint(i,25.0,X,Y,Z))
		    {
		        if ( PlayersData[i][Idiomas][idiomaid] )
		        {
		    		SendClientMessage(i, SendChatStreamColors[4],MsgSendChat);
	    		}
	    		else
	    		{
		    		SendClientMessage(i, SendChatStreamColors[4],MsgSendChatDesconocido);
				}
			}
		    else if(IsPlayerInRangeOfPoint(i,30.0,X,Y,Z))
		    {
		        if ( PlayersData[i][Idiomas][idiomaid] )
		        {
		    		SendClientMessage(i, SendChatStreamColors[5],MsgSendChat);
	    		}
	    		else
	    		{
		    		SendClientMessage(i, SendChatStreamColors[5],MsgSendChatDesconocido);
				}
			}
		}
	}
}

GetPosSpace(const text[], option)
{
	new SavePos = -1;
	for (new i = 1; i <= option; i++)
	{
		SavePos = strfind(text, " ", false, SavePos + 1);
	}
	return SavePos;
}

IsNotZero(playerid, number)
{
	if ( number > 0 && number <= 999999)
	{
	    return true;
	}
	else
	{
		SendInfoMessage(playerid, 0, "882", "Debe depositar o retirar mas de $0 y menos de $999999");
		return false;
	}
}

IsNotOneWeapon(weaponid)
{

	if ( SlotIDWeapon[weaponid] != 0   &&
		 SlotIDWeapon[weaponid] != 1   &&
		 SlotIDWeapon[weaponid] != 10  &&
		 SlotIDWeapon[weaponid] != 11  &&
		 SlotIDWeapon[weaponid] != 12   )
	{
	    return true;
	}
	else
	{
	    return false;
	}
}

IsPlayerNotVehicleWeapondAction(playerid, playeridtwo)
{
	if ( !IsPlayerInAnyVehicle(playerid) && !IsPlayerInAnyVehicle(playeridtwo) )
	{
	    return true;
	}
	else
	{
		SendInfoMessage(playerid, 0, "1032", "No puede estar ninguno de los 2 en un vehiculo para dar armas, municiones o quitar una misma");
	    return false;
	}
}

GetMyNearCity(playerid)
{
    for ( new i = 10000; i >= 0;i=i-100)
    {
		if (IsPlayerInRangeOfPoint(playerid, i, -1720.5479,1018.1831,17.2422) &&
			IsPlayerInRangeOfPoint(playerid, i, 2804.9290,-1432.0378,39.7068) )
		{
		    continue;
		}
		else
		{
			if ( IsPlayerInRangeOfPoint(playerid, i, -1720.5479,1018.1831,17.2422) )
			{
				return true; // SF
			}
			else
			{
				return false; // LS
			}
		}
	}
	return false;
}

ReverseEx(&number)
{
	if ( number )
	{
	    number = false;
	}
	else
	{
	    number = true;
	}
}

Reverse(&bool:number)
{
	if ( number )
	{
	    number = false;
	}
	else
	{
	    number = true;
	}
}

IsPlayerInBarra(playerid)
{
	if ( GetPlayerVirtualWorld(playerid) == 4 || PlayersData[playerid][IsPlayerInVehInt])
	{
		if ( IsPlayerInRangeOfPoint(playerid, 	3.0,
												-927.9366,2224.1982,43.2305) ||
			IsPlayerInRangeOfPoint(playerid, 	3.0,
												-909.5477,2224.5791,43.2305) ||
			IsPlayerInRangeOfPoint(playerid, 	3.0,
												-908.4485,2224.5012,51.3453) ||
			IsPlayerInRangeOfPoint(playerid, 	3.0,
												-927.8519,2224.3909,51.34535)||
			IsPlayerInRangeOfPoint(playerid, 	3.0,
												-917.7833,2206.2751,51.3453) ||
			IsPlayerInRangeOfPoint(playerid, 	3.0,
												2398.5273,1107.9354,34.6063) ||
			IsPlayerInRangeOfPoint(playerid, 	3.0,
												970.8110,-47.7546,1001.1172) ||
			IsPlayerInRangeOfPoint(playerid, 	3.0,
												-786.2424,498.2604,1371.7422)	)
		{
		    return true;
		}
	}
	return false;
}

IsPointFromPoint(Float:RadioE, Float:XpointOne, Float:YpointOne, Float:ZpointOne, Float:XpointTwo, Float:YpointTwo, Float:ZpointTwo)
{
	if ( floatabs(XpointOne - XpointTwo) <= RadioE &&
		 floatabs(YpointOne - YpointTwo) <= RadioE &&
		 floatabs(ZpointOne - ZpointTwo) <= RadioE
	   )
	{
	    return true;
    }
    else
    {
        return false;
	}
}

TogglePlayerControllableEx(playerid, bool:toogle)
{
	if ( toogle )
	{
		if ( !PlayersDataOnline[playerid][IsAtado] && !PlayersDataOnline[playerid][IsEsposas] )
		{
			TogglePlayerControllable(playerid, toogle);
		}
	}
	else
	{
		TogglePlayerControllable(playerid, toogle);
	}
}

IsValidStringServer(playerid, const string[])
{
    if (strfind(string, InvalidSting, true) != -1)
    {
        SendInfoMessage(playerid, 0, "1380", "Ha introducido un caracter invalido.");
        return false;
    }
    for ( new i = 0; i < strlen(string); i++ )
	{
		if ( string[i] == ',' ||
	     	 string[i] == '|' )
		{
		    SendInfoMessage(playerid, 0, "1380", "Ha introducido un caracter invalido.");
		    return false;
		}
	}
	return true;
}

IsValidStringServerOther(playerid, const string[])
{
    if (strfind(string, InvalidSting, true) != -1)
    {
        SendInfoMessage(playerid, 0, "1380", "Ha introducido un caracter invalido.");
        return false;
    }
	for ( new i = 0; i < strlen(string); i++ )
	{
	    if ( string[i] == ''' ||
	     	 string[i] == '|' )
		{
		    SendInfoMessage(playerid, 0, "1380", "Ha introducido un caracter invalido.");
		    return false;
		}
	}
	return true;
}

DetectSpam(playerid, text[])
{
	if ( strfind(text, " server ", false, 0) 					!= -1 ||
		 strfind(text, "server ", false, 0) 					== 0 ||
	     strfind(text, " servidor ", false, 0) 					!= -1 ||
		 strfind(text, "servidor ", false, 0) 					== 0 ||
		 strfind(text, " rol ", false, 0) 						!= -1 ||
		 strfind(text, "rol ", false, 0)						== 0 ||
		 strfind(text, "87.98.229.188:7232", false, 0)			!= -1 ||
		 strfind(text, "213.5.176.155:8888", false, 0) 			!= -1 ||
		 strfind(text, "217.18.70.93:8800", false, 0) 			!= -1 ||
		 strfind(text, "66.7.194.75:5555", false, 0) 			!= -1 ||
		 strfind(text, "173.192.22.150:7777", false, 0) 		!= -1 ||
		 strfind(text, "78.129.221.58:7787", false, 0)			!= -1 ||
 		 strfind(text, "184.82.169.84:7781", false, 0) 			!= -1 ||
 		 strfind(text, "188.138.106.41:7777", false, 0) 		!= -1 ||
 		 strfind(text, "Rol Iberico", false, 0) 				!= -1 ||
		 strfind(text, "Gamerol.net", false, 0) 				!= -1 ||
		 strfind(text, "Gamerol", false, 0) 					!= -1 ||
		 strfind(text, "CiudadMetropolis.com", false, 0) 		!= -1 ||
		 strfind(text, "Ciudad Metropolis", false, 0) 			!= -1 ||
		 strfind(text, "Spacerol.net", false, 0) 				!= -1 ||
		 strfind(text, "Spacerol", false, 0) 					!= -1
	  )
	{
		format(text, 256, "Anuncio: %s. Movil: %i", text, PlayersData[playerid][Phone]);
		SendClientMessage(playerid, 0x0FFF00FF, text);
		new MsgAviso[MAX_TEXT_CHAT];
	    format(MsgAviso, sizeof(MsgAviso), "%s AntiSpam - %s[%i] posible spammer. Texto del anuncio: %s", LOGO_STAFF, PlayersDataOnline[playerid][NameOnline], playerid, text);
	    MsgCheatsReportsToAdmins(MsgAviso);
		return true;
	}
	else
	{
	    return false;
	}
}

SetPlayerVirtualWorldEx(playerid, wolrdid)
{
	SetPlayerVirtualWorld(playerid, wolrdid);
	if ( PlayersDataOnline[playerid][State] == 3 )
	{
		AddPlayerDescription(playerid, true);
	}
}

ShowStations(playerid, selected, option)
{
	new StationsDialog[2500];
	new TempConvert[150];
	new SelectedColor[10];

    strcat(StationsDialog, "{"COLOR_ROJO"}|| DETENER MUSICA ||", sizeof(StationsDialog));

	for (new i = 0; i < sizeof(Stations); i++)
	{
	    if ( selected == i )
	    {
	        SelectedColor = "{"COLOR_AZUL"}";
	    }
	    else
	    {
			SelectedColor = "{"COLOR_VERDE"}";
		}

	    format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}%i - %s%s", i + 1, SelectedColor, Stations[i][0]);
        strcat(StationsDialog, TempConvert, sizeof(StationsDialog));
	}
	if ( option == 1 )
	{
		ShowPlayerDialogEx(playerid,141,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Musica - Casa", StationsDialog, "Seleccionar", "Salir");
	}
	else if ( option == 2 )
	{
		ShowPlayerDialogEx(playerid,155,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Musica - Local", StationsDialog, "Seleccionar", "Salir");
	}
	else
	{
		ShowPlayerDialogEx(playerid,143,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Estereo - Vehiculo", StationsDialog, "Seleccionar", "Salir");
	}
}
SpawnPlayerEx(playerid)
{
    SpawnPlayer(playerid);
	ReturnObjetsToPlayer(playerid);
}
SetPlayerSkinEx(playerid, skinid)
{
	SetPlayerSkin(playerid, skinid);
	ReturnObjetsToPlayer(playerid);
}
GetPlayerInteriorEx(playerid)
{
	return PlayersDataOnline[playerid][LastInterior];
}
SetPlayerInteriorEx(playerid, newinterior)
{
	PlayersDataOnline[playerid][LastInterior] = newinterior;
	SetPlayerInterior(playerid, newinterior);
}

SendInfoMessage(playerid, type, const optional[], const message[]) 
{
	new MsgInfo[MAX_TEXT_CHAT];
	switch ( type )
	{
	    // Error
	    case 0:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "Error: %s", message);
		}
		// Ayuda
	    case 1:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "%s %s", message, optional);
		}
		// informacion
	    case 2:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "Info: %s", message);
		}
		// Afirmativo
	    case 3:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "Importante: %s", message);
		}
	}
	return SendClientMessage(playerid, COLOR_MESSAGES[type], MsgInfo);
}

SendOutput(playerid, type, const message[], const optional[]) 
{
	new MsgInfo[MAX_TEXT_CHAT];
	switch ( type )
	{
	    // Error
	    case 0:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "Error: %s", message);
		}
		// Ayuda
	    case 1:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "%s %s", message, optional);
		}
		// informacion
	    case 2:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "Info: %s", message);
		}
		// Afirmativo
	    case 3:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "Importante: %s", message);
		}
	}
	return SendClientMessage(playerid, COLOR_MESSAGES[type], MsgInfo);
}

SendSyntaxError(playerid, const command[], const example[])
{
	new SintaxisErro[MAX_TEXT_CHAT];
	format(SintaxisErro, sizeof(SintaxisErro), "Ha introducído mal el sintaxis del comando /%s. Ejemplo correcto: /%s", command, example );
	return SendSplittedMessage(playerid, COLOR_MESSAGES[0], SintaxisErro);
}

SendAccessError(playerid, const command[])
{
	new AcessError[MAX_TEXT_CHAT];
	format(AcessError, sizeof(AcessError), "Tu no tienes acceso a el comando /%s", command);
	return SendClientMessage(playerid, COLOR_MESSAGES[0], AcessError);
}

SendAdviseMessage(playerid, const advise[])
{
	new adviseText[150];
    format(adviseText, sizeof(adviseText), "%s %s", LOGO_STAFF, advise);
	return SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, adviseText);
}

SendSplittedMessage(playerid, color, const text[])
{
    if (strlen(text) <= MAX_TEXT_CHAT)
        return SendClientMessage(playerid, color, text);

	new newString[256];
	strcopy(newString, text);

	new stringCutted[MAX_TEXT_CHAT + 1];
	strmid(stringCutted, text, 0, MAX_TEXT_CHAT - 3);
	strcat(stringCutted, "...");

	strdel(newString, 0, MAX_TEXT_CHAT - 3);
	strins(newString, "...", 0, strlen(newString) + 3 + 1);

	SendClientMessage(playerid, color, stringCutted);
	return SendSplittedMessage(playerid, color, newString);
}

Text:TextDrawCreateEx(Float:Xt, Float:Yt, const text[])
{
    MAX_TEXT_DRAW++;
    return TextDrawCreate(Xt, Yt, text);
}