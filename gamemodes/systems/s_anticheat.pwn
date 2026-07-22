UpdateArmourAndArmour(playerid, Float:Health, Float:Armour)
{
	if ( PlayersDataOnline[playerid][VidaOn] >= Health && PlayersDataOnline[playerid][ChalecoOn] >= Armour )
	{
	    PlayersDataOnline[playerid][VidaOn] = Health;
	    PlayersDataOnline[playerid][ChalecoOn] = Armour;
	    return true;
	}
	else
	{
        SetPlayerHealth(playerid, PlayersDataOnline[playerid][VidaOn]);
        SetPlayerArmour(playerid, PlayersDataOnline[playerid][ChalecoOn]);
	    return false;
	}
}

IsCheatMoney(playerid, lastmoney)
{
	if ( lastmoney > PlayersData[playerid][Dinero] )
	{
		new MsgAviso[MAX_TEXT_CHAT];
	    format(MsgAviso, sizeof(MsgAviso), "%s AntiCheat-Money - %s[%i] posible cheat de money. Datos: Dinero encima: $%i Dinero AntiCheat: $%i.", LOGO_STAFF, PlayersDataOnline[playerid][NameOnline], playerid, lastmoney, PlayersData[playerid][Dinero]);
	    MsgCheatsReportsToAdmins(MsgAviso);
    }
}
CheckWeapondCheat(playerid)
{
	if ( PlayersDataOnline[playerid][StateWeaponPass] <= gettime() && !PlayersDataOnline[playerid][ModeDM] )
	{
		new WEAPON:WeapoindID, AmmoQl;
		for (new i = 0; i < 13; i++)
		{
			GetPlayerWeaponData(playerid, WEAPON_SLOT:i, WeapoindID, AmmoQl);
			if ( PlayersData[playerid][WeaponS][i] == WeapoindID && PlayersData[playerid][AmmoS][i] >= AmmoQl || AmmoQl == 0)
			{
			 	//   printf("%i - %i || %i - %i", PlayersData[playerid][WeaponS][i], PlayersData[playerid][AmmoS][i], WeapoindID, AmmoQl);
			    PlayersData[playerid][WeaponS][i] = WeapoindID;
	            PlayersData[playerid][AmmoS][i] = AmmoQl;
			}
			else
			{
				GivePlayerWeaponReturn(playerid);
				PlayersDataOnline[playerid][CountCheat]++;
				if ( PlayersDataOnline[playerid][CountCheat] % 100 == 0 )
				{
					new MsgAvisoWeapon[MAX_TEXT_CHAT];
				    format(MsgAvisoWeapon, sizeof(MsgAvisoWeapon), "%s AntiCheat-Weapon - %s[%i] posible cheat de Weapon.", LOGO_STAFF, PlayersDataOnline[playerid][NameOnline], playerid);
					MsgCheatsReportsToAdmins(MsgAvisoWeapon);
				    printf("%s", MsgAvisoWeapon);
			    }
				return false;
			}
		}
	}
	return true;
}
ShowPlayerDialogEx(playerid, dialogid, DIALOG_STYLE:style, const caption[], const info[], const button1[], const button2[])
{
    PlayersDataOnline[playerid][CurrentDialog] = dialogid;
	ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
}