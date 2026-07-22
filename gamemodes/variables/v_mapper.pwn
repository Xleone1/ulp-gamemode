enum ObjetosEnum
{
	Modelo,
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:PosRX,
	Float:PosRY,
	Float:PosRZ,
	Mundo,
	Interior,
	//////////
	CreatedBy[MAX_PLAYER_NAME],
	Tipo,//0: Objeto | 1: Puerta | 2: Peaje | 3: Parqueo
	Tipoid,
	//////////
	materialtype[MAX_MATERIALINDEX],//0: Default | 1: Material | 2: MaterialText
	//////////
	texturemodel[MAX_MATERIALINDEX],
	materialcolor[MAX_MATERIALINDEX],//ARGB - 0 Disables
	//////////
	materialsize[MAX_MATERIALINDEX],
	fontsize[MAX_MATERIALINDEX],//0-255
	bold[MAX_MATERIALINDEX],
	fontcolor[MAX_MATERIALINDEX],//ARGB
	backgroundcolor[MAX_MATERIALINDEX],//ARGB
	textalignment[MAX_MATERIALINDEX],//0: Left | 1: Center | 2: Right
	//////////
	ID_Objeto
};

new Mapeo[MAX_MAPEOS_COUNT][ObjetosEnum];
new MAX_MAPEOS;

new MapeoTxdName[MAX_MAPEOS_COUNT][MAX_MATERIALINDEX][30];
new MapeoTextureName[MAX_MAPEOS_COUNT][MAX_MATERIALINDEX][30];
//////////
new MapeoText[MAX_MAPEOS_COUNT][MAX_MATERIALINDEX][128];
new MapeoFont[MAX_MAPEOS_COUNT][MAX_MATERIALINDEX][40];

new IndexType[3][20] = {"{"COLOR_ROJO"}Sin Uso","{"COLOR_VERDE"}Textura","{"COLOR_AZUL"}Texto"};
new Alineacion[3][10] = {"Izquierda","Centro","Derecha"};
new MapeoType[4][10] = {"Objeto","Puerta","Peaje","Parqueo"};

enum PuertaEnum
{
    ID_Mapeo,
    Creada,
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:PosRX,
	Float:PosRY,
	Float:PosRZ,
	Float:Velocidad,
	Abierta,
	LlaveTipo,//0: Faccion | 1: Casa | 2: Negocio
	LlaveOwnerID
};

new Puerta[MAX_PUERTAS_COUNT][PuertaEnum];
new MAX_PUERTAS;

enum PeajesParqueoEnum
{
	ID_Mapeo,
	Creado,
	Float:PosXFalse,
	Float:PosYFalse,
	Float:PosZFalse,
	Float:PosRotXFalse,
	Float:PosRotYFalse,
	Float:PosRotZFalse,
	Float:PosCommandX,
	Float:PosCommandY,
	Float:PosCommandZ,
	Float:Velocidad,
	Abierto
};

new Peajes[MAX_PEAJES_COUNT][PeajesParqueoEnum];
new MAX_PEAJES;

new Parqueo[MAX_PARQUEOS_COUNT][PeajesParqueoEnum];
new MAX_PARQUEOS;

new MAX_GARAGES_EX;

new LlaveTipoName[3][10] = {"Faccion","Casa","Negocio"};
new MapperRangos[2][20] = {"Mapper Ayudante", "Mapper Oficial"};