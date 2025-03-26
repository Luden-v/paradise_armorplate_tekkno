
local ox_inventory = exports.ox_inventory

for plateType, config in pairs(Config.ArmorPlates) do
    exports.qbx_core:CreateUseableItem(config.item, function(source)
        TriggerClientEvent('paradise_armorplate:client:useArmor', source, plateType)
    end)
end

RegisterNetEvent('paradise_armorplate:server:removePlate', function(itemName)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    --Player.Functions.RemoveItem(itemName, 1)
    exports.ox_inventory:RemoveItem(src, itemName, 1, nil)
    print(itemName)
    --TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], "remove")
end)

RegisterNetEvent("Armor:UpdateDurability", function()
local ped = GetPlayerPed(source)
local armor =  GetPedArmour(ped)
local vest = ox_inventory:GetSlotIdWithItem(source, "armor_vest")
    ox_inventory:SetDurability(source, vest, armor)
end)