local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "UpsetTummy"
objective.AmountPoints = 250

function objective:Start(target)
    self.Target = target

    if self.Target == nil then
        return false
    end

    self.Text = string.format("Give %s serious nausea.", self.Target.Name)

    return true
end

function objective:IsCompleted()
    if self.Target == nil then
        return
    end

    local aff = self.Target.CharacterHealth.GetAffliction("nausea", true)

    if aff ~= nil and aff.Strength > 80 then
        return true
    end

    return false
end

return objective
