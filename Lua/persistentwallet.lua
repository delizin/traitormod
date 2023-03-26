-- Save Wallet Balance for Each Character when Saving Game

-- Save Wallet Balance for Disconnected Character and prevent transfer of balance to bank

-- Prevent Loss of Wallet on Death

-- Load Wallet Balance for Each Character at Round Start

-- Load Wallet Balance for Characters when they join the server

-- Load Wallet Balance for Characters when they respawn


Traitormod.LoadWallet = function (client)
    if client == nil then
        Traitormod.Error("Loading wallet failed! Client was nil")
        return
    elseif not client.Character or not client.Character.Info then 
        Traitormod.Error("Loading wallet failed! Client.Character or .Info was null! " .. Traitormod.ClientLogName(client))
        return 
    end
    local amount = Traitormod.GetData(client, "Wallet") or 0
    local max = 2000000     -- must be int32

    if amount > max then
        amount = max
    end

    Traitormod.Debug("Loading wallet from stored file: " .. Traitormod.ClientLogName(client) .. " -> " .. amount)
    client.Character.Wallet.Balance = amount
end

Traitormod.SaveWallet = function (client)
    if client == nil then
        Traitormod.Error("Saving wallet failed! Client was nil")
        return
    elseif not client.Character or not client.Character.Info then 
        Traitormod.Error("Saving wallet failed! Client.Character or .Info was null! " .. Traitormod.ClientLogName(client))
        return 
    end

    local amount = client.Character.Wallet.Balance
    client.Character.Wallet.Balance = 0
    Traitormod.Debug("Saving wallet to file: " .. Traitormod.ClientLogName(client) .. " -> " .. amount)
    Traitormod.SetData(client, "Wallet", amount)
    Traitormod.SaveData()
end

-- Save Wallet on Death
Hook.Patch("Barotrauma.Character", "Kill", function (instance, ptable)
    if instance.IsPlayer then
        client = Traitormod.FindClientCharacter(instance)
        Traitormod.SaveWallet(client)
        Traitormod.Debug(string.format("Player %s died. Saving their wallet.", client.Name))
    end
end, Hook.HookMethodType.Before)

Hook.Patch("Barotrauma.GameSession", "Save", function (instance, ptable)
    Traitormod.Debug("Saving Wallets for All Clients")
    for _, client in pairs(Client.ClientList) do
        if client.Character ~= nil then
            Traitormod.SaveWallet(client)
        end
    end
end, Hook.HookMethodType.Before)