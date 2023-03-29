local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "InduceVomitting"
objective.AmountPoints = 250

objective.StringVariations = {"You have noticed %s periodically experiencing sea sickness. Induce vomitting to get it all out of their system at once.",
                              "You suspect %s ate something weird. Induce vomitting to get it out.",
                              "You caught %s spitting in your coffee. Punish them by causing them to vomit."}

function objective:Start(target)
    self.Target = target

    if self.Target == nil then
        return false
    end

    self.Text = string.format(Traitormod.RandomStringVariant(self.StringVariations), self.Target.Name)

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
