local MoneyBox = nil

RegisterNetEvent("rsg_moneybox:client:useMoneyBox")
AddEventHandler("rsg_moneybox:client:useMoneyBox", function(coords)
    local dialog = exports['rsg-input']:ShowInput({
        header = "Enter Cash Amount",
        submitText = "Create Money Box",
        inputs = {
            {
                text = "Cash Amount ($)",
                name = "cash_amount",
                type = "number",
                isRequired = true
            }
        }
    })

    if dialog and dialog.cash_amount then
        TriggerServerEvent("rsg_moneybox:createMoneyBox", coords, dialog.cash_amount)
    end
end)

RegisterNetEvent('rsg_moneybox:createMoneyBoxClient')
AddEventHandler('rsg_moneybox:createMoneyBoxClient', function(coords, moneyBox)
    local prop = Config.MoneyBoxProp
    local moneyBoxObject = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z, true, true, true)

    if DoesEntityExist(moneyBoxObject) then
        PlaceObjectOnGroundProperly(moneyBoxObject)
        local netId = NetworkGetNetworkIdFromEntity(moneyBoxObject)
        moneyBox.netId = netId
        TriggerServerEvent('rsg_moneybox:updateMoneyBoxNetId', moneyBox)
    else
        print("Failed to create money box object")
    end
end)

local moneyBoxProp = {
    GetHashKey(Config.MoneyBoxProp)
}

exports[Config.TargetResource]:AddTargetModel(moneyBoxProp, {
    options = {
        {
            event = 'rsg_moneybox:pickupMoneyBox',
            icon = 'fas fa-box',
            label = 'Pick up Money Box',
            action = function(entity)
                local netId = NetworkGetNetworkIdFromEntity(entity)
                TriggerServerEvent('rsg_moneybox:pickupMoneyBox', netId)
            end
        },
        {
            event = 'rsg_moneybox:openMoneyBox',
            icon = 'fas fa-box-open',
            label = 'Open Money Box',
            action = function(entity)
                local netId = NetworkGetNetworkIdFromEntity(entity)
                TriggerServerEvent('rsg_moneybox:openMoneyBox', netId)
            end
        }
    },
    distance = 2.5
})

RegisterNetEvent('rsg_moneybox:removeMoneyBox')
AddEventHandler('rsg_moneybox:removeMoneyBox', function(netId)
    local object = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(object) then
        DeleteEntity(object)
    end
end)

RegisterNetEvent('rsg_moneybox:notifyMoneyBoxOpened')
AddEventHandler('rsg_moneybox:notifyMoneyBoxOpened', function(cashAmount)
    TriggerEvent('rNotify:NotifyLeft', "You found $" .. cashAmount .. " in the money box!", "NICE ONE", "generic_textures", "tick", 4000)
end)

RegisterNetEvent('rsg_moneybox:notifyMoneyBoxPickedUp')
AddEventHandler('rsg_moneybox:notifyMoneyBoxPickedUp', function(cashAmount)
    TriggerEvent('rNotify:NotifyLeft', "You picked up $" .. cashAmount .. " from the money box!", "NICE ONE", "generic_textures", "tick", 4000)
end)
