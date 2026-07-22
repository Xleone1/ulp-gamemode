// comandos y dialogos de bombas extraidos de main.pwn

OnPlayerCommandBombas(playerid, const cmdtext[])
{
    // /Poner Bomba [tipo]
    if (strfind(cmdtext, "/Poner Bomba", true) == 0)
    {
        MsgAdminUseCommands(9, playerid, cmdtext);
        if ( PlayersData[playerid][Faccion] == SICARIOS &&
             PlayersData[playerid][Rango] <= 4 ||
             PlayersData[playerid][Admin] >= 8 && PlayersDataOnline[playerid][AdminOn] )
        {
            if ( PlayersData[playerid][Bombas] > 0 || PlayersData[playerid][Admin] >= 8 && PlayersDataOnline[playerid][AdminOn] )
            {
                new ObjectIDBomb = strval(cmdtext[GetPosSpace(cmdtext, 2)]);
                new ResultadoPlanted;
                new Float:PosPlayer[3]; GetPlayerPos(playerid, PosPlayer[0], PosPlayer[1], PosPlayer[2]);
                if ( IsPlayerInAnyVehicle(playerid) )
                {
                    ResultadoPlanted = AddBomba(playerid, BOMBA_TYPE_CAR, GetPlayerVehicleID(playerid), PosPlayer[0], PosPlayer[1], PosPlayer[2], 0);
                    ApplyPlayerAnimCustom(playerid,
                    "CAR_CHAT",
                    CARCHAT_ANIMATIONS[15], false);
                }
                else
                {
                    if ( ObjectIDBomb >= 0 && ObjectIDBomb < 8 )
                    {
                        ResultadoPlanted = AddBomba(playerid, BOMBA_TYPE_FOOT, false, PosPlayer[0], PosPlayer[1], PosPlayer[2], BombasOjectsID[ObjectIDBomb]);
                        ApplyPlayerAnimCustom(playerid,
                        "BOMBER",
                        BOMBER_ANIMATIONS[0], false);
                    }
                    else
                    {
                        SendInfoMessage(playerid, 0, "1303", "El tipo de bomba debe estar comprendido entre 0 y 7!");
                    }
                }
                if ( ResultadoPlanted )
                {
                    if ( PlayersData[playerid][Admin] >= 8 && PlayersDataOnline[playerid][AdminOn] )
                    {

                    }
                    else
                    {
                        PlayersData[playerid][Bombas]--;
                    }
                }
            }
            else
            {
                SendInfoMessage(playerid, 0, "1302", "No tienes bombas!");
            }
        }
        else
        {
            SendInfoMessage(playerid, 0, "1294", "Usted no es no puede poner bombas!");
        }
        return 1;
    }
    // /Ver Bomba
    else if (strcmp("/Ver Bomba", cmdtext, true, 10) == 0 && strlen(cmdtext) == 10)
    {
        if ( PlayersData[playerid][Faccion] == SICARIOS &&
             PlayersData[playerid][Rango] <= 4 )
        {
            new IsBombNear = IsPlayerNearBomba(playerid, 1.5, -1);
            if ( IsBombNear != -1 )
            {
                new MsgVerBomba[MAX_TEXT_CHAT];
                format(MsgVerBomba, sizeof(MsgVerBomba), "Esta bomba tiene el numero de control #%i", IsBombNear);
                SendInfoMessage(playerid, 2, "0", MsgVerBomba);
            }
            else
            {
                SendInfoMessage(playerid, 0, "1300", "No te encuentras cerca de una bomba");
            }
        }
        else
        {
            SendInfoMessage(playerid, 0, "1297", "Usted no puede ver el numero de control en una bomba!");
        }
        return 1;
    }
    // /Bombas (abre dialog 77)
    else if (strcmp("/Bombas", cmdtext, true, 7) == 0 && strlen(cmdtext) == 7)
    {
        MsgAdminUseCommands(9, playerid, cmdtext);
        if ( PlayersData[playerid][Faccion] == SICARIOS &&
             PlayersData[playerid][Rango] <= 4 || PlayersData[playerid][Admin] >= 8 && PlayersDataOnline[playerid][AdminOn] )
        {
            ShowBombas(playerid);
        }
        else
        {
            SendInfoMessage(playerid, 0, "1298", "Usted no puede usar el control de bombas!");
        }
        return 1;
    }
    // /Detonar Todas
    else if (strcmp("/Detonar Todas", cmdtext, true, 14) == 0 && strlen(cmdtext) == 14)
    {
        MsgAdminUseCommands(9, playerid, cmdtext);
		new isFound;
        if ( PlayersData[playerid][Faccion] == SICARIOS &&
             PlayersData[playerid][Rango] <= 1  || PlayersData[playerid][Admin] >= 8 && PlayersDataOnline[playerid][AdminOn])
        {
            for (new i = 0; i < MAX_BOMBAS_COUNT; i++ )
            {
                if ( BombasO[i][TypeBomba] != BOMBA_TYPE_NONE )
                {
                    ActivarBomba(i, 1);
                    isFound++;
                }
            }
            if ( isFound )
            {
                new StringFormat[MAX_TEXT_CHAT];
                format(StringFormat, sizeof(StringFormat), "Detonaste todas las bombas actuales en total eran %i.", isFound);
                SendInfoMessage(playerid, 2, "0", StringFormat);
            }
            else
            {
                SendInfoMessage(playerid, 0, "1306", "No hay bombas para detonar!");
            }
        }
        else
        {
            SendInfoMessage(playerid, 0, "1305", "No te encuentras cerca de una bomba!");
        }
        return 1;
    }
    // /Desactivar (wrapper para bomba y bomba todos)
    else if (strfind(cmdtext, "/Desactivar ", true) == 0)
    {
        // /Desactivar Bomba
        if (strcmp("/Desactivar Bomba", cmdtext, true, 17) == 0 && strlen(cmdtext) == 17)
        {
            if ( PlayersData[playerid][Faccion] == SICARIOS &&
                 PlayersData[playerid][Rango] <= 4 ||
                PlayersData[playerid][Faccion] == SFPD && PlayersData[playerid][Rango] <= 6 ||
                PlayersData[playerid][Faccion] == LSPD && PlayersData[playerid][Rango] <= 6  )
            {
                new IsBombNear = IsPlayerNearBomba(playerid, 1.5, -1);
                if ( IsBombNear != -1 )
                {
                    if ( PlayersData[playerid][Faccion] == SFPD || PlayersData[playerid][Faccion] == LSPD )
                    {
                        if (IntentarAccion(playerid, "desactivar la bomba", random(3)))
                        {
                            DesactivarBomba(playerid, IsBombNear);
                            Acciones(playerid, 7, "Bomba: Desactivada...");
                        }
                        else
                        {
                            ActivarBomba(IsBombNear, 20);
                            Acciones(playerid, 7, "Bomba: Activada...");
                        }
                    }
                    else
                    {
                        if ( DesactivarBomba(playerid, IsBombNear) )
                        {
                            SendInfoMessage(playerid, 2, "0", "Desactivaste esta bomba!");
                        }
                        else
                        {
                            SendInfoMessage(playerid, 0, "1304", "Ocurrio un error al desactivar la bomba!");
                        }
                    }
                }
                else
                {
                    SendInfoMessage(playerid, 0, "1301", "No te encuentras cerca de una bomba!");
                }
            }
            else
            {
                SendInfoMessage(playerid, 0, "1295", "Usted no es no puede desactivar bombas!");
            }
        }
        // /Desactivar Bomba Todos
        else if (strcmp("/Desactivar Bomba Todos", cmdtext, true, 23) == 0 && strlen(cmdtext) == 23)
        {
            MsgAdminUseCommands(9, playerid, cmdtext);
            if ( PlayersData[playerid][Admin] >= 7 )
            {
                for (new i = 0; i < MAX_BOMBAS_COUNT; i++ )
                {
                    RemoveBomba(i);
                }
                new StringFormat[MAX_TEXT_CHAT];
                format(StringFormat, sizeof(StringFormat), "%s Has desactivado todas las bombas",LOGO_STAFF);
                SendClientMessage(playerid, COLOR_MENSAJES_DE_AVISOS, StringFormat);
            }
            else
            {
                SendInfoMessage(playerid, 0, "1299", "Tu no tienes acceso a el comando /Desactivar Bomba Todos.");
            }
        }
        else
        {
            SendInfoMessage(playerid, 0, "1296", "Quizas quiso decir: /Desactivar Bomba");
        }
    }
    return 0;
}

// dialogos de bombas (cases 77 y 78)

OnBombasDialogResponse(playerid, dialogid, response, listitem)
{
    switch(dialogid)
    {
        case 77:
        {
            if ( response == 1 )
            {
                new IsBombNear = IsPlayerNearBomba(playerid, 250.0, PlayersDataOnline[playerid][SaveAfterAgenda][listitem]);
                if ( IsBombNear != -1 )
                {
                    if ( ActivarBomba(IsBombNear, 20) )
                    {
                        ShowPlayerDialogEx(playerid,78,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Bombas - Control Detonacion", "{"COLOR_VERDE"}Bomba detonada exitosamente!", "Aceptar", "Volver");
                    }
                    else
                    {
                        ShowPlayerDialogEx(playerid,78,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Bombas - Control Error", "{"COLOR_ROJO"}Error al detonar la bomba!\n Al parecer ya fue detonada por otro miembro!", "Aceptar", "Volver");
                    }
                }
                else
                {
                    ShowPlayerDialogEx(playerid,78,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Bombas - Control Error", "{"COLOR_VERDE"}Error de conexion con la bomba\n intente acercarse mas a la misma para detonarla!", "Aceptar", "Volver");
                }
            }
            return 1;
        }
        case 78:
        {
            if ( response == 0 )
            {
                ShowBombas(playerid);
            }
            return 1;
        }
    }
    return 0;
}
