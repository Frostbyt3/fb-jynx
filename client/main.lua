-- Variables

local QBCore = exports['qb-core']:GetCoreObject()

local meterIsOpen = false
local meterActive = false
local lastLocation = nil
local mouseActive = false
local recklessDriving = false
local NpcDuty = false
local PlayerJob = {}
local crashCount = 0

-- used for polyzones
local isInsidePickupZone = false
local isInsideDropZone = false
local Notified = false
local isPlayerInsideZone = false

local meterData = {
    fareAmount = 6,
    currentFare = 0,
    distanceTraveled = 0,
}

local NpcData = {
    Active = false,
    CurrentNpc = nil,
    LastNpc = nil,
    CurrentDeliver = nil,
    LastDeliver = nil,
    Npc = nil,
    NpcBlip = nil,
    DeliveryBlip = nil,
    NpcTaken = false,
    NpcDelivered = false,
    CountDown = 180,
    startingLength = 0,
    distanceLeft = 0
}

-- Events
AddEventHandler('onResourceStart', function(resourceName) -- Check for Resource Starting to prevent bugs when the resource gets restarted
    PlayerJob = QBCore.Functions.GetPlayerData().job
    if Config.UseTarget then
        setupTarget()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() -- Check for Player Loaded Updates
    PlayerJob = QBCore.Functions.GetPlayerData().job
    if Config.UseTarget then
        setupTarget()
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) -- Check for Job Updates
    PlayerJob = JobInfo
end)

local function RemovePed(p) -- RemovePed Function. Deletes the selected NPC
    SetTimeout(60000, function()
        if DoesEntityExist(p) then
            ClearPedTasksImmediately(p)  -- Stop any ongoing tasks
            SetEntityAsNoLongerNeeded(p) -- Mark the ped for cleanup
            DeletePed(p)  -- Safely delete the ped
        end
    end)
end

local function ResetNpcTask() -- Reset NPC Task so that they aren't wanting to fight the player
    if NpcData.Npc and DoesEntityExist(NpcData.Npc) then
        local npc = NpcData.Npc
        local vehicle = GetVehiclePedIsIn(npc, false) -- Get NPC's vehicle

        -- Handle NPC exiting the vehicle
        if vehicle and DoesEntityExist(vehicle) then
            TaskOpenVehicleDoor(npc, vehicle, 1.0)
            Wait(300)
            TaskLeaveVehicle(npc, vehicle, 0) -- Make the NPC leave the vehicle
            Wait(800)
        end

        -- Clear NPC tasks and adjust behavior
        SetEntityAsMissionEntity(NpcData.Npc, false, true)
        SetEntityAsNoLongerNeeded(NpcData.Npc)
        ClearPedTasksImmediately(npc)
        SetPedFleeAttributes(npc, 0, false)
        SetPedCombatAttributes(npc, 46, true)
        SetPedCanBeDraggedOut(npc, false)
        TaskWanderStandard(npc, 10.0, 10) -- Make the NPC wander away rather than run
        Wait(2000)
        SetVehicleDoorsShut(vehicle, false)

        RemovePed(npc)
    end

    NpcData = {
        Active = false,
        CurrentNpc = nil,
        LastNpc = nil,
        CurrentDeliver = nil,
        LastDeliver = nil,
        Npc = nil,
        NpcBlip = nil,
        DeliveryBlip = nil,
        NpcTaken = false,
        NpcDelivered = false,
        startingLength = 0,
        distanceLeft = 0
    }
end

local function resetMeter() -- Reset meter stacks back to 0
    meterData = {
        fareAmount = 6,
        currentFare = 0,
        distanceTraveled = 0,
        startingLength = 0,
        distanceLeft = 0
    }
end

local function IsDriver() -- Check to see if player is the driver
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end

local function DrawText3D(x, y, z, text) -- Draw On Screen Text
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x, y, z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function GetDeliveryLocation() -- Function to grab next dropoff location
    NpcData.CurrentDeliver = math.random(1, #Config.NPCLocations.DropLocations)
    if NpcData.LastDeliver ~= nil then
        while NpcData.LastDeliver ~= NpcData.CurrentDeliver do
            NpcData.CurrentDeliver = math.random(1, #Config.NPCLocations.DropLocations)
        end
    end

    if NpcData.DeliveryBlip ~= nil then
        RemoveBlip(NpcData.DeliveryBlip)
    end
    NpcData.DeliveryBlip = AddBlipForCoord(Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].z)
    SetBlipColour(NpcData.DeliveryBlip, 3)
    SetBlipRoute(NpcData.DeliveryBlip, true)
    SetBlipRouteColour(NpcData.DeliveryBlip, 3)
    NpcData.LastDeliver = NpcData.CurrentDeliver
    if not Config.UseTarget then -- added checks to disable distance checking if polyzone option is used
        CreateThread(function()
            while true and NpcData.Active do
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local dist = #(pos - vector3(Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].z))
                if dist < 25 then
                    DrawMarker(1, Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 245, 66, 156, 255, 0, 0, 0, 1, 0, 0, 0)
                    if dist < 5 then
                        DrawText3D(Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].z, Lang:t('info.drop_off_npc'))
                        if IsControlJustPressed(0, 38) then
                            local veh = GetVehiclePedIsIn(ped, 0)
                            --TaskLeaveVehicle(NpcData.Npc, veh, 0)
                            local targetCoords = Config.NPCLocations.PickupLocations[NpcData.LastNpc]
                            TaskGoStraightToCoord(NpcData.Npc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                            SendNUIMessage({
                                action = 'toggleMeter'
                            })
                            if not recklessDriving then
                                local calcTip = 0
                                if crashCount > 0 then
                                    calcTip = math.ceil(meterData.currentFare / crashCount)
                                else
                                    calcTip = meterData.currentFare
                                end
                                local Tip = math.ceil(calcTip * (Config.tipPercentage / 100))
                                if Tip < 5 then
                                    TriggerServerEvent('fb-jynx:server:NpcPay', meterData.currentFare, false, 5)
                                    TriggerEvent('fb-jynx:client:rideCompleted', 5)
                                else
                                    TriggerServerEvent('fb-jynx:server:NpcPay', meterData.currentFare, false, Tip)
                                    TriggerEvent('fb-jynx:client:rideCompleted', Tip)
                                end
                                TriggerServerEvent('fb-jynx:server:updatesql', math.ceil(meterData.currentFare * 0.03))
                                ResetCrashCount()
                                meterActive = false
                                SendNUIMessage({
                                    action = 'resetMeter'
                                })
                                QBCore.Functions.Notify(Lang:t('ride_completed'), "success")
                                if NpcData.DeliveryBlip ~= nil then
                                    RemoveBlip(NpcData.DeliveryBlip)
                                end
                                ResetNpcTask()
                                recklessDriving = false

                                if NpcDuty then
                                    if Config.DebugCode then QBCore.Functions.Notify('NPCDuty is true', 'debug') end
                                    QBCore.Functions.Notify(Lang:t("ride_completed"), "debug")
                                    if not NpcData.Active then
                                        if Config.DebugCode then QBCore.Functions.Notify('NpcData.Active is false', 'debug') end
                                        TriggerEvent('fb-jynx:client:DoNpcRide')
                                    end
                                end
                                
                                break
                            else
                                local calcTip = 0
                                if crashCount > 0 then
                                    calcTip = math.ceil(meterData.currentFare / crashCount)
                                else
                                    calcTip = meterData.currentFare
                                end
                                local Tip = math.ceil(calcTip * (Config.recklessPercentage / 100)) -- Reckless Driving lowers the tip percentage
                                if Tip < 5 then
                                    TriggerServerEvent('fb-jynx:server:NpcPay', meterData.currentFare, false, 5)
                                    TriggerEvent('fb-jynx:client:rideCompleted', 5)
                                else
                                    TriggerServerEvent('fb-jynx:server:NpcPay', meterData.currentFare, false, Tip)
                                    TriggerEvent('fb-jynx:client:rideCompleted', Tip)
                                end
                                TriggerServerEvent('fb-jynx:server:updatesql', math.ceil(meterData.currentFare * 0.03))
                                ResetCrashCount()
                                meterActive = false
                                SendNUIMessage({
                                    action = 'resetMeter'
                                })
                                --QBCore.Functions.Notify(Lang:t('info.person_was_dropped_off'), 'success')
                                QBCore.Functions.Notify(Lang:t('ride_completed'), "success")
                                if NpcData.DeliveryBlip ~= nil then
                                    RemoveBlip(NpcData.DeliveryBlip)
                                end
                                ResetNpcTask()
                                recklessDriving = false

                                if NpcDuty then
                                    if Config.DebugCode then QBCore.Functions.Notify('NPCDuty is true', 'debug') end
                                    QBCore.Functions.Notify(Lang:t('ride_completed'), "debug")
                                    if not NpcData.Active then
                                        if Config.DebugCode then QBCore.Functions.Notify('NpcData.Active is false', 'debug') end
                                        TriggerEvent('fb-jynx:client:DoNpcRide')
                                    end
                                end

                                break
                            end
                        end
                    end
                end
                Wait(1)
            end
        end)
    end
end

--[[ local function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
    local nearbyEntities = {}
    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        local playerPed = PlayerPedId()
        coords = GetEntityCoords(playerPed)
    end
    for k, entity in pairs(entities) do
        local distance = #(coords - GetEntityCoords(entity))
        if distance <= maxDistance then
            nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
        end
    end
    return nearbyEntities
end ]]

local function calculateFareAmount() -- Canclulating fare amount constantly
    if meterIsOpen and meterActive and not NpcData.NpcTaken then -- For RP purposes
        local startPos = lastLocation
        local newPos = GetEntityCoords(PlayerPedId())
        if startPos ~= newPos then
            local newDistance = #(startPos - newPos)
            lastLocation = newPos
            meterData['distanceTraveled'] += (newDistance / 1609)
            local fareAmount = ((meterData['distanceTraveled']) * Config.Meter['defaultPrice']) + Config.Meter['startingPrice']
            meterData['currentFare'] = math.floor(fareAmount)
            SendNUIMessage({
                action = 'updateMeter',
                meterData = meterData
            })
        end
    end

    if meterIsOpen and meterActive and NpcData.NpcTaken then
        if DoesBlipHaveGpsRoute(NpcData.DeliveryBlip) then
            local startPos = lastLocation
            local newPos = GetEntityCoords(PlayerPedId())
            if startPos ~= newPos then
                lastLocation = newPos
                if NpcData.startingLength == 0 then NpcData.startingLength = GetGpsBlipRouteLength() end -- initial length
                NpcData.distanceLeft = GetGpsBlipRouteLength()                                           -- refresh length as driving
                if GetGpsBlipRouteLength() > NpcData.distanceLeft then return end                        -- check route length against previous route length
                local distanceTraveled = NpcData.startingLength - NpcData.distanceLeft                   -- calculate route progress
                if distanceTraveled < 0 then return end
                meterData['distanceTraveled'] = (distanceTraveled / 1609)
                local fareAmount = ((meterData['distanceTraveled']) * Config.Meter['defaultPrice']) + Config.Meter['startingPrice']
                meterData['currentFare'] = math.floor(fareAmount)
                SendNUIMessage({
                    action = 'updateMeter',
                    meterData = meterData
                })
            end
        end
    end
end

local function ResetCrashCount() -- Reset Crash Count after every NPC Ride
    crashCount = 0
end

RegisterNetEvent('fb-jynx:client:resetMeter', function(source) -- Reset Meter Stats back to 0
    if meterIsOpen then
        if meterActive then
            resetMeter()
            QBCore.Functions.Notify('Meter Reset!', 'success')
        else
            QBCore.Functions.Notify('Your meter must be active', 'error')
        end
    else
        QBCore.Functions.Notify('Your meter must be open', 'error')
    end
end)

function closeMenuFull() -- Close QB-Menu
    exports['qb-menu']:closeMenu()
end

-- Events
RegisterNetEvent('fb-jynx:client:DoNpcRide', function() -- Do an NPC Ride
    if not NpcData.Active then
        NpcData.CurrentNpc = math.random(1, #Config.NPCLocations.PickupLocations) -- Random Pickup Location from config
        if NpcData.LastNpc ~= nil then
            while NpcData.LastNpc ~= NpcData.CurrentNpc do
                NpcData.CurrentNpc = math.random(1, #Config.NPCLocations.PickupLocations) -- Random Pickup Location from config
            end
        end

        local Gender = math.random(1, #Config.NpcSkins)
        local PedSkin = math.random(1, #Config.NpcSkins[Gender])
        local model = GetHashKey(Config.NpcSkins[Gender][PedSkin])
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end
        NpcData.Npc = CreatePed(3, model, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].x, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].y, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].z - 0.98, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].w, true, true)
        PlaceObjectOnGroundProperly(NpcData.Npc)
        FreezeEntityPosition(NpcData.Npc, true)
        if NpcData.NpcBlip ~= nil then
            RemoveBlip(NpcData.NpcBlip)
        end
        QBCore.Functions.Notify(Lang:t('info.npc_on_gps'), 'success')

        -- added checks to disable distance checking if polyzone option is used
        if Config.UseTarget then createNpcPickUpLocation() end

        NpcData.NpcBlip = AddBlipForCoord(Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].x, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].y, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].z)
        SetBlipColour(NpcData.NpcBlip, 3)
        SetBlipRoute(NpcData.NpcBlip, true)
        SetBlipRouteColour(NpcData.NpcBlip, 3)
        NpcData.LastNpc = NpcData.CurrentNpc
        NpcData.Active = true
        -- added checks to disable distance checking if polyzone option is used
        if not Config.UseTarget then
            CreateThread(function()
                while not NpcData.NpcTaken and NpcData.Active do
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    local dist = #(pos - vector3(Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].x, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].y, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].z))

                    if dist < 25 then
                        DrawMarker(0, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].x, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].y, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 255, 1, 0, 0, 1, 0, 0, 0)

                        if dist < 5 then
                            DrawText3D(Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].x, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].y, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].z, Lang:t('info.call_npc'))
                            if IsControlJustPressed(0, 38) then
                                local veh = GetVehiclePedIsIn(ped, 0)
                                local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)
                                local vehHealth = GetVehicleBodyHealth(veh)
                                if vehHealth < 500 then
                                    QBCore.Functions.Notify('I\'m not getting in that thing! Get it repaired!', 'error')
                                    TriggerEvent('fb-jynx:client:CancelNpcRide')
                                    break
                                end

                                for i = maxSeats - 1, 0, -1 do
                                    if IsVehicleSeatFree(veh, i) then
                                        freeSeat = i
                                        break
                                    end
                                end

                                meterIsOpen = true
                                meterActive = true
                                lastLocation = GetEntityCoords(PlayerPedId())
                                SendNUIMessage({
                                    action = 'openMeter',
                                    toggle = true,
                                    meterData = Config.Meter
                                })
                                SendNUIMessage({
                                    action = 'toggleMeter'
                                })
                                resetMeter()
                                ClearPedTasksImmediately(NpcData.Npc)
                                FreezeEntityPosition(NpcData.Npc, false)
                                TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)
                                QBCore.Functions.Notify(Lang:t('info.go_to_location'))
                                if NpcData.NpcBlip ~= nil then
                                    RemoveBlip(NpcData.NpcBlip)
                                end
                                GetDeliveryLocation()
                                NpcData.NpcTaken = true
                            end
                        end
                    end
                    Wait(1)
                end
            end)
        end
    else
        QBCore.Functions.Notify(Lang:t('error.already_mission'))
    end
end)

local rideCount = 0
local totalTips = 0
RegisterNetEvent('fb-jynx:client:rideCompleted') -- This is for future ride tracking
AddEventHandler('fb-jynx:client:rideCompleted', function(tipAmount)
    rideCount = rideCount + 1
    totalTips = totalTips + tipAmount
    SendNUIMessage({
        action = 'updateStats',
        rides = rideCount,
        tips = totalTips
    })
end)

RegisterCommand('jmeter', function(source, args, rawCommand) -- Command to toggle the NUI Meter in case of other means failing
    TriggerEvent('fb-jynx:client:toggleMeter')
end)

RegisterNetEvent('fb-jynx:client:CancelNpcRide', function() -- Cancel Current Ride
    if NpcData.Active then
        NpcData.Active = false
        NpcData.NpcTaken = false
        NpcData.CurrentNpc = nil
        NpcData.LastNpc = nil
        NpcData.CurrentDeliver = nil
        NpcData.LastDeliver = nil

        if NpcData.NpcBlip ~= nil then
            RemoveBlip(NpcData.NpcBlip)
        end
        if NpcData.DeliveryBlip ~= nil then
            RemoveBlip(NpcData.DeliveryBlip)
        end

        ResetNpcTask()

        if meterActive then
            SendNUIMessage({
                action = 'resetMeter'
            })
            SendNUIMessage({
                action = 'toggleMeter'
            })
            meterActive = false
        end

        QBCore.Functions.Notify(Lang:t('success.mission_cancelled'), 'success')

        if NpcDuty then
            TriggerEvent('fb-jynx:client:DoNpcRide')
        end
    else
        QBCore.Functions.Notify(Lang:t('error.no_mission_active'), 'error')
    end
end)

RegisterNetEvent('fb-jynx:client:toggleMeter', function() -- Toggle the NUI Meter On/Off
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        if not meterIsOpen and IsDriver() then
            SendNUIMessage({
                action = 'openMeter',
                toggle = true,
                meterData = Config.Meter
            })
            meterIsOpen = true
        else
            SendNUIMessage({
                action = 'openMeter',
                toggle = false
            })
            meterIsOpen = false
        end
    else
        QBCore.Functions.Notify(Lang:t('error.no_vehicle'), 'error')
    end
end)

RegisterNetEvent('fb-jynx:client:enableMeter', function() -- Show the NUI Meter
    if meterIsOpen then
        SendNUIMessage({
            action = 'toggleMeter'
        })
    else
        QBCore.Functions.Notify(Lang:t('error.not_active_meter'), 'error')
    end
end)

RegisterNetEvent('fb-jynx:client:toggleDuty', function() -- Toggle Duty via the Radial Menu
    if NpcDuty then
        if NpcData.Active then
            QBCore.Functions.Notify('Finish or Cancel your current ride.', 'primary')
        end
        QBCore.Functions.Notify('You are now Off Duty', 'success')
        NpcDuty = false
    else
        QBCore.Functions.Notify('You are now On Duty', 'success')
        NpcDuty = true
        TriggerEvent('fb-jynx:client:DoNpcRide')
    end
end)

-- NUI Callbacks

RegisterNUICallback('enableMeter', function(data, cb)
    meterActive = data.enabled
    if not meterActive then resetMeter() end
    lastLocation = GetEntityCoords(PlayerPedId())
    cb('ok')
end)

RegisterNUICallback('hideMouse', function(_, cb)
    SetNuiFocus(false, false)
    mouseActive = false
    cb('ok')
end)

-- Threads
--[[ CreateThread(function() -- This may or may not be used in a future update
    local TaxiBlip = AddBlipForCoord(Config.BlipLocation)
    SetBlipSprite(TaxiBlip, 198)
    SetBlipDisplay(TaxiBlip, 4)
    SetBlipScale(TaxiBlip, 0.6)
    SetBlipAsShortRange(TaxiBlip, true)
    SetBlipColour(TaxiBlip, 5)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Lang:t('info.blip_name'))
    EndTextCommandSetBlipName(TaxiBlip)
end) ]]

-- Calculate the Fare amount
CreateThread(function()
    while true do
        Wait(2000)
        calculateFareAmount()
    end
end)

-- Disable the meter if the player leaves the vehicle
CreateThread(function()
    while true do
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            if meterIsOpen then
                SendNUIMessage({
                    action = 'openMeter',
                    toggle = false
                })
                meterIsOpen = false
            end
        end
        Wait(200)
    end
end)

-- Reckless Driving Detection Thread
CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            if NpcData.NpcTaken then
                local vehicle = GetVehiclePedIsIn(playerPed, 0)
                local speed = GetEntitySpeed(vehicle) * 2.23694 -- Convert to MPH

                if speed > 85 then
                    recklessDriving = true
                end
            end
        end
    end
end)

-- Crash Detection Thread
CreateThread(function()
    while true do
        Wait(100) -- Check every 100ms for a collision
        local playerPed = PlayerPedId()

        -- Ensure the player is in a vehicle
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, 0)

            -- Check for a collision
            if HasEntityCollidedWithAnything(vehicle) then
                local speed = GetEntitySpeed(vehicle) * 2.23694 -- Convert speed to MPH
                local health = GetEntityHealth(vehicle)
                local coords = GetEntityCoords(vehicle)
                local damage = GetVehicleBodyHealth(vehicle)
                if NpcData.NpcTaken then
                    if speed > 10 and health < 1000 then -- Check speed to not screw over your ride when random NPCs crash into you at a stop light.
                        crashCount = crashCount + 1
                        if Config.DebugCode then
                            print('Crashes: ' .. crashCount)
                            print('Collision Speed: ' .. speed)
                            print('Collision Health: ' .. health)
                            print('Coords = x:' .. coords.x .. ' y:' .. coords.y .. ' z:' .. coords.z)
                            print('Collision Damage: ' .. 1000 - damage)
                        end

                        QBCore.Functions.Notify('Crashes during this ride: ' .. crashCount .. '', 'error')

                        -- Prevent repeated detection for the same collision
                        Wait(1000) -- Wait 5 seconds before detecting again
                    end
                end
            end
        end
    end
end)

-- POLY & TARGET Conversion code

-- setup qb-target
function setupTarget()
    CreateThread(function()
        exports['qb-target']:SpawnPed({
            model = 'a_m_m_indian_01',
            coords = vector4(901.34, -170.06, 74.08, 228.81),
            minusOne = true,
            freeze = true,
            invincible = true,
            blockevents = true,
            animDict = 'abigail_mcs_1_concat-0',
            anim = 'csb_abigail_dual-0',
            flag = 1,
            scenario = 'WORLD_HUMAN_AA_COFFEE',
            target = {
                options = {
                    {
                        type = 'client',
                        event = 'fb-jynx:client:requestcab',
                        icon = 'fas fa-sign-in-alt',
                        label = 'Request Jynx Job',
                    }
                },
                distance = 2.5,
            },
            spawnNow = true,
            currentpednumber = 0,
        })
    end)
end

local zone
local delieveryZone

function createNpcPickUpLocation()
    local PickUpZones = {
        BoxZone:Create(Config.PZLocations.PickupLocations[NpcData.CurrentNpc].coord, Config.PZLocations.PickupLocations[NpcData.CurrentNpc].height, Config.PZLocations.PickupLocations[NpcData.CurrentNpc].width, {
            name = 'PickupZone1',
            heading = Config.PZLocations.PickupLocations[NpcData.CurrentNpc].heading,
            debugPoly = Config.DebugPoly,
            minZ = Config.PZLocations.PickupLocations[NpcData.CurrentNpc].minZ,
            maxZ = Config.PZLocations.PickupLocations[NpcData.CurrentNpc].maxZ,
        }),
        BoxZone:Create(Config.PZLocations.PickupLocations[NpcData.CurrentNpc].coord, Config.PZLocations.PickupLocations[NpcData.CurrentNpc].height, Config.PZLocations.PickupLocations[NpcData.CurrentNpc].width, {
            name = 'PickupZone2',
            heading = Config.PZLocations.PickupLocations[NpcData.CurrentNpc].heading,
            debugPoly = Config.DebugPoly,
            minZ = Config.PZLocations.PickupLocations[NpcData.CurrentNpc].minZ,
            maxZ = Config.PZLocations.PickupLocations[NpcData.CurrentNpc].maxZ,
        })
    }
    zone = ComboZone:Create(PickUpZones, {
        name = "PickupCombo",
         debugPoly = Config.DebugPoly
        })

    zone:onPlayerInOut(function(isPlayerInside)
        if isPlayerInside then
            if not isInsidePickupZone and not NpcData.NpcTaken then
                isInsidePickupZone = true
                exports['qb-core']:DrawText(Lang:t('info.call_npc'), Config.DefaultTextLocation)
                callNpcPoly()
            end
        else
            Citizen.SetTimeout(250, function()
                isInsidePickupZone = false
                exports['qb-core']:HideText()
            end)
        end
    end)
end

function createNpcDelieveryLocation()
    local DropoffZones = {
        BoxZone:Create(Config.PZLocations.DropLocations[NpcData.CurrentDeliver].coord, Config.PZLocations.DropLocations[NpcData.CurrentDeliver].height, Config.PZLocations.DropLocations[NpcData.CurrentDeliver].width, {
            name = "DropoffZone1",
            heading = Config.PZLocations.DropLocations[NpcData.CurrentDeliver].heading,
            debugPoly = Config.DebugPoly,
            minZ = Config.PZLocations.DropLocations[NpcData.CurrentDeliver].minZ,
            maxZ = Config.PZLocations.DropLocations[NpcData.CurrentDeliver].maxZ,
        }),
        BoxZone:Create(Config.PZLocations.DropLocations[NpcData.CurrentDeliver].coord, Config.PZLocations.DropLocations[NpcData.CurrentDeliver].height, Config.PZLocations.DropLocations[NpcData.CurrentDeliver].width, {
            name = "DropoffZone2",
            heading = Config.PZLocations.DropLocations[NpcData.CurrentDeliver].heading,
            debugPoly = Config.DebugPoly,
            minZ = Config.PZLocations.DropLocations[NpcData.CurrentDeliver].minZ,
            maxZ = Config.PZLocations.DropLocations[NpcData.CurrentDeliver].maxZ,
        })
    }
    delieveryZone = ComboZone:Create(DropoffZones, {
        name = "PickupCombo",
         debugPoly = Config.DebugPoly
        })

    delieveryZone:onPlayerInOut(function(isPlayerInside)
        if isPlayerInside then
            if not isInsideDropZone and NpcData.NpcTaken then
                isInsideDropZone = true
                exports['qb-core']:DrawText(Lang:t('info.drop_off_npc'), Config.DefaultTextLocation)
                dropNpcPoly()
            end
        else
            Citizen.SetTimeout(250, function()
                isInsideDropZone = false
                exports['qb-core']:HideText()
            end)
        end
    end)
end

function callNpcPoly()
    CreateThread(function()
        while not NpcData.NpcTaken do
            local ped = PlayerPedId()
            DrawMarker(0, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].x, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].y, Config.NPCLocations.PickupLocations[NpcData.CurrentNpc].z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 245, 66, 156, 255, false, 0, 0, 1, 0, 0, 0)
            if isInsidePickupZone then
                if IsControlJustPressed(0, 38) then
                    exports['qb-core']:KeyPressed()
                    local veh = GetVehiclePedIsIn(ped, 0)
                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)
                    local vehHealth = GetVehicleBodyHealth(veh)
                    local ped = PlayerPedId()
                    local vehLockStatus, curVeh = GetVehicleDoorLockStatus(veh), GetVehiclePedIsIn(ped, false)

                    if vehLockStatus ~= 1 then
                        QBCore.Functions.Notify('Unlock your vehicle first!', 'error')
                        return
                    end

                    if vehHealth < 750 then
                        QBCore.Functions.Notify('I\'m not getting in that thing! Get it repaired!', 'error')
                        TriggerEvent('fb-jynx:client:CancelNpcRide')
                        break
                    end

                    for i = maxSeats - 1, 0, -1 do
                        if IsVehicleSeatFree(veh, i) then
                            freeSeat = i
                            break
                        end
                    end

                    meterIsOpen = true
                    meterActive = true
                    lastLocation = GetEntityCoords(PlayerPedId())
                    SendNUIMessage({
                        action = 'openMeter',
                        toggle = true,
                        meterData = Config.Meter
                    })
                    SendNUIMessage({
                        action = 'toggleMeter'
                    })
                    ClearPedTasksImmediately(NpcData.Npc)
                    FreezeEntityPosition(NpcData.Npc, false)
                    TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)
                    resetMeter()
                    QBCore.Functions.Notify(Lang:t('info.go_to_location'))
                    if NpcData.NpcBlip ~= nil then
                        RemoveBlip(NpcData.NpcBlip)
                    end
                    GetDeliveryLocation()
                    NpcData.NpcTaken = true
                    createNpcDelieveryLocation()
                    zone:destroy()
                end
            end
            Wait(1)
        end
    end)
end

function dropNpcPoly()
    CreateThread(function()
        while NpcData.NpcTaken do
            local ped = PlayerPedId()
            DrawMarker(1, Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DropLocations[NpcData.CurrentDeliver].z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 5.0, 245, 66, 156, 150, 0, 0, 0, 1, 0, 0, 0)

            if isInsideDropZone then
                if IsControlJustPressed(0, 38) then
                    exports['qb-core']:KeyPressed()
                    local veh = GetVehiclePedIsIn(ped, 0)
                    local targetCoords = Config.NPCLocations.PickupLocations[NpcData.LastNpc]
                    TaskGoStraightToCoord(NpcData.Npc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                    SendNUIMessage({
                        action = 'toggleMeter'
                    })
                    if not recklessDriving then
                        local calcTip = 0
                        local bonusTip = math.random(1, 5)
                        if crashCount > 0 then
                            calcTip = math.ceil(meterData.currentFare / crashCount)
                        else
                            calcTip = meterData.currentFare
                        end
                        local Tip = math.ceil(calcTip * (Config.tipPercentage / 100))
                        if Tip < 5 then
                            TriggerServerEvent('fb-jynx:server:NpcPay', meterData.currentFare, false, 5)
                            TriggerEvent('fb-jynx:client:rideCompleted', 5)
                        elseif Config.bonusTipChance then
                            TriggerServerEvent('fb-jynx:server:NpcPay', meterData.currentFare, false, Tip * 2)
                            TriggerEvent('fb-jynx:client:rideCompleted', Tip * 2)
                        else
                            TriggerServerEvent('fb-jynx:server:NpcPay', meterData.currentFare, false, Tip)
                            TriggerEvent('fb-jynx:client:rideCompleted', Tip)
                        end
                        TriggerServerEvent('fb-jynx:server:updatesql', math.ceil(meterData.currentFare * 0.03))
                        ResetCrashCount()
                        meterActive = false
                        SendNUIMessage({
                            action = 'resetMeter'
                        })
                        if NpcData.DeliveryBlip ~= nil then
                            RemoveBlip(NpcData.DeliveryBlip)
                        end
                        ResetNpcTask()
                        delieveryZone:destroy()
                        recklessDriving = false

                        if NpcDuty then
                            QBCore.Functions.Notify(Lang:t("info.ride_completed"), "success")
                            if not NpcData.Active then
                                TriggerEvent('fb-jynx:client:DoNpcRide')
                            end
                        else
                            QBCore.Functions.Notify(Lang:t("info.ride_completed_off_duty"), "success")
                        end

                        break
                    else
                        local calcTip = 0
                        if crashCount > 0 then
                            calcTip = math.ceil(meterData.currentFare / crashCount)
                        else
                            calcTip = meterData.currentFare
                        end
                        local Tip = math.ceil(calcTip * (Config.recklessPercentage / 100)) -- Reckless Driving lowers the tip percentage
                        if Tip < 5 then
                            TriggerServerEvent('fb-jynx:server:NpcPay', meterData.currentFare, false, 5)
                            TriggerEvent('fb-jynx:client:rideCompleted', 5)
                        elseif Config.bonusTipChance then
                            TriggerServerEvent('fb-jynx:server:NpcPay', meterData.currentFare, false, Tip * 2)
                            TriggerEvent('fb-jynx:client:rideCompleted', Tip * 2)
                        else
                            TriggerServerEvent('fb-jynx:server:NpcPay', meterData.currentFare, false, Tip)
                            TriggerEvent('fb-jynx:client:rideCompleted', Tip)
                        end
                        TriggerServerEvent('fb-jynx:server:updatesql', math.ceil(meterData.currentFare * 0.03))
                        ResetCrashCount()
                        meterActive = false
                        SendNUIMessage({
                            action = 'resetMeter'
                        })
                        if NpcData.DeliveryBlip ~= nil then
                            RemoveBlip(NpcData.DeliveryBlip)
                        end
                        ResetNpcTask()
                        delieveryZone:destroy()
                        recklessDriving = false

                        if NpcDuty then
                            QBCore.Functions.Notify(Lang:t("info.ride_completed"), "success")
                            if not NpcData.Active then
                                TriggerEvent('fb-jynx:client:DoNpcRide')
                            end
                        else
                            QBCore.Functions.Notify(Lang:t("info.ride_completed_off_duty"), "success")
                        end

                        break
                    end
                end
            end
            Wait(1)
        end
    end)
end