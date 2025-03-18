<?php
include '../header.php';

// Sikkerhed for at forhindre uautoriseret adgang
if (!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true) {
    header("location: /police/pages/login.php");
    exit;
}

// Tjek om brugeren er admin
$isAdmin = $_SESSION["websiteadmin"] ?? false;

// Manuelle databaseoplysninger
$db_host = 'mysql87.unoeuro.com'; // Din databasehost (fx localhost)
$db_user = 'avanha_dk';      // Dit databasebrugernavn
$db_pass = '2fegEtnAr9HF5kRzcdbB';          // Din adgangskode til databasen
$db_name = 'avanha_dk_db_drp'; // Navnet på din database

// Opret forbindelse til databasen
$link = new mysqli($db_host, $db_user, $db_pass, $db_name);

// Tjek forbindelsen
if ($link->connect_error) {
    die("Forbindelse til databasen mislykkedes: " . $link->connect_error);
}

// Håndter oprettelse af zoner
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["action"]) && $_POST["action"] == "create") {
    $zoneName = $_POST["zone_name"];
    $zoneType = $_POST["zone_type"];
    $zoneX = $_POST["zone_x"];
    $zoneY = $_POST["zone_y"];

    $sql = "INSERT INTO zones (name, type, x, y) VALUES (?, ?, ?, ?)";
    if ($stmt = $link->prepare($sql)) {
        $stmt->bind_param("ssdd", $zoneName, $zoneType, $zoneX, $zoneY);
        $stmt->execute();
        $stmt->close();
    }
}

// Håndter sletning af zoner
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["action"]) && $_POST["action"] == "delete") {
    $zoneId = $_POST["zone_id"];

    $sql = "DELETE FROM zones WHERE id = ?";
    if ($stmt = $link->prepare($sql)) {
        $stmt->bind_param("i", $zoneId);
        $stmt->execute();
        $stmt->close();
    }
}

// Hent eksisterende zoner fra databasen
$zones = [];
$sql = "SELECT * FROM zones";
if ($result = $link->query($sql)) {
    while ($row = $result->fetch_assoc()) {
        $zones[] = $row;
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Satellit System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #1a1a1a;
            color: white;
            margin: 0;
            padding: 0;
        }

        .satelit-wrapper {
            display: flex;
            flex-direction: row;
            gap: 20px;
            padding: 20px;
        }

        .map-container {
            position: relative;
            width: 70%;
            height: 80vh;
            border: 2px solid #444;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.5);
        }

        .map-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .marker {
            position: absolute;
            width: 15px;
            height: 15px;
            background: red;
            border: 2px solid white;
            border-radius: 50%;
            transform: translate(-50%, -50%);
            cursor: pointer;
        }

        .controls {
            width: 30%;
            padding: 20px;
            background: rgba(0, 0, 0, 0.8);
            color: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.5);
        }

        .controls h3 {
            margin-bottom: 15px;
            font-size: 18px;
        }

        .controls label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .controls input, .controls select, .controls button {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
        }

        .controls button {
            background: #007bff;
            color: white;
            cursor: pointer;
            transition: background 0.3s;
        }

        .controls button:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <main>
        <div class="satelit-wrapper">
            <div class="map-container">
                <img src="https://i.imgur.com/NLsGhdQ.jpeg" alt="GTA Kort" id="gta-map">
                <div id="markers">
                    <?php foreach ($zones as $zone): ?>
                        <div class="marker" 
                             style="left: <?= $zone['x'] ?>%; top: <?= $zone['y'] ?>%;" 
                             title="<?= htmlspecialchars($zone['name']) ?> (<?= htmlspecialchars($zone['type']) ?>)">
                        </div>
                    <?php endforeach; ?>
                </div>
            </div>
            <div class="controls">
                <h3>Kontrolpanel</h3>
                <form method="POST">
                    <input type="hidden" name="action" value="create">
                    <label for="zone-type">Vælg Zone Type:</label>
                    <select name="zone_type" id="zone-type">
                        <option value="visitationszone">Visitationszone</option>
                        <option value="bandehus">Bandehus</option>
                        <option value="andet">Andet</option>
                    </select>
                    <label for="zone-name">Navn på Zone:</label>
                    <input type="text" name="zone_name" id="zone-name" placeholder="Indtast navn" required>
                    <input type="hidden" name="zone_x" id="zone-x">
                    <input type="hidden" name="zone_y" id="zone-y">
                    <button type="submit">Gem Zone</button>
                </form>
                <h3>Eksisterende Zoner</h3>
                <ul>
                    <?php foreach ($zones as $zone): ?>
                        <li>
                            <?= htmlspecialchars($zone['name']) ?> (<?= htmlspecialchars($zone['type']) ?>)
                            <form method="POST" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="zone_id" value="<?= $zone['id'] ?>">
                                <button type="submit" style="background: #e74c3c;">Slet</button>
                            </form>
                        </li>
                    <?php endforeach; ?>
                </ul>
            </div>
        </div>
    </main>

    <script>
        const map = document.getElementById('gta-map');
        const markersContainer = document.getElementById('markers');
        const zoneXInput = document.getElementById('zone-x');
        const zoneYInput = document.getElementById('zone-y');

        map.addEventListener('click', (e) => {
            const rect = map.getBoundingClientRect();
            const x = ((e.clientX - rect.left) / rect.width) * 100;
            const y = ((e.clientY - rect.top) / rect.height) * 100;

            zoneXInput.value = x.toFixed(2);
            zoneYInput.value = y.toFixed(2);

            const marker = document.createElement('div');
            marker.classList.add('marker');
            marker.style.left = `${x}%`;
            marker.style.top = `${y}%`;
            markersContainer.appendChild(marker);
        });
    </script>
</body>
</html>


CREATE TABLE zones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    x DECIMAL(5, 2) NOT NULL,
    y DECIMAL(5, 2) NOT NULL
);