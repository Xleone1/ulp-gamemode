enum PistasEnum
{
	NamePista[35],
	Valid,
	ValidR,
	ShowTagPos,
	ShowTagPlayers,
	ShowTagCarPointsExit,
	ShowTagCamPoints,
	Lock,
	Interior,
	World,
	Used,
	ConteoPlayers,
	TimeStart,
	MaxCheckPointsTotal,
	IsCameras,
	Repair,


/* Configuracion de la Carrera */
	Vueltas,
	Competidores,
	SaveRecord,
	ConteoR,
	TiempoAntes,
	Tipo,
	EstadoR,
	CochesP,
	AlReves,
	CheckPointFinal,
	RaceTimer,
	MinPP,
	MaxPP,
	MaxCameras,
	Float:Radio
}
new Pistas[MAX_COUNT_PISTAS][PistasEnum];

enum PistasPosEnum
{
	Valid,
	Float:Xpos,
	Float:Ypos,
	Float:Zpos,
	Text3D:Text3DPista,
	Text3DPistaB
}
new PistasPos[MAX_COUNT_PISTAS][MAX_COUNT_PISTAS_POS][PistasPosEnum];

enum PistasPosPlayersEnum
{
	Valid,
	Float:Xpos,
	Float:Ypos,
	Float:Zpos,
	Float:ZZpos,
	Text3D:Text3DPista,
	Text3DPistaB,

	/* Configuracion de la Carrera */
	ExitReason,
	VehicleIDR,
	PlayerIDR,
	VueltaR,
	LastCheckPoint,
	TimeFinish,
	PosFinish,

	/* Info Vuelta */
	NameR[MAX_PLAYER_NAME],
	PistaIDR,
}
new PistasPosPlayers[MAX_COUNT_PISTAS][MAX_COUNT_PISTAS_POS_PLAYERS][PistasPosPlayersEnum];

enum PistasCarPointsExitEnum
{
	Valid,
	Float:Xpos,
	Float:Ypos,
	Float:Zpos,
	Float:ZZpos,
	Text3D:Text3DPista,
	Text3DPistaB
}
new PistasCarPointsExit[MAX_COUNT_PISTAS][MAX_COUNT_PISTAS_POS_PLAYERS][PistasCarPointsExitEnum];

enum PistasTopEnum
{
    PlayerName[MAX_PLAYER_NAME],
	Time,
	Empty_1,
	Empty_2,
	Vueltas,
    DateHour,
    DateMinute,
    DateSecond,
    DateMonth,
    DateDay,
    DateYear,
	CarModel
}
new PistasTop[MAX_COUNT_PISTAS][MAX_COUNT_PISTAS_TOP][PistasTopEnum];

enum PistasCamerasEnum
{
	Valid,
	Float:Xpos,
	Float:Ypos,
	Float:Zpos,
	Float:Vel,

	Text3D:Text3DPista,
	Text3DPistaB
}
new PistasCameras[MAX_COUNT_PISTAS][MAX_COUNT_PISTAS_CAMERAS][PistasCamerasEnum];

new Text:ScoreRaceBox;
new Text:ScorePosRace[MAX_COUNT_PISTAS];

new CochesPistaNames[6][10] =
{
	"TODOS",
	"Coches",
	"Camiones",
	"Motos",
	"Aviones",
	"Bote"
};
new PistasType[2][10] =
{
	"vehiculos",
	"Aereos"
};
new PistasTypeEstados[2][8] =
{
	"Publica",
	"Privada"
};
new PistasTypeUses[4][13] =
{
	"Detenida",
	"Esperando...",
	"Conteo...",
	"En Uso"
};
new PistasTypeFinal[6][20] =
{
	"Desconecto",
	"Expulsado",
	"Termino",
	"Murio",
	"Exploto",
	"Salida Voluntaria"
};