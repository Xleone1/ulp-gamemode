// variables del sistema de velocimetro digital

// indices: 0=bg, 1=vel_num, 2=vel_unit, 3=gas_label, 4=gas_bg, 5=gas_fill, 6=oil_label, 7=oil_bg, 8=oil_fill, 9=ind_left, 10=ind_right
new SpeedoPTD[MAX_PLAYERS][11];

#define GetSpeedoPTD(%1,%2) (PlayerText:SpeedoPTD[%1][%2])
#define SetSpeedoPTD(%1,%2,%3) (SpeedoPTD[%1][%2] = _:%3)
