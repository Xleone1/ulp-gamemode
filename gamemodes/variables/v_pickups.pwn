enum PickupsEnum
{
	Tipo,
	Tipoid,
	Tipoidextra
};
new PickupIndex[MAX_PICKUPS][PickupsEnum];

enum PickupInfoEnum
{
	Float:PosInfoX,
	Float:PosInfoY,
	Float:PosInfoZ,
	PickupId
}
new PickupInfo[MAX_PICKUP_INFO_COUNT][PickupInfoEnum];
new MAX_PICKUP_INFO;

new PickupidPoliceFurgo;
new PickupidAmbulance;
new PickupidFurgoCNN;
new PickupExitVagones[3];
new SuperMercadosPickupid[2];