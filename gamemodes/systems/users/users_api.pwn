// cliente HTTP de autenticacion contra la API externa (pawn-requests).
// maneja login, registro, listado de personajes y carga de personaje.
// toda la logica previa de mysql/bcrypt para el inicio de sesion
// pasa por este modulo.

#define USERS_API_CFG_PATH "Misc/api_auth.cfg"

static bool:g_UsersApiEnabled = false;
static g_UsersApiKey[128];
static g_UsersApiBaseUrl[256];
static g_UsersApiLoginPath[128];
static g_UsersApiRegisterPath[128];
static g_UsersApiCharGetPath[128];
static g_UsersApiCharCreatePath[128];
static g_UsersApiCharUpdatePath[128];
static RequestsClient:g_UsersApiClient = RequestsClient:-1;

static stock RequestsClient:UsersApi_GetClient()
{
	if (g_UsersApiClient == RequestsClient:-1)
	{
		g_UsersApiClient = RequestsClient(g_UsersApiBaseUrl);
	}
	return g_UsersApiClient;
}

UsersApi_LoadConfig()
{
	g_UsersApiEnabled = false;
	g_UsersApiKey[0] = EOS;
	g_UsersApiBaseUrl[0] = EOS;
	g_UsersApiLoginPath[0] = EOS;
	g_UsersApiRegisterPath[0] = EOS;
	g_UsersApiCharGetPath[0] = EOS;
	g_UsersApiCharCreatePath[0] = EOS;
	g_UsersApiCharUpdatePath[0] = EOS;

	if (!fexist(USERS_API_CFG_PATH))
	{
		printf("[UsersApi] Archivo de configuracion no encontrado: %s", USERS_API_CFG_PATH);
		printf("[UsersApi] Login contra API deshabilitado.");
		return 0;
	}

	new File:cfg = fopen(USERS_API_CFG_PATH, io_read);
	if (!cfg)
	{
		printf("[UsersApi] Error al abrir configuracion: %s", USERS_API_CFG_PATH);
		printf("[UsersApi] Login contra API deshabilitado.");
		return 0;
	}

	new line[256], key[64], value[200];
	while (fread(cfg, line, sizeof(line)))
	{
		if (line[0] == EOS || line[0] == '#' || line[0] == ';')
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
			key[--klen] = EOS;

		while (value[0] == ' ' || value[0] == '\t')
			strdel(value, 0, 1);
		new vlen = strlen(value);
		while (vlen > 0 && (value[vlen-1] == ' ' || value[vlen-1] == '\t' || value[vlen-1] == '\r' || value[vlen-1] == '\n'))
			value[--vlen] = EOS;

		if (strcmp(key, "users_api_enabled", true) == 0)
		{
			g_UsersApiEnabled = (strval(value) == 1);
		}
		else if (strcmp(key, "users_api_key", true) == 0)
		{
			format(g_UsersApiKey, sizeof(g_UsersApiKey), "%s", value);
		}
		else if (strcmp(key, "users_api_base_url", true) == 0)
		{
			format(g_UsersApiBaseUrl, sizeof(g_UsersApiBaseUrl), "%s", value);
		}
		else if (strcmp(key, "users_api_login_path", true) == 0)
		{
			format(g_UsersApiLoginPath, sizeof(g_UsersApiLoginPath), "%s", value);
		}
		else if (strcmp(key, "users_api_register_path", true) == 0)
		{
			format(g_UsersApiRegisterPath, sizeof(g_UsersApiRegisterPath), "%s", value);
		}
		else if (strcmp(key, "users_api_char_get_path", true) == 0)
		{
			format(g_UsersApiCharGetPath, sizeof(g_UsersApiCharGetPath), "%s", value);
		}
		else if (strcmp(key, "users_api_char_create_path", true) == 0)
		{
			format(g_UsersApiCharCreatePath, sizeof(g_UsersApiCharCreatePath), "%s", value);
		}
		else if (strcmp(key, "users_api_char_update_path", true) == 0)
		{
			format(g_UsersApiCharUpdatePath, sizeof(g_UsersApiCharUpdatePath), "%s", value);
		}
	}
	fclose(cfg);

	if (g_UsersApiEnabled)
	{
		new bool:valid = true;

		if (strlen(g_UsersApiBaseUrl) == 0)
		{
			printf("[UsersApi] WARN: 'users_api_base_url' no esta configurado.");
			valid = false;
		}
		if (strlen(g_UsersApiKey) == 0)
		{
			printf("[UsersApi] WARN: 'users_api_key' no esta configurado.");
			valid = false;
		}
		if (strlen(g_UsersApiLoginPath) == 0)
		{
			printf("[UsersApi] WARN: 'users_api_login_path' no esta configurado.");
			valid = false;
		}
		if (strlen(g_UsersApiRegisterPath) == 0)
		{
			printf("[UsersApi] WARN: 'users_api_register_path' no esta configurado.");
			valid = false;
		}
		if (strlen(g_UsersApiCharGetPath) == 0)
		{
			printf("[UsersApi] WARN: 'users_api_char_get_path' no esta configurado.");
			valid = false;
		}
		if (strlen(g_UsersApiCharCreatePath) == 0)
		{
			printf("[UsersApi] WARN: 'users_api_char_create_path' no esta configurado.");
			valid = false;
		}
		if (strlen(g_UsersApiCharUpdatePath) == 0)
		{
			printf("[UsersApi] WARN: 'users_api_char_update_path' no esta configurado.");
			valid = false;
		}

		if (!valid)
		{
			printf("[UsersApi] Login contra API deshabilitado por configuracion incompleta.");
			g_UsersApiEnabled = false;
		}
	}

	if (g_UsersApiEnabled)
	{
		printf("[UsersApi] Enabled: Yes");
		printf("[UsersApi] Base URL: %s", g_UsersApiBaseUrl);
		printf("[UsersApi] Login: %s | Register: %s", g_UsersApiLoginPath, g_UsersApiRegisterPath);
		printf("[UsersApi] Char get: %s | Char create: %s | Char update: %s", g_UsersApiCharGetPath, g_UsersApiCharCreatePath, g_UsersApiCharUpdatePath);
	}
	else
	{
		printf("[UsersApi] Enabled: No");
	}

	return 1;
}

bool:UsersApi_IsEnabled()
{
	return g_UsersApiEnabled;
}

// envia POST /auth/login con username + password
// la respuesta llega a OnAuthLogin con el mismo playerid
UsersApi_Login(playerid, const password[])
{
	if (!g_UsersApiEnabled)
		return 0;

	new Headers:headers = RequestHeaders(
		"X-API-Key", g_UsersApiKey,
		"Content-Type", "application/json"
	);

	new Node:body = JsonObject(
		"username", JsonString(PlayersDataOnline[playerid][NameOnline]),
		"password", JsonString(password)
	);

	new Request:req = RequestJSON(
		UsersApi_GetClient(),
		g_UsersApiLoginPath,
		HTTP_METHOD_POST,
		"OnAuthLogin",
		body,
		headers
	);

	if (!IsValidRequest(req))
	{
		printf("[UsersApi] Error: fallo al enviar login para %s[%i]", PlayersDataOnline[playerid][NameOnline], playerid);
		return 0;
	}
	usersApi_TrackRequest(req, playerid);
	return 1;
}

// envia POST /auth/register con username + password
// la respuesta llega a OnAuthRegister
usersApi_DoRegister(playerid, const password[])
{
	if (!g_UsersApiEnabled)
		return 0;

	new Headers:headers = RequestHeaders(
		"X-API-Key", g_UsersApiKey,
		"Content-Type", "application/json"
	);

	new Node:body = JsonObject(
		"username", JsonString(PlayersDataOnline[playerid][NameOnline]),
		"password", JsonString(password)
	);

	new Request:req = RequestJSON(
		UsersApi_GetClient(),
		g_UsersApiRegisterPath,
		HTTP_METHOD_POST,
		"OnAuthRegister",
		body,
		headers
	);

	if (!IsValidRequest(req))
	{
		printf("[UsersApi] Error: fallo al enviar register para %s[%i]", PlayersDataOnline[playerid][NameOnline], playerid);
		return 0;
	}
	usersApi_TrackRequest(req, playerid);
	return 1;
}

// envia GET /characters/<id> para traer el CharacterFull
// la respuesta llega a OnCharacterLoad
usersApi_LoadCharacter(playerid, characterId)
{
	if (!g_UsersApiEnabled)
		return 0;

	new path[160];
	format(path, sizeof(path), g_UsersApiCharGetPath, characterId);

	new Headers:headers = RequestHeaders(
		"X-API-Key", g_UsersApiKey
	);

	new Request:req = RequestJSON(
		UsersApi_GetClient(),
		path,
		HTTP_METHOD_GET,
		"OnCharacterLoad",
		Node:-1,
		headers
	);

	if (!IsValidRequest(req))
	{
		printf("[UsersApi] Error: fallo al cargar personaje %i para %s[%i]", characterId, PlayersDataOnline[playerid][NameOnline], playerid);
		return 0;
	}
	usersApi_TrackRequest(req, playerid);
	return 1;
}

// envia POST /characters/create con account_id + name + email + sex + age
// la respuesta llega a OnCharacterCreate
usersApi_CreateCharacter(playerid, const characterName[])
{
	if (!g_UsersApiEnabled)
		return 0;

	new Headers:headers = RequestHeaders(
		"X-API-Key", g_UsersApiKey,
		"Content-Type", "application/json"
	);

	// los campos email/sex/age vienen de los dialogs de setup (State==4).
	// si el personaje se crea desde el flujo de char-select (caso normal de
	// una cuenta existente con 0 personajes), usamos los valores guardados
	// en TempEmail/TempSexo/TempEdad o defaults sensatos.
	new emailBuf[60];
	format(emailBuf, sizeof(emailBuf), "%s", PlayersDataOnline[playerid][TempEmail]);

	new sexVal = PlayersDataOnline[playerid][TempSexo];
	if ( sexVal < 0 || sexVal > 1 )
		sexVal = 0;

	new ageVal = PlayersDataOnline[playerid][TempEdad];
	if ( ageVal < 18 || ageVal > 99 )
		ageVal = 18;

	new Node:body = JsonObject(
		"account_id", JsonInt(TempAccountID[playerid]),
		"name", JsonString(characterName),
		"email", JsonString(emailBuf),
		"sex", JsonInt(sexVal),
		"age", JsonInt(ageVal)
	);

	new Request:req = RequestJSON(
		UsersApi_GetClient(),
		g_UsersApiCharCreatePath,
		HTTP_METHOD_POST,
		"OnCharacterCreate",
		body,
		headers
	);

	if (!IsValidRequest(req))
	{
		printf("[UsersApi] Error: fallo al crear personaje para %s[%i]", PlayersDataOnline[playerid][NameOnline], playerid);
		return 0;
	}
	usersApi_TrackRequest(req, playerid);
	return 1;
}

// envia PUT /characters/<character_id> con todos los campos del personaje.
// mapea PlayersData[playerid] -> JSON con las claves exactas que espera la API.
// (espejo de usersApi_ApplyCharacter en sentido inverso).
// fire-and-forget: no esperamos callback porque el jugador se esta desconectando.
usersApi_SaveCharacter(playerid)
{
	if (!g_UsersApiEnabled)
		return 0;

	new characterId = ApiCharacterID[playerid];
	if (characterId <= 0)
	{
		printf("[UsersApi] Save: sin character_id para %s[%i]", PlayersDataOnline[playerid][NameOnline], playerid);
		return 0;
	}

	new path[160];
	format(path, sizeof(path), g_UsersApiCharUpdatePath, characterId);

	new Headers:headers = RequestHeaders(
		"X-API-Key", g_UsersApiKey,
		"Content-Type", "application/json"
	);

	// construimos el body con los valores actuales de PlayersData
	new
		WeaponsData[50],
		AmmoData[50];

	for (new i = 0; i < 13; i++)
	{
		format(WeaponsData, sizeof(WeaponsData), "%s%i|", WeaponsData, _:PlayersData[playerid][WeaponS][i]);
		format(AmmoData, sizeof(AmmoData), "%s%i|", AmmoData, PlayersData[playerid][AmmoS][i]);
	}

	new Node:body = JsonObject(
		"hours_playing", JsonInt(PlayersData[playerid][HoursPlaying]),
		"admin", JsonInt(PlayersData[playerid][Admin]),
		"lockpicks", JsonInt(PlayersData[playerid][Ganzuas]),
		"health", JsonInt(floatround(PlayersData[playerid][Vida])),
		"armor", JsonInt(floatround(PlayersData[playerid][Chaleco])),
		"money", JsonInt(PlayersData[playerid][Dinero]),
		"skin", JsonInt(PlayersData[playerid][Skin]),
		"pos_x", JsonFloat(PlayersData[playerid][Spawn_X]),
		"pos_y", JsonFloat(PlayersData[playerid][Spawn_Y]),
		"pos_z", JsonFloat(PlayersData[playerid][Spawn_Z]),
		"pos_a", JsonFloat(PlayersData[playerid][Spawn_ZZ]),
		"world", JsonInt(PlayersData[playerid][World]),
		"interior", JsonInt(PlayersData[playerid][Interior]),
		"sex", JsonInt(PlayersData[playerid][Sexo]),
		"age", JsonInt(PlayersData[playerid][Edad]),
		"city", JsonInt(PlayersData[playerid][Ciudad]),
		"faction", JsonInt(PlayersData[playerid][Faccion]),
		"rank", JsonInt(PlayersData[playerid][Rango]),
		"materials", JsonInt(PlayersData[playerid][Materiales]),
		"drugs", JsonInt(PlayersData[playerid][Drogas]),
		"deaths", JsonInt(PlayersData[playerid][DeahtCount]),
		"kills", JsonInt(PlayersData[playerid][KilledCount]),
		"phone", JsonInt(PlayersData[playerid][Phone]),
		"fatigue", JsonInt(PlayersData[playerid][Cansansio]),
		"bank", JsonInt(PlayersData[playerid][Banco]),
		"bombs", JsonInt(PlayersData[playerid][Bombas]),
		"house_id", JsonInt(PlayersData[playerid][House]),
		"business_id", JsonInt(PlayersData[playerid][Negocio]),
		"car_id", JsonInt(PlayersData[playerid][Car]),
		"rent_id", JsonInt(PlayersData[playerid][Alquiler]),
		"walk_style", JsonInt(PlayersData[playerid][MyStyleWalk]),
		"talk_style", JsonInt(PlayersData[playerid][MyStyleTalk]),
		"fighting_style", JsonInt(PlayersData[playerid][Habilidad]),
		"job", JsonInt(PlayersData[playerid][Job]),
		"description_id", JsonInt(PlayersData[playerid][Description]),
		"description_color", JsonInt(PlayersData[playerid][DescriptionColor]),
		"warns", JsonInt(PlayersData[playerid][Warn]),
		"jail_time", JsonInt(PlayersData[playerid][Jail]),
		"jail_type", JsonInt(PlayersData[playerid][IsInJail]),
		"weapons", JsonString(WeaponsData),
		"ammo", JsonString(AmmoData),
		"pockets_0", JsonInt(PlayersData[playerid][Bolsillos][0]),
		"pockets_1", JsonInt(PlayersData[playerid][Bolsillos][1]),
		"pockets_2", JsonInt(PlayersData[playerid][Bolsillos][2]),
		"pockets_3", JsonInt(PlayersData[playerid][Bolsillos][3]),
		"pockets_4", JsonInt(PlayersData[playerid][Bolsillos][4]),
		"objects_0", JsonInt(PlayersData[playerid][Objetos][0]),
		"objects_1", JsonInt(PlayersData[playerid][Objetos][1]),
		"objects_2", JsonInt(PlayersData[playerid][Objetos][2]),
		"objects_3", JsonInt(PlayersData[playerid][Objetos][3]),
		"objects_4", JsonInt(PlayersData[playerid][Objetos][4]),
		"objects_5", JsonInt(PlayersData[playerid][Objetos][5]),
		"objects_6", JsonInt(PlayersData[playerid][Objetos][6]),
		"objects_7", JsonInt(PlayersData[playerid][Objetos][7]),
		"objects_8", JsonInt(PlayersData[playerid][Objetos][8])
	);

	new Request:req = RequestJSON(
		UsersApi_GetClient(),
		path,
		HTTP_METHOD_PUT,
		"OnCharacterUpdate",
		body,
		headers
	);

	if (!IsValidRequest(req))
	{
		printf("[UsersApi] Error: fallo al guardar personaje %i para %s[%i]", characterId, PlayersDataOnline[playerid][NameOnline], playerid);
		return 0;
	}
	usersApi_TrackRequest(req, playerid);
	return 1;
}

// callback del PUT. fire-and-forget: solo logueamos el resultado.
forward OnCharacterUpdate(Request:id, E_HTTP_STATUS:status, Node:node);
public OnCharacterUpdate(Request:id, E_HTTP_STATUS:status, Node:node)
{
	// el playerid ya se desconecto probablemente. solo logueamos el resultado.
	if (status == HTTP_STATUS_OK || status == HTTP_STATUS_NO_CONTENT)
	{
		// OK
		#pragma unused node
	}
	else
	{
		new errMsg[128];
		if (JsonGetString(node, "detail", errMsg, sizeof(errMsg)) != 0)
			format(errMsg, sizeof(errMsg), "HTTP %d", _:status);
		printf("[UsersApi] Error al guardar personaje: %s", errMsg);
	}
	return 1;
}

// re-muestra el Dialog 1 con texto de confirmacion de contrasena
// (caso "cuenta no existe, es registro").
usersApi_ShowConfirmPwd(playerid)
{
	new MsgWelcome[72];
	format(MsgWelcome, sizeof(MsgWelcome), "{"COLOR_AZUL"}Autenticacion - %s", PlayersDataOnline[playerid][NameOnlineFix]);
	ShowPlayerDialogEx(playerid, 1, DIALOG_STYLE_PASSWORD, MsgWelcome,
		"{"COLOR_TEXTO_DIALOGS"}La cuenta no existe, es un nuevo registro.\n\n{"COLOR_ROJO"}Re-ingrese la misma contrasena para confirmarla.", "Confirmar", "Cancelar");
}

// dialog del paso de email luego de crear la cuenta
usersApi_ShowEmailDialog(playerid)
{
	ShowPlayerDialogEx(playerid, 200, DIALOG_STYLE_INPUT,
		"{"COLOR_AZUL"}Registro - Email",
		"{"COLOR_TEXTO_DIALOGS"}Ingrese su Email\n\n{"COLOR_ROJO"}Nota: {"COLOR_TEXTO_DIALOGS"}Debe ser un email valido (contener @).",
		"Continuar", "Salir");
}

// dialog del paso de sexo
usersApi_ShowSexoDialog(playerid)
{
	ShowPlayerDialogEx(playerid, 201, DIALOG_STYLE_LIST,
		"{"COLOR_AZUL"}Registro - Sexo",
		"Hombre\nMujer", "Continuar", "Atras");
}

// dialog del paso de edad
usersApi_ShowEdadDialog(playerid)
{
	new body[256];
	format(body, sizeof(body),
		"{"COLOR_TEXTO_DIALOGS"}Ingrese su edad (entre 18 y 99).\n\nEdad actual seleccionada: %d",
		PlayersDataOnline[playerid][TempEdad]);
	ShowPlayerDialogEx(playerid, 202, DIALOG_STYLE_INPUT,
		"{"COLOR_AZUL"}Registro - Edad", body, "Continuar", "Atras");
}

// dialog del paso de nombre de personaje (ultimo paso antes de POST)
usersApi_ShowNameDialog(playerid)
{
	ShowPlayerDialogEx(playerid, 4, DIALOG_STYLE_INPUT,
		"{"COLOR_AZUL"}Registro - Personaje",
		"{"COLOR_TEXTO_DIALOGS"}Ingrese el Nombre_Apellido de su personaje\n{"COLOR_TEXTO_DIALOGS"}Formato: Nombre_Apellido",
		"Crear", "Atras");
}

// valida que un string tenga formato Nombre_Apellido (una sola underscore, largo razonable)
bool:IsValidNameApellido(const name[])
{
	new len = strlen(name);
	if (len < 3 || len >= MAX_PLAYER_NAME)
		return false;

	new underscoreCount = 0;
	for (new i = 0; i < len; i++)
	{
		if (name[i] == '_')
			underscoreCount++;
	}
	if (underscoreCount != 1)
		return false;

	new pos = strfind(name, "_", false);
	if (pos == 0 || pos == len - 1)
		return false;

	return true;
}

// muestra el TABLIST con los personajes de la cuenta y opcion de crear nuevo
forward ShowPlayerCharSelect(playerid);
public ShowPlayerCharSelect(playerid)
{
	new body[1024];
	new row[96];
	new charCount = 0;

	body[0] = EOS;

	for (new i = 0; i < MAX_CHARS_PER_ACCOUNT; i++)
	{
		if ( TempCharIDs[playerid][i] != 0 )
		{
			if (charCount > 0)
				strcat(body, "\n", sizeof(body));

			format(row, sizeof(row), "%s\tNivel %d", TempCharList[playerid][i], GetLevelFromHours(TempCharLevel[playerid][i]));
			strcat(body, row, sizeof(body));
			charCount++;
		}
	}

	// agregar opcion de crear nuevo si hay espacio
	if (charCount < MAX_CHARS_PER_ACCOUNT)
	{
		if (charCount > 0)
			strcat(body, "\n", sizeof(body));
		strcat(body, "{"COLOR_VERDE"}Crear Nuevo Personaje\t+", sizeof(body));
	}

	ShowPlayerDialogEx(playerid, 3, DIALOG_STYLE_TABLIST,
		"{"COLOR_AZUL"}Seleccione su personaje", body, "Seleccionar", "Salir");
}

// mapea un JSON CharacterFull a PlayersData[playerid]
// y llama a ContinueLoginFlow
usersApi_ApplyCharacter(playerid, Node:node)
{
	if (node == Node:-1)
		return 0;

	// asegurar limpieza por si quedo algo de un login anterior
	// (DataUserClean ya se llamo en OnPlayerConnect; aqui solo sobreescribimos los
	//  campos que vienen de la API)

	// id del personaje: lo guardamos para que DataUserSave haga PUT al desconectarse
	JsonGetInt(node, "id", ApiCharacterID[playerid]);

	// campos escalares
	new ret;
	new intVal;
	new strVal[64];

	// mapeo exacto de la API -> PlayersData (claves segun contrato de la API)
	ret = JsonGetInt(node, "skin", PlayersData[playerid][Skin]);
	ret = JsonGetInt(node, "money", PlayersData[playerid][Dinero]);
	ret = JsonGetInt(node, "bank", PlayersData[playerid][Banco]);
	ret = JsonGetInt(node, "health", intVal);
	if (ret == 0) PlayersData[playerid][Vida] = float(intVal);
	ret = JsonGetInt(node, "armor", intVal);
	if (ret == 0) PlayersData[playerid][Chaleco] = float(intVal);
	ret = JsonGetInt(node, "interior", PlayersData[playerid][Interior]);
	ret = JsonGetInt(node, "world", PlayersData[playerid][World]);
	ret = JsonGetInt(node, "sex", PlayersData[playerid][Sexo]);
	ret = JsonGetInt(node, "age", PlayersData[playerid][Edad]);
	ret = JsonGetInt(node, "city", PlayersData[playerid][Ciudad]);
	ret = JsonGetInt(node, "faction", PlayersData[playerid][Faccion]);
	ret = JsonGetInt(node, "rank", PlayersData[playerid][Rango]);
	ret = JsonGetInt(node, "materials", PlayersData[playerid][Materiales]);
	ret = JsonGetInt(node, "drugs", PlayersData[playerid][Drogas]);
	ret = JsonGetInt(node, "hours_playing", PlayersData[playerid][HoursPlaying]);
	ret = JsonGetInt(node, "admin", PlayersData[playerid][Admin]);
	ret = JsonGetInt(node, "lockpicks", PlayersData[playerid][Ganzuas]);
	ret = JsonGetInt(node, "deaths", PlayersData[playerid][DeahtCount]);
	ret = JsonGetInt(node, "kills", PlayersData[playerid][KilledCount]);
	ret = JsonGetInt(node, "phone", PlayersData[playerid][Phone]);
	ret = JsonGetInt(node, "fatigue", PlayersData[playerid][Cansansio]);
	ret = JsonGetInt(node, "house_id", PlayersData[playerid][House]);
	ret = JsonGetInt(node, "business_id", PlayersData[playerid][Negocio]);
	ret = JsonGetInt(node, "car_id", PlayersData[playerid][Car]);
	ret = JsonGetInt(node, "rent_id", PlayersData[playerid][Alquiler]);
	ret = JsonGetInt(node, "walk_style", PlayersData[playerid][MyStyleWalk]);
	ret = JsonGetInt(node, "talk_style", PlayersData[playerid][MyStyleTalk]);
	ret = JsonGetInt(node, "fighting_style", PlayersData[playerid][Habilidad]);
	ret = JsonGetInt(node, "job", PlayersData[playerid][Job]);
	ret = JsonGetInt(node, "description_id", PlayersData[playerid][Description]);
	ret = JsonGetInt(node, "description_color", PlayersData[playerid][DescriptionColor]);
	ret = JsonGetInt(node, "warns", PlayersData[playerid][Warn]);
	ret = JsonGetInt(node, "jail_time", PlayersData[playerid][Jail]);
	ret = JsonGetInt(node, "jail_type", PlayersData[playerid][IsInJail]);

	// normalizar estado de jail: si la API (o la version vieja del backend)
	// nos manda jail_type <= 0 significa "no en jail". forzamos IsInJail=-1
	// y Jail=0 para que el timer de OnPlayerUpdate
	//   if (IsInJail != -1 && Jail <= MyTime) SpawnPlayerEx();
	// no se dispare de forma espuria al entrar al server.
	if (PlayersData[playerid][IsInJail] <= 0)
	{
		PlayersData[playerid][IsInJail] = -1;
		PlayersData[playerid][Jail] = 0;
	}

	ret = JsonGetFloat(node, "pos_x", PlayersData[playerid][Spawn_X]);
	ret = JsonGetFloat(node, "pos_y", PlayersData[playerid][Spawn_Y]);
	ret = JsonGetFloat(node, "pos_z", PlayersData[playerid][Spawn_Z]);
	ret = JsonGetFloat(node, "pos_a", PlayersData[playerid][Spawn_ZZ]);

	// fallback: si la API no incluye coordenadas (personaje nuevo), usamos
	// el mismo spawn por defecto que usa el resto del codigo para evitar
	// aparecer en (0,0,0) con skin de CJ.
	if (PlayersData[playerid][Spawn_X] == 0.0
		&& PlayersData[playerid][Spawn_Y] == 0.0
		&& PlayersData[playerid][Spawn_Z] == 0.0)
	{
		PlayersData[playerid][Spawn_X]  = -2049.9419;
		PlayersData[playerid][Spawn_Y]  = 461.4292;
		PlayersData[playerid][Spawn_Z]  = 35.1719;
		PlayersData[playerid][Spawn_ZZ] = 312.4388;
	}

	CreatePlayerUniqueID(playerid);//REVISAR UBICACION

	if (JsonGetString(node, "name", strVal, sizeof(strVal)) == 0)
	{
		format(PlayersDataOnline[playerid][NameOnlineFix], MAX_PLAYER_NAME, "%s", strVal);
		// actualizar el nombre SA-MP para que el TAB muestre el Nombre_Apellido
		// del personaje en lugar del username maestro de la cuenta
		if (IsPlayerConnected(playerid) && strlen(strVal) >= 3)
		{
			format(PlayersDataOnline[playerid][NameOnline], MAX_PLAYER_NAME, "%s", strVal);
			SetPlayerName(playerid, PlayersDataOnline[playerid][NameOnline]);
			// SetPlayerName(playerid, PlayersData[playerid][UniqueID]);
		}
	}
	if (JsonGetString(node, "email", strVal, sizeof(strVal)) == 0)
	{
		format(PlayersData[playerid][Email], 60, "%s", strVal);
	}
	if (JsonGetString(node, "girlfriend", strVal, sizeof(strVal)) == 0)
	{
		format(PlayersData[playerid][GirlFreind], MAX_PLAYER_NAME, "%s", strVal);
	}
	if (JsonGetString(node, "myip", strVal, sizeof(strVal)) == 0)
	{
		format(PlayersData[playerid][MyIP], 16, "%s", strVal);
	}
	if (JsonGetString(node, "description", strVal, sizeof(strVal)) == 0)
	{
		format(PlayersData[playerid][DescriptionString], MAX_TEXT_DESCRIPTION, "%s", strVal);
	}

	// arrays: weapons, ammo, pockets, objects, faction, languages, licenses...
	new strValBig[128];

	if (JsonGetString(node, "weapons", strValBig, sizeof(strValBig)) == 0)
	{
		new tmpWeap[13];
		sscanf(strValBig, "p<|>A<i>[13]", tmpWeap);
		for (new i = 0; i < 13; i++)
			PlayersData[playerid][WeaponS][i] = WEAPON:tmpWeap[i];
	}

	if (JsonGetString(node, "ammo", strValBig, sizeof(strValBig)) == 0)
	{
		sscanf(strValBig, "p<|>A<i>[13]", PlayersData[playerid][AmmoS]);
	}

	ret = JsonGetInt(node, "pockets_0", PlayersData[playerid][Bolsillos][0]);
	ret = JsonGetInt(node, "pockets_1", PlayersData[playerid][Bolsillos][1]);
	ret = JsonGetInt(node, "pockets_2", PlayersData[playerid][Bolsillos][2]);
	ret = JsonGetInt(node, "pockets_3", PlayersData[playerid][Bolsillos][3]);
	ret = JsonGetInt(node, "pockets_4", PlayersData[playerid][Bolsillos][4]);

	ret = JsonGetInt(node, "objects_0", PlayersData[playerid][Objetos][0]);
	ret = JsonGetInt(node, "objects_1", PlayersData[playerid][Objetos][1]);
	ret = JsonGetInt(node, "objects_2", PlayersData[playerid][Objetos][2]);
	ret = JsonGetInt(node, "objects_3", PlayersData[playerid][Objetos][3]);
	ret = JsonGetInt(node, "objects_4", PlayersData[playerid][Objetos][4]);
	ret = JsonGetInt(node, "objects_5", PlayersData[playerid][Objetos][5]);
	ret = JsonGetInt(node, "objects_6", PlayersData[playerid][Objetos][6]);
	ret = JsonGetInt(node, "objects_7", PlayersData[playerid][Objetos][7]);
	ret = JsonGetInt(node, "objects_8", PlayersData[playerid][Objetos][8]);

	ret = JsonGetInt(node, "bombs", PlayersData[playerid][Bombas]);

	// flags booleanos del personaje
	new bool:tmp;
	if (JsonGetBool(node, "in_tutorial", tmp) == 0) PlayersData[playerid][InTutorial] = tmp;
	if (JsonGetBool(node, "enable_description", tmp) == 0) PlayersData[playerid][EnableDescription] = tmp;
	if (JsonGetBool(node, "description_custom", tmp) == 0) PlayersData[playerid][DescriptionSelect] = tmp;

	return 1;
}

// ============================================================================
// CALLBACKS HTTP
// ============================================================================

// POST /auth/login -> la API devuelve 200 si la cuenta existe y la pass es correcta,
// 404 si la cuenta no existe (en ese caso pedimos confirmacion de password y luego
// POST /auth/register),
// 401 si la pass es incorrecta, u otro codigo de error.
forward OnAuthLogin(Request:id, E_HTTP_STATUS:status, Node:node);
public OnAuthLogin(Request:id, E_HTTP_STATUS:status, Node:node)
{
	new playerid = playerid_lookup(id);
	if (playerid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid))
		return 1;

	if (status == HTTP_STATUS_NOT_FOUND)
	{
		// la cuenta no existe: pedir confirmacion de la contrasena
		// antes de registrar. guardamos la primera entrada y mostramos
		// el dialog de password de nuevo con un texto especifico.
		format(PlayersDataOnline[playerid][TempRegisterPwd], 25, "%s", PlayersDataOnline[playerid][TempPassword]);
		PlayersDataOnline[playerid][WaitingPwdConfirm] = true;
		usersApi_ShowConfirmPwd(playerid);
		return 1;
	}

	if (status == HTTP_STATUS_UNAUTHORIZED)
	{
		ShowPlayerLoginApi(playerid, false);
		SendInfoMessage(playerid, 0, "209", "Clave incorrecta, vuelva a intentarlo");
		return 1;
	}

	if (status != HTTP_STATUS_OK)
	{
		ShowPlayerLoginApi(playerid, true);
		SendInfoMessage(playerid, 0, "0", "Error de autenticacion. Intente nuevamente.");
		return 1;
	}

	// 200 OK: login exitoso, parsear account_id y characters
	JsonGetInt(node, "account_id", TempAccountID[playerid]);

	// limpiar lista previa
	for (new i = 0; i < MAX_CHARS_PER_ACCOUNT; i++)
	{
		TempCharIDs[playerid][i] = 0;
		TempCharList[playerid][i][0] = EOS;
		TempCharLevel[playerid][i] = 0;
	}

	new Node:charsNode;
	if (JsonGetArray(node, "characters", charsNode) == 0)
	{
		new length;
		JsonArrayLength(charsNode, length);

		new idx = 0;
		for (new i = 0; i < length && idx < MAX_CHARS_PER_ACCOUNT; i++)
		{
			new Node:charNode;
			JsonArrayObject(charsNode, i, charNode);

			// puede venir un objeto CharacterFull o un stub {id, name, level}
			new charId = 0;
			JsonGetInt(charNode, "id", charId);
			if (charId == 0)
				continue;

			TempCharIDs[playerid][idx] = charId;

			new charName[64];
			if (JsonGetString(charNode, "name", charName, sizeof(charName)) == 0)
			{
				format(TempCharList[playerid][idx], MAX_PLAYER_NAME, "%s", charName);
			}
			else
			{
				format(TempCharList[playerid][idx], MAX_PLAYER_NAME, "Personaje %d", idx + 1);
			}

			new charLevel = 0;
			JsonGetInt(charNode, "level", charLevel);
			TempCharLevel[playerid][idx] = charLevel;

			idx++;
		}
	}

	if (TempCharIDs[playerid][0] == 0)
	{
		// no hay personajes: ir directo a crear
		ShowPlayerDialogEx(playerid, 4, DIALOG_STYLE_INPUT,
			"{"COLOR_AZUL"}Crear Personaje",
			"{"COLOR_TEXTO_DIALOGS"}Ingrese el Nombre_Apellido de su personaje\n{"COLOR_TEXTO_DIALOGS"}Formato: Nombre_Apellido",
			"Crear", "Salir");
	}
	else
	{
		ShowPlayerCharSelect(playerid);
	}
	return 1;
}

// POST /auth/register
forward OnAuthRegister(Request:id, E_HTTP_STATUS:status, Node:node);
public OnAuthRegister(Request:id, E_HTTP_STATUS:status, Node:node)
{
	new playerid = playerid_lookup(id);
	if (playerid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid))
		return 1;

	if (status != HTTP_STATUS_OK && status != HTTP_STATUS_CREATED)
	{
		SendInfoMessage(playerid, 0, "0", "No se pudo crear la cuenta. Intente nuevamente.");
		// limpiar estado de confirmacion por si quedo seteado
		PlayersDataOnline[playerid][WaitingPwdConfirm] = false;
		format(PlayersDataOnline[playerid][TempRegisterPwd], 25, "");
		ShowPlayerLoginApi(playerid, true);
		return 1;
	}

	JsonGetInt(node, "account_id", TempAccountID[playerid]);

	// cuenta creada: no hay personajes todavia
	for (new i = 0; i < MAX_CHARS_PER_ACCOUNT; i++)
	{
		TempCharIDs[playerid][i] = 0;
		TempCharList[playerid][i][0] = EOS;
		TempCharLevel[playerid][i] = 0;
	}

	// limpiar flag de confirmacion: ya estamos registrados
	PlayersDataOnline[playerid][WaitingPwdConfirm] = false;
	format(PlayersDataOnline[playerid][TempRegisterPwd], 25, "");

	// arrancar la cadena de dialogs de post-registro: email -> sexo -> edad -> nombre
	PlayersDataOnline[playerid][State] = 4; // setup de personaje
	usersApi_ShowEmailDialog(playerid);
	return 1;
}

// GET /characters/<id>
forward OnCharacterLoad(Request:id, E_HTTP_STATUS:status, Node:node);
public OnCharacterLoad(Request:id, E_HTTP_STATUS:status, Node:node)
{
	new playerid = playerid_lookup(id);
	if (playerid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid))
		return 1;

	if (status != HTTP_STATUS_OK)
	{
		SendInfoMessage(playerid, 0, "0", "No se pudo cargar el personaje. Intente nuevamente.");
		ShowPlayerCharSelect(playerid);
		return 1;
	}

	usersApi_ApplyCharacter(playerid, node);
	UsersApi_FinalizeLogin(playerid);
	return 1;
}

// POST /characters/create
forward OnCharacterCreate(Request:id, E_HTTP_STATUS:status, Node:node);
public OnCharacterCreate(Request:id, E_HTTP_STATUS:status, Node:node)
{
	new playerid = playerid_lookup(id);
	if (playerid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid))
		return 1;

	if (status != HTTP_STATUS_OK && status != HTTP_STATUS_CREATED)
	{
		// intentar extraer el detalle del error
		new errMsg[128];
		if (JsonGetString(node, "detail", errMsg, sizeof(errMsg)) != 0)
			format(errMsg, sizeof(errMsg), "Error %d", _:status);
		SendInfoMessage(playerid, 0, "0", errMsg);
		ShowPlayerDialogEx(playerid, 4, DIALOG_STYLE_INPUT,
			"{"COLOR_AZUL"}Crear Personaje",
			"{"COLOR_TEXTO_DIALOGS"}Ingrese el Nombre_Apellido de su nuevo personaje\n{"COLOR_TEXTO_DIALOGS"}Formato: Nombre_Apellido",
			"Crear", "Cancelar");
		return 1;
	}

	usersApi_ApplyCharacter(playerid, node);
	UsersApi_FinalizeLogin(playerid);
	return 1;
}

// finalizacion del login: configurar timer, state y delegar a ContinueLoginFlow
UsersApi_FinalizeLogin(playerid)
{
	GetPlayerIp(playerid, PlayersData[playerid][MyIP], 16);

	SetPlayerColor(playerid, PLAYERS_COLOR);

	PlayersDataOnline[playerid][State] = 3;
	PlayersDataOnline[playerid][LoginTime] = gettime();

	ContinueLoginFlow(playerid);
	return 1;
}

// mapea Request:id -> playerid. el include no expone un builtin,
// asi que usamos un mapa chico indexado por ID.
// como el plugin asigna IDs unicos crecientes, los guardamos
// en una tabla fija de tamaño MAX_REQUESTS con doble indexacion.
#define USERS_API_MAX_PENDING 32
static g_UsersApiPendingReq[USERS_API_MAX_PENDING];
static g_UsersApiPendingPid[USERS_API_MAX_PENDING];

usersApi_TrackRequest(Request:id, playerid)
{
	for (new i = 0; i < USERS_API_MAX_PENDING; i++)
	{
		if (g_UsersApiPendingReq[i] == 0 || g_UsersApiPendingReq[i] == _:id)
		{
			g_UsersApiPendingReq[i] = _:id;
			g_UsersApiPendingPid[i] = playerid;
			return 1;
		}
	}
	// tabla llena: overwrite el primero
	g_UsersApiPendingReq[0] = _:id;
	g_UsersApiPendingPid[0] = playerid;
	return 1;
}

playerid_lookup(Request:id)
{
	for (new i = 0; i < USERS_API_MAX_PENDING; i++)
	{
		if (g_UsersApiPendingReq[i] == _:id)
			return g_UsersApiPendingPid[i];
	}
	return INVALID_PLAYER_ID;
}

// el plugin llama a esta callback por nombre cuando falla el transporte
// (DNS, timeout, conexion rechazada, etc). el Request:id permite
// recuperar el playerid que origino el request.
forward OnRequestFailure(Request:id, errorCode, errorMessage[], len);
public OnRequestFailure(Request:id, errorCode, errorMessage[], len)
{
	new playerid = playerid_lookup(id);
	if (playerid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid))
		return 1;

	printf("[UsersApi] Error de conexion: codigo %i - %s", errorCode, errorMessage);
	SendInfoMessage(playerid, 0, "0", "No se pudo conectar con el servidor de autenticacion.");
	ShowPlayerLoginApi(playerid, true);
	return 1;
}
