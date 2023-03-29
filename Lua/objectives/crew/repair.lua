local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Repair"
objective.AmountPoints = 400
objective.Amount = 5
objective.ItemIdentifier = nil
objective.ItemText = nil

objective.MechanicalItems = {
    { identifier = "pump", desc = "Pumps", minamount=2, maxamount=4 },
    { identifier = "engine", desc = "Engines", minamount=2, maxamount=2 },
    -- Add additional mechanical items as needed
  }
  
  objective.ElectricalItems = {
    { identifier = "junctionbox", desc = "Junction Boxes", minamount=3, maxamount=5 },
    { identifier = "battery", desc = "Batteries", minamount=2, maxamount=4 },
    { identifier = "navterminal", desc = "Navigation Terminal", minamount=1, maxamount=1 },
    --{ identifier = "supercapacitor", desc = "Supercapacitors", minamount=2, maxamount=2 },
    { identifier = "reactor", desc = "Reactor", minamount=1, maxamount=1 },
    -- Add additional electrical items as needed
  }

function objective:SelectRandomRepairTarget()
    local randomMechanicalItem = math.random(1, #self.MechanicalItems)
    local randomElectricalItem = math.random(1, #self.ElectricalItems)
    local mechanicalItem = self.MechanicalItems[randomMechanicalItem]
    local electricalItem = self.ElectricalItems[randomElectricalItem]
    local repairItem = nil

    -- If Engineer, Choose a random item from the electrical list
    if self.Character.IsEngineer then
        repairItem = electricalItem

    -- If Mechanic, Choose a random item from the mechanical list
    elseif 
        self.Character.IsMechanic then
            repairItem = mechanicalItem
    -- If Assistant or Other, Choose a random item from the mechanical or electrical list
    else
        local randomItem = math.random(1, 2)

        if randomItem == 1 then
            repairItem = mechanicalItem        
        else
            repairItem = electricalItem
        end
    end

    self.ItemIdentifier = repairItem.identifier
    self.ItemText = repairItem.desc
    self.Amount = math.random(repairItem.minamount, repairItem.maxamount)
end

function objective:Start(target)
    self.Progress = 0
    self:SelectRandomRepairTarget()
    
    self.Text = string.format("Repair (%s/%s) %s", self.Progress, self.Amount, self.ItemText)

    return true
end

function objective:StopRepairing(item, character)
    if item:HasTag(self.ItemIdentifier) and character == self.Character then
        -- If Item is Repaired, Add to Progress
        if item.ConditionPercentage > 95 then
            Traitormod.Debug("Item Repaired (" .. self.ItemIdentifier .. ") by " .. character.Name)
            self.Progress = self.Progress + 1
            self.Text = string.format("Repair (%s/%s) %s", self.Progress, self.Amount, self.ItemText)
        end
    end
end

function objective:IsCompleted()
    if self.Progress >= self.Amount then
        return true
    end

    return false
end

return objective
