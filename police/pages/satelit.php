<?php
include '../header.php';


if($_SESSION["afdeling"] == "Advokatledelse" ) {
    header("location: /police/pages/employed.php");
    exit;
}


$isAdmin = $_SESSION["websiteadmin"] ?? false;


$db_host = ''; // Din databasehost
$db_user = '';          // Dit databasebrugernavn
$db_pass = ''; // Din adgangskode til databasen
$db_name = '';   // Navnet på din database


$link = new mysqli($db_host, $db_user, $db_pass, $db_name);


if ($link->connect_error) {
    die("Forbindelse til databasen mislykkedes: " . $link->connect_error);
}


$vehicles = [];
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["search"])) {
    $searchTerm = $_POST["search_term"];
    $sql = "SELECT * FROM owned_vehicles WHERE plate LIKE ? OR owner LIKE ? OR model LIKE ?";
    if ($stmt = $link->prepare($sql)) {
        $searchTerm = "%$searchTerm%";
        $stmt->bind_param("sss", $searchTerm, $searchTerm, $searchTerm);
        $stmt->execute();
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()) {
            $vehicles[] = $row;
        }
        $stmt->close();
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Køretøjsregister</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #121212; /* Mørk baggrund */
            color: #e0e0e0; /* Lys grå tekst */
            margin: 0;
            padding: 0;
        }

        .register-wrapper {
            width: 90%;
            margin: 40px auto;
            padding: 30px;
            background: #1e1e1e; /* Let mørkere baggrund for kontrast */
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.5); /* Subtil skygge */
        }

        .register-wrapper h1 {
            text-align: center;
            margin-bottom: 30px;
            color: #ffffff; /* Hvid tekst */
            font-size: 2rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .search-form {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
        }

        .search-form input[type="text"] {
            width: 60%;
            padding: 10px;
            border: 1px solid #333; /* Subtil kant */
            border-radius: 5px;
            font-size: 16px;
            background: #1e1e1e; /* Samme som wrapper */
            color: #e0e0e0;
            outline: none;
            transition: border-color 0.3s ease;
        }

        .search-form input[type="text"]:focus {
            border-color: #555; /* Let lysere kant ved fokus */
        }

        .search-form button {
            padding: 10px 20px;
            margin-left: 10px;
            border: none;
            border-radius: 5px;
            background: #333; /* Neutral mørk knap */
            color: #e0e0e0;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .search-form button:hover {
            background: #444; /* Let lysere ved hover */
        }

        .vehicle-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: #1e1e1e; /* Samme som wrapper */
            border-radius: 5px;
            overflow: hidden;
        }

        .vehicle-table th, .vehicle-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #333; /* Subtil linje mellem rækker */
        }

        .vehicle-table th {
            background: #333; /* Mørk baggrund til overskrifter */
            color: #e0e0e0;
            text-transform: uppercase;
            font-size: 14px;
        }

        .vehicle-table tr:nth-child(even) {
            background: #1a1a1a; /* Let mørkere baggrund for hver anden række */
        }

        .vehicle-table tr:hover {
            background: #2a2a2a; /* Lysere baggrund ved hover */
        }

        .vehicle-thumbnail {
            width: 100px;
            height: auto;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.5); /* Subtil skygge */
        }

        .no-results {
            text-align: center;
            color: #888; /* Lys grå tekst */
            margin-top: 20px;
            font-size: 18px;
        }

        @media (max-width: 768px) {
            .search-form input[type="text"] {
                width: 100%;
            }

            .search-form button {
                width: 100%;
                margin-top: 10px;
            }

            .vehicle-table th, .vehicle-table td {
                font-size: 14px;
                padding: 10px;
            }

            .vehicle-thumbnail {
                width: 80px;
            }
        }
    </style>
</head>
<body>
    <div class="register-wrapper">
        <h1>Køretøjsregister</h1>
        <form method="POST" class="search-form">
            <input type="text" name="search_term" placeholder="Søg efter nummerplade, ejer eller model..." required>
            <button type="submit" name="search">Søg</button>
        </form>

        <?php if (!empty($vehicles)): ?>
            <table class="vehicle-table">
                <thead>
                    <tr>
                        <th>Nummerplade</th>
                        <th>Ejer</th>
                        <th>Model</th>
                        <th>Status</th>
                        <th>Billede</th>
                        <th>Beskrivelse</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($vehicles as $vehicle): ?>
                        <tr>
                            <td><?= htmlspecialchars($vehicle['plate']) ?></td>
                            <td><?= htmlspecialchars($vehicle['owner']) ?></td>
                            <td><?= htmlspecialchars($vehicle['model']) ?></td>
                            <td><?= $vehicle['impounded'] ? 'Beslaglagt' : ($vehicle['parked'] ? 'Parkeret' : 'I brug') ?></td>
                            <td>
                                <img src="<?= htmlspecialchars($vehicle['thumbnail']) ?>" alt="Thumbnail" class="vehicle-thumbnail">
                            </td>
                            <td><?= htmlspecialchars($vehicle['mdt_description'] ?? 'Ingen beskrivelse') ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php else: ?>
            <p class="no-results">Ingen køretøjer fundet.</p>
        <?php endif; ?>
    </div>
</body>
</html>