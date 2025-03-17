<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST' && $_GET['endpoint'] == 'duty') {
    $data = json_decode(file_get_contents('php://input'), true);
    $conn = new mysqli("localhost", "root", "password", "avanha_dk_db_drp");

    if ($conn->connect_error) {
        die("Databaseforbindelse fejlet: " . $conn->connect_error);
    }

    foreach ($data['users'] as $identifier => $userData) {
        $sql = "UPDATE users SET isOnDuty = 1 WHERE identifier = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $identifier);
        $stmt->execute();
    }

    echo json_encode(["status" => "success", "message" => "isOnDuty opdateret til 1!"]);
    $conn->close();
}
?>



PerformDutyUpdate = function()
    Citizen.CreateThread(function()
        local url = "http://domain/api.php?endpoint=duty"
        local headers = { ['Content-Type'] = 'application/json' }

        local data = { users = {} }
        local playersInService = exports.esx_service:getInService("police")
        
        for _, source in pairs(playersInService) do
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer then
                data.users[xPlayer.identifier] = {} -- Ingen yderligere data, kun identifier
            end
        end
        
        PerformHttpRequest(url, function(statusCode, text, headers)
            if statusCode == 200 then
                print("isOnDuty opdateret til 1 for alle spillere i tjeneste!")
            else
                print("Fejl ved opdatering af isOnDuty. Status: " .. tostring(statusCode))
            end
        end, 'POST', json.encode(data), headers)
    end)
end



dette er til dem som gider pille ved fleet system dette vil nok blive implatret ordenligt så det virker i en senere opdatering
