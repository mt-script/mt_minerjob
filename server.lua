local ESX, QBCore

if Config.ESX then
    ESX = exports['es_extended']:getSharedObject()
else
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterNetEvent('miner:buyPickaxe')
AddEventHandler('miner:buyPickaxe', function(pickaxeType)
    local xPlayer = Config.ESX and ESX.GetPlayerFromId(source) or QBCore.Functions.GetPlayer(source)
    local money = Config.ESX and xPlayer.getMoney() or xPlayer.PlayerData.money['cash']
    local price = Config.Pickaxes[pickaxeType].price

    if money >= price then
        if Config.ESX then
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(pickaxeType .. '_pickaxe', 1)
        else
            xPlayer.Functions.RemoveMoney('cash', price)
            xPlayer.Functions.AddItem(pickaxeType .. '_pickaxe', 1)
        end
        TriggerClientEvent('ox_lib:notify', source, {type = 'success', text = 'You bought a ' .. pickaxeType .. ' pickaxe!'})
    else
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', text = 'Not enough money!'})
    end
end)

RegisterNetEvent('miner:sellOres')
AddEventHandler('miner:sellOres', function()
    local xPlayer = Config.ESX and ESX.GetPlayerFromId(source) or QBCore.Functions.GetPlayer(source)
    local totalMoney = 0

    for _, ore in pairs(Config.Ores) do
        local oreCount = Config.ESX and xPlayer.getInventoryItem(ore.name).count or xPlayer.Functions.GetItemByName(ore.name).amount
        if oreCount > 0 then
            local price = Config.SellPrices[ore.name] * oreCount
            totalMoney = totalMoney + price
            if Config.ESX then
                xPlayer.removeInventoryItem(ore.name, oreCount)
            else
                xPlayer.Functions.RemoveItem(ore.name, oreCount)
            end
        end
    end

    if totalMoney > 0 then
        if Config.ESX then
            xPlayer.addMoney(totalMoney)
        else
            xPlayer.Functions.AddMoney('cash', totalMoney)
        end
        TriggerClientEvent('ox_lib:notify', source, {type = 'success', text = 'You sold your ores for $' .. totalMoney .. '!'})
    else
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', text = 'You have no ores to sell!'})
    end
end)

RegisterNetEvent('miner:rewardPlayer')
AddEventHandler('miner:rewardPlayer', function(pickaxeType)
    if not pickaxeType then
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', text = 'You need a pickaxe to mine!'})
        return
    end

    local xPlayer = Config.ESX and ESX.GetPlayerFromId(source) or QBCore.Functions.GetPlayer(source)
    local rewards = {}

    for _, ore in pairs(Config.Ores) do
        if math.random(100) <= ore.probability then
            local amount = (pickaxeType == 'advanced') and ore.advanced_amount or ore.basic_amount
            table.insert(rewards, {name = ore.name, amount = amount})
        end
    end

    if #rewards > 0 then
        for _, reward in pairs(rewards) do
            if Config.ESX then
                xPlayer.addInventoryItem(reward.name, reward.amount)
            else
                xPlayer.Functions.AddItem(reward.name, reward.amount)
            end
        end
        TriggerClientEvent('ox_lib:notify', source, {type = 'success', text = 'You mined some ores!'})
    else
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', text = 'No ores found!'})
    end
end)
