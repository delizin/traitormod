## Mod Overview
This is a heavily modified version of Evilfactory's Traitermod. It is our attempt at creating a fun and balanced traitor mode in a multiplayer campaign for Barotrauma.

### Some Key Changes from evilfactory/traitormod
- Designed to work primarily multiplayer campaigns
- Additional/modified roles and traitor objectives
- Persistent wallets for players
- No skill penalty on respawn to minimize long term gameplay impact of traitors
- Traitor objectives are meant to minimally disruptive to long term progress and enjoyment of the game, while still creating a quiet distrust and suspicion of your crew.

## How to Use
### Install Requirements
- *LuaCs for Barotrauma*: [https://evilfactory.github.io/LuaCsForBarotrauma/lua-docs/](https://evilfactory.github.io/LuaCsForBarotrauma/lua-docs/manual/installing-lua-for-barotrauma-manually/)

### Install Mod on Dedicated Servers
This is just a server-side mod and does not need to be installed by clients.
1. Download this mod to the server.
2. Add the mod to your config_player.xml file, located in your Barotrauma directly with the Barotrauma DedicatedServer executable

On Linux, it will look something like this:
```  
<contentpackages>
    <!--Vanilla-->
    <corepackage
      path="Content/ContentPackages/Vanilla.xml" />
    <regularpackages>
      <package path="/home/<username>/.local/share/Daedalic Entertainment GmbH/Barotrauma/WorkshopMods/Installed/traitormod-dev/filelist.xml" />
    </regularpackages>
</contentpackages>
  ```
3. Mod will announce that is working during server startup.
4. Set your desired config settings in config.lua (See info below for the easily configurable options).

## Chat Commands

### General Commands
- `!help`: Displays a list of general commands available to all players.
- `!helpadmin`: Displays a list of admin commands.
- `!helptraitor`: Displays a list of traitor-specific commands.
- `!version`: Shows the current version of Evil Factory's Traitor Mod.
- `!point` or `!points`: Displays your current points balance.
- `!info`: Displays the welcome message.
- `!suicide`, `!kill`, or `!death`: Kills your character if alive and not handcuffed or knocked down.
- `!locatesub` or `!locatesubmarine`: Provides the distance and direction of the main submarine from the player. Only works for monster characters. 
- `!droppoints <amount>`: Drops specified points from the player's inventory.

### Role Management Commands
- `!toggletraitor`: Toggles your traitor status on or off (if the mod allows optional traitors).
- `!role` or `!traitor`: Shows your special role, if any. You need to be alive to use this command.
- `!roles` or `!traitors`: (Admin only) Displays a list of all players with special roles.
- `!assignrole <client> <role>`: Assigns a role to a specified player. Usage: `!assignrole <client> <role>`. Requires admin permissions.
- `!addobj <client> <objective>`: Adds an objective to a specified player who already has a role assigned. Usage: `!addobj <client> <objective>`. Requires admin permissions.

### Admin Commands
- `!traitoralive`: Indicates whether any traitors are still alive.
- `!alive`: Displays a list of all players, indicating if they are dead or alive.
- `!roundinfo`: Shows information about the current round or the last round if no round is in progress.
- `!allpoint`: Displays the points and weight of all players.
- `!addpoint <client>`: Adds points to a specific player or all players.
- `!addlife <client>`: Adds lives to a specific player or all players.
- `!void <client>`: Sends a player's character to the void.
- `!unvoid <client>`: Removes a player's character from the void and returns them to their previous position.
- `!revive <client>`: Revives the specified player, or the admin themselves if no player is specified.
- `!ongoingevents`: Displays ongoing events in the current game.
- `!triggerevent <event>`: Triggers a specified event in the game.



## Configuration
Configuration settings are located in traitormod/config/config.lua. 

### Config Settings
### USER FEEDBACK
- `config.Language` : The language of the game. Valid options: "English"
- `config.SendWelcomeMessage`: Whether to send a welcome message to new players. Valid options: true or false
- `config.ChatMessageType`: The color of the message in chat. Valid options: ChatMessageType.Error (red), ChatMessageType.Private (green), ChatMessageType.Dead (blue), ChatMessageType.Radio (yellow)

### GAMEPLAY
- `config.Codewords`: A list of codewords used for communication between players. Valid options: a list of strings
- `config.AmountCodeWords`: The number of codewords each player receives. Valid options: a positive integer
- `config.OptionalTraitors`: Whether players can use a command to toggle their traitor status. Valid options: true or false
- `config.RagdollOnDisconnect`: Whether to leave a ragdoll of the player when they disconnect. Valid options: true or false
- `config.EnableControlHusk`: Whether to allow players to control their husked character after death. Valid options: true or false
- `config.TraitorChance`: The chance that a player is a traitor. Valid options: a decimal between 0 and 1
- `config.OverrideRespawnSubmarine`: Whether to override the game's respawn shuttle with a submarine. Valid options: true or false
- `config.RespawnSubmarineFile`: The file path of the submarine used for respawn. Valid options: a string representing a file path
- `config.RespawnText`: The message displayed when a player respawns. Valid options: a string
- `config.RespawnTeam`: The team the player respawns on. Valid options: CharacterTeamType.Team1 or CharacterTeamType.Team2
- `config.PermanentPoints`: Whether to store points and lives in a file. Valid options: true or false
- `config.RemotePoints`: The IP address of the remote server storing points and lives. Valid options: a string representing an IP address or nil
- `config.RemoteServerAuth`: The authentication credentials for the remote server. Valid options: a table containing the authentication credentials or an empty table
- `config.PermanentStatistics`: Whether to store statistics in a file. Valid options: true or false
- `config.MaxLives`: The maximum number of lives a player can have. Valid options: a positive integer
- `config.MinRoundTimeToLooseLives`: The minimum amount of time a player must be alive before losing a life. Valid options: a positive integer
- `config.RespawnedPlayersDontLooseLives`: Whether players who respawn do not lose a life. Valid options: true or false
- `config.MaxExperienceFromPoints`: The maximum amount of experience a player can gain from stored points. Valid options: a positive integer or nil
- `config.RemoveSkillBooks`: Whether to remove skill books from the game. Valid options: true or false
- `config.NerfSwords`: Whether to nerf swords. Valid options: true or false
- `config.EnablePointExp`: Whether to enable setting experience to point value at match start. Valid options: true or false
- `config.GlobalExperienceModifier`: The global experience modifier. Valid options: a decimal between 0 and 1
- `config.FreeExperience`: The amount of temporary experience given every ExperienceTimer seconds. Valid options: a positive integer
- `config.ExperienceTimer`: A positive integer that sets the interval in seconds at which temporary experience is given to players. Default value is 120.
- `config.PointsGainedFromSkill`: A table that sets the amount of points given to a player for using certain skills. Valid keys are "medical", "weapons", "mechanical", "electrical", and "helm". Default values are 30, 20, 19, 19, and 9, respectively.
- `config.PointsLostAfterNoLives`: A function that takes an integer as input and returns a float that determines the percentage of points lost after a player runs out of lives. Default function returns x * 0.75.
- `config.AmountExperienceWithPoints`: A function that takes an integer as input and returns the amount of experience gained from the given amount of points. Default function returns 0.
- `config.AmountWeightWithPoints`: A function that takes an integer as input and returns the weight based on the logarithm of the given amount of points. Default function returns math.log(x + 10).
- `config.GamemodeConfig`: A table that sets the configuration for the different gamemodes available in the game.
- `config.RoleConfig`: A table that sets the configuration for the different roles available in the game.
- `config.ObjectiveConfig`: A table that sets the configuration for the different objectives available in the game.
- `config.RandomEventConfig`: A table that sets the configuration for the random events that can occur during the game.
- `config.PointShopConfig`: A table that sets the configuration for the point shop in the game.
- `config.GhostRoleConfig`: A table that sets the configuration for the ghost roles in the game. 

## Mod development resources
- *Barotrauma Source*: https://github.com/Regalis11/Barotrauma
- *Lua for Barotrauma Docs*: https://evilfactory.github.io/LuaCsForBarotrauma/lua-docs/
- *Original Traitormod*: https://github.com/evilfactory/traitormod
