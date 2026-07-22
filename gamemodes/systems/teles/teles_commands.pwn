// comandos y dialogos de teles extraidos de main.pwn

OnPlayerCommandTeles(playerid, const cmdtext[])
{
	if (strcmp("/Crear Tele", cmdtext, true) == 0)
	{
	    if (!PlayersData[playerid][Mapper]) return SendAccessError(playerid, "Crear Tele");
		CrearTele(playerid);
		return 1;
	}
	else if (strfind(cmdtext, "/Crear Garage", true) == 0){
	    if (!PlayersData[playerid][Mapper]) return SendAccessError(playerid, "Crear Garage");
		if(strlen(cmdtext) >= 14){
			new teleID = strval(cmdtext[14]);
			if(teleID < 0 || teleID >= MAX_TELES_COUNT) return SendInfoMessage(playerid, 0, "", "ID invalida!");
			if(!Teles[teleID][PickupID]) return SendInfoMessage(playerid, 0, "", "Ese tele no existe");
			if(Teles[teleID][DuenoType] == 2) return SendInfoMessage(playerid, 0, "", "Debes usar /Crear GarageC para crear un garage en una casa!");
			CrearGarage(playerid, teleID);
		}
		else SendSyntaxError(playerid, "Crear Garage [ID_Tele]", "Crear Garage 10");
		return 1;
	}
	return 0;
}

OnPlayerCommandTelesLlaves(playerid, const cmdtext[])
{
	if (strcmp("/Llaves PuertaEx", cmdtext, true, 16) == 0 && strlen(cmdtext) == 16)
	{
		if (PlayersDataOnline[playerid][InPickupTele] == -1) return SendInfoMessage(playerid, 0, "812", "No te encuentras al lado de ninguna puerta");
		new teleid = PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipoid];
		if (PlayerHaveTeleKeys(playerid, teleid))
		{
			if (Teles[teleid][Lock])
			{
				Teles[teleid][Lock] = false;
				Teles[Teles[teleid][PickupIDGo]][Lock] = false;
				GameTextForPlayer(playerid, "~W~Puerta ~G~Abierta!", 1000, 6);
			}
			else
			{
				Teles[teleid][Lock] = true;
				Teles[Teles[teleid][PickupIDGo]][Lock] = true;
				GameTextForPlayer(playerid, "~W~Puerta ~R~Cerrada!", 1000, 6);
			}
			PlayPlayerStreamSound(playerid, 1027);
			UpdateLockDoorForPlayer(PlayersDataOnline[playerid][InPickup], Teles[teleid][Lock], Teles[teleid][PickupIDGo]);
		}
		else
		{
			SendInfoMessage(playerid, 0, "811", "No tienes las llaves de esta puerta!");
		}
		return 1;
	}
	else if (strcmp("/Llaves GarageEx", cmdtext, true, 16) == 0 && strlen(cmdtext) == 16)
	{
		new teleid = IsPlayerInGarageEx(playerid);
		if (teleid != -1)
		{
			if (PlayerHaveTeleKeys(playerid, teleid))
			{
				if (Teles[teleid][Lock])
				{
					Teles[teleid][Lock] = false;
					Teles[Teles[teleid][PickupIDGo]][Lock] = false;
					GameTextForPlayer(playerid, "~W~Garage ~G~Abierto!", 1000, 6);
				}
				else
				{
					Teles[teleid][Lock] = true;
					Teles[Teles[teleid][PickupIDGo]][Lock] = true;
					GameTextForPlayer(playerid, "~W~Garage ~R~Cerrado!", 1000, 6);
				}
				PlayPlayerStreamSound(playerid, 1027);
				UpdateLockDoorForPlayer(PlayersDataOnline[playerid][InPickup], Teles[teleid][Lock], Teles[teleid][PickupIDGo]);
			}
			else
			{
				SendInfoMessage(playerid, 0, "1286", "No tienes las llaves de este garage!");
			}
		}
		else
		{
			SendInfoMessage(playerid, 0, "1459", "No te encuentras al lado de ningun garage");
		}
		return 1;
	}
	return 0;
}

OnPlayerCommandTelesMapper(playerid, const cmdtext[])
{
	// /Tele Tipo
	if (strfind(cmdtext, "/Tele Tipo", true) == 0)
	{
	    if (!PlayersData[playerid][Mapper]) return SendAccessError(playerid, "Tele Tipo");
	    if (PlayersDataOnline[playerid][InPickupTele] == -1) return SendInfoMessage(playerid, 0, "", "No te encuentras en ningun tele");
	    new teleid = PlayersDataOnline[playerid][InPickupTele];

	    if (strcmp("/Tele Tipo Banco", cmdtext, true) == 0)
	    {
			SetTeleTipo(teleid, 0);
	    	SendAdviseMessage(playerid, "Ahora este tele es la entrada un banco.");
	    }
	    else if (strcmp("/Tele Tipo Hotel", cmdtext, true) == 0)
	    {
			SetTeleTipo(teleid, 1);
	    	SendAdviseMessage(playerid, "Ahora este tele es la entrada un hotel.");
	    }
	    else return SendInfoMessage(playerid, 0, "", "Quizas quiso decir: /Tele Tipo {Banco, Hotel}");
		return 1;
	}
	// /IrTele [ID_Tele]
	else if (strfind(cmdtext, "/IrTele ", true) == 0)
	{
	    if (!PlayersData[playerid][Mapper]) return SendAccessError(playerid, "IrTele");
	    new teleid = strval(cmdtext[8]);
	    if (teleid < 0 || teleid >= MAX_TELES_COUNT ) return SendInfoMessage(playerid, 0, "", "ID de Tele invalido");
	    if (Teles[teleid][PickupID] == 0) return SendInfoMessage(playerid, 0, "", "El tele no existe");

	    IrTele(playerid, teleid);
		return 1;
	}
	// /TelePos [ID_Tele]
	else if (strcmp("/TelePos", cmdtext, true) == 0) return SendSyntaxError(playerid, "TelePos", "TelePos 12");
	else if (strfind(cmdtext, "/TelePos ", true) == 0)
	{
	    if (!PlayersData[playerid][Mapper]) return SendAccessError(playerid, "TelePos");
	    new teleid = -1;
	    if (sscanf(cmdtext[9], "i", teleid)) return SendSyntaxError(playerid, "TelePos", "TelePos 12");
	    if (teleid < 0 || teleid >= MAX_TELES_COUNT ) return SendInfoMessage(playerid, 0, "", "ID de Tele invalido");
	    if (Teles[teleid][PickupID] == 0) return SendInfoMessage(playerid, 0, "", "El tele no existe");

	    GetPlayerPos(playerid, Teles[teleid][PosX], Teles[teleid][PosY], Teles[teleid][PosZ]);
	    GetPlayerFacingAngle(playerid, Teles[teleid][PosZZ]);
	    Teles[teleid][World] = GetPlayerVirtualWorld(playerid);
		Teles[teleid][Interior] = GetPlayerInterior(playerid);
		SaveTele(teleid, true);

		new string[144]; format(string,sizeof(string), "Moviste el tele id %i a esta posicion.", teleid);
		SendAdviseMessage(playerid, string);
		return 1;
	}
	// /Borrar Tele
	else if (strcmp(cmdtext, "/Borrar Tele", true) == 0)
	{
	    if (!PlayersData[playerid][Mapper]) return SendAccessError(playerid, "Borrar Tele");

	    if (PlayersDataOnline[playerid][InPickupTele] == -1) return SendInfoMessage(playerid, 0, "", "No te encuentras en ningun tele");
	    new teleid = PlayersDataOnline[playerid][InPickupTele];

	    new string[144]; format(string,sizeof(string), "Borraste el tele id %i, estaba vinculado al tele %i.", teleid, Teles[teleid][PickupIDGo]);

		BorrarTele(teleid);
		SendInfoMessage(playerid, 3, "", string);
		return 1;
	}
	// /TeleP [Tipo_Propietario] [Propietario_ID]
	else if (strfind(cmdtext, "/TeleP", true) == 0)
	{
	    if (!PlayersData[playerid][Mapper]) return SendAccessError(playerid, "TeleP");

	    if(strfind(cmdtext, "/TeleP ", true) == 0)
	    {
	        new tipo, tipoid;
	        if (sscanf(cmdtext[7], "ii", tipo, tipoid))
			{
			 	SendSyntaxError(playerid, "TeleP", "TeleP 0 1");
				SendInfoMessage(playerid, 0, "", "Tipo de propietarios: {0: Faccion | 1: Negocio | 2: Casa}");
			    return 1;
	        }
	        if (tipo < 0 || tipo > 2) return SendInfoMessage(playerid, 0, "", "Tipo de propietarios: {0: Faccion | 1: Negocio | 2: Casa}");
	        switch (tipo)
	        {
	            case 0: if (tipoid < 0 || tipoid > MAX_FACCION) return SendInfoMessage(playerid, 0, "", "ID de Faccion Invalida");
	            case 1..2: if (tipoid <= 0) return SendInfoMessage(playerid, 0, "", "ID de Propiedad invalido.");
	        }
			if (PlayersDataOnline[playerid][InPickupTele] == -1) return SendInfoMessage(playerid, 0, "", "No te encuentras en ningun tele");
	    	new
				teleid = PlayersDataOnline[playerid][InPickupTele],
				teleidGo = Teles[teleid][PickupIDGo];

			if(Teles[teleid][IsGarage] && tipo == 2) return SendInfoMessage(playerid, 0, "", "No puedes asignar a este garage el tipo de propiedad casa!");

			AsignarTelePropietario(teleid, tipo, tipoid);

	        new string[144];
			if (tipo == 0) format(string,sizeof(string), "El tele %i y %i ahora tiene como llaves la faccion %s[%i]", teleid, teleidGo, FaccionData[tipoid][NameFaccion], tipoid);
	        else if (tipo == 1)
			{
				format(string,sizeof(string), "El tele %i y %i ahora tiene como llaves el negocio %i", teleid, teleidGo, tipoid);
				Teles[teleid][IsNegocioTele] = true;
	        }
	        else if (tipo == 2)
			{
				format(string,sizeof(string), "El tele %i y %i ahora tiene como llaves la casa %i", teleid, teleidGo, tipoid);
				Teles[teleid][IsCasaTele] = true;
	        }

	    	SendAdviseMessage(playerid, string);
	    }
	    else SendSyntaxError(playerid, "TeleP [Tipo_Propietario] [Propietario_ID]", "TeleP 0 1");
		return 1;
	}
	return 0;
}


OnTelesDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case 175:
		{
			if(!response) return 1;
			new teleid = PlayersDataOnline[playerid][SaveAfterAgenda][0];
			if(!Teles[teleid][PickupID]) return SendInfoMessage(playerid, 0, "", "El tele que quiere editar ya no existe!");

			new	teleidGo = Teles[teleid][PickupIDGo];
			if(listitem == 0){
				ShowEditTeleNombre(playerid, teleid);
			}
			else if(listitem == 1){
				ShowEditTeleNombre(playerid, teleidGo);
			}
			else if(listitem == 2)
			{
				ShowTeleUbicaciones(playerid, teleid);
			}
			else if(listitem == 3)
			{
				ShowTeleKeys(playerid, teleid);
			}
			else if(listitem == 4)
			{
				new string[128];
				format(string,sizeof(string), "Borraste el tele id %i, estaba vinculado al tele %i.", teleid, teleidGo);
				SendInfoMessage(playerid, 3, "", string);
				BorrarTele(teleid);
			}
			return 1;
		}
		case 176:
		{
			new teleEditing = PlayersDataOnline[playerid][SaveAfterAgenda][1];
			if(!Teles[teleEditing][PickupID]) return SendInfoMessage(playerid, 0, "", "El tele que estaba editando ya no existe!");
			if(response){
				if(strlen(inputtext) >= 2 && strlen(inputtext) <= 128){
					format(Teles[teleEditing][LugarText], 128, "%s", inputtext);
					SaveTele(teleEditing, true);
					new string[80];
					format(string, sizeof(string), "Cambiaste el nombre del tele %i!", teleEditing);
					SendAdviseMessage(playerid, string);
				}
				else{
					SendInfoMessage(playerid, 0, "", "El nombre debe tener minimo 4 y maximo 128 caracteres");
					ShowEditTeleNombre(playerid, teleEditing);
					return 1;
				}
			}
			ShowDialogEditTele(playerid, PlayersDataOnline[playerid][SaveAfterAgenda][0]);
			return 1;
		}
		case 177:
		{
			new teleid = PlayersDataOnline[playerid][SaveAfterAgenda][0];
			if(!Teles[teleid][PickupID]) return SendInfoMessage(playerid, 0, "", "El tele que estaba editando ya no existe!");
			if(response){
				new teleidGo = Teles[teleid][PickupIDGo];
				if(listitem == 0){
					if(Teles[teleid][IsGarage]){
						ShowTeleGarage(playerid, teleid);
						return 1;
					}
					else SendInfoMessage(playerid, 0, "", "Este tele no tiene garage");
				}
				else if(listitem >= 3 && listitem <= 8){
					ShowEditTeleUbicaciones(playerid, teleid, (listitem - 2));
					return 1;
				}
				else if(listitem == 9 || listitem == 18){
					new myVW = GetPlayerVirtualWorld(playerid), myInt = GetPlayerInterior(playerid),
					string[80], Float:PP[4]; GetPlayerPos(playerid, PP[0], PP[1], PP[2]); GetPlayerFacingAngle(playerid, PP[3]);
					if(listitem == 9){
						if(Teles[teleid][IsGarage] && (myVW != 0 || myInt != 0)){
							if(Teles[teleidGo][World] != 0 || Teles[teleidGo][Interior] != 0 )
							{
								SendInfoMessage(playerid, 0, "", "Este tele tiene configurado un garage, uno de los teles debe de llevar al exterior!");
								ShowTeleUbicaciones(playerid, teleid);
								return 1;
							}
						}
						Teles[teleid][PosX] = PP[0];
						Teles[teleid][PosY] = PP[1];
						Teles[teleid][PosZ] = PP[2];
						Teles[teleid][PosZZ] = PP[3];
						Teles[teleid][World] = myVW;
						Teles[teleid][Interior] = myInt;
					}
					else if(listitem == 18){
						if(Teles[teleid][IsGarage] && (myVW != 0 || myInt != 0)){
							if(Teles[teleid][World] != 0 || Teles[teleid][Interior] != 0 )
							{
								SendInfoMessage(playerid, 0, "", "Este tele tiene configurado un garage, uno de los teles debe de llevar al exterior!");
								ShowTeleUbicaciones(playerid, teleid);
								return 1;
							}
						}
						Teles[teleidGo][PosX] = PP[0];
						Teles[teleidGo][PosY] = PP[1];
						Teles[teleidGo][PosZ] = PP[2];
						Teles[teleidGo][PosZZ] = PP[3];
						Teles[teleidGo][World] = myVW;
						Teles[teleidGo][Interior] = myInt;
					}
					SaveTele(teleid, true);
					SaveTele(teleidGo, true);
					format(string, sizeof(string), "Moviste el tele %i de posicion!", (listitem == 9) ? (teleid) : (teleidGo));
					SendAdviseMessage(playerid, string);
				}
				ShowTeleUbicaciones(playerid, teleid);
			}
			return 1;
		}
		case 178:
		{
			new teleid = PlayersDataOnline[playerid][SaveAfterAgenda][0];
			if(!Teles[teleid][PickupID]) return SendInfoMessage(playerid, 0, "", "El tele que estaba editando ya no existe!");

			if(response){
				new g = Teles[teleid][Garage_ID];
				if(listitem >= 1 && listitem <= 4){
					ShowEditTeleGarage(playerid, teleid, 1, listitem);
					return 1;
				}
				else if(listitem == 5 || listitem == 12){
					new Float:PP[4]; GetPlayerPos(playerid, PP[0], PP[1], PP[2]); GetPlayerFacingAngle(playerid, PP[3]);
					new X = (listitem == 5) ? (GaragesEx[g][ID_Tele]) : (Teles[GaragesEx[g][ID_Tele]][PickupIDGo]);
					if(IsPointFromPoint(10.0, PP[0], PP[1], PP[2], Teles[X][PosX], Teles[X][PosY], Teles[X][PosZ]))
					{
						if(listitem == 5){
							GaragesEx[g][PosXOne] = PP[0];
							GaragesEx[g][PosYOne] = PP[1];
							GaragesEx[g][PosZOne] = PP[2];
							GaragesEx[g][PosZZOne] = PP[3];
						}
						else if(listitem == 12){
							GaragesEx[g][PosXTwo] = PP[0];
							GaragesEx[g][PosYTwo] = PP[1];
							GaragesEx[g][PosZTwo] = PP[2];
							GaragesEx[g][PosZZTwo] = PP[3];
						}
						SaveGarageEx(g);
						SendAdviseMessage(playerid, "Ubicacion del garage actualizada");
					}
					else SendInfoMessage(playerid, 0, "", "No te encuentras cerca del tele!");
				}
				else if(listitem >= 8 && listitem <= 11){
					ShowEditTeleGarage(playerid, teleid, 2, (listitem - 7));
					return 1;
				}
				else if(listitem == 14){
					Teles[GaragesEx[g][ID_Tele]][IsGarage] = 0;
					Teles[GaragesEx[g][ID_Tele]][Garage_ID] = -1;
					format(Teles[GaragesEx[g][ID_Tele]][LugarText], 20, "Desconocido");
					SaveTele(GaragesEx[g][ID_Tele], true);
					Teles[Teles[GaragesEx[g][ID_Tele]][PickupIDGo]][IsGarage] = 0;
					Teles[Teles[GaragesEx[g][ID_Tele]][PickupIDGo]][Garage_ID] = -1;
					format(Teles[Teles[GaragesEx[g][ID_Tele]][PickupIDGo]][LugarText], 20, "Desconocido");
					SaveTele(Teles[GaragesEx[g][ID_Tele]][PickupIDGo], true);
					GaragesEx[g][Creado] = 0;
					GaragesEx[g][ID_Tele] = -1;
					GaragesEx[g][PosXOne] = 0.0;
					GaragesEx[g][PosYOne] = 0.0;
					GaragesEx[g][PosZOne] = -3000.0;
					GaragesEx[g][PosZZOne] = 0.0;
					GaragesEx[g][PosXTwo] = 0.0;
					GaragesEx[g][PosYTwo] = 0.0;
					GaragesEx[g][PosZTwo] = -3000.0;
					GaragesEx[g][PosZZTwo] = 0.0;
					SaveGarageEx(g);
					SendInfoMessage(playerid, 3, "", "Garage Eliminado!");
					ShowTeleUbicaciones(playerid, teleid);
					return 1;
				}
				ShowTeleGarage(playerid, teleid);
			}
			else{
				ShowTeleUbicaciones(playerid, teleid);
			}
			return 1;
		}
		case 179:
		{
			new teleid = PlayersDataOnline[playerid][SaveAfterAgenda][0];
			if(!Teles[teleid][PickupID]) return SendInfoMessage(playerid, 0, "", "El tele que estaba editando ya no existe!");

			new OneOrTwo = PlayersDataOnline[playerid][SaveAfterAgenda][1];
			new option = PlayersDataOnline[playerid][SaveAfterAgenda][2];
			if(response){
				if(strlen(inputtext) >= 1){
					new g = Teles[teleid][Garage_ID];
					if(IsValidGarageEdit(teleid, g, OneOrTwo, option, floatstr(inputtext)))
					{
						if(option == 1){
							if(OneOrTwo == 1)
							GaragesEx[g][PosXOne] = floatstr(inputtext);
							else
							GaragesEx[g][PosXTwo] = floatstr(inputtext);
						}
						else if(option == 2){
							if(OneOrTwo == 1)
							GaragesEx[g][PosYOne] = floatstr(inputtext);
							else
							GaragesEx[g][PosYTwo] = floatstr(inputtext);
						}
						else if(option == 3){
							if(OneOrTwo == 1)
							GaragesEx[g][PosZOne] = floatstr(inputtext);
							else
							GaragesEx[g][PosZTwo] = floatstr(inputtext);
						}
						else if(option == 4){
							if(OneOrTwo == 1)
							GaragesEx[g][PosZZOne] = floatstr(inputtext);
							else
							GaragesEx[g][PosZZTwo] = floatstr(inputtext);
						}
						SaveGarageEx(g);
						SendAdviseMessage(playerid, "Ubicacion del garage actualizada");
					}
					else SendInfoMessage(playerid, 0, "", "La coordenada ingresada se aleja demasiado del tele!");
				}
				else{
					ShowEditTeleGarage(playerid, teleid, OneOrTwo, option);
					return 1;
				}
			}
			ShowTeleGarage(playerid, teleid);
			return 1;
		}
		case 180:
		{
			new teleid = PlayersDataOnline[playerid][SaveAfterAgenda][0];
			if(!Teles[teleid][PickupID]) return SendInfoMessage(playerid, 0, "", "El tele que estaba editando ya no existe!");

			new teleEditing = PlayersDataOnline[playerid][SaveAfterAgenda][1];
			new option = PlayersDataOnline[playerid][SaveAfterAgenda][2];
			if(response){
				if(strlen(inputtext) >= 1){
					if(option == 5 || option == 6){
						if(strval(inputtext) != 0 && Teles[teleEditing][IsGarage]){
							new teleidGo = Teles[teleEditing][PickupIDGo];
							if(Teles[teleidGo][World] != 0 || Teles[teleidGo][Interior] != 0){
								SendInfoMessage(playerid, 0, "", "Este tele tiene configurado un garage, uno de los teles debe de llevar al exterior!");
								ShowEditTeleUbicaciones(playerid, teleEditing, option);
								return 1;
							}
						}
					}
					if(option == 1)
					Teles[teleEditing][PosX] = floatstr(inputtext);
					else if(option == 2)
					Teles[teleEditing][PosY] = floatstr(inputtext);
					else if(option == 3)
					Teles[teleEditing][PosZ] = floatstr(inputtext);
					else if(option == 4)
					Teles[teleEditing][PosZZ] = floatstr(inputtext);
					else if(option == 5)
					Teles[teleEditing][World] = strval(inputtext);
					else if(option == 6)
					Teles[teleEditing][Interior] = strval(inputtext);
					SaveTele(teleEditing, true);
				}
				else{
					ShowEditTeleUbicaciones(playerid, teleEditing, option);
					return 1;
				}
			}
			ShowTeleUbicaciones(playerid, teleid);
			return 1;
		}
		case 181:
		{
			new teleid = PlayersDataOnline[playerid][SaveAfterAgenda][0];
			if(!Teles[teleid][PickupID]) return SendInfoMessage(playerid, 0, "", "El tele que estaba editando ya no existe!");
			if(response){
				new	teleidGo = Teles[teleid][PickupIDGo];
				if(listitem == 0){
					if(Teles[teleid][IsGarage]){
						Teles[teleid][DuenoType] = (Teles[teleid][DuenoType] == 1) ? (0) : (Teles[teleid][DuenoType] + 1);
						Teles[teleidGo][DuenoType] = (Teles[teleidGo][DuenoType] == 1) ? (0) : (Teles[teleidGo][DuenoType] + 1);
					}
					else{
						Teles[teleid][DuenoType] = (Teles[teleid][DuenoType] == 2) ? (0) : (Teles[teleid][DuenoType] + 1);
						Teles[teleidGo][DuenoType] = (Teles[teleidGo][DuenoType] == 2) ? (0) : (Teles[teleidGo][DuenoType] + 1);
					}
					Teles[teleid][IsNegocioTele] = false;
					Teles[teleid][IsCasaTele] = false;
					Teles[teleidGo][IsNegocioTele] = false;
					Teles[teleidGo][IsCasaTele] = false;
					if(!Teles[teleidGo][DuenoType])
					{
						Teles[teleid][Dueno] = 0;
						Teles[teleidGo][Dueno] = 0;
					}
					else if(Teles[teleidGo][DuenoType] == 1){
						Teles[teleid][IsNegocioTele] = true;
						Teles[teleidGo][IsNegocioTele] = true;
						Teles[teleid][Dueno] = 1;
						Teles[teleidGo][Dueno] = 1;
					}
					else if(Teles[teleidGo][DuenoType] == 2){
						Teles[teleid][IsCasaTele] = true;
						Teles[teleidGo][IsCasaTele] = true;
						Teles[teleid][Dueno] = 1;
						Teles[teleidGo][Dueno] = 1;
					}
					SaveTele(teleid, false);
					SaveTele(teleidGo, false);
				}
				else if(listitem == 1){
					ShowEditTeleKeys(playerid, teleid);
					return 1;
				}
				ShowTeleKeys(playerid, teleid);
			}
			else ShowDialogEditTele(playerid, teleid);
			return 1;
		}
		case 182:
		{
			new teleid = PlayersDataOnline[playerid][SaveAfterAgenda][0];
			if(!Teles[teleid][PickupID]) return SendInfoMessage(playerid, 0, "", "El tele que estaba editando ya no existe!");
			if(response){
				if(strlen(inputtext) >= 1){
					new new_id = (Teles[teleid][DuenoType] == 0) ? (GetFaccionByName(inputtext)) : (strval(inputtext));
					if(Teles[teleid][DuenoType] == 0 && (new_id < 0 || new_id > MAX_FACCION)) SendInfoMessage(playerid, 0, "", "ID de Faccion invalida");
					else if(Teles[teleid][DuenoType] == 1 && (new_id < 1 || new_id >= MAX_BIZZ_COUNT)) SendInfoMessage(playerid, 0, "", "ID de Negocio invalida");
					else if(Teles[teleid][DuenoType] == 2 && (new_id < 1 || new_id >= MAX_HOUSE_COUNT)) SendInfoMessage(playerid, 0, "", "ID de Casa invalida");
					else{
						new	teleidGo = Teles[teleid][PickupIDGo];
						Teles[teleid][Dueno] = new_id;
						Teles[teleidGo][Dueno] = new_id;
						SaveTele(teleid, false);
						SaveTele(teleidGo, false);
						ShowTeleKeys(playerid, teleid);
						return 1;
					}
				}
				ShowEditTeleKeys(playerid, teleid);
			}
			else ShowTeleKeys(playerid, teleid);
			return 1;
		}
	}
	return 0;
}


