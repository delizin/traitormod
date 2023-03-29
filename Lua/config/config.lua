local config = {}
config.DebugLogs = true
config.DebugMode = false

----- USER FEEDBACK -----
config.Language = "English"
config.SendWelcomeMessage = true
config.ChatMessageType = ChatMessageType.Private    -- Error = red | Private = green | Dead = blue | Radio = yellow

----- GAMEPLAY -----
config.Codewords = {
    "hull", "tobacco", "nonsense", "fish", "clown", "quartermaster", "fast", "possibility",
	"thalamus", "hungry", "water", "looks", "renegade", "angry", "green", "sink", "rubber",
	"mask", "sweet", "ice", "charybdis", "cult", "secret", "frequency",
	"husk", "rust", "ruins", "red", "boat", "cats", "rats", "blast",
	"tire", "trunk", "weapons", "threshers", "cargo", "method", "monkey",
    "donkey balls", "ubiquitous", "mendacious", "polyglottal"
}

config.AmountCodeWords = 2

config.OptionalTraitors = false        -- players can use !toggletraitor
config.RagdollOnDisconnect = false
config.EnableControlHusk = false     -- EXPERIMENTAL: enable to control husked character after death

config.TraitorChance = 0.15

-- This overrides the game's respawn shuttle, and uses it as a submarine injector, to spawn submarines in game easily. Respawn should still work as expected, but the shuttle submarine file needs to be manually added here.
-- Note: If this is disabled, traitormod will disable all functions related to submarine spawning.
-- Warning: Only respawn shuttles will be used, the option to spawn people directly into the submarine doesnt work.
config.OverrideRespawnSubmarine = false
config.RespawnSubmarineFile = "Content/Submarines/Selkie.sub"
config.RespawnText = "Respawn in %s seconds."
config.RespawnTeam = CharacterTeamType.Team1

----- POINTS + LIVES -----
config.PermanentPoints = true      -- sets if points and lives will be stored in and loaded from a file
config.RemotePoints = nil
config.RemoteServerAuth = {}
config.PermanentStatistics = false  -- sets if statistics be stored in and loaded from a file
config.MaxLives = 5
config.MinRoundTimeToLooseLives = 180
config.RespawnedPlayersDontLooseLives = false
config.MaxExperienceFromPoints = 0     -- if not nil, this amount is the maximum experience players gain from stored points (30k = lvl 10 | 38400 = lvl 12)
config.RemoveSkillBooks = false
config.NerfSwords = false
config.EnablePointExp = false    -- Enables Setting Exp to Point Value at Match Start

config.GlobalExperienceModifier = 0.5
config.FreeExperience = 0         -- temporary experience given every ExperienceTimer seconds
config.ExperienceTimer = 120

config.PointsGainedFromSkill = {
    medical = 30,
    weapons = 20,
    mechanical = 19,
    electrical = 19,
    helm = 9,
}


config.PointsLostAfterNoLives = function (x)
    return x * 0.75
end

config.AmountExperienceWithPoints = function (x)
    if config.EnablePointExp then
    	return x
    else
	return 0
    end
end

-- Give weight based on the logarithm of experience
-- 100 experience = 4 chance
-- 1000 experience = 6 chance
config.AmountWeightWithPoints = function (x)
    return math.log(x + 10) -- add 1 because log of 0 is -infinity
end

----- GAMEMODE -----
config.GamemodeConfig = {
    Secret = {
        EndOnComplete = true,           -- end round everyone but traitors are dead
        EnableRandomEvents = false,
        EndGameDelaySeconds = 15,

        TraitorSelectDelayMin = 120,
        TraitorSelectDelayMax = 150,

        PointsGainedFromHandcuffedTraitors = 1000,
        DistanceToEndOutpostRequired = 8000,

        MissionPoints = {
            Salvage = 1100,
            Monster = 1050,
            Cargo = 1000,
            Beacon = 1200,
            Nest = 1700,
            Mineral = 1000,
            Combat = 1400,
            AbandonedOutpost = 500,
            Escort = 1200,
            Pirate = 1300,
            GoTo = 1000,
            ScanAlienRuins = 1600,
            ClearAlienRuins = 2000,
            Default = 1000,
        },
        PointsGainedFromCrewMissionsCompleted = 0,
        LivesGainedFromCrewMissionsCompleted = 0,

        TraitorTypeChance = {
            Traitor = 80, -- Traitors have 80% chance of being a normal traitor
            Cultist = 20,
        },

        AmountTraitors = function (amountPlayers)
            config.TestMode = false -- ??
            if config.DebugMode then return 1 end

            if amountPlayers > 12 then
                if .5 > math.random() then
                    return 2 
                else
                    return 1
                end
            end
            if amountPlayers > 5 then return 1 end

            print("Not enough players to start traitor mode.")
            return 0
        end,

        -- 0 = 0% chance
        -- 1 = 100% chance
        TraitorFilter = function (client)
            if client.Character.TeamID ~= CharacterTeamType.Team1 then return 0 end
            if not client.Character.IsHuman then return 0 end
            if client.Character.HasJob("captain") then return 0.5 end
            if client.Character.HasJob("securityofficer") then return 0.5 end
            if client.Character.HasJob("medicaldoctor") then return 0.5 end

            return 1
        end
    },

    PvP = {
        EnableRandomEvents = false, -- most events are coded to only affect the main submarine
        WinningPoints = 1000,
        WinningDeadPoints = 500,
        MinimumPlayersForPoints = 4,
        ShowSonar = true,
        IdCardAllAccess = true,
        CrossTeamCommunication = true,
    },

    -- Campaign Gamemode Settings
    Campaign = {
        EndOnComplete = true,           -- end round everyone but traitors are dead
        EnableRandomEvents = false,
        EndGameDelaySeconds = 15,

        TraitorSelectDelayMin = 120,
        TraitorSelectDelayMax = 150,

        PointsGainedFromHandcuffedTraitors = 1000,
        DistanceToEndOutpostRequired = 8000,

        MissionPoints = {
            Salvage = 1100,
            Monster = 1050,
            Cargo = 1000,
            Beacon = 1200,
            Nest = 1700,
            Mineral = 1000,
            Combat = 1400,
            AbandonedOutpost = 500,
            Escort = 1200,
            Pirate = 1300,
            GoTo = 1000,
            ScanAlienRuins = 1600,
            ClearAlienRuins = 2000,
            Default = 1000,
        },
        PointsGainedFromCrewMissionsCompleted = 0,
        LivesGainedFromCrewMissionsCompleted = 0,

        TraitorTypeChance = {
            Traitor = 80, -- Traitors have 80% chance of being a normal traitor
            Cultist = 20,
        },

        -- This is the maximum number of traitors that can be in a round. Actual number is rolled each round.
        AmountTraitors = function (amountPlayers)
            config.TestMode = false -- ??
            if config.DebugMode then return 1 end
            if amountPlayers > 12 then return 2 end
            if amountPlayers > 5 then return 1 end
            print("Not enough players to start traitor mode.")
            return 0
        end,

        -- 0 = 0% chance
        -- 1 = 100% chance
        TraitorFilter = function (client)
            if client.Character.TeamID ~= CharacterTeamType.Team1 then return 0 end
            if not client.Character.IsHuman then return 0 end
            if client.Character.HasJob("captain") then return 0.5 end
            if client.Character.HasJob("securityofficer") then return 0.5 end
            if client.Character.HasJob("medicaldoctor") then return 0.5 end

            return 1
        end
    },
    -- End Campaign Gamemode Settings

}

config.RoleConfig = {
    Crew = {
        AvailableObjectives = {
            ["captain"] = {},
            ["engineer"] = {"Repair"},
            ["mechanic"] = {"Repair"},
            ["securityofficer"] = {"KillMonsters"},
            ["medic"] = {},
            ["assistant"] = {"Repair"},
        }
    },

    Cultist = {
        SubObjectives = {"Assassinate", "Kidnap", "TurnHusk", "TrippingBalls", "UpsetTummy", "StealCaptainID", "StealDoctorID", "StealSecurityID", "StealEngineerID", "StealMechanicID"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = false,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = false,                  -- traitors can send direct messages to other players using !tdm

        -- Names, None
        TraitorMethodCommunication = "Codewords",

        SelectBotsAsTargets = false,
        SelectPiratesAsTargets = false,
    },

    HuskServant = {
        TraitorBroadcast = true,
    },

    Traitor = {
        SubObjectives = {"Mutiny", "StealCaptainID", "Survive", "Kidnap", "PoisonCaptain", "TrippingBalls", "UpsetTummy", "StealDoctorID", "StealSecurityID", "StealEngineerID", "StealMechanicID"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = false,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = false,                  -- traitors can send direct messages to other players using !tdm

        -- Names, Codewords, None
        TraitorMethodCommunication = "Codewords",

        SelectBotsAsTargets = false,
        SelectPiratesAsTargets = false,
        SelectUniqueTargets = true,     -- every traitor target can only be chosen once per traitor (respawn+false -> no end)
        PointsPerAssassination = 100,
    },

}

config.ObjectiveConfig = {
    Assassinate = {
        AmountPoints = 600,
    },

    Survive = {
        AlwaysActive = true,
        AmountPoints = 500,
        AmountLives = 1,
    },

    StealCaptainID = {
        AmountPoints = 1300,
    },

    Kidnap = {
        AmountPoints = 2500,
        Seconds = 100,
    },

    Mutiny = {
        AmountPoints = 3000,
        Seconds = 300,
    },

    PoisonCaptain = {
        AmountPoints = 1600,
    },

    Husk = {
        AmountPoints = 800,
    },

    TurnHusk = {
        AmountPoints = 500,
        AmountLives = 1,
    },

    DestroyCaly = {
        AmountPoints = 500,
    },

    TrippingBalls = {
        AmountPoints = 250,
    },

    UpsetTummy = {
        AmountPoints = 250,
    },
}

----- EVENTS -----
config.RandomEventConfig = {
    Events = {
        dofile(Traitormod.Path .. "/Lua/config/randomevents/communicationsoffline.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/superballastflora.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/maintenancetoolsdelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/medicaldelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/ammodelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/hiddenpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/electricalfixdischarge.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/wreckpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/beaconpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/abysshelp.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/lightsoff.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/emergencyteam.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/piratecrew.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/outpostpirateattack.lua"),
    }
}

config.PointShopConfig = {
    Enabled = true,
    DeathTimeoutTime = 120,
    ItemCategories = {
        dofile(Traitormod.Path .. "/Lua/config/pointshop/cultist.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/traitor.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/security.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/maintenance.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/materials.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/medical.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/ores.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/other.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/experimental.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/deathspawn.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/ships.lua"),
    }
}

config.GhostRoleConfig = {
    Enabled = true,
    MiscGhostRoles = {
        ["Watcher"] = true,
        ["Mudraptor_pet"] = true,
    }
}

return config
