# Baseline Infrastructure & Operations Audit

**Audit Date:** October 20, 2026  
**Auditor:** Darshan Nair  
**Target Goal:** Cloud / DevOps Migration Foundation  

---

## 1. Cloud Subscription & Cost Baseline

* **Subscription Name:** Azure subscription 1
* **Subscription ID:** `463e2a1f-a435-4f4b-95c8-53b9df353507`
* **Cost Controls Configured:** 
  * Monthly budget alert configured (`lab-monthly-budget`) with notification gates at 50%, 80%, and 100%.
  * Compute status changed from `Running` to `Stopped (deallocated)` to prevent unnecessary hourly compute burn.

---

## 2. Virtual Machine & Host Architecture

* **Host Machine Name:** `rg-az104-lab`
* **Resource Group:** `RG-AZ104-LAB_GROUP`
* **Region / Zone:** India South Central (Zone 1)
* **Instance Size:** `Standard DS1 v2` (1 vCPU, 3.5 GiB memory)
* **Operating System:** Ubuntu Linux 24.04 LTS
* **Storage Allocation:**
  * Root Disk (`/dev/root`): 29 GB total, 2.6 GB used (10% utilization).
  * Azure Ephemeral Disk (`/dev/sdb1`): 6.8 GB mounted at `/mnt` (non-persistent).

---

## 3. Network Topology & Firewall Boundaries

* **Virtual Network / Subnet:** `vnet-indiasouthcentral-1` / `snet-indiasouthcentral-1`
* **Private IP:** `172.16.0.4`
* **Public IP:** `172.198.160.132` (Dynamic/Standard allocation)
* **Inbound Security Rules (NSG):**
  * `Port 22 (TCP)`: SSH enabled from `Any` source (flagged for restriction).
  * `Port 80 (TCP)`: HTTP enabled from `Any` source (`Allow-HTTP-Lab`).

---

## 4. Workload & Service Inspection

* **Web Server:** Nginx (`nginx.service`)
  * Status: `active (running)`
  * Systemd Configuration: `enabled` (auto-starts on boot)
  * Listening Sockets: `0.0.0.0:80` (IPv4) and `[::]:80` (IPv6)
* **Active Web Response:** Verified reachable over HTTP port 80 prior to deallocation.

---

## 5. Identified Architectural & Operational Risks

1. **Security Exposure:** Port 22 (SSH) is open to the public internet (`0.0.0.0/0`), leaving the VM vulnerable to brute-force attempts.
2. **Cost Inefficiency:** `Standard DS1 v2` is an older, costlier general-purpose tier. It should be migrated to a cost-effective burstable tier (such as `Standard_B1s` or `Standard_B2s`) or replaced with containerized services.
3. **Manual Management (ClickOps):** The VM, networking, and web services were created manually without Infrastructure as Code (Terraform), preventing automated recovery or replication.