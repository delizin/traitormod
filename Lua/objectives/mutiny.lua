-- The mutiny objective is to handcuff the captain, take his ID, and seize control of the ship. 

local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Mutiny"
objective.RoleFilter = { ["captain"] = true }
objective.AmountPoints = 3000

function objective:Start(target)
    self.Target = target

    if self.Target == nil then
        return false
    end
    
    if self.Character.IsCaptain then
        Traitormod.Debug("Mutiny: Captain cannot mutiny against self.")
        return false
    end

    self.TargetName = target.Name

    self.Text = string.format(Traitormod.Language.ObjectiveKidnap, self.TargetName,
    self.Seconds)

    self.SecondsLeft = self.Seconds

    return true
end

function objective:IsCompleted()
    objective_1_complete = false
    objective_2_complete = false

    -- Objective 1 - Has Captain ID
    for item in self.Character.Inventory.AllItems do
        if item.Prefab.Identifier == "idcard" and item.GetComponentString("IdCard").OwnerJobId == "captain" then
            objective_1_complete = true
        end
    end

    -- Objective 2 - Captain is Handcuffed
    if self.SecondsLeft <= 0 then
        self.Text = string.format(Traitormod.Language.ObjectiveKidnap, self.TargetName,
        self.Seconds)

        objective_2_complete = true
    end

    local char = self.Target

    if char == nil or char.IsDead then return false end

    local item = char.Inventory.GetItemInLimbSlot(InvSlotType.RightHand)

    if item ~= nil and item.Prefab.Identifier == "handcuffs" then
        if self.lastTimer == nil then
            self.lastTimer = Timer.GetTime()
        end

        self.SecondsLeft = math.max(0, self.SecondsLeft - (Timer.GetTime() - self.lastTimer))

        self.Text = string.format(Traitormod.Language.ObjectiveKidnap, self.TargetName,
            math.floor(self.SecondsLeft))

        self.lastTimer = Timer.GetTime()

    else
        self.lastTimer = Timer.GetTime()
    end

    if objective_1_complete and objective_2_complete then
        return true
    end

    return false
end

return objective
