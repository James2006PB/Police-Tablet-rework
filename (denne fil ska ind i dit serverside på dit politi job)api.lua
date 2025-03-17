PerformWantedFunction = function()
    Citizen.CreateThread(function()
        local url = "http://localhost/api2.php?endpoint=wanted_data"
        PerformHttpRequest(url, function(statusCode, text, headers)
            if statusCode ~= 200 then return end
            local response = json.decode(text)
            wantedVehicles = response.data.population_vehicles
            TriggerClientEvent("drp_policejob:collectWantedPlates", -1, wantedVehicles)
        end, 'GET', '', {})
    end)
end



//dette script vil kun virke hvis i bruger drps/savanhas politi job