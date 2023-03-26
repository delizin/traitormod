local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "StealMechanicID"
objective.RoleFilter = {["mechanic"] = true}
objective.AmountPoints = 1000

function objective:Start(target)
    -- if no valid captain found, abort
    if not target then
        return false
    end

    if self.Character.IsCaptain then
        Traitormod.Debug("StealMechanicID: Mechanic cannot steal mechanic's ID.")
        return false
    end

    self.Text = Traitormod.Language.ObjectiveStealMechanicID

    return true
end

function objective:IsCompleted()
    for item in self.Character.Inventory.AllItems do
        if item.Prefab.Identifier == "idcard" and item.GetComponentString("IdCard").OwnerJobId == "mechanic" then
            return true
        end
    end

    return false
end

return objective