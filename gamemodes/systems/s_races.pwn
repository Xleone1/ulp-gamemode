Float:GetPlayerProgressRace(playerid, &progress)
{
    progress = GetMaxCheckPointCurrentPista(PlayersDataOnline[playerid][PistaIDp],
	PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VueltaR],
	PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][LastCheckPoint]);
    new Float:PlayerPos[3];
    GetPlayerPos(playerid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);

	new NextCheckPoint;
	if ( progress >= Pistas[PlayersDataOnline[playerid][PistaIDp]][MaxCheckPointsTotal] )
	{
		NextCheckPoint = GetNextCheckPoint(PlayersDataOnline[playerid][PistaIDp],
		(progress - 1) % Pistas[PlayersDataOnline[playerid][PistaIDp]][MaxCheckPointsTotal],
		Pistas[PlayersDataOnline[playerid][PistaIDp]][AlReves]);
	}
	else
	{
		NextCheckPoint = GetNextCheckPoint(PlayersDataOnline[playerid][PistaIDp],
		progress - 1,
		Pistas[PlayersDataOnline[playerid][PistaIDp]][AlReves]);
	}

	//printf("->> %i", NextCheckPoint);

	return GetPointFromPoint(
	PlayerPos[0],
	PlayerPos[1],
	PlayerPos[2],
	PistasPos[PlayersDataOnline[playerid][PistaIDp]][NextCheckPoint][Xpos],
	PistasPos[PlayersDataOnline[playerid][PistaIDp]][NextCheckPoint][Ypos],
	PistasPos[PlayersDataOnline[playerid][PistaIDp]][NextCheckPoint][Zpos]
	);
}
LoadDataPistas()
{
	new query[100], Cache:PISTA_DATA, Cache:CACHE, rowCount;

	for (new p = 0;p < MAX_COUNT_PISTAS;p++)
	{
		format(query, sizeof(query), "SELECT * FROM %s WHERE ID=%d", DIR_PISTAS, p);
		PISTA_DATA = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);

		if (rowCount)
		{
			cache_get_value_name_int(0, "Valid", Pistas[p][Valid]);
			cache_get_value_name_int(0, "IsLock", Pistas[p][Lock]);
			cache_get_value_name(0, "NamePista", Pistas[p][NamePista], 35);
			cache_get_value_name_int(0, "Interior", Pistas[p][Interior]);
			cache_get_value_name_int(0, "World", Pistas[p][World]);
			cache_get_value_name_int(0, "IsCameras", Pistas[p][IsCameras]);

			////////////////////////////////////Checkpoints
			format(query, sizeof(query), "SELECT * FROM %s WHERE pista_id=%d", DIR_PISTAS_CHECKPOINTS, p);
			CACHE = mysql_query(dataBase, query);
			cache_get_row_count(rowCount);
			if(rowCount){
				rowCount = (rowCount > MAX_COUNT_PISTAS_POS) ? (MAX_COUNT_PISTAS_POS):(rowCount);
				for(new i; i != rowCount; i++){
					cache_get_value_index_int(i, 3, PistasPos[p][i][Valid]);
					cache_get_value_index_float(i, 4, PistasPos[p][i][Xpos]);
					cache_get_value_index_float(i, 5, PistasPos[p][i][Ypos]);
					cache_get_value_index_float(i, 6, PistasPos[p][i][Zpos]);
				}
			}
			cache_delete(CACHE);
			////////////////////////////////////PlayerPos
			format(query, sizeof(query), "SELECT * FROM %s WHERE pista_id=%d", DIR_PISTAS_PLAYERS, p);
			CACHE = mysql_query(dataBase, query);
			cache_get_row_count(rowCount);
			if(rowCount){
				rowCount = (rowCount > MAX_COUNT_PISTAS_POS_PLAYERS) ? (MAX_COUNT_PISTAS_POS_PLAYERS):(rowCount);
				for(new i; i != rowCount; i++){
					cache_get_value_index_int(i, 3, PistasPosPlayers[p][i][Valid]);
					cache_get_value_index_float(i, 4, PistasPosPlayers[p][i][Xpos]);
					cache_get_value_index_float(i, 5, PistasPosPlayers[p][i][Ypos]);
					cache_get_value_index_float(i, 6, PistasPosPlayers[p][i][Zpos]);
					cache_get_value_index_float(i, 7, PistasPosPlayers[p][i][ZZpos]);
				}
			}
			cache_delete(CACHE);

			////////////////////////////////////PlayerPosExit
			format(query, sizeof(query), "SELECT * FROM %s WHERE pista_id=%d", DIR_PISTAS_PLAYERS_EXIT, p);
			CACHE = mysql_query(dataBase, query);
			cache_get_row_count(rowCount);
			if(rowCount){
				rowCount = (rowCount > MAX_COUNT_PISTAS_POS_PLAYERS) ? (MAX_COUNT_PISTAS_POS_PLAYERS):(rowCount);
				for(new i; i != rowCount; i++){
					cache_get_value_index_int(i, 3, PistasCarPointsExit[p][i][Valid]);
					cache_get_value_index_float(i, 4, PistasCarPointsExit[p][i][Xpos]);
					cache_get_value_index_float(i, 5, PistasCarPointsExit[p][i][Ypos]);
					cache_get_value_index_float(i, 6, PistasCarPointsExit[p][i][Zpos]);
					cache_get_value_index_float(i, 7, PistasCarPointsExit[p][i][ZZpos]);
				}
			}
			cache_delete(CACHE);
			////////////////////////////////////Cameras
			format(query, sizeof(query), "SELECT * FROM %s WHERE pista_id=%d", DIR_PISTAS_CAMERAS, p);
			CACHE = mysql_query(dataBase, query);
			cache_get_row_count(rowCount);
			if(rowCount){
				rowCount = (rowCount > MAX_COUNT_PISTAS_CAMERAS) ? (MAX_COUNT_PISTAS_CAMERAS):(rowCount);
				for(new i; i != rowCount; i++){
					cache_get_value_index_int(i, 3, PistasCameras[p][i][Valid]);
					cache_get_value_index_float(i, 4, PistasCameras[p][i][Xpos]);
					cache_get_value_index_float(i, 5, PistasCameras[p][i][Ypos]);
					cache_get_value_index_float(i, 6, PistasCameras[p][i][Zpos]);
					cache_get_value_index_float(i, 7, PistasCameras[p][i][Vel]);
				}
			}
			cache_delete(CACHE);
			////////////////////////////////////Records
			format(query, sizeof(query), "SELECT * FROM %s WHERE pista_id=%d", DIR_PISTAS_RECORDS, p);
			CACHE = mysql_query(dataBase, query);
			cache_get_row_count(rowCount);
			if(rowCount){
				rowCount = (rowCount > MAX_COUNT_PISTAS_TOP) ? (MAX_COUNT_PISTAS_TOP):(rowCount);
				for(new i; i != rowCount; i++){
					cache_get_value_index(i, 3, PistasTop[p][i][PlayerName], MAX_PLAYER_NAME);
					if(strlen(PistasTop[p][i][PlayerName]) < 2){
						format(PistasTop[p][i][PlayerName], MAX_PLAYER_NAME, "No");
					}
					cache_get_value_index_int(i, 4, PistasTop[p][i][Time]);
					cache_get_value_index_int(i, 5, PistasTop[p][i][Empty_1]);
					cache_get_value_index_int(i, 6, PistasTop[p][i][Empty_2]);
					cache_get_value_index_int(i, 7, PistasTop[p][i][Vueltas]);
					cache_get_value_index_int(i, 8, PistasTop[p][i][DateHour]);
					cache_get_value_index_int(i, 9, PistasTop[p][i][DateMinute]);
					cache_get_value_index_int(i, 10, PistasTop[p][i][DateSecond]);
					cache_get_value_index_int(i, 11, PistasTop[p][i][DateMonth]);
					cache_get_value_index_int(i, 12, PistasTop[p][i][DateDay]);
					cache_get_value_index_int(i, 13, PistasTop[p][i][DateYear]);
					cache_get_value_index_int(i, 14, PistasTop[p][i][CarModel]);
				}
			}
			cache_delete(CACHE);

			Pistas[p][TiempoAntes] = 10;
			Pistas[p][ConteoR] 	= 3;
			Pistas[p][Radio] 	= 10;

			Pistas[p][Vueltas] = 1;

			ValidingPista(p, false);
		}
		cache_delete(PISTA_DATA);
	}
}
CreatePista(p)
{
	new query[1024], Cache:CACHE, pistaExist, rowCount;

	format(query, 80, "SELECT ID FROM %s WHERE ID=%d;", DIR_PISTAS, p);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(pistaExist);
	cache_delete(CACHE);

	if(!pistaExist && Pistas[p][Valid]){
		mysql_format(dataBase, query, sizeof(query), "INSERT INTO %s (`ID`,`Valid`,`IsLock`,`NamePista`,`Interior`,`World`,`IsCameras`) \
			VALUES (%d,%d,%d,'%e',%d,%d,%d);", DIR_PISTAS, 
			p,
			Pistas[p][Valid], 
			Pistas[p][Lock], 
			Pistas[p][NamePista], 
			Pistas[p][Interior], 
			Pistas[p][World], 
			Pistas[p][IsCameras]);
		mysql_query(dataBase, query, false);
		pistaExist = true;
	}
	if(pistaExist){
		mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
			Valid='%d',IsLock='%d',NamePista='%e',Interior='%d',World='%d',IsCameras='%d' WHERE ID=%d;", DIR_PISTAS, 
			Pistas[p][Valid], 
			Pistas[p][Lock], 
			Pistas[p][NamePista], 
			Pistas[p][Interior], 
			Pistas[p][World], 
			Pistas[p][IsCameras],
			p);
		mysql_query(dataBase, query, false);
		////////////////////////////////////Checkpoints
		format(query, 200, "SELECT ID FROM %s WHERE pista_id=%d;", DIR_PISTAS_CHECKPOINTS, p);
		CACHE = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(CACHE);

		if(rowCount < MAX_COUNT_PISTAS_POS){
			new i = (!rowCount) ? (0) : (rowCount);
			for (; i < MAX_COUNT_PISTAS_POS; i++){
				format(query, sizeof(query), "INSERT INTO %s (pista_id,checkpoint_id,Valid,Xpos,Ypos,Zpos) \
					VALUES (%d,%d,%d,%f,%f,%f);", DIR_PISTAS_CHECKPOINTS, 
					p, i, PistasPos[p][i][Valid], PistasPos[p][i][Xpos], PistasPos[p][i][Ypos], PistasPos[p][i][Zpos]);
				mysql_query(dataBase, query, false);
			}
		}
		for (new i = 0; i < MAX_COUNT_PISTAS_POS; i++)
		{
			mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
				Valid=%d,Xpos=%f,Ypos=%f,Zpos=%f WHERE pista_id=%d AND checkpoint_id=%d;", DIR_PISTAS_CHECKPOINTS, 
				PistasPos[p][i][Valid], PistasPos[p][i][Xpos], PistasPos[p][i][Ypos], PistasPos[p][i][Zpos], p, i);
			mysql_query(dataBase, query, false);
		}
		////////////////////////////////////PlayerPos
		format(query, 200, "SELECT ID FROM %s WHERE pista_id=%d;", DIR_PISTAS_PLAYERS, p);
		CACHE = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(CACHE);

		if(rowCount < MAX_COUNT_PISTAS_POS_PLAYERS){
			new i = (!rowCount) ? (0) : (rowCount);
			for (; i < MAX_COUNT_PISTAS_POS_PLAYERS; i++){
				format(query, sizeof(query), "INSERT INTO %s (pista_id,spawn_id,Valid,Xpos,Ypos,Zpos,ZZpos) \
					VALUES (%d,%d,%d,%f,%f,%f,%f);", DIR_PISTAS_PLAYERS, 
					p, i, PistasPosPlayers[p][i][Valid], PistasPosPlayers[p][i][Xpos], PistasPosPlayers[p][i][Ypos], PistasPosPlayers[p][i][Zpos], PistasPosPlayers[p][i][ZZpos]);
				mysql_query(dataBase, query, false);
			}
		}
		for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
		{
			mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
				Valid=%d,Xpos=%f,Ypos=%f,Zpos=%f,ZZpos=%f WHERE pista_id=%d AND spawn_id=%d;", DIR_PISTAS_PLAYERS, 
				PistasPosPlayers[p][i][Valid], PistasPosPlayers[p][i][Xpos], PistasPosPlayers[p][i][Ypos], PistasPosPlayers[p][i][Zpos], PistasPosPlayers[p][i][ZZpos], p, i);
			mysql_query(dataBase, query, false);
		}
		////////////////////////////////////PlayerPosExit
		format(query, 200, "SELECT ID FROM %s WHERE pista_id=%d;", DIR_PISTAS_PLAYERS_EXIT, p);
		CACHE = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(CACHE);

		if(rowCount < MAX_COUNT_PISTAS_POS_PLAYERS){
			new i = (!rowCount) ? (0) : (rowCount);
			for (; i < MAX_COUNT_PISTAS_POS_PLAYERS; i++){
				format(query, sizeof(query), "INSERT INTO %s (pista_id,spawn_id,Valid,Xpos,Ypos,Zpos,ZZpos) \
					VALUES (%d,%d,%d,%f,%f,%f,%f);", DIR_PISTAS_PLAYERS_EXIT, 
					p, i, PistasCarPointsExit[p][i][Valid], PistasCarPointsExit[p][i][Xpos], PistasCarPointsExit[p][i][Ypos], PistasCarPointsExit[p][i][Zpos], PistasCarPointsExit[p][i][ZZpos]);
				mysql_query(dataBase, query, false);
			}
		}
		for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
		{
			mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
				Valid=%d,Xpos=%f,Ypos=%f,Zpos=%f,ZZpos=%f WHERE pista_id=%d AND spawn_id=%d;", DIR_PISTAS_PLAYERS_EXIT, 
				PistasCarPointsExit[p][i][Valid], PistasCarPointsExit[p][i][Xpos], PistasCarPointsExit[p][i][Ypos], PistasCarPointsExit[p][i][Zpos], PistasCarPointsExit[p][i][ZZpos], p, i);
			mysql_query(dataBase, query, false);
		}
		////////////////////////////////////Cameras
		format(query, 200, "SELECT ID FROM %s WHERE pista_id=%d;", DIR_PISTAS_CAMERAS, p);
		CACHE = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(CACHE);

		if(rowCount < MAX_COUNT_PISTAS_CAMERAS){
			new i = (!rowCount) ? (0) : (rowCount);
			for (; i < MAX_COUNT_PISTAS_CAMERAS; i++){
				format(query, sizeof(query), "INSERT INTO %s (pista_id,camera_id,Valid,Xpos,Ypos,Zpos,Vel) \
					VALUES (%d,%d,%d,%f,%f,%f,%f);", DIR_PISTAS_CAMERAS, 
					p, i, PistasCameras[p][i][Valid], PistasCameras[p][i][Xpos], PistasCameras[p][i][Ypos], PistasCameras[p][i][Zpos], PistasCameras[p][i][Vel]);
				mysql_query(dataBase, query, false);
			}
		}
		for (new i = 0; i < MAX_COUNT_PISTAS_CAMERAS;i++)
		{
			mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
				Valid=%d,Xpos=%f,Ypos=%f,Zpos=%f,Vel=%f WHERE pista_id=%d AND camera_id=%d;", DIR_PISTAS_CAMERAS, 
				PistasCameras[p][i][Valid], PistasCameras[p][i][Xpos], PistasCameras[p][i][Ypos], PistasCameras[p][i][Zpos], PistasCameras[p][i][Vel], p, i);
			mysql_query(dataBase, query, false);
		}
		////////////////////////////////////Records
		format(query, 200, "SELECT ID FROM %s WHERE pista_id=%d;", DIR_PISTAS_RECORDS, p);
		CACHE = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(CACHE);

		if(rowCount < MAX_COUNT_PISTAS_TOP){
			new i = (!rowCount) ? (0) : (rowCount);
			for (; i < MAX_COUNT_PISTAS_TOP; i++){
				format(query, sizeof(query), "INSERT INTO %s (pista_id,record_id) VALUES (%d,%d);", DIR_PISTAS_RECORDS, p, i);
				mysql_query(dataBase, query, false);
			}
		}
		for (new i = 0; i < MAX_COUNT_PISTAS_TOP;i++)
		{
			mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
				PlayerName='%e',Time=%d,Empty_1=%d,Empty_2=%d,Vueltas=%d,\
				DateHour=%d,DateMinute=%d,DateSecond=%d,DateMonth=%d,DateDay=%d,DateYear=%d,CarModel=%d \
				WHERE pista_id=%d AND record_id=%d;", DIR_PISTAS_RECORDS, 
				PistasTop[p][i][PlayerName], PistasTop[p][i][Time], PistasTop[p][i][Empty_1], PistasTop[p][i][Empty_2], PistasTop[p][i][Vueltas], 
				PistasTop[p][i][DateHour], PistasTop[p][i][DateMinute], PistasTop[p][i][DateSecond], PistasTop[p][i][DateMonth], PistasTop[p][i][DateDay], PistasTop[p][i][DateYear], PistasTop[p][i][CarModel], 
				p, i);
			mysql_query(dataBase, query, false);
		}
	}
}
SaveDataPista(p)
{
	new query[1024], Cache:CACHE, pistaExist;

	format(query, 80, "SELECT ID FROM %s WHERE ID=%d;", DIR_PISTAS, p);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(pistaExist);
	cache_delete(CACHE);

	if(!pistaExist && Pistas[p][Valid]){
		CreatePista(p);
		return 1;
	}
	if(pistaExist){
		mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
			Valid='%d',IsLock='%d',NamePista='%e',Interior='%d',World='%d',IsCameras='%d' WHERE ID=%d;", DIR_PISTAS, 
			Pistas[p][Valid], 
			Pistas[p][Lock], 
			Pistas[p][NamePista], 
			Pistas[p][Interior], 
			Pistas[p][World], 
			Pistas[p][IsCameras],
			p);
		mysql_query(dataBase, query, false);
	}
	return 1;
}
SaveDataPistaCheckPoint(p, checkpoint_ID)
{
	new query[1024], Cache:CACHE, pistaExist, rowCount;

	format(query, 80, "SELECT ID FROM %s WHERE ID=%d;", DIR_PISTAS, p);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(pistaExist);
	cache_delete(CACHE);

	if(!pistaExist && Pistas[p][Valid]){
		CreatePista(p);
		return true;
	}
	if(pistaExist){
		////////////////////////////////////Checkpoints
		format(query, 200, "SELECT ID FROM %s WHERE pista_id=%d;", DIR_PISTAS_CHECKPOINTS, p);
		CACHE = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(CACHE);

		if(rowCount < MAX_COUNT_PISTAS_POS){
			new i = (!rowCount) ? (0) : (rowCount);
			for (; i < MAX_COUNT_PISTAS_POS; i++){
				format(query, sizeof(query), "INSERT INTO %s (pista_id,checkpoint_id,Valid,Xpos,Ypos,Zpos) \
					VALUES (%d,%d,%d,%f,%f,%f);", DIR_PISTAS_CHECKPOINTS, 
					p, i, PistasPos[p][i][Valid], PistasPos[p][i][Xpos], PistasPos[p][i][Ypos], PistasPos[p][i][Zpos]);
				mysql_query(dataBase, query, false);
			}
			return 1;
		}
		mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
			Valid=%d,Xpos=%f,Ypos=%f,Zpos=%f WHERE pista_id=%d AND checkpoint_id=%d;", DIR_PISTAS_CHECKPOINTS, 
			PistasPos[p][checkpoint_ID][Valid], PistasPos[p][checkpoint_ID][Xpos], PistasPos[p][checkpoint_ID][Ypos], PistasPos[p][checkpoint_ID][Zpos], p, checkpoint_ID);
		mysql_query(dataBase, query, false);
	}
	return 1;
}
SaveDataPistaSpawnPoints(p, spawn_id)
{
	new query[1024], Cache:CACHE, pistaExist, rowCount;

	format(query, 80, "SELECT ID FROM %s WHERE ID=%d;", DIR_PISTAS, p);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(pistaExist);
	cache_delete(CACHE);

	if(!pistaExist && Pistas[p][Valid]){
		CreatePista(p);
		return true;
	}
	if(pistaExist){
		////////////////////////////////////PlayerPos
		format(query, 200, "SELECT ID FROM %s WHERE pista_id=%d;", DIR_PISTAS_PLAYERS, p);
		CACHE = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(CACHE);

		if(rowCount < MAX_COUNT_PISTAS_POS_PLAYERS){
			new i = (!rowCount) ? (0) : (rowCount);
			for (; i < MAX_COUNT_PISTAS_POS_PLAYERS; i++){
				format(query, sizeof(query), "INSERT INTO %s (pista_id,spawn_id,Valid,Xpos,Ypos,Zpos,ZZpos) \
					VALUES (%d,%d,%d,%f,%f,%f,%f);", DIR_PISTAS_PLAYERS, 
					p, i, PistasPosPlayers[p][i][Valid], PistasPosPlayers[p][i][Xpos], PistasPosPlayers[p][i][Ypos], PistasPosPlayers[p][i][Zpos], PistasPosPlayers[p][i][ZZpos]);
				mysql_query(dataBase, query, false);
			}
			return 1;
		}
		mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
			Valid=%d,Xpos=%f,Ypos=%f,Zpos=%f,ZZpos=%f WHERE pista_id=%d AND spawn_id=%d;", DIR_PISTAS_PLAYERS, 
			PistasPosPlayers[p][spawn_id][Valid], PistasPosPlayers[p][spawn_id][Xpos], PistasPosPlayers[p][spawn_id][Ypos], PistasPosPlayers[p][spawn_id][Zpos], PistasPosPlayers[p][spawn_id][ZZpos], p, spawn_id);
		mysql_query(dataBase, query, false);
	}
	return 1;
}
SaveDataPistaSpawnPointsExit(p, spawn_id)
{
	new query[1024], Cache:CACHE, pistaExist, rowCount;

	format(query, 80, "SELECT ID FROM %s WHERE ID=%d;", DIR_PISTAS, p);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(pistaExist);
	cache_delete(CACHE);

	if(!pistaExist && Pistas[p][Valid]){
		CreatePista(p);
		return true;
	}
	if(pistaExist){
		////////////////////////////////////PlayerPosExit
		format(query, 200, "SELECT ID FROM %s WHERE pista_id=%d;", DIR_PISTAS_PLAYERS_EXIT, p);
		CACHE = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(CACHE);

		if(rowCount < MAX_COUNT_PISTAS_POS_PLAYERS){
			new i = (!rowCount) ? (0) : (rowCount);
			for (; i < MAX_COUNT_PISTAS_POS_PLAYERS; i++){
				format(query, sizeof(query), "INSERT INTO %s (pista_id,spawn_id,Valid,Xpos,Ypos,Zpos,ZZpos) \
					VALUES (%d,%d,%d,%f,%f,%f,%f);", DIR_PISTAS_PLAYERS, 
					p, i, PistasCarPointsExit[p][i][Valid], PistasCarPointsExit[p][i][Xpos], PistasCarPointsExit[p][i][Ypos], PistasCarPointsExit[p][i][Zpos], PistasCarPointsExit[p][i][ZZpos]);
				mysql_query(dataBase, query, false);
			}
			return 1;
		}
		mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
			Valid=%d,Xpos=%f,Ypos=%f,Zpos=%f,ZZpos=%f WHERE pista_id=%d AND spawn_id=%d;", DIR_PISTAS_PLAYERS_EXIT, 
			PistasCarPointsExit[p][spawn_id][Valid], PistasCarPointsExit[p][spawn_id][Xpos], PistasCarPointsExit[p][spawn_id][Ypos], PistasCarPointsExit[p][spawn_id][Zpos], PistasCarPointsExit[p][spawn_id][ZZpos], p, spawn_id);
		mysql_query(dataBase, query, false);
	}
	return 1;
}
SaveDataPistaCamera(p, camera_id)
{
	new query[1024], Cache:CACHE, pistaExist, rowCount;

	format(query, 80, "SELECT ID FROM %s WHERE ID=%d;", DIR_PISTAS, p);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(pistaExist);
	cache_delete(CACHE);

	if(!pistaExist && Pistas[p][Valid]){
		CreatePista(p);
		return true;
	}
	if(pistaExist){
		////////////////////////////////////Cameras
		format(query, 200, "SELECT ID FROM %s WHERE pista_id=%d;", DIR_PISTAS_CAMERAS, p);
		CACHE = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(CACHE);

		if(rowCount < MAX_COUNT_PISTAS_CAMERAS){
			new i = (!rowCount) ? (0) : (rowCount);
			for (; i < MAX_COUNT_PISTAS_CAMERAS; i++){
				format(query, sizeof(query), "INSERT INTO %s (pista_id,camera_id,Valid,Xpos,Ypos,Zpos,Vel) \
					VALUES (%d,%d,%d,%f,%f,%f,%f);", DIR_PISTAS_CAMERAS, 
					p, i, PistasCameras[p][i][Valid], PistasCameras[p][i][Xpos], PistasCameras[p][i][Ypos], PistasCameras[p][i][Zpos], PistasCameras[p][i][Vel]);
				mysql_query(dataBase, query, false);
			}
			return 1;
		}
		mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
			Valid=%d,Xpos=%f,Ypos=%f,Zpos=%f,Vel=%f WHERE pista_id=%d AND camera_id=%d;", DIR_PISTAS_CAMERAS, 
			PistasCameras[p][camera_id][Valid], PistasCameras[p][camera_id][Xpos], PistasCameras[p][camera_id][Ypos], PistasCameras[p][camera_id][Zpos], PistasCameras[p][camera_id][Vel], p, camera_id);
		mysql_query(dataBase, query, false);
	}
	return 1;
}
SaveDataPistaRecords(p, record_id)
{
	new query[1024], Cache:CACHE, pistaExist, rowCount;

	format(query, 80, "SELECT ID FROM %s WHERE ID=%d;", DIR_PISTAS, p);
	CACHE = mysql_query(dataBase, query);
	cache_get_row_count(pistaExist);
	cache_delete(CACHE);

	if(!pistaExist && Pistas[p][Valid]){
		CreatePista(p);
		return true;
	}
	if(pistaExist){
		////////////////////////////////////Records
		format(query, 200, "SELECT ID FROM %s WHERE pista_id=%d;", DIR_PISTAS_RECORDS, p);
		CACHE = mysql_query(dataBase, query);
		cache_get_row_count(rowCount);
		cache_delete(CACHE);

		if(rowCount < MAX_COUNT_PISTAS_TOP){
			new i = (!rowCount) ? (0) : (rowCount);
			for (; i < MAX_COUNT_PISTAS_TOP; i++){
				format(query, sizeof(query), "INSERT INTO %s (pista_id,record_id) VALUES (%d,%d);", DIR_PISTAS_RECORDS, p, i);
				mysql_query(dataBase, query, false);
			}
		}
		for (new i = 0; i < MAX_COUNT_PISTAS_TOP;i++)
		{
			mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET \
				PlayerName='%e',Time=%d,Empty_1=%d,Empty_2=%d,Vueltas=%d,\
				DateHour=%d,DateMinute=%d,DateSecond=%d,DateMonth=%d,DateDay=%d,DateYear=%d,CarModel=%d \
				WHERE pista_id=%d AND record_id=%d;", DIR_PISTAS_RECORDS, 
				PistasTop[p][record_id][PlayerName], PistasTop[p][record_id][Time], PistasTop[p][record_id][Empty_1], PistasTop[p][record_id][Empty_2], PistasTop[p][record_id][Vueltas], 
				PistasTop[p][record_id][DateHour], PistasTop[p][record_id][DateMinute], PistasTop[p][record_id][DateSecond], PistasTop[p][record_id][DateMonth], PistasTop[p][record_id][DateDay], PistasTop[p][record_id][DateYear], PistasTop[p][record_id][CarModel], 
				p, record_id);
			mysql_query(dataBase, query, false);
		}
	}
	return 1;
}
ValidingPista(pistaid, option)
{
	new AreValid;
	for (new i = 0; i < MAX_COUNT_PISTAS_POS;i++)
	{
		if ( PistasPos[pistaid][i][Valid])
		{
		    AreValid++;
		    if ( AreValid > 1 )
		    {
				break;
			}
			else
			{
			    continue;
			}
		}
	}
	if ( AreValid > 1)
	{
	    AreValid = false;
		for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
		{
			if ( PistasPosPlayers[pistaid][i][Valid]&& PistasCarPointsExit[pistaid][i][Valid] ||
				!PistasPosPlayers[pistaid][i][Valid]&&!PistasCarPointsExit[pistaid][i][Valid])
			{
				if ( PistasPosPlayers[pistaid][i][Valid]&& PistasCarPointsExit[pistaid][i][Valid] )
				{
				    AreValid++;
				}
				continue;
			}
			else
			{
			    AreValid = false;
			    break;
			}
		}
		if ( AreValid )
		{
		    if ( Pistas[pistaid][IsCameras] )
		    {
		        AreValid = false;
				for (new i = 0; i < MAX_COUNT_PISTAS_CAMERAS;i++)
				{
					if ( PistasCameras[pistaid][i][Valid] )
					{
					    AreValid++;
					}
					else
					{
					    break;
					}
				}
		    	if ( AreValid < 2 )
		    	{
		    	    AreValid = 999;
				}
				else
				{
					Pistas[pistaid][MaxCameras] = AreValid - 1;
				}
	    	}
		}
		if ( AreValid && AreValid != 999)
		{
			Pistas[pistaid][MaxCheckPointsTotal] = GetMaxCountPistasPos(pistaid);
			Pistas[pistaid][ValidR] = true;
			Pistas[pistaid][MinPP]	= GetMinPistaRace(pistaid);
			Pistas[pistaid][MaxPP] 	= GetMaxPistaRace(pistaid);
			CleanPistaForRace(pistaid);
			Pistas[pistaid][TiempoAntes] = 10;
			Pistas[pistaid][ConteoR] = 3;
			Pistas[pistaid][Radio] = 10;
			Pistas[pistaid][Vueltas] = 1;
			return true;
		}
	}
	if ( option )
	{
	    if ( AreValid != 999 )
	    {
			// CleanPista(pistaid);
		}
	}
	return false;
}
CleanPista(pistaid)
{
   	format(Pistas[pistaid][NamePista], 35, "No");
	Pistas[pistaid][ShowTagPos] = false;
	Pistas[pistaid][ShowTagPlayers] = false;
	Pistas[pistaid][ShowTagCamPoints] = false;
	ShowOrHideTagPistaPlayers(pistaid);
	ShowOrHideTagPistaPos(pistaid);
	ShowOrHideTagPistaCam(pistaid);
	for (new i = 0; i < MAX_COUNT_PISTAS_POS;i++)
	{
		CleanPistaPos(pistaid, i);
	}
	for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
	{
		CleanPistaPosPlayers(pistaid, i);
		CleanPistaCarPointsExit(pistaid, i);
	}
	for (new i = 0; i < MAX_COUNT_PISTAS_CAMERAS;i++)
	{
		CleanPistaCameras(pistaid, i);
	}
	for (new i = 0; i < MAX_COUNT_PISTAS_TOP;i++)
	{
		CleanPistaRecords(pistaid, i);
	}
	Pistas[pistaid][ValidR] 	 = false;
	Pistas[pistaid][Valid] 		 = false;
	Pistas[pistaid][Lock]   	 = false;
	Pistas[pistaid][IsCameras]   = false;
	SaveDataPista(pistaid);//Actualiza los datos basicos lo demas lo actualiza las funciones
}
CleanPistaRecords(pistaid, posid)
{
	format(PistasTop[pistaid][posid][PlayerName], MAX_PLAYER_NAME, "No");
    PistasTop[pistaid][posid][Time]		= 0;
    PistasTop[pistaid][posid][Empty_1] 	= 0;
    PistasTop[pistaid][posid][Empty_2] 	= 0;
    PistasTop[pistaid][posid][Vueltas] 	= 0;
    PistasTop[pistaid][posid][DateHour] 	= 0;
    PistasTop[pistaid][posid][DateMinute] = 0;
    PistasTop[pistaid][posid][DateSecond] = 0;
    PistasTop[pistaid][posid][DateMonth] 	= 0;
    PistasTop[pistaid][posid][DateDay] 	= 0;
    PistasTop[pistaid][posid][DateYear] 	= 0;
	SaveDataPistaRecords(pistaid, posid);
}
CleanPistaPos(pistaid, posid)
{
    PistasPos[pistaid][posid][Valid] 	= false;
    PistasPos[pistaid][posid][Xpos] 	= 0.0;
    PistasPos[pistaid][posid][Ypos] 	= 0.0;
    PistasPos[pistaid][posid][Zpos] 	= 0.0;
	SaveDataPistaCheckPoint(pistaid, posid);
}
CleanPistaPosPlayers(pistaid, posplayersid)
{
    PistasPosPlayers[pistaid][posplayersid][Valid] = false;
    PistasPosPlayers[pistaid][posplayersid][Xpos] 	= 0.0;
    PistasPosPlayers[pistaid][posplayersid][Ypos] 	= 0.0;
    PistasPosPlayers[pistaid][posplayersid][Zpos] 	= 0.0;
    PistasPosPlayers[pistaid][posplayersid][ZZpos] = 0.0;
	SaveDataPistaSpawnPoints(pistaid, posplayersid);
}
CleanPistaCameras(pistaid, posplayersid)
{
    PistasCameras[pistaid][posplayersid][Valid] = false;
    PistasCameras[pistaid][posplayersid][Xpos] 	= 0.0;
    PistasCameras[pistaid][posplayersid][Ypos] 	= 0.0;
    PistasCameras[pistaid][posplayersid][Zpos] 	= 0.0;
    PistasCameras[pistaid][posplayersid][Vel] 	= 0.0;
	SaveDataPistaCamera(pistaid, posplayersid);
}
CleanPistaCarPointsExit(pistaid, posplayersid)
{
    PistasCarPointsExit[pistaid][posplayersid][Valid] = false;
    PistasCarPointsExit[pistaid][posplayersid][Xpos] 	= 0.0;
    PistasCarPointsExit[pistaid][posplayersid][Ypos] 	= 0.0;
    PistasCarPointsExit[pistaid][posplayersid][Zpos] 	= 0.0;
    PistasCarPointsExit[pistaid][posplayersid][ZZpos] 	= 0.0;
	SaveDataPistaSpawnPointsExit(pistaid, posplayersid);
}
CreatePistaPos(playerid, pistaid, posid)
{
	new Float:PosPos[3];
	if ( IsPlayerInAnyVehicle(playerid) )
	{
	    GetVehiclePos(GetPlayerVehicleID(playerid), PosPos[0], PosPos[1], PosPos[2]);
	}
	else
	{
	    GetPlayerPos(playerid, PosPos[0], PosPos[1], PosPos[2]);
	}
    PistasPos[pistaid][posid][Valid] 	= true;
    PistasPos[pistaid][posid][Xpos] 	= PosPos[0];
    PistasPos[pistaid][posid][Ypos] 	= PosPos[1];
    PistasPos[pistaid][posid][Zpos] 	= PosPos[2];
	UpdateTagPistaPos(pistaid, posid);
	SaveDataPistaCheckPoint(pistaid, posid);
}
CreatePistaPlayers(playerid, pistaid, posid)
{
	new Float:PosPos[4];
	if ( IsPlayerInAnyVehicle(playerid) )
	{
	    GetVehiclePos(GetPlayerVehicleID(playerid), PosPos[0], PosPos[1], PosPos[2]);
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), PosPos[3]);
	}
	else
	{
	    GetPlayerPos(playerid, PosPos[0], PosPos[1], PosPos[2]);
	    GetPlayerFacingAngle(playerid, PosPos[3]);
	}
    PistasPosPlayers[pistaid][posid][Valid] = true;
    PistasPosPlayers[pistaid][posid][Xpos] 	= PosPos[0];
    PistasPosPlayers[pistaid][posid][Ypos] 	= PosPos[1];
    PistasPosPlayers[pistaid][posid][Zpos] 	= PosPos[2];
    PistasPosPlayers[pistaid][posid][ZZpos] = PosPos[3];
	UpdateTagPistaPlayers(pistaid, posid);
	SaveDataPistaSpawnPoints(pistaid, posid);
}
CreatePistaCarPoints(playerid, pistaid, posid)
{
	new Float:PosPos[4];
	if ( IsPlayerInAnyVehicle(playerid) )
	{
	    GetVehiclePos(GetPlayerVehicleID(playerid), PosPos[0], PosPos[1], PosPos[2]);
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), PosPos[3]);
	}
	else
	{
	    GetPlayerPos(playerid, PosPos[0], PosPos[1], PosPos[2]);
	    GetPlayerFacingAngle(playerid, PosPos[3]);
	}
    PistasCarPointsExit[pistaid][posid][Valid] = true;
    PistasCarPointsExit[pistaid][posid][Xpos] 	= PosPos[0];
    PistasCarPointsExit[pistaid][posid][Ypos] 	= PosPos[1];
    PistasCarPointsExit[pistaid][posid][Zpos] 	= PosPos[2];
    PistasCarPointsExit[pistaid][posid][ZZpos] = PosPos[3];
	UpdateTagPistaPlayers(pistaid, posid);
	SaveDataPistaSpawnPointsExit(pistaid, posid);
}
CreatePistaCameras(playerid, pistaid, posid)
{
	new Float:PosPos[4];
	if ( IsPlayerInAnyVehicle(playerid) )
	{
	    GetVehiclePos(GetPlayerVehicleID(playerid), PosPos[0], PosPos[1], PosPos[2]);
	}
	else
	{
	    GetPlayerPos(playerid, PosPos[0], PosPos[1], PosPos[2]);
	}
    PistasCameras[pistaid][posid][Valid] = true;
    PistasCameras[pistaid][posid][Xpos]  = PosPos[0];
    PistasCameras[pistaid][posid][Ypos]  = PosPos[1];
    PistasCameras[pistaid][posid][Zpos]  = PosPos[2];
    PistasCameras[pistaid][posid][Vel] 	 = 0.01;
	UpdateTagPistaCameras(pistaid, posid);
	SaveDataPistaCamera(pistaid, posid);
}
GetMaxCountPistas()
{
	new CountP;
	for (new p = 0;p < MAX_COUNT_PISTAS;p++)
	{
	    if ( Pistas[p][Valid] )
	    {
			CountP++;
		}
	}
	return CountP;
}
GetMaxCountPistasPos(pistaid)
{
	new CountPPos;
	for (new i = 0; i < MAX_COUNT_PISTAS_POS;i++)
	{
		if (PistasPos[pistaid][i][Valid])
		{
		    CountPPos++;
		}
	}
	return CountPPos;
}
GetMaxCountPistasCamPoints(pistaid)
{
	new CountPPosP;
	for (new i = 0; i < MAX_COUNT_PISTAS_CAMERAS;i++)
	{
		if (PistasCameras[pistaid][i][Valid])
		{
		    CountPPosP++;
		}
	}
	return CountPPosP;
}
GetMaxCountPistasCarPointsExit(pistaid)
{
	new CountPPosP;
	for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
	{
		if (PistasCarPointsExit[pistaid][i][Valid])
		{
		    CountPPosP++;
		}
	}
	return CountPPosP;
}
GetMaxCountPistasPlayers(pistaid)
{
	new CountPPosP;
	for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
	{
		if (PistasPosPlayers[pistaid][i][Valid])
		{
		    CountPPosP++;
		}
	}
	return CountPPosP;
}
GetNextPista()
{
	for (new p = 0;p < MAX_COUNT_PISTAS;p++)
	{
	    if ( !Pistas[p][ValidR] && !Pistas[p][Valid])
	    {
	        return p;
	    }
	}
	return -1;
}
ShowEditorPistas(playerid)
{
	new ListDialog[350];
	format(ListDialog, sizeof(ListDialog),
	"{"COLOR_AZUL"}1- {"COLOR_CREMA"}Nueva Pista\r\n{"COLOR_AZUL"}2- {"COLOR_CREMA"}Lista de Pistas {"COLOR_VERDE"}(%i)",
		GetMaxCountPistas()
	);
	ShowPlayerDialogEx(playerid,95,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Editor de Pistas", ListDialog, "Seleccionar", "Salir");
}
ShowNewPista(playerid)
{
	new NextPista = GetNextPista();
	if ( NextPista != -1 )
	{
		PlayersDataOnline[playerid][SaveAfterAgenda][0] = NextPista;
		ShowPlayerDialogEx(playerid,96,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Editor de Pistas - Nueva Pista", "{"COLOR_CREMA"}Ingrese un nombre para la pista", "Crear", "Volver");
	}
	else
	{
		ShowPlayerDialogEx(playerid,94,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error", "{"COLOR_CREMA"}Se ha alcanzado el maximo numero de pistas", "Aceptar", "Volver");
	}
}
ShowListPistas(playerid)
{
	new PistasDialog[1400];
	new TempConvert[50];
	new ConteoPistas = -1;
	for (new i = 0; i < MAX_COUNT_PISTAS; i++)
	{
	    if ( Pistas[i][Valid] )
	    {
			if ( ConteoPistas != -1 )
			{
				if ( !Pistas[i][ValidR] )
				{
			    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_ROJO"}%s", Pistas[i][NamePista]);
		    	}
		    	else
		    	{
			    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}%s", Pistas[i][NamePista]);
				}
	    	}
			else
			{
				if ( !Pistas[i][ValidR] )
				{
		    		format(TempConvert, sizeof(TempConvert), "{"COLOR_ROJO"}%s", Pistas[i][NamePista]);
	    		}
	    		else
	    		{
		    		format(TempConvert, sizeof(TempConvert), "{"COLOR_CREMA"}%s", Pistas[i][NamePista]);
				}
			}
	        strcat(PistasDialog, TempConvert, sizeof(PistasDialog));
	        ConteoPistas++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoPistas] = i;
        }
	}
	if (ConteoPistas != -1)
	{
		ShowPlayerDialogEx(playerid,97,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Editor de Pistas - Lista de Pistas", PistasDialog, "Seleccionar", "Volver");
	}
	else
	{
		ShowPlayerDialogEx(playerid,94,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error", "{"COLOR_CREMA"}No se encontraron pistas creadas", "Aceptar", "Volver");
	}
}
PistaExist(playerid, pistaid)
{
	if ( Pistas[pistaid][Valid] )
	{
		return true;
	}
	else
	{
		ShowPlayerDialogEx(playerid,999,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Pistas - Error", "{"COLOR_CREMA"}Oops, la pista con la que estabas trabajando fue borrada!", "Ok", "");
	    return false;
	}
}
ShowListPistasOptions(playerid, pistaid)
{
    if ( PistaExist(playerid, pistaid) )
    {
		new ListDialog[700];
		format(ListDialog, sizeof(ListDialog),
		"{"COLOR_AZUL"}1- {"COLOR_CREMA"}Modificar Nombre {"COLOR_VERDE"}(%s)\r\n{"COLOR_AZUL"}2- {"COLOR_CREMA"}CheckPoints {"COLOR_VERDE"}(%i)\r\n{"COLOR_AZUL"}3- {"COLOR_CREMA"}CarPoints {"COLOR_VERDE"}(%i)\r\n{"COLOR_AZUL"}4- {"COLOR_CREMA"}CarPointsExit {"COLOR_VERDE"}(%i)\r\n{"COLOR_AZUL"}5- {"COLOR_CREMA"}CamerasPoints {"COLOR_VERDE"}(%i)\r\n{"COLOR_AZUL"}6- {"COLOR_CREMA"}Mostrar CheckPoints {"COLOR_VERDE"}(%s)\r\n",
		    Pistas[pistaid][NamePista],
		    GetMaxCountPistasPos(pistaid),
		    GetMaxCountPistasPlayers(pistaid),
		    GetMaxCountPistasCarPointsExit(pistaid),
		    GetMaxCountPistasCamPoints(pistaid),
		    SiOrNo[Pistas[pistaid][ShowTagPos]]
		);
		format(ListDialog, sizeof(ListDialog),
		"%s{"COLOR_AZUL"}7- {"COLOR_CREMA"}Mostrar CarPoints {"COLOR_VERDE"}(%s)\r\n{"COLOR_AZUL"}8- {"COLOR_CREMA"}Mostrar CarPointsExit {"COLOR_VERDE"}(%s)\r\n{"COLOR_AZUL"}9- {"COLOR_CREMA"}Mostrar CamerasPoints {"COLOR_VERDE"}(%s)\r\n{"COLOR_AZUL"}10- {"COLOR_CREMA"}Validar\r\n{"COLOR_AZUL"}11- {"COLOR_CREMA"}Interior {"COLOR_VERDE"}(%i)\r\n{"COLOR_AZUL"}11- {"COLOR_CREMA"}Mundo {"COLOR_VERDE"}(%i)\r\n{"COLOR_AZUL"}12- {"COLOR_CREMA"}Bloqueado {"COLOR_VERDE"}(%s)\r\n{"COLOR_AZUL"}13- {"COLOR_CREMA"}Camaras {"COLOR_VERDE"}(%s)\r\n{"COLOR_AZUL"}14- {"COLOR_CREMA"}Eliminar",
			ListDialog,
		    SiOrNo[Pistas[pistaid][ShowTagPlayers]],
		    SiOrNo[Pistas[pistaid][ShowTagCarPointsExit]],
		    SiOrNo[Pistas[pistaid][ShowTagCamPoints]],
		    Pistas[pistaid][Interior],
		    Pistas[pistaid][World],
		    SiOrNo[Pistas[pistaid][Lock]],
		    SiOrNo[Pistas[pistaid][IsCameras]]
		);
		ShowPlayerDialogEx(playerid,98,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Editor de Pistas - Opciones de Edicion", ListDialog, "Seleccionar", "Volver");
		PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
	}
}
ShowPistaChangeName(playerid, pistaid)
{
	if ( PistaExist(playerid, pistaid) )
	{
		PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
		ShowPlayerDialogEx(playerid,99,DIALOG_STYLE_INPUT,"{"COLOR_AZUL"}Editor de Pistas - Modificar nombre", "{"COLOR_CREMA"}Ingrese un nuevo nombre para la pista", "Modificar", "Volver");
	}
}
ShowPistaShowCheckPoints(playerid, pistaid)
{
	if ( PistaExist(playerid, pistaid) )
	{
        if ( !Pistas[pistaid][Used] )
        {
		    PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
			new PistasDialog[2500];
			new TempConvert[50];
			for (new i = 0; i < MAX_COUNT_PISTAS_POS; i++)
			{
				if (i)
				{
					if ( PistasPos[pistaid][i][Valid] )
					{
				    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_VERDE"}ID: %i - Usado", i);
			    	}
			    	else
			    	{
				    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_ROJO"}ID: %i - Sin Uso", i);
					}
		    	}
				else
				{
					if ( PistasPos[pistaid][i][Valid] )
					{
				    	format(TempConvert, sizeof(TempConvert), "{"COLOR_VERDE"}ID: %i - Usado", i);
			    	}
			    	else
			    	{
				    	format(TempConvert, sizeof(TempConvert), "{"COLOR_ROJO"}ID: %i - Sin Uso", i);
					}
				}
		        strcat(PistasDialog, TempConvert, sizeof(PistasDialog));
			}
		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Editor de Pistas - %s (CheckPoints)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,100,DIALOG_STYLE_LIST, PistasDialogName, PistasDialog, "Seleccionar", "Volver");
		}
		else
		{
			ShowPlayerDialogEx(playerid,94,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe detenerla antes de seguir editandola", "Aceptar", "Volver");
		}
	}
}
ShowPistaShowPosPlayers(playerid, pistaid)
{
	if ( PistaExist(playerid, pistaid) )
	{
        if ( !Pistas[pistaid][Used] )
        {
		    PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
			new PistasDialog[1400];
			new TempConvert[50];
			for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS; i++)
			{
				if (i)
				{
					if ( PistasPosPlayers[pistaid][i][Valid] )
					{
				    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_VERDE"}ID: %i - Usado", i);
			    	}
			    	else
			    	{
				    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_ROJO"}ID: %i - Sin Uso", i);
					}
		    	}
				else
				{
					if ( PistasPosPlayers[pistaid][i][Valid] )
					{
				    	format(TempConvert, sizeof(TempConvert), "{"COLOR_VERDE"}ID: %i - Usado", i);
			    	}
			    	else
			    	{
				    	format(TempConvert, sizeof(TempConvert), "{"COLOR_ROJO"}ID: %i - Sin Uso", i);
					}
				}
		        strcat(PistasDialog, TempConvert, sizeof(PistasDialog));
			}
		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Editor de Pistas - %s (CarPoints)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,101,DIALOG_STYLE_LIST, PistasDialogName, PistasDialog, "Seleccionar", "Volver");
		}
		else
		{
			ShowPlayerDialogEx(playerid,94,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe detenerla antes de seguir editandola", "Aceptar", "Volver");
		}
	}
}
ShowPistaShowCheckPointsOptions(playerid, pistaid, posid)
{
    if ( PistaExist(playerid, pistaid) )
    {
        if ( !Pistas[pistaid][Used] )
        {
			new ListDialog[500];
			format(ListDialog, sizeof(ListDialog),
			"{"COLOR_AZUL"}Info: {"COLOR_CREMA"}X: %f - Y: %f - Z: %f\r\n{"COLOR_AZUL"}1- {"COLOR_CREMA"}Ir {"COLOR_VERDE"}\r\n{"COLOR_AZUL"}2- {"COLOR_CREMA"}Editar\r\n{"COLOR_AZUL"}3- {"COLOR_CREMA"}Borrar\r\n{"COLOR_AZUL"}4- {"COLOR_CREMA"}Mover",
			    PistasPos[pistaid][posid][Xpos],
			    PistasPos[pistaid][posid][Ypos],
			    PistasPos[pistaid][posid][Zpos]
			);
		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Editor de Pistas - %s (CheckPoints)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,102,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");

			PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
			PlayersDataOnline[playerid][SaveAfterAgenda][1] = posid;
		}
		else
		{
			ShowPlayerDialogEx(playerid,94,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe detenerla antes de seguir editandola", "Aceptar", "Volver");
		}
	}
}
ShowPistaShowPosPlayersOptions(playerid, pistaid, posid)
{
    if ( PistaExist(playerid, pistaid) )
    {
        if ( !Pistas[pistaid][Used] )
        {
			new ListDialog[500];
			format(ListDialog, sizeof(ListDialog),
			"{"COLOR_AZUL"}Info: {"COLOR_CREMA"}X: %f - Y: %f - Z: %f - ZZ: %f\r\n{"COLOR_AZUL"}1- {"COLOR_CREMA"}Ir {"COLOR_VERDE"}\r\n{"COLOR_AZUL"}2- {"COLOR_CREMA"}Editar\r\n{"COLOR_AZUL"}3- {"COLOR_CREMA"}Borrar\r\n{"COLOR_AZUL"}4- {"COLOR_CREMA"}Mover",
			    PistasPosPlayers[pistaid][posid][Xpos],
			    PistasPosPlayers[pistaid][posid][Ypos],
			    PistasPosPlayers[pistaid][posid][Zpos],
			    PistasPosPlayers[pistaid][posid][ZZpos]
			);
		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Editor de Pistas - %s (CarPoints)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,103,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");

			PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
			PlayersDataOnline[playerid][SaveAfterAgenda][1] = posid;
		}
		else
		{
			ShowPlayerDialogEx(playerid,94,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe detenerla antes de seguir editandola", "Aceptar", "Volver");
		}
	}
}
ShowPistaCamOptions(playerid, pistaid, posid)
{
    if ( PistaExist(playerid, pistaid) )
    {
        if ( !Pistas[pistaid][Used] )
        {
			new ListDialog[500];
			format(ListDialog, sizeof(ListDialog),
			"{"COLOR_AZUL"}Info: {"COLOR_CREMA"}X: %f - Y: %f - Z: %f - Velocidad: %f\r\n{"COLOR_AZUL"}1- {"COLOR_CREMA"}Ir {"COLOR_VERDE"}\r\n{"COLOR_AZUL"}2- {"COLOR_CREMA"}Editar\r\n{"COLOR_AZUL"}4- {"COLOR_CREMA"}Velocidad (%f)\r\n{"COLOR_AZUL"}5- {"COLOR_CREMA"}Borrar\r\n{"COLOR_AZUL"}6- {"COLOR_CREMA"}Mover",
			    PistasCameras[pistaid][posid][Xpos],
			    PistasCameras[pistaid][posid][Ypos],
			    PistasCameras[pistaid][posid][Zpos],
			    PistasCameras[pistaid][posid][Vel],
   			    PistasCameras[pistaid][posid][Vel]
			);
		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Editor de Pistas - %s (CamerasPoints)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,124,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");

			PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
			PlayersDataOnline[playerid][SaveAfterAgenda][1] = posid;
		}
		else
		{
			ShowPlayerDialogEx(playerid,94,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe detenerla antes de seguir editandola", "Aceptar", "Volver");
		}
	}
}
ShowPistaCarPointsExitOptions(playerid, pistaid, posid)
{
    if ( PistaExist(playerid, pistaid) )
    {
        if ( !Pistas[pistaid][Used] )
        {
			new ListDialog[500];
			format(ListDialog, sizeof(ListDialog),
			"{"COLOR_AZUL"}Info: {"COLOR_CREMA"}X: %f - Y: %f - Z: %f - ZZ: %f\r\n{"COLOR_AZUL"}1- {"COLOR_CREMA"}Ir {"COLOR_VERDE"}\r\n{"COLOR_AZUL"}2- {"COLOR_CREMA"}Editar\r\n{"COLOR_AZUL"}3- {"COLOR_CREMA"}Borrar\r\n{"COLOR_AZUL"}4- {"COLOR_CREMA"}Mover",
			    PistasCarPointsExit[pistaid][posid][Xpos],
			    PistasCarPointsExit[pistaid][posid][Ypos],
			    PistasCarPointsExit[pistaid][posid][Zpos],
			    PistasCarPointsExit[pistaid][posid][ZZpos]
			);
		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Editor de Pistas - %s (CarPointsExit)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,107,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");

			PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
			PlayersDataOnline[playerid][SaveAfterAgenda][1] = posid;
		}
		else
		{
			ShowPlayerDialogEx(playerid,94,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe detenerla antes de seguir editandola", "Aceptar", "Volver");
		}
	}
}
ShowPistaShowCarPointsExit(playerid, pistaid)
{
	if ( PistaExist(playerid, pistaid) )
	{
        if ( !Pistas[pistaid][Used] )
        {
		    PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
			new PistasDialog[1400];
			new TempConvert[50];
			for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS; i++)
			{
				if (i)
				{
					if ( PistasCarPointsExit[pistaid][i][Valid] )
					{
				    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_VERDE"}ID: %i - Usado", i);
			    	}
			    	else
			    	{
				    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_ROJO"}ID: %i - Sin Uso", i);
					}
		    	}
				else
				{
					if ( PistasCarPointsExit[pistaid][i][Valid] )
					{
				    	format(TempConvert, sizeof(TempConvert), "{"COLOR_VERDE"}ID: %i - Usado", i);
			    	}
			    	else
			    	{
				    	format(TempConvert, sizeof(TempConvert), "{"COLOR_ROJO"}ID: %i - Sin Uso", i);
					}
				}
		        strcat(PistasDialog, TempConvert, sizeof(PistasDialog));
			}
		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Editor de Pistas - %s (CarPointsExit)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,106,DIALOG_STYLE_LIST, PistasDialogName, PistasDialog, "Seleccionar", "Volver");
		}
		else
		{
			ShowPlayerDialogEx(playerid,94,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe detenerla antes de seguir editandola", "Aceptar", "Volver");
		}
	}
}
ShowPistaShowCam(playerid, pistaid)
{
	if ( PistaExist(playerid, pistaid) )
	{
        if ( !Pistas[pistaid][Used] )
        {
		    PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
			new PistasDialog[1400];
			new TempConvert[50];
			for (new i = 0; i < MAX_COUNT_PISTAS_CAMERAS; i++)
			{
				if (i)
				{
					if ( PistasCameras[pistaid][i][Valid] )
					{
				    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_VERDE"}ID: %i - Usado", i);
			    	}
			    	else
			    	{
				    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_ROJO"}ID: %i - Sin Uso", i);
					}
		    	}
				else
				{
					if ( PistasCameras[pistaid][i][Valid] )
					{
				    	format(TempConvert, sizeof(TempConvert), "{"COLOR_VERDE"}ID: %i - Usado", i);
			    	}
			    	else
			    	{
				    	format(TempConvert, sizeof(TempConvert), "{"COLOR_ROJO"}ID: %i - Sin Uso", i);
					}
				}
		        strcat(PistasDialog, TempConvert, sizeof(PistasDialog));
			}
		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Editor de Pistas - %s (CamerasPoints)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,123,DIALOG_STYLE_LIST, PistasDialogName, PistasDialog, "Seleccionar", "Volver");
		}
		else
		{
			ShowPlayerDialogEx(playerid,94,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe detenerla antes de seguir editandola", "Aceptar", "Volver");
		}
	}
}
ShowPistaRemove(playerid, pistaid)
{
    if ( !Pistas[pistaid][Used] )
    {
		ShowPlayerDialogEx(playerid,104,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Eliminar Pista", "{"COLOR_CREMA"}Esta seguro que desea eliminar esta pista?", "Si", "No");
	}
	else
	{
		ShowPlayerDialogEx(playerid,94,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe detenerla antes de seguir editandola", "Aceptar", "Volver");
	}
}
ShowPistaValidar(playerid, pistaid)
{
    if ( !Pistas[pistaid][Used] )
    {
		if ( ValidingPista(pistaid, false) )
		{
			ShowPlayerDialogEx(playerid,105,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Validacion OK", "{"COLOR_VERDE"}La pista se ha validado correctamente", "Ok", "");
		}
		else
		{
			ShowPlayerDialogEx(playerid,105,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error en Validacion", "{"COLOR_ROJO"}No se pudo validar la pista\nRevise la misma y intentelo de nuevo", "Ok", "");
		}
	}
	else
	{
		ShowPlayerDialogEx(playerid,94,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Editor de Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe detenerla antes de seguir editandola", "Aceptar", "Volver");
	}
}
ShowOrHideTagPistaPos(pistaid)
{
	if ( Pistas[pistaid][ShowTagPos] )
	{
		for (new i = 0; i < MAX_COUNT_PISTAS_POS;i++)
		{
			if ( PistasPos[pistaid][i][Valid] )
			{
				UpdateTagPistaPos(pistaid, i);
			}
		}
	}
	else
	{
		for (new i = 0; i < MAX_COUNT_PISTAS_POS;i++)
		{
			if ( PistasPos[pistaid][i][Valid] )
			{
			    RemoveTagPistaPos(pistaid, i);
			}
		}
	}
}
ShowOrHideTagPistaPlayers(pistaid)
{
	if ( Pistas[pistaid][ShowTagPlayers] )
	{
		for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
		{
			if ( PistasPosPlayers[pistaid][i][Valid] )
			{
				UpdateTagPistaPlayers(pistaid, i);
			}
		}
	}
	else
	{
		for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
		{
			if ( PistasPosPlayers[pistaid][i][Valid] )
			{
			    RemoveTagPistaPlayers(pistaid, i);
			}
		}
	}
}
RemoveTagPistaPos(pistaid, posid)
{
	if ( PistasPos[pistaid][posid][Text3DPistaB] )
	{
		Delete3DTextLabel(PistasPos[pistaid][posid][Text3DPista]);
		PistasPos[pistaid][posid][Text3DPistaB] = false;
	}
}
UpdateTagPistaPos(pistaid, posid)
{
	if ( PistasPos[pistaid][posid][Text3DPistaB] )
	{
		Delete3DTextLabel(PistasPos[pistaid][posid][Text3DPista]);
	}
	if ( PistasPos[pistaid][posid][Valid] && Pistas[pistaid][ShowTagPos])
	{
		new MsgObject3D[400];
		format(MsgObject3D, sizeof(MsgObject3D), "Nombre: %s[ID:%i]\n\nPosX: %f\nPosY: %f\nPosZ: %f",
		Pistas[pistaid][NamePista],
		posid,
		PistasPos[pistaid][posid][Xpos],
		PistasPos[pistaid][posid][Ypos],
		PistasPos[pistaid][posid][Zpos]
		);
		PistasPos[pistaid][posid][Text3DPista] = Create3DTextLabel(MsgObject3D,0x0055FFFF,
		PistasPos[pistaid][posid][Xpos],
		PistasPos[pistaid][posid][Ypos],
		PistasPos[pistaid][posid][Zpos],
		300.0,
		Pistas[pistaid][World]);
		PistasPos[pistaid][posid][Text3DPistaB] = true;
	}
	else
	{
		PistasPos[pistaid][posid][Text3DPistaB] = false;
	}
}
RemoveTagPistaPlayers(pistaid, posid)
{
	if ( PistasPosPlayers[pistaid][posid][Text3DPistaB] )
	{
		Delete3DTextLabel(PistasPosPlayers[pistaid][posid][Text3DPista]);
		PistasPosPlayers[pistaid][posid][Text3DPistaB] = false;
	}
}
UpdateTagPistaPlayers(pistaid, posid)
{
	if ( PistasPosPlayers[pistaid][posid][Text3DPistaB] )
	{
		Delete3DTextLabel(PistasPosPlayers[pistaid][posid][Text3DPista]);
	}
	if ( PistasPosPlayers[pistaid][posid][Valid] && Pistas[pistaid][ShowTagPlayers])
	{
		new MsgObject3D[400];
		format(MsgObject3D, sizeof(MsgObject3D), "Nombre: %s[ID:%i]\n\nPosX: %f\nPosY: %f\nPosZ: %f\nPosZZ: %f",
		Pistas[pistaid][NamePista],
		posid,
		PistasPosPlayers[pistaid][posid][Xpos],
		PistasPosPlayers[pistaid][posid][Ypos],
		PistasPosPlayers[pistaid][posid][Zpos],
		PistasPosPlayers[pistaid][posid][ZZpos]
		);
		PistasPosPlayers[pistaid][posid][Text3DPista] = Create3DTextLabel(MsgObject3D,COLOR_3DLABEL_PISTAS,
		PistasPosPlayers[pistaid][posid][Xpos],
		PistasPosPlayers[pistaid][posid][Ypos],
		PistasPosPlayers[pistaid][posid][Zpos],
		300.0, Pistas[pistaid][World]);
		PistasPosPlayers[pistaid][posid][Text3DPistaB] = true;
	}
}
RemoveTagPistaCarPointsExit(pistaid, posid)
{
	if ( PistasCarPointsExit[pistaid][posid][Text3DPistaB] )
	{
		Delete3DTextLabel(PistasCarPointsExit[pistaid][posid][Text3DPista]);
		PistasCarPointsExit[pistaid][posid][Text3DPistaB] = false;
	}
}
UpdateTagPistaCarPointsExit(pistaid, posid)
{
	if ( PistasCarPointsExit[pistaid][posid][Text3DPistaB] )
	{
		Delete3DTextLabel(PistasCarPointsExit[pistaid][posid][Text3DPista]);
	}
	if ( PistasCarPointsExit[pistaid][posid][Valid] && Pistas[pistaid][ShowTagCarPointsExit])
	{
		new MsgObject3D[400];
		format(MsgObject3D, sizeof(MsgObject3D), "Nombre: %s[ID:%i]\n\nPosX: %f\nPosY: %f\nPosZ: %f\nPosZZ: %f",
		Pistas[pistaid][NamePista],
		posid,
		PistasCarPointsExit[pistaid][posid][Xpos],
		PistasCarPointsExit[pistaid][posid][Ypos],
		PistasCarPointsExit[pistaid][posid][Zpos],
		PistasCarPointsExit[pistaid][posid][ZZpos]
		);
		PistasCarPointsExit[pistaid][posid][Text3DPista] = Create3DTextLabel(MsgObject3D,0x00AD28FF,
		PistasCarPointsExit[pistaid][posid][Xpos],
		PistasCarPointsExit[pistaid][posid][Ypos],
		PistasCarPointsExit[pistaid][posid][Zpos],
		300.0, Pistas[pistaid][World]);
		PistasCarPointsExit[pistaid][posid][Text3DPistaB] = true;
	}
}
RemoveTagPistaCameras(pistaid, posid)
{
	if ( PistasCameras[pistaid][posid][Text3DPistaB] )
	{
		Delete3DTextLabel(PistasCameras[pistaid][posid][Text3DPista]);
		PistasCameras[pistaid][posid][Text3DPistaB] = false;
	}
}
UpdateTagPistaCameras(pistaid, posid)
{
	if ( PistasCameras[pistaid][posid][Text3DPistaB] )
	{
		Delete3DTextLabel(PistasCameras[pistaid][posid][Text3DPista]);
	}
	if ( PistasCameras[pistaid][posid][Valid] && Pistas[pistaid][ShowTagCamPoints])
	{
		new MsgObject3D[400];
		format(MsgObject3D, sizeof(MsgObject3D), "Nombre: %s[ID:%i]\n\nPosX: %f\nPosY: %f\nPosZ: %f\nVelocidad: %f",
		Pistas[pistaid][NamePista],
		posid,
		PistasCameras[pistaid][posid][Xpos],
		PistasCameras[pistaid][posid][Ypos],
		PistasCameras[pistaid][posid][Zpos],
		PistasCameras[pistaid][posid][Vel]
		);
		PistasCameras[pistaid][posid][Text3DPista] = Create3DTextLabel(MsgObject3D,0xFA00FFFF,
		PistasCameras[pistaid][posid][Xpos],
		PistasCameras[pistaid][posid][Ypos],
		PistasCameras[pistaid][posid][Zpos],
		300.0, Pistas[pistaid][World]);
		PistasCameras[pistaid][posid][Text3DPistaB] = true;
	}
}
ShowOrHideTagPistaCam(pistaid)
{
	if ( Pistas[pistaid][ShowTagCamPoints] )
	{
		for (new i = 0; i < MAX_COUNT_PISTAS_CAMERAS;i++)
		{
			if ( PistasCameras[pistaid][i][Valid] )
			{
				UpdateTagPistaCameras(pistaid, i);
			}
		}
	}
	else
	{
		for (new i = 0; i < MAX_COUNT_PISTAS_CAMERAS;i++)
		{
			if ( PistasCameras[pistaid][i][Valid] )
			{
			    RemoveTagPistaCameras(pistaid, i);
			}
		}
	}
}
ShowOrHideTagPistaCarPointsExit(pistaid)
{
	if ( Pistas[pistaid][ShowTagCarPointsExit] )
	{
		for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
		{
			if ( PistasCarPointsExit[pistaid][i][Valid] )
			{
				UpdateTagPistaCarPointsExit(pistaid, i);
			}
		}
	}
	else
	{
		for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
		{
			if ( PistasCarPointsExit[pistaid][i][Valid] )
			{
			    RemoveTagPistaCarPointsExit(pistaid, i);
			}
		}
	}
}
ShowPistas(playerid)
{
	new PistasDialog[1500];
	new TempConvert[100];
	new ConteoPistas = -1;
	for (new i = 0; i < MAX_COUNT_PISTAS; i++)
	{
	    if ( Pistas[i][ValidR] )
	    {
	        if ( !Pistas[i][Lock] || Pistas[i][Lock] && PlayersData[playerid][Admin] >= 4 )
	        {
				if ( ConteoPistas != -1 )
				{
					if ( Pistas[i][Lock] )
					{
				    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_VERDE"}%s {"COLOR_AMARILLO"}(%s)", Pistas[i][NamePista], PistasTypeUses[Pistas[i][Used]]);
			    	}
			    	else
			    	{
				    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_CREMA"}%s {"COLOR_AMARILLO"}(%s)", Pistas[i][NamePista], PistasTypeUses[Pistas[i][Used]]);
					}
		    	}
				else
				{
					if ( Pistas[i][Lock] )
					{
			    		format(TempConvert, sizeof(TempConvert), "{"COLOR_VERDE"}%s {"COLOR_AMARILLO"}(%s)", Pistas[i][NamePista], PistasTypeUses[Pistas[i][Used]]);
		    		}
		    		else
		    		{
			    		format(TempConvert, sizeof(TempConvert), "{"COLOR_CREMA"}%s {"COLOR_AMARILLO"}(%s)", Pistas[i][NamePista], PistasTypeUses[Pistas[i][Used]]);
					}
				}
		        strcat(PistasDialog, TempConvert, sizeof(PistasDialog));
		        ConteoPistas++;
		        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoPistas] = i;
	        }
        }
	}
	if (ConteoPistas != -1)
	{
		ShowPlayerDialogEx(playerid,109,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Pistas - Lista de Pistas", PistasDialog, "Seleccionar", "Salir");
	}
	else
	{
		ShowPlayerDialogEx(playerid,999,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Pistas - Error", "{"COLOR_CREMA"}No se encontaron pistas creadas", "Ok", "");
	}
}
ShowPistasOptions(playerid, pistaid)
{
    if ( PistaExist(playerid, pistaid) )
    {
		new ListDialog[850];
		format(ListDialog, sizeof(ListDialog),
		"{"COLOR_AZUL"}Info: {"COLOR_CREMA"}Maximo de competidores: {"COLOR_VERDE"}(%i)\r\n{"COLOR_AZUL"}1- {"COLOR_CREMA"}Vueltas {"COLOR_VERDE"}(%i)\r\n{"COLOR_AZUL"}2- {"COLOR_CREMA"}Competidores {"COLOR_VERDE"}(%i)\r\n{"COLOR_AZUL"}3- {"COLOR_CREMA"}Guardar Record {"COLOR_VERDE"}(%s)\r\n{"COLOR_AZUL"}4- {"COLOR_CREMA"}Conteo {"COLOR_VERDE"}(%i)\r\n{"COLOR_AZUL"}5- {"COLOR_CREMA"}Tiempo antes de empezar {"COLOR_VERDE"}(%i)\r\n{"COLOR_AZUL"}6- {"COLOR_CREMA"}Radio de los CheckPoints {"COLOR_VERDE"}(%.1f)\r\n",
			GetMaxCountPistasPlayers(pistaid),
			Pistas[pistaid][Vueltas],
			Pistas[pistaid][Competidores] + 1,
			SiOrNo[Pistas[pistaid][SaveRecord]],
			Pistas[pistaid][ConteoR],
			Pistas[pistaid][TiempoAntes],
			Pistas[pistaid][Radio]
		);
		format(ListDialog, sizeof(ListDialog),
		"%s{"COLOR_AZUL"}7- {"COLOR_CREMA"}Tipo de Checkpoints: {"COLOR_VERDE"}(%s)\r\n{"COLOR_AZUL"}8- {"COLOR_CREMA"}Estado: {"COLOR_VERDE"}(%s)\r\n{"COLOR_AZUL"}9- {"COLOR_CREMA"}Coches Permitidos: {"COLOR_VERDE"}(%s)\r\n{"COLOR_AZUL"}10- {"COLOR_CREMA"}Al Reves: {"COLOR_VERDE"}(%s)\r\n{"COLOR_AZUL"}11- {"COLOR_CREMA"}Indestructible: {"COLOR_VERDE"}(%s)\r\n{"COLOR_AZUL"}12- {"COLOR_CREMA"}CheckPoint Final: {"COLOR_VERDE"}(ID:%i)\r\n{"COLOR_AZUL"}13- {"COLOR_CREMA"}Unir un Jugador\r\n{"COLOR_AZUL"}14- {"COLOR_CREMA"}Ver Jugadores {"COLOR_VERDE"}(%i)\r\n{"COLOR_AZUL"}15- {"COLOR_CREMA"}Detener Carrera!\r\n{"COLOR_AZUL"}16- {"COLOR_CREMA"}Comenzar Carrera!",
		    ListDialog,
			PistasType[Pistas[pistaid][Tipo]],
			PistasTypeEstados[Pistas[pistaid][EstadoR]],
			CochesPistaNames[Pistas[pistaid][CochesP]],
			SiOrNo[Pistas[pistaid][AlReves]],
			SiOrNo[Pistas[pistaid][Repair]],
			Pistas[pistaid][CheckPointFinal],
			GetMaxPlayerCurrentPista(pistaid)
		);
	    new PistasDialogName[MAX_TEXT_CHAT];
	    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s (Configuracion)", Pistas[pistaid][NamePista]);
		ShowPlayerDialogEx(playerid,110,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");

		PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
	}
}
ShowPistasSelectVueltas(playerid, pistaid)
{
    if ( PistaExist(playerid, pistaid) )
    {
        if ( !Pistas[pistaid][Used] )
        {
			new ListDialog[600];
			new TempConvert[15];
			for ( new i = 0; i < 50; i++ )
			{
			    if ( i )
			    {
					format(TempConvert, sizeof(TempConvert),
					"\r\n{"COLOR_AZUL"}%i",i + 1);
				}
				else
				{
					format(TempConvert, sizeof(TempConvert),
					"{"COLOR_AZUL"}%i",i + 1);
				}

				strcat(ListDialog, TempConvert, sizeof(ListDialog));
			}

		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s (Vueltas)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,111,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");

			PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
		}
		else
		{
			ShowPlayerDialogEx(playerid,120,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe esperar que finalize para crear otra", "Aceptar", "Volver");
		}
	}
}
ShowPistasSelectVelocidad(playerid, pistaid, posid)
{
    if ( PistaExist(playerid, pistaid) )
    {
        if ( !Pistas[pistaid][Used] )
        {
			PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
			PlayersDataOnline[playerid][SaveAfterAgenda][1] = posid;
			new VelDialog[700];
			format(VelDialog, sizeof(VelDialog),
			"{"COLOR_VERDE"}1- {"COLOR_VERDE"}0.1 (Rapido)\r\n{"COLOR_VERDE"}2- {"COLOR_VERDE"}0.01 (Normal)\r\n{"COLOR_VERDE"}3- {"COLOR_VERDE"}0.001 (Lento)\r\n{"COLOR_VERDE"}4- {"COLOR_AZUL"}A Gusto");

		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s (Velocidad)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,125,DIALOG_STYLE_LIST, PistasDialogName, VelDialog, "Seleccionar", "Volver");
		}
		else
		{
			ShowPlayerDialogEx(playerid,120,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe esperar que finalize para crear otra", "Aceptar", "Volver");
		}
	}
}
ShowPistasSelectCompetidores(playerid, pistaid)
{
    if ( PistaExist(playerid, pistaid) )
    {
        if ( !Pistas[pistaid][Used] )
        {
			new ListDialog[500];
			new TempConvert[15];
			for ( new i = 0; i < GetMaxCountPistasPlayers(pistaid); i++ )
			{
			    if ( i )
			    {
					format(TempConvert, sizeof(TempConvert),
					"\r\n{"COLOR_ROJO"}%i",i + 1);
				}
				else
				{
					format(TempConvert, sizeof(TempConvert),
					"{"COLOR_ROJO"}%i",i + 1);
				}

				strcat(ListDialog, TempConvert, sizeof(ListDialog));
			}

		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s (Competidores)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,112,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");

			PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
		}
		else
		{
			ShowPlayerDialogEx(playerid,120,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe esperar que finalize para crear otra", "Aceptar", "Volver");
		}
	}
}
ShowPistasSelectConteo(playerid, pistaid)
{
    if ( PistaExist(playerid, pistaid) )
    {
        if ( !Pistas[pistaid][Used] )
        {
			new ListDialog[500];
			new TempConvert[15];
			for ( new i = 0; i < 15; i++ )
			{
			    if ( i )
			    {
					format(TempConvert, sizeof(TempConvert),
					"\r\n{"COLOR_AZUL"}%i",i + 1);
				}
				else
				{
					format(TempConvert, sizeof(TempConvert),
					"{"COLOR_AZUL"}%i",i + 1);
				}

				strcat(ListDialog, TempConvert, sizeof(ListDialog));
			}

		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s (Conteo)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,113,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");

			PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
		}
		else
		{
			ShowPlayerDialogEx(playerid,120,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe esperar que finalize para crear otra", "Aceptar", "Volver");
		}
	}
}
ShowPistasSelectRadio(playerid, pistaid)
{
    if ( PistaExist(playerid, pistaid) )
    {
        if ( !Pistas[pistaid][Used] )
        {
			new ListDialog[800];
			new TempConvert[15];
			for ( new i = 2; i < 61; i+=2)
			{
			    if ( i != 2 )
			    {
					format(TempConvert, sizeof(TempConvert),
					"\r\n{AFFF00}%i",i);
				}
				else
				{
					format(TempConvert, sizeof(TempConvert),
					"{AFFF00}%i",i);
				}

				strcat(ListDialog, TempConvert, sizeof(ListDialog));
			}

		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s (Radio CheckPoints)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,122,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");

			PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
		}
		else
		{
			ShowPlayerDialogEx(playerid,120,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe esperar que finalize para crear otra", "Aceptar", "Volver");
		}
	}
}
ShowPistasSelectTiempoAntes(playerid, pistaid)
{
    if ( PistaExist(playerid, pistaid) )
    {
        if ( !Pistas[pistaid][Used] )
        {
			new ListDialog[500];
			new TempConvert[15];
			for ( new i = 10; i < 161; i+=10)
			{
			    if ( i != 10 )
			    {
					format(TempConvert, sizeof(TempConvert),
					"\r\n{"COLOR_AMARILLO"}%i",i);
				}
				else
				{
					format(TempConvert, sizeof(TempConvert),
					"{"COLOR_AMARILLO"}%i",i);
				}

				strcat(ListDialog, TempConvert, sizeof(ListDialog));
			}

		    new PistasDialogName[MAX_TEXT_CHAT];
		    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s (Tiempo)", Pistas[pistaid][NamePista]);
			ShowPlayerDialogEx(playerid,114,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");

			PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
		}
		else
		{
			ShowPlayerDialogEx(playerid,120,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe esperar que finalize para crear otra", "Aceptar", "Volver");
		}
	}
}
ShowPistasCochesPermitidos(playerid, pistaid)
{
    if ( PistaExist(playerid, pistaid) )
    {
		new ListDialog[500];
		new TempConvert[20];
		for ( new i = 0; i < sizeof(CochesPistaNames); i++)
		{
		    if (i)
		    {
				format(TempConvert, sizeof(TempConvert),
				"\r\n{"COLOR_AZUL"}%s",CochesPistaNames[i]);
			}
			else
			{
				format(TempConvert, sizeof(TempConvert),
				"{"COLOR_AZUL"}%s",CochesPistaNames[i]);
			}

			strcat(ListDialog, TempConvert, sizeof(ListDialog));
		}

	    new PistasDialogName[MAX_TEXT_CHAT];
	    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s (Coches)", Pistas[pistaid][NamePista]);
		ShowPlayerDialogEx(playerid,115,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");

		PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
	}
}
ShowPistasUnirJugador(playerid, pistaid)
{
    if ( Pistas[pistaid][Used] == RACE_STATE_ESPERANDO )
    {
	    new PistasDialogName[MAX_TEXT_CHAT];
	    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s (Agregar)", Pistas[pistaid][NamePista]);
		ShowPlayerDialogEx(playerid,118,DIALOG_STYLE_INPUT, PistasDialogName, "{"COLOR_CREMA"}Ingrese la ID del jugador que desea incluir a esta carrera", "Unir", "Volver");
		PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
	}
	else
	{
		SendInfoMessage(playerid, 0, "1434", "No puede agregar jugadores si no ha iniciado la carrera, tampoco mientras este en ejecucion la misma");
		ShowPistasOptions(playerid, pistaid);
	}
}
ShowPistasVerJugadoresOptions(playerid, pistaid, posid)
{
	new ListDialog[150];
	format(ListDialog, sizeof(ListDialog),
	"{"COLOR_AZUL"}1- {"COLOR_CREMA"}Enviar Mensaje\r\n{"COLOR_AZUL"}2- {"COLOR_CREMA"}Expulsar"	);

    new PistasDialogName[MAX_TEXT_CHAT];
    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s (Jugadores)", Pistas[pistaid][NamePista]);
	ShowPlayerDialogEx(playerid,119,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");

	PlayersDataOnline[playerid][SaveAfterAgenda][0] = pistaid;
	PlayersDataOnline[playerid][SaveAfterAgenda][1] = posid;
}
ShowPistasVerJugadores(playerid, pistaid)
{
	PlayersDataOnline[playerid][SaveAfterAgenda][59] = pistaid;
    if ( Pistas[pistaid][Used] )
    {
		new ListDialog[1200];
		new TempConvert[55];
		new ConteoPista = -1;
		for ( new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS; i++)
		{
		    if ( PistasPosPlayers[pistaid][i][Valid] && PistasPosPlayers[pistaid][i][PlayerIDR] != -1 )
		    {
			    if (ConteoPista != -1)
			    {
					format(TempConvert, sizeof(TempConvert),
					"\r\n{"COLOR_AZUL"}%s{"COLOR_AMARILLO"}[%i]",PlayersDataOnline[PistasPosPlayers[pistaid][i][PlayerIDR]][NameOnlineFix], PistasPosPlayers[pistaid][i][PlayerIDR]);
				}
				else
				{
					format(TempConvert, sizeof(TempConvert),
					"{"COLOR_AZUL"}%s{"COLOR_AMARILLO"}[%i]",PlayersDataOnline[PistasPosPlayers[pistaid][i][PlayerIDR]][NameOnlineFix], PistasPosPlayers[pistaid][i][PlayerIDR]);
				}
				strcat(ListDialog, TempConvert, sizeof(ListDialog));
				ConteoPista++;
				PlayersDataOnline[playerid][SaveAfterAgenda][ConteoPista] = i;
			}
		}
	    new PistasDialogName[MAX_TEXT_CHAT];
	    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s (Jugadores)", Pistas[pistaid][NamePista]);
		if (ConteoPista != -1)
		{
			ShowPlayerDialogEx(playerid,116,DIALOG_STYLE_LIST, PistasDialogName, ListDialog, "Seleccionar", "Volver");
		}
		else
		{
			ShowPlayerDialogEx(playerid,116,DIALOG_STYLE_MSGBOX, PistasDialogName, "{"COLOR_CREMA"}No hay jugadores en esta pista todavia.", "Refrescar", "Volver");
		}
	}
	else
	{
		SendInfoMessage(playerid, 0, "1433", "Debe iniciar la carrera antes de ver la lista de jugadores");
		ShowPistasOptions(playerid, pistaid);
	}
}
ShowPistasComenzar(playerid, pistaid)
{
    if ( PistaExist(playerid, pistaid) )
    {
        if ( !Pistas[pistaid][Used] )
        {
			if ( ValidingPista(pistaid, false) )
			{
                CleanPistaForRace(pistaid);
                StartRace(pistaid, true);
			    new PistasDialogName[MAX_TEXT_CHAT];
			    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s", Pistas[pistaid][NamePista]);
				ShowPlayerDialogEx(playerid,120,DIALOG_STYLE_MSGBOX,PistasDialogName, "{"COLOR_VERDE"}Has abierto la carrera con exito!", "Aceptar", "Volver");
			}
			else
			{
				ShowPlayerDialogEx(playerid,120,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Pistas - Error", "{"COLOR_ROJO"}Esta pista no paso el proceso de validacion!", "Aceptar", "Volver");
			}
		}
		else
		{
			ShowPlayerDialogEx(playerid,120,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Pistas - Error", "{"COLOR_CREMA"}Esta pista esta siendo usada en una carrera,\ndebe esperar que finalize para crear otra", "Aceptar", "Volver");
		}
	}
}
CleanPistaForRace(pistaid)
{
    for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
    {
        PistasPosPlayers[pistaid][i][PlayerIDR] 	 = -1;
        PistasPosPlayers[pistaid][i][VehicleIDR] 	 = -1;
        PistasPosPlayers[pistaid][i][VueltaR] 		 = 0;
        PistasPosPlayers[pistaid][i][ExitReason]     = -1;

        PistasPosPlayers[pistaid][i][PistaIDR]     	 = -1;
		PistasPosPlayers[pistaid][i][PosFinish]  	 = 50;

        if ( Pistas[pistaid][AlReves] )
        {
        	PistasPosPlayers[pistaid][i][LastCheckPoint] = Pistas[pistaid][MinPP];
       	}
       	else
       	{
        	PistasPosPlayers[pistaid][i][LastCheckPoint] = Pistas[pistaid][MaxPP];
		}
    }
	Pistas[pistaid][ConteoPlayers] = false;
}
CancelRace(pistaid)
{
	if ( Pistas[pistaid][Used] )
	{
        KillTimer(Pistas[pistaid][RaceTimer]);

	    for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
	    {
		    if ( PistasPosPlayers[pistaid][i][Valid] && PistasPosPlayers[pistaid][i][PlayerIDR] != -1 )
		    {
				RemovePlayerToRace(PistasPosPlayers[pistaid][i][PlayerIDR], true, false, STATE_RACE_EXIT_EXPULSADO);
			}
		}
		Pistas[pistaid][Used] = false;
		return true;
	}
	return false;
}
GetMaxPlayerCurrentPista(pistaid)
{
	new CountPista;
    for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
    {
		if ( PistasPosPlayers[pistaid][i][Valid] && PistasPosPlayers[pistaid][i][PlayerIDR] != -1 )
		{
		    CountPista++;
		}
    }
    return CountPista;
}
IsVehiceInRace(vehicleIndex)
{
	for (new p = 0; p < MAX_COUNT_PISTAS;p++)
    {
		for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
	    {
	        if ( Pistas[p][Used] && PistasPosPlayers[p][i][PlayerIDR] && PistasPosPlayers[p][i][VehicleIDR] == DataCars[vehicleIndex][VehicleID] )
	        {
	            return PistasPosPlayers[p][i][PlayerIDR];
	        }
		}
	}
	return -1;
}
RemovePlayerToRace(playerid, option, optiontwo, reason)
{
    if ( PlayersDataOnline[playerid][PistaIDp] != -1 )
    {
		new vehicleid = PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VehicleIDR];
		new vehicleIndex = GetVehicleIndexByVehicleID(vehicleid);
		if (vehicleIndex == -1) return -1;
		DataCars[vehicleIndex][LastX] 		= PistasCarPointsExit[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][Xpos];
		DataCars[vehicleIndex][LastY] 		= PistasCarPointsExit[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][Ypos];
		DataCars[vehicleIndex][LastZ] 		= PistasCarPointsExit[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][Zpos];
		DataCars[vehicleIndex][LastZZ] 		= PistasCarPointsExit[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][ZZpos];
		DataCars[vehicleIndex][WorldLast] 	= Pistas[PlayersDataOnline[playerid][PistaIDp]][World];
		DataCars[vehicleIndex][InteriorLast] = Pistas[PlayersDataOnline[playerid][PistaIDp]][Interior];
        DataCars[vehicleIndex][LastDamage] = 1000.0;
        // if ( vehicleid > MAX_CAR_FACCION )
        // {
        //     CleanTunningSlots(PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VehicleIDR]);
		// }
		DestroyVehicle(vehicleid);
        SetLastSettingVehicle(vehicleIndex);
		RepairVehicle(vehicleid);

		// UpdateGasAndOil(vehicleIndex); // nuevo velocimetro - eliminado sistema viejo

		DataCars[vehicleIndex][AlarmOn] = false;
		DataCars[vehicleIndex][StateEncendido] = true;
		DataCars[vehicleIndex][Puente] = false;

		IsVehicleOff(vehicleIndex);

		if ( DataCars[vehicleIndex][VehicleDeath] )
		{
			DataCars[vehicleIndex][VehicleDeath] = false;
			KillTimer(DataCars[vehicleIndex][TimerIdBug]);
		}

        if (option)
        {
			DisablePlayerRaceCheckpoint(playerid);
	    	UpdateDamage(playerid, DataCars[vehicleIndex][LastDamage], vehicleIndex);
			TextDrawHideForPlayer(playerid, ScorePosRace[PlayersDataOnline[playerid][PistaIDp]]);
			TextDrawHideForPlayer(playerid, ScoreRaceBox);

			SetPlayerVirtualWorldEx(playerid, Pistas[PlayersDataOnline[playerid][PistaIDp]][World]);
			SetPlayerInteriorEx(playerid, Pistas[PlayersDataOnline[playerid][PistaIDp]][Interior]);
            PutPlayerInVehicle(playerid, vehicleid, 0);
            TogglePlayerControllable(playerid, true);
            SetCameraBehindPlayer(playerid);

            PlayersDataOnline[playerid][VidaOn] = 80.0;
		}

		if ( Pistas[PlayersDataOnline[playerid][PistaIDp]][Used] 		== RACE_STATE_CONTEO ||
			 Pistas[PlayersDataOnline[playerid][PistaIDp]][Used] 		== RACE_STATE_ESPERANDO )
		{
			if ( Pistas[PlayersDataOnline[playerid][PistaIDp]][IsCameras] )
			{
				KillTimer(PlayersDataOnline[playerid][TimerCamaraIdRace]);
			}
		}

		PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][PlayerIDR] = -1;
		PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VehicleIDR] = -1;
		PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][ExitReason] = reason;

        new CarreraID = PlayersDataOnline[playerid][PistaIDp];
        PlayersDataOnline[playerid][PistaIDp] 	= -1;
        PlayersDataOnline[playerid][PosIDp] 	= -1;

        if ( optiontwo && Pistas[CarreraID][Used] != RACE_STATE_ESPERANDO && !GetMaxPlayerCurrentPista(CarreraID)  )
        {
            if ( !Pistas[CarreraID][ConteoPlayers] )
            {
	            new MsgCarreraFinish[MAX_TEXT_CHAT];
			    format(MsgCarreraFinish, sizeof(MsgCarreraFinish), "{"COLOR_AZUL"}La carrera finalizó debido a que los concursantes abandonarón la carrera!");
				SendMessageToRaceChat(CarreraID, MsgCarreraFinish, true);
			    CancelRace(CarreraID);
		    }
		    else
		    {
				ShowStatsRace(CarreraID);
			}
		}
        return CarreraID;
    }
    else
    {
        return -1;
	}
}
AddPlayerToRace(playerid, pistaid, option)
{
	if ( PlayersDataOnline[playerid][PistaIDp] == -1 )
	{
	    if ( Pistas[pistaid][Used] == RACE_STATE_ESPERANDO )
	    {
	        if ( !Pistas[pistaid][EstadoR] || option)
	        {
		        if ( IsPlayerInAnyVehicle(playerid) )
		        {
		            if ( !Pistas[pistaid][CochesP] || coches_Todos_Type[GetVehicleModel(GetPlayerVehicleID(playerid)) - 400] == Pistas[pistaid][CochesP] )
		            {
		                if ( GetMaxPlayerCurrentPista(pistaid) < Pistas[pistaid][Competidores] + 1 )
		                {
		                    if ( GetPlayerVehicleSeat(playerid) == 0 )
		                    {
								new vehicleIndex = GetVehicleIndexByVehicleID(GetPlayerVehicleID(playerid));
		                        if ( IsVehiceInRace(vehicleIndex) == -1 )
		                        {
							        for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
							        {
							            if ( PistasPosPlayers[pistaid][i][Valid] && PistasPosPlayers[pistaid][i][PlayerIDR] == -1 )
							            {
							                PistasPosPlayers[pistaid][i][VehicleIDR] = GetPlayerVehicleID(playerid);
							                PistasPosPlayers[pistaid][i][ExitReason] = -1;
											PistasPosPlayers[pistaid][i][PlayerIDR]  = playerid;
						   	                PlayersDataOnline[playerid][PistaIDp] 	 = pistaid;
						                   	PlayersDataOnline[playerid][PosIDp] 	 = i;
											/*DataCars[PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VehicleIDR]][AlarmOn] = false;
											DataCars[PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VehicleIDR]][StateEncendido] = false;
											DataCars[PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VehicleIDR]][Puente] = false;

											IsVehicleOff(PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VehicleIDR]);*/
				          					
				          					SetVehiclePos(PistasPosPlayers[pistaid][i][VehicleIDR], PistasPosPlayers[pistaid][i][Xpos], PistasPosPlayers[pistaid][i][Ypos], PistasPosPlayers[pistaid][i][Zpos]);
				          					SetVehicleZAngle(PistasPosPlayers[pistaid][i][VehicleIDR], PistasPosPlayers[pistaid][i][ZZpos]);
				          					SetVehicleVirtualWorldEx(vehicleIndex, Pistas[pistaid][World]);
				          					LinkVehicleToInteriorEx(vehicleIndex, Pistas[pistaid][Interior]);

				          					TogglePlayerControllable(playerid, false);

				          					SetCameraBehindPlayer(playerid);

				          					format(PistasPosPlayers[pistaid][i][NameR], MAX_PLAYER_NAME, "%s", PlayersDataOnline[playerid][NameOnlineFix]);

								            if ( Pistas[PlayersDataOnline[playerid][PistaIDp]][IsCameras] )
								            {
									            SetCameraPresentRace(playerid, PlayersDataOnline[playerid][PistaIDp],
												0,
												0,
									            PistasCameras[PlayersDataOnline[playerid][PistaIDp]][0][Xpos],
									            PistasCameras[PlayersDataOnline[playerid][PistaIDp]][0][Ypos],
									            PistasCameras[PlayersDataOnline[playerid][PistaIDp]][0][Zpos]);
								            }
							                return 5;
							            }
									}
									return 4;
								}
								else
								{
								    return 9;
								}
							}
							else
							{
							    return 8;
							}
						}
						else
						{
						    return 6;
						}
					}
					else
					{
					    return 3;
					}
				}
				else
				{
				    return 2;
				}
			}
			else
			{
			    return 1;
			}
	    }
	    else
	    {
	        return false;
		}
	}
	else
	{
	    return 7;
	}
}
ShowPistaSelectCheckPoint(playerid, pistaid)
{
	if ( PistaExist(playerid, pistaid) )
	{
	    PlayersDataOnline[playerid][SaveAfterAgenda][59] = pistaid;
		new PistasDialog[2500];
		new TempConvert[50];
		new ConteoPistas = -1;
		for (new i = 0; i < MAX_COUNT_PISTAS_POS; i++)
		{
		    if ( PistasPos[pistaid][i][Valid] )
		    {
				if (ConteoPistas != -1)
				{
			    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_VERDE"}ID: %i", i);
		    	}
				else
				{
			    	format(TempConvert, sizeof(TempConvert), "{"COLOR_VERDE"}ID: %i", i);
				}
		        strcat(PistasDialog, TempConvert, sizeof(PistasDialog));
		        ConteoPistas++;
		        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoPistas] = i;
			}
		}
	    new PistasDialogName[MAX_TEXT_CHAT];
	    format(PistasDialogName, sizeof(PistasDialogName), "{"COLOR_AZUL"}Pistas - %s (CheckPoints)", Pistas[pistaid][NamePista]);
		if (ConteoPistas != -1)
		{
			ShowPlayerDialogEx(playerid,121,DIALOG_STYLE_LIST,PistasDialogName, PistasDialog, "Selecionar", "Volver");
		}
		else
		{
			ShowPlayerDialogEx(playerid,120,DIALOG_STYLE_MSGBOX,PistasDialogName, "{"COLOR_TEXTO_DIALOGS"}No se encontrarón checkpoints para esta carrera.", "Aceptar", "Volver");
		}
	}
}
ShowPistaPlayerPublics(playerid)
{
	new PistasDialog[1400];
	new TempConvert[50];
	new ConteoPistas = -1;
	for (new i = 0; i < MAX_COUNT_PISTAS; i++)
	{
	    if ( Pistas[i][ValidR] && Pistas[i][Used] == RACE_STATE_ESPERANDO && !Pistas[i][EstadoR])
	    {
			if ( ConteoPistas != -1 )
			{
		    	format(TempConvert, sizeof(TempConvert), "\r\n{"COLOR_AZUL"}%s {"COLOR_VERDE"}(%i)", Pistas[i][NamePista], GetMaxPlayerCurrentPista(i));
	    	}
			else
			{
	    		format(TempConvert, sizeof(TempConvert), "{"COLOR_AZUL"}%s {"COLOR_VERDE"}(%i)", Pistas[i][NamePista], GetMaxPlayerCurrentPista(i));
			}
	        strcat(PistasDialog, TempConvert, sizeof(PistasDialog));
	        ConteoPistas++;
	        PlayersDataOnline[playerid][SaveAfterAgenda][ConteoPistas] = i;
        }
	}
	if (ConteoPistas != -1)
	{
		ShowPlayerDialogEx(playerid,117,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Carreras - Unirme a una carrera Publica", PistasDialog, "Unirme!", "Salir");
	}
	else
	{
		ShowPlayerDialogEx(playerid,999,DIALOG_STYLE_MSGBOX,"{"COLOR_AZUL"}Carreras - Error", "{"COLOR_CREMA"}No se encontaron carreras Publicas creadas", "Ok", "");
	}
}
SendMessageToRaceChat(raceid, const text[], option)
{
	new MsgRace[256];
	new PistaNear = GetNextCheckPoint(raceid, Pistas[raceid][MaxPP], false);
	if ( option )
	{
		format(MsgRace, sizeof(MsgRace), "{"COLOR_AMARILLO"}\"%s\" Carrera: {"COLOR_CREMA"}%s", Pistas[raceid][NamePista], text);
	}
	else
	{
		format(MsgRace, sizeof(MsgRace), "%s", text);
	}

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if ( IsPlayerConnected(i) && PlayersDataOnline[i][State] == 3 )
		{
			if ( PlayersDataOnline[i][PistaIDp] != -1 ||
                 PlayersDataOnline[i][ModeRace] ||
				 IsPlayerInRangeOfPoint(i, 300.0,
							 PistasPos[raceid][PistaNear][Xpos],
							 PistasPos[raceid][PistaNear][Ypos],
							 PistasPos[raceid][PistaNear][Zpos]) )
			{
				SendClientMessage(i, COLOR_MENSAJES_DE_AVISOS, MsgRace);
			}
		}
	}
}
GetValidCheckPoint(pistaid, checkpointid, option)
{
	if ( checkpointid >= Pistas[pistaid][MaxPP] && !option)
	{
		checkpointid = Pistas[pistaid][MinPP];
	}
	else if ( checkpointid <= Pistas[pistaid][MinPP] && option)
	{
	    checkpointid = Pistas[pistaid][MaxPP];
	}
	else if ( option )
	{
	    checkpointid--;
	}
	else
	{
	    checkpointid++;
	}
	return	checkpointid;
}
GetNextCheckPoint(pistaid, checkpointid, option)
{
//	printf("GetNextCheckPoint JOIN %i - %i - %i", pistaid, checkpointid, option);
	new CurrentPoint = checkpointid;
	for (checkpointid = GetValidCheckPoint(pistaid, checkpointid, option); checkpointid < Pistas[pistaid][MaxPP];checkpointid = GetValidCheckPoint(pistaid, checkpointid, option))
	{
		if ( checkpointid == CurrentPoint )
		{
			break;
		}
		else
		{
			if ( PistasPos[pistaid][checkpointid][Valid] )
			{
			    break;
			}
			else
			{
			    continue;
			}
		}
	}
//	printf("Sale: %i", checkpointid);
	return checkpointid;
}
GetMaxPistaRace(raceid)
{
	new MaxP;
	for (new i = 0; i < MAX_COUNT_PISTAS_POS;i++)
	{
	    if ( PistasPos[raceid][i][Valid] )
	    {
	    	MaxP = i;
	    }
	}
	return MaxP;
}
GetMinPistaRace(raceid)
{
	new MinP;
	for (new i = 0; i < MAX_COUNT_PISTAS_POS;i++)
	{
	    if ( PistasPos[raceid][i][Valid] )
	    {
	    	MinP = i;
	    	break;
	    }
	}
	return MinP;
}
SetPlayerNextCheckPointRace(playerid)
{
	if ( PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VueltaR] 		  ==	Pistas[PlayersDataOnline[playerid][PistaIDp]][Vueltas] 			&&
		 PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][LastCheckPoint] == 	Pistas[PlayersDataOnline[playerid][PistaIDp]][CheckPointFinal] )
	{
	    new PistasDialogText[MAX_TEXT_CHAT];
	    format(PistasDialogText, sizeof(PistasDialogText), "{"COLOR_AZUL"}%s{"COLOR_VERDE"} finalizo la carrera.", PlayersDataOnline[playerid][NameOnlineFix]);
		SendMessageToRaceChat(PlayersDataOnline[playerid][PistaIDp], PistasDialogText, true);
		Pistas[PlayersDataOnline[playerid][PistaIDp]][ConteoPlayers]++;
		PlayerPlaySound(playerid, SOUND_END_RACE, 0.0, 0.0, 0.0);

		PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][TimeFinish] = gettime() - Pistas[PlayersDataOnline[playerid][PistaIDp]][TimeStart];

		PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][PosFinish] = Pistas[PlayersDataOnline[playerid][PistaIDp]][ConteoPlayers];

		AddPlayerToRecordsLive(PlayersDataOnline[playerid][PistaIDp], PlayersDataOnline[playerid][PosIDp]);

		RemovePlayerToRace(playerid, true, true, STATE_RACE_EXIT_FINISH);
	}
	else
	{
		new NuevoCheckPoint =
		GetNextCheckPoint(PlayersDataOnline[playerid][PistaIDp],
		PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][LastCheckPoint],
		Pistas[PlayersDataOnline[playerid][PistaIDp]][AlReves]);
		new NextNuevoCheckPoint =
		GetNextCheckPoint(PlayersDataOnline[playerid][PistaIDp],
		NuevoCheckPoint,
		Pistas[PlayersDataOnline[playerid][PistaIDp]][AlReves]);

		if ( Pistas[PlayersDataOnline[playerid][PistaIDp]][AlReves] )
		{
			if ( PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][LastCheckPoint] == Pistas[PlayersDataOnline[playerid][PistaIDp]][MaxPP] )
			{
				if ( PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VueltaR] )
				{
			    	new PistasDialogText[70];
				    format(PistasDialogText, sizeof(PistasDialogText), "~B~]]]]]]~G~~n~Vuelta %i ~W~Completada!~N~~R~]]]]]]", PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VueltaR]);
					GameTextForPlayer(playerid, PistasDialogText, 4000, 4);
					PlayerPlaySound(playerid, SOUND_VUELTA_VRACE, 0.0, 0.0, 0.0);
				}
			    PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VueltaR]++;
			}
		}
		else
		{
			if ( PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][LastCheckPoint] == Pistas[PlayersDataOnline[playerid][PistaIDp]][MinPP] )
			{
				if ( PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VueltaR] )
				{
			    	new PistasDialogText[70];
				    format(PistasDialogText, sizeof(PistasDialogText), "~B~]]]]]]~G~~n~Vuelta %i ~W~Completada!~N~~R~]]]]]]", PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VueltaR]);
					GameTextForPlayer(playerid, PistasDialogText, 4000, 4);
					PlayerPlaySound(playerid, SOUND_VUELTA_VRACE, 0.0, 0.0, 0.0);
				}
			    PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VueltaR]++;
			}
		}

		new CP_TYPE:StyleCheckPoint;
		if ( PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][VueltaR] 		  ==	Pistas[PlayersDataOnline[playerid][PistaIDp]][Vueltas] 			&&
		  	 NuevoCheckPoint == 	Pistas[PlayersDataOnline[playerid][PistaIDp]][CheckPointFinal] )
		{
		    if ( Pistas[PlayersDataOnline[playerid][PistaIDp]][Tipo] )
		    {
            	StyleCheckPoint = CP_TYPE_AIR_FINISH;
           	}
           	else
           	{
				StyleCheckPoint = CP_TYPE_GROUND_FINISH;
			}
		}
		else
		{
		    if ( Pistas[PlayersDataOnline[playerid][PistaIDp]][Tipo] )
		    {
            	StyleCheckPoint = CP_TYPE_AIR_NORMAL;
           	}
           	else
           	{
				StyleCheckPoint = CP_TYPE_GROUND_NORMAL;
			}
		}

	    PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][LastCheckPoint] = NuevoCheckPoint;
		SetPlayerRaceCheckpoint(playerid, StyleCheckPoint,
		PistasPos[PlayersDataOnline[playerid][PistaIDp]][PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][LastCheckPoint]][Xpos],
		PistasPos[PlayersDataOnline[playerid][PistaIDp]][PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][LastCheckPoint]][Ypos],
		PistasPos[PlayersDataOnline[playerid][PistaIDp]][PistasPosPlayers[PlayersDataOnline[playerid][PistaIDp]][PlayersDataOnline[playerid][PosIDp]][LastCheckPoint]][Zpos],
		PistasPos[PlayersDataOnline[playerid][PistaIDp]][NextNuevoCheckPoint][Xpos],
		PistasPos[PlayersDataOnline[playerid][PistaIDp]][NextNuevoCheckPoint][Ypos],
		PistasPos[PlayersDataOnline[playerid][PistaIDp]][NextNuevoCheckPoint][Zpos],
		Pistas[PlayersDataOnline[playerid][PistaIDp]][Radio]);
	}
}
ShowStatsRace(raceid)
{
	SendMessageToRaceChat(raceid, "{00FF46}La carrera a finalizado!", true);
	SendMessageToRaceChat(raceid, "{00EBFF}|______________ Resumen de la Carrera ______________|", true);

	new PistasDialogText[MAX_TEXT_CHAT];
	for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
	{
	    if ( PistasPosPlayers[raceid][i][PistaIDR] != -1 )
	    {
	        new Timee[3];
			GetTimeBySeconds(PistasPosPlayers[raceid][PistasPosPlayers[raceid][i][PistaIDR]][TimeFinish], Timee[0], Timee[1], Timee[2]);

		    format(PistasDialogText, sizeof(PistasDialogText), "{"COLOR_TEXTO_DIALOGS"}%i - %s {AFFF00}Tiempo: {EBFF00}%i:%i:%i", i + 1,
			PistasPosPlayers[raceid][PistasPosPlayers[raceid][i][PistaIDR]][NameR],
			Timee[0], Timee[1], Timee[2]);
	        SendMessageToRaceChat(raceid, PistasDialogText, true);
	    }
	}
//	        SendMessageToRaceChat(raceid, "{"COLOR_ROJO"} ** DESCALIFICADOS **", true);
	for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
	{
	    if ( PistasPosPlayers[raceid][i][ExitReason] != -1 && PistasPosPlayers[raceid][i][ExitReason] != STATE_RACE_EXIT_FINISH )
	    {

		    format(PistasDialogText, sizeof(PistasDialogText), "{00B9FF}%s {"COLOR_ROJO"}(Descalificado) {0069FF}Razón: {EBFF00}%s",
			PistasPosPlayers[raceid][i][NameR],
			PistasTypeFinal[PistasPosPlayers[raceid][i][ExitReason]]);
	        SendMessageToRaceChat(raceid, PistasDialogText, true);
	    }
	}
	CancelRace(raceid);
}
AddPlayerToRecordsLive(raceid, posid)
{
	for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
	{
	    if ( PistasPosPlayers[raceid][i][PistaIDR] == -1 )
	    {
	    	PistasPosPlayers[raceid][i][PistaIDR]  	 = posid;
	    	return i;
    	}
    }
    return -1;
}
GetTimeBySeconds(seconds, &hour, &minute, &second)
{
	if ( seconds / 3600 )
	{
	    hour = seconds / 3600;
	    if ( (seconds % 3600) )
	    {
	        minute = (seconds % 3600) / 60;
	        if ( ((seconds % 3600) % 60) )
	        {
	            second = ((seconds % 3600) % 60);
	        }
		}
	}
	if ( seconds / 60 )
	{
        minute = seconds / 60;
        if ( (seconds % 60) )
        {
            second = seconds % 60;
        }
	}
	else
	{
	    second = seconds;
	}
}
ComparePlayersRaceProgress(progress1, progress2, Float:Distance1, Float:Distance2)
{
	if ( progress2 >= progress1 )
	{
	    if ( progress2 == progress1 )
	    {
			if ( Distance2 < Distance1 )
			{
			    return true;
			}
		}
		else
		{
		    return true;
		}
	}
	return false;
}
GetMaxCheckPointCurrentPista(pistaid, countvuelta, checkpointcount)
{
//	printf("checkpointcount %i", checkpointcount);
    if ( !countvuelta )
    {
        return true;
	}
	else
	{
	    if ( checkpointcount != 0 )
	    {
			return (Pistas[pistaid][MaxCheckPointsTotal] * (countvuelta))
			- (Pistas[pistaid][MaxCheckPointsTotal] - (checkpointcount));
		}
		else
		{
			return (Pistas[pistaid][MaxCheckPointsTotal] * (countvuelta));
		}
	}
}

function StartRace(pistaid, option)
{
    new PistasDialogText[MAX_TEXT_CHAT];
	if ( option )
	{
	    format(PistasDialogText, sizeof(PistasDialogText), "Nueva carrera tipo {"COLOR_AMARILLO"}%s{"COLOR_CREMA"}, comienza en {"COLOR_VERDE"}%i {"COLOR_CREMA"}segundos!", PistasTypeEstados[Pistas[pistaid][EstadoR]], Pistas[pistaid][TiempoAntes]);
       	Pistas[pistaid][Used] = RACE_STATE_ESPERANDO;
	    Pistas[pistaid][RaceTimer] = SetTimerEx("StartRace", Pistas[pistaid][TiempoAntes] * 1000, false, "dd", pistaid, false);
    }
    else
    {
        if ( GetMaxPlayerCurrentPista(pistaid) )
        {
		    format(PistasDialogText, sizeof(PistasDialogText), "Comienza un conteo de %i en 5 segundos para empezar!", Pistas[pistaid][ConteoR]);
	       	Pistas[pistaid][Used] = RACE_STATE_CONTEO;
		    Pistas[pistaid][RaceTimer] = SetTimerEx("ConteoRace", 5000, false, "dd", pistaid, Pistas[pistaid][ConteoR] + 1);
	    }
	    else
	    {
		    format(PistasDialogText, sizeof(PistasDialogText), "{"COLOR_AZUL"}La carrera no comenzo por falta de concursantes!");
		    CancelRace(pistaid);
		}
	}
	SendMessageToRaceChat(pistaid, PistasDialogText, true);
}

function ConteoRace(pistaid, count)
{
	new ConteoText[10];
	new StyleText;
	count--;
	if(count)
	{
	    format(ConteoText, sizeof(ConteoText), "~R~%i", count);
	    StyleText = 5;
    }
    else
    {
		Pistas[pistaid][Used] 		= RACE_STATE_COMPITIENDO;

		Pistas[pistaid][TimeStart] 	= gettime();

	    format(ConteoText, sizeof(ConteoText), "~G~Go!", count);
	    StyleText = 0;
		new PistasDialogText[256];
	    format(PistasDialogText, sizeof(PistasDialogText), "La carrera comenzo con %i competidores!", GetMaxPlayerCurrentPista(pistaid));
		SendMessageToRaceChat(pistaid, PistasDialogText, true);
	}
    for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS;i++)
    {
	    if ( PistasPosPlayers[pistaid][i][Valid] && PistasPosPlayers[pistaid][i][PlayerIDR] != -1 )
	    {
	    	GameTextForPlayer(PistasPosPlayers[pistaid][i][PlayerIDR], ConteoText, 1000, StyleText);
	    	if ( !StyleText )
	    	{
				SetPlayerNextCheckPointRace(PistasPosPlayers[pistaid][i][PlayerIDR]);
				TogglePlayerControllable(PistasPosPlayers[pistaid][i][PlayerIDR], true);
				PlayerPlaySound(PistasPosPlayers[pistaid][i][PlayerIDR], SOUND_START_RACE, 0.0, 0.0, 0.0);
				PistasPosPlayers[pistaid][i][ExitReason] = -1;

				TextDrawShowForPlayer(PistasPosPlayers[pistaid][i][PlayerIDR], ScorePosRace[pistaid]);
				TextDrawShowForPlayer(PistasPosPlayers[pistaid][i][PlayerIDR], ScoreRaceBox);

				/*DataCars[PistasPosPlayers[pistaid][i][VehicleIDR]][AlarmOn] = false;
				DataCars[PistasPosPlayers[pistaid][i][VehicleIDR]][StateEncendido] = true;
				DataCars[PistasPosPlayers[pistaid][i][VehicleIDR]][Puente] = false;

				IsVehicleOff(PistasPosPlayers[pistaid][i][VehicleIDR]);*/

				if ( Pistas[pistaid][IsCameras] )
				{
					KillTimer(PlayersDataOnline[PistasPosPlayers[pistaid][i][PlayerIDR]][TimerCamaraIdRace]);
				}
				SetCameraBehindPlayer(PistasPosPlayers[pistaid][i][PlayerIDR]);
			}
    	}
    }
    if ( count )
    {
	    Pistas[pistaid][RaceTimer] = SetTimerEx("ConteoRace", 2000, false, "dd", pistaid, count);
	}
	else
	{
	    Pistas[pistaid][RaceTimer] = SetTimerEx("UpdateTextDrawRacePositions", 500, false, "d", pistaid);
	}
}

function UpdateTextDrawRacePositions(pistaid)
{
	new FiveOnePos[5] = {-1,-1,-1,-1,-1};
	new FiveOneScore[5];
	new Float:FiveOneDistance[5];
	new IsUpdate;
	new PosUpdate;
	new ScoreUpdate;
	new Float:DistanceUpdate;
	new a;
	for (new i = 0; i < MAX_COUNT_PISTAS_POS_PLAYERS; i++)
	{
	    if ( PistasPosPlayers[pistaid][i][PlayerIDR] != -1)
	    {
	        for ( a = 0; a < 5; a++)
	        {
				if ( FiveOnePos[a] == -1 )
				{
					DistanceUpdate =  GetPlayerProgressRace(PistasPosPlayers[pistaid][i][PlayerIDR], ScoreUpdate);
					PosUpdate = i;
					ScoreUpdate += 111;
					IsUpdate = true;
					break;
				}
				else if ( FiveOneScore[a] > 100 )
				{
					DistanceUpdate =  GetPlayerProgressRace(PistasPosPlayers[pistaid][i][PlayerIDR], ScoreUpdate);

					if ( ComparePlayersRaceProgress(FiveOneScore[a] - 111, ScoreUpdate, FiveOneDistance[a], DistanceUpdate) )
					{
						PosUpdate = i;
						ScoreUpdate += 111;
						IsUpdate = true;
						break;
					}
				}
			}
		}
		else if ( PistasPosPlayers[pistaid][i][PosFinish] < 5 )
		{
	        for ( a = 0; a < 5; a++)
	        {
	            if ( FiveOnePos[a] == -1 ||
					 FiveOneScore[a] > 100 ||
					 PistasPosPlayers[pistaid][i][PosFinish] < FiveOneScore[a] && FiveOneScore[a] > 100 )
	            {
					PosUpdate = i;
					ScoreUpdate = PistasPosPlayers[pistaid][i][PosFinish];

					IsUpdate = true;
					break;
				}
			}
		}

	    if ( IsUpdate )
	    {
		    IsUpdate = 4;
			while ( IsUpdate != a )
			{
				FiveOnePos[IsUpdate] 		= FiveOnePos[IsUpdate - 1];
				FiveOneScore[IsUpdate]		= FiveOneScore[IsUpdate - 1];
				FiveOneDistance[IsUpdate]	= FiveOneDistance[IsUpdate - 1];
				IsUpdate--;
			}
			FiveOnePos[a] 		= PosUpdate;
			FiveOneScore[a]		= ScoreUpdate;
			FiveOneDistance[a]	= DistanceUpdate;
		}


		IsUpdate = false;

	}

	new TextDrawText[250];
	new TempString[50];
	for (a = 0; a < 5;a++)
	{
		if (FiveOnePos[a] != -1)
		{
			if ( a )
			{
				format(TempString, sizeof(TempString), "~N~~N~~W~%i- ~G~%s",
				a + 1,
				PistasPosPlayers[pistaid][FiveOnePos[a]][NameR]);
			}
			else
			{
				format(TempString, sizeof(TempString), "~W~%i- ~G~%s",
				a + 1,
				PistasPosPlayers[pistaid][FiveOnePos[a]][NameR]);
			}
		}
		else
		{
			if ( a )
			{
				format(TempString, sizeof(TempString), "~N~~N~~W~%i- ~R~Vac\xa2o",
				a + 1);
			}
			else
			{
				format(TempString, sizeof(TempString), "~W~%i- ~R~Vac\xa2o",
				a + 1);
			}
		}
		strcat(TextDrawText, TempString,sizeof(TextDrawText));
	}
	TextDrawSetString(ScorePosRace[pistaid], TextDrawText);

    Pistas[pistaid][RaceTimer] = SetTimerEx("UpdateTextDrawRacePositions", 100, false, "d", pistaid);
}

function SetCameraPresentRace(playerid, raceid, point, Float:Porcent, Float:CameraX, Float:CameraY, Float:CameraZ)
{
	SetPlayerCameraLookAt(playerid,
	PistasPosPlayers[raceid][PlayersDataOnline[playerid][PosIDp]][Xpos],
	PistasPosPlayers[raceid][PlayersDataOnline[playerid][PosIDp]][Ypos],
	PistasPosPlayers[raceid][PlayersDataOnline[playerid][PosIDp]][Zpos]);

	new NextPoint;
	new PassPoint;
	Porcent += PistasCameras[raceid][point][Vel];
	if ( point == Pistas[raceid][MaxCameras] )
	{
		NextPoint = 0;
	}
	else
	{
		NextPoint = point + 1;
	}
	/////////////////////////////// X POS
	if ( PistasCameras[raceid][point][Xpos] > PistasCameras[raceid][NextPoint][Xpos] )
	{
        CameraX -= ((PistasCameras[raceid][point][Xpos] - PistasCameras[raceid][NextPoint][Xpos]) * Porcent) / 100;
        if ( CameraX < PistasCameras[raceid][NextPoint][Xpos] )
        {
            PassPoint++;
        }
	}
	else
	{
        CameraX += ((PistasCameras[raceid][NextPoint][Xpos] - PistasCameras[raceid][point][Xpos]) * Porcent) / 100;
        if ( CameraX > PistasCameras[raceid][NextPoint][Xpos] )
        {
            PassPoint++;
        }
	}
	/////////////////////////////// Y POS
	if ( PistasCameras[raceid][point][Ypos] > PistasCameras[raceid][NextPoint][Ypos] )
	{
        CameraY -= ((PistasCameras[raceid][point][Ypos] - PistasCameras[raceid][NextPoint][Ypos]) * Porcent) / 100;
        if ( CameraY < PistasCameras[raceid][NextPoint][Ypos] )
        {
            PassPoint++;
        }
	}
	else
	{
        CameraY += ((PistasCameras[raceid][NextPoint][Ypos] - PistasCameras[raceid][point][Ypos]) * Porcent) / 100;
        if ( CameraY > PistasCameras[raceid][NextPoint][Ypos] )
        {
            PassPoint++;
        }
	}
	/////////////////////////////// Z POS
	if ( PistasCameras[raceid][point][Zpos] > PistasCameras[raceid][NextPoint][Zpos] )
	{
        CameraZ -= ((PistasCameras[raceid][point][Zpos] - PistasCameras[raceid][NextPoint][Zpos]) * Porcent) / 100;

        PassPoint++;
	}
	else
	{
        CameraZ += ((PistasCameras[raceid][NextPoint][Zpos] - PistasCameras[raceid][point][Zpos]) * Porcent) / 100;

        PassPoint++;
	}

	if ( PassPoint == 3 )
	{
	    point = NextPoint;
		CameraX = PistasCameras[raceid][NextPoint][Xpos];
		CameraY = PistasCameras[raceid][NextPoint][Ypos];
		CameraZ = PistasCameras[raceid][NextPoint][Zpos];
	    Porcent = 0.0;
	}
	SetPlayerCameraPos(playerid,CameraX,CameraY,CameraZ);
	PlayersDataOnline[playerid][TimerCamaraIdRace] = SetTimerEx("SetCameraPresentRace", 20, false, "dddffff", playerid, raceid, point, Porcent, CameraX, CameraY, CameraZ);
}