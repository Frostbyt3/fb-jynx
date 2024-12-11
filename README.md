# fb-jynx
A ridesharing service for QBCore similar to Uber/Lyft. More information to come.

If you're using qb-radialmenu, add this to the config.lua:
```['jynx'] = {
        {
            id = 'toggle_meter',
            title = 'Show/Hide Meter',
            icon = 'eye-slash',
            type = 'client',
            event = 'fb-jynx:client:toggleMeter',
            shouldClose = false
        }, {
            id = 'startstopmeter',
            title = 'Start/Stop Meter',
            icon = 'hourglass-start',
            type = 'client',
            event = 'fb-jynx:client:enableMeter',
            shouldClose = true
        }, {
            id = 'npc_ride',
            title = 'Toggle NPC Rides',
            icon = 'taxi',
            type = 'client',
            event = 'fb-jynx:client:toggleDuty',
            shouldClose = true
        }, {
            id = 'resetmeter',
            title = 'Reset Meter',
            icon = 'stopwatch',
            type = 'client',
            event = 'fb-jynx:client:resetMeter',
            shouldClose = true
        }, {
            id = 'cancelride',
            title = 'Cancel NPC Ride',
            icon = 'xmark',
            type = 'client',
            event = 'fb-jynx:client:CancelNpcRide',
            shouldClose = true
        }
    }```