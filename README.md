# Azure Cloud Platform & DevOps Engineering Portfolio

Enterprise-aligned cloud platform engineering repository documenting the architecture, infrastructure automation, systems observability, and cost governance of production workloads on Microsoft Azure.

---

## Portfolio Architecture Evolution

[Project A (Active)]              [Project B (Month 3)]            [Project C (Months 4-5)]         [Project D (Month 6)]
Manual Audit & RCA Runbooks  ──►  Docker Containers & CI/CD   ──►  Kubernetes (AKS) & SRE       ──► Enterprise Landing Zone
Hardened Bash Health Probes       Azure Key Vault & OIDC           GitOps (ArgoCD) & Helm           Hub-Spoke Network Topology
Modular Terraform + Remote State  Automated Rollback Pipelines     KQL Golden Signals & Chaos DR    FinOps & Azure Architecture

 
## Project A: Azure Infrastructure Audit & Modular Terraform Foundation


                           [ Internet Traffic ]
                                     │
                    ┌────────────────┴────────────────┐
                    │                                 │
              HTTP (Port 80)                   SSH (Port 22)
               Source: Any (*)              Source: Workstation IP
                    │                                 │
                    ▼                                 ▼
         [ azurerm_public_ip ]               (Workstation Restricted)
          (Static / Standard)                         │
                    │                                 │
                    └────────────────┬────────────────┘
                                     ▼
                    [ azurerm_network_security_group ]
                      (nsg-web: Priority 200 & 210)
                                     │
                                     ▼
                      [ azurerm_virtual_network ]
                     (vnet-foundation: 10.0.0.0/16)
                                     │
                                     ▼
                           [ azurerm_subnet ]
                         (snet-web: 10.0.1.0/24)
                                     │
                                     ▼
                     [ azurerm_network_interface ]
                      (nic-web-vm: Dynamic IP 10.0.1.4)
                                     │
                                     ▼
                   [ azurerm_linux_virtual_machine ]
                     • Name: vm-web-lab
                     • SKU: Standard_DC1s_v3 (Zone 3)
                     • OS: Ubuntu 24.04 LTS Server
                     • Auth: Asymmetric 4096-bit RSA SSH
                     • Bootstrap: Cloud-Init (custom_data)
                                     │
                                     ▼
                        [ Systemd & Nginx Service ]
                     (HTTP 200 OK Live Dashboard)


## Engineering Highlights & Trade-Offs
- **Remote State Concurrency & Integrity:** State is isolated in an Azure Blob Storage backend (tfstate796080) protected by native Azure Blob distributed  lease locking to eliminate state corruption across concurrent team operations.

- **Network Edge Decoupling:** The Public IP (Standard SKU, Static allocation) and Network Interface Card are decoupled from the VM lifecycle, allowing VM replacement, resizing, and maintenance without dropping network identities.

Decoupled Architecture (What You Built):
[ Public IP ] ──binds──► [ Virtual NIC ] ◄──plugs into── [ Virtual Machine ]
 (20.198.94.196)           (nic-web-vm)                   (vm-web-lab)

- **Defensive Boundary:** Port 22 administrative SSH access is locked strictly to workstation CIDR prefix (180.151.36.142/32), eliminating brute-force internet scanning.

- **Physical Capacity Optimization:** Diagnosed real-time SkuNotAvailable (HTTP 409 Conflict) capacity constraints in centralindia across burstable SKUs (Standard_B1s, Standard_B2s). Queried Azure CLI quota APIs (az vm list-skus and az vm list-usage) and targeted Standard_DC1s_v3 in Zone 3 with zero code rewrites.

- **Immutable Bootstrapping:** Injected Base64-encoded Cloud-Init (custom_data) to automatically update packages, install Nginx, enable the systemd service, and deploy a custom dark-mode landing card upon initial boot.


## Terraform Inputs & Outputs Input Variables (terraform/variables.tf)
### Input Variables

resource_group_name = rg-terraform-foundations
location = centralindia
environment = Lab
owner = Darshan Nair
vnet_address_space = ["10.0.0.0/16"]
subnet_web_prefix = ["10.0.1.0/24"]
admin_source_ip = "180.151.36.142/32"
vm_size = Standard_DC1s_v3
admin_username = azureuser
ssh_public_key_path = "~/.ssh/id_rsa_azure.pub"

### Output Variables
resource_group_id = azurerm_resource_group.lab_rg.id
resource_group_name = azurerm_resource_group.lab_rg.name
vnet_id = azurerm_virtual_network.foundational_vnet.id
web_subnet_id = azurerm_subnet.web_subnet.id
web_nsg_id = azurerm_network_security_group.web_nsg.id
public_ip_address = azurerm_public_ip.web_pip.ip_address
vm_name = azurerm_linux_virtual_machine.web_vm.name
ssh_command = ssh -i ~/.ssh/id_rsa_azure ${var.admin_username}@${azurerm_public_ip.web_pip.ip_address}

## FinOps & Operational Lifecycle Automation
To enforce cost hygiene and eliminate compute burn during non-working hours, the repository provides automated PowerShell lifecycle controls:

**Start the lab VM, verify hypervisor state, and display access endpoints:**
.\start-lab.ps1

**Deallocate the VM, release physical CPU/RAM, and halt compute billing at 0 INR/hr:**
.\stop-lab.ps1

## Repository Structure
<pre>
azure-cloud-platform-engineering/
├── .gitignore                         # Excludes cached binaries, state files, and private keys
├── README.md                          # Executive architecture summary and documentation
├── start-lab.ps1                      # FinOps: Automated startup and health verification
├── stop-lab.ps1                       # FinOps: Automated deallocation (0 INR/hr park)
├── docs/
│   ├── 01-baseline-audit/
│   │   └── audit-report.md            # Initial state audit and technical debt register
│   └── 02-incident-runbooks/
│       └── rca-nginx-systemd-failure.md # Root Cause Analysis: Systemd recovery runbook
├── scripts/
│   └── system-health/
│       └── service_health_check.sh    # Production Bash probe with UTC ISO logging & exit codes
└── terraform/
    ├── provider.tf                    # AzureRM provider & remote Azure Blob backend configuration
    ├── main.tf                        # VNet, Subnet, NSG, Edge NIC, Public IP, and Cloud-Init VM
    ├── variables.tf                   # Reusable, parameterized inputs
    └── outputs.tf                     # Programmatic endpoints and connection strings
</pre>

