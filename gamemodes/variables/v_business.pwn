enum NegociosModeloEnum
{
	Float:PosInX,	          	// 00 - Pos X Adentro del Negocio
	Float:PosInY,          		// 01 - Pos Y Adentro del Negocio
	Float:PosInZ,          		// 02 - Pos Z Adentro del Negocio
	Float:PosInZZ,         		// 03 - Pos ZZ Adentro del Negocio
	Float:PosInX_PC,	        // 04 - Pos X PlayerCheckpoint Adentro del Negocio
	Float:PosInY_PC,          	// 05 - Pos Y PlayerCheckpoint Adentro del Negocio
	Float:PosInZ_PC,          	// 06 - Pos Z PlayerCheckpoint Adentro del Negocio
	InteriorId,         		// 08 - ID del interior del negocio
	TypeName[MAX_PLAYER_NAME],	// 09 - Nombre del tipo de negocio
	PickupId					// 11 - I ID del pickupp
};
new NegociosModelos[MAX_BIZZ_TYPE_COUNT][MAX_BIZZ_MODELS_BY_TYPE][NegociosModeloEnum];

enum NegociosEnum
{
	Float:PosOutX,          	// 00 - Pos X Afuera del Negocio
	Float:PosOutY,          	// 01 - Pos Y Afuera del Negocio
	Float:PosOutZ,          	// 02 - Pos Z Afuera del Negocio
	Float:PosOutZZ,         	// 03 - Pos ZZ Afuera del Negocio
	PickupOutId,          	 	// 04 - ID Del Pickup de afuera del negocio
	Type,          	 			// 05 - Type de negocio
	Text3D:TextLabel,
	Deposito,           		// 06 - Deposito del negocio
	Precio,           			// 07 - Precio del negocio
	Lock,           			// 08 - Cerrado o abierto
	NModel,           			// 09 - Modelo ed negocio
	PriceJoin,           		// 10 - Precio de entrada por defecto
	PricePiece,           		// 11 - Precio que pagara por el producto
	NameBizz[MAX_BIIZ_NAME], 	// 12 - Nombre del negocio
	Dueno[MAX_PLAYER_NAME], 	// 13 - Nombre del dueño del negocio
	Extorsion[MAX_PLAYER_NAME], // 14 - Nombre del extorsionista
	Materiales, 				// 15 - Nombre del extorsionista
	World,                      // 16 - Mundo del negocio
	DepositoExtorsion,          // 17 - Dinero Extorsion
	Empty0,
	Float:PosInX_PC,
	Float:PosInY_PC,
	Float:PosInZ_PC
};
new NegociosData[MAX_BIZZ_COUNT][NegociosEnum];

new Armas_Clases    		[9][25];
new Armas_Nombre			[9][5][30];
new Armas_Precios			[9][5][6];
new Armas_Precios_Num		[9][5];
new Armas_Municion          [9][5];
new Armas_ID				[9][5];