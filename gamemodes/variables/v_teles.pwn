enum TelesEnum
{
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:PosZZ,
	PickupID,
	PickupIDGo,
	Text3D:TextLabel,
	World,
	Interior,
	Lock,
	Dueno,
	DuenoType, // 0: Faccion | 1: Negocio | 2: Casa
	IsBankTele,
	IsHotelTele,
	IsNegocioTele,
	IsCasaTele,
	IsGarage,
	Garage_ID,
	PrecioEntrada,
	LugarText[128]
};

new Teles[MAX_TELES_COUNT][TelesEnum];
new MAX_TELES;
new TelesDuenoType[3][10] = {"Faccion","Negocio","Casa"};


enum GaragesExEnum
{
	Creado,
	ID_Tele,
	Float:PosXOne,
	Float:PosYOne,
	Float:PosZOne,
	Float:PosZZOne,
	Float:PosXTwo,
	Float:PosYTwo,
	Float:PosZTwo,
	Float:PosZZTwo
};
new GaragesEx[MAX_GARAGES_EX_COUNT][GaragesExEnum];