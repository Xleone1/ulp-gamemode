SendStaffOutput(playerid, type, const message[]) 
{
	new MsgInfo[MAX_TEXT_CHAT];
	switch ( type )
	{
	    // Helper
	    case 0:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "%s", message);
		}
		// Soporte
		case 1:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "%s", message);
		}
		// Moderador General
		case 2:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "%s", message);
		}
		// Co-Admin
		case 3:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "%s", message);
		}
		// Admin
		case 4:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "%s", message);
		}
		// GameMaster
		case 5:
	    {
	        format(MsgInfo, sizeof(MsgInfo), "%s", message);
		}
	}
	return SendClientMessage(playerid, AdminsRangosColors[type], MsgInfo);
}