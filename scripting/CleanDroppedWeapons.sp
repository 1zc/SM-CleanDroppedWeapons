// I n f r a  :(
#include <sdkhooks>
#include <sdktools>
#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
	name = "Clean Dropped Weapons", 
	author = "Infra", 
	description = "A simple plugin to clean up weapons when they are dropped. Has functionality to prevent players from picking dropped weapons up.", 
	version = "1.0", 
	url = "https://github.com/1zc"
};

int weaponOwners[4096] = { 0, ... };
ConVar g_cvCleanup, g_cvPickupPrevention;

public void OnPluginStart()
{
    g_cvCleanup = CreateConVar("cdw_cleanup_enabled", "1", "Clean-up weapons when they are dropped. 1 = Enabled, 0 = Disabled", _, true, 0.0, true, 1.0);
    g_cvPickupPrevention = CreateConVar("cdw_prevent_pickups", "1", "0 = Allow all weapon pickups, 1 = Prevent weapon pickups if the weapon doesn't belong to the player.", _, true, 0.0, true, 1.0);

    AutoExecConfig(true, "CleanDroppedWeapons");
}

public void OnMapEnd()
{
    // Reset weapon owners array
    for (int i = 0; i < 4096; i++)
        weaponOwners[i] = 0;
}

public void OnClientPostAdminCheck(int client)
{
    if (g_cvCleanup.BoolValue == true)
        SDKHook(client, SDKHook_WeaponDropPost, Hook_OnWeaponDropPost);

    if (g_cvPickupPrevention.BoolValue == true)
        SDKHook(client, SDKHook_WeaponCanUse, Hook_OnWeaponCanUse);
}

public void Hook_OnWeaponDropPost(int client, int weapon)
{
    // Ensure weapon index isn't -1 (this usuallys happens on team switch)
    if (weapon == -1)
        return; 
        
    // Get client userID
    client = GetClientUserId(client);

    // Temporarily assign the weapon's owner if it was not dropped by server.
    // This should allow plugins a very small (but sufficient) window for the server to give weapons to players, 
    // either by plugins or by admins using the "give" command.
    if (client != 0)
        weaponOwners[weapon] = client;

    // Kill the weapon and reset owner index
    AcceptEntityInput(weapon, "Kill");
    weaponOwners[weapon] = 0;
} 

public Action Hook_OnWeaponCanUse(int client, int weapon)
{
    client = GetClientUserId(client);

    // Let bots pick up whatever they want
    if (IsClientConnected(client) && IsFakeClient(client))
    {
        return Plugin_Continue;
    }

    // Check if weapon was given by Server or if it belongs to the client.
    // Allow pickup if so.
    if (weaponOwners[weapon] == 0 || weaponOwners[weapon] == client)
    {
        weaponOwners[weapon] = client;
        return Plugin_Continue;
    }

    // Deny pick up.
    return Plugin_Handled;
} 

