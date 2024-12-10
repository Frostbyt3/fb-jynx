local QBCore = exports['qb-core']:GetCoreObject()

function NearCar(src)
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    for _, v in pairs(Config.NPCLocations.DropLocations) do
        local dist = #(coords - vector3(v.x, v.y, v.z))
        if dist < 20 then
            return true
        end
    end
end

RegisterNetEvent('fb-jynx:server:NpcPay', function(Payment, recklessDriving, Tip)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if NearCar(src) then
        local randomAmount = math.random(1, 5)
        local r1, r2 = math.random(1, 5), math.random(1, 5)
        if randomAmount == r1 or randomAmount == r2 then Payment = Payment + math.random(10, 20) end

        Player.Functions.AddMoney('cash', Payment, 'Jynx Payout')

        local chance = math.random(1, 100)
        --local Tip = math.ceil(Payment / 2)
        if chance < 75 then
            if not recklessDriving then
                Player.Functions.AddMoney('cash', Tip, 'Jynx Tip')
                TriggerClientEvent('QBCore:Notify', src, 'Here\'s a tip! $' .. Tip .. '', 'success')
            else
                Player.Functions.AddMoney('cash', Tip, 'Jynx Tip')
                TriggerClientEvent('QBCore:Notify', src, 'You were driving recklessly. Your Tip has been cut down to: ' .. Tip .. '', 'error')
            end
        end
    else
        --DropPlayer(src, 'Attempting To Exploit')
        TriggerClientEvent('QBCore:Notify', src, 'You aren\'t near the drop-off location', 'error')
    end
end)

RegisterNetEvent('fb-jynx:server:changeDuty', function(data)
    local Player = QBCore.Functions.GetPlayer(source)
    local Job = Player.PlayerData.job

    if Job and Job.onduty then
        Player.Functions.SetJobDuty(false)
        QBCore.Functions.Notify(source, 'You are now Off-Duty', 'primary')
    elseif Job and not Job.onduty then
        Player.Functions.SetJobDuty(true)
        QBCore.Functions.Notify(source, 'You are now On-Duty', 'primary')
    end
end)