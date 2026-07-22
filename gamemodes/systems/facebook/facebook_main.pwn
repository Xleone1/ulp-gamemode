IsUniqueIDInUse(const uniqueID[])
{
    new sql[100], Cache:cacheid;
    mysql_format(dataBase, sql, sizeof(sql), "SELECT `UniqueID` FROM `%s` WHERE `UniqueID`='%s'", DIR_USERS, uniqueID);
    cacheid = mysql_query(dataBase, sql);
    new result = cache_num_rows();
    cache_delete(cacheid);
    return result;
}

CreatePlayerUniqueID(playerid)
{
    new Go = true, uniqueID[UNIQUE_ID_LENGTH];
    do{
        new 
            firstLetter  = random(sizeof(abecedario)), 
            secondLetter  = random(sizeof(abecedario)), 
            thirdLetter  = random(sizeof(abecedario)), 
            firstNumber  = random(10), 
            secondNumber  = random(10), 
            thirdNumber = random(10);
        format(uniqueID, UNIQUE_ID_LENGTH+1, "%s%s%s%i%i%i", abecedario[firstLetter], abecedario[secondLetter], abecedario[thirdLetter], firstNumber, secondNumber, thirdNumber);
        if( !IsUniqueIDInUse(uniqueID) ) Go = false;
    }
    while(Go);
    format(PlayersData[playerid][UniqueID], UNIQUE_ID_LENGTH+1, uniqueID);
}

LoadPlayerFacebook(playerid)
{
    new query[200], Cache:cacheid;
    mysql_format(dataBase, query, sizeof(query), "SELECT `user_id_B` FROM `%s` WHERE `user_id_A`='%d';", DIR_USERS_FACEBOOK, PlayersData[playerid][DB_ID]);
    cacheid = mysql_query(dataBase, query);
    new count = cache_num_rows();
    new getPlayerFacebook[MAX_PLAYERS];
    new getID = -1;
    new testCount;
    for( new i; i != count; i++ ){
        cache_get_value_index_int(0, count, getPlayerFacebook[count]);
        getID = GetUserIDBySQLID( getPlayerFacebook[count] );
        if( getID != -1 ){
            Facebook[playerid][getID] = 1;
            Facebook[getID][playerid] = 1;
            Importante(playerid, "Alguien que conoces esta conectado: %s {FF0000}(Debug System Message)", PlayersDataOnline[getID][NameOnline]);
            Importante(getID, "Se conecto %s {FF0000}(Debug System Message)", PlayersDataOnline[playerid][NameOnline]);
            testCount++;
        }
    }
    Info(playerid, "%d de %d usuarios que conoces estan conectados", testCount, count);
    cache_delete(cacheid);
}

public OnPlayerStreamIn(playerid, forplayerid)
{
    //NameTags[forplayerid][playerid]
    if( IsValidPlayer3DTextLabel(forplayerid, NameTags[forplayerid][playerid]) ) DeletePlayer3DTextLabel(forplayerid, NameTags[forplayerid][playerid]);
    if( Facebook[forplayerid][playerid] ){
        NameTags[forplayerid][playerid] = CreatePlayer3DTextLabel(forplayerid, "%s (%d)", -1, 0,0,0.3, 15.0, playerid, INVALID_VEHICLE_ID, true, PlayersDataOnline[playerid][NameOnlineFix], playerid);
    }
    else{
        NameTags[forplayerid][playerid] = CreatePlayer3DTextLabel(forplayerid, "Desconocido (%d)", 0xFF0000FF, 0,0,0.3, 15.0, playerid, INVALID_VEHICLE_ID, true, playerid);
    }
    return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
    if( IsValidPlayer3DTextLabel(forplayerid, NameTags[forplayerid][playerid]) ) DeletePlayer3DTextLabel(forplayerid, NameTags[forplayerid][playerid]);   
    return 1;
}