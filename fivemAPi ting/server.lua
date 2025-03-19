ESX = exports["es_extended"]:getSharedObject()
local ox = exports['ox_lib']
local scanning = false
local policeVehicles = { [`passatmarked`] = true, [`police2`] = true, [`police3`] = true }


function GetWantedVehicles(callback)
    PerformHttpRequest("https://www.avanha.dk/police/pages/anpg.php", function(err, text, headers)
        if err == 200 then
            local vehicles = json.decode(text)
            callback(vehicles)
        else
            print("Fejl ved hentning af eftersøgte biler")
            callback({})
        end
    end, "GET")
end

RegisterNetEvent("esx:playerLoaded", function()
    local playerPed = PlayerPedId()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle and policeVehicles[GetEntityModel(vehicle)] then
                if not scanning then
                    scanning = true
                    ox.notify({ title = "ANPG System", description = "Scanning aktiveret", type = "info", duration = 5000 })
                    StartANPR(vehicle)
                end
            else
                if scanning then
                    scanning = false
                    ox.notify({ title = "ANPG System", description = "ANPG deaktiveret.", type = "warning", duration = 5000 })
                end
            end
        end
    end)
end)

function StartANPR(vehicle)
    Citizen.CreateThread(function()
        while scanning do
            Citizen.Wait(5000)
            if IsPedInAnyPoliceVehicle(PlayerPedId()) then
                local plate = GetVehicleNumberPlateText(vehicle)
                CheckVehicleStatus(plate, vehicle)
            else
                scanning = false
            end
        end
    end)
end

function CheckVehicleStatus(plate, vehicle)
    GetWantedVehicles(function(wantedVehicles)
        for _, v in ipairs(wantedVehicles) do
            if v.plate == plate then
                local coords = GetEntityCoords(vehicle)
                ox.notify({ title = "ANPG Alarm", description = ("🚨 EFTERSØGT KØRETØJ!\nNummerplade: %s\nEjer: %s\nÅrsag: %s"):format(v.plate, v.owner or "Ukendt", v.reason), type = "error", duration = 8000 })
                UpdateLiveTracking(plate, coords)
                return
            end
        end
        ox.notify({ title = "ANPG Scan", description = ("✅ Køretøj %s er rent"):format(plate), type = "success", duration = 5000 })
    end)
end

function UpdateLiveTracking(plate, coords)
    local payload = json.encode({ plate = plate, lat = coords.x, lon = coords.y, time = os.date("%H:%M:%S") })
    PerformHttpRequest("https://www.avanha.dk/police/pages/anpr_live.php", function(err, text, headers) end, "POST", payload, { ["Content-Type"] = "application/json" })
end
