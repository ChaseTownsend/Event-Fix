#pragma newdecls required

// Includes
#include <sourcemod>
#include <dhooks>

// Defines
#define VERSION "0.0.1"

// Dhooks
DynamicDetour g_hDetourCreateEvent;

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

public void OnPluginStart()
{
	LoadGameData();

	if (g_hDetourCreateEvent)
	{
		CreateEvent("give_me_my_cgameeventmanager_pointer", true);
	}
}

void LoadGamedata()
{
	g_hDetourCreateEvent = DynamicDetour.FromConf(gamedata, "CGameEventManager::CreateEvent");
	if (!g_hDetourCreateEvent || !g_hDetourCreateEvent.Enable(Hook_Pre, Detour_CreateEvent))
	{
		LogError("[DHooks] Failed to create detour for CGameEventManager::CreateEvent");
	}
}
public void OnMapStart()
{
    if (g_aGameEventManager && g_hSDKLoadEvents)
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