local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "StealEngineerID"
objective.RoleFilter = {["engineer"] = true}
objective.AmountPoints = 1000

function objective:Start(target)
    -- if no valid captain found, abort
    if not target then
        return false
    end

    if self.Character.IsCaptain then
        Traitormod.Debug("StealEngineerID: Engineer cannot steal engineer's ID.")
        return false
    end

    self.Text = Traitormod.Language.ObjectiveStealEngineerID

    return true
end

function objective:IsCompleted()
    for item in self.Character.Inventory.AllItems do
        if item.Prefab.Identifier == "idcard" and item.GetComponentString("IdCard").OwnerJobId == "engineer" then
            return true
        end
    end

    return false
end

return objective