<?php
header('Content-Type: application/json');

$db_pass = getenv('DB_PASSWORD');
$has_secret = !empty($db_pass);

$response = [
    "status"      => "healthy",
    "timestamp"   => gmdate("Y-m-d\TH:i:s\Z"),
    "application" => "Azure Cloud Platform Workload",
    "version"     => "1.2.0",
    "environment" => getenv('APP_ENV') ?: 'production',
    "secrets_engine" => [
        "key_vault_connected" => $has_secret,
        "db_secret_status" => $has_secret ? "retrieved" : "not found"
    ]
];

http_response_code(200);
echo json_encode($response, JSON_PRETTY_PRINT);