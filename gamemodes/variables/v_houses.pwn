enum HouseEnums
{
	Dueno[MAX_PLAYER_NAME],
	ArmarioWeapon[7],
	ArmarioAmmo[7],
	Float:Chaleco,
	Drogas,
	Ganzuas,
	Bombas,
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:PosZZ,
	Interior,
	TypeHouseId,
	PickupId,
	Text3D:TextLabel,
	PriceRent,
	Level,
	World,
	Lock,
	Price,
	Deposito,
	Materiales,
	ArmarioLock,
	RefrigeradorLock,
	RingHouseTime,
	StationID,
    GavetaObjects[MAX_GUANTERA_GAVETA_SLOTS],
    GavetaLock
}
new HouseData[MAX_HOUSE_COUNT][HouseEnums];
new MAX_HOUSE;

enum HouseFriendsEnum
{
    Name[MAX_PLAYER_NAME],
}
new HouseFriends[MAX_HOUSE_COUNT][MAX_HOUSE_FRIENDS][HouseFriendsEnum];

enum TypeHouseEnums
{
	TypeName[MAX_PLAYER_NAME],
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:PosZZ,
	Interior,
	PickupId
}
new TypeHouse[MAX_HOUSE_TYPE_COUNT][TypeHouseEnums];
new MAX_HOUSE_TYPE;


enum GaragesEnum
{
    Float:Xg,
    Float:Yg,
    Float:Zg,
    Float:ZZg,
    Float:XgIn,
    Float:YgIn,
    Float:ZgIn,
    Float:ZZgIn,
    Float:XgOut,
    Float:YgOut,
    Float:ZgOut,
    Float:ZZgOut,
    LockIn,
    LockOut,
	PickupidIn,
	PickupidOut,
	TypeGarageE,
	WorldG
}
new Garages[MAX_HOUSE_COUNT][MAX_GARAGE_FOR_HOUSE][GaragesEnum];
new MAX_GARAGES;


enum GaragesDesingEnum
{
    Float:Xg,
    Float:Yg,
    Float:Zg,
    Float:ZZg,
    Float:XgIn,
    Float:YgIn,
    Float:ZgIn,
    Float:ZZgIn,
    Float:XgOut,
    Float:YgOut,
    Float:ZgOut,
    Float:ZZgOut,
	TypeGarageE
}
new GaragesDesing[MAX_GARAGES_DESING][GaragesDesingEnum];

enum TypeGarageEnums
{
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:PosZZ,
	Float:PosXh,
	Float:PosYh,
	Float:PosZh,
	Float:PosZZh,
	Float:PosXc,
	Float:PosYc,
	Float:PosZc,
	Float:PosZZc,
	Interior,
	PickupId,
	PickupIdh
};
new TypeGarage[MAX_GARAGE_TYPE_COUNT][TypeGarageEnums];
new MAX_GARAGE_TYPE;

enum RefrigeradorEnum
{
	Articulo[MAX_REFRIGERADOR_SLOTS_COUNT],
	Cantidad[MAX_REFRIGERADOR_SLOTS_COUNT]
}
new Refrigerador[MAX_HOUSE_COUNT][RefrigeradorEnum];