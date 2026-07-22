enum DataCarsEnum
{
	ID,
	VehicleID, 					// ID del Vehiculo
	Float:PosX,       			// 00 - Coordenadas X
	Float:PosY,       			// 01 - Coordenadas Y
	Float:PosZ,       			// 02 - Coordenadas Z
	Float:PosZZ,      			// 03 - Coordenadas ZZ
	Float:LastX,
	Float:LastY,
	Float:LastZ,
	Float:LastZZ,
	VEHICLE_PANEL_STATUS:PanelS,
	VEHICLE_DOOR_STATUS:DoorS,
	VEHICLE_LIGHT_STATUS:LightS,
	VEHICLE_TIRE_STATUS:TiresS,
	Modelo,     				// 04 - Modelo
	Color1,     				// 05 - Color 1
	Color2,     				// 06 - Color 2
	Dueno[MAX_PLAYER_NAME], 	// 07 - Propietario
	Lock,						// 08 - Lock
	Time,       				// 09 - Time
	Matricula,     				// 10 - Matricula
	MatriculaString[VEHICLE_PLATE_LENGTH],     	// 10.1 - Matricula String
	Puente,      				// 11 - Puente
	Gas,	      				// 12 - Gas
	ConteoOil,                  // 13 - ConteoOil
	GasNotShow,                 // 14 - GasNotShow
	OilNotShow,
	TimeGas,                    // 15 - Time Gas
//	Text:TextDrawGas,	      	// 16 - Gas Text
//	Text:TextDrawEstado,	    // 17 - Dato Text
//	Text:TextDrawVelocidad,	    // 18 - Velocidad Text
	StateEncendido,			    // 19 - Apagado o encendido
	LockPolice,                 // 20 - Candado de la policia
	ReasonLock[50],           	// 21 - Razon del candado
	MaleteroState,              // 22 - Estado del Maletero
	SlotsTunning[14],           // 23 Slots de Tunning
	Vinillo,
	CapoState,
	LightState,
	RespawnTimerId,
	IsIntermitente,             // 0 = Descativado | 1 = Izquiredo | 2 = Derecho
	ConteoIntermitente,
	AlarmOn,
	Oil,
	TemperaturaC,
	EngineState,
	Float:LastDamage,
//	LastVelocityInt,
	Interior,
	InteriorLast,
	World,
	WorldLast,
	AttachObjectID,
	TimeCalentamiento,
	LlenandoGas,
	StationID,
    GuanteraObjects[MAX_GUANTERA_GAVETA_SLOTS],
    GuanteraLock,
    TimerIdBug,
    VehicleDeath,
	VehicleAnticheat,
	Freno,
	OwnerId,
	FactionId, 
	JobId
};
new DataCars[MAX_VEHICLE_COUNT][DataCarsEnum];
new MAX_CAR;
new coches_Todos_Maleteros          [MAX_VEHICLE_COUNT][12][2]; // 7 - CHALECO | 8 - DROGAS | 9 - GANZUAS | 10 - MATERIALES | 11 - BOMBAS
new coches_Todos_Precios			[212];
new coches_Todos_Velocidad			[212];
new coches_Todos_Type               [212];
new coches_Todos_Nombres            [212][MAX_PLAYER_NAME];

new MAX_CAR_DUENO;
new MAX_CAR_FACCION;
new MAX_CAR_PUBLIC;

new TimeTren;
new TrainGroups[MAX_TRAINS][4];
new MAX_TRAIN = -1;

enum TaxisTaximetroEnum
{
	TaxiOn,
	TaxiTime[3],
	TaxiVehicleid,
	Text:Seats[3]
}
new TaxisTaximetro[MAX_TAXIS_COUNT][TaxisTaximetroEnum];
new MAX_TAXIS;

new NamesAlarma[2][10] =
{
	"Desactivo",
	"Activo"
};
// nuevo velocimetro - eliminado sistema viejo
// new Text:BarsGas[MAX_GAS_VEHICLE + 1];
// new Text:BarsDamage[MAX_DAMAGE_VEHICLE + 1];
// new Text:BarsOil[MAX_OIL_VEHICLE + 1];
// new Text:VelocimetroNumber1[10];
// new Text:VelocimetroNumber2[10];
// new Text:VelocimetroNumber3[10];
// new Text:TemperaturaTextDraws[42];
// new Text:VelocimetroFijos[9];