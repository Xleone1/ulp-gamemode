// logica core de audio stream (mp3)

#define MP3_RANGE (30.0)

new bool:PlayerPlayingMP3[MAX_PLAYERS];
new PlayerMP3URL[MAX_PLAYERS][256];

PlayMP3ToNearby(playerid, const url[])
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	PlayerPlayingMP3[playerid] = true;
	strmid(PlayerMP3URL[playerid], url, 0, strlen(url), 256);

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (i == playerid) continue;
		if (!IsPlayerConnected(i)) continue;
		if (PlayersDataOnline[i][State] != 3) continue;

		if (IsPlayerInRangeOfPoint(i, MP3_RANGE, x, y, z))
		{
			PlayAudioStreamForPlayer(i, url);
		}
	}
	return 1;
}

StopMP3Nearby(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	PlayerPlayingMP3[playerid] = false;
	PlayerMP3URL[playerid][0] = EOS;

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (i == playerid) continue;
		if (!IsPlayerConnected(i)) continue;
		if (PlayersDataOnline[i][State] != 3) continue;

		if (IsPlayerInRangeOfPoint(i, MP3_RANGE, x, y, z))
		{
			StopAudioStreamForPlayer(i);
		}
	}
	return 1;
}
