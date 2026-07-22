new SiOrNoBank[2][11] =
{
	"{"COLOR_ROJO"}No",
	"{"COLOR_VERDE"}Si"
};

enum CajerosEnum
{
	Float:PosX,
	Float:PosY,
	Float:PosZ
};
new Cajeros[MAX_CAJEROS_COUNT][CajerosEnum];
new MAX_CAJEROS;

enum AccountBankEnum
{
	Owner[MAX_PLAYER_NAME],
	Balance,
	LockIn,
	LockOut
}
new Banking[MAX_PLAYERS][AccountBankEnum];

enum ChequesEnum
{
	UniqueID,
	Type,
	NombreCh[MAX_PLAYER_NAME],
	Ammount
}
new Cheques[MAX_PLAYERS][MAX_COUNT_CHEQUES][ChequesEnum];