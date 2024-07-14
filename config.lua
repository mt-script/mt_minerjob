Config = {
    ESX = true,  -- if you use ESX, set true, otherwise false for QBCore
    NPC = {
        {coords = vector3(2569.2739, 2720.2891, 42.9563), heading = 180.0, model = 's_m_m_security_01'},
    },
    Pickaxes = {
        basic = {price = 500, amount = 1},
        advanced = {price = 5000, amount = 2}
    },
    MiningPoints = {
        {coords = vector3(2980.0508, 2748.8638, 43.3420)},
        {coords = vector3(2942.6589, 2741.9983, 43.5085)},
        -- add more points as needed
    },
    Ores = {
        {name = 'iron_ore', probability = 50, basic_amount = 1, advanced_amount = 2},
        {name = 'gold_ore', probability = 30, basic_amount = 1, advanced_amount = 2},
        {name = 'diamond_ore', probability = 10, basic_amount = 1, advanced_amount = 1},
        {name = 'coal_ore', probability = 80, basic_amount = 1, advanced_amount = 3},
        {name = 'copper_ore', probability = 40, basic_amount = 1, advanced_amount = 2}
    },
    SellPrices = {
        iron_ore = 100,
        gold_ore = 500,
        diamond_ore = 1000,
        coal_ore = 50,
        copper_ore = 200
    }
}