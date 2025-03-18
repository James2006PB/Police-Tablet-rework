<?php
// Databaseforbindelse
$db_host = ''; // Din databasehost
$db_user = '';      // Dit databasebrugernavn
$db_pass = '';          // Din adgangskode til databasen
$db_name = '';  // Navnet på din database

$link = new mysqli($db_host, $db_user, $db_pass, $db_name);

// Tjek forbindelsen
if ($link->connect_error) {
    http_response_code(500);
    die(json_encode(["error" => "Forbindelse til databasen mislykkedes: " . $link->connect_error]));
}

// Modtag data fra FiveM
$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['plate'], $data['owner'], $data['model'], $data['status'], $data['thumbnail'], $data['description'])) {
    $plate = $data['plate'];
    $owner = $data['owner'];
    $model = $data['model'];
    $status = $data['status'];
    $thumbnail = $data['thumbnail'];
    $description = $data['description'];

    // Gem data i databasen
    $sql = "INSERT INTO owned_vehicles (plate, owner, model, stored, thumbnail, mdt_description) 
            VALUES (?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE owner = VALUES(owner), model = VALUES(model), stored = VALUES(stored), thumbnail = VALUES(thumbnail), mdt_description = VALUES(mdt_description)";
    if ($stmt = $link->prepare($sql)) {
        $stmt->bind_param("ssssss", $plate, $owner, $model, $status, $thumbnail, $description);
        if ($stmt->execute()) {
            http_response_code(200);
            echo json_encode(["success" => "Data gemt med succes."]);
        } else {
            http_response_code(500);
            echo json_encode(["error" => "Kunne ikke gemme data."]);
        }
        $stmt->close();
    } else {
        http_response_code(500);
        echo json_encode(["error" => "Kunne ikke forberede forespørgslen."]);
    }
} else {
    http_response_code(400);
    echo json_encode(["error" => "Ugyldige data modtaget."]);
}
?>