local isMining = false

Citizen.CreateThread(function()
    for _, npc in pairs(Config.NPC) do
        local model = GetHashKey(npc.model)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
        local ped = CreatePed(4, model, npc.coords, npc.heading, false, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        
        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'buy_basic_pickaxe',
                label = 'Buy Basic Pickaxe - $' .. Config.Pickaxes.basic.price,
                icon = 'fa-solid fa-hammer',
                onSelect = function()
                    TriggerServerEvent('miner:buyPickaxe', 'basic')
                end
            },
            {
                name = 'buy_advanced_pickaxe',
                label = 'Buy Advanced Pickaxe - $' .. Config.Pickaxes.advanced.price,
                icon = 'fa-solid fa-hammer',
                onSelect = function()
                    TriggerServerEvent('miner:buyPickaxe', 'advanced')
                end
            },
            {
                name = 'sell_ores',
                label = 'Sell Ores',
                icon = 'fa-solid fa-sack-dollar',
                onSelect = function()
                    TriggerServerEvent('miner:sellOres')
                end
            }
        })
    end

    for _, point in pairs(Config.MiningPoints) do
        exports.ox_target:addSphereZone({
            coords = point.coords,
            radius = 2.0,
            options = {
                {
                    name = 'mine_ore',
                    label = 'Mine Ore',
                    icon = 'fa-solid fa-pickaxe',
                    onSelect = function()
                        if not isMining then
                            StartMining()
                        else
                            TriggerEvent('ox_lib:notify', {type = 'error', text = 'You are already mining!'})
                        end
                    end
                }
            }
        })
    end
end)

function StartMining()
    isMining = true
    local ped = PlayerPedId()
    local dict = "amb@world_human_hammering@male@base"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(1)
    end
    TaskPlayAnim(ped, dict, "base", 8.0, 8.0, -1, 1, 0, false, false, false)
    Citizen.Wait(25000)
    ClearPedTasks(ped)
    TriggerServerEvent('miner:rewardPlayer', GetPickaxeType())
    isMining = false
end

function GetPickaxeType()
    local basic = exports.ox_inventory:Search('count', 'basic_pickaxe')
    local advanced = exports.ox_inventory:Search('count', 'advanced_pickaxe')

    if advanced > 0 then
        return 'advanced'
    elseif basic > 0 then
        return 'basic'
    else
        return nil
    end
end
