#pragma newdecls required

// Includes
#include <sourcemod>
#include <sdktools>

// Defines
#define VERSION "0.0.1"

Address g_aGameEventManager;
Handle g_hSDKLoadEvents

public Plugin myinfo =
{
	name		=	"(PRE-RELEASE) Damage Events Fix",
	author		=	"The FatCat",
	description	=	"Fixes the player_hurt and npc_hurt events to use a long(32 bits) instead of a short(16 bits)",
	version		=	VERSION,
	url			=	"https://github.com/ChaseTownsend/Event-Fix",
};

public void OnMapStart()
{
    if (g_aGameEventManager && g_hSDKLoadEvents) // Where does this get set?
	{
		char eventsFile[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, eventsFile, sizeof(eventsFile), "data/events/events.res");
		LogMessage("Loading custom events file '%s'", eventsFile);
		if (SDKCall(g_hSDKLoadEvents, g_aGameEventManager, eventsFile))
		{
			LogMessage("Success!");
		}
		else
		{
			LogError("FAILED to load custom events file '%s'", eventsFile);
		}
	}
	else
	{
		LogError("FAILED to load custom events file (Missing Gamedata!)");
	}
}