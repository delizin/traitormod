local event = {}

event.Name = "ShadyMission"
event.MinRoundTime = 1
event.MaxRoundTime = 10
event.MinIntensity = 0.6
event.MaxIntensity = 1
event.ChancePerMinute = 0.05
event.OnlyOncePerRound = true

local textPromptUtils = require("textpromptutils")

event.Start = function ()
    if #Level.Loaded.Wrecks == 0 then return end

    local possibleTargets = {}

    for key, value in pairs(Client.ClientList) do
        local character = value.Character
        if character and not character.IsDead and character.Vitality > 50 then
            if not Traitormod.RoleManager.IsAntagonist(character) then
                table.insert(possibleTargets, value)
            end
        end
    end

    if #possibleTargets == 0 then
        return
    end

    local specialBeacon = nil

    local target = possibleTargets[math.random(1, #possibleTargets)]

    -- mountain
    textPromptUtils.Prompt(
    "You pickup a weird radio transmission, it sounds like they are looking for someone to do a job for them.",
    {"Answer", "Ignore"}, target, function (option)
        if option == 2 then
            event.End()
            return
        end

        textPromptUtils.Prompt(
            "\"Oh hello there! We are looking for someone to do a simple task for us. We are willing to pay up to 3000 points for it. Interested?\"",
            {"Sure! What's it?"}, target, function ()

                textPromptUtils.Prompt(
                    "\"In this area where your submarine is heading through, there's an old wrecked submarine where we need to place some supplies. Because we don't have the supplies available right now, you are going to need to get the supplies yourself. We are going to need at least 8 of any medical item, 4 oxygen tanks, 2 loaded firearms of any type and a special sonar beacon. We will be paying 1500 points for these supplies, if you add any other supplies, we will give you up to 1500 additional points.\"",
                    {"This sounds fishy, why would you want to put these supplies in a wrecked submarine?!"}, target, function (option)
                        textPromptUtils.Prompt(
                            "\"Now this is none of your business, will you do it or not?\"",
                            {"Accept the offer", "Deny the offer"}, target, function (option2)
                                if option2 == 2 then
                                    event.End()
                                    return
                                end

                                textPromptUtils.Prompt(
                                    "\"Great! Just put all the supplies and the special sonar beacon in a metal crate and leave it in the wreck.\"",
                                    {"I'll do my best"}, target, function (option2)
                                end)

                                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("sonarbeacon"), target.Character.Inventory, nil, nil, function (item)
                                    specialBeacon = item

                                    item.Description = "‖color:gui.red‖It looks like this sonar beacon was modified.\nBehind it there's a note saying: \"8 medical items, 4 oxygen tanks and 2 loaded firearms.\"‖color:end‖"
                                    item.set_InventoryIconColor(Color(255, 0, 0))
                                    item.SpriteColor = Color(255, 0, 0, 255)
                                    local color = item.SerializableProperties[Identifier("SpriteColor")]
                                    Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(color, item))
                                    local invColor = item.SerializableProperties[Identifier("InventoryIconColor")]
                                    Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(invColor, item))

                                    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("batterycell"), item.OwnInventory, nil, nil, function (batteryCell)
                                        batteryCell.NonPlayerTeamInteractable = true
                                        local prop = batteryCell.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                                        Networking.CreateEntityEvent(batteryCell, Item.ChangePropertyEventData(prop, batteryCell))
                                    end)
                                end)
                        end, "ShockJock")
                end, "ShockJock")
        end, "ShockJock")
    end, "ShockJock")

    local completed = false

    local timer = 0
    Hook.Add("think", "Traitormod.RandomEvents.ShadyMission", function ()
        if Timer.GetTime() < timer then return end
        timer = Timer.GetTime() + 1
        if completed then return end
        if specialBeacon == nil then return end

        local isOnWreck = false
        for key, value in pairs(Level.Loaded.Wrecks) do
            if value == specialBeacon.Submarine then
                isOnWreck = true
            end
        end
        if not isOnWreck then return end

        local parent = specialBeacon.ParentInventory

        if parent == nil then return end
        if LuaUserData.IsTargetType(parent.Owner, "Barotrauma.Character") then return end
        if parent.Owner.ParentInventory ~= nil then return end
        if parent.Owner.Prefab.Identifier ~= "metalcrate" then return end

        local oxygenTanks = 0
        local medicalItems = 0
        local firearms = 0

        local notCounted = {}
        for item in parent.AllItems do
            if item.Prefab.Identifier == "oxygentank" then
                oxygenTanks = oxygenTanks + 1
            elseif item.HasTag("medical") then
                medicalItems = medicalItems + 1
            elseif item.HasTag("weapon") and item.GetContainedItemConditionPercentage() > 0.5 then
                firearms = firearms + 1
            else
                notCounted[item] = true
            end
        end

        if oxygenTanks >= 4 and medicalItems >= 8 and firearms >= 2 then
            local baseAmount = 1500

            for item, _ in pairs(notCounted) do
                if item.Prefab.DefaultPrice ~= nil then
                    baseAmount = baseAmount + item.Prefab.DefaultPrice.Price / 2
                end
            end

            completed = true

            Traitormod.AwardPoints(target, baseAmount)
            Traitormod.SendMessage(target, "You have received " .. baseAmount .. " points.", "InfoFrameTabButton.Mission")

            local newSet = {}
            newSet.Name = target.Name
            newSet.Items = {}

            for item in parent.AllItems do
                local itemData = {}
                itemData.Id = item.Prefab.Identifier.Value
                itemData.SubItems = {}
                if item.OwnInventory then
                    for subItem in item.OwnInventory.AllItems do
                        table.insert(itemData.SubItems, {subItem.Prefab.Identifier.Value})
                    end
                end

                local terminal = item.GetComponentString("Terminal")
                if terminal then
                    itemData.ShowMessage = terminal.ShowMessage
                end

                table.insert(newSet.Items, itemData)
            end

            local data = Traitormod.GetMasterData("TraitorItemSets") or {}
            table.insert(data, newSet)
            Traitormod.SetMasterData("TraitorItemSets", data)

            --parent.Owner.NonInteractable = true
        end
    end)
end


event.End = function ()
    Hook.Remove("think", "Traitormod.RandomEvents.ShadyMission")
end

return event