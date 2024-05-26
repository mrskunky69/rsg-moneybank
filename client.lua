local MoneyBoxes = {}

RegisterNetEvent('rsg_moneybox:client:useMoneyBox')
AddEventHandler('rsg_moneybox:client:useMoneyBox', function(coords)
    local playerPed = PlayerPedId()
    local prop = Config.MoneyBoxProp

    local moneyBox = {
        netId = nil,
        cashAmount = 0,
        coords = coords
    }

    local moneyBoxObject = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z, true, true, true)

    if DoesEntityExist(moneyBoxObject) then
        PlaceObjectOnGroundProperly(moneyBoxObject)
        local netId = NetworkGetNetworkIdFromEntity(moneyBoxObject)
        moneyBox.netId = netId
        table.insert(MoneyBoxes, moneyBox)
    else
        print("Failed to create money box object")
    end
end)

local moneyBoxProp = {
    GetHashKey(Config.MoneyBoxProp)
}

local moneyBoxProp = Config.MoneyBoxProp

if type(moneyBoxProp) == "string" then
    moneyBoxProp = GetHashKey(moneyBoxProp)
end

local moneyBoxProp = {
    moneyBoxProp
}

-- Add target options to the money box model
exports[Config.TargetResource]:AddTargetModel(moneyBoxProp, {
    options = {
        {
            event = 'rsg_moneybox:addMoneyToBox',
            icon = 'fas fa-dollar-sign',
            label = 'Add Money to Box',
            action = function(entity)
                local netId = NetworkGetNetworkIdFromEntity(entity)
                local moneyBox = GetMoneyBoxByNetId(netId)
                if moneyBox then
                    OpenAddMoneyDialog(moneyBox)
                end
            end
        },
        {
            event = 'rsg_moneybox:pickupMoneyBox',
            icon = 'fas fa-hand-holding',
            label = 'Pick Up Money Box',
            action = function(entity)
                local netId = NetworkGetNetworkIdFromEntity(entity)
                local moneyBox = GetMoneyBoxByNetId(netId)
                if moneyBox then
                    PickUpMoneyBox(moneyBox)
                end
            end
        }
    },
    distance = 2.5
})

RegisterNetEvent('rsg_moneybox:notifyPickup')
AddEventHandler('rsg_moneybox:notifyPickup', function(cashAmount)
    TriggerEvent('rNotify:NotifyLeft', "You received $" .. cashAmount .. " from the money box.", "Money Box Picked Up", "generic_textures", "tick", 4000)
end)

function GetMoneyBoxByNetId(netId)
    for _, moneyBox in ipairs(MoneyBoxes) do
        if moneyBox.netId == netId then
            return moneyBox
        end
    end
    return nil
end

function OpenAddMoneyDialog(moneyBox)
    local amount = exports['rsg-input']:ShowInput({
        header = "Add Money to Box",
        submitText = "Add",
        inputs = {
            {
                text = "Amount ($)",
                name = "amount",
                type = "number",
                isRequired = true
            }
        }
    })

    if amount then
        TriggerServerEvent('rsg_moneybox:addMoneyToBox', {
            amount = amount.amount,
            moneyBox = moneyBox
        })
    end
end

-- Event handler for opening a money box
-- Event handler for opening a money box
RegisterNetEvent('rsg_moneybox:client:openMoneyBox')
AddEventHandler('rsg_moneybox:client:openMoneyBox', function(moneyBox)
    local cashAmount = moneyBox.cashAmount
    TriggerEvent('rNotify:NotifyLeft', "The money box contains $" .. cashAmount .. ".", "Money Box Opened", "generic_textures", "tick", 4000)

    -- Trigger a server event to remove the money box item from the player's inventory
    TriggerServerEvent('rsg_moneybox:removeMoneyBoxFromInventory', moneyBox.cashAmount)
end)

function RemoveMoneyBox(netId)
    local moneyBox = GetMoneyBoxByNetId(netId)
    if moneyBox then
        local object = NetworkGetEntityFromNetworkId(netId)
        if DoesEntityExist(object) then
            DeleteEntity(object)
        end
        table.remove(MoneyBoxes, table.indexOfElement(MoneyBoxes, moneyBox))
    end
end

function RemoveMoneyBox(netId)
    local moneyBox = GetMoneyBoxByNetId(netId)
    if moneyBox then
        local object = NetworkGetEntityFromNetworkId(netId)
        if DoesEntityExist(object) then
            DeleteEntity(object)
        end
        for i = 1, #MoneyBoxes do
            if MoneyBoxes[i] == moneyBox then
                table.remove(MoneyBoxes, i)
                break
            end
        end
    end
end

function PickUpMoneyBox(moneyBox)
    TriggerServerEvent('rsg_moneybox:pickupMoneyBox', moneyBox)
    RemoveMoneyBox(moneyBox.netId)
end

RegisterNetEvent('rsg_moneybox:updateMoneyBoxCash')
AddEventHandler('rsg_moneybox:updateMoneyBoxCash', function(netId, cashAmount)
    local moneyBox = GetMoneyBoxByNetId(netId)
    if moneyBox then
        moneyBox.cashAmount = cashAmount
    end
end)

RegisterNetEvent('rsg_moneybox:addMoneyBoxToInventory')
AddEventHandler('rsg_moneybox:addMoneyBoxToInventory', function(cashAmount)
    TriggerEvent('rNotify:NotifyLeft', "You picked up the money box with $" .. cashAmount .. " inside.", "Money Box Picked Up", "generic_textures", "tick", 4000)
    TriggerEvent('rsg_moneybox:client:useMoneyBox', GetEntityCoords(PlayerPedId()))
end)