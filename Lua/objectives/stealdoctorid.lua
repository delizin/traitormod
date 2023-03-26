local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "StealDoctorID"
objective.RoleFilter = {["medicaldoctor"] = true}
objective.AmountPoints = 1000

function objective:Start(target)
    -- if no valid doctor found, abort
    if not target then
        return false
    end

    if self.Character.IsMedic then
        Traitormod.Debug("StealDoctorID: Doctor cannot steal doctor's ID.")
        return false
    end

    self.Text = Traitormod.Language.ObjectiveStealDoctorID

    return true
end

function objective:IsCompleted()
    for item in self.Character.Inventory.AllItems do
        if item.Prefab.Identifier == "idcard" and item.GetComponentString("IdCard").OwnerJobId == "medicaldoctor" then
            return true
        end
    end

    return false
end

return objective