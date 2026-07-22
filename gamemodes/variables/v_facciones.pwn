enum FaccionesData
{
	NameFaccion[MAX_FACCION_NAME],
	Lider[MAX_PLAYER_NAME],
	Precio,
	Deposito,
	Paga[MAX_FACCION_RANGOS],
	Extorsion,
	Almacen[MAX_ALMACENES],
	LockA[MAX_ALMACENES],
	Float:AlmacenX[MAX_ALMACENES],
	Float:AlmacenY[MAX_ALMACENES],
	Float:AlmacenZ[MAX_ALMACENES],
	AlmacenWorld[MAX_ALMACENES],
	Float:Spawn_X[2],
	Float:Spawn_Y[2],
	Float:Spawn_Z[2],
	Float:Spawn_ZZ[2],
	Drogas[MAX_ALMACENES],
	Ganzuas[MAX_ALMACENES],
	Bombas[MAX_ALMACENES],
	InteriorSpawn,
	Float:PickupOut_X,
	Float:PickupOut_Y,
	Float:PickupOut_Z,
	Float:PickupOut_ZZ,
	Float:PickupIn_X,
	Float:PickupIn_Y,
	Float:PickupIn_Z,
	Float:PickupIn_ZZ,
	PickupidOutF,
	PickupidInF,
	Text3D:TextLabelOut,
	Text3D:TextLabelIn,
	PrecioFaccion,
	InteriorFaccion,
	Lock,
	World,
	Family,
	Radio
};
new FaccionData[MAX_FACCION_COUNT][FaccionesData];
new FaccionesRangos[MAX_FACCION_COUNT][MAX_FACCION_RANGOS][MAX_FACCION_NAME];
new RangosSkins[MAX_FACCION_COUNT][MAX_FACCION_RANGOS][MAX_FACCION_SKIN];
new	WeaponsFaccion[MAX_FACCION_COUNT][MAX_ALMACENES][10];
new AmmoFaccion[MAX_FACCION_COUNT][MAX_ALMACENES][10];
new Float:FaccionesChaleco[MAX_FACCION_COUNT][MAX_ALMACENES][4];

enum FaccionGetMercanciaEnum
{
	Float:PosX,
	Float:PosY,
	Float:PosZ
}
new FaccionesMercancias[MAX_FACCION_COUNT][FaccionGetMercanciaEnum];

new CallCNN = -1;
new EntrevistaState;

new IdArmasTraficantes[16] =
{
	1,                  // 00 - ID: 0 | Nombre: Brass Knuckles
	4,                  // 01 - ID: 0 | Nombre: Cuchillo
	5,                  // 02 - ID: 0 | Nombre: Bate
	6,                  // 03 - ID: 0 | Nombre: Pala
	8,                  // 04 - ID: 0 | Nombre: Katana
	22,                 // 05 - ID: 0 | Nombre: 9mm
	23,                 // 06 - ID: 0 | Nombre: Silenciada 9mm
	24,                 // 07 - ID: 0 | Nombre: Desert Eagle
	25,                 // 08 - ID: 0 | Nombre: Shotgun
	29,                 // 09 - ID: 0 | Nombre: MP5
	30,                 // 10 - ID: 0 | Nombre: AK-47
	31,                 // 11 - ID: 0 | Nombre: M4
	33,                 // 12 - ID: 0 | Nombre: Country Rifle
	34                  // 13 - ID: 0 | Nombre: Sniper Rifle
};

new MaterialesArmasTraficantes[16] =
{
	50,                  // 00 - ID: 0 | Nombre: Brass Knuckles
	100,                 // 01 - ID: 0 | Nombre: Cuchillo
	50,                  // 02 - ID: 0 | Nombre: Bate
	75,                  // 03 - ID: 0 | Nombre: Pala
	100,                 // 04 - ID: 0 | Nombre: Katana
	175,                 // 05 - ID: 0 | Nombre: 9mm
	150,                 // 06 - ID: 0 | Nombre: Silenciada 9mm
	300,                 // 07 - ID: 0 | Nombre: Desert Eagle
	250,                 // 08 - ID: 0 | Nombre: Shotgun
	350,                 // 09 - ID: 0 | Nombre: MP5
	400,                 // 10 - ID: 0 | Nombre: AK-47
	425,                 // 11 - ID: 0 | Nombre: M4
	500,                 // 12 - ID: 0 | Nombre: Country Rifle
	600,                  // 13 - ID: 0 | Nombre: Sniper Rifle
	1000                 // 14 - ID: 0 | Nombre: Bomba
};

new MunicionArmasTraficantes[16] =
{
	1,                  // 00 - ID: 0 | Nombre: Brass Knuckles
	1,                  // 01 - ID: 0 | Nombre: Cuchillo
	1,                  // 02 - ID: 0 | Nombre: Bate
	1,                  // 03 - ID: 0 | Nombre: Pala
	1,  	            // 04 - ID: 0 | Nombre: Katana
	50,                 // 05 - ID: 0 | Nombre: 9mm
	50,                 // 06 - ID: 0 | Nombre: Silenciada 9mm
	50,                 // 07 - ID: 0 | Nombre: Desert Eagle
	50,                 // 08 - ID: 0 | Nombre: Shotgun
	280,                // 09 - ID: 0 | Nombre: MP5
	280,                // 10 - ID: 0 | Nombre: AK-47
	280,                // 11 - ID: 0 | Nombre: M4
	50,                 // 12 - ID: 0 | Nombre: Country Rifle
	50	                // 13 - ID: 0 | Nombre: Sniper Rifle
};

new TimerDrogas;