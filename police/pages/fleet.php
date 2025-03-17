<?php 
include '../header.php';

// Sikkerhed for at forhindre advokater at tilgå denne side.
if($_SESSION["afdeling"] == "Advokatledelse" ) {
    header("location: /police/pages/employed.php");
    exit;
}

$fleet_categories = [
    'betjent' => 'Ukategoriseret',
    'betjent' => 'Almen',
    'mc' => 'Motorcykel',
    'lima' => 'Indsatsleder',
    'helikopter' => 'Helikopter',
    'civil' => 'Civil',
    'krim_kriminalteknisk_afdeling' => 'KRIM (Kriminalteknisk afdeling)',
    'romeo_reaktionsenheden' => 'Romeo (Reaktionsenheden)',
    'bankrobbery' => 'Bankrøveri',
    'training' => 'Træning',
    'razzia' => 'Razzia',
];

$fleet_custom_categories = [
    'bankrobbery' => true,
    'training' => true,
    'razzia' => true,
    'helikopter' => true,
];

$fleet_extra_permissions = [
    'lima-a' => 'lima',
];

$adminPermissions = [
    'lima' => true,
    'lima-a' => true,
    'alarmoperatør' => true,
];

if(isset($_GET['user'])) {
    if(isset($_GET['move'])) {
        $sql = "UPDATE users SET patrol_category = ? WHERE id = ?";

        if($stmt = mysqli_prepare($link, $sql)){
            mysqli_stmt_bind_param($stmt, "si", $param_category, $param_id);

            $param_category = $_GET['move'];
            $param_id = $_GET['user'];
            
            if(mysqli_stmt_execute($stmt)) {
                header("location: fleet.php");
            } else{
                echo "Something went wrong. Please try again later. <br>";
                printf("Error message: %s\n", $link->error);
            }
        }
        
        mysqli_stmt_close($stmt);
    }

    if(isset($_GET['remove'])) {
        $sql = "UPDATE users SET patrol_category = ? WHERE id = ?";

        if($stmt = mysqli_prepare($link, $sql)){
            mysqli_stmt_bind_param($stmt, "si", $param_category, $param_id);

            $param_category = NULL;
            $param_id = $_GET['user'];
            
            if(mysqli_stmt_execute($stmt)) {
                header("location: fleet.php");
            } else{
                echo "Something went wrong. Please try again later. <br>";
                printf("Error message: %s\n", $link->error);
            }
        }
        
        mysqli_stmt_close($stmt);
    }

    if(isset($_GET['comment']) && isset($_GET['option'])) {
        $task = $_GET['comment'];
        if ($_GET['comment'] == '') {
            $task = $_GET['option'];
        }

        $sql = "UPDATE users SET patrol_task = ? WHERE id = ?";

        if($stmt = mysqli_prepare($link, $sql)){
            mysqli_stmt_bind_param($stmt, "si", $param_comment, $param_id);

            $param_comment = $task;
            $param_id = $_GET['user'];
            
            if(mysqli_stmt_execute($stmt)) {
                header("location: fleet.php");
            } else{
                echo "Something went wrong. Please try again later. <br>";
                printf("Error message: %s\n", $link->error);
            }
        }
        
        mysqli_stmt_close($stmt);
    }
}

function makeKeyFriendly($string) {
    $string = strtolower($string);
    $string = str_replace(' ', '_', $string);
    $string = preg_replace('/[^A-Za-z0-9_]/', '', $string);
    return $string;
}

function formatLicense($licenses, $categories, $current, $custom_categories, $extra_permissions) {
    if(!is_array($licenses)) return array();

    $formated_licenses = array();
    foreach($licenses as $name => $license) {
        if(!is_array($license)) continue;

        $temp_licenses = array();
        foreach($license as $name) {
            $name = makeKeyFriendly($name);

            if (!(isset($current) && $name == $current)) {
                if (isset($categories[$name])) {
                    $label = $categories[$name];
                    $formated_licenses[$name] = $label;
                }

                if (!isset($categories[$name]) && isset($extra_permissions[$name])) {
                    $category_name = $extra_permissions[$name];
                    $label = $categories[$category_name];
                    $formated_licenses[$category_name] = $label;
                }
            }
        }
    }

    foreach($custom_categories as $name => $value) {
        if (!(isset($current) && $name == $current)) {
            $label = $categories[$name];
            $formated_licenses[$name] = $label;
        }
    }

    asort($formated_licenses);

    return $formated_licenses;
}

$processedAdminPermissions = [];
foreach($adminPermissions as $key => $value) {
    $processedKey = makeKeyFriendly($key);
    $processedAdminPermissions[$processedKey] = $value;
}

function hasAdminPermissions($id) {
    global $processedAdminPermissions;
    $licenses = json_decode($_SESSION["licenses"], true);
    
    foreach($licenses as $license) {
        if(!is_array($license)) continue;

        foreach($license as $name) {
            $processedName = makeKeyFriendly($name);
            if (isset($processedAdminPermissions[$processedName])) {
                return true;
            }
        }
    }
    
    return $id == $_SESSION["id"] || $_SESSION["websiteadmin"];
}

$stmt = $link->prepare("SELECT * FROM users where isOnDuty = 1 ORDER BY (patrol_id IS NULL), patrol_id ASC, username ASC");
$stmt->execute();
$result = $stmt->get_result();

$users = array();
if($result->num_rows > 0){
    while($row = $result->fetch_assoc()) {
        $users[] = $row;
    }
}

$categorized = array();
foreach($fleet_categories as $key => $value) {
    $license_emne = makeKeyFriendly($key);
    $categorized[$license_emne] = array();
}


if(isset($_GET['user'])) {
    if(isset($_GET['move'])) {
        $sql = "UPDATE users SET patrol_category = ? WHERE id = ?";

        if($stmt = mysqli_prepare($link, $sql)){
            mysqli_stmt_bind_param($stmt, "si", $param_category, $param_id);

            $param_category = $_GET['move'];
            $param_id = $_GET['user'];
            
            if(mysqli_stmt_execute($stmt)) {
                header("location: fleet.php");
            } else{
                echo "Something went wrong. Please try again later. <br>";
                printf("Error message: %s\n", $link->error);
            }
        }
        
        mysqli_stmt_close($stmt);
    }
  if (isset($_GET['user']) && isset($_GET['patrol_id'])) {
    $sql = "UPDATE users SET patrol_id = ? WHERE id = ?";

    if ($stmt = mysqli_prepare($link, $sql)) {
        mysqli_stmt_bind_param($stmt, "ii", $param_patrol_id, $param_id);

        $param_patrol_id = $_GET['patrol_id']; 
        $param_id = $_GET['user']; 

        if (mysqli_stmt_execute($stmt)) {
            header("location: fleet.php");
        } else {
            echo "Der opstod en fejl ved opdatering af patruljenummer. Prøv igen senere.<br>";
            printf("Fejlbesked: %s\n", $link->error);
        }
    }

    mysqli_stmt_close($stmt);
}

$uncategorized = array();
foreach($users as $user) {
    $patrol_category = $user['patrol_category'];
    if($patrol_category == NULL) {
        $uncategorized[] = $user;
    }

    if (isset($categorized[$patrol_category])) {
        $categorized[$patrol_category][] = $user;
    }
}

foreach($categorized as $patrol_category => &$users) {
    usort($users, function($a, $b) {
        if ($a['patrol_id'] === $b['patrol_id']) {
            return 0;
        }
        if ($a['patrol_id'] === NULL) {
            return 1;
        }
        if ($b['patrol_id'] === NULL) {
            return -1;
        }
        return ($a['patrol_id'] < $b['patrol_id']) ? -1 : 1;
    });
}
unset($users);

$extra_permissions = array();
foreach($fleet_extra_permissions as $key => $value) {
    $license_emne = makeKeyFriendly($key);
    $license_name = makeKeyFriendly($value);
    $extra_permissions[$license_emne] = $license_name;
}

echo "<main>";
    echo "<div class='fleet-wrapper'>";
        echo "<div class='fleet-uncategorized'>";
            echo "<h1>Uden for tjeneste (" . sizeof($uncategorized) . ")</h1>";
            echo "<div class='fleet-uncategorized-list'>";
                foreach($uncategorized as $user) {
                    $licenses = json_decode($user['licenses'], true);
                    $formated_licenses = formatLicense($licenses, $fleet_categories, NULL, $fleet_custom_categories, $extra_permissions);

                    echo "<div class='fleet-user-container'>";
                        echo "<div class='fleet-user-informations'>";
                            echo "<div class='fleet-user-info'>";
                                echo '<i class="fa-solid fa-user"></i>';
                                echo $user["username"] . " " . $user["firstname"] . " " . $user["lastname"] . " (" . $user['nickname'] . ")";
                            echo "</div>";

                            if ($user["patrol_task"] != NULL && $user["patrol_task"] != "") {
                                echo "<div class='fleet-user-task'>";
                                    echo '<i class="fa-solid fa-bars-progress"></i><p>';
                                    echo $user["patrol_task"];
                                echo "</p></div>";
                            }

                            if ($user["patrol_id"] != NULL) {
                                echo "<div class='fleet-user-patrol'>";
                                    echo '<i class="fa-solid fa-car"></i>';
                                    echo "Patrulje nummer: " . $user["patrol_id"];
                                echo "</div>";
                            }
                        echo "</div>";
                        echo "<div class='fleet-user-icons'>";
                            if (hasAdminPermissions($user["id"])) {
                                echo '<button class="hoverBtn">';
                                    echo '<i class="fa-solid fa-list"></i>';
                                    echo '<div class="fleet-user-icons-content">';
                                        foreach($formated_licenses as $name => $license) {
                                            echo "<a href='fleet.php?user=" . $user['id'] . "&move=" . $name . "'>" . $license . "</a>";
                                        }
                                    echo '</div>';
                                echo '</button>';
                                echo '<button onclick="addCustomPlayerTask(' . $user['id'] . ')"><i class="fa-solid fa-pen-to-square"></i></button>';
                            }
                        echo "</div>";
                    echo "</div>";
                }
            echo "</div>";
        echo "</div>";

        echo "<div class='fleet-categorized'>";
            foreach($categorized as $key => $category_users) {
                $category_label = $fleet_categories[$key];

                echo "<div class='fleet-category' id='" . $key . "'>";
                    echo "<h1>" . $category_label . " (" . sizeof($category_users) . ")</h1>";
                    echo "<div class='fleet-categorized-list'>";
                        foreach($category_users as $user) {
                            $licenses = json_decode($user['licenses'], true);
                            $formated_licenses = formatLicense($licenses, $fleet_categories, $key, $fleet_custom_categories, $extra_permissions);

                            echo "<div class='fleet-user-container'>";
                                echo "<div class='fleet-user-informations'>";
                                    echo "<div class='fleet-user-info'>";
                                        echo '<i class="fa-solid fa-user"></i>';
                                        echo $user["username"] . " " . $user["firstname"] . " " . $user["lastname"] . " (" . $user["nickname"] . ")";
                                    echo "</div>";

                                    if ($user["patrol_task"] != NULL && $user["patrol_task"] != "") {
                                        echo "<div class='fleet-user-task'><p>";
                                            echo '<i class="fa-solid fa-bars-progress"></i>';
                                            echo $user["patrol_task"];
                                        echo "</p></div>";
                                    }

                                    if ($user["patrol_id"] != NULL) {
                                        echo "<div class='fleet-user-patrol'>";
                                            echo '<i class="fa-solid fa-car"></i>';
                                            echo "Patrulje nummer: " . $user["patrol_id"];
                                        echo "</div>";
                                    }
                                echo "</div>";
                                echo "<div class='fleet-user-icons'>";
                                    if (hasAdminPermissions($user["id"])) {
                                        echo '<button class="hoverBtn">';
                                            echo '<i class="fa-solid fa-list"></i>';
                                            echo '<div class="fleet-user-icons-content">';
                                                foreach($formated_licenses as $name => $license) {
                                                    echo "<a href='fleet.php?user=" . $user['id'] . "&move=" . $name . "'>" . $license . "</a>";
                                                }
                                            echo '</div>';
                                        echo '</button>';
                                        echo '<button onclick="addCustomPlayerTask(' . $user['id'] . ')"><i class="fa-solid fa-pen-to-square"></i></button>';
                                        echo '<a href="fleet.php?user=' . $user["id"] . '&remove=true"><i class="fa-solid fa-xmark"></i></a>';
                                    }
                                echo "</div>";
                            echo "</div>";
                        }
                    echo "</div>";
                echo "</div>";
            }
        echo "</div>";
    echo "</div>";
?>

<script type="text/javascript">
function addCustomPlayerTask(id) {
    (async () => {
        const { value: formValues } = await Swal.fire({
            title: 'Indtast opgave',
            html:
                '<input id="swal-input1" class="swal2-input" placeholder="Opgave">' +
                '<select id="swal-input2" class="swal2-input">' +
                    '<option value="">Eller vælg en opgave</option>' +
                    '<option value="Skyderi">Skyderi</option>' +
                    '<option value="Trafikstop">Trafikstop</option>' +
                    '<option value="Eftersættelse">Eftersættelse</option>' +
                    '<option value="Butikstyveri">Butikstyveri</option>' +
                    '<option value="Pengetransporter">Pengetransporter</option>' +
                    '<option value="Mistænkelig adfærd">Mistænkelig adfærd</option>' +
                    '<option value="Fangetransport">Fangetransport</option>' +
                    '<option value="Narkoopkald">Narkoopkald</option>' +
                    '<option value="ATK">ATK</option>' +
                    '<option value="Afhøring">Afhøring</option>' +
                    '<option value="Kontorarbejde">Kontorarbejde</option>' +
                '</select>',
            focusConfirm: false,
            preConfirm: () => {
                return [
                    document.getElementById('swal-input1').value,
                    document.getElementById('swal-input2').value
                ]
            },
            showCancelButton: true
        });

        if (formValues) {
            const [comment, option] = formValues;
            window.location.href = "fleet.php?user=" + id + "&comment=" + encodeURIComponent(comment) + "&option=" + encodeURIComponent(option);
        }
    })();
}
</script>


<div class="professional-form-container">
    <style>
        .professional-form-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            padding: 20px;
            background: #3a3f44; 
            border-radius: 12px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            max-width: 95%%;
            margin: 0 auto;
            font-family: 'Arial', sans-serif;
        }

        .professional-form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        label {
            font-weight: bold;
            font-size: 1.1rem;
            color: #fff; 
            display: flex;
            align-items: center;
            gap: 8px;
        }

        input[type="text"], select, input[type="number"] {
            font-size: 1rem;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            width: 100%;
            background-color: #2e3338; 
            color: #fff; 
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease-in-out;
        }

        input[type="text"]:focus, select:focus, input[type="number"]:focus {
            border-color: #4caf50; 
            box-shadow: 0 0 5px rgba(76, 175, 80, 0.5);
            outline: none;
        }

        .btn {
            padding: 12px 20px;
            font-size: 1rem;
            font-weight: bold;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .btn-update {
            background-color: #4caf50; 
            color: white;
        }

        .btn-update:hover {
            background-color: #45a049;
            transform: scale(1.05);
        }

        .btn-move {
            background-color: #007bff; 
            color: white;
        }

        .btn-move:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }

        button i {
            margin-right: 8px;
        }

        
        .form-group > label i {
            color: #4caf50; 
        }
    </style>

    
    <form method='GET' action='fleet.php' class="professional-form">
        <div class="form-group">
            <label for='patrol_id'>
                <i class="fa-solid fa-car"></i> Patruljenummer
            </label>
            <input 
                type='text' 
                id='patrol_id' 
                name='patrol_id' 
                value='<?php echo htmlspecialchars($user['patrol_id']); ?>' 
                placeholder="Indtast ID (bogstaver og tal)"
                class="form-input" 
                pattern="[A-Za-z0-9\-]+" 
                title="Kun bogstaver, tal og bindestreger er tilladt.">
        </div>
        <input type='hidden' name='user' value='<?php echo $user['id']; ?>'>
        <button type='submit' class="btn btn-update">
            <i class="fa-solid fa-check"></i> Opdater
        </button>
    </form>

 
    <form method='GET' action='fleet.php' class="professional-form">
        <div class="form-group">
            <label for='category_change'>
                <i class="fa-solid fa-list-alt"></i> Flyt til kategori
            </label>
            <select id='category_change' name='category_change' class="form-select">
                <?php
                foreach ($fleet_categories as $key => $category) {
                    $selected = $key === $user['patrol_category'] ? "selected" : "";
                    echo "<option value='" . $key . "' " . $selected . ">" . $category . "</option>";
                }
                ?>
            </select>
        </div>
        <input type='hidden' name='user' value='<?php echo $user['id']; ?>'>
        <button type='submit' class="btn btn-move">
            <i class="fa-solid fa-arrow-right"></i> Flyt
        </button>
    </form>
</div>



<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>

    document.querySelector('.btn-update').addEventListener('click', function(e) {
        e.preventDefault(); 

        Swal.fire({
            title: 'Bekræft Opdatering',
            text: 'Er du sikker på, at du vil opdatere patruljenummeret?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: 'Ja, opdater!',
            cancelButtonText: 'Annuller',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                e.target.closest('form').submit(); 
            }
        });
    });


    document.querySelector('.btn-move').addEventListener('click', function(e) {
        e.preventDefault(); 

        Swal.fire({
            title: 'Bekræft Flytning',
            text: 'Er du sikker på, at du vil flytte til denne kategori?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: 'Ja, flyt!',
            cancelButtonText: 'Annuller',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                e.target.closest('form').submit(); 
            }
        });
    });
</script>




<?php
echo "</main>";

include '../footer.php'; 
?>