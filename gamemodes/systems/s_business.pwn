
//Precios productos
new const M24_7_Precios[8] =
{
	150,//Patines
	60,//Dados
	100,//Agenda
	50,//Flores
    2,//Saldo
	150,//Bolsa
	80,//Condones
	150//Maleta
};

new const PreciosElectronica[5] = {
	200,//Camara de Fotos
	300,//Movil
	200,//Modelo de Moviles
	100,//Agenda
	1,//Saldo
};

new const PreciosPolleria[4] = {
	20,
	30,
	50,
	60
};

new const PreciosHamburgseria[4] = {
	20,
	30,
	50,
	60
};

new const PreciosPizzeria[3] = {
	5,
	40,
	60
};

new const PreciosDonuteria[3] = {
	20,
	45,
	55
};

new const PreciosRestaurante[8] = {
	5,
	3,
	10,
	60,
	20,
	50,
	60,
	40
};
//Precios productos end

SaveDataBizzModel(typeid, id)
{
	if(!NegociosModelos[typeid][id][InteriorId]) return false;

	new query[1000], Cache:cacheid, bizzTypeExists;
	mysql_format(dataBase, query, 1000, "SELECT * FROM `%s` WHERE TypeOfBizz=%i AND Model_ID=%i;", DIR_NEGOCIOS_TYPE, typeid, id);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(bizzTypeExists);
	cache_delete(cacheid);

	if (!bizzTypeExists)
	{
		mysql_format(dataBase, query, 100, "INSERT INTO `%s` (`TypeOfBizz`,`Model_ID`) VALUES ('%i','%i');", DIR_NEGOCIOS_TYPE, typeid, id);
		mysql_query(dataBase, query, false);
	}

	format(query, sizeof(query), "UPDATE %s SET ", DIR_NEGOCIOS_TYPE);
	strcat(query, "`PosInX`='%f',`PosInY`='%f',`PosInZ`='%f',`PosInZZ`='%f',`PosInX_PC`='%f',");
	strcat(query, "`PosInY_PC`='%f',`PosInZ_PC`='%f',`InteriorId`='%d',`TypeName`='%e'");
	strcat(query, " WHERE TypeOfBizz=%i AND Model_ID=%i;");
	mysql_format(dataBase, query, sizeof(query), query, 
		NegociosModelos[typeid][id][PosInX],	 
		NegociosModelos[typeid][id][PosInY],    
		NegociosModelos[typeid][id][PosInZ],    
		NegociosModelos[typeid][id][PosInZZ],   
		NegociosModelos[typeid][id][PosInX_PC],
		NegociosModelos[typeid][id][PosInY_PC], 
		NegociosModelos[typeid][id][PosInZ_PC],
		NegociosModelos[typeid][id][InteriorId],
		NegociosModelos[typeid][id][TypeName],
		typeid, id);
	mysql_query(dataBase, query, false);
	return true;
}

forward CreateModeloNegocioDynamicPickup(negociotipo, negociomodelo, Float:x, Float:y, Float:z);

LoadDataBizzType()
{
	new query[100], Cache:cacheid, count;
	for(new TypeOfBizz; TypeOfBizz!=MAX_BIZZ_TYPE_COUNT; TypeOfBizz++){
		format(query, sizeof(query), "SELECT * FROM `%s` WHERE TypeOfBizz=%i;", DIR_NEGOCIOS_TYPE, TypeOfBizz);
		cacheid = mysql_query(dataBase, query);
		cache_get_row_count(count);
		if ( count )
		{
			for(new id; id!=count; id++){
				cache_get_value_name_float(id, "PosInX", NegociosModelos[TypeOfBizz][id][PosInX]);	 
				cache_get_value_name_float(id, "PosInY", NegociosModelos[TypeOfBizz][id][PosInY]);    
				cache_get_value_name_float(id, "PosInZ", NegociosModelos[TypeOfBizz][id][PosInZ]);    
				cache_get_value_name_float(id, "PosInZZ", NegociosModelos[TypeOfBizz][id][PosInZZ]);   
				cache_get_value_name_float(id, "PosInX_PC", NegociosModelos[TypeOfBizz][id][PosInX_PC]);
				cache_get_value_name_float(id, "PosInY_PC", NegociosModelos[TypeOfBizz][id][PosInY_PC]); 
				cache_get_value_name_float(id, "PosInZ_PC", NegociosModelos[TypeOfBizz][id][PosInZ_PC]);
				cache_get_value_name_int(id, "InteriorId", NegociosModelos[TypeOfBizz][id][InteriorId]);
				cache_get_value_name(id, "TypeName", NegociosModelos[TypeOfBizz][id][TypeName], MAX_PLAYER_NAME);

				if(NegociosModelos[TypeOfBizz][id][InteriorId]) NegociosModelos[TypeOfBizz][id][PickupId] = CreateModeloNegocioDynamicPickup(TypeOfBizz, id, NegociosModelos[TypeOfBizz][id][PosInX], NegociosModelos[TypeOfBizz][id][PosInY], NegociosModelos[TypeOfBizz][id][PosInZ]);
			}
			printf("[%s]: Se cargaron %i %s (MAX: %i)", DIR_NEGOCIOS_TYPE, count, NegociosTipo[TypeOfBizz], MAX_BIZZ_MODELS_BY_TYPE);
		}
		else printf("[%s]: No se encontraron modelos de negocios para %s", DIR_NEGOCIOS_TYPE, NegociosTipo[TypeOfBizz]);
		cache_delete(cacheid);
	}
	return true;
}

DataSaveBizz(bizzid, bool:update)
{
	new query[1000], Cache:cacheid, negocioExiste;
	mysql_format(dataBase, query, 100, "SELECT * FROM `%s` WHERE `ID`='%i';", DIR_NEGOCIOS, bizzid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(negocioExiste);
	cache_delete(cacheid);

	if (!negocioExiste && NegociosData[bizzid][Type])
	{
		mysql_format(dataBase, query, 100, "INSERT INTO `%s` (`ID`) VALUES ('%i');", "negocios", bizzid);
		mysql_query(dataBase, query, false);
		negocioExiste = true;
	}

	if(negocioExiste){
		format(query, 100, "UPDATE `%s` SET ", DIR_NEGOCIOS);
		strcat(query, "`PosOutX`='%f',`PosOutY`='%f',`PosOutZ`='%f',`PosOutZZ`='%f',`Type`='%i',`Deposito`='%i',`Precio`='%i',`Seguro`='%i',`NModel`='%i',`PriceJoin`='%i',");
		strcat(query, "`PricePiece`='%i',`NameBizz`='%e',`Dueno`='%e',`Extorsion`='%e',`Materiales`='%i',`DepositoExtorsion`='%i',`Empty0`='%i',");
		strcat(query, "`PosInX_PC`='%f',`PosInY_PC`='%f',`PosInZ_PC`='%f'");
		strcat(query, " WHERE `ID`='%i';");
		mysql_format(dataBase, query, 1000, query,
			NegociosData[bizzid][PosOutX],
			NegociosData[bizzid][PosOutY],
			NegociosData[bizzid][PosOutZ],
			NegociosData[bizzid][PosOutZZ],
			NegociosData[bizzid][Type],
			NegociosData[bizzid][Deposito],
			NegociosData[bizzid][Precio],
			NegociosData[bizzid][Lock],
			NegociosData[bizzid][NModel],
			NegociosData[bizzid][PriceJoin],

			NegociosData[bizzid][PricePiece],
			NegociosData[bizzid][NameBizz],
			NegociosData[bizzid][Dueno],
			NegociosData[bizzid][Extorsion],
			NegociosData[bizzid][Materiales],
			NegociosData[bizzid][DepositoExtorsion],
			NegociosData[bizzid][Empty0],

			NegociosData[bizzid][PosInX_PC],
			NegociosData[bizzid][PosInY_PC],
			NegociosData[bizzid][PosInZ_PC],
			bizzid);
		mysql_query(dataBase, query, false);
	}

	if ( update )
	{
		UpdateTextLabelNegocio(bizzid);
		UpdatePickupNegocio(bizzid);
	}
}

DataLoadBizz(bizzid)
{
	new query[1000], Cache:cacheid, negocioExiste;
	mysql_format(dataBase, query, 100, "SELECT * FROM `%s` WHERE `ID`='%i';", DIR_NEGOCIOS, bizzid);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(negocioExiste);

	if ( negocioExiste )
	{
	    cache_get_value_name_int(0, "Type", NegociosData[bizzid][Type]);
		if(NegociosData[bizzid][Type])
		{
			cache_get_value_name_float(0, "PosOutX", NegociosData[bizzid][PosOutX]);
			cache_get_value_name_float(0, "PosOutY", NegociosData[bizzid][PosOutY]);
			cache_get_value_name_float(0, "PosOutZ", NegociosData[bizzid][PosOutZ]);
			cache_get_value_name_float(0, "PosOutZZ", NegociosData[bizzid][PosOutZZ]);
			cache_get_value_name_int(0, "Deposito", NegociosData[bizzid][Deposito]);
			cache_get_value_name_int(0, "Precio", NegociosData[bizzid][Precio]);
			cache_get_value_name_int(0, "Seguro", NegociosData[bizzid][Lock]);
			cache_get_value_name_int(0, "NModel", NegociosData[bizzid][NModel]);
			cache_get_value_name_int(0, "PriceJoin", NegociosData[bizzid][PriceJoin]);
			cache_get_value_name_int(0, "PricePiece", NegociosData[bizzid][PricePiece]);
			cache_get_value_name(0, "NameBizz", NegociosData[bizzid][NameBizz],   MAX_BIIZ_NAME);
			cache_get_value_name(0, "Dueno", NegociosData[bizzid][Dueno],		  MAX_PLAYER_NAME);
			cache_get_value_name(0, "Extorsion", NegociosData[bizzid][Extorsion], MAX_PLAYER_NAME);
			cache_get_value_name_int(0, "Materiales", NegociosData[bizzid][Materiales]);
			cache_get_value_name_int(0, "DepositoExtorsion", NegociosData[bizzid][DepositoExtorsion]);
			cache_get_value_name_int(0, "Empty0", NegociosData[bizzid][Empty0]);
			cache_get_value_name_float(0, "PosInX_PC", NegociosData[bizzid][PosInX_PC]);
			cache_get_value_name_float(0, "PosInY_PC", NegociosData[bizzid][PosInY_PC]);
			cache_get_value_name_float(0, "PosInZ_PC", NegociosData[bizzid][PosInZ_PC]);

			NegociosData[bizzid][World] = bizzid;

			UpdateTextLabelNegocio(bizzid);
			UpdatePickupNegocio(bizzid);
		}
	}
	cache_delete(cacheid);
	return negocioExiste;
}

ChangeBizzName(playerid, bizzid, const cmdtext[])
{
	if( PlayersData[playerid][Admin] >= 8 || IsMyBizz(playerid, bizzid, true)  )
	{
		if( !IsBizzOnRobo(playerid, bizzid) )
		{
			if( strlen(cmdtext) > 16 )
			{	
				if( strlen(cmdtext[16]) >= 2 && strlen(cmdtext[16]) <= 80 )
				{
					if( IsValidStringServerOther(playerid, cmdtext) )
					{
						format(NegociosData[bizzid][NameBizz], 	MAX_BIIZ_NAME, "%s", ConvertToRGBColor(cmdtext[16]));
						DataSaveBizz(bizzid, true);
						Importante(playerid, "Has modificado el nombre del negocio");
					}
				}
				else Error(playerid, "El nombre de su negocio tiene que ser mayor de 2 y menos de 80 caracteres"); 
			}
			else SendSyntaxError(playerid, "Cambiar Nombre [Nombre]", "Cambiar Nombre Hola Mundo");
		}
	}
}

GetMyNextBizz()
{
	for (new i = 1; i < MAX_BIZZ_COUNT; i++)
	{
		if(!NegociosData[i][Type]) return i;
	}
	return false;
}

UpdateTextLabelNegocio(bizzid)
{
	new TextLabelText[400];
	if( strlen(NegociosData[bizzid][Dueno]) > 1 )
	{
		format(TextLabelText, sizeof(TextLabelText), "%s\n\n\
		{"COLOR_AZUL"}Lugar: {"COLOR_CREMA"}Negocio PN-%i\n\
		{"COLOR_VERDE"}Tipo: {"COLOR_CREMA"}%s\n\
		{"COLOR_VERDE"}Socio: {"COLOR_CREMA"}%s\n",
		NegociosData[bizzid][NameBizz],
		bizzid,
		NegociosTipo[NegociosData[bizzid][Type]-1],
		NegociosData[bizzid][Extorsion]);
		if( NegociosData[bizzid][Type] == BIZZ_TYPE_DISCOTECA ||
			NegociosData[bizzid][Type] == BIZZ_TYPE_CASINO )
		{
			format(TextLabelText, sizeof(TextLabelText), "%s\
			{"COLOR_VERDE"}Entrada: {"COLOR_CREMA"}$%d\n", TextLabelText, NegociosData[bizzid][PriceJoin]);
		}
	}
	else{
		format(TextLabelText, sizeof(TextLabelText), "\
		{"COLOR_AZUL"}Lugar: {"COLOR_CREMA"}Negocio PN-%i\n\
		{"COLOR_VERDE"}Tipo: {"COLOR_CREMA"}%s\n",
		bizzid,
		NegociosTipo[NegociosData[bizzid][Type]-1]);

		if( NegociosData[bizzid][Type] == BIZZ_TYPE_DISCOTECA || 
			NegociosData[bizzid][Type] == BIZZ_TYPE_CASINO )
		format(TextLabelText, sizeof(TextLabelText), "%s{"COLOR_VERDE"}Entrada: {"COLOR_CREMA"}$%d\n", TextLabelText, NegociosData[bizzid][PriceJoin]);

		format(TextLabelText, sizeof(TextLabelText), "%s\
		{"COLOR_VERDE"}Precio: {"COLOR_CREMA"}$%i\n\
		{"COLOR_VERDE"}Use {"COLOR_ROJO"}/Comprar Negocio",
		TextLabelText, NegociosData[bizzid][Precio]);
	}
	if (IsValidDynamic3DTextLabel(NegociosData[bizzid][TextLabel])) DestroyDynamic3DTextLabel(NegociosData[bizzid][TextLabel]);

	NegociosData[bizzid][TextLabel] = CreateDynamic3DTextLabel(TextLabelText, 0xFFFFFFFF, NegociosData[bizzid][PosOutX], NegociosData[bizzid][PosOutY], NegociosData[bizzid][PosOutZ],
	10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, -1, 0);
}

UpdatePickupNegocio(bizzid){
	new pickupid = NegociosData[bizzid][PickupOutId];
	if(IsValidDynamicPickup(pickupid)){
		DestroyDynamicPickup(pickupid);
		PickupIndex[pickupid][Tipo] = PICKUP_TYPE_NINGUNO;
		PickupIndex[pickupid][Tipoid] = 0;
	}
	pickupid = CreateDynamicPickup(PICKUP_MODEL_BIZZ, 1, NegociosData[bizzid][PosOutX], NegociosData[bizzid][PosOutY], NegociosData[bizzid][PosOutZ], WORLD_NORMAL, 0, -1, MAX_BIZZ_PICKUP_DISTANCE);
	PickupIndex[pickupid][Tipo] = PICKUP_TYPE_NEGOCIO;
	PickupIndex[pickupid][Tipoid] = bizzid;
	NegociosData[bizzid][PickupOutId] = pickupid;
}

SetFunctionsForBizz(playerid, bizzid)
{
	if(NegociosData[bizzid][PosInX_PC]) SetPlayerCheckpoint(playerid, NegociosData[bizzid][PosInX_PC], NegociosData[bizzid][PosInY_PC], NegociosData[bizzid][PosInZ_PC], 1.0);
}

IsMyExtorsion(playerid, bizzid)
{
    if ( strfind(NegociosData[bizzid][Extorsion], PlayersDataOnline[playerid][NameOnline], false) == 0 && strlen(NegociosData[bizzid][Extorsion]) == strlen(PlayersDataOnline[playerid][NameOnline]) )
	{
	    return true;
    }
    else
    {
		return false;
	}
}

IsMyBizz(playerid, bizzid, msg)
{
	if (PlayersData[playerid][Negocio] == bizzid && bizzid)
	{
	    return true;
    }
    else
    {
		if ( msg )
		{
			Error(playerid, "Este negocio no es suyo");
		}
		return false;
	}
}

SetMoneyExtorsion(bizzid, money)
{
    if( strlen(NegociosData[bizzid][Extorsion]) > 2 )//Extorsionista se lleva 20 % de ganancias
    {
		NegociosData[bizzid][DepositoExtorsion] = NegociosData[bizzid][DepositoExtorsion] + (money / 5);
	    NegociosData[bizzid][Deposito] = NegociosData[bizzid][Deposito] + (money - (money / 5) );
    }
    else
    {
        NegociosData[bizzid][Deposito] = NegociosData[bizzid][Deposito] + money;
	}
	NegociosData[bizzid][Materiales] -= 2;
}

RemoveDuenoOfBizz(bizzid)
{
	NegociosData[bizzid][Lock] = true;
    format(NegociosData[bizzid][Dueno], MAX_PLAYER_NAME, "0");
    format(NegociosData[bizzid][Extorsion], MAX_PLAYER_NAME, "No");
    DataSaveBizz(bizzid, true);
	for(new i,j=GetPlayerPoolSize(); i<=j; i++){
		if(PlayersData[i][Negocio] == bizzid){
			PlayersData[i][Negocio] = 0;
			DataUserSave(i);
			break;
		}
	}
	new query[128];
	mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET Negocio=0 WHERE Negocio=%d;", DIR_USERS, bizzid);
	mysql_query(dataBase, query, false);
}

ShowBizzTypes(playerid)
{
	new string[128];
	Ayuda(playerid, "Tipos de Negocio:");
	for( new i; i!=MAX_BIZZ_TYPE_COUNT; i++ ){
		if( (strlen(string) + strlen(NegociosTipo[i]) + 14) > sizeof(string) ){
			Ayuda(playerid, string);
			format(string, sizeof(string), "");
		}
		format(string, sizeof(string), "%sTipo %d: \"%s\" | ", string, i+1, NegociosTipo[i]);
	}
	Ayuda(playerid, string);
	return 1;
}

ShowBizzModels(playerid)
{
	new string[128];
	Ayuda(playerid, "Modelos de negocios:");
	for( new i; i!=MAX_BIZZ_TYPE_COUNT; i++ ){
		format(string, sizeof(string), "Tipo %d[%s]: ", i+1, NegociosTipo[i]);
		for( new x; x!=MAX_BIZZ_MODELS_BY_TYPE; x++ ){
			if( NegociosModelos[i][x][InteriorId] ){
				if( (strlen(string) + strlen(NegociosModelos[i][x][TypeName]) + 7) > sizeof(string) ){
					Ayuda(playerid, string);
					format(string, sizeof(string), "— ", i+1, NegociosTipo[i]);
				}
				format(string, sizeof(string), "%s%s(%d) | ", string, NegociosModelos[i][x][TypeName], x+1);
			}
		}
		Ayuda(playerid, string);
	}
	return 1;
}

ShowBizzModelsOfType(playerid, type)
{
	new string[128];
	Ayuda(playerid, "Modelos de Negocio Tipo %s(%d):", NegociosTipo[type], type + 1);
	for( new x; x!=MAX_BIZZ_MODELS_BY_TYPE; x++ ){
		if( NegociosModelos[type][x][InteriorId] ){
			if( (strlen(string) + strlen(NegociosModelos[type][x][TypeName]) + 7) > sizeof(string) ){
				Ayuda(playerid, string);
				format(string, sizeof(string), "— ");
			}
			format(string, sizeof(string), "%s%s(%d) | ", string, NegociosModelos[type][x][TypeName], x + 1);
		}
	}
	Ayuda(playerid, string);
	return 1;
}

GetNextBizzModelID(playerid, typeid, &id)
{
	id = -1;
	for( new i; i!=MAX_BIZZ_MODELS_BY_TYPE; i++ ){
		if( !NegociosModelos[typeid][i][InteriorId] ){
			id = i;
			break;
		}
	}
	if(id == -1){
		if(playerid != -1) Error(playerid, "Se alcanzo el maximo de modelos (%d) para el tipo de negocio %s[%d]!", MAX_BIZZ_MODELS_BY_TYPE, NegociosTipo[typeid], typeid);
		return false;
	}
	return true;
}

GetMaxBizzModelsByType(type)
{
	new maxID = -1;
	for( new i; i!=MAX_BIZZ_MODELS_BY_TYPE; i++ ){
		if( NegociosModelos[type][i][InteriorId] )
		maxID = i;
	}
	return maxID;
}

ShowPlayerBizzTypesModels(playerid, bizzType, bizzModel)
{
	PlayersDataOnline[playerid][SaveAfterAgenda][0] = bizzType;
	PlayersDataOnline[playerid][SaveAfterAgenda][1] = bizzModel;

	new caption[64], info[1024];
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Modelo %s[%d] - Tipo %s[%d]", NegociosModelos[bizzType][bizzModel][TypeName], bizzModel+1, NegociosTipo[bizzType], bizzType+1);
	strcat(info, "Nombre\t{"COLOR_VERDE"}Editar\n");
	strcat(info, "Pickup\t{"COLOR_VERDE"}Editar\n");
	strcat(info, "Checkpoint\t{"COLOR_VERDE"}Editar\n");
	strcat(info, "{"COLOR_ROJO"}Eliminar\t");
	ShowPlayerDialogEx(playerid, 154, DIALOG_STYLE_TABLIST, caption, info, "Aceptar", "Cerrar");
}

ShowPlayerBizzTypesModelsOptions(playerid, bizzType, bizzModel, option)
{
	PlayersDataOnline[playerid][SaveAfterAgenda][2] = option;

	new caption[64], info[1024];
	new OptionText[4][20] = {"Nombre", "Pickup", "CheckPoint","Eliminar"};
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Modelo %s[%d] - %s", NegociosModelos[bizzType][bizzModel][TypeName], bizzModel+1, OptionText[option]);
	if(option == 0){
		strcat(info, "{"COLOR_CREMA"}Nuevo nombre de modelo de negocio:");
		ShowPlayerDialogEx(playerid, 155, DIALOG_STYLE_INPUT, caption, info, "Renombrar", "Cancelar");
		return 1;
	}
	else if(option == 1){
		format(info, sizeof(info), "Coordenada X: %.2f\t{"COLOR_VERDE"}Cambiar\n", NegociosModelos[bizzType][bizzModel][PosInX]);
		format(info, sizeof(info), "%sCoordenada Y: %.2f\t{"COLOR_VERDE"}Cambiar\n", info, NegociosModelos[bizzType][bizzModel][PosInY]);
		format(info, sizeof(info), "%sCoordenada Z: %.2f\t{"COLOR_VERDE"}Cambiar\n", info, NegociosModelos[bizzType][bizzModel][PosInZ]);
		format(info, sizeof(info), "%sCoordenada ZZ: %.2f\t{"COLOR_VERDE"}Cambiar\n", info, NegociosModelos[bizzType][bizzModel][PosInZZ]);
		format(info, sizeof(info), "%sInterior: %i\t{"COLOR_VERDE"}Cambiar\n", info, NegociosModelos[bizzType][bizzModel][InteriorId]);
		strcat(info, "Ubicacion\t{"COLOR_VERDE"}Mover Aqui\n");
	}
	else if(option == 2){
		format(info, sizeof(info), "Coordenada X: %.2f\t{"COLOR_VERDE"}Cambiar\n", NegociosModelos[bizzType][bizzModel][PosInX_PC]);
		format(info, sizeof(info), "%sCoordenada Y: %.2f\t{"COLOR_VERDE"}Cambiar\n", info, NegociosModelos[bizzType][bizzModel][PosInY_PC]);
		format(info, sizeof(info), "%sCoordenada Z: %.2f\t{"COLOR_VERDE"}Cambiar\n", info, NegociosModelos[bizzType][bizzModel][PosInZ_PC]);
		strcat(info, "Ubicacion\t{"COLOR_VERDE"}Mover Aqui\n");
	}
	else if(option == 3){
		ShowPlayerDialogEx(playerid, 155, DIALOG_STYLE_MSGBOX, caption, "ACCION PELIGROSA!!!!\nEsta seguro que desea eliminar este interior?", "{"COLOR_ROJO"}Eliminar", "Cancelar");
		return 1;
	}
	ShowPlayerDialogEx(playerid, 155, DIALOG_STYLE_TABLIST, caption, info, "Aceptar", "Volver");
	return 1;
}

ShowBizzModelsOptsSub(playerid, bizzType, bizzModel, PickupOrCheck, listitem)
{
	PlayersDataOnline[playerid][SaveAfterAgenda][2] = listitem;
	PlayersDataOnline[playerid][SaveAfterAgenda][3] = PickupOrCheck;

	new caption[64], info[1024];
	new PickupOrCheckText[2][20] = {"Pickup", "CheckPoint"};
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Modelo %s[%d] - %s", NegociosModelos[bizzType][bizzModel][TypeName], bizzModel+1, PickupOrCheckText[PickupOrCheck]);
	if(PickupOrCheck == 0){//Pickup
		if(listitem >= 0 && listitem <= 3){
			format(info, sizeof(info), "Ingrese la nueva coordenada");
		}
		else if(listitem == 4){
			format(info, sizeof(info), "Ingrese el nuevo interior_id");
		}
		else if(listitem == 5){
			new getInt = GetPlayerInterior(playerid);
			if(!getInt) return Error(playerid, "Debes estar en un interior para usar este comando.");
			new Float:PP[4]; GetPlayerPos(playerid, PP[0], PP[1], PP[2]), GetPlayerFacingAngle(playerid, PP[3]);
			ImportanteEx(playerid, "Moviste el Pickup del interior de negocios %s[%d] a tu ubicacion: %.2f %.2f %.2f %.2f Interior %d", NegociosModelos[bizzType][bizzModel][TypeName], bizzModel+1, PP[0], PP[1], PP[2], PP[3], getInt);
			NegociosModelos[bizzType][bizzModel][PosInX] = PP[0];
			NegociosModelos[bizzType][bizzModel][PosInY] = PP[1];
			NegociosModelos[bizzType][bizzModel][PosInZ] = PP[2];
			NegociosModelos[bizzType][bizzModel][PosInZZ] = PP[3];
			NegociosModelos[bizzType][bizzModel][InteriorId] = getInt;
			ShowPlayerBizzTypesModelsOptions(playerid, bizzType, bizzModel, 1);

			UpdateBizzTypeModelPickup(bizzType, bizzModel);
			SaveDataBizzModel(bizzType, bizzModel);
			return 1;
		}
	}
	else if(PickupOrCheck == 1){//CheckPoint
		if(listitem >= 0 && listitem <= 2){
			format(info, sizeof(info), "Ingrese la nueva coordenada");
		}
		else if(listitem == 3){
			if(GetPlayerInterior(playerid) != NegociosModelos[bizzType][bizzModel][InteriorId]) return Error(playerid, "Debes estar en el interior del negocio para ajustar el CheckPoint!");
			new Float:PP[3]; GetPlayerPos(playerid, PP[0], PP[1], PP[2]);
			ImportanteEx(playerid, "Moviste el CheckPoint del interior de negocios %s[%d] a tu ubicacion: %.2f %.2f %.2f", NegociosModelos[bizzType][bizzModel][TypeName], bizzModel+1, PP[0], PP[1], PP[2]);
			NegociosModelos[bizzType][bizzModel][PosInX_PC] = PP[0];
			NegociosModelos[bizzType][bizzModel][PosInY_PC] = PP[1];
			NegociosModelos[bizzType][bizzModel][PosInZ_PC] = PP[2];
			ShowPlayerBizzTypesModelsOptions(playerid, bizzType, bizzModel, 2);
			UpdateAllBizzModelCheckPoint(playerid, bizzType, bizzModel);
			
			SaveDataBizzModel(bizzType, bizzModel);
			return 1;
		}
	}
	ShowPlayerDialogEx(playerid, 167, DIALOG_STYLE_INPUT, caption, info, "Cambiar", "Cancelar");
	return 1;
}

UpdateBizzTypeModelPickup(bizzType, bizzModel)
{
	new pickupid = NegociosModelos[bizzType][bizzModel][PickupId];
	PickupIndex[pickupid][Tipo] = PICKUP_TYPE_NINGUNO;
	PickupIndex[pickupid][Tipoid] = 0;
	PickupIndex[pickupid][Tipoidextra] = 0;
	if(IsValidDynamicPickup(pickupid)) DestroyDynamicPickup(pickupid);
	
	NegociosModelos[bizzType][bizzModel][PickupId] = CreateModeloNegocioDynamicPickup(bizzType, bizzModel, NegociosModelos[bizzType][bizzModel][PosInX], NegociosModelos[bizzType][bizzModel][PosInY], NegociosModelos[bizzType][bizzModel][PosInZ]);
}

CreateModeloNegocioDynamicPickup(negociotipo, negociomodelo, Float:x, Float:y, Float:z)
{
    new pickupid = CreateDynamicPickup(PICKUP_MODEL_BIZZ, 1, x, y, z, -1, NegociosModelos[negociotipo][negociomodelo][InteriorId], -1, 50.0);
    PickupIndex[pickupid][Tipo] = PICKUP_TYPE_NEGOCIO_TYPE;
	PickupIndex[pickupid][Tipoid] = negociotipo;
	PickupIndex[pickupid][Tipoidextra] = negociomodelo;
	return pickupid;
}

BorrarNegocio(bizzid)
{
	DestroyDynamicPickup(NegociosData[bizzid][PickupOutId]);
	PickupIndex[NegociosData[bizzid][PickupOutId]][Tipo] = PICKUP_TYPE_NINGUNO;
	PickupIndex[NegociosData[bizzid][PickupOutId]][Tipoid] = 0;
	NegociosData[bizzid][PickupOutId] = 0;

	DestroyDynamic3DTextLabel(NegociosData[bizzid][TextLabel]);
	NegociosData[bizzid][TextLabel] = INVALID_3DTEXT_ID;

	if(strlen(NegociosData[bizzid][Dueno]) > 1){
		for(new i,j=GetPlayerPoolSize(); i<=j; i++){
			if(PlayersData[i][Negocio] == bizzid){
				PlayersData[i][Negocio] = 0;
				DataUserSave(i);
				break;
			}
		}
		new query[128];
		mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET Negocio=0 WHERE Negocio=%i;", DIR_USERS, bizzid);
		mysql_query(dataBase, query, false);
	}

	NegociosData[bizzid][PosOutX] = 0;
	NegociosData[bizzid][PosOutY] = 0;
	NegociosData[bizzid][PosOutZ] = -1000;
	NegociosData[bizzid][PosOutZZ] = 0;
	NegociosData[bizzid][Type] = 0;
	NegociosData[bizzid][Deposito] = 0;
	NegociosData[bizzid][Precio] = 0;
	NegociosData[bizzid][Lock] = 1;
	NegociosData[bizzid][NModel] = 0;
	NegociosData[bizzid][PriceJoin] = 0;
	NegociosData[bizzid][PricePiece] = 0;
	format(NegociosData[bizzid][NameBizz], MAX_BIIZ_NAME, "Ninguno");
	format(NegociosData[bizzid][Dueno], MAX_PLAYER_NAME, "0");
	format(NegociosData[bizzid][Extorsion], MAX_PLAYER_NAME, "No");
	NegociosData[bizzid][Materiales] = 0;
	NegociosData[bizzid][World] = 0;
	NegociosData[bizzid][DepositoExtorsion] = 0;
	NegociosData[bizzid][PosInX_PC] = 0;
	NegociosData[bizzid][PosInY_PC] = 0;
	NegociosData[bizzid][PosInZ_PC] = 0;
	DataSaveBizz(bizzid, false);
}

UpdateAllBizzModelCheckPoint(playerid, bizzType, bizzModel)
{
	new count;
	for(new bizzid=1; bizzid < MAX_BIZZ_COUNT; bizzid++){
		if(NegociosData[bizzid][Type] == bizzType + 1 && NegociosData[bizzid][NModel] == bizzModel + 1){
			count++;
			NegociosData[bizzid][PosInX_PC] = NegociosModelos[bizzType][bizzModel][PosInX_PC];
			NegociosData[bizzid][PosInY_PC] = NegociosModelos[bizzType][bizzModel][PosInY_PC];
			NegociosData[bizzid][PosInZ_PC] = NegociosModelos[bizzType][bizzModel][PosInZ_PC];
			DataSaveBizz(bizzid, false);
		}
	}
	if(playerid != -1){
		Advise(playerid, "Se actualizo el CheckPoint de %d negocios con el mismo interior", count);
		SetPlayerCheckpoint(playerid, NegociosModelos[bizzType][bizzModel][PosInX_PC], NegociosModelos[bizzType][bizzModel][PosInY_PC], NegociosModelos[bizzType][bizzModel][PosInZ_PC], 1.0);
	}
}

ShowDialog247(playerid)
{
	new info[500];
	strcat(info, "Patines\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Dados\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Agenda\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Flores\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "{"COLOR_ROSA"}Comprar Saldo\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Bolsa\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Condones\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Maleta\t{"COLOR_VERDE"}$%i\n");

	format(info, 500, info,
		M24_7_Precios[0],
		M24_7_Precios[1],
		M24_7_Precios[2],
		M24_7_Precios[3],
		M24_7_Precios[4],
		M24_7_Precios[5],
		M24_7_Precios[6],
		M24_7_Precios[7]);

	ShowPlayerDialogEx(playerid, 162, DIALOG_STYLE_TABLIST, "{"COLOR_AZUL"}24/7", info, "Comprar", "Salir");
}

ShowDialogElectronica(playerid)
{
	new info[500];
	strcat(info, "Camara de Fotos\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Movil\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Modelo de Moviles\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Agenda\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "{"COLOR_ROSA"}Comprar Saldo\t{"COLOR_VERDE"}$%i\n");

	format(info, 500, info,
		PreciosElectronica[0],
		PreciosElectronica[1],
		PreciosElectronica[2],
		PreciosElectronica[3],
		PreciosElectronica[4]);

	ShowPlayerDialogEx(playerid, 168, DIALOG_STYLE_TABLIST, "{"COLOR_AZUL"}Electronica", info, "Comprar", "Salir");
}

ShowDialogTypePhones(playerid)
{
	new info[100];
	strcat(info, "Normal\n");
	strcat(info, "Color Oro\n");
	strcat(info, "Azul Claro\n");
	strcat(info, "Naranja\n");
	strcat(info, "Negro\n");
	strcat(info, "Rosa\n");
	strcat(info, "Rojo\n");
	strcat(info, "Verde\n");
	strcat(info, "Azul Oscuro\n");
	strcat(info, "Amarillo\n");
	strcat(info, "Blanco");
	ShowPlayerDialogEx(playerid, 163, DIALOG_STYLE_LIST, "{"COLOR_AZUL"}Electronica -> Modelo de Moviles", info, "Comprar", "Volver");
}

ShowDialogPolleria(playerid)
{
	new info[500];
	strcat(info, "Alitas\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Alitas + Burrito\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Balde Alitas + Hamburgesa\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Ensalada + Burrito\t{"COLOR_VERDE"}$%i\n");

	format(info, 500, info,
		PreciosPolleria[0],
		PreciosPolleria[1],
		PreciosPolleria[2],
		PreciosPolleria[3]);

	ShowPlayerDialogEx(playerid, 169, DIALOG_STYLE_TABLIST, "{"COLOR_AZUL"}Polleria", info, "Comprar", "Salir");
}

ShowDialogHamburgeseria(playerid)
{
	new info[500];
	strcat(info, "Hamburguesa\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Hamburguesa doble\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Hamburguesa tripe\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Ensalada\t{"COLOR_VERDE"}$%i\n");

	format(info, 500, info,
		PreciosHamburgseria[0],
		PreciosHamburgseria[1],
		PreciosHamburgseria[2],
		PreciosHamburgseria[3]);

	ShowPlayerDialogEx(playerid, 170, DIALOG_STYLE_TABLIST, "{"COLOR_AZUL"}Hamburgeseria", info, "Comprar", "Salir");
}

ShowDialogPizzeria(playerid)
{
	new info[500];
	strcat(info, "Porcion de Pizza\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Caja de Pizza\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Ensalada\t{"COLOR_VERDE"}$%i\n");

	format(info, 500, info,
		PreciosPizzeria[0],
		PreciosPizzeria[1],
		PreciosPizzeria[2]);

	ShowPlayerDialogEx(playerid, 171, DIALOG_STYLE_TABLIST, "{"COLOR_AZUL"}Pizzeria", info, "Comprar", "Salir");
}

ShowDialogDonuteria(playerid)
{
	new info[500];
	strcat(info, "Rosquilla + Muffin\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Donas + Rosquilla\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Combo Donas + Rosquilla\t{"COLOR_VERDE"}$%i\n");

	format(info, 500, info,
		PreciosDonuteria[0],
		PreciosDonuteria[1],
		PreciosDonuteria[2]);

	ShowPlayerDialogEx(playerid, 172, DIALOG_STYLE_TABLIST, "{"COLOR_AZUL"}Donuteria", info, "Comprar", "Salir");
}

ShowDialogRestaurante(playerid)
{
	new info[500];
	strcat(info, "Agua\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Gaseosa\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Cafe\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Pollo al horno\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Hamburguesa\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Pizza\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Ensalada\t{"COLOR_VERDE"}$%i\n");
	strcat(info, "Postre\t{"COLOR_VERDE"}$%i\n");

	format(info, 500, info,
		PreciosRestaurante[0],
		PreciosRestaurante[1],
		PreciosRestaurante[2],
		PreciosRestaurante[3],
		PreciosRestaurante[4],
		PreciosRestaurante[5],
		PreciosRestaurante[6],
		PreciosRestaurante[7]);

	ShowPlayerDialogEx(playerid, 173, DIALOG_STYLE_TABLIST, "{"COLOR_AZUL"}Restaurante", info, "Comprar", "Salir");
}

ShowDialogBar(playerid, listview)
{
    if ( NegociosData[GetPlayerVirtualWorld(playerid)][Materiales] >= 2 )
    {
		if (PlayersData[playerid][Dinero] >= 5 )
		{
		    SetBuyBares(playerid, listview, true);
		}
		else
		{
   		    SendInfoMessage(playerid, 0, "1000", "No tienes suficiente dinero para comprar esta bebida");
		}
	}
	else
	{
	    SendInfoMessage(playerid, 0, "1001", "Este bar no tiene materiales");
	}
	ShowPlayerDialogEx(playerid,29,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Bar", "{"COLOR_CREMA"}Agua          {"COLOR_VERDE"}$5\r\n{"COLOR_CREMA"}Refresco     {"COLOR_VERDE"}$10\r\n{"COLOR_CREMA"}Cerveza      {"COLOR_VERDE"}$15\r\n{"COLOR_CREMA"}Vodka        {"COLOR_VERDE"}$20", "Comprar", "Salir");
}

ShowDialogBarra(playerid, listview)
{
	if (PlayersData[playerid][Dinero] >= 10 )
	{
	    SetBuyBares(playerid, listview, false);
	}
	else
	{
	    SendInfoMessage(playerid, 0, "1289", "No tienes suficiente dinero para comprar esta bebida");
	}
	ShowPlayerDialogEx(playerid,76,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Barra", "{"COLOR_CREMA"}Agua          {"COLOR_VERDE"}$10\r\n{"COLOR_CREMA"}Refresco     {"COLOR_VERDE"}$20\r\n{"COLOR_CREMA"}Cerveza      {"COLOR_VERDE"}$30\r\n{"COLOR_CREMA"}Vodka        {"COLOR_VERDE"}$40", "Comprar", "Salir");
}

SetBuyBares(playerid, option, IsBizz)
{
	new MoneySet;
	switch (option)
	{
	    // AGUA
	    case 0:
		{
			MoneySet = (IsBizz) ? 5 : 10;
			Acciones(playerid, 8, "bebe agua");
		}
	    // REFRESCO
	    case 1:
		{
			MoneySet = (IsBizz) ? 10 : 20;
			Acciones(playerid, 8, "compra un refresco");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK); // SPUNK
		}
	    // CERVEZA
	    case 2:
		{
			MoneySet = (IsBizz) ? 15 : 30;
			Acciones(playerid, 8, "compra una cerveza");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE); // CERVEZA
		}
	    // VODKA
	    case 3:
		{
			MoneySet = (IsBizz) ? 20 : 40;
			Acciones(playerid, 8, "compra una botella de Vodka");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE); // WINE
		}
	}
	new Float:HPSet = (IsBizz) ? MoneySet*2 : MoneySet/2;//Sale la mitad y da el bole - Sale el doble y da la mitad...
	SetPlayerHealthEx(playerid, HPSet);
    GivePlayerMoneyEx(playerid, -MoneySet);
	if(PlayersData[playerid][IsPlayerInBizz]){
		if(NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_DISCOTECA){
			IsBizz = true;
		}
	}
	if ( IsBizz )
	{
		SetMoneyExtorsion(GetPlayerVirtualWorld(playerid), MoneySet);
	}
}

ShowDialogArmeria(playerid)
{
	new caption[64], info[500];
	new category = PlayersDataOnline[playerid][SaveAfterAgenda][0];
	if(category == 0)
	{
		strcat(info, "Categoria\n");
		for(new x; x<=8; x++)
		format(info, 500, "%s{"COLOR_CREMA"}%s\n", info, Armas_Clases[x]);

		ShowPlayerDialogEx(playerid, 174, DIALOG_STYLE_TABLIST_HEADERS, "{"COLOR_AZUL"}Armeria", info, "Seleccionar", "Salir");
	}
	else{
		format(caption, sizeof(caption), "{"COLOR_AZUL"}Armeria -> %s", Armas_Clases[category-1]);
		strcat(info, "{"COLOR_CREMA"}Arma\t{"COLOR_CREMA"}Municion/Cantidad\t{"COLOR_CREMA"}Precio Unitario\t{"COLOR_CREMA"}Precio\n");
		new maxRow;
		if(category == 1) maxRow = 5;
		else if(category == 2) maxRow = 4;
		else if(category == 3) maxRow = 3;
		else if(category == 4) maxRow = 2;
		else if(category == 5) maxRow = 1;
		else if(category == 6) maxRow = 2;
		else if(category == 7) maxRow = 2;
		else if(category == 8) maxRow = 3;
		else if(category == 9) maxRow = 3;
		for(new i; i!=maxRow; i++){
			if(PlayersData[playerid][Dinero] >= Armas_Precios_Num[category-1][i])// * Armas_Municion[category-1][i])
			{
				if(PlayersData[playerid][Dinero] >= Armas_Precios_Num[category-1][i] * Armas_Municion[category-1][i])
				format(info, sizeof(info), "%s%s\t%i\t{"COLOR_VERDE"}$%i\t{"COLOR_VERDE"}$%i\n", info, Armas_Nombre[category-1][i], Armas_Municion[category-1][i], Armas_Precios_Num[category-1][i], Armas_Precios_Num[category-1][i] * Armas_Municion[category-1][i]);
				else
				format(info, sizeof(info), "%s%s\t%i\t{"COLOR_VERDE"}$%i\t{"COLOR_ROJO"}$%i\n", info, Armas_Nombre[category-1][i], Armas_Municion[category-1][i], Armas_Precios_Num[category-1][i], Armas_Precios_Num[category-1][i] * Armas_Municion[category-1][i]);
			}
			else format(info, sizeof(info), "%s%s\t%i\t{"COLOR_ROJO"}$%i\t{"COLOR_ROJO"}$%i\n", info, Armas_Nombre[category-1][i], Armas_Municion[category-1][i], Armas_Precios_Num[category-1][i], Armas_Precios_Num[category-1][i] * Armas_Municion[category-1][i]);
		}
		ShowPlayerDialogEx(playerid, 174, DIALOG_STYLE_TABLIST_HEADERS, caption, info, "Comprar", "Volver");
	}
}

DialogArmeria(playerid, listitem)
{
	new category = PlayersDataOnline[playerid][SaveAfterAgenda][0];
	if(category == 0){
		PlayersDataOnline[playerid][SaveAfterAgenda][0] = listitem+1;
		ShowDialogArmeria(playerid);
	}
	else{
		if ( Armas_Municion[category-1][listitem] == 1 )
		{
			if ( CheckWeapondCheat(playerid) && PlayersData[playerid][Dinero] >= Armas_Precios_Num[category-1][listitem] )
			{
			    if ( category-1 == 9 && listitem == 1 )
			    {
                    Importante(playerid, "Has comprado un chaleco por $%i", Armas_Precios_Num[category-1][listitem]);
					SetPlayerArmourEx(playerid, 80);
				}
				else
				{
                    Importante(playerid, "Has comprado %s por $%i", Armas_Nombre[category-1][listitem][4], Armas_Precios_Num[category-1][listitem]);
                    GivePlayerWeaponEx(playerid, Armas_ID[category-1][listitem], 1);
				}
				GivePlayerMoneyEx(playerid, -Armas_Precios_Num[category-1][listitem]);
				SetMoneyExtorsion(GetPlayerVirtualWorld(playerid), Armas_Precios_Num[category-1][listitem]);
			}
			else
			{
				Error(playerid, "No tienes suficiente dinero para comprar este accesorio de la armeria");
			}
			ShowDialogArmeria(playerid);
		}
		else{
			new MsgComprarArmaDialogPresupuesto[MAX_TEXT_CHAT];
			format(MsgComprarArmaDialogPresupuesto, sizeof(MsgComprarArmaDialogPresupuesto), "{"COLOR_TEXTO_DIALOGS"}¿Desea comprar %s con %i de municion\n{"COLOR_TEXTO_DIALOGS"}por el precio de $%i?",
			Armas_Nombre[category-1][listitem][4],
			Armas_Municion[category-1][listitem], Armas_Precios_Num[category-1][listitem] * Armas_Municion[category-1][listitem]);

			ShowPlayerDialogEx(playerid, 9, DIALOG_STYLE_MSGBOX, "{"COLOR_AZUL"}Finalize su compra!", MsgComprarArmaDialogPresupuesto, "Comprar!", "Modificar");
			PlayersDataOnline[playerid][MyAmmoSelect] = Armas_Municion[category-1][listitem];
			PlayersDataOnline[playerid][SaveAfterAgenda][1] = listitem;
		}
	}
}

ShowDialogSuperMercado(playerid)
{
	new info[200];
	strcat(info, "{"COLOR_CREMA"}Articulo\t{"COLOR_CREMA"}Precio\n");
	
    strcat(info, "Pack 6 Cervezas\t{"COLOR_VERDE"}$%i\n");
    strcat(info, "5 Vodkas\t{"COLOR_VERDE"}$%i\n");
    strcat(info, "5 Refrescos\t{"COLOR_VERDE"}$%i\n");
    strcat(info, "Pollo Crudo\t{"COLOR_VERDE"}$%i\n");
    strcat(info, "Papas\t{"COLOR_VERDE"}$%i\n");
    strcat(info, "Arroz\t{"COLOR_VERDE"}$%i\n");

    format(info, 500, info,
		SupermercadoArticulosPrecios[0],
		SupermercadoArticulosPrecios[1],
		SupermercadoArticulosPrecios[2],
		SupermercadoArticulosPrecios[3],
		SupermercadoArticulosPrecios[4],
		SupermercadoArticulosPrecios[5]);

    ShowPlayerDialogEx(playerid, 37, DIALOG_STYLE_TABLIST_HEADERS, "{"COLOR_AZUL"}Super Mercado", info, "Comprar", "Salir");
}


OnPlayerCommandBusiness(playerid, const cmdtext[])
{
	// COMANDO: /Ver Precio
	if( !strcmp("/Ver Precio", cmdtext, true) )
	{
		if( PlayersData[playerid][Faccion] == CAMIONEROS && PlayersData[playerid][Rango] <= 3 ||
			PlayersData[playerid][Faccion] == CONTRABANDISTAS && PlayersData[playerid][Rango] <= 3 )
		{
			if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");
			new bizzid = PlayersDataOnline[playerid][InPickupNegocio];
			
			if( NegociosData[bizzid][Type] != BIZZ_TYPE_ROPA && PlayersData[playerid][Faccion] == CAMIONEROS )
			{
				if( NegociosData[bizzid][PricePiece] == 0 ) return Error(playerid, "Este negocio no esta aceptando materiales");

				Info(playerid, "Este negocio paga el material a $%i. Actualmente tiene [%i/5000]", NegociosData[bizzid][PricePiece], NegociosData[bizzid][Materiales]);
			}
			else if( NegociosData[bizzid][Type] == BIZZ_TYPE_ROPA && PlayersData[playerid][Faccion] == CONTRABANDISTAS )
			{
				if( NegociosData[bizzid][PricePiece] == 0 ) return Error(playerid, "Esta tienda no esta aceptando materiales");

				Info(playerid, "Esta tienda paga el material a $%i. Actualmente tiene [%i/5000]", NegociosData[bizzid][PricePiece], NegociosData[bizzid][Materiales]);
			}
			else Error(playerid, "No puedes ver el precio de compra de este negocio");
		}
		else SendAccessError(playerid, cmdtext[1]);
		return true;
	}
	// COMANDO: /Abastecer Tienda
	else if( !strcmp("/Abastecer Tienda", cmdtext, true) )
	{
		if( PlayersData[playerid][Faccion] == CONTRABANDISTAS && PlayersData[playerid][Rango] <= 3 )
		{
			if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ninguna Tienda de Ropas");
			{
				new
					MyNearCar = IsPlayerInNearVehicle(playerid),
					bizzid = PlayersDataOnline[playerid][InPickupNegocio];
				if( MyNearCar )
				{
					MyNearCar--;
					if( DataCars[MyNearCar][Time] == CONTRABANDISTAS && DataCars[MyNearCar][Modelo] == 418 )
					{
						new const maleteroMateriales = coches_Todos_Maleteros[MyNearCar][10][0];
						new const priceToPay = maleteroMateriales + NegociosData[bizzid][PricePiece];

						if( NegociosData[bizzid][Type] != BIZZ_TYPE_ROPA ) return Error(playerid, "Solo puedes abastecer tiendas de ropa");
						if( NegociosData[bizzid][PricePiece] == 0 ) return Error(playerid, "Esta tienda no esta aceptando compra de materiales, conctacte con el dueño");
						if( maleteroMateriales == 0 ) return Error(playerid, "No le quedan materiales a esta furgona");				
						if( NegociosData[bizzid][Materiales] + maleteroMateriales > 5000 ) return Error(playerid, "El almacen del la tienda esta lleno o los materiales que quieres depositar ya sobrepasan el límite de 5000");
						if( NegociosData[bizzid][Deposito] < priceToPay ) return Error(playerid, "Esta tienda no le queda suficiente dinero para comprale todos los materiales del la furgona");

						Importante(playerid, "Has abastecido esta tienda con %i materiales, se le ha enviado $%i a la cuenta de la empresa", maleteroMateriales, priceToPay);

						coches_Todos_Maleteros[MyNearCar][10][0] = 0;
						NegociosData[bizzid][Materiales] += maleteroMateriales;
						NegociosData[bizzid][Deposito] -= priceToPay;
						FaccionData[CONTRABANDISTAS][Deposito] += priceToPay;
						SaveDataVehicle(MyNearCar);
						DataSaveBizz(bizzid, false);
						UpdateFaccionDeposit(CONTRABANDISTAS);
					}
					else Error(playerid, "Este vehiculo no sirve para abastecer las tiendas de ropa");
				}
			}
		}
		else SendAccessError(playerid, cmdtext[1]);
		return true;
	}
	// COMANDO: /Abastecer Negocio
	else if( !strcmp("/Abastecer Negocio", cmdtext, true) )
	{
		if( PlayersData[playerid][Faccion] == CAMIONEROS && PlayersData[playerid][Rango] <= 3 )
		{
			if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");

			new
				MyNearCar = IsPlayerInNearVehicle(playerid),
				bizzid = PlayersDataOnline[playerid][InPickupNegocio];
			if( MyNearCar )
			{
				MyNearCar--;
				if( (DataCars[MyNearCar][Modelo] == 514 || DataCars[MyNearCar][Modelo] == 515 || DataCars[MyNearCar][Modelo] == 403 || DataCars[MyNearCar][Modelo] == 456 || DataCars[MyNearCar][Modelo] == 578) && 
					DataCars[MyNearCar][Time] == CAMIONEROS )
				{
					new const maleteroMateriales = coches_Todos_Maleteros[MyNearCar][10][0];
					new const priceToPay = maleteroMateriales + NegociosData[bizzid][PricePiece];

					if( NegociosData[bizzid][Type] == BIZZ_TYPE_ROPA ) return Error(playerid, "No puedes abastecer tiendas de ropa");
					if( NegociosData[bizzid][PricePiece] == 0 ) return Error(playerid, "Este negocio no esta aceptando compra de materiales, conctacte con el dueño");
					if( maleteroMateriales == 0 ) return Error(playerid, "No le quedán materiales a este camión");
					if( NegociosData[bizzid][Materiales] + maleteroMateriales > 5000 ) return Error(playerid, "El almacen del negocio esta lleno o los materiales que quieres depositar ya sobrepasan el límite de 5000");
					if( NegociosData[bizzid][Deposito] < priceToPay ) return Error(playerid, "Este negocio no le quedá suficiente dinero para comprale todos los materiales del camión");

					Importante(playerid, "Has abastecido este negocio con %i materiales, se le ha enviado $%i a la cuenta de la empresa", maleteroMateriales, priceToPay);

					coches_Todos_Maleteros[MyNearCar][10][0] = 0;
					NegociosData[bizzid][Materiales] += maleteroMateriales;
					NegociosData[bizzid][Deposito] -= priceToPay;
					FaccionData[CAMIONEROS][Deposito] += priceToPay;
					SaveDataVehicle(MyNearCar);
					DataSaveBizz(bizzid, false);
					UpdateFaccionDeposit(CAMIONEROS);
				}
				else Error(playerid, "Este vehiculo no es un camión de materiales, busque uno y aparquelo junto al negocio y luego use (/Abastecer Negocio)");
			}
		}
		else SendAccessError(playerid, cmdtext[1]);
		return true;
	}
	//////////--- /Crear Negocio [Tipo] [Modelo] [Precio]
	else if( !strfind(cmdtext, "/Crear Negocio", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext[1]);
		new TypeBizz, ModelBizz, PrecioN;
		if( strlen(cmdtext) <= 15 || sscanf(cmdtext[15], "ddD(-1)", TypeBizz, ModelBizz, PrecioN) ) return SendSyntaxError(playerid, "Crear Negocio [Tipo] [Modelo] [Precio (Opcional)]", "Crear Negocio 1 1 150000");

		if( TypeBizz < 1 || TypeBizz > MAX_BIZZ_TYPE_COUNT )
		{
			Error(playerid, "Tipo de negocio invalido!");
			ShowBizzTypes(playerid);
			return 1;
		}
	
		new MaxBizzModels = GetMaxBizzModelsByType(TypeBizz-1);
		if( MaxBizzModels == -1 ) return Error(playerid, "Este tipo de negocio no tiene programado interiores! Use /Crear Modelo Negocio");
		if( ModelBizz < 1 || ModelBizz > (MaxBizzModels+1) )
		{
			Error(playerid, "Modelo de negocio invalido!");
			ShowBizzModelsOfType(playerid, TypeBizz-1);
			return 1;
		}
		new MyNextBizz = GetMyNextBizz();
		if( !MyNextBizz ) return Error(playerid, "Ya no se pueden agregar mas negocios, se ha alcanzado el límite! (%d)", MAX_BIZZ_COUNT - 1);
	
		if( PrecioN == -1 ) PrecioN = 150000;
		if( PrecioN < 0 || PrecioN > 2000000 ) return Error(playerid, "El precio del negocio debe ser entre $0 y $2000000");

		new Float:PlayerPosBizz[4];
		GetPlayerPos(playerid, PlayerPosBizz[0], PlayerPosBizz[1], PlayerPosBizz[2]);
		GetPlayerFacingAngle(playerid, PlayerPosBizz[3]);

		NegociosData[MyNextBizz][PosOutX] = PlayerPosBizz[0];
		NegociosData[MyNextBizz][PosOutY] = PlayerPosBizz[1];
		NegociosData[MyNextBizz][PosOutZ] = PlayerPosBizz[2];
		NegociosData[MyNextBizz][PosOutZZ] = PlayerPosBizz[3];
		NegociosData[MyNextBizz][Deposito] = 0;
		NegociosData[MyNextBizz][Precio] = PrecioN;
		NegociosData[MyNextBizz][Lock] = false;
		NegociosData[MyNextBizz][Type] = TypeBizz;
		NegociosData[MyNextBizz][NModel] = ModelBizz;
		NegociosData[MyNextBizz][PriceJoin] = 0;
		NegociosData[MyNextBizz][PricePiece] = 0;
		NegociosData[MyNextBizz][Materiales] = 5000;//Crear negocios ya full
		format(NegociosData[MyNextBizz][NameBizz], 	MAX_BIIZ_NAME, "Ninguno");
		format(NegociosData[MyNextBizz][Dueno], MAX_PLAYER_NAME, "0");
		format(NegociosData[MyNextBizz][Extorsion], MAX_PLAYER_NAME, "No");
		NegociosData[MyNextBizz][PosInX_PC] = NegociosModelos[TypeBizz-1][ModelBizz-1][PosInX_PC];
		NegociosData[MyNextBizz][PosInY_PC] = NegociosModelos[TypeBizz-1][ModelBizz-1][PosInY_PC];
		NegociosData[MyNextBizz][PosInZ_PC] = NegociosModelos[TypeBizz-1][ModelBizz-1][PosInZ_PC];

		DataSaveBizz(MyNextBizz, true);

		ImportanteEx(playerid, "Has creado un negocio tipo \"%s\"[%i] modelo \"%s\"[%i] con ID %i, Precio: $%i", NegociosTipo[TypeBizz-1], TypeBizz, NegociosModelos[TypeBizz-1][ModelBizz-1][TypeName], ModelBizz, MyNextBizz, PrecioN);
		return true;
	}	
	//		/Crear Modelo Negocio [Tipo_ID] [Nombre]
	else if( !strfind(cmdtext, "/Crear Modelo Negocio", true) )
	{
		new bizzTypeID, bizzTypeName[24];
		if( strlen(cmdtext) <= 22 || sscanf(cmdtext[22], "is[24]", bizzTypeID, bizzTypeName) )
		{
			SendSyntaxError(playerid, "Crear Modelo Negocio [Tipo_ID] [Nombre]", "Crear Modelo Negocio 1 24/7 Vacio");
			ShowBizzTypes(playerid);
			return 1;
		}
		if(bizzTypeID < 1 || bizzTypeID > sizeof(NegociosTipo)){
			Error(playerid, "Tipo de negocio invalido.");
			ShowBizzTypes(playerid);
			return 1;
		}
		bizzTypeID--;
		if(strlen(bizzTypeName) < 2 || strlen(bizzTypeName) > MAX_PLAYER_NAME)
		{
			Error(playerid, "El nombre del modelo de negocio debe ser entre 2 y 24 caracteres.");
			return 1;
		}
		new bizzModelID;
		if( GetNextBizzModelID(playerid, bizzTypeID, bizzModelID) )
		{
			if( !GetPlayerInterior(playerid) ) return Error(playerid, "Debes estar en un interior para usar este comando.");
			new Float:PP[4]; GetPlayerPos(playerid, PP[0], PP[1], PP[2]); GetPlayerFacingAngle(playerid, PP[3]);
			NegociosModelos[bizzTypeID][bizzModelID][PosInX] = PP[0];
			NegociosModelos[bizzTypeID][bizzModelID][PosInY] = PP[1];
			NegociosModelos[bizzTypeID][bizzModelID][PosInZ] = PP[2];
			NegociosModelos[bizzTypeID][bizzModelID][PosInZZ] = PP[3];
			NegociosModelos[bizzTypeID][bizzModelID][PosInX_PC] = 0.0;
			NegociosModelos[bizzTypeID][bizzModelID][PosInY_PC] = 0.0;
			NegociosModelos[bizzTypeID][bizzModelID][PosInZ_PC] = 0.0;
			NegociosModelos[bizzTypeID][bizzModelID][InteriorId] = GetPlayerInterior(playerid);
			format(NegociosModelos[bizzTypeID][bizzModelID][TypeName], 24, "%s", bizzTypeName);
			SaveDataBizzModel(bizzTypeID, bizzModelID);

			NegociosModelos[bizzTypeID][bizzModelID][PickupId] = CreateModeloNegocioDynamicPickup(bizzTypeID, bizzModelID, NegociosModelos[bizzTypeID][bizzModelID][PosInX], NegociosModelos[bizzTypeID][bizzModelID][PosInY], NegociosModelos[bizzTypeID][bizzModelID][PosInZ]);

			ImportanteEx(playerid, "Creaste un modelo de negocio con el ID %d. Tipo: %s[%d], Nombre: %s, Interior: %d",\
				bizzModelID+1, NegociosTipo[bizzTypeID], bizzTypeID+1, bizzTypeName, GetPlayerInterior(playerid));
			Advise(playerid, "Use \"/Editar Modelo Negocio %d %d\" para configurar la posicion del CheckPoint!", bizzTypeID+1, bizzModelID+1);
		}
		return true;
	}
	// COMANDO: /Bar
	else if( !strcmp("/Bar", cmdtext, true) )
	{
		if( PlayersData[playerid][IsPlayerInBizz] && NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_BAR )
		{
			if( IsPlayerInRangeOfPoint(playerid, 2.0, NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInX_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInY_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInZ_PC]) )
			{
				ShowPlayerDialogEx(playerid,29,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Bar", "{"COLOR_CREMA"}Agua          {"COLOR_VERDE"}$5\r\n{"COLOR_CREMA"}Refresco     {"COLOR_VERDE"}$10\r\n{"COLOR_CREMA"}Cerveza      {"COLOR_VERDE"}$15\r\n{"COLOR_CREMA"}Vodka        {"COLOR_VERDE"}$20", "Comprar", "Salir");
			}
			else
			{
				Error(playerid, "No te encuentras cerca del la barra");
			}
		}
		else if( IsPlayerInBarra(playerid) )
		{
			ShowPlayerDialogEx(playerid,76,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Barra", "{"COLOR_CREMA"}Agua          {"COLOR_VERDE"}$10\r\n{"COLOR_CREMA"}Refresco     {"COLOR_VERDE"}$20\r\n{"COLOR_CREMA"}Cerveza      {"COLOR_VERDE"}$30\r\n{"COLOR_CREMA"}Vodka        {"COLOR_VERDE"}$40", "Comprar", "Salir");
		}
		else
		{
			Error(playerid, "No estas en un bar");
		}
		return true;
	}
	// COMANDO: /Llaves Negocio
	else if( !strcmp("/Llaves Negocio", cmdtext, true) )
	{
		if( PlayersDataOnline[playerid][InPickupNegocio] || PickupIndex[PlayersDataOnline[playerid][InPickup]][Tipo] == PICKUP_TYPE_NEGOCIO_TYPE )
		{
			new bizzID = ( PlayersDataOnline[playerid][InPickupNegocio] ) ? ( PlayersDataOnline[playerid][InPickupNegocio] ) : ( PlayersData[playerid][IsPlayerInBizz] );
			if( !IsMyBizz(playerid, bizzID, true) ) return true;
			if( !IsBizzOnRobo(playerid, bizzID) )
			{
				if( NegociosData[bizzID][Lock] )
				{
					NegociosData[bizzID][Lock] = false;
					GameTextForPlayer(playerid, "~W~Puerta ~G~Abierta!", 1000, 6);
				}
				else
				{
					NegociosData[bizzID][Lock] = true;
					GameTextForPlayer(playerid, "~W~Puerta ~R~Cerrada!", 1000, 6);
				}
				PlayPlayerStreamSound(playerid, 1027);
				UpdateLockDoorForPlayer(NegociosData[bizzID][PickupOutId], NegociosData[bizzID][Lock], NegociosModelos[NegociosData[bizzID][Type]-1][NegociosData[bizzID][NModel]-1][PickupId]);
			}
		}
		else
		{
			Error(playerid, "No te encuentras en ningun negocio");
		}
		return true;
	}
	// COMANDO: /Cambiar Precio Entrada [Nuevo_Precio]
	else if( !strfind(cmdtext, "/Cambiar Precio Entrada", true) )
	{
		if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio.");
		new bizzid = PlayersDataOnline[playerid][InPickupNegocio];
		if( !IsMyBizz(playerid, bizzid, true) ) return 1;
		if( NegociosData[bizzid][Type] != BIZZ_TYPE_DISCOTECA && 
			NegociosData[bizzid][Type] != BIZZ_TYPE_CASINO ) return Error(playerid, "Solo puedes cambiar el precio entrada a una Discoteca o Casino");
		if( !IsBizzOnRobo(playerid, bizzid) )
		{
			if( strlen(cmdtext) <= 24 ) return SendSyntaxError(playerid, "Cambiar Precio Entrada [Precio]", "Cambiar Precio Entrada 2");
			new newPrice = strval(cmdtext[24]);
			if( newPrice >= 0 &&  newPrice <= 20000)
			{
				NegociosData[bizzid][PriceJoin] = newPrice;
				DataSaveBizz(bizzid, true);
				Importante(playerid, "Has modificado el precio de entrada del negocio");
			}
			else
			{
				Error(playerid, "El precio de entrada minimo es $0 y maximo $20000");
			}
		}
		return true;
	}
	// COMANDO: /Cambiar Precio Entrada [Nuevo_Precio]
	else if( !strfind(cmdtext, "/Cambiar Precio Materiales", true) )
	{
		if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio.");
		new bizzid = PlayersDataOnline[playerid][InPickupNegocio];
		if( !IsMyBizz(playerid, bizzid, true) ) return 1;
		if( !IsBizzOnRobo(playerid, bizzid) )
		{
			if( strlen(cmdtext) <= 27 ) return SendSyntaxError(playerid, "Cambiar Precio Materiales [Precio]", "Cambiar Precio Materiales 2");
			new newPrice = strval(cmdtext[27]);
			if( newPrice >= 0 &&  newPrice <= 1000)
			{
				NegociosData[bizzid][PricePiece] = newPrice;
				DataSaveBizz(bizzid, true);
				Importante(playerid, "Has modificado el precio de los materiales");
			}
			else
			{
				Error(playerid, "El precio de compra de materiales minimo es $0 y mayor $1000");
			}
		}
		return true;
	}
	// COMANDO: /Retirar Extorsion
	else if( !strcmp("/Retirar Extorsion", cmdtext, true) )
	{
		if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");
		new bizzid = PlayersDataOnline[playerid][InPickupNegocio];
		if( !IsMyExtorsion(playerid, bizzid) ) return Error(playerid, "Usted no extorsiona este negocio");
		if( IsBizzOnRobo(playerid, bizzid) ) return true;
		
		if( NegociosData[bizzid][DepositoExtorsion] > 0 )
		{
			GivePlayerMoneyEx(playerid, NegociosData[bizzid][DepositoExtorsion]);

			Importante(playerid, "Ha retirado $%i extorsionados de este negocio", NegociosData[bizzid][DepositoExtorsion]);
			NegociosData[bizzid][DepositoExtorsion] = 0;
			DataSaveBizz(bizzid, false);
		}
		else
		{
			Error(playerid, "No hay dinero para extorsionar en este negocio");
		}
		return true;
	}
	// COMANDO: /Retirar Negocio [Cantidad]
	else if( !strfind(cmdtext, "/Retirar Negocio", true) )
	{
		if( PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");
		new BizzId = PlayersDataOnline[playerid][InPickupNegocio];
		if( !IsMyBizz(playerid, BizzId, true) ) return 1;
		if( IsBizzOnRobo(playerid, BizzId) ) return 1;
		if( strlen(cmdtext) <= 17 ) return SendSyntaxError(playerid, "Retirar Negocio [Cantidad]", "Retirar Negocio 1000");
		new amount = strval(cmdtext[17]);
		if( amount > 0 && NegociosData[BizzId][Deposito] >= amount )
		{
			NegociosData[BizzId][Deposito] -= amount;
			DataSaveBizz(BizzId, false);
			GivePlayerMoneyEx(playerid, amount);

			Importante(playerid, "Ha retirado $%i del negocio, su nuevo saldo es: $%i", amount, NegociosData[BizzId][Deposito]);
		}
		else
		{
			Error(playerid, "No tienes esa cantidad de dinero para retirar del negocio");
		}
		return true;
	}
	// COMANDO: /Depositar Negocio [Cantidad]
	else if( !strfind(cmdtext, "/Depositar Negocio", true) )
	{
		if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");
		
		new BizzId = PlayersDataOnline[playerid][InPickupNegocio];
		if( !IsMyBizz(playerid, BizzId, true) ) return 1;
		if( strlen(cmdtext) <= 19 ) return SendSyntaxError(playerid, "Depositar Negocio [Cantidad]", "Depositar Negocio 1000");
		new amount = strval(cmdtext[19]);
		if(PlayersData[playerid][Dinero] >= amount )
		{
			NegociosData[BizzId][Deposito] += amount;
			DataSaveBizz(BizzId, false);
			GivePlayerMoneyEx(playerid, -amount);
			
			Importante(playerid, "Ha depositado $%i del negocio, su nuevo saldo es: $%i", amount, NegociosData[BizzId][Deposito]);
		}
		else
		{
			Error(playerid, "No tienes esa cantidad de dinero para depositar en el negocio");
		}
		return true;
	}
	// COMANDO: /Consutlar Negocio
	else if( !strcmp("/Consultar Negocio", cmdtext, true) )
	{
		if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");
	
		new BizzId = PlayersDataOnline[playerid][InPickupNegocio];
		if( IsMyBizz(playerid, BizzId, true)  )
		{			
			Info(playerid, "Tiene usted $%i en el fondo de su negocio", NegociosData[BizzId][Deposito]);
		}
		return true;
	}
	// COMANDO: /Consultar Extorsion
	else if( !strcmp("/Consultar Extorsion", cmdtext, true) )
	{
		if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");
		new BizzId = PlayersDataOnline[playerid][InPickupNegocio];
		if( IsMyExtorsion(playerid, BizzId) )
		{
			Info(playerid, "Tiene acumulado $%i de extorsion en este negocio", NegociosData[BizzId][DepositoExtorsion]);
		}
		else
		{
			Error(playerid, "Usted no extorsiona este negocio");
		}
		return true;
	}
	// COMANDO: /Comprar Ropa
	else if( !strcmp("/Comprar Ropa", cmdtext, true) )
	{
		if( PlayersData[playerid][IsPlayerInBizz] && NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_ROPA )
		{
			if( IsPlayerInRangeOfPoint(playerid, 2.0, NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInX_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInY_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInZ_PC]) )
			{
				if(PlayersData[playerid][Dinero] >= 50 )
				{
					if( NegociosData[PlayersData[playerid][IsPlayerInBizz]][Materiales] >= 2 )
					{
						SetMoneyExtorsion(PlayersData[playerid][IsPlayerInBizz], 50);
						GivePlayerMoneyEx(playerid, -50);
						SetPlayerSelectedTypeSkin(playerid, false);
					}
					else
					{
						Error(playerid, "Esta tienda no tiene materiales");
					}
				}
				else
				{
					Error(playerid, "No tienes suficiente dinero para comprar ropa, cuesta $50");
				}
			}
			else
			{
				Error(playerid, "No te encuentras cerca del vestidor");
			}
		}
		else
		{
			Error(playerid, "No estas en una tienda de ropa");
		}
		return true;
	}
	// COMANDO: /Comprar Lentes
	else if( !strcmp("/Comprar Lentes", cmdtext, true) )
	{
		if( PlayersData[playerid][IsPlayerInBizz] && NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_ROPA )
		{
			if( IsPlayerInRangeOfPoint(playerid, 2.0, NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInX_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInY_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInZ_PC]) )
			{
				if(PlayersData[playerid][Dinero] >= 100 )
				{
					if( NegociosData[PlayersData[playerid][IsPlayerInBizz]][Materiales] >= 2 )
					{
						if( IsAllowItSkinForGafas(PlayersData[playerid][Skin]) )
						{
							if( IsPlayerNotFullObjects(playerid, true) != -1 )
							{
								SetMoneyExtorsion(PlayersData[playerid][IsPlayerInBizz], 100);
								GivePlayerMoneyEx(playerid, -100);
								PlayersDataOnline[playerid][TypeBuy] = TYPE_GAFAS;
								SetPlayerSelectedTypeHair(playerid);
							}
						}
						else
						{
							Error(playerid, "Con este skin no puedes usar lentes!");
						}
					}
					else
					{
						Error(playerid, "Esta tienda no tiene materiales");
					}
				}
				else
				{
					Error(playerid, "No tienes suficiente dinero para comprar lentes, cuesta $100");
				}
			}
			else
			{
				Error(playerid, "No te encuentras cerca del probador");
			}
		}
		else
		{
			Error(playerid, "No estas en una tienda de ropa");
		}
		return true;
	}
	// COMANDO: /Comprar Casco
	else if( !strcmp("/Comprar Casco", cmdtext, true) )
	{
		if( PlayersData[playerid][IsPlayerInBizz] && NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_ROPA )
		{
			if( IsPlayerInRangeOfPoint(playerid, 2.0, NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInX_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInY_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInZ_PC]) )
			{
				if(PlayersData[playerid][Dinero] >= 100 )
				{
					if( NegociosData[PlayersData[playerid][IsPlayerInBizz]][Materiales] >= 2 )
					{
						if( IsAllowItSkinForCasco(PlayersData[playerid][Skin]) )
						{
							if( IsPlayerNotFullObjects(playerid, true) != -1 )
							{
								SetMoneyExtorsion(PlayersData[playerid][IsPlayerInBizz], 100);
								GivePlayerMoneyEx(playerid, -100);
								PlayersDataOnline[playerid][TypeBuy] = TYPE_CASCO;
								SetPlayerSelectedTypeHair(playerid);
							}
						}
						else
						{
							Error(playerid, "Con este skin no puedes usar cascos!");
						}
					}
					else
					{
						Error(playerid, "Esta tienda no tiene materiales");
					}
				}
				else
				{
					Error(playerid, "No tienes suficiente dinero para comprar cascos, cuesta $100");
				}
			}
			else
			{
				Error(playerid, "No te encuentras cerca del probador");
			}
		}
		else
		{
			Error(playerid, "No estas en una tienda de ropa");
		}
		return true;
	}
	// COMANDO: /Comprar Reloj
	else if( !strcmp("/Comprar Reloj", cmdtext, true) )
	{
		if( PlayersData[playerid][IsPlayerInBizz] && NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_ROPA )
		{
			if( IsPlayerInRangeOfPoint(playerid, 2.0, NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInX_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInY_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInZ_PC]) )
			{
				if(PlayersData[playerid][Dinero] >= 100 )
				{
					if( NegociosData[PlayersData[playerid][IsPlayerInBizz]][Materiales] >= 2 )
					{
						if( IsAllowItSkinForRelojes(PlayersData[playerid][Skin]) )
						{
							if( IsPlayerNotFullObjects(playerid, true) != -1 )
							{
								SetMoneyExtorsion(PlayersData[playerid][IsPlayerInBizz], 100);
								GivePlayerMoneyEx(playerid, -100);
								PlayersDataOnline[playerid][TypeBuy] = TYPE_RELOJES;
								SetPlayerSelectedTypeHair(playerid);
							}
						}
						else
						{
							Error(playerid, "Con este skin no puedes usar relojes!");
						}
					}
					else
					{
						Error(playerid, "Esta tienda no tiene materiales");
					}
				}
				else
				{
					Error(playerid, "No tienes suficiente dinero para comprar un reloj, cuesta $100");
				}
			}
			else
			{
				Error(playerid, "No te encuentras cerca del probador");
			}
		}
		else
		{
			Error(playerid, "No estas en una tienda de ropa");
		}
		return true;
	}
	// COMANDO: /Comprar Gorra
	else if( !strcmp("/Comprar Gorra", cmdtext, true) )
	{
		if( PlayersData[playerid][IsPlayerInBizz] && NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_ROPA )
		{
			if( IsPlayerInRangeOfPoint(playerid, 2.0, NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInX_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInY_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInZ_PC]) )
			{
				if(PlayersData[playerid][Dinero] >= 100 )
				{
					if( NegociosData[PlayersData[playerid][IsPlayerInBizz]][Materiales] >= 2 )
					{
						if( IsAllowItSkinForGorras(PlayersData[playerid][Skin]) )
						{
							if( IsPlayerNotFullObjects(playerid, true) != -1 )
							{
								SetMoneyExtorsion(PlayersData[playerid][IsPlayerInBizz], 100);
								GivePlayerMoneyEx(playerid, -100);
								PlayersDataOnline[playerid][TypeBuy] = TYPE_GORRAS;
								SetPlayerSelectedTypeHair(playerid);
							}
						}
						else
						{
							Error(playerid, "Con este skin no puedes usar gorras!");
						}
					}
					else
					{
						Error(playerid, "Esta tienda no tiene materiales");
					}
				}
				else
				{
					Error(playerid, "No tienes suficiente dinero para comprar una gorra, cuesta $100");
				}
			}
			else
			{
				Error(playerid, "No te encuentras cerca del probador");
			}
		}
		else
		{
			Error(playerid, "No estas en una tienda de ropa");
		}
		return true;
	}
	// COMANDO: /Comprar Boina
	else if( !strcmp("/Comprar Boina", cmdtext, true) )
	{
		if( PlayersData[playerid][IsPlayerInBizz] && NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_BARBERIA )
		{
			if( IsPlayerInRangeOfPoint(playerid, 2.0, NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInX_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInY_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInZ_PC]) )
			{
				if(PlayersData[playerid][Dinero] >= 150 )
				{
					if( NegociosData[PlayersData[playerid][IsPlayerInBizz]][Materiales] >= 2 )
					{
						if( IsAllowItSkinForBoina(PlayersData[playerid][Skin]) )
						{
							if( IsPlayerNotFullObjects(playerid, true) != -1 )
							{
								SetMoneyExtorsion(PlayersData[playerid][IsPlayerInBizz], 150);
								GivePlayerMoneyEx(playerid, -150);
								PlayersDataOnline[playerid][TypeBuy] = TYPE_BOINA;
								SetPlayerSelectedTypeHair(playerid);
							}
						}
						else
						{
							Error(playerid, "Con este skin no puedes usar boinas!");
						}
					}
					else
					{
						Error(playerid, "Esta barbería no tiene materiales");
					}
				}
				else
				{
					Error(playerid, "No tienes suficiente dinero para darte comprar una boina, cuesta $150");
				}
			}
			else
			{
				Error(playerid, "No te encuentras en el lugar para comprar boinas!");
			}
		}
		else
		{
			Error(playerid, "No estas en una barbería");
		}
		return true;
	}
	// COMANDO: /Comprar Peluca
	else if( !strcmp("/Comprar Peluca", cmdtext, true) )
	{
		if( PlayersData[playerid][IsPlayerInBizz] && NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_BARBERIA )
		{
			if( IsPlayerInRangeOfPoint(playerid, 2.0, NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInX_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInY_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInZ_PC]) )
			{
				if(PlayersData[playerid][Dinero] >= 150 )
				{
					if( NegociosData[PlayersData[playerid][IsPlayerInBizz]][Materiales] >= 2 )
					{
						if( IsAllowItSkinForHair(PlayersData[playerid][Skin]) )
						{
							if( IsPlayerNotFullObjects(playerid, true) != -1 )
							{
								SetMoneyExtorsion(PlayersData[playerid][IsPlayerInBizz], 150);
								GivePlayerMoneyEx(playerid, -150);
								PlayersDataOnline[playerid][TypeBuy] = TYPE_PELO;
								SetPlayerSelectedTypeHair(playerid);
							}
						}
						else
						{
							Error(playerid, "Con este skin no puedes usar pelucas!");
						}
					}
					else
					{
						Error(playerid, "Esta barbería no tiene materiales");
					}
				}
				else
				{
					Error(playerid, "No tienes suficiente dinero para darte comprar una peluca, cuesta $150");
				}
			}
			else
			{
				Error(playerid, "No te encuentras en el lugar para comprar pelucas!");
			}
		}
		else
		{
			Error(playerid, "No estas en una barbería");
		}
		return true;
	}
	// COMANDO: /Comprar Negocio
	else if( !strcmp("/Comprar Negocio", cmdtext, true) )
	{
		if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");
		new BizzId = PlayersDataOnline[playerid][InPickupNegocio];
		if( strlen(NegociosData[BizzId][Dueno]) > 1 ) return Error(playerid, "Este negocio ya tiene dueño");
		if( GetPlayerScoreEx(playerid) < 10 ) return Error(playerid, "Debes tener minimo nivel 10 para comprar un negocio");
		if(PlayersData[playerid][Dinero] >= NegociosData[BizzId][Precio] )
		{
			format(NegociosData[BizzId][Dueno], MAX_PLAYER_NAME, "%s", PlayersDataOnline[playerid][NameOnline]);
			format(NegociosData[BizzId][Extorsion], MAX_PLAYER_NAME, "No");
			DataSaveBizz(BizzId, true);
			GivePlayerMoneyEx(playerid, -NegociosData[BizzId][Precio]);
			PlayersData[playerid][Negocio] = BizzId;
			DataUserSave(playerid);
			Importante(playerid, "Compraste el negocio PN-%d tipo %s por la suma de $%d!", BizzId, NegociosTipo[NegociosData[BizzId][Type]-1], NegociosData[BizzId][Precio]);
			GameTextForPlayer(playerid, "~B~Has ~G~comprado un negocio!", 2000, 0);
		}
		else
		{
			Error(playerid, "No tienes suficiente dinero para comprar este negocio");
		}
		return true;
	}
	// COMANDO: /Comprar Agua
	else if( !strcmp("/Comprar Agua", cmdtext, true) )
	{
		if( PlayersData[playerid][IsPlayerInBizz] && NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_BAR )
		{
			if( IsPlayerInRangeOfPoint(playerid, 3.0, NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInX_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInY_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInZ_PC]) )
			{
				if(PlayersData[playerid][Dinero] >= 5 )
				{
					if( NegociosData[PlayersData[playerid][IsPlayerInBizz]][Materiales] >= 2 )
					{
						SetBuyBares(playerid, 0, true);
					}
					else
					{
						Error(playerid, "Este bar no tiene materiales");
					}
				}
				else
				{
					Error(playerid, "No tienes suficiente dinero para comprar agua, cuesta $5");
				}
			}
			else
			{
				Error(playerid, "No te encuentras cerca del la barra");
			}
		}
		else
		{
			Error(playerid, "No estas en un bar");
		}
		return true;
	}
	// COMANDO: /Comprar Refresco
	else if( !strcmp("/Comprar Refresco", cmdtext, true) )
	{
		if( PlayersData[playerid][IsPlayerInBizz] && NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_BAR )
		{
			if( IsPlayerInRangeOfPoint(playerid, 3.0, NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInX_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInY_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInZ_PC]) )
			{
				if(PlayersData[playerid][Dinero] >= 10 )
				{
					if( NegociosData[PlayersData[playerid][IsPlayerInBizz]][Materiales] >= 2 )
					{
						SetBuyBares(playerid, 1, true);
					}
					else
					{
						Error(playerid, "Este bar no tiene materiales");
					}
				}
				else
				{
					Error(playerid, "No tienes suficiente dinero para comprar un regfresco, cuesta $10");
				}
			}
			else
			{
				Error(playerid, "No te encuentras cerca del la barra");
			}
		}
		else
		{
			Error(playerid, "No estas en un bar");
		}
		return true;
	}
	else if( !strcmp("/Comprar Cerveza", cmdtext, true) )
	{
		if( PlayersData[playerid][IsPlayerInBizz] && NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_BAR )
		{
			if( IsPlayerInRangeOfPoint(playerid, 3.0, NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInX_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInY_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInZ_PC]) )
			{
				if(PlayersData[playerid][Dinero] >= 15 )
				{
					if( NegociosData[PlayersData[playerid][IsPlayerInBizz]][Materiales] >= 2 )
					{
						SetBuyBares(playerid, 2, true);
					}
					else
					{
						Error(playerid, "Este bar no tiene materiales");
					}
				}
				else
				{
					Error(playerid, "No tienes suficiente dinero para comprar una cerveza, cuesta $15");
				}
			}
			else
			{
				Error(playerid, "No te encuentras cerca del la barra");
			}
		}
		else
		{
			Error(playerid, "No estas en un bar");
		}
		return true;
	}
	else if( !strcmp("/Comprar Vodka", cmdtext, true) )
	{
		if( PlayersData[playerid][IsPlayerInBizz] && NegociosData[PlayersData[playerid][IsPlayerInBizz]][Type] == BIZZ_TYPE_BAR )
		{
			if( IsPlayerInRangeOfPoint(playerid, 3.0, NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInX_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInY_PC], NegociosData[PlayersData[playerid][IsPlayerInBizz]][PosInZ_PC]) )
			{
				if(PlayersData[playerid][Dinero] >= 20 )
				{
					if( NegociosData[PlayersData[playerid][IsPlayerInBizz]][Materiales] >= 2 )
					{
						SetBuyBares(playerid, 3, true);
					}
					else
					{
						Error(playerid, "Este bar no tiene materiales");
					}
				}
				else
				{
					Error(playerid, "No tienes suficiente dinero para comprar una botella de Vodka, cuesta $20");
				}
			}
			else
			{
				Error(playerid, "No te encuentras cerca del la barra");
			}
		}
		else
		{
			Error(playerid, "No estas en un bar");
		}
		return true;
	}
	//		/Quitar Extorsion [Usuario]
	else if( !strfind(cmdtext, "/Quitar Extorsion", true) )
	{
		if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");
		new BizzId = PlayersDataOnline[playerid][InPickupNegocio];
		if( !IsMyBizz(playerid, BizzId, true) ) return true;
		new getid;
		if( strlen(cmdtext) <= 18 || sscanf(cmdtext[18], "u", getid) ) return SendSyntaxError(playerid, "Quitar Extorsion [Usuario]", "Quitar Extorsion 4");
		if( !IsPlayerNear(playerid, getid) ) return 1;
		if( IsMyExtorsion(getid, BizzId) )
		{
			format(NegociosData[BizzId][Extorsion], MAX_PLAYER_NAME, "No");
			Importante(playerid, "Has dado el poder de extorsion de este negocio a %s", PlayersDataOnline[getid][NameOnlineFix]);
			Importante(getid, "%s te ha dado el poder de extorsionarle este negocio", PlayersDataOnline[playerid][NameOnlineFix]);
			DataSaveBizz(BizzId, true);
		}
		else
		{
			Error(playerid, "Este jugador no es extorsionista de su negocio");
		}
		return true;
	}
	// COMANDO: /Dar Extorsion [Usuario]
	else if( !strfind(cmdtext, "/Dar Extorsion", true) )
	{
		if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");
		new BizzId = PlayersDataOnline[playerid][InPickupNegocio];
		if( !IsMyBizz(playerid, BizzId, true) ) return true;
		if( strlen(NegociosData[BizzId][Extorsion]) > 2 ) return Error(playerid, "Solo puede haber un extorsionista por negocio");
		new getid;
		if( strlen(cmdtext) <= 15 || sscanf(cmdtext[15], "u", getid) ) return SendSyntaxError(playerid, "Dar Extorsion [Usuario]", "Dar Extorsion 4");
		if( IsPlayerNear(playerid, getid) )
		{
			format(NegociosData[BizzId][Extorsion], MAX_PLAYER_NAME, "%s", PlayersDataOnline[getid][NameOnline]);
			Importante(playerid, "Has dado el poder de extorsion de este negocio a %s", PlayersDataOnline[getid][NameOnlineFix]);
			Importante(getid, "%s te ha dado el poder de extorsionarle este negocio", PlayersDataOnline[playerid][NameOnlineFix]);
			DataSaveBizz(BizzId, true);
		}
		return true;
	}
	// COMANDO: /Vender Negocio
	else if( !strcmp("/Vender Negocio", cmdtext, true) )
	{
		if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");

		new BizzId = PlayersDataOnline[playerid][InPickupNegocio];
		if( IsMyBizz(playerid, BizzId, true)  )
		{
			if( !IsBizzOnRobo(playerid, BizzId) )
			{
				PlayersDataOnline[playerid][MyPickupLock] = true;
				NegociosData[BizzId][Lock] = true;
				format(NegociosData[BizzId][Dueno], MAX_PLAYER_NAME, "0");
				format(NegociosData[BizzId][Extorsion], MAX_PLAYER_NAME, "No");
				DataSaveBizz(BizzId, true);
				GivePlayerMoneyEx(playerid, NegociosData[BizzId][Precio]);
				PlayersData[playerid][Negocio] = 0;
				DataUserSave(playerid);
				Importante(playerid, "Vendio su negocio PN-%d tipo %s por el valor de $%d", BizzId, NegociosTipo[NegociosData[BizzId][Type]-1], NegociosData[BizzId][Precio]);
				GameTextForPlayer(playerid, "~B~Has ~R~vendido un negocio!", 2000, 0);
			}
		}
		return true;
	}
	//////////--- /NPos [ID]              - CAMBIAR LA POSIcion DE UN NEGOCIO
	else if( !strfind(cmdtext, "/NPos", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext[1]);
		if( strlen(cmdtext) <= 6 ) return SendSyntaxError(playerid, "NPos [ID_Negocio]", "NPos 1");
		new NewPosBizz = strval(cmdtext[6]);
		if( NewPosBizz > 0 && NewPosBizz < MAX_BIZZ_COUNT )
		{
			if(!NegociosData[NewPosBizz][Type]) return Error(playerid, "El negocio no existe");
			new Float:PlayerPosBizz[4];
			GetPlayerPos(playerid, PlayerPosBizz[0], PlayerPosBizz[1], PlayerPosBizz[2]);
			GetPlayerFacingAngle(playerid, PlayerPosBizz[3]);

			NegociosData[NewPosBizz][PosOutX] = PlayerPosBizz[0];
			NegociosData[NewPosBizz][PosOutY] = PlayerPosBizz[1];
			NegociosData[NewPosBizz][PosOutZ] = PlayerPosBizz[2];
			NegociosData[NewPosBizz][PosOutZZ] = PlayerPosBizz[3];

			DataSaveBizz(NewPosBizz, true);

			ImportanteEx(playerid, "Cambiaste la posicion del negocio ID[%i] a la: ( X: %f Y: %f Z: %f ZZ: %f )", NewPosBizz, PlayerPosBizz[0], PlayerPosBizz[1], PlayerPosBizz[2], PlayerPosBizz[3]);
		}
		else
		{
			Error(playerid, "El ID del negocio introducido no existe!");
		}
		return true;
	}
	//////////// EDITAR NEGOCIO
	else if( !strcmp(cmdtext, "/Editar Negocio Marcador", true) )
	{
		new bizzid = PlayersData[playerid][IsPlayerInBizz];
		if( !bizzid ) return Error(playerid, "Debes estar dentro de un negocio para usar este comando");
		if( PlayersData[playerid][Admin] >= 9 || IsMyBizz(playerid, bizzid, false)){
			new Float:PP[3]; GetPlayerPos(playerid, PP[0], PP[1], PP[2]);
			NegociosData[bizzid][PosInX_PC] = PP[0];
			NegociosData[bizzid][PosInY_PC] = PP[1];
			NegociosData[bizzid][PosInZ_PC] = PP[2];
			DataSaveBizz(bizzid, false);

			Importante(playerid, "Moviste de lugar el marcador del negocio!");
			SetFunctionsForBizz(playerid, bizzid);
		}
		else Error(playerid, "No puede cambiar de lugar el marcador de un negocio que no es suyo!");
		return true;
	}
	//////////// /NPRECIO
	else if( !strfind(cmdtext, "/NPrecio", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext[1]);
	
		if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");
		if( strlen(cmdtext) <= 9 ) return SendSyntaxError(playerid, "NPrecio [Precio]", "NPrecio 150000");
		new BizzId = PlayersDataOnline[playerid][InPickupNegocio];
		new newPrice = strval(cmdtext[9]);

		if( newPrice >= 0 && newPrice <= 500000 )
		{
			NegociosData[BizzId][Precio] = newPrice;
			DataSaveBizz(BizzId, true);
			ImportanteEx(playerid, "Cambiaste el precio de este negocio a: $%d", newPrice);
		}
		else
		{
			Error(playerid, "El precio de negocio introducído tiene que estar entre 0 y 500000");
		}
		return true;
	}
	//////////--- /Ntipo [Tipo] [Modelo]
	else if( !strfind(cmdtext, "/Ntipo", true) )
	{
		if(PlayersData[playerid][Admin] < 8 && !PlayersData[playerid][Mapper]) return SendAccessError(playerid, cmdtext[1]);
		
		new bizzType, bizzModel;
		if(strlen(cmdtext) <= 7 || sscanf(cmdtext[7], "ii", bizzType, bizzModel))
		{
			SendSyntaxError(playerid, "NTipo [ID_Tipo] [ID_Modelo]", "NTipo 1 1");
			ShowBizzModels(playerid);
			return 1;
		}
		if( bizzType < 1 || bizzType > sizeof(NegociosTipo) )
		{
			Error(playerid, "Tipo de negocio invalido.");
			ShowBizzTypes(playerid);
			return 1;
		}
		bizzType--;
		new MaxBizzModels = GetMaxBizzModelsByType(bizzType);
		if( MaxBizzModels == -1 ) return Error(playerid, "Este tipo de negocio no tiene un interior programado! Use /Crear Modelo Negocio");
		if( bizzModel < 1 || bizzModel > (MaxBizzModels+1) )
		{
			Error(playerid, "Modelo de negocio invalido!");
			ShowBizzModelsOfType(playerid, bizzType);
			return 1;
		}
		bizzModel--;
		if( !NegociosModelos[bizzType][bizzModel][InteriorId] ) return Error(playerid, "Ese interior no existe.");
		if( PlayersDataOnline[playerid][InPickupNegocio] )
		{
			new bizzid = PlayersDataOnline[playerid][InPickupNegocio];
			if( NegociosData[bizzid][Type] == (bizzType+1) && NegociosData[bizzid][NModel] == (bizzModel+1) ) return Error(playerid, "Ese negocio ya tiene ese interior configurado!");
			ImportanteEx(playerid, "Cambiaste el negocio %d de: \"%s\"[%s] a \"%s\"[%s]", bizzid, \
				NegociosModelos[NegociosData[bizzid][Type]-1][NegociosData[bizzid][NModel]-1][TypeName], NegociosTipo[NegociosData[bizzid][Type]-1], \
				NegociosModelos[bizzType][bizzModel][TypeName], NegociosTipo[bizzType]);

			NegociosData[bizzid][Type] = bizzType+1;
			NegociosData[bizzid][NModel] = bizzModel+1;
			NegociosData[bizzid][PosInX_PC] = NegociosModelos[bizzType][bizzModel][PosInX_PC];
			NegociosData[bizzid][PosInY_PC] = NegociosModelos[bizzType][bizzModel][PosInY_PC];
			NegociosData[bizzid][PosInZ_PC] = NegociosModelos[bizzType][bizzModel][PosInZ_PC];
			if( NegociosData[bizzid][Type] != BIZZ_TYPE_DISCOTECA || 
				NegociosData[bizzid][Type] != BIZZ_TYPE_CASINO )
			NegociosData[bizzid][PriceJoin] = 0;
			DataSaveBizz(bizzid, true);
		}
		else
		{
			SetPlayerPos(playerid, NegociosModelos[bizzType][bizzModel][PosInX], NegociosModelos[bizzType][bizzModel][PosInY], NegociosModelos[bizzType][bizzModel][PosInZ]);
			SetPlayerInteriorEx(playerid, NegociosModelos[bizzType][bizzModel][InteriorId]);
			SetPlayerCheckpoint(playerid, NegociosModelos[bizzType][bizzModel][PosInX_PC], NegociosModelos[bizzType][bizzModel][PosInY_PC], NegociosModelos[bizzType][bizzModel][PosInZ_PC], 1.0);

			Advise(playerid, "Fuiste al modelo \"%s\"[%d] del tipo de negocio \"%s\"[%d]", NegociosModelos[bizzType][bizzModel][TypeName], bizzModel+1, NegociosTipo[bizzType], bizzType+1);
		}
		return true;
	}
	/////////////////EDITAR MODELO NEGOCIO [Tipo] [Modelo]
	else if( !strfind(cmdtext, "/Editar Modelo Negocio", true) )
	{
		if(PlayersData[playerid][Admin] < 9) return SendAccessError(playerid, "Editar Modelo Negocio");
		new bizzType, bizzModel;
		if( strlen(cmdtext) <= 23 || sscanf(cmdtext[23], "dd", bizzType, bizzModel)) return SendSyntaxError(playerid, "Editar Modelo Negocio [Tipo] [Modelo]", "Editar Modelo Negocio 1 1");
		if(bizzType >= 1 && bizzType <= sizeof(NegociosTipo) )
		{
			bizzType--;
			new MaxBizzModels = GetMaxBizzModelsByType(bizzType);
			if( MaxBizzModels == -1 ) return Error(playerid, "Este tipo de negocio no tiene programado interiores! Use /Crear Modelo Negocio");
			if( bizzModel >= 1 && bizzModel <= (MaxBizzModels+1) )
			{
				bizzModel--;
				if(!NegociosModelos[bizzType][bizzModel][InteriorId]) return Error(playerid, "Ese interior no existe.");
				ShowPlayerBizzTypesModels(playerid, bizzType, bizzModel);
			}
			else{
				Error(playerid, "Modelo de negocio invalido!");
				ShowBizzModelsOfType(playerid, bizzType);
			}
		}
		else{
			Error(playerid, "Tipo de negocio invalido.");
			ShowBizzTypes(playerid);
		}
		return true;
	}
	//////////--- /VNegocio	              - VENDER UN NEGOCIO
	else if( !strcmp("/Vnegocio", cmdtext, true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 8 ) return SendAccessError(playerid, cmdtext[1]);
		if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No te encuentras en ningun negocio");
		
		new BizzId = PlayersDataOnline[playerid][InPickupNegocio];
		if( strlen(NegociosData[BizzId][Dueno]) > 1 )
		{
			ImportanteEx(playerid, "Has vendido este negocio al estado, erá propiedad de %s", NegociosData[BizzId][Dueno]);
			RemoveDuenoOfBizz(BizzId);
		}
		else
		{
			Error(playerid, "Este negocio ya no tiene dueño");
		}
		return true;
	}
	//			/IrN [ID]					- Ir a un negocio
	else if( !strfind(cmdtext, "/IrN", true) )
	{
		MsgAdminUseCommands(9, playerid, cmdtext);
		if( PlayersData[playerid][Admin] < 7 ) return SendAccessError(playerid, cmdtext[1]);
		if( strlen(cmdtext) <= 5 ) return SendSyntaxError(playerid, "IrN [ID_Negocio]", "IrN 1");
		new BizzID = strval(cmdtext[5]);
		if( BizzID > 0 && BizzID < MAX_BIZZ_COUNT )
		{
			if(!NegociosData[BizzID][Type]) return Error(playerid, "ID de negocio introducido no existe");
			SetPlayerPos(playerid, NegociosData[BizzID][PosOutX], NegociosData[BizzID][PosOutY], NegociosData[BizzID][PosOutZ]);
			SetPlayerFacingAngle(playerid, NegociosData[BizzID][PosOutZZ]);
			Advise(playerid, "Fuiste al negocio %d", BizzID);
		}
		else
		{
			Error(playerid, "El ID de negocio introducido es invalida!");
		}
		return true;
	}
	//		/Borrar Negocio [ID (Opcional)]
	else if( !strfind(cmdtext, "/Borrar Negocio", true) )
	{
		if(PlayersData[playerid][Admin] < 9) return SendAccessError(playerid, "Borrar Negocio");
		new bizzid;
		if(strlen(cmdtext) >= 16){
			if(strlen(cmdtext) > 16){
				bizzid = strval(cmdtext[16]);
				if( bizzid < 1 || bizzid >= MAX_BIZZ_COUNT ) return Error(playerid, "ID de negocio invalida!");
				if( !NegociosData[bizzid][Type] ) return Error(playerid, "El negocio ya no existe.");
			}
			else SendSyntaxError(playerid, "Borrar Negocio [ID_Negocio (Opcional)]", "Borrar Negocio 10 o use /Borrar Negocio en la puerta de uno");
		}
		else{
			if( !PlayersDataOnline[playerid][InPickupNegocio] ) return Error(playerid, "No se encuentra en la puerta de ningun negocio!");
			bizzid = PlayersDataOnline[playerid][InPickupNegocio];
		}
		if( bizzid )
		{
			if(strlen(NegociosData[bizzid][Dueno]) > 1)
			ImportanteEx(playerid, "Borraste el negocio %s[%i], ID: %i, Precio: $%i, Propietario: %s", NegociosTipo[NegociosData[bizzid][Type]-1], NegociosData[bizzid][Type], bizzid, NegociosData[bizzid][Precio], NegociosData[bizzid][Dueno]);
			else
			ImportanteEx(playerid, "Borraste el negocio %s[%i], ID: %i, Precio: $%i", NegociosTipo[NegociosData[bizzid][Type]-1], NegociosData[bizzid][Type], bizzid, NegociosData[bizzid][Precio]);
			BorrarNegocio(bizzid);
		}
		return true;
	}
	// COMANDO: /Info Negocio
	else if( !strcmp("/Info Negocio", cmdtext, true) )
	{
		new bizzid = PlayersDataOnline[playerid][InPickupNegocio];
		if( !bizzid ) return Error(playerid, "No te encuentras en ningun negocio");
		
		if( PlayersData[playerid][Admin] >= 7 || IsMyBizz(playerid, bizzid, true) )
		{
			new MsgInfoNegocio[6][150];
			format(MsgInfoNegocio[0], 150, "(( ID del Negocio: %i ))Nombre del Negocio: %s | Materiales: [%i/5000]", bizzid, NegociosData[bizzid][NameBizz], NegociosData[bizzid][Materiales]);
			format(MsgInfoNegocio[1], 150, "Precio Entrada: $%i", NegociosData[bizzid][PriceJoin]);
			format(MsgInfoNegocio[2], 150, "Precio que paga por Materiales(0  = Deshabilitado): $%i", NegociosData[bizzid][PricePiece]);
			format(MsgInfoNegocio[3], 150, "Deposito: $%i", NegociosData[bizzid][Deposito]);
			format(MsgInfoNegocio[4], 150, "Dinero extorsionado: $%i", NegociosData[bizzid][DepositoExtorsion]);
			format(MsgInfoNegocio[5], 150, "Precio del negocio: $%i", NegociosData[bizzid][Precio]);

			SendInfoMessage(playerid, 1, " ", "|____________________ Negocio ___________________|");
			SendInfoMessage(playerid, 1, MsgInfoNegocio[0], "Negocio: ");
			SendInfoMessage(playerid, 1, MsgInfoNegocio[1], "Negocio: ");
			SendInfoMessage(playerid, 1, MsgInfoNegocio[2], "Negocio: ");
			SendInfoMessage(playerid, 1, MsgInfoNegocio[3], "Negocio: ");
			SendInfoMessage(playerid, 1, MsgInfoNegocio[4], "Negocio: ");
			SendInfoMessage(playerid, 1, MsgInfoNegocio[5], "Negocio: ");
			SendInfoMessage(playerid, 1, " ", "|_____________________ Fin ____________________|");
		}
		return true;
	}
	return false;
}