/// 				DEFINE
#define SERVER_NAME							"ULP Legacy Roleplay"
#define URL_WEB								"github.com/Xleone1/ulp-gamemode"

#define FORUM_BRIDGE_CFG_PATH				"Misc/forum_bridge.cfg"

#define WELCOME_MESSAGE						"Bienvenido a la comunidad de "SERVER_NAME""
#define TITULO_AYUDA "|»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»» Centro de Ayuda ««««««««««««««««««««««««««««««««««««««««««««««««|"
#define LOGO_STAFF "Staff:"

#define COLOR_TITULO_DE_AYUDA				0x778899FF
#define COLOR_TITULO_DIALOGS				"006CAA"
#define COLOR_TEXTO_DIALOGS					"F0F0F0"
#define COLOR_CREMA							"E6E6E6"
#define COLOR_AZUL							"00A5FF"
#define COLOR_VERDE							"00F50A"
#define COLOR_AMARILLO						"F5FF00"
#define COLOR_ROJO							"F50000"
#define COLOR_ROSA							"BE00FF"
#define COLOR_AZUL_OSCURO					"0037FF"
#define COLOR_OOC_CHANNEL					0xFFA000FF
#define COLOR_DUDAS                     	0x93A6FFFF
#define COLOR_CHEATS_REPORTES				0xFF4600FF
#define COLOR_RADIO							0x0069FFFF
#define COLOR_DE_TRANSMISION                0x00FFB4FF
#define COLOR_DE_NARRACION 	                0xFF8200FF
#define COLOR_FAMILY						0x00EBFFFF
#define COLOR_3DLABEL_PISTAS				0xFFC800FF
#define COLOR_DM       						0xFF0055FF
#define COLOR_DM_TEAM  						0x0087FFFF
#define COLOR_OWNED_CHAT                    0x2587CEFF
#define COLOR_MENSAJES_DE_AVISOS 			0x8C8C8CFF
#define COLOR_MALETERO_ARMARIO_CAJA_FUERTE  0xC3FF00FF
#define	COLOR_KICK_JAIL_BAN                 0xFFBE00FF
#define COLOR_DE_WISPEO                     0xF5FF00FF
#define COLOR_INFO_MOVIL                    0xFFF000FF
#define COLOR_COLGAR_DESCOLGAR              0x828282FF
#define PLAYERS_COLOR   	  				0xFEFEFEFF

#define SOUND_TUNNING                       1133
#define SOUND_START_RACE					1056
#define SOUND_VUELTA_VRACE					1057
#define SOUND_END_RACE						1133
#define SOUND_ALARM_CAR						1190

#define MAX_RADIO_STREAM                    300
#define WORLD_DEFAULT_INTERIOR              4
#define WORLD_NORMAL			            0
#define INFINITY_HEALTH 					(Float:0x7F800000)
#define MAX_TEXT_CHAT                       128

new const Meses[12][11] =
{
	{"Enero"},
	{"Febrero"},
	{"Marzo"},
	{"Abril"},
	{"Mayo"},
	{"Junio"},
	{"Julio"},
	{"Agosto"},
	{"Septiembre"},
	{"Octubre"},
	{"Noviembre"},
	{"Diciembre"}
};

new const NamesLook[2][10] =
{
	"Abrio",
	"Cerro"
};

new const NamesLookReverse[2][10] =
{
	"Cerro",
	"Abrio"
};

new const SiOrNo[2][3] =
{
	"No",
	"Si"
};

new const Ciudades[2][11] =
{
	"Los Santos",
	"San Fierro"
};

new const SendChatStreamColors[6] =
{
	0xF0F0F0FA,     // 1
	0xDCDCDCFA,     // 2
	0xC8C8C8FA,     // 3
	0xAFAFAFC8,     // 4
	0x9696A096,     // 5
	0x7D7D7D64      // 6
};

new const COLOR_MESSAGES[4] =
{   
	0xFFA97FFF,      // 0 - COLOR ERROR
	0xFFD97FFF,      // 1 - COLOR AYUDA
	0xC8C8C8CD,      // 2 - COLOR INFORMAcion
	0x33CCFFAA       // 3 - COLOR AFIRMATIVO
};

new const AccionesColors[20] =
{
	0xACC97F22A,        // 0 - ME - LILA
	0xFFFF00FF,         // 1 - AME - AMARILLO
	0x00FF00FF,         // 2 - INTENTAR OK - VERDE
	0xE10000FF,         // 3 - INTENTAR FAIL - ROJO
	0xFFFFFFFF,         // 4 - GRITAR - BLANCO
	0xE600FFFF,         // 5 - SUSURRAR - BLANCO
	0xF0F0F0FF,         // 6 - CANAL OOC - MEDIO GRIS
	0xFFFF00FF,         // 7 - AME FIX - AMARILLO
	0xACC97F22A,        // 8 - ME FIX - 0xACC97F22A
	0xFFFF00FF         // 9 - MEGAFONO
};

new const Float:AccionesRadios[20] =
{
	30.0,        // 0 - ME
	30.0,        // 1 - AME
	30.0,        // 2 - INTENTAR OK
	30.0,        // 3 - INTENTAR FAIL
	50.0,        // 4 - GRITAR
	3.0,         // 5 - SUSURRAR
	30.0,        // 6 - CANAL OOC
	30.0,        // 7 - AME
	30.0,         // 8 - ME
	60.0         // 9 - MEGAFONO
};

new const IdiomasNames[6][MAX_PLAYER_NAME] =
{
	"Aleman",           // 00 - Aleman
	"Frances",          // 01 - Frances
	"Portugues",        // 02 - Portugues
	"Italiano",         // 03 - Italiano
	"Ingles",           // 04 - Ingles
	"Japones"           // 05 - Japones
};

new const LicenciasNames[8][7] =
{
	"Armas", 	          // 00 - Armas
	"Coche",           	  // 01 - Coche
	"Camion",             // 02 - Camion
	"Moto",          	  // 03 - Moto
	"Vuelo",        	  // 04 - Vuelo
	"Botes",         	  // 05 - Bote
	"Tren",	    	      // 06 - Tren
	"Pesca"    	          // 07 - Pesca
};

new SlotIDWeapon[47] =
{
	0, // 0 - Unarmed
	0, // 1 - Brass Knuckles
	1, // 2 - Golf Club
	1, // 3 - Nite Stick
	1, // 4 - Knife
	1, // 5 - Baseball Bat
	1, // 6 - Shovel
	1, // 7 - Pool Cue
	1, // 8 - Katana
	1, // 9 - Chainsaw
	10, // 10 - Purple Dildo
	10, // 11 - Small White Vibrator
	10, // 12 - Large White Vibrator
	10, // 13 - Silver Vibrator
	10, // 14 - Flowers
	10, // 15 - Cane
	8, // 16 - Grenade
	8, // 17 - Tear Gas *
	8, // 18 - Molotov Cocktail
	-1, // 19 -
	-1, // 20 -
	-1, // 21 -
	2, // 22 - 9mm
	2, // 23 - Silenced 9mm
	2, // 24 - Desert Eagle
	3, // 25 - Shotgun
	3, // 26 - Sawn-off Shotgun
	3, // 27 - Combat Shotgun
	4, // 28 - Micro SMG
	4, // 29 - MP5
	5, // 30 - AK-47
	5, // 31 - M4
	4, // 32 - Tec9
	6, // 33 - Country Rifle
	6, // 34 - Sniper Rifle
	7, // 35 - Rocket Launcher
	7, // 36 - HS Rocket Launcher **
	7, // 37 - Flamethrower
	7, // 38 - Minigun
	8, // 39 - Satchel Charge ***
	12, // 40 - Detonator
	9, // 41 - Spraycan
	9, // 42 - Fire Extinguisher
	9, // 43 - Camera
	11, // 44 - Nightvision Goggles ****
	11, // 45 - Thermal Goggles ****
	11 // 46 - Parachute
};

new SlotNameWeapon[47][25] =
{
	"Nada", 					// 0 - Unarmed
	"Manopla", 					// 1 - Brass Knuckles
	"Palo de Golf", 			// 2 - Golf Club
	"Baston policial", 			// 3 - Nite Stick
	"Cuchillo", 				// 4 - Knife
	"Bate", 					// 5 - Baseball Bat
	"Pala", 					// 6 - Shovel
	"Palo de Billar",			// 7 - Pool Cue
	"Sable", 					// 8 - Katana
	"Motosierra", 				// 9 - Chainsaw
	"Consolador Rosado", 		// 10 - Purple Dildo
	"Consolador Pequeño", 		// 11 - Small White Vibrator
	"Consolador Largo", 		// 12 - Large White Vibrator
	"Consolador Plateado", 		// 13 - Silver Vibrator
	"Flores", 					// 14 - Flowers
	"Baston", 					// 15 - Cane
	"Granadas", 				// 16 - Grenade
	"Granadas de Gas",		 	// 17 - Tear Gas *
	"Coctel Molotov", 			// 18 - Molotov Cocktail
	-1, // 19 -
	-1, // 20 -
	-1, // 21 -
	"Pistola 9mm", 				// 22 - 9mm
	"Silenciada 9mm", 			// 23 - Silenced 9mm
	"Desert Eagle", 			// 24 - Desert Eagle
	"Escopeta", 				// 25 - Shotgun
	"Recortada", 				// 26 - Sawn-off Shotgun
	"Escopeta de Combate", 		// 27 - Combat Shotgun
	"Micro SMG", 				// 28 - Micro SMG
	"MP5", 						// 29 - MP5
	"AK-47", 					// 30 - AK-47
	"M4", 						// 31 - M4
	"Tec9", 					// 32 - Tec9
	"Rifle Corto Alcance", 		// 33 - Country Rifle
	"Rifle Largo Alcance", 		// 34 - Sniper Rifle
	"Cohete", 					// 35 - Rocket Launcher
	"RPG Cohete", 				// 36 - HS Rocket Launcher **
	"Lanzallamas", 				// 37 - Flamethrower
	"Minigun", 					// 38 - Minigun
	"Explosivos", 				// 39 - Satchel Charge ***
	"Detonador", 				// 40 - Detonator
	"Spray Policial", 			// 41 - Spraycan
	"Extintor de incendios", 	// 42 - Fire Extinguisher
	"Camara Fotografica", 		// 43 - Camera
	"Gafas de vision nocturna", // 44 - Nightvision Goggles ****
	"Gafas termicas", 			// 45 - Thermal Goggles ****
	"Paracaidas" 				// 46 - Parachute
};

new const abecedario[26][] = {
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
    "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
};

#include "constants/c_users.pwn"
#include "constants/c_vehicles.pwn"
#include "constants/c_business.pwn"
#include "constants/c_houses.pwn"

#include "constants/c_faccioes.pwn"
#include "constants/c_jobs.pwn"
#include "constants/c_mapper.pwn"
#include "constants/c_pickups.pwn"
#include "constants/c_teles.pwn"

#include "constants/c_bank.pwn"
#include "constants/c_bolsa.pwn"
#include "constants/c_bombas.pwn"
#include "constants/c_cartera.pwn"
#include "constants/c_fires.pwn"
#include "constants/c_gasolineras.pwn"
#include "constants/c_impuestos.pwn"
#include "constants/c_phone.pwn"
#include "constants/c_races.pwn"
#include "constants/c_robos.pwn"
#include "constants/c_traffic_items.pwn"
#include "constants/c_player_attachments.pwn"
#include "constants/c_camaras_vigilancia.pwn"
#include "constants/c_anims.pwn"
#include "constants/facebook.pwn"