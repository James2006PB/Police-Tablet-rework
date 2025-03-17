<?php
$host = "localhost";
$user = "root";
$password = "password";
$database = "avanha_dk_db_drp";

$conn = new mysqli($host, $user, $password, $database);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] == 'GET' && $_GET['endpoint'] == 'wanted_data') {
    $sql_population = "SELECT phone_number, username FROM population";
    $population_result = $conn->query($sql_population);

    $population = [];
    while ($row = $population_result->fetch_assoc()) {
        $population[$row['phone_number']] = $row['username'];
    }

    $sql_vehicles = "SELECT plate, owner FROM population_vehicles";
    $vehicles_result = $conn->query($sql_vehicles);

    $wanted_vehicles = [];
    while ($row = $vehicles_result->fetch_assoc()) {
        $username = isset($population[$row['owner']]) ? $population[$row['owner']] : "Ukendt";
        $wanted_vehicles[$row['plate']] = $username;
    }

    header('Content-Type: application/json');
    echo json_encode([
        "data" => [
            "population" => $population,
            "population_vehicles" => $wanted_vehicles
        ]
    ]);
    exit();
}
$conn->close();
?>
