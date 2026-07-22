LoadTexDrawsTutorial()
{
	//      \x98 = A Con tilde
	// 		\x9e = E con tilde
	//      \xa2 = I Con tilde
	//		\xa6 = O Con tilde

	// Ayuntamiento
	SetTextDrawTutorial(0, "~B~Buenas! Te queremos presentar todo ~N~lo que es y somos ~B~UN ~G~Player~N~~W~Para eso, hemos preparado este corto tutorial y~N~darte una calurosa bienvenida!");
	// Camioneros
	SetTextDrawTutorial(1, "En el servidor encontraras lo t\xa2pico y lo no t\xa2pico ~N~de servidores ~G~RolePlay~W~ como por ejemplo:~N~~B~-Interiores para cada Faccion~N~-Sub-Interiores dentro de los mismos~N~-Todos los sistemas desde 0~N~~W~Entre muchisimas otras cosas que usted mismo ~N~podra descubrir!");
	// Taxis
	SetTextDrawTutorial(2, "Solo pedimos que se respeten todas las reglas~N~del servidor, para eso le aconsejamos~N~que lea las reglas ~R~\"/Reglas\"~W~~N~y a la vez nos ayuda a ser un mejor servidor!");
	// Taller
	SetTextDrawTutorial(3, "Recuerde visitar el foro en: ~G~"URL_WEB" ~W~donde ~N~ encontrara diversa informacion ~N~para debatir");
	// CNN
	SetTextDrawTutorial(4, "Al igual el foro es un medio muy t\xa2pico ~N~de encontrar un empleo, as\xa2 ~N~que no pierda el tiempo!");
	// Detectives
	SetTextDrawTutorial(5, "Tambi\x9en si consta con un micro y usa el TeamSpeak 3~N~Puede conectarse a nuestro servidor~N~en la siguiente IP:~N~~G~----~N~~W~All\xa2 podras encontrar varias salas privadas ~N~para cada faccion entre otros");
	// Licencieros
	SetTextDrawTutorial(6, "Esperamos que con este corto tutorial vaya ~N~teniendo una idea de cual es nuestro objetivo que ~N~no es mas ~B~Que divertirnos!~N~~N~~N~~N~~N~~R~Ahora lo dejamos con una breve~N~explicacion de las reglas principales");
	SetTextDrawTutorial(7, "~R~Qu\x9e es un server de Rol~B~?~N~~N~~W~-Un servidor de Rol es una simulacion de la vida~N~real, donde se debe tratar de  actuar y hacer las ~N~cosas lo mas aproximado a la vida real.");
	SetTextDrawTutorial(8, "~R~Qu\x9e son los canales IC y OOC~B~?~N~~N~~B~IC(In Character)~W~ Es cuando hablas dentro del personaje~N~que representas el juego.~N~~N~~B~OOC(Out Of Character)~W~ Es cuando hablas fuera de~N~ tu personaje (La persona en la vida real)");
	SetTextDrawTutorial(9, "~R~Qu\x9e es confusion de canales~B~?~N~~N~~W~Es cuando se dicen cosas OOC en IC.~N~Es mezclar informacion de la vida real, con la otra~N~realidad dentro del servidor.~N~~N~~B~Ejemplo: ~W~Te acercas a una persona y le preguntas IC: ~N~Qui\x9en es admin aqu\xa2? De que faccion eres?");
	SetTextDrawTutorial(10, "~R~Qu\x9e es MG(MetaGaming)~B~?~N~~N~~W~Es cuando llamas a una persona por su nombre, sin~N~que \x9el te lo hubiera  dicho IC, Simplemente lo~N~llamaste por su nombre porque lo viste  encima de~N~su cabeza.~N~~G~Continua...");
	SetTextDrawTutorial(11, "~B~Ejemplo: ~N~~W~Vez el nombre del jefe de una~N~mafia del server,~N~en alguna otra parte, y te diriges directamente a~N~hacia donde \x9el, sin conocerlo IC, vas y le pides~N~que te meta a su faccion.");
	SetTextDrawTutorial(12, "~R~Qu\x9e es PG (PowerGaming)~B~?~N~~N~~W~Es forzar a tu personaje, para hacer cosas irrealistas.~N~~N~~B~Ejemplo: ~W~Si estas en la carcel, no puede poner~N~~P~/me rompe las rejas con sus poderes~N~~G~/Intentar derrumbar el ayuntamiento con una patada voladora.~N~~G~Continua...");
	SetTextDrawTutorial(13, "Tampoco se puede  manipular o forzar el personaje~N~de otro jugador para hacer una~N~accion imposible~N~y fuera de la realidad. ~N~~N~~B~Ejemplos: ~N~~P~/me mata a Javier_Peralta con su vision laser~N~~G~/Intentar enviar a Javier_Peralta a la luna de un golpe.");
	SetTextDrawTutorial(14, "~R~Qu\x9e es CJ(CarJaked)~B~?~N~~N~~W~-Es cuando se acerca una persona en un auto y pulsas~N~ \"Enter\" y lo sacas del auto solo porque si, sin razon alguna.");
	SetTextDrawTutorial(15, "~R~Qu\x9e es CK(CarKill)~B~?~N~~N~~W~Es cuando se mata a una persona atropellando o a-~N~plastandolo con un auto.");
	SetTextDrawTutorial(16, "~R~Qu\x9e es DB(Drive-By)~B~?~N~~N~~W~Es disparar desde el asiento del conductor de una~N~moto o de un auto (Generalmente tambi\x9en esta Prohi-~N~bido, debido a cuando se dispara desde el asiento~N~del conductor, el GTA SA utiliza el AUTO-AIM \"Mi-~N~ra Automatica\")");
	SetTextDrawTutorial(17, "~R~Qu\x9e es BJ (BunnyJump)~B~?~N~~N~~W~Es ir corriendo y saltando a al mismo tiempo para~N~avanzar mas rapido y no cansarse.~N~Esto es considerado como Anti-Rol.~N~~N~~N~~N~~N~~R~FIN DEL TUTORIAL DE REGLAS");
	//Es ir corriendo y saltando a al mismo tiempo para   Es ir corriendo y saltando a al mismo tiempo para        Es ir corriendo y saltando a al mismo tiempo para   Es ir corriendo y saltando a al mismo tiempo para

}
SetTextDrawTutorial(textdrawid, const text[])
{
	TexdrawsTutorial[textdrawid] = TextDrawCreateEx(300.0, 200.0, text);
	TextDrawColour(TexdrawsTutorial[textdrawid], 0xFFFEFFFF);
	TextDrawSetShadow(TexdrawsTutorial[textdrawid] ,1);
	TextDrawFont(TexdrawsTutorial[textdrawid], TEXT_DRAW_FONT_1);
	TextDrawAlignment(TexdrawsTutorial[textdrawid], TEXT_DRAW_ALIGN_RIGHT);
	TextDrawLetterSize(TexdrawsTutorial[textdrawid], 0.5, 1.3);
}

SetCameraPresent(playerid, point, Float:Porcent, Float:CameraX, Float:CameraY, Float:CameraZ, min, max)
{
	SetPlayerCameraLookAt(playerid, CamerasPresent[point][4], CamerasPresent[point][5], CamerasPresent[point][6]);
	new NextPoint;
	new PassPoint;
	Porcent += CamerasPresent[point][3];
	if ( point == max )
	{
		NextPoint = min;
	}
	else
	{
		NextPoint = point + 1;
	}
	/////////////////////////////// X POS
	if ( CamerasPresent[point][0] > CamerasPresent[NextPoint][0] )
	{
        CameraX -= ((CamerasPresent[point][0] - CamerasPresent[NextPoint][0]) * Porcent) / 100;
        if ( CameraX < CamerasPresent[NextPoint][0] )
        {
            PassPoint++;
        }
	}
	else
	{
        CameraX += ((CamerasPresent[NextPoint][0] - CamerasPresent[point][0]) * Porcent) / 100;
        if ( CameraX > CamerasPresent[NextPoint][0] )
        {
            PassPoint++;
        }
	}
	/////////////////////////////// Y POS
	if ( CamerasPresent[point][1] > CamerasPresent[NextPoint][1] )
	{
        CameraY -= ((CamerasPresent[point][1] - CamerasPresent[NextPoint][1]) * Porcent) / 100;
        if ( CameraY < CamerasPresent[NextPoint][1] )
        {
            PassPoint++;
        }
	}
	else
	{
        CameraY += ((CamerasPresent[NextPoint][1] - CamerasPresent[point][1]) * Porcent) / 100;
        if ( CameraY > CamerasPresent[NextPoint][1] )
        {
            PassPoint++;
        }
	}
	/////////////////////////////// Z POS
	if ( CamerasPresent[point][2] > CamerasPresent[NextPoint][2] )
	{
        CameraZ -= ((CamerasPresent[point][2] - CamerasPresent[NextPoint][2]) * Porcent) / 100;
        /*
		if ( CameraZ < CamerasPresent[NextPoint][2] )
        {
            PassPoint++;
        }
		*/
        PassPoint++;
	}
	else
	{
        CameraZ += ((CamerasPresent[NextPoint][2] - CamerasPresent[point][2]) * Porcent) / 100;
        /*
		if ( CameraZ > CamerasPresent[NextPoint][2] )
        {
            PassPoint++;
        }
		*/
        PassPoint++;
	}

	if ( PassPoint == 3 )
	{
	    point = NextPoint;
		CameraX = CamerasPresent[NextPoint][0];
		CameraY = CamerasPresent[NextPoint][1];
		CameraZ = CamerasPresent[NextPoint][2];
	    Porcent = 0.0;
	}
	SetPlayerCameraPos(playerid,CameraX,CameraY,CameraZ);
	PlayersDataOnline[playerid][TimerCamaraId] = SetTimerEx("SetCameraPresent", 20, false, "ddffffdd", playerid, point, Porcent, CameraX, CameraY, CameraZ, min, max);
}

function SetPlayerTutorial(playerid, tutorialid)
{
	if ( IsPlayerConnected(playerid) && PlayersData[playerid][InTutorial] )
	{
	    new TimeTutorial;
		switch( tutorialid )
		{
		    case 0: // Ayuntamiento
		    {
		        SetPlayerVirtualWorldEx(playerid, 0);
				SetPlayerPos(playerid, 1499.5968,-1663.2734,7.0682);

				SetCameraPresent(playerid, 15, 0, CamerasPresent[15][0], CamerasPresent[15][1], CamerasPresent[15][2], 15, 18);
                TimeTutorial = 15000;
			}
		    case 1: // Camioneros
		    {
   				KillTimer(PlayersDataOnline[playerid][TimerCamaraId]);
				SetCameraPresent(playerid, 19, 0, CamerasPresent[19][0], CamerasPresent[19][1], CamerasPresent[19][2], 19, 23);
				SetPlayerPos(playerid, -513.8900,-518.0787,25.5234);

                TimeTutorial = 15000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 2: // Taxis
		    {
   				KillTimer(PlayersDataOnline[playerid][TimerCamaraId]);
				SetCameraPresent(playerid, 24, 0, CamerasPresent[24][0], CamerasPresent[24][1], CamerasPresent[24][2], 24, 28);
				SetPlayerPos(playerid, 1772.3389,-1924.6448,3.4906);

                TimeTutorial = 15000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 3: // Taller
		    {
   				KillTimer(PlayersDataOnline[playerid][TimerCamaraId]);
				SetCameraPresent(playerid, 34, 0, CamerasPresent[34][0], CamerasPresent[34][1], CamerasPresent[34][2], 34, 38);
				SetPlayerPos(playerid, -2860.8513,468.8911,-20.2054);

                TimeTutorial = 15000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 4: // CNN
		    {
   				KillTimer(PlayersDataOnline[playerid][TimerCamaraId]);
				SetCameraPresent(playerid, 45, 0, CamerasPresent[45][0], CamerasPresent[45][1], CamerasPresent[45][2], 45, 51);
				SetPlayerPos(playerid, 757.7950,-1357.0710,7.3166);

                TimeTutorial = 15000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 5: // Detectives
		    {
   				KillTimer(PlayersDataOnline[playerid][TimerCamaraId]);
				SetCameraPresent(playerid, 39, 0, CamerasPresent[29][0], CamerasPresent[39][1], CamerasPresent[39][2], 39, 44);
				SetPlayerPos(playerid, -2039.1923,1271.1046,23.3799);

                TimeTutorial = 15000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 6: // Licencieros
		    {
   				KillTimer(PlayersDataOnline[playerid][TimerCamaraId]);
				SetCameraPresent(playerid, 29, 0, CamerasPresent[29][0], CamerasPresent[29][1], CamerasPresent[29][2], 29, 33);
				SetPlayerPos(playerid, -2028.0050,-114.0599,29.5306);

                TimeTutorial = 25000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 7: // Que es un server de Rol? ///////////////
		    {
		        SetPlayerVirtualWorldEx(playerid, playerid + 5);
				for (new AE = 0; AE <= 20; AE++)
				{
				    SendClientMessage(playerid, 0xFFF, " ");
				}
				TextDrawShowForPlayer(playerid, WideScreen);
				TextDrawShowForPlayer(playerid, WideScreen2);

			    SetPlayerPos(playerid, 154.1154,-1952.1362,51.3438);
			    SetPlayerFacingAngle(playerid, 350.7448);

   				KillTimer(PlayersDataOnline[playerid][TimerCamaraId]);
				SetCameraPresent(playerid, 0, 0, CamerasPresent[0][0], CamerasPresent[0][1], CamerasPresent[0][2], 0, 14);
                TimeTutorial = 20000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 8:
		    {
                TimeTutorial = 20000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 9:
		    {
                TimeTutorial = 20000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 10:
		    {
                TimeTutorial = 20000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 11:
		    {
                TimeTutorial = 20000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 12:
		    {
                TimeTutorial = 20000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 13:
		    {
                TimeTutorial = 20000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 14:
		    {
                TimeTutorial = 20000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 15:
		    {
                TimeTutorial = 20000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 16:
		    {
                TimeTutorial = 20000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
		    case 17:
		    {
                TimeTutorial = 20000;
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);
			}
			default:
			{
				PlayersDataOnline[playerid][StateDeath] = true;
				PlayersData[playerid][InTutorial] = false;
				PlayersDataOnline[playerid][IsNotSilenciado] = true;
				SetPlayerVirtualWorldEx(playerid, 0);
				UpdateSpawnPlayer(playerid);
				SpawnPlayerEx(playerid);
				TextDrawHideForPlayer(playerid, TexdrawsTutorial[tutorialid - 1]);

				TextDrawHideForPlayer(playerid, WideScreen);
				TextDrawHideForPlayer(playerid, WideScreen2);

				KillTimer(PlayersDataOnline[playerid][TimerCamaraId]);

				SendInfoMessage(playerid, 2, "0", "Ha finalizado el tutorial.");
				return false;
			}
		}
		TextDrawShowForPlayer(playerid, TexdrawsTutorial[tutorialid]);
		tutorialid++;
		PlayersDataOnline[playerid][TimerTutorialId] = SetTimerEx("SetPlayerTutorial", TimeTutorial, false, "dd", playerid, tutorialid);
		return false;
	}
	return true;
}