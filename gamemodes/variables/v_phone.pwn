enum Agenda
{
	NameC[MAX_AGENDA_NAME],
	NumberC,
	bool:IsBlackList
};
new AgendaData[MAX_PLAYERS][MAX_PLAYER_CONTACT][Agenda];

enum SMSEnum
{
    Number,
	SMSText[MAX_TEXT_SMS]
}
new SMS[MAX_PLAYERS][MAX_SMS_COUNT][SMSEnum];


enum CallPoliceEnum
{
    Number,
    NameC[MAX_PLAYER_NAME],
	ReasonC[MAX_TEXT_CHAT],
	TimeCall[3]
}
new CallPolice[MAX_CALL_POLICE_COUNT][2][CallPoliceEnum];

enum CallPublicsEnum
{
    Number,
	TimeCall[3],
	City
}
new CallPublics[MAX_CALL_POLICE_COUNT][3][CallPublicsEnum];

enum CallSAMDEnum
{
    Number,
	TimeCall[3],
	Type,
	City
}
new CallSAMD[2][MAX_CALL_POLICE_COUNT][CallSAMDEnum];

new TimerAd;

new MovilesObjects[11] = 
{
    330,
	18865,
	18866,
	18867,
	18868,
	18869,
	18870,
	18871,
	18872,
	18873,
	18874
};