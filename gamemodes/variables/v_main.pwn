new MySQL:dataBase;
new InvalidSting[2];
new Bonus;
new WeatherCurrent;
new ResetGM;
new ReasonReset[150];

new Text:Url_Web;
new Text:Url_WebShadow;

new MAX_TEXT_DRAW;

new CanalOOC;
new CanalDudas = true;

new SKIN_CIVILES[118];

enum CamerasLoginEnum
{
	Float:PlayerPosLogin[3],
	Float:CamerasPosLogin[3],
	Float:CamerasLookLogin[3]
}
new CamerasLogin[10][CamerasLoginEnum];
new MAX_CAMERAS_LOGIN;

enum JailType
{
	Float:PosX_Preso,
	Float:PosY_Preso,
	Float:PosZ_Preso,
	Float:PosZZ_Preso,
	Float:PosX_Liberado,
	Float:PosY_Liberado,
	Float:PosZ_Liberado,
	Float:PosZZ_Liberado,
	Interior_Preso,
	Interior_Liberado,
	WorldLiberado
};
new JailsType[3][JailType];

new Stations[41][2][60] =
{
    {""SERVER_NAME" - Radio Oficial{"COLOR_ROSA"}\t\t(Variado)",	""},
	{"TruckersFM{"COLOR_ROSA"}\t\t\t\t(Variado)",					"http://live.truckers.fm/"},
	{"TruckersSimFM{"COLOR_ROSA"}\t\t\t(Variado)", 				"http://live.trucksim.fm/"},
	{"DubPlateFM{"COLOR_ROSA"}\t\t\t\t(Dub y Bass)", 				"http://sc2.dubplate.fm/radio/8000/dubandbass/uhifi?hi.mp3"},
	{"DubPlateFM{"COLOR_ROSA"}\t\t\t\t(Urban Boogie)", 			"http://sc2.dubplate.fm/radio/8010/urbanboogie/uhifi?hi.mp3"},
	{"DubPlateFM{"COLOR_ROSA"}\t\t\t\t(5 Pointz)", 				"http://sc2.dubplate.fm/radio/8020/hiphop/uhifi?hi.mp3"},
	{"DubPlateFM{"COLOR_ROSA"}\t\t\t\t(Drum and Bass)", 			"http://sc2.dubplate.fm/radio/8030/dnb/uhifi?hi.mp3"},
	{"SomaFM{"COLOR_ROSA"}\t\t\t(Underground 80s)", 				"http://ice2.somafm.com/u80s-128-mp3"},
	{"SomaFM{"COLOR_ROSA"}\t\t\t\t(Black Rock FM)", 				"http://ice6.somafm.com/brfm-128-mp3"},
	{"Ranchera 106.5FM{"COLOR_ROSA"}\t\t(Ranchera)",				"http://sp4.colombiatelecom.com.co/8024/stream"},
	
	{"El mero mero radio{"COLOR_ROSA"}\t\t\t(Reggaeton)", 		"http://listen.radionomy.com/el-mero-mero-radio"},
	{"Fiesta Mexicana{"COLOR_ROSA"}\t\t\t(Canciones Mexicanas)", 	"http://174.123.136.130:8888/"},
	{"Renovacion y Evolucion{"COLOR_ROSA"}\t\t(Metal)",		 	"http://65.254.42.234:15060/"},
	{"Rockarolla{"COLOR_ROSA"}\t\t\t\t(Rock)",		 			"http://shout.streamwithq.gr:4042/"},
	{"Z Rock & Pop{"COLOR_ROSA"}\t\t\t(Rock and Pop)",		 	"http://servistream.pe:8116/"},
	{"Hard Base FM{"COLOR_ROSA"}\t\t\t(Hardbase)",		 		"http://listen.hardbase.fm/tunein-dsl-pls"},
	{"Dubstep{"COLOR_ROSA"}\t\t\t\t(Dubstep)",		 			"http://cp.internet-radio.org.uk:15634/"},
	{"Top Hits Music{"COLOR_ROSA"}\t\t\t(Pop)",		 			"http://scfire-mtc-aa01.stream.aol.com:80/stream/1014"},
	{"La Radio Tropical{"COLOR_ROSA"}\t\t\t(Cumbia)",		 		"http://67.205.76.173:8136"},
	{"Max Dance{"COLOR_ROSA"}\t\t\t\t(House Variado)",		 	"http://cp.internet-radio.org.uk:15114/"},
	{"The Hot 100{"COLOR_ROSA"}\t\t\t(Variado)",		 			"http://cp2.internet-radio.org.uk:30115/"},
	{"Big Radio Warm{"COLOR_ROSA"}\t\t\t(Variado)",		 		"http://74.86.211.35/101point6"},
	{"Grunge FM{"COLOR_ROSA"}\t\t\t\t(Grunge)",		 			"http://livestream2.bigrradio.com/grungefm"},
	{"Energy FM{"COLOR_ROSA"}\t\t\t\t(Electronica)",		 		"http://cp.internet-radio.org.uk:15614/"},
	{"XTraFM{"COLOR_ROSA"}\t\t\t\t(Variado)",		 				"http://stream.xtra.fm:8006/"},
	{"Europa FM Gipuzkoa{"COLOR_ROSA"}\t\t(Rock/Pop)",		 	"http://stream.europafmgipuzkoa.com:80/"},
	{"The Buzz{"COLOR_ROSA"}\t\t\t\t(Alternative & Grunge)",		"http://scfire-mtc-aa03.stream.aol.com:80/stream/1022"},
	{"ChroniX Agression{"COLOR_ROSA"}\t\t\t(Metal)",		 		"http://scfire-mtc-aa05.stream.aol.com:80/stream/1039"},
	{"S K Y FM{"COLOR_ROSA"}\t\t\t\t(Salsa)",		 				"http://205.188.215.231:8010"},
	{"M2 Sunshine{"COLOR_ROSA"}\t\t\t(Reggae & Dance Hall)",		"http://91.121.120.152:8000"},
	{"RaggaKings{"COLOR_ROSA"}\t\t\t(Reggaeton)",		 			"http://205.234.220.66:7970"},
	{"STRM Soundtrack{"COLOR_ROSA"}\t\t\t(Soundtrack)",		 	"http://83.145.128.37:9000"},
	{"Country 101 FM{"COLOR_ROSA"}\t\t\t(Country)",		 		"http://uplink.181.fm:8018/"},
	{"Old School 101 FM{"COLOR_ROSA"}\t\t\t(HipHop /Rnb)",		"http://uplink.181.fm:8068/"},
	{"The Beatles 101 FM{"COLOR_ROSA"}\t\t(Rock)",		 		"http://uplink.181.fm:8062/"},
	{"Real Punk Radio{"COLOR_ROSA"}\t\t\t(Punk)",		 			"http://174.122.26.45:80/"},
	{"Friends or Enemies{"COLOR_ROSA"}\t\t(Punk)",		 		"http://s1.voscast.com:7364/"},
	{"Panda Show{"COLOR_ROSA"}\t\t\t(Humor)",		 				"http://208.85.242.77:80"},
	{"Dnb Real Radio{"COLOR_ROSA"}\t\t\t(Drum and bass)",		 	"http://deppy.dnbradio.com:8016"},
	{"Estudio 92{"COLOR_ROSA"}\t\t\t\t(Variado)",		 			"http://94.23.67.172:9112/"},
	{"Panamericana{"COLOR_ROSA"}\t\t\t(Salsa)",		 			"http://76.10.222.35:8300/"}

//	{"Soundtrack{"COLOR_ROSA"}\t\t\t\t(Soundtrack)",		 	"Soundtrack"},
};


#include "variables/v_vehicles.pwn"
#include "variables/v_users.pwn"
#include "variables/v_houses.pwn"

#include "variables/v_bank.pwn"
#include "variables/v_robos.pwn"
#include "variables/v_impuestos.pwn"
#include "variables/v_tutorial.pwn"
#include "variables/v_races.pwn"
#include "variables/v_facciones.pwn"
#include "variables/v_cartera.pwn"
#include "variables/v_bombs.pwn"
#include "variables/v_bolsa.pwn"
#include "variables/v_bolsillo.pwn"
#include "variables/v_phone.pwn"
#include "variables/v_gasolineras.pwn"
#include "variables/v_business.pwn"
#include "variables/v_jobs.pwn"
#include "variables/v_pickups.pwn"
#include "variables/v_traffic_items.pwn"
#include "variables/v_teles.pwn"
#include "variables/v_mapper.pwn"
#include "variables/v_fires.pwn"
#include "variables/v_deathmatch.pwn"
#include "variables/v_camaras_vigilancia.pwn"
#include "variables/v_tunning.pwn"
#include "variables/v_player_attachments.pwn"
#include "variables/v_player_fightstyle.pwn"
#include "variables/facebook.pwn"