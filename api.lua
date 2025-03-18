local apiUrl = "https://din-hjemmeside.dk/police/pages/vehicle_register.php" -- URL til din PHP API


function fetchVehicleData()
    local vehicles = {}


    local result = MySQL.Sync.fetchAll("SELECT plate, owner, model, parked, impounded, thumbnail, mdt_description FROM owned_vehicles")
    if result then
        for _, row in ipairs(result) do
            table.insert(vehicles, {
                plate = row.plate,
                owner = row.owner or "Ukendt",
                model = row.model or "Ukendt",
                status = row.impounded == 1 and "Beslaglagt" or (row.parked == 1 and "Parkeret" or "I brug"),
                thumbnail = row.thumbnail or "https://www.auto123.com/static/auto123/images/unknown.692d9ec5c563.png",
                description = row.mdt_description or "Ingen beskrivelse"
            })
        end
    end

    return vehicles
end


function sendVehicleData()
    local vehicles = fetchVehicleData()

    for _, vehicle in ipairs(vehicles) do
        PerformHttpRequest(apiUrl, function(statusCode, response, headers)
            if statusCode == 200 then
                print("Data sendt til API med succes for køretøj: " .. vehicle.plate)
            else
                print("Fejl ved afsendelse af data for køretøj: " .. vehicle.plate .. " - Statuskode: " .. statusCode)
            end
        end, "POST", json.encode(vehicle), { ["Content-Type"] = "application/json" })
    end
end

-- Kør funktionen automatisk hver 5. minut
Citizen.CreateThread(function()
    while true do
        sendVehicleData()
        Citizen.Wait(300000) -- 300.000 millisekunder = 5 minutter
    end
end)