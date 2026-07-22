enum DataUsers
{
	DB_ID,
	EmailTime,
	Email[60],           // Email
	Password[BCRYPT_HASH_LENGTH],       // 2
	AccountState,       // 3
	Float:Spawn_X,  	// 4
	Float:Spawn_Y, 		// 5
	Float:Spawn_Z, 	 	// 6
	Float:Spawn_ZZ, 	// 7
	HoursPlaying, 		// 8
	DeahtCount, 		// 9
	KilledCount, 		// 10
	Phone, 				// 11
	House, 				// 12
	Negocio, 			
	Car,				// 13
	Faccion,			// 14
	Rango,				// 15
	GirlFreind[MAX_PLAYER_NAME],// 16
	Bolsillos[5],		// 17
	Habilidad,			// 18
	Warn,				// 19
	Ciudad,				// 20
	Float:Vida,			// 21
	Float:Chaleco,		// 22
	Cansansio, 			// 23
	Dinero, 			// 24
	Banco, 				// 25
	Jail, 				// 26
	Admin,				// 27
	World,				// 28
	Interior,			// 29
	Skin,				// 30
	Drogas,				// 31
	Materiales,			// 32
    Lata,				// 33
	Ganzuas,			// 34
	Alquiler,			// 35
	Bombas,				// 36
	Sexo,				// 37
	Idiomas[6],			// 38
	Licencias[7],       // 39
	IsInJail,			// 40
	Nacer,				// 41
	TimeRequestBank,	// 42
	MyBonus,			// 43
	InTutorial,			// 44
	Edad,				// 45
	IsPlayerInHouse,	// 46
	TimeEquipo,			// 47
	SpawnAmigo,			// 48
	IsPaga,				// 50
	MyIP[16],			// 51
	Job,				// 52
	MyStyleWalk,		// 53
	Saldo,				// 55
	LicenciaPesca,		// 56
	IntermitentState,	// 57
	MyStyleTalk,		// 59
	IsPlayerInBizz,		// 60
	IsPlayerInGarage,	// 62
	WEAPON:WeaponS[13],
	AmmoS[13],
	Asignados[3],
    Bolsa[4],
    BolsaC[4],
    HaveBolsa,
    IsPlayerInVehInt,
    Cartera[MAX_COUNT_CARTERA],
    CarteraC[MAX_COUNT_CARTERA],
    CarteraT[MAX_COUNT_CARTERA],
    AccountBankingOpen,
    CarteraI[MAX_COUNT_CARTERA],
   	IsPlayerInBank,
    AlertSMSBank,
    HorasWork,
	CameraLogin,
	Enfermedad,
	Description,
	EnableDescription,
	DescriptionString[MAX_TEXT_DESCRIPTION],
	DescriptionColor,
	DescriptionSelect,
	SpawnFac,
	Objetos[MAX_OBJECTS_PLAYERS],
	ObjetosVision[MAX_OBJECTS_PLAYERS],
	TypePhone,
	Ayudante,
	Mapper,
	UniqueID[UNIQUE_ID_LENGTH]//ABC123
};
new PlayersData[MAX_PLAYERS][DataUsers];


enum DataUsersOnline
{
	State,
	LastCmdTime,
	CmdSpamCount,
	LastMsgTime,
	MsgSpamCount,
	FloodMuteTime,
	/*
	    0 - Conectando...
		1 - Login
		2 - Registro
		3 - Logueado
	*/
	CurrentDialog,
	LoginTime,
	Spawn,
	Espectando,
	NameOnline[MAX_PLAYER_NAME],
	NameOnlineFix[MAX_PLAYER_NAME],
	Intentar,
	StateMoneyPass,
	StateWeaponPass,
	StateChannelOOC,
	StateChannelFamily,
	StateChannelRadio,
	StateChannelCNN,
	StateJob,
	Paga,
	InPickup,
	InPickupFaccion,
	InPickupTele,
	InPickupNegocio,
	InPickupCasa,
	Float:MyPickupX,
	Float:MyPickupY,
	Float:MyPickupZ,
	Float:MyPickupZZ,
	MyPickupWorld,
	MyPickupLock,
	Float:MyPickupX_Now,
	Float:MyPickupY_Now,
	Float:MyPickupZ_Now,
	MyPickupInterior,
	Text:MyTextDrawShow,
	InvitePlayer,
	InviteFaccion,
	Frecuencia,
	AdminOn,
	Freeze,
	Wispers,
	Level,
	IsPagaO,
	Menu:InMenu,
	MyIDVehicleTunning,
	TypeSkinList,
	RowHair,
	TypeBuy,
	RowSkin,
	IsPlayerInHotel,
	AfterMenuRow,
	IsTaxi,
	SeatTaxi,
	SubAfterMenuRow,
	MyAmmoSelect,
	Float:VidaOn,
	Float:ChalecoOn,
	ChangeVC,
	InAnim,
	InCall,
	SendCommands,
	Altavoz,
	IsDescolgado,
	PhoneOnline,
	InSleep,
	CansansioConteo,
	InCarId,
	InVehicle,
	MyLastIdReport,
	TimeCallPublics,
	// Dar con Dialog
	IsEntrevistado,
	IsAtado,
	IsEsposas,
	IsTeazer,
	// estado del taser (toggle con /taser)
	// 0 = guardado | 1 = activo
	IsTaserEquipped,
	TaserSavedWeapon,
	TaserSavedAmmo,
	MarcaZZ,
	DarLlaves,
	StateDeath,
	TimerTutorialId,
	TimerCamaraId,
	TimerCamaraIdRace,
	IsNotSilenciado,
	ModeDM,
	TeamDM,
	ModeRace,
	Text3D:Description3D,
	IsAFK,
	Float:CoordenadasAFK[4],
	SaveAfterAgenda[60],
	SaveNameContact[10],
	JobBonus,
	IsCheckCheat,
	CountCheat,
	InWalk,
	TimeCall,
	ICall,
	SPECIAL_ACTION:InSpecialAnim,
	IsCheckUser,
	IsEspectando,
	EspectVehOrPlayer,
	IsCleanAnimCar,
	WEAPON:LastWeapondRow,
	IsAutorizado,
	NameProject[MAX_PLAYER_NAME],
	TimeLata,
	InCamera,
	NumberCallPublic,
	// nuevo velocimetro - eliminado sistema viejo
	// LastVel[3],
	// LastTextDrawTemperatura,
	// LastDamageInt,
	// LastGas,
	// LastOil,
	LicenciaTest,
	PointDm,
	ExitedVehicle,
	TimerLoginId,
	DesignGarageId,
	CallTime,
	PistaIDp,
	PosIDp,
	// Vender:       0 = playerid      1 = tipo
	PlayerSexo,
	VPhone[3],
	VCoche[2],
	VFactura[2],
	VServicio[2],
	VMulta[2],
	VRepair[2],
	VAceite[2],
	Contrato[2],
	VArma[2],
	VDrogas[3],
	VGanzuas[2],
	VProteger[2],
	CountIntentarVehicle,
	Float:CurrentHealth,
	Float:CurrentArmour,
	LastInterior,
	//Mapeos
	EditingType,//0: Nada | 1: Mapeo
	EditingMapeo,
	EditingObjectID,
	EditingIndex,
	EditingOption,//Index Material Option
	EditingMovement,
	//Teles
	TeleCreate, // Pos1 | Pos2
	TeleCreateInfo[2], //Mundo - Interior
	Float:TeleCreatePos[4],// XYZRZ
	GarageCreate,
	Float:GarageCreatePos[4],
	//Editar Impuestos
	Float:pAlicuotas[3], // Casas | Negocios | Vehiculos
	pPrecioPeaje,
	pPrecioCombustible,
	IsLookingGas,
	bool:PendingEmailGate,
	TempEmail[60],
	TempPassword[25],
	// password de registro: la API recibe 404 -> guardamos la primera aca,
	// pedimos confirmacion y solo si coincide procedemos a /auth/register
	TempRegisterPwd[25],
	bool:WaitingPwdConfirm,
	TempSexo,
	TempEdad
};
new PlayersDataOnline[MAX_PLAYERS][DataUsersOnline];

// seleccion de personaje: la API devuelve hasta 3 personajes por cuenta
new TempAccountID[MAX_PLAYERS];
new TempCharList[MAX_PLAYERS][3][MAX_PLAYER_NAME];
new TempCharIDs[MAX_PLAYERS][3];
new TempCharLevel[MAX_PLAYERS][3];
// id del personaje actualmente logueado (lo llena OnCharacterLoad/Create,
// lo consume DataUserSave para hacer PUT /characters/<id>)
new ApiCharacterID[MAX_PLAYERS];

new LataName[3][MAX_PLAYER_NAME] =
{
	"Vacia",         // 1
	"Gas",           // 2
	"Aceite"         // 3
};

new Sexos[2][20] =
{
	"Hombre",
	"Mujer"
};

new ModeTalkLibraryAnim[7][8] =
{
		"PED",
		"RAPPING",
		"GANGS",
		"GANGS",
		"GANGS",
		"GANGS",
		"GANGS"
};
new ModeTalkNameAnim[7][15] =
{
		"IDLE_chat",
		"RAP_A_Loop",
		"prtial_gngtlkB",
		"prtial_gngtlkE",
		"prtial_gngtlkF",
		"prtial_gngtlkG",
		"prtial_gngtlkH"
};
new ModeTalkName[7][11] =
{
		"Normal",       // 00 -
		"Barbaro",     // 01 -
		"Guapo",        // 02 -
		"Rapero",     // 03 -
		"Pandillero", // 04 -
		"Negociante", // 05 -
		"Expresivo" // 06 -
};
new ModeWalkID[15] =
{
	263,                  // 00 - WALK_player
	257,                  // 01 - WALK_drunk
	254,                  // 02 - WALK_civi
	258,                  // 03 - WALK_fat
	260,                  // 04 - WALK_gang1
	261,                 // 05 - WALK_gang2
	262,                 // 06 - WALK_old
	265,                 // 07 - WALK_shuffle
	264,                 // 08 - WALK_rocket
	270,                 // 09 - Walk_Wuzi
	275,                 // 10 - WOMAN_runfatold
	278,                  // 11 - WOMAN_walkbusy
	280,                  // 12 - WOMAN_walkpro
	283,                  // 13 - WOMAN_walksexy
	279                  // 14 - WOMAN_walkfatold
};
new ModeWalkName[15][MAX_PLAYER_NAME] =
	{
		"Normal",       // 00 -
		"Borracho",     // 01 -
		"Civil",        // 02 -
		"Chambado",     // 03 -
		"Pandillero 1", // 04 -
		"Pandillero 2", // 05 -
		"Viejo 1",      // 06 -
		"Viejo 2",      // 07 -
		"Lesionado",    // 08 -
		"Ciego",        // 09 -
		"Cansado",      // 10 -
		"Mujer 1",      // 11 -
		"Mujer 2",      // 12 -
		"Mujer Sexy",   // 13 -
		"Vieja"         // 14 -
};

new EnfermedadName[7][16] =
	{
		"Ninguna",      // 00 -
		"Dengue",     	// 01 -
		"Gripe A",  	// 02 -
		"Sifilis",     	// 03 -
		"Conjunctivitis",// 04 -
		"Fiebre", 		// 05 -
		"Gonorrea"      // 06 -
};
new EnfermedadColores[7][10]=
{
	"{FFFFFF}",     // 00 - Ninguna
	"{1D4BA1}",     // 01 - Dengue-
	"{00D400}",  	// 02 - Gripe A -
	"{6F00D6}",    	// 03 - Sida -
	"{EE6F00}", 	// 04 - Cancer -
	"{38CAE0}", 	// 05 - Fiebre
	"{CDE000}"      // 06 - Gonorrea
};
new EnfermedadTiempo[7]=
	{
		80,     // 00 - Ninguna
		50,     // 01 - Dengue
		60,  	// 02 - Gripe A
		40,    	// 03 - Sida
		30, 	// 04 - Cancer
		45, 	// 05 - Fiebre
		70      // 06 - Gonorrea
};

new DescriptionsPerColors[14] =
{
	0x00CDFFFF, //Celeste
	0xCA3022FF, //Rojo oscuro
	0x4A4AFFFF, //Azul Claro
	0xAA00FFFF, //Violeta
	0x7D0000FF, //Marron
	0xC00000FF, //Rojo
	0xD40000FF, //Rojo Claro
	0x0000E0FF, //Azul
	0xD4D438FF, //Amarillo
	0x686884FF, //Gris
	0x7650A8FF, //Purpura
	0xD46C00FF, //Naranja
	0x00D4A1FF,  //Menta
	0x008228FF  //Verde Oscuro

};
new DescriptionsPerColorsHTML[14][7] =
{
	"00CDFF",
	"C33022",
	"4A4AAF",
	"AA00FF",
	"7D0000",
	"C00000",
	"D40000",
	"0000E0",
	"D4D438",
	"686884",
	"7650A8",
	"D46C00",
	"00D4A1",
	"008228"
};
new DescriptionsColors[13] =
{
	0x00CDFFFF, //Feliz
	0xCA3022FF, //Enojado
	0x4A4AFFFF, //Triste
	0x0000A8FF, //Aburrido
	0x006238FF, //Amargado
	0xC00000FF, //Molesto
	0xD40000FF, //Furioso
	0x0000E0FF, //Relajado
	0xD4D438FF, //Nostalgico
	0x686884FF, //Serio
	0x7650A8FF, //Deprimido
	0xD46C00FF, //Nervioso
	0x00D4A1FF  //Emocionado
};

new DescriptionsPerType[2][14] =
{
	{"Estatico"},
	{"Personalizada"}
};
new DescriptionsText[13][11] =
{
	{"Feliz"},
	{"Enojado"},
	{"Triste"},
	{"Aburrido"},
	{"Amargado"},
	{"Molesto"},
	{"Furioso"},
	{"Relajado"},
	{"Nostalgico"},
	{"Serio"},
	{"Deprimido"},
	{"Nervioso"},
	{"Emocionado"}
};
new DescriptionsPerNames[14][15] =
{
	{"Celeste"},
	{"Rojo Oscuro"},
	{"Azul Claro"},
	{"Violeta"},
	{"Marron"},
	{"Rojo"},
	{"Rojo Claro"},
	{"Azul"},
	{"Amarillo"},
	{"Gris"},
	{"Purpura"},
	{"Naranja"},
	{"Menta"},
	{"Verde Oscuro"}
};

new NameConfigutionUser[2][20] =
{
	"{"COLOR_VERDE"}Automatico",
	"{"COLOR_AMARILLO"}Manual"
};