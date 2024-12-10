local Translations = {
    error = {
        ["already_mission"] = "You are already on an NPC Ride",
        ["no_vehicle"] = "You are not in a vehicle",
        ["not_active_meter"] = "Meter is not active",
        ["no_mission_active"] = "You don\'t have a ride to cancel"
    },
    success = {
        ["mission_cancelled"] = "Ride has been cancelled",
    },
    info = {
        ["person_was_dropped_off"] = "Ride Completed!",
        ["npc_on_gps"] = "Drive to the location to pick up a passenger",
        ["go_to_location"] = "Drive to the location to drop off your passenger",
        ["drop_off_npc"] = "[E] Drop-off Passenger",
        ["call_npc"] = "[E] Pick-up Passenger",
        ["blip_name"] = "Jynx HQ",
        ["ride_completed"] = "Ride Completed! Requesting new ride..."
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
