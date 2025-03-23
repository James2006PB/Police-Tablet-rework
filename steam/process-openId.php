<?php
function p($arr){
    return '<pre>'.print_r($arr,true).'</pre>';
}

require_once $_SERVER['DOCUMENT_ROOT'] . '/config.php';

$params = [
    'openid.assoc_handle' => $_GET['openid_assoc_handle'],
    'openid.signed'       => $_GET['openid_signed'],
    'openid.sig'          => $_GET['openid_sig'],
    'openid.ns'           => 'http://specs.openid.net/auth/2.0',
    'openid.mode'         => 'check_authentication',
];

$signed = explode(',', $_GET['openid_signed']);
    
foreach ($signed as $item) {
    $val = $_GET['openid_'.str_replace('.', '_', $item)];
    $params['openid.'.$item] = stripslashes($val);
}

$data = http_build_query($params);

$context = stream_context_create([
    'http' => [
        'method' => 'POST',
        'header' => "Accept-language: en\r\n".
        "Content-type: application/x-www-form-urlencoded\r\n".
        'Content-Length: '.strlen($data)."\r\n",
        'content' => $data,
    ],
]);


$result = file_get_contents('https://steamcommunity.com/openid/login', false, $context);

if(preg_match("#is_valid\s*:\s*true#i", $result)){
    preg_match('#^https://steamcommunity.com/openid/id/([0-9]{17,25})#', $_GET['openid_claimed_id'], $matches);
    $steamID64 = is_numeric($matches[1]) ? $matches[1] : 0; 

}else{
    echo 'error: unable to validate your request';
    exit();
}

$response = file_get_contents('https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key='.STEAM_API_KEY.'&steamids='.$steamID64);
$response = json_decode($response, true);

if (isset($response['response']['players'][0])) {
    $userData = $response['response']['players'][0];
    $steamHex = 'steam:' . dechex($steamID64);

    $_SESSION["steam_id"] = $steamHex;

    header("Location: /police/pages/profile.php?steamid=" . $steamHex);
    exit();
} else {
    echo 'Error: Unable to retrieve Steam user data.';
    exit();
}