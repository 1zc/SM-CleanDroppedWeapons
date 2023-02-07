# SM-CleanDroppedWeapons
A simple plugin to clean up weapons when they are dropped. Has functionality to prevent players from picking dropped weapons up. Made & tested for CS:GO, and great for game-modes like Surf where randomly picking up weapons that other players throw can be rather annoying.

## Configuration
Configuration can be done in the `CleanDroppedWeapons.cfg` file located in the `cfg/sourcemod` directory.

- `cdw_cleanup_enabled`: Clean-up weapons when they are dropped. 
    - 0 = Disabled
    - 1 = Enabled
    
- `cdw_prevent_pickups`: Prevent weapons from being picked up by players.
    - 0 = Allow all weapon pickups
    - 1 = Prevent weapon pickups if the weapon doesn't belong to the player
