// comandos de audio stream (mp3)

OnPlayerCommandAudioStream(playerid, const cmdtext[])
{
	// /playmp3 [url]
	if (strfind(cmdtext, "/playmp3 ", true) == 0)
	{
		if (cmdtext[9] == EOS)
			return Error(playerid, "Uso: /playmp3 [url]");

		new url[256];
		strmid(url, cmdtext, 9, strlen(cmdtext), 256);

		if (strfind(url, "http", true) != 0)
			return Error(playerid, "La URL debe comenzar con http:// o https://");

		PlayMP3ToNearby(playerid, url);
		SendInfoMessage(playerid, 2, "0", "Reproduciendo MP3 a jugadores cercanos.");
		return 1;
	}
	// /pararmp3
	else if (strcmp("/pararmp3", cmdtext, true) == 0 && cmdtext[9] == EOS)
	{
		if (!PlayerPlayingMP3[playerid])
			return Error(playerid, "No estas reproduciendo ningun MP3.");

		StopMP3Nearby(playerid);
		SendInfoMessage(playerid, 2, "0", "MP3 detenido para jugadores cercanos.");
		return 1;
	}
	return 0;
}
