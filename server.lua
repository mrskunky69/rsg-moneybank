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

RegisterNetEvent('rsg_moneybox:createMoneyBox')
AddEventHandler('rsg_moneybox:createMoneyBox', function(coords, cashAmount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveMoney('cash', cashAmount) then
        local moneyBox = {
            netId = nil,
            cashAmount = cashAmount,
            coords = coords
        }
        MySQL.Async.execute('INSERT INTO money_boxes (cashAmount, x, y, z) VALUES (@cashAmount, @x, @y, @z)', {
            ['@cashAmount'] = moneyBox.cashAmount,
            ['@x'] = moneyBox.coords.x,
            ['@y'] = moneyBox.coords.y,
            ['@z'] = moneyBox.coords.z
        }, function(affectedRows)
            if affectedRows > 0 then
                TriggerClientEvent('rsg_moneybox:createMoneyBoxClient', src, coords, moneyBox)
            else
                print("Error inserting money box into database")
            end
        end)
    else
        TriggerClientEvent('RSGCore:Notify', src, "You don't have enough cash", 'error')
    end
end)

RegisterNetEvent('rsg_moneybox:updateMoneyBoxNetId')
AddEventHandler('rsg_moneybox:updateMoneyBoxNetId', function(moneyBox)
    MySQL.Async.execute('UPDATE money_boxes SET netId = @netId WHERE x = @x AND y = @y AND z = @z', {
        ['@netId'] = moneyBox.netId,
        ['@x'] = moneyBox.coords.x,
        ['@y'] = moneyBox.coords.y,
        ['@z'] = moneyBox.coords.z
    }, function(affectedRows)
        if affectedRows == 0 then
            print("Error updating money box netId in database")
        end
    end)
end)

RegisterNetEvent('rsg_moneybox:openMoneyBox')
AddEventHandler('rsg_moneybox:openMoneyBox', function(netId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    MySQL.Async.fetchAll('SELECT * FROM money_boxes WHERE netId = @netId', { ['@netId'] = netId }, function(results)
        if results[1] then
            local cashAmount = results[1].cashAmount
            Player.Functions.AddMoney('cash', cashAmount)
            MySQL.Async.execute('DELETE FROM money_boxes WHERE netId = @netId', { ['@netId'] = netId }, function(affectedRows)
                if affectedRows > 0 then
                    TriggerClientEvent('rsg_moneybox:removeMoneyBox', -1, netId)
                    TriggerClientEvent('rsg_moneybox:notifyMoneyBoxOpened', src, cashAmount)
                else
                    TriggerClientEvent('RSGCore:Notify', src, "Failed to remove money box from database", 'error')
                end
            end)
        else
            TriggerClientEvent('RSGCore:Notify', src, "Money box not found", 'error')
        end
    end)
end)

RegisterNetEvent('rsg_moneybox:pickupMoneyBox')
AddEventHandler('rsg_moneybox:pickupMoneyBox', function(netId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    MySQL.Async.fetchAll('SELECT * FROM money_boxes WHERE netId = @netId', { ['@netId'] = netId }, function(results)
        if results[1] then
            local cashAmount = results[1].cashAmount
            Player.Functions.AddItem('moneybox', 1)
            Player.Functions.AddMoney('cash', cashAmount)
            MySQL.Async.execute('DELETE FROM money_boxes WHERE netId = @netId', { ['@netId'] = netId }, function(affectedRows)
                if affectedRows > 0 then
                    TriggerClientEvent('rsg_moneybox:removeMoneyBox', -1, netId)
                    TriggerClientEvent('rsg_moneybox:notifyMoneyBoxPickedUp', src, cashAmount)
                else
                    TriggerClientEvent('RSGCore:Notify', src, "Failed to remove money box from database", 'error')
                end
            end)
        else
            TriggerClientEvent('RSGCore:Notify', src, "Money box not found", 'error')
        end
    end)
end)




AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        MySQL.Async.fetchAll('SELECT * FROM money_boxes', {}, function(moneyBoxes)
            TriggerClientEvent('rsg_moneybox:loadMoneyBoxes', -1, moneyBoxes)
        end)
    end
end)
