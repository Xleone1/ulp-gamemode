// helpers puros de bombas sin side effects

IsPlayerNearBomba(playerid, Float:Range, option)
{
    if ( option == -1 )
    {
        for (new i = 0; i < MAX_BOMBAS_COUNT; i++ )
        {
            if ( IsPlayerNearBombaEx(playerid, i, Range) )
            {
                return i;
            }
        }
    }
    else
    {
        if ( IsPlayerNearBombaEx(playerid, option, Range) )
        {
            return option;
        }
    }
    return -1;
}

IsVehicleHaveBomba(vehicleSQLID)
{
    for (new i = 0; i < MAX_BOMBAS_COUNT; i++ )
    {
        if ( BombasO[i][TypeBomba] == BOMBA_TYPE_CAR && BombasO[i][ObjectID] == vehicleSQLID)
        {
            return i;
        }
    }
    return -1;
}

IsPlayerNearBombaEx(playerid, bombaid, Float:Range)
{
    new Float:VehPos[3];
    if ( BombasO[bombaid][TypeBomba] != BOMBA_TYPE_NONE )
    {
        if ( BombasO[bombaid][TypeBomba] == BOMBA_TYPE_FOOT )
        {
            if ( IsPlayerInRangeOfPoint(playerid, Range,
                BombasO[bombaid][PosX], BombasO[bombaid][PosY], BombasO[bombaid][PosZ] ) )
            {
                return true;
            }
        }
        else
        {
            GetVehiclePos(BombasO[bombaid][ObjectID], VehPos[0], VehPos[1], VehPos[2]);
            if ( IsPlayerInRangeOfPoint(playerid, Range,
                VehPos[0], VehPos[1], VehPos[2] ) )
            {
                return true;
            }
        }
    }
    return false;
}
