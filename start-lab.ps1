# ==============================================================================
# Script: start-lab.ps1
# Purpose: Powers on the lab VM, verifies health, and displays access endpoints
# ==============================================================================

Write-Host "==> Powering on vm-web-lab in Central India (Zone 3)..." -ForegroundColor Cyan
az vm start -g rg-terraform-foundations -n vm-web-lab

Write-Host "`n==> Verifying Hypervisor Power State..." -ForegroundColor Cyan
$state = az vm show -d -g rg-terraform-foundations -n vm-web-lab --query "powerState" -o tsv

if ($state -eq "VM running") {
    Write-Host "Power State: $state" -ForegroundColor Green
    Write-Host "`n--------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host " Web Endpoint : http://20.198.94.196" -ForegroundColor Yellow
    Write-Host " SSH Command  : ssh -i `"`$env:USERPROFILE\.ssh\id_rsa_azure`" azureuser@20.198.94.196" -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------------" -ForegroundColor DarkGray
} else {
    Write-Host "[WARNING] Expected 'VM running' but received: $state" -ForegroundColor Red
}