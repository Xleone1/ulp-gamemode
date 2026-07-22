#define DIR_USERS "users"
#define VIDA_CRACK                          15
#define NAME_TAG_DISTANCE_DEFAULT			15.0
#define MAX_CANSANSIO						54 	// + 550
#define MAX_TEXT_DESCRIPTION 130
#define UNIQUE_ID_LENGTH 6

// maximo de personajes por cuenta definidos por la API
#define MAX_CHARS_PER_ACCOUNT 1

// estados del flujo de login basado en API
// (mismo enum DataUsersOnline.State que ya existia; valores agregados)
/*
	0 - Conectando...
	1 - Login (esperando password)
	2 - Registro (esperando password)
	3 - Logueado (personaje cargado, en juego)
	4 - Seleccion de personaje (post login, antes de entrar al juego)
*/