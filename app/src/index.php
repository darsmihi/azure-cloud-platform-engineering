<?php
header('Content-Type: application/json');

$response = [
    "status"      => "healthy",
    "timestamp"   => gmdate("Y-m-d\TH:i:s\Z"),
    "application" => "Azure Cloud Platform Workload",
    "version"     => "1.0.0",
    "environment" => getenv('APP_ENV') ?: 'local'
];

http_response_code(200);
echo json_encode($response, JSON_PRETTY_PRINT);