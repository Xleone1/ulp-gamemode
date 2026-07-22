SetMenuTraficante(playerid)
{
	new ListDialog[700];
	format(ListDialog, sizeof(ListDialog),
	"{"COLOR_CREMA"}01- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}02- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}03- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}04- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}05- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}06- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}07- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}08- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}09- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}10- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}11- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}12- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}13- %s {"COLOR_VERDE"}(%i)\r\n{"COLOR_CREMA"}14- %s {"COLOR_VERDE"}(%i){"COLOR_CREMA"}\r\n15- Bomba {"COLOR_VERDE"}(1000)",
	SlotNameWeapon[IdArmasTraficantes[0]],
	MaterialesArmasTraficantes[0],
	SlotNameWeapon[IdArmasTraficantes[1]],
	MaterialesArmasTraficantes[1],
	SlotNameWeapon[IdArmasTraficantes[2]],
	MaterialesArmasTraficantes[2],
	SlotNameWeapon[IdArmasTraficantes[3]],
	MaterialesArmasTraficantes[3],
	SlotNameWeapon[IdArmasTraficantes[4]],
	MaterialesArmasTraficantes[4],
	SlotNameWeapon[IdArmasTraficantes[5]],
	MaterialesArmasTraficantes[5],
	SlotNameWeapon[IdArmasTraficantes[6]],
	MaterialesArmasTraficantes[6],
	SlotNameWeapon[IdArmasTraficantes[7]],
	MaterialesArmasTraficantes[7],
	SlotNameWeapon[IdArmasTraficantes[8]],
	MaterialesArmasTraficantes[8],
	SlotNameWeapon[IdArmasTraficantes[9]],
	MaterialesArmasTraficantes[9],
	SlotNameWeapon[IdArmasTraficantes[10]],
	MaterialesArmasTraficantes[10],
	SlotNameWeapon[IdArmasTraficantes[11]],
	MaterialesArmasTraficantes[11],
	SlotNameWeapon[IdArmasTraficantes[12]],
	MaterialesArmasTraficantes[12],
	SlotNameWeapon[IdArmasTraficantes[13]],
	MaterialesArmasTraficantes[13]
	);
	ShowPlayerDialogEx(playerid,10,DIALOG_STYLE_LIST,"{"COLOR_AZUL"}Crear Arma", ListDialog, "Crear", "Cancelar");
}