static bool:g_ForumBridgeEnabled = false;
static g_ForumBridgeApiKey[128];
static g_ForumBridgeApiUrl[256];
static g_ForumBridgeCreateUserPath[128];
static RequestsClient:g_ForumBridgeClient = RequestsClient:-1;

static stock RequestsClient:Forum_GetClient()
{
    if (g_ForumBridgeClient == RequestsClient:-1)
    {
        g_ForumBridgeClient = RequestsClient(g_ForumBridgeApiUrl);
    }
    return g_ForumBridgeClient;
}

ForumBridge_LoadConfig()
{
    g_ForumBridgeEnabled = false;
    g_ForumBridgeApiKey[0] = '\0';
    g_ForumBridgeApiUrl[0] = '\0';
    g_ForumBridgeCreateUserPath[0] = '\0';

    if (!fexist(FORUM_BRIDGE_CFG_PATH))
    {
        printf("[ForumBridge] Archivo de configuracion no encontrado: %s", FORUM_BRIDGE_CFG_PATH);
        printf("[ForumBridge] Forum Bridge deshabilitado.");
        return 0;
    }

    new File:cfg = fopen(FORUM_BRIDGE_CFG_PATH, io_read);
    if (!cfg)
    {
        printf("[ForumBridge] Error al abrir configuracion: %s", FORUM_BRIDGE_CFG_PATH);
        printf("[ForumBridge] Forum Bridge deshabilitado.");
        return 0;
    }

    new line[256], key[64], value[200];
    while (fread(cfg, line, sizeof(line)))
    {
        if (line[0] == '\0' || line[0] == '#' || line[0] == ';')
            continue;

        new eqPos = strfind(line, "=", false);
        if (eqPos == -1)
            continue;

        strmid(key, line, 0, eqPos, sizeof(key));
        strmid(value, line, eqPos + 1, strlen(line), sizeof(value));

        while (key[0] == ' ' || key[0] == '\t')
            strdel(key, 0, 1);
        new klen = strlen(key);
        while (klen > 0 && (key[klen-1] == ' ' || key[klen-1] == '\t' || key[klen-1] == '\r' || key[klen-1] == '\n'))
            key[--klen] = '\0';

        while (value[0] == ' ' || value[0] == '\t')
            strdel(value, 0, 1);
        new vlen = strlen(value);
        while (vlen > 0 && (value[vlen-1] == ' ' || value[vlen-1] == '\t' || value[vlen-1] == '\r' || value[vlen-1] == '\n'))
            value[--vlen] = '\0';

        if (strcmp(key, "forum_bridge_enabled", true) == 0)
        {
            g_ForumBridgeEnabled = (strval(value) == 1);
        }
        else if (strcmp(key, "forum_bridge_api_url", true) == 0)
        {
            format(g_ForumBridgeApiUrl, sizeof(g_ForumBridgeApiUrl), "%s", value);
        }
        else if (strcmp(key, "forum_bridge_api_key", true) == 0)
        {
            format(g_ForumBridgeApiKey, sizeof(g_ForumBridgeApiKey), "%s", value);
        }
        else if (strcmp(key, "forum_bridge_create_user_path", true) == 0)
        {
            format(g_ForumBridgeCreateUserPath, sizeof(g_ForumBridgeCreateUserPath), "%s", value);
        }
    }
    fclose(cfg);

    if (g_ForumBridgeEnabled)
    {
        new bool:valid = true;

        if (strlen(g_ForumBridgeApiUrl) == 0)
        {
            printf("[ForumBridge] WARN: 'forum_bridge_api_url' no esta configurado.");
            valid = false;
        }
        if (strlen(g_ForumBridgeApiKey) == 0)
        {
            printf("[ForumBridge] WARN: 'forum_bridge_api_key' no esta configurado.");
            valid = false;
        }
        if (strlen(g_ForumBridgeCreateUserPath) == 0)
        {
            printf("[ForumBridge] WARN: 'forum_bridge_create_user_path' no esta configurado.");
            valid = false;
        }

        if (!valid)
        {
            printf("[ForumBridge] Forum Bridge deshabilitado por configuracion incompleta.");
            g_ForumBridgeEnabled = false;
        }
    }

    if (g_ForumBridgeEnabled)
    {
        printf("[ForumBridge] Enabled: Yes");
        printf("[ForumBridge] API URL: %s", g_ForumBridgeApiUrl);
        printf("[ForumBridge] Endpoint: %s", g_ForumBridgeCreateUserPath);
        if (strlen(g_ForumBridgeApiKey) > 0)
            printf("[ForumBridge] API Key: configured");
        else
            printf("[ForumBridge] API Key: missing");
    }
    else
    {
        printf("[ForumBridge] Enabled: No");
    }

    return 1;
}

Forum_CreateUser(playerid)
{
    if (!g_ForumBridgeEnabled)
    {
        return 0;
    }

    if (strlen(PlayersDataOnline[playerid][TempPassword]) == 0)
    {
        printf("[ForumBridge] Error: TempPassword vacia para jugador %s[%i]", PlayersDataOnline[playerid][NameOnline], playerid);
        return 0;
    }

    new Headers:headers = RequestHeaders(
        "X-API-Key", g_ForumBridgeApiKey,
        "Content-Type", "application/json"
    );

    new Node:body = JsonObject(
        "username", JsonString(PlayersDataOnline[playerid][NameOnline]),
        "password", JsonString(PlayersDataOnline[playerid][TempPassword]),
        "email", JsonString(PlayersData[playerid][Email])
    );

    new Request:req = RequestJSON(
        Forum_GetClient(),
        g_ForumBridgeCreateUserPath,
        HTTP_METHOD_POST,
        "OnForumBridgeCreateUser",
        body,
        headers
    );

    if (!IsValidRequest(req))
    {
        printf("[ForumBridge] Error: Fallo al enviar request para jugador %s[%i]", PlayersDataOnline[playerid][NameOnline], playerid);
    }

    format(PlayersDataOnline[playerid][TempPassword], 25, "");
    return 1;
}

forward OnForumBridgeCreateUser(Request:id, Node:node, statusCode);
public OnForumBridgeCreateUser(Request:id, Node:node, statusCode)
{
    if (statusCode != 200 && statusCode != 201)
    {
        printf("[ForumBridge] Error: "SERVER_NAME" API respondio con codigo %i", statusCode);
    }
    return 1;
}

forward OnRequestFailureForumBridge(Request:id, errorCode, errorMessage[], len);
public OnRequestFailureForumBridge(Request:id, errorCode, errorMessage[], len)
{
    printf("[ForumBridge] Error de conexion: codigo %i - %s", errorCode, errorMessage);
    return 1;
}
