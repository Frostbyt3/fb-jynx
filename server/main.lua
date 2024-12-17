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

RegisterNetEvent('fb-jynx:server:updatesql', function(feeJynx) -- Slip the creators of this script a little something
    local JYNX_BANK_ID = Config.AccountNumber

    if feeJynx == 0 then return end

    MySQL.update('UPDATE ps_banking_accounts SET balance = balance + ? WHERE id = ?', { feeJynx, JYNX_BANK_ID })
    TriggerClientEvent('QBCore:Notify', src, 'ps_banking_accounts row with: ' .. JYNX_BANK_ID .. ' updated with: ' .. feeJynx, 'debug')
end)