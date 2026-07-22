// logica core de bombas

ShowBombas(playerid)
{
    new BombasDialog[1750];
    new TempConvert[60];
    new ConteoBombas = -1;
    new TiposBomb[2][9] = {"Piso", "Vehiculo"};
    for (new i = 0; i < MAX_BOMBAS_COUNT; i++ )
    {
        if ( BombasO[i][TypeBomba] != BOMBA_TYPE_NONE )
        {
            if ( ConteoBombas != -1 )
            {
                format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}Bomba {"COLOR_AMARILLO"}#%i {"COLOR_AZUL"}[%s]", i, TiposBomb[BombasO[i][TypeBomba] - 1]);
            }
            else
            {
                format(TempConvert, sizeof(TempConvert), "{"COLOR_CREMA"}Bomba {"COLOR_AMARILLO"}#%i {"COLOR_AZUL"}[%s]", i, TiposBomb[BombasO[i][TypeBomba] - 1]);
            }
            strcat(BombasDialog, TempConvert, sizeof(BombasDialog));
            ConteoBombas++;
            PlayersDataOnline[playerid][SaveAfterAgenda][ConteoBombas] = i;
        }
    }
    if (ConteoBombas != -1)
    {
        ShowPlayerDialogEx(playerid,77,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Bombas - Control", BombasDialog, "Detonar", "Salir");
    }
    else
    {
        ShowPlayerDialogEx(playerid,999,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Bombas - Control", "{"COLOR_TEXTO_DIALOGS"}No se encontraron bombas.", "Aceptar", "");
    }
}

AddBomba(playerid, type, vehicleSQLID, Float:Xbom, Float:Ybom, Float:Zbom, objectid)
{
    for (new i = 0; i < MAX_BOMBAS_COUNT; i++ )
    {
        if ( BombasO[i][TypeBomba] == BOMBA_TYPE_NONE )
        {
            new MsgPonerBomba[MAX_TEXT_CHAT];
            if ( type == BOMBA_TYPE_FOOT )
            {
                format(MsgPonerBomba, sizeof(MsgPonerBomba), "has puesto una bomba en el piso! El número de control de la bomba es #%i.", i);
                new Float:ZZ[3];
                if ( playerid != -1 )
                {
                    switch ( objectid )
                    {
                        case 1654: // Dinamita
                        {
                            Zbom   = Zbom - 0.9;
                            ZZ[0]  = -90.0;
                        }
                        case 1265: // Bolsa
                        {
                            Zbom   = Zbom - 0.6;
                        }
                        case 1580:
                        {
                            Zbom   = Zbom - 1.0;
                        }
                        case 1210: // Maletin
                        {
                            Zbom   = Zbom - 0.9;
                            ZZ[0]  = -90.0;
                        }
                        case 1576:
                        {
                            Zbom   = Zbom - 1.0;
                        }
                        case 1577:
                        {
                            Zbom   = Zbom - 1.0;
                        }
                        case 1578:
                        {
                            Zbom   = Zbom - 1.0;
                        }
                        case 1579:
                        {
                            Zbom   = Zbom - 1.0;
                        }
                    }
                }
                else
                {
                    if ( objectid == 1654 || objectid == 1210 )
                    {
                        ZZ[0] = -90.0;
                    }
                }
                BombasO[i][ObjectIDO] = objectid;
                BombasO[i][ObjectID]  = CreateDynamicObject(objectid, Xbom, Ybom, Zbom, ZZ[0], ZZ[1], ZZ[2], -1, -1, -1, MAX_RADIO_STREAM);
                BombasO[i][PosX]      = Xbom;
                BombasO[i][PosY]      = Ybom;
                BombasO[i][PosZ]      = Zbom;
                BombasO[i][TypeBomba] = BOMBA_TYPE_FOOT;
            }
            else
            {
                format(MsgPonerBomba, sizeof(MsgPonerBomba), "Has puesto una bomba en este vehiculo! El numero de contro de la bomba es #%i.", i);
                BombasO[i][ObjectID]  = vehicleSQLID;
                BombasO[i][TypeBomba] = BOMBA_TYPE_CAR;
            }
            if ( playerid != -1 )
            {
                SendInfoMessage(playerid, 2, "0", MsgPonerBomba);
            }
            SaveBombaToDB(i);
            return true;
        }
    }
    if ( playerid != -1 )
    {
        SendInfoMessage(playerid, 0, "1294", "Han alcanzado el numero de bombas plantadas!");
    }
    return false;
}

RemoveBomba(bombaid)
{
    if ( BombasO[bombaid][TypeBomba] != BOMBA_TYPE_NONE )
    {
        if ( BombasO[bombaid][TypeBomba] == BOMBA_TYPE_FOOT )
        {
            DestroyDynamicObject(BombasO[bombaid][ObjectID]);
        }
        BombasO[bombaid][TypeBomba] = BOMBA_TYPE_NONE;
        ClearBombaFromDB(bombaid);
        return true;
    }
    return false;
}

DesactivarBomba(playerid, bombaid)
{
    if ( BombasO[bombaid][TypeBomba] != BOMBA_TYPE_NONE )
    {
        PlayersData[playerid][Bombas]++;
        RemoveBomba(bombaid);
        return true;
    }
    return false;
}

function ActivarBomba(bombaid, count)
{
    if ( BombasO[bombaid][TypeBomba] != BOMBA_TYPE_NONE )
    {
        if ( BombasO[bombaid][TypeBomba] == BOMBA_TYPE_CAR )
        {
            GetVehiclePos(BombasO[bombaid][ObjectID], BombasO[bombaid][PosX], BombasO[bombaid][PosY], BombasO[bombaid][PosZ]);
        }
        for (new i = 0; i < count; i++)
        {
            CreateExplosion(BombasO[bombaid][PosX], BombasO[bombaid][PosY], BombasO[bombaid][PosZ], 2, 10.0);
        }
        RemoveBomba(bombaid);
        return true;
    }
    return false;
}
