local QBCore = exports['qb-core']:GetCoreObject()

RegisterNUICallback("close", function()
    closePawn();
    cb("ok")
end)

RegisterNUICallback("sellitem", function(data)
    QBCore.Functions.TriggerCallback("pawn:SellItem", function(r)
        
    end, data)
end)
local allowedZone = false

CreateThread(function()
    -- for k, v in pairs(pwnShop) do
    --     local k = lib.zones.box({
    --         coords =  v,
    --         size = vec3(2.0, 2.0, 2.0),
    --         rotation = 0,
    --         debug = false,
    --         inside = function(tn)
    --             if IsControlJustReleased(0--[[control type]],  38--[[control index]]) then
    --                 openPawn()
    --             end 
    --         end,
    --         onEnter = function(tb)
    --             lib.showTextUI('[E] - Open Pawnshop', {
    --                 position = 'left-center',
    --             })
    --         end,
    --         onExit = function(tb)
    --             lib.hideTextUI()
    --         end
    --     })

    local zones = {}

    for k, v in pairs(cfg.pwnShops) do

        local BoxZone = BoxZone:Create(v.loc, 3.0, 5.0, {
            name= v.name .. tostring(k),
            offset={0.0, 0.0, 0.0},
            scale={1.0, 1.0, 1.0},
            debugPoly=false,
        })

        table.insert(zones, BoxZone)

        local blip = AddBlipForCoord(v.loc)
        SetBlipSprite(blip, 431)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 5)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(v.name)
        EndTextCommandSetBlipName(blip)
    end

    local pwnZones = ComboZone:Create(zones, {name="pwnShops", debugPoly=false})

    pwnZones:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            checkForInput()
            allowedZone = true
            TriggerEvent('qb-core:client:DrawText', cfg.openShopText, 'left')
        else
            allowedZone = false
            TriggerEvent('qb-core:client:HideText')
        end
    end)
end)

function checkForInput()
    Citizen.CreateThread(function()
        while allowedZone do
            if IsControlJustReleased(0--[[control type]],  38--[[control index]]) then
                openPawn()
            end 
            Wait(0)
        end
    end)    
end

function closePawn()
    SetNuiFocus(false, false)
    SendNuiMessage(json.encode({
        type="closePawn"
    }))
end

function openPawn()
    QBCore.Functions.TriggerCallback("pawn:RetreiveItems", function(cb)
        SetNuiFocus(true, true)
        SendNuiMessage(json.encode({
            type="openPawn",
            items = cb
        }))
    end)
end