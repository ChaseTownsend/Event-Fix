#pragma newdecls required

// Includes
#include <sourcemod>
#include <dhooks>

// Defines
#define VERSION "1.0.0"

// Dhooks
DynamicDetour g_hDetourCreateEvent;
//
Address g_aGameEventManager;
Handle g_hSDKLoadEvents

// Plugin Info
public Plugin myinfo =
{
	name		=	"Damage Events Fix",
	author		=	"The FatCat",
	description	=	"Fixes the player_hurt and npc_hurt events to use a long(32 bits) instead of a short(16 bits)",
	version		=	VERSION,
	url			=	"https://github.com/ChaseTownsend/Event-Fix",
};


void LoadGameData()
{
	GameData gamedata = new GameData("events");
	if (!gamedata)
	{
		SetFailState("[SDK] Failed to locate gamedata file \"events.txt\"");
	}
	
	g_hDetourCreateEvent = DynamicDetour.FromConf(gamedata, "CGameEventManager::CreateEvent");
	if (!g_hDetourCreateEvent || !g_hDetourCreateEvent.Enable(Hook_Pre, Detour_CreateEvent))
	{
		LogError("[DHooks] Failed to create detour for CGameEventManager::CreateEvent");
	}

	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(gamedata, SDKConf_Virtual, "CGameEventManager::LoadEventsFromFile");
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
	g_hSDKLoadEvents = EndPrepSDKCall();
	if (!g_hSDKLoadEvents)
	{
		LogError("[SDK] Failed to create call to CGameEventManager::LoadEventsFromFile");
	}
}


public void OnPluginStart()
{
	LoadGameData();

	if (g_hDetourCreateEvent)
	{
		CreateEvent("give_me_my_cgameeventmanager_pointer", true);
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

public MRESReturn Detour_CreateEvent(Address eventManager, DHookReturn returnVal, DHookParam params)
{
	g_aGameEventManager = eventManager;
	return MRES_Ignored;
}