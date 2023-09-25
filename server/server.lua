local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("pawn:SellItem", function(source, cb, data)
    local player = QBCore.Functions.GetPlayer(source)
    print(json.encode(data))
    if data ~= nil then
        if player.Functions.RemoveItem(data.dbname, data.amount) then
            player.Functions.AddMoney("cash", data.amount * cfg.Items[data.dbname].price)
            TriggerClientEvent("QBCore:Notify", source, "You sold ".. data.amount.." ".. data.label.. " for ".. cfg.Items[data.dbname].price.."."
                ,"success")
                cb(true)
        else
            TriggerClientEvent("QBCore:Notify", source, "You do not have any of that item!"
            ,"error")
            cb(false)
        end
    end
    cb(false)
end)

QBCore.Functions.CreateCallback('pawn:RetreiveItems', function(source, cb)
    local player = QBCore.Functions.GetPlayer(source)
    local itemsToSend = {}
    if player ~= nil then 
        for dbname, data in pairs(cfg.Items) do
                local items = player.Functions.GetItemsByName(dbname)
                local amnt = 0
                if items ~= nil then
                    for k, v in pairs(items) do
                        amnt = amnt + v.amount
                    end
                    if amnt > 0 then
                        data.amount = amnt
                        data.dbname = dbname
                        table.insert(itemsToSend, data)
                    end
                end
        end
        cb(json.encode(itemsToSend))
    end
end)
