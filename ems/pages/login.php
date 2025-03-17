<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/config.php';
 
// Check if the user is already logged in, if yes then redirect him to welcome page
if(isset($_SESSION["loggedin"]) && $_SESSION["loggedin"] === true){
    header("location: employed.php");
    exit;
}
 
// Define variables and initialize with empty values
$username = $password = "";
$username_err = $password_err = "";
$afdeling_err = "";
 
// Processing form data when form is submitted
if($_SERVER["REQUEST_METHOD"] == "POST"){
 
    // Check if username is empty
    if(empty(trim($_POST["username"]))){
        $username_err = "Please enter username.";
    } else{
        $username = trim($_POST["username"]);
    }
    
    if(empty(trim($_POST["password"]))){
        $password_err = "Please enter your password.";
    } else{
        $password = trim($_POST["password"]);
    }
    
    if(empty($username_err) && empty($password_err) && empty($afdeling_err)){
        $sql = "SELECT id, username, password, firstname, lastname, job, WebsiteAdmin, role, afdeling, hasPsykologAccess FROM users_ems WHERE username = ?";
        
        if($stmt = mysqli_prepare($link, $sql)){
            mysqli_stmt_bind_param($stmt, "s", $param_username);
            
            $param_username = $username;
            
            if(mysqli_stmt_execute($stmt)) {
                mysqli_stmt_store_result($stmt);
                
                if(mysqli_stmt_num_rows($stmt) == 1) {                  
                    mysqli_stmt_bind_result($stmt, $id, $username, $hashed_password, $firstname, $lastname, $job, $WebsiteAdmin, $role, $afdeling, $hasPsykologAccess);
                    if(mysqli_stmt_fetch($stmt)) {
                        if(password_verify($password, $hashed_password)) {
                            session_start();
                                
                            $_SESSION["loggedin"] = true;
                            $_SESSION["id"] = $id;
                            $_SESSION["username"] = $username;
                            $_SESSION["role"] = $role;
                            $_SESSION["afdeling"] = $afdeling;
                            $_SESSION["websiteadmin"] = $WebsiteAdmin;
                            $_SESSION["hasPsykologAccess"] = $hasPsykologAccess;
                            $_SESSION["firstname"] = $firstname;
                            $_SESSION["lastname"] = $lastname;

                            $_SESSION["job"] = 'ems';
                            
                            header("location: employed.php");
                        } else{
                            $password_err = "Det indtastede kodeord er ikke korrekt.";
                        }
                    }
                } else {
                    $username_err = "Ingen konto blev fundet med det nummer";
                }
            } else{
                echo "Oops! Der gik noget galt. Prøv venligst igen senere.";
            }
        }
        
        // Close statement
        mysqli_stmt_close($stmt);
    }
    
    // Close connection
    mysqli_close($link);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>

    <link rel="shortcut icon" type="image/png" href="../../assets/img/logo.png"/>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" href="../../assets/css/police.css?v=3.0">
</head>
<body>
    <div class="login-form">
        <div class="wrapper">
            <img src="../../assets/img/logo_stort.png" alt="logo">
            <h2>Login</h2>
            <?php echo (!empty($afdeling_err)) ? '<p class="error">Du prøver at logge på den forkerte afdeling' : ''; ?>
            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
                <div class="form-group <?php echo (!empty($username_err)) ? 'has-error' : ''; ?>">
                    <label>Badge nummer</label>
                    <input type="text" name="username" class="form-control" value="<?php echo $username; ?>">
                    <span class="help-block"><?php echo $username_err; ?></span>
                </div>    
                <div class="form-group <?php echo (!empty($password_err)) ? 'has-error' : ''; ?>">
                    <label>Kodeord</label>
                    <input type="password" name="password" class="form-control">
                    <span class="help-block"><?php echo $password_err; ?></span>
                </div>
                <div class="form-group" id="submit">
                    <input type="submit" class="btn btn-primary" value="Login">
                </div>
            </form>
        </div>
        <div class="text-center mt-4">
            <a href="../../" class="btn btn-primary">Tilbage til start</a>
        </div>
    </div>
    <div class="front-page-footer">
        <h1>Provided and made alive by Stausi</h1>
    </div>
</body>
</html>