SaveImpuestos(){
	new query[300], Cache:cacheid, rowExist;
	format(query, sizeof(query), "SELECT ID FROM %s WHERE ID=1;", DIR_IMPUESTOS);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(rowExist);
	cache_delete(cacheid);
	if(!rowExist)
	{
		format(query, sizeof(query), "INSERT INTO `%s`(`ID`,`alicuotaCasas`,`alicuotaNegocios`,`alicuotaVehiculos`,`precioPeajesParqueos`,`precioCombustible`) \
			VALUES ('1','%f','%f','%f','%d','%d');", DIR_IMPUESTOS,
			alicuotaCasas,
			alicuotaNegocios,
			alicuotaVehiculos,
			precioPeajesParqueos,
			precioCombustible);
		mysql_query(dataBase, query, false);
		return 1;
	}
	format(query, sizeof(query), "UPDATE %s SET `alicuotaCasas`='%f',`alicuotaNegocios`='%f',`alicuotaVehiculos`='%f',`precioPeajesParqueos`='%d',`precioCombustible`='%d' WHERE ID=1;",
		DIR_IMPUESTOS,
		alicuotaCasas,
		alicuotaNegocios,
		alicuotaVehiculos,
		precioPeajesParqueos,
		precioCombustible);
	mysql_query(dataBase, query, false);
	printf("[%s]: Impuestos guardados!", DIR_IMPUESTOS);
	return 1;
}

LoadImpuestos(){
	new query[300], Cache:cacheid, rowExist;
	format(query, sizeof(query), "SELECT * FROM %s WHERE ID=1;", DIR_IMPUESTOS);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(rowExist);
	if(rowExist)
	{
		cache_get_value_index_float(0, 1, alicuotaCasas);
		cache_get_value_index_float(0, 2, alicuotaNegocios);
		cache_get_value_index_float(0, 3, alicuotaVehiculos);
		cache_get_value_index_int(0, 4, precioPeajesParqueos);
		cache_get_value_index_int(0, 5, precioCombustible);
		printf("[%s]: Impuestos cargados!", DIR_IMPUESTOS);
	}
	else{
		printf("[%s]: Error al cargar impuestos desde la DB!", DIR_IMPUESTOS);
		printf("[%s]: Configurando impuestos a valores default...Ok", DIR_IMPUESTOS);
	}
	cache_delete(cacheid);
}

ShowImpuestos(playerid)
{
	new info[1024];//, caption[64];
	new paga = FaccionData[PlayersData[playerid][Faccion]][Paga][PlayersData[playerid][Rango]],
		intereses = PlayersData[playerid][Banco] / 2000,
		Float:impuestos,
		Float:impuesto;
	format(info, sizeof(info), "Paga Actual\t{"COLOR_VERDE"}+$%i\n", paga);
	format(info, sizeof(info), "%sIntereses del Banco\t{"COLOR_VERDE"}+$%i\n", info, intereses);
	format(info, sizeof(info), "%s \t \n", info);
	if(PlayersData[playerid][Alquiler] != -1)
	{
		format(info, sizeof(info), "%sAlquiler PC-%i\t{"COLOR_ROJO"}-$%i\n", info, PlayersData[playerid][Alquiler], HouseData[PlayersData[playerid][Alquiler]][PriceRent]);
		impuestos += HouseData[PlayersData[playerid][Alquiler]][PriceRent];
	}
	if(PlayersData[playerid][House] != -1)
	{
		impuesto = floatdiv(floatmul(HouseData[PlayersData[playerid][House]][Price], alicuotaCasas), 100);
		format(info, sizeof(info), "%sCasa PC-%i\t{"COLOR_ROJO"}-$%i\n", info, PlayersData[playerid][House], floatround(impuesto, floatround_tozero));
		impuestos += impuesto;
	}
	if(PlayersData[playerid][Negocio])
	{
		impuesto = floatdiv(floatmul(NegociosData[PlayersData[playerid][Negocio]][Precio], alicuotaNegocios), 100);
		format(info, sizeof(info), "%sNegocio PN-%i\t{"COLOR_ROJO"}-$%i\n", info, PlayersData[playerid][Negocio], floatround(impuesto, floatround_tozero));
		impuestos += impuesto;
	}
	if(PlayersData[playerid][Car] != -1)
	{
		impuesto = floatdiv(floatmul(coches_Todos_Precios[DataCars[PlayersData[playerid][Car]][Modelo] - 400], alicuotaVehiculos), 100);
		format(info, sizeof(info), "%sVehiculo %s ((ID: %i))\t{"COLOR_ROJO"}-$%i\n", info, coches_Todos_Nombres[DataCars[PlayersData[playerid][Car]][Modelo] - 400], PlayersData[playerid][Car], floatround(impuesto, floatround_tozero));
		impuestos += impuesto;
	}
	new totalWin = (paga + intereses),
		totalLost = floatround(impuestos, floatround_tozero);
	new total = totalWin - totalLost;
	format(info, sizeof(info), "%s \t \n", info);
	format(info, sizeof(info), "%sTotal Ingresos\t{"COLOR_VERDE"}+$%i\n", info, totalWin);
	format(info, sizeof(info), "%sTotal Egresos\t{"COLOR_ROJO"}-$%i\n", info, totalLost);
	format(info, sizeof(info), "%s \t \n", info);
	if(total >= 0)
	format(info, sizeof(info), "%sSaldo Final\t{"COLOR_VERDE"}+$%i\n", info, totalWin - totalLost);
	else
	format(info, sizeof(info), "%sSaldo Final\t{"COLOR_ROJO"}-$%i\n", info, totalLost - totalWin);
	ShowPlayerDialogEx(playerid, 999, DIALOG_STYLE_TABLIST, "{"COLOR_AZUL"}Impuestos", info, "Cerrar", "");
}

ShowEditarImpuestos(playerid)
{
	new info[1024];
	format(info, sizeof(info), "> Inmuebles:\t\n");
	format(info, sizeof(info), "%sTasa Imponible Viviendas: %.4f%%\t{"COLOR_VERDE"}Editar\n", info, PlayersDataOnline[playerid][pAlicuotas][0]);
	format(info, sizeof(info), "%sTasa Imponible Negocios: %.4f%%\t{"COLOR_VERDE"}Editar\n", info, PlayersDataOnline[playerid][pAlicuotas][1]);
	format(info, sizeof(info), "%s> Muebles:\t\n", info);
	format(info, sizeof(info), "%sTasa Imponible Vehiculos: %.4f%%\t{"COLOR_VERDE"}Editar\n", info, PlayersDataOnline[playerid][pAlicuotas][2]);
	format(info, sizeof(info), "%s> Servicios:\t\n", info);
	format(info, sizeof(info), "%sPeajes y Parqueos: $%d\t{"COLOR_VERDE"}Editar\n", info, PlayersDataOnline[playerid][pPrecioPeaje]);
	format(info, sizeof(info), "%sCombustbile: $%d x L\t{"COLOR_VERDE"}Editar\n", info, PlayersDataOnline[playerid][pPrecioCombustible]);
	format(info, sizeof(info), "%s{"COLOR_AZUL"}Simular Impuestos\t{"COLOR_VERDE"}Confirmar Cambios\n", info);

	ShowPlayerDialogEx(playerid, 183, DIALOG_STYLE_TABLIST, "{"COLOR_AZUL"}Editar Impuestos", info, "Seleccionar", "Cerrar");
}

ShowEditarImpuestosOpcion(playerid, opcion)
{
	PlayersDataOnline[playerid][SaveAfterAgenda][0] = opcion;
	new caption[64], info[1024];
	format(caption, sizeof(caption), "{"COLOR_AZUL"}Editar Impuestos");
	format(info, sizeof(info), "{"COLOR_CREMA"}");
	if(opcion == 1)
	{
		format(caption, sizeof(caption), "%s -> Viviendas", caption);
		format(info, sizeof(info), "%sTasa Impositiva de Viviendas: %.4f%%\nIngrese un nuevo porcentaje:", info, PlayersDataOnline[playerid][pAlicuotas][0]);
	}
	else if(opcion == 2)
	{
		format(caption, sizeof(caption), "%s -> Negocios", caption);
		format(info, sizeof(info), "%sTasa Impositiva de Negocios: %.4f%%\nIngrese un nuevo porcentaje:", info, PlayersDataOnline[playerid][pAlicuotas][1]);
	}
	else if(opcion == 3)
	{
		format(caption, sizeof(caption), "%s -> Vehiculos", caption);
		format(info, sizeof(info), "%sTasa Impositiva de Vehiculos: %.4f%%\nIngrese un nuevo porcentaje:", info, PlayersDataOnline[playerid][pAlicuotas][2]);
	}
	else if(opcion == 4)
	{
		format(caption, sizeof(caption), "%s -> Peajes y Parqueos", caption);
		format(info, sizeof(info), "%sPrecio de Peajes y Parqueos: $%d\nIngrese un nuevo monto:", info, PlayersDataOnline[playerid][pPrecioPeaje]);
	}
	else if(opcion == 5)
	{
		format(caption, sizeof(caption), "%s -> Combustible", caption);
		format(info, sizeof(info), "%sPrecio de Combustible: $%d\nIngrese un nuevo monto:", info, PlayersDataOnline[playerid][pPrecioCombustible]);
	}
	// format(info, sizeof(info), "%s                 ", info);//para q se vea el titulo bien

	ShowPlayerDialogEx(playerid, 184, DIALOG_STYLE_INPUT, caption, info, "Editar", "Cancelar");
}

ShowSimularImpuestos(playerid)
{
	new info[1024];
	new paga = 500,
		intereses = 10,
		Float:impuestos,
		Float:impuesto;
	format(info, sizeof(info), "Paga Actual\t{"COLOR_VERDE"}+$%d\n", paga);
	format(info, sizeof(info), "%sIntereses del Banco\t{"COLOR_VERDE"}+$%d\n", info, intereses);
	format(info, sizeof(info), "%s \t \n", info);

	impuesto = floatdiv(floatmul(80000, PlayersDataOnline[playerid][pAlicuotas][0]), 100);
	impuestos += impuesto;
	format(info, sizeof(info), "%sCasa $80000\t{"COLOR_ROJO"}-$%d\n", info, floatround(impuesto, floatround_tozero));

	impuesto = floatdiv(floatmul(150000, PlayersDataOnline[playerid][pAlicuotas][1]), 100);
	impuestos += impuesto;
	format(info, sizeof(info), "%sNegocio $150000\t{"COLOR_ROJO"}-$%d\n", info, floatround(impuesto, floatround_tozero));
	
	impuesto = floatdiv(floatmul(coches_Todos_Precios[122], PlayersDataOnline[playerid][pAlicuotas][2]), 100);
	impuestos += impuesto;
	format(info, sizeof(info), "%sVehiculo %s $%d\t{"COLOR_ROJO"}-$%d\n", info, coches_Todos_Nombres[122], coches_Todos_Precios[122], floatround(impuesto, floatround_tozero));
	
	if(PlayersDataOnline[playerid][pPrecioPeaje] != precioPeajesParqueos)
	format(info, sizeof(info), "%sPeajes y Parqueos\t{"COLOR_AZUL"}$%d a $%d\n", info, precioPeajesParqueos, PlayersDataOnline[playerid][pPrecioPeaje]);
	if(PlayersDataOnline[playerid][pPrecioCombustible] != precioCombustible)
	format(info, sizeof(info), "%sCombustible\t{"COLOR_AZUL"}$%d a $%d\n", info, precioCombustible, PlayersDataOnline[playerid][pPrecioCombustible]);

	new totalWin = (paga + intereses),
		totalLost = floatround(impuestos, floatround_tozero);
	new total = totalWin - totalLost;
	format(info, sizeof(info), "%s \t \n", info);
	format(info, sizeof(info), "%sTotal Ingresos\t{"COLOR_VERDE"}+$%d\n", info, totalWin);
	format(info, sizeof(info), "%sTotal Egresos\t{"COLOR_ROJO"}-$%d\n", info, totalLost);
	format(info, sizeof(info), "%s \t \n", info);
	if(total >= 0)
	format(info, sizeof(info), "%sSaldo Final\t{"COLOR_VERDE"}+$%d\n", info, totalWin - totalLost);
	else
	format(info, sizeof(info), "%sSaldo Final\t{"COLOR_ROJO"}-$%d\n", info, totalLost - totalWin);
	ShowPlayerDialogEx(playerid, 185, DIALOG_STYLE_TABLIST, "{"COLOR_AZUL"}Impuestos Simulados", info, "Confirmar", "Volver");
}