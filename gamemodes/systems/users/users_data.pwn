
DataUserLoad(playerid)
{
	new query[500], Cache:cacheid, cuentaExiste;

	mysql_format(dataBase, query, 500, "SELECT * FROM `%s` WHERE `Nombre`='%e';", DIR_USERS, PlayersDataOnline[playerid][NameOnline]);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(cuentaExiste);

	if ( cuentaExiste )
	{
		new WeaponsData[50], AmmoData[50];

		cache_get_value_name_int(0, "ID", PlayersData[playerid][DB_ID]);
		cache_get_value_name(0, "Email", PlayersData[playerid][Email], 60);
		cache_get_value_name(0, "Password", PlayersData[playerid][Password], 61);
		cache_get_value_name_int(0, "AccountState", PlayersData[playerid][AccountState]);
		cache_get_value_name_float(0, "Spawn_X", PlayersData[playerid][Spawn_X]);
		cache_get_value_name_float(0, "Spawn_Y", PlayersData[playerid][Spawn_Y]);
		cache_get_value_name_float(0, "Spawn_Z", PlayersData[playerid][Spawn_Z]);
		cache_get_value_name_float(0, "Spawn_ZZ", PlayersData[playerid][Spawn_ZZ]);
		cache_get_value_name_int(0, "HoursPlaying", PlayersData[playerid][HoursPlaying]);
		cache_get_value_name_int(0, "DeahtCount", PlayersData[playerid][DeahtCount]);

		cache_get_value_name_int(0, "KilledCount", PlayersData[playerid][KilledCount]);
		cache_get_value_name_int(0, "Phone", PlayersData[playerid][Phone]);
		cache_get_value_name_int(0, "House", PlayersData[playerid][House]);
		cache_get_value_name_int(0, "Negocio", PlayersData[playerid][Negocio]);
		cache_get_value_name_int(0, "Car", PlayersData[playerid][Car]);
		cache_get_value_name_int(0, "Faccion", PlayersData[playerid][Faccion]);
		cache_get_value_name_int(0, "Rango", PlayersData[playerid][Rango]);
		cache_get_value_name(0, "GirlFreind", PlayersData[playerid][GirlFreind], MAX_PLAYER_NAME);
		cache_get_value_name_int(0, "Bolsillos0", PlayersData[playerid][Bolsillos][0]);
		cache_get_value_name_int(0, "Bolsillos1", PlayersData[playerid][Bolsillos][1]);
		cache_get_value_name_int(0, "Bolsillos2", PlayersData[playerid][Bolsillos][2]);

		cache_get_value_name_int(0, "Bolsillos3", PlayersData[playerid][Bolsillos][3]);
		cache_get_value_name_int(0, "Bolsillos4", PlayersData[playerid][Bolsillos][4]);
		cache_get_value_name_int(0, "Habilidad", PlayersData[playerid][Habilidad]);
		cache_get_value_name_int(0, "Warn", PlayersData[playerid][Warn]);
		cache_get_value_name_int(0, "Ciudad", PlayersData[playerid][Ciudad]);
		cache_get_value_name_float(0, "Vida", PlayersData[playerid][Vida]);
		cache_get_value_name_float(0, "Chaleco", PlayersData[playerid][Chaleco]);
		cache_get_value_name_int(0, "Cansansio", PlayersData[playerid][Cansansio]);
		cache_get_value_name_int(0, "Dinero", PlayersData[playerid][Dinero]);
		cache_get_value_name_int(0, "Banco", PlayersData[playerid][Banco]);

		cache_get_value_name_int(0, "Jail", PlayersData[playerid][Jail]);
		cache_get_value_name_int(0, "Admin", PlayersData[playerid][Admin]);
		cache_get_value_name_int(0, "World", PlayersData[playerid][World]);
		cache_get_value_name_int(0, "Interior", PlayersData[playerid][Interior]);
		cache_get_value_name_int(0, "Skin", PlayersData[playerid][Skin]);
		cache_get_value_name_int(0, "Drogas", PlayersData[playerid][Drogas]);
		cache_get_value_name_int(0, "Materiales", PlayersData[playerid][Materiales]);
		cache_get_value_name_int(0, "Lata", PlayersData[playerid][Lata]);
		cache_get_value_name_int(0, "Ganzuas", PlayersData[playerid][Ganzuas]);
		cache_get_value_name_int(0, "Alquiler", PlayersData[playerid][Alquiler]);

		cache_get_value_name_int(0, "Bombas", PlayersData[playerid][Bombas]);
		cache_get_value_name_int(0, "Sexo", PlayersData[playerid][Sexo]);
		cache_get_value_name_int(0, "Idiomas0", PlayersData[playerid][Idiomas][0]);
		cache_get_value_name_int(0, "Idiomas1", PlayersData[playerid][Idiomas][1]);
		cache_get_value_name_int(0, "Idiomas2", PlayersData[playerid][Idiomas][2]);
		cache_get_value_name_int(0, "Idiomas3", PlayersData[playerid][Idiomas][3]);
		cache_get_value_name_int(0, "Idiomas4", PlayersData[playerid][Idiomas][4]);
		cache_get_value_name_int(0, "Idiomas5", PlayersData[playerid][Idiomas][5]);
		cache_get_value_name_int(0, "Licencias0", PlayersData[playerid][Licencias][0]);
		cache_get_value_name_int(0, "Licencias1", PlayersData[playerid][Licencias][1]);

		cache_get_value_name_int(0, "Licencias2", PlayersData[playerid][Licencias][2]);
		cache_get_value_name_int(0, "Licencias3", PlayersData[playerid][Licencias][3]);
		cache_get_value_name_int(0, "Licencias4", PlayersData[playerid][Licencias][4]);
		cache_get_value_name_int(0, "Licencias5", PlayersData[playerid][Licencias][5]);
		cache_get_value_name_int(0, "Licencias6", PlayersData[playerid][Licencias][6]);
		cache_get_value_name_int(0, "IsInJail", PlayersData[playerid][IsInJail]);
		cache_get_value_name_int(0, "Nacer", PlayersData[playerid][Nacer]);
		cache_get_value_name_int(0, "TimeRequestBank", PlayersData[playerid][TimeRequestBank]);
		cache_get_value_name_int(0, "MyBonus", PlayersData[playerid][MyBonus]);
		cache_get_value_name_int(0, "InTutorial", PlayersData[playerid][InTutorial]);

		cache_get_value_name_int(0, "Edad", PlayersData[playerid][Edad]);
		cache_get_value_name_int(0, "IsPlayerInHouse", PlayersData[playerid][IsPlayerInHouse]);
		cache_get_value_name_int(0, "TimeEquipo", PlayersData[playerid][TimeEquipo]);
		cache_get_value_name_int(0, "SpawnAmigo", PlayersData[playerid][SpawnAmigo]);
		cache_get_value_name_int(0, "IsPaga", PlayersData[playerid][IsPaga]);
		cache_get_value_name(0, "MyIP", PlayersData[playerid][MyIP], 16);
		cache_get_value_name_int(0, "Job", PlayersData[playerid][Job]);
		cache_get_value_name_int(0, "MyStyleWalk", PlayersData[playerid][MyStyleWalk]);
		cache_get_value_name_int(0, "Saldo", PlayersData[playerid][Saldo]);
		cache_get_value_name_int(0, "LicenciaPesca", PlayersData[playerid][LicenciaPesca]);

		cache_get_value_name_int(0, "IntermitentState", PlayersData[playerid][IntermitentState]);
		cache_get_value_name_int(0, "MyStyleTalk", PlayersData[playerid][MyStyleTalk]);
		cache_get_value_name_int(0, "IsPlayerInBizz", PlayersData[playerid][IsPlayerInBizz]);
		cache_get_value_name_int(0, "IsPlayerInGarage", PlayersData[playerid][IsPlayerInGarage]);
		cache_get_value_name(0, "WeaponS", WeaponsData, 50);
		cache_get_value_name(0, "AmmoS", AmmoData, 50);
		cache_get_value_name_int(0, "Asignados0", PlayersData[playerid][Asignados][0]);
		cache_get_value_name_int(0, "Asignados1", PlayersData[playerid][Asignados][1]);
		cache_get_value_name_int(0, "Asignados2", PlayersData[playerid][Asignados][2]);
		cache_get_value_name_int(0, "Bolsa0", PlayersData[playerid][Bolsa][0]);

		cache_get_value_name_int(0, "Bolsa1", PlayersData[playerid][Bolsa][1]);
		cache_get_value_name_int(0, "Bolsa2", PlayersData[playerid][Bolsa][2]);
		cache_get_value_name_int(0, "Bolsa3", PlayersData[playerid][Bolsa][3]);
		cache_get_value_name_int(0, "BolsaC0", PlayersData[playerid][BolsaC][0]);
		cache_get_value_name_int(0, "BolsaC1", PlayersData[playerid][BolsaC][1]);
		cache_get_value_name_int(0, "BolsaC2", PlayersData[playerid][BolsaC][2]);
		cache_get_value_name_int(0, "BolsaC3", PlayersData[playerid][BolsaC][3]);
		cache_get_value_name_int(0, "HaveBolsa", PlayersData[playerid][HaveBolsa]);
		cache_get_value_name_int(0, "IsPlayerInVehInt", PlayersData[playerid][IsPlayerInVehInt]);
		cache_get_value_name_int(0, "Cartera0", PlayersData[playerid][Cartera][0]);

		cache_get_value_name_int(0, "Cartera1", PlayersData[playerid][Cartera][1]);
		cache_get_value_name_int(0, "Cartera2", PlayersData[playerid][Cartera][2]);
		cache_get_value_name_int(0, "Cartera3", PlayersData[playerid][Cartera][3]);
		cache_get_value_name_int(0, "Cartera4", PlayersData[playerid][Cartera][4]);
		cache_get_value_name_int(0, "Cartera5", PlayersData[playerid][Cartera][5]);
		cache_get_value_name_int(0, "CarteraC0", PlayersData[playerid][CarteraC][0]);
		cache_get_value_name_int(0, "CarteraC1", PlayersData[playerid][CarteraC][1]);
		cache_get_value_name_int(0, "CarteraC2", PlayersData[playerid][CarteraC][2]);
		cache_get_value_name_int(0, "CarteraC3", PlayersData[playerid][CarteraC][3]);
		cache_get_value_name_int(0, "CarteraC4", PlayersData[playerid][CarteraC][4]);

		cache_get_value_name_int(0, "CarteraC5", PlayersData[playerid][CarteraC][5]);
		cache_get_value_name_int(0, "CarteraT0", PlayersData[playerid][CarteraT][0]);
		cache_get_value_name_int(0, "CarteraT1", PlayersData[playerid][CarteraT][1]);
		cache_get_value_name_int(0, "CarteraT2", PlayersData[playerid][CarteraT][2]);
		cache_get_value_name_int(0, "CarteraT3", PlayersData[playerid][CarteraT][3]);
		cache_get_value_name_int(0, "CarteraT4", PlayersData[playerid][CarteraT][4]);
		cache_get_value_name_int(0, "CarteraT5", PlayersData[playerid][CarteraT][5]);
		cache_get_value_name_int(0, "AccountBankingOpen", PlayersData[playerid][AccountBankingOpen]);
		cache_get_value_name_int(0, "CarteraI0", PlayersData[playerid][CarteraI][0]);
		cache_get_value_name_int(0, "CarteraI1", PlayersData[playerid][CarteraI][1]);

		cache_get_value_name_int(0, "CarteraI2", PlayersData[playerid][CarteraI][2]);
		cache_get_value_name_int(0, "CarteraI3", PlayersData[playerid][CarteraI][3]);
		cache_get_value_name_int(0, "CarteraI4", PlayersData[playerid][CarteraI][4]);
		cache_get_value_name_int(0, "CarteraI5", PlayersData[playerid][CarteraI][5]);
		cache_get_value_name_int(0, "IsPlayerInBank", PlayersData[playerid][IsPlayerInBank]);
		cache_get_value_name_int(0, "AlertSMSBank", PlayersData[playerid][AlertSMSBank]);
		cache_get_value_name_int(0, "HorasWork", PlayersData[playerid][HorasWork]);
		cache_get_value_name_int(0, "CameraLogin", PlayersData[playerid][CameraLogin]);
		cache_get_value_name_int(0, "Enfermedad", PlayersData[playerid][Enfermedad]);
		cache_get_value_name_int(0, "Description", PlayersData[playerid][Description]);

		cache_get_value_name_int(0, "EnableDescription", PlayersData[playerid][EnableDescription]);
		cache_get_value_name(0, "DescriptionString", PlayersData[playerid][DescriptionString], MAX_TEXT_DESCRIPTION);
		cache_get_value_name_int(0, "DescriptionColor", PlayersData[playerid][DescriptionColor]);
		cache_get_value_name_int(0, "DescriptionSelect", PlayersData[playerid][DescriptionSelect]);
		cache_get_value_name_int(0, "SpawnFac", PlayersData[playerid][SpawnFac]);
		cache_get_value_name_int(0, "Objetos0", PlayersData[playerid][Objetos][0]);
		cache_get_value_name_int(0, "Objetos1", PlayersData[playerid][Objetos][1]);
		cache_get_value_name_int(0, "Objetos2", PlayersData[playerid][Objetos][2]);
		cache_get_value_name_int(0, "Objetos3", PlayersData[playerid][Objetos][3]);

		cache_get_value_name_int(0, "Objetos4", PlayersData[playerid][Objetos][4]);
		cache_get_value_name_int(0, "Objetos5", PlayersData[playerid][Objetos][5]);
		cache_get_value_name_int(0, "Objetos6", PlayersData[playerid][Objetos][6]);
		cache_get_value_name_int(0, "Objetos7", PlayersData[playerid][Objetos][7]);
		cache_get_value_name_int(0, "Objetos8", PlayersData[playerid][Objetos][8]);
		cache_get_value_name_int(0, "ObjetosVision0", PlayersData[playerid][ObjetosVision][0]);
		cache_get_value_name_int(0, "ObjetosVision1", PlayersData[playerid][ObjetosVision][1]);
		cache_get_value_name_int(0, "ObjetosVision2", PlayersData[playerid][ObjetosVision][2]);
		cache_get_value_name_int(0, "ObjetosVision3", PlayersData[playerid][ObjetosVision][3]);
		cache_get_value_name_int(0, "ObjetosVision4", PlayersData[playerid][ObjetosVision][4]);

		cache_get_value_name_int(0, "ObjetosVision5", PlayersData[playerid][ObjetosVision][5]);
		cache_get_value_name_int(0, "ObjetosVision6", PlayersData[playerid][ObjetosVision][6]);
		cache_get_value_name_int(0, "ObjetosVision7", PlayersData[playerid][ObjetosVision][7]);
		cache_get_value_name_int(0, "ObjetosVision8", PlayersData[playerid][ObjetosVision][8]);
		cache_get_value_name_int(0, "TypePhone", PlayersData[playerid][TypePhone]);
		cache_get_value_name_int(0, "Ayudante", PlayersData[playerid][Ayudante]);
		cache_get_value_name_int(0, "Mapper", PlayersData[playerid][Mapper]);

		new SplitPos[2] = {0,0};
		new GetAWeaponsData[13][10];
		new GetAmmoData[13][10];
        for(new i=0; i != 13; i++)
		{
            SplitPos[0] = strfind(WeaponsData, "|", false);
            strmid(GetAWeaponsData[i], WeaponsData, 0, SplitPos[0]);
            strdel(WeaponsData, 0, SplitPos[0]+1);

            SplitPos[1] = strfind(AmmoData, "|", false);
            strmid(GetAmmoData[i], AmmoData, 0, SplitPos[1]);
            strdel(AmmoData, 0, SplitPos[1]+1);

			PlayersData[playerid][WeaponS][i] = WEAPON:(strval(GetAWeaponsData[i]));
			PlayersData[playerid][AmmoS][i] = strval(GetAmmoData[i]);
        }
	}
	cache_delete(cacheid);
	return cuentaExiste;
}

DataUserSave(playerid)
{
	if ( PlayersDataOnline[playerid][Spawn] )
	{
        GetSpawnInfoEx(playerid);
    }

	new
	string[10],
	WeaponsData[50],
	AmmoData[50];

	for(new i=0; i<13; i++)
	{
		format(string,10,"%i|", PlayersData[playerid][WeaponS][i]);
		strcat(WeaponsData, string);
		format(string,10,"%i|", PlayersData[playerid][AmmoS][i]);
		strcat(AmmoData, string);
	}

	new query[2000], Cache:cacheid, cuentaExiste;

	mysql_format(dataBase, query, 200, "SELECT `ID` FROM `%s` WHERE `Nombre`='%e';", DIR_USERS, PlayersDataOnline[playerid][NameOnline]);
	cacheid = mysql_query(dataBase, query);
	cache_get_row_count(cuentaExiste);

	if (cuentaExiste)
	{
		cache_get_value_name_int(0, "ID", PlayersData[playerid][DB_ID]);
	}
	cache_delete(cacheid);

	if (!cuentaExiste)
	{
	    mysql_format(dataBase, query, 200, "INSERT INTO `%s` (`Nombre`,`Password`) VALUES ('%e', '%e');", DIR_USERS, PlayersDataOnline[playerid][NameOnline], PlayersData[playerid][Password]);
	    cacheid = mysql_query(dataBase, query);
	    PlayersData[playerid][DB_ID] = cache_insert_id();
	    cache_delete(cacheid);
	}

	format(query, 100, "UPDATE `%s` SET ", DIR_USERS);
	strcat(query, "`Nombre`='%e',`Email`='%e',`Password`='%e',`AccountState`='%i',`Spawn_X`='%f',`Spawn_Y`='%f',`Spawn_Z`='%f',`Spawn_ZZ`='%f',`HoursPlaying`='%i',`DeahtCount`='%i',");
	strcat(query, "`KilledCount`='%i',`Phone`='%i',`House`='%i',`Negocio`='%i',`Car`='%i',`Faccion`='%i',`Rango`='%i',`GirlFreind`='%e',`Bolsillos0`='%i',`Bolsillos1`='%i',`Bolsillos2`='%i',");
	strcat(query, "`Bolsillos3`='%i',`Bolsillos4`='%i',`Habilidad`='%i',`Warn`='%i',`Ciudad`='%i',`Vida`='%f',`Chaleco`='%f',`Cansansio`='%i',`Dinero`='%i',`Banco`='%i',");
	strcat(query, "`Jail`='%i',`Admin`='%i',`World`='%i',`Interior`='%i',`Skin`='%i',`Drogas`='%i',`Materiales`='%i',`Lata`='%i',`Ganzuas`='%i',`Alquiler`='%i',");
	strcat(query, "`Bombas`='%i',`Sexo`='%i',`Idiomas0`='%i',`Idiomas1`='%i',`Idiomas2`='%i',`Idiomas3`='%i',`Idiomas4`='%i',`Idiomas5`='%i',`Licencias0`='%i',`Licencias1`='%i',");
	strcat(query, "`Licencias2`='%i',`Licencias3`='%i',`Licencias4`='%i',`Licencias5`='%i',`Licencias6`='%i',`IsInJail`='%i',`Nacer`='%i',`TimeRequestBank`='%i',`MyBonus`='%i',`InTutorial`='%i',");
	strcat(query, "`Edad`='%i',`IsPlayerInHouse`='%i',`TimeEquipo`='%i',`SpawnAmigo`='%i',`IsPaga`='%i',`MyIP`='%s',`Job`='%i',`MyStyleWalk`='%i',`Saldo`='%i',`LicenciaPesca`='%i'");
	strcat(query, " WHERE `ID`='%i';");

	mysql_format(dataBase, query, 2000, query,
		PlayersDataOnline[playerid][NameOnline],
		PlayersData[playerid][Email],
		PlayersData[playerid][Password],
		PlayersData[playerid][AccountState],
		PlayersData[playerid][Spawn_X],
		PlayersData[playerid][Spawn_Y],
		PlayersData[playerid][Spawn_Z],
		PlayersData[playerid][Spawn_ZZ],
		PlayersData[playerid][HoursPlaying],
		PlayersData[playerid][DeahtCount],

		PlayersData[playerid][KilledCount],
		PlayersData[playerid][Phone],
		PlayersData[playerid][House],
		PlayersData[playerid][Negocio],
		PlayersData[playerid][Car],
		PlayersData[playerid][Faccion],
		PlayersData[playerid][Rango],
		PlayersData[playerid][GirlFreind],
		PlayersData[playerid][Bolsillos][0],
		PlayersData[playerid][Bolsillos][1],
		PlayersData[playerid][Bolsillos][2],

		PlayersData[playerid][Bolsillos][3],
		PlayersData[playerid][Bolsillos][4],
		PlayersData[playerid][Habilidad],
		PlayersData[playerid][Warn],
		PlayersData[playerid][Ciudad],
		PlayersData[playerid][Vida],
		PlayersData[playerid][Chaleco],
		PlayersData[playerid][Cansansio],
		PlayersData[playerid][Dinero],
		PlayersData[playerid][Banco],

		PlayersData[playerid][Jail],
		PlayersData[playerid][Admin],
		PlayersData[playerid][World],
		PlayersData[playerid][Interior],
		PlayersData[playerid][Skin],
		PlayersData[playerid][Drogas],
		PlayersData[playerid][Materiales],
		PlayersData[playerid][Lata],
		PlayersData[playerid][Ganzuas],
		PlayersData[playerid][Alquiler],

		PlayersData[playerid][Bombas],
		PlayersData[playerid][Sexo],
		PlayersData[playerid][Idiomas][0],
		PlayersData[playerid][Idiomas][1],
		PlayersData[playerid][Idiomas][2],
		PlayersData[playerid][Idiomas][3],
		PlayersData[playerid][Idiomas][4],
		PlayersData[playerid][Idiomas][5],
		PlayersData[playerid][Licencias][0],
		PlayersData[playerid][Licencias][1],

		PlayersData[playerid][Licencias][2],
		PlayersData[playerid][Licencias][3],
		PlayersData[playerid][Licencias][4],
		PlayersData[playerid][Licencias][5],
		PlayersData[playerid][Licencias][6],
		PlayersData[playerid][IsInJail],
		PlayersData[playerid][Nacer],
		PlayersData[playerid][TimeRequestBank],
		PlayersData[playerid][MyBonus],
		PlayersData[playerid][InTutorial],

		PlayersData[playerid][Edad],
		PlayersData[playerid][IsPlayerInHouse],
		PlayersData[playerid][TimeEquipo],
		PlayersData[playerid][SpawnAmigo],
		PlayersData[playerid][IsPaga],
		PlayersData[playerid][MyIP],
		PlayersData[playerid][Job],
		PlayersData[playerid][MyStyleWalk],
		PlayersData[playerid][Saldo],
		PlayersData[playerid][LicenciaPesca],

		PlayersData[playerid][DB_ID]
	);
	mysql_query(dataBase, query, false);

	format(query, 100, "UPDATE `%s` SET ", DIR_USERS);
	strcat(query, "`IntermitentState`='%i',`MyStyleTalk`='%i',`IsPlayerInBizz`='%i',`IsPlayerInGarage`='%i',`WeaponS`='%s',`AmmoS`='%s',`Asignados0`='%i',`Asignados1`='%i',`Asignados2`='%i',`Bolsa0`='%i',");
	strcat(query, "`Bolsa1`='%i',`Bolsa2`='%i',`Bolsa3`='%i',`BolsaC0`='%i',`BolsaC1`='%i',`BolsaC2`='%i',`BolsaC3`='%i',`HaveBolsa`='%i',`IsPlayerInVehInt`='%i',`Cartera0`='%i',");
	strcat(query, "`Cartera1`='%i',`Cartera2`='%i',`Cartera3`='%i',`Cartera4`='%i',`Cartera5`='%i',`CarteraC0`='%i',`CarteraC1`='%i',`CarteraC2`='%i',`CarteraC3`='%i',`CarteraC4`='%i',");
	strcat(query, "`CarteraC5`='%i',`CarteraT0`='%i',`CarteraT1`='%i',`CarteraT2`='%i',`CarteraT3`='%i',`CarteraT4`='%i',`CarteraT5`='%i',`AccountBankingOpen`='%i',`CarteraI0`='%i',`CarteraI1`='%i',");
	strcat(query, "`CarteraI2`='%i',`CarteraI3`='%i',`CarteraI4`='%i',`CarteraI5`='%i',`IsPlayerInBank`='%i',`AlertSMSBank`='%i',`HorasWork`='%i',`CameraLogin`='%i',`Enfermedad`='%i',`Description`='%i',");
	strcat(query, "`EnableDescription`='%i',`DescriptionString`='%e',`DescriptionColor`='%i',`DescriptionSelect`='%i',`SpawnFac`='%i',`Objetos0`='%i',`Objetos1`='%i',`Objetos2`='%i',`Objetos3`='%i',");
	strcat(query, "`Objetos4`='%i',`Objetos5`='%i',`Objetos6`='%i',`Objetos7`='%i',`Objetos8`='%i',`ObjetosVision0`='%i',`ObjetosVision1`='%i',`ObjetosVision2`='%i',`ObjetosVision3`='%i',`ObjetosVision4`='%i',");
	strcat(query, "`ObjetosVision5`='%i',`ObjetosVision6`='%i',`ObjetosVision7`='%i',`ObjetosVision8`='%i',`TypePhone`='%i',`Ayudante`='%i',`Mapper`='%i'");
	strcat(query, " WHERE `ID`='%i';");

	mysql_format(dataBase, query, 2000, query,
		PlayersData[playerid][IntermitentState],
		PlayersData[playerid][MyStyleTalk],
		PlayersData[playerid][IsPlayerInBizz],
		PlayersData[playerid][IsPlayerInGarage],
		WeaponsData,
		AmmoData,
		PlayersData[playerid][Asignados][0],
		PlayersData[playerid][Asignados][1],
		PlayersData[playerid][Asignados][2],
		PlayersData[playerid][Bolsa][0],

		PlayersData[playerid][Bolsa][1],
		PlayersData[playerid][Bolsa][2],
		PlayersData[playerid][Bolsa][3],
		PlayersData[playerid][BolsaC][0],
		PlayersData[playerid][BolsaC][1],
		PlayersData[playerid][BolsaC][2],
		PlayersData[playerid][BolsaC][3],
		PlayersData[playerid][HaveBolsa],
		PlayersData[playerid][IsPlayerInVehInt],
		PlayersData[playerid][Cartera][0],

		PlayersData[playerid][Cartera][1],
		PlayersData[playerid][Cartera][2],
		PlayersData[playerid][Cartera][3],
		PlayersData[playerid][Cartera][4],
		PlayersData[playerid][Cartera][5],
		PlayersData[playerid][CarteraC][0],
		PlayersData[playerid][CarteraC][1],
		PlayersData[playerid][CarteraC][2],
		PlayersData[playerid][CarteraC][3],
		PlayersData[playerid][CarteraC][4],

		PlayersData[playerid][CarteraC][5],
		PlayersData[playerid][CarteraT][0],
		PlayersData[playerid][CarteraT][1],
		PlayersData[playerid][CarteraT][2],
		PlayersData[playerid][CarteraT][3],
		PlayersData[playerid][CarteraT][4],
		PlayersData[playerid][CarteraT][5],
		PlayersData[playerid][AccountBankingOpen],
		PlayersData[playerid][CarteraI][0],
		PlayersData[playerid][CarteraI][1],

		PlayersData[playerid][CarteraI][2],
		PlayersData[playerid][CarteraI][3],
		PlayersData[playerid][CarteraI][4],
		PlayersData[playerid][CarteraI][5],
		PlayersData[playerid][IsPlayerInBank],
		PlayersData[playerid][AlertSMSBank],
		PlayersData[playerid][HorasWork],
		PlayersData[playerid][CameraLogin],
		PlayersData[playerid][Enfermedad],
		PlayersData[playerid][Description],

		PlayersData[playerid][EnableDescription],
		PlayersData[playerid][DescriptionString],
		PlayersData[playerid][DescriptionColor],
		PlayersData[playerid][DescriptionSelect],
		PlayersData[playerid][SpawnFac],
		PlayersData[playerid][Objetos][0],
		PlayersData[playerid][Objetos][1],
		PlayersData[playerid][Objetos][2],
		PlayersData[playerid][Objetos][3],

		PlayersData[playerid][Objetos][4],
		PlayersData[playerid][Objetos][5],
		PlayersData[playerid][Objetos][6],
		PlayersData[playerid][Objetos][7],
		PlayersData[playerid][Objetos][8],
		PlayersData[playerid][ObjetosVision][0],
		PlayersData[playerid][ObjetosVision][1],
		PlayersData[playerid][ObjetosVision][2],
		PlayersData[playerid][ObjetosVision][3],
		PlayersData[playerid][ObjetosVision][4],

		PlayersData[playerid][ObjetosVision][5],
		PlayersData[playerid][ObjetosVision][6],
		PlayersData[playerid][ObjetosVision][7],
		PlayersData[playerid][ObjetosVision][8],
		PlayersData[playerid][TypePhone],
		PlayersData[playerid][Ayudante],
		PlayersData[playerid][Mapper],

  		PlayersData[playerid][DB_ID]
	);
	mysql_query(dataBase, query, false);
}
