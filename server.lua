RSGCore = exports['rsg-core']:GetCoreObject()

RSGCore.Functions.CreateUseableItem(Config.MoneyBoxItem, function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname

    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        local playerPed = GetPlayerPed(source)
        local coords = GetEntityCoords(playerPed)

        TriggerClientEvent("rsg_moneybox:client:useMoneyBox", source, coords)
        TriggerEvent('rsg-log:server:CreateLog', 'money_box', 'Creating money box', 'green', firstname .. ' ' .. lastname .. ' has created a money box.')
    else
        TriggerClientEvent('RSGCore:Notify', source, "You don't have a money box", 'error')
    end
end)

RegisterNetEvent('rsg_moneybox:addMoneyToBox')
AddEventHandler('rsg_moneybox:addMoneyToBox', function(data)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local moneyAmount = data.amount
    local moneyBox = data.moneyBox

    if Player.Functions.RemoveMoney('cash', moneyAmount) then
        moneyBox.cashAmount = moneyBox.cashAmount + moneyAmount
        TriggerClientEvent('rsg_moneybox:updateMoneyBoxCash', -1, moneyBox.netId, moneyBox.cashAmount)
        TriggerClientEvent('RSGCore:Notify', src, "You added $" .. moneyAmount .. " to the money box", 'success')
    else
        TriggerClientEvent('RSGCore:Notify', src, "You don't have enough cash", 'error')
    end
end)

RegisterNetEvent('rsg_moneybox:pickupMoneyBox')
AddEventHandler('rsg_moneybox:pickupMoneyBox', function(moneyBox)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    -- Pay the cash amount directly to the player
    Player.Functions.AddMoney('cash', moneyBox.cashAmount)

    -- Notify the player of the cash received from the money box
    TriggerClientEvent('rsg_moneybox:notifyPickup', src, moneyBox.cashAmount)

    
end)

RegisterNetEvent('rsg_moneybox:removeMoneyBoxFromInventory')
AddEventHandler('rsg_moneybox:removeMoneyBoxFromInventory', function(cashAmount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    -- Remove the money box item from the player's inventory
    Player.Functions.RemoveItem(Config.MoneyBoxItem, 1)
    Player.Functions.AddMoney('cash', cashAmount)

    TriggerClientEvent('RSGCore:Notify', src, "You received $" .. cashAmount .. " from the money box.", 'success')
end)