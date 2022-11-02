local QBCore = exports['qb-core']:GetCoreObject()

local ItemList = {
    ["casinochips"] = 1,
}
RegisterServerEvent("qb-casino:server:WhiteSell")
AddEventHandler("qb-casino:server:WhiteSell", function()
    local src = source
    local price = Config.whiteChipPrice
    local Player = QBCore.Functions.GetPlayer(src)
    local xItem = Player.Functions.GetItemByName("casinochips")
    if xItem ~= nil then
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    price = price * (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    Player.Functions.AddMoney(Config.payment, price, "sold-casino-chips")
                    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['casinochips'], "remove", Player.PlayerData.items[k].amount)
                    TriggerClientEvent('QBCore:Notify', src, "You sold "..Player.PlayerData.items[k].amount.." White chips for $"..price)
                    TriggerClientEvent("doj:casinoChipMenu", src)
                end
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You dont have any casino chips...", "error")
        TriggerClientEvent("doj:casinoChipMenu", src)
    end
end)


















