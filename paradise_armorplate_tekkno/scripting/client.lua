local ox_inventory = exports.ox_inventory

local function HasArmorVest()
    local hasVest = ox_inventory:GetItemCount(Config.RequiredVest) > 0
    return hasVest
end

local function CanUseArmorType(armorType)
    local Player = QBX.PlayerData
    local jobName = Player.job.name
    
    if Config.ArmorPlates[armorType].jobs == nil then
        return true
    end
    
    return Config.ArmorPlates[armorType].jobs[jobName] == true
end

local function ApplyArmorPlate(plateType)
    local src = source
    local ox_inventory = exports.ox_inventory
    local vest = ox_inventory:Search("count", "armor_vest")
    local armorConfig = Config.ArmorPlates[plateType]
    
    if not HasArmorVest() then
        lib.notify({
            title = 'Error',
            description = 'You need an armor vest to apply plates!',
            type = 'error'
        })
        return
    end
    
    if not CanUseArmorType(plateType) then
        lib.notify({
            title = 'Error',
            description = 'You cannot use this type of armor plate!',
            type = 'error'
        })
        return
    end
    
    local currentArmor = GetPedArmour(PlayerPedId())
    if currentArmor >= armorConfig.maxArmor then
        lib.notify({
            title = 'Error',
            description = 'Maximum armor capacity reached!',
            type = 'error'
        })
        return
    end
    
    if lib.progressBar({
        duration = armorConfig.useTime,
        label = 'Applying Armor Plate...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'clothingshirt',
            clip = 'try_shirt_positive_d',
            flag = 49
        },
    }) then
        local newArmor = math.min(currentArmor + armorConfig.armorIncrease, armorConfig.maxArmor)
        SetPedArmour(PlayerPedId(), newArmor)
        TriggerServerEvent("Armor:UpdateDurability")
        TriggerServerEvent("paradise_armorplate:server:removePlate", armorConfig.item)
    

        lib.notify({
            title = 'Success',
            description = 'Armor plate applied successfully!',
            type = 'success'
        })
    else
        lib.notify({
            title = 'Cancelled',
            description = 'Cancelled applying armor plate!',
            type = 'error'
        })
    end
end

RegisterNetEvent('paradise_armorplate:client:useArmor', function(plateType)
    ApplyArmorPlate(plateType)
end)