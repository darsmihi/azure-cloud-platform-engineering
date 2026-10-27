# ==============================================================================
# Script: stop-lab.ps1
# Purpose: Deallocates the VM to release hypervisor hardware and halt compute billing
# ==============================================================================

Write-Host "==> Deallocating vm-web-lab (Releasing physical CPU/RAM)..." -ForegroundColor Cyan
az vm deallocate -g rg-terraform-foundations -n vm-web-lab

Write-Host "`n==> Verifying Deallocation..." -ForegroundColor Cyan
$state = az vm show -d -g rg-terraform-foundations -n vm-web-lab --query "powerState" -o tsv

if ($state -eq "VM deallocated") {
    Write-Host "Power State: $state" -ForegroundColor Green
    Write-Host "`n[SUCCESS] Compute billing halted at 0 INR/hr. Lab is safely parked." -ForegroundColor Green
} else {
    Write-Host "`n[WARNING] VM is not in 'VM deallocated' state. Current state: $state" -ForegroundColor Red
}