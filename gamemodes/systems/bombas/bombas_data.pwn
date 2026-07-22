// capa de persistencia para bombas

SaveBombaToDB(bombaid)
{
    new query[356];
    mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET typeBomb = %d, model_id = %d, pos_x = %f, pos_y = %f, pos_z = %f, object_id = %d WHERE id = %d;",
    DIR_BOMBAS,
    BombasO[bombaid][TypeBomba],
    BombasO[bombaid][ObjectIDO],
    BombasO[bombaid][PosX],
    BombasO[bombaid][PosY],
    BombasO[bombaid][PosZ],
    BombasO[bombaid][ObjectID],
    bombaid);
    mysql_query(dataBase, query, false);
    printf("Query: %s", query);
}

ClearBombaFromDB(bombaid)
{
    new query[356];
    mysql_format(dataBase, query, sizeof(query), "UPDATE %s SET typeBomb = 0, model_id = 0, pos_x = 0, pos_y = 0, pos_z = 0, object_id = 0 WHERE id = %d;",
    DIR_BOMBAS,
    bombaid);
    mysql_query(dataBase, query);
}
