LoadIncendios()
{
	new DirBD[50];
	format(DirBD, sizeof(DirBD), "%sIncendios.ulp", DIR_MISC);
	if ( fexist(DirBD) )
	{
	    new FireData[510];
	    new FireDataSlots[MAX_GASOLINERAS_COUNT][30];
		new File:LoadFire = fopen(DirBD, io_read);
		fread(LoadFire, FireData);
		fclose(LoadFire);

		new PosSplitAfter = 0;
		for ( new i = 0; i < MAX_INCENDIOS; i++ )
		{
			PosSplitAfter = strfind(FireData, ",", false);
			strmid(FireDataSlots[i], FireData, 0, PosSplitAfter, sizeof(FireData));
			strdel(FireData, 0, PosSplitAfter + 1);
			Incendios[i][HouseidI]	= strval(FireDataSlots[i]);
			if (Incendios[i][HouseidI])
			{
				CreateFire(Incendios[i][HouseidI], i);
			}
		}
	}
	else
	{
	    print(" ERROR AL CARGAR LOS INCENDIOS !!!!!!");
	}
}
SaveIncendios()
{
	new DirBD[50];
	format(DirBD, sizeof(DirBD), "%sIncendios.ulp", DIR_MISC);

	new FireData[510];
	new TempConvert[510];
	for (new i = 0; i < MAX_INCENDIOS; i++)
	{
	    format(TempConvert, sizeof(TempConvert), "%i,", Incendios[i][HouseidI]);
        strcat(FireData, TempConvert, sizeof(TempConvert));
	}

	new File:SaveFire = fopen(DirBD, io_write);
	fwrite(SaveFire, FireData);
	fclose(SaveFire);
}


GetFireNext()
{
	for (new i; i < MAX_INCENDIOS; i++)
	{
		if ( !Incendios[i][HouseidI] )
		{
		    return i;
		}
	}
	return -1;
}
CreateFire(houseid, fireid)
{
	if ( fireid != -1 )
	{
	    Incendios[fireid][HouseidI] = houseid;

		Incendios[fireid][ObjectsIDIn][14] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX], HouseData[houseid][PosY], HouseData[houseid][PosZ], 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][13] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX], HouseData[houseid][PosY], HouseData[houseid][PosZ] + LINE_FIRE, 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][12] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX], HouseData[houseid][PosY] + LINE_FIRE, HouseData[houseid][PosZ], 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][11] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX] + LINE_FIRE, HouseData[houseid][PosY], HouseData[houseid][PosZ], 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][10] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX] + LINE_FIRE, HouseData[houseid][PosY] + LINE_FIRE, HouseData[houseid][PosZ], 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][9] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX], HouseData[houseid][PosY] + LINE_FIRE, HouseData[houseid][PosZ] + LINE_FIRE, 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][8] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX] + LINE_FIRE, HouseData[houseid][PosY], HouseData[houseid][PosZ] + LINE_FIRE, 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][7] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX], HouseData[houseid][PosY], HouseData[houseid][PosZ] - LINE_FIRE, 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][6] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX], HouseData[houseid][PosY] - LINE_FIRE, HouseData[houseid][PosZ], 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][5] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX] - LINE_FIRE, HouseData[houseid][PosY], HouseData[houseid][PosZ], 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][4] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX] - LINE_FIRE, HouseData[houseid][PosY] - LINE_FIRE, HouseData[houseid][PosZ], 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][3] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX], HouseData[houseid][PosY] - LINE_FIRE, HouseData[houseid][PosZ] - LINE_FIRE, 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][2] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX] - LINE_FIRE, HouseData[houseid][PosY], HouseData[houseid][PosZ] - LINE_FIRE, 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][1] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX] + LINE_FIRE, HouseData[houseid][PosY] + LINE_FIRE, HouseData[houseid][PosZ] + LINE_FIRE, 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDIn][0] = CreateDynamicObject(FIRE_OBJECT, HouseData[houseid][PosX] - LINE_FIRE, HouseData[houseid][PosY] - LINE_FIRE, HouseData[houseid][PosZ] - LINE_FIRE, 0.0, 0.0, 0.0, -1, -1, -1, MAX_RADIO_STREAM);

		Incendios[fireid][ObjectsIDOut][14] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX], TypeHouse[HouseData[houseid][TypeHouseId]][PosY], TypeHouse[HouseData[houseid][TypeHouseId]][PosZ], 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][13] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX], TypeHouse[HouseData[houseid][TypeHouseId]][PosY], TypeHouse[HouseData[houseid][TypeHouseId]][PosZ] + LINE_FIRE, 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][12] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX], TypeHouse[HouseData[houseid][TypeHouseId]][PosY] + LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosZ], 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][11] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX] + LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosY], TypeHouse[HouseData[houseid][TypeHouseId]][PosZ], 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][10] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX] + LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosY] + LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosZ], 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][9] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX], TypeHouse[HouseData[houseid][TypeHouseId]][PosY] + LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosZ] + LINE_FIRE, 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][8] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX] + LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosY], TypeHouse[HouseData[houseid][TypeHouseId]][PosZ] + LINE_FIRE, 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][7] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX], TypeHouse[HouseData[houseid][TypeHouseId]][PosY], TypeHouse[HouseData[houseid][TypeHouseId]][PosZ] - LINE_FIRE, 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][6] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX], TypeHouse[HouseData[houseid][TypeHouseId]][PosY] - LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosZ], 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][5] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX] - LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosY], TypeHouse[HouseData[houseid][TypeHouseId]][PosZ], 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][4] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX] - LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosY] - LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosZ], 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][3] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX], TypeHouse[HouseData[houseid][TypeHouseId]][PosY] - LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosZ] - LINE_FIRE, 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][2] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX] - LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosY], TypeHouse[HouseData[houseid][TypeHouseId]][PosZ] - LINE_FIRE, 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][1] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX] + LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosY] + LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosZ] + 2, 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		Incendios[fireid][ObjectsIDOut][0] = CreateDynamicObject(FIRE_OBJECT, TypeHouse[HouseData[houseid][TypeHouseId]][PosX] - LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosY] - LINE_FIRE, TypeHouse[HouseData[houseid][TypeHouseId]][PosZ] -2, 0.0, 0.0, 0.0, houseid, -1, -1, MAX_RADIO_STREAM);
		return true;
	}
	else
	{
	    return false;
	}
}
DestroyFire(fireid)
{
	if ( Incendios[fireid][HouseidI] )
	{
		Incendios[fireid][HouseidI] = false;
		for (new i = 0; i < 15; i++)
		{
		    if ( Incendios[fireid][ObjectsIDIn][i] )
		    {
			    DestroyDynamicObject(Incendios[fireid][ObjectsIDIn][i]);
			    Incendios[fireid][ObjectsIDIn][i] = false;
			}
			if ( Incendios[fireid][ObjectsIDOut][i] )
			{
			    DestroyDynamicObject(Incendios[fireid][ObjectsIDOut][i]);
			    Incendios[fireid][ObjectsIDOut][i] = false;
			}
		}
		return true;
	}
	{
		return false;
	}
}
IsPlayerNearFire(playerid)
{
	for (new i = 0; i < MAX_INCENDIOS; i++)
	{
		if ( Incendios[i][HouseidI] )
		{
		    new Float:PosFire[3];
		    if ( PlayersData[playerid][IsPlayerInHouse] == Incendios[i][HouseidI])
		    {
		        PosFire[0] = TypeHouse[HouseData[Incendios[i][HouseidI]][TypeHouseId]][PosX];
				PosFire[1] = TypeHouse[HouseData[Incendios[i][HouseidI]][TypeHouseId]][PosY];
				PosFire[2] = TypeHouse[HouseData[Incendios[i][HouseidI]][TypeHouseId]][PosZ];
			}
			else
			{
		        PosFire[0] = HouseData[Incendios[i][HouseidI]][PosX];
				PosFire[1] = HouseData[Incendios[i][HouseidI]][PosY];
				PosFire[2] = HouseData[Incendios[i][HouseidI]][PosZ];
			}
			if ( IsPlayerInRangeOfPoint(playerid, 20.0, PosFire[0], PosFire[1], PosFire[2]) )
			{
			    return i;
			}
		}
	}
	SendInfoMessage(playerid, 0, "1273", "Usted no se encuentra cerca de un incendio");
	return -1;
}
DestroyParticleFire(fireid)
{
	for (new i = 0; i < 15; i++)
	{
	    if ( Incendios[fireid][ObjectsIDIn][i] )
	    {
		    if ( Incendios[fireid][ObjectsIDIn][i] )
		    {
			    DestroyDynamicObject(Incendios[fireid][ObjectsIDIn][i]);
			    Incendios[fireid][ObjectsIDIn][i] = false;
			}
			if ( Incendios[fireid][ObjectsIDOut][i] )
			{
			    DestroyDynamicObject(Incendios[fireid][ObjectsIDOut][i]);
			    Incendios[fireid][ObjectsIDOut][i] = false;
			}
			break;
		}

	}
	if ( !Incendios[fireid][ObjectsIDOut][14] )
	{
		DestroyFire(fireid);
	}
}
ShowIncendios(playerid)
{
	new IncendiosDialog[700];
	new TempConvert[60];
	new ConteoFire = -1;
	for (new i = 0; i < MAX_INCENDIOS; i++)
	{
	    if ( Incendios[i][HouseidI] )
	    {
			if ( ConteoFire != -1 )
			{
			    format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}Incendio ID[%i] - Casa ID[%i]", i, Incendios[i][HouseidI]);
	    	}
			else
			{
			    format(TempConvert, sizeof(TempConvert), "{"COLOR_CREMA"}Incendio ID[%i] - Casa ID[%i]", i, Incendios[i][HouseidI]);
			}
	        strcat(IncendiosDialog, TempConvert, sizeof(IncendiosDialog));
	        ConteoFire++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoFire] = i;
        }
	}
	if (ConteoFire != -1)
	{
		ShowPlayerDialogEx(playerid,71,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Incendios - Lista", IncendiosDialog, "Destruir", "Salir");
	}
	else
	{
		ShowPlayerDialogEx(playerid,999,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Incendios - informacion", "{"COLOR_TEXTO_DIALOGS"}No se encontraron incendios.", "Aceptar", "");
	}
}
CheckFire(playerid)
{
	for (new i = 0; i < MAX_INCENDIOS; i++)
	{
	    if ( Incendios[i][HouseidI] )
	    {
			if ( GetPlayerVirtualWorld(playerid) == Incendios[i][HouseidI] && IsPlayerInRangeOfPoint(playerid, 3.0, TypeHouse[HouseData[Incendios[i][HouseidI]][TypeHouseId]][PosX], TypeHouse[HouseData[Incendios[i][HouseidI]][TypeHouseId]][PosY], TypeHouse[HouseData[Incendios[i][HouseidI]][TypeHouseId]][PosZ]) ||
			     IsPlayerInRangeOfPoint(playerid, 3.0, HouseData[Incendios[i][HouseidI]][PosX], HouseData[Incendios[i][HouseidI]][PosY], HouseData[Incendios[i][HouseidI]][PosZ]) )
			{
			    SetPlayerHealthEx(playerid, -5);
			}
	    }
    }
}
RandomFire()
{
	new HouseID = random(MAX_HOUSE_COUNT - 1) + 1;
    if ( strlen(HouseData[HouseID][Dueno]) > 2 )
    {
		if ( CreateFire(HouseID, GetFireNext()) )
		{
			printf("[Incendios]: La casa ID[%i] se incendio!", HouseID);
		}
    }
}