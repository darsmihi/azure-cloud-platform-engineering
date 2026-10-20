# Azure Cloud & Platform Engineering Portfolio

Hands-on repository documenting the architecture, automation, observability, and cost-governance of an enterprise-aligned Azure cloud platform.

## Architecture & Project Phases

* **Phase 1: Foundation & Baseline Audit**
  * [Infrastructure & Operations Audit Report](docs/01-baseline-audit/audit-report.md)
  * Linux host inspection, security boundaries, and automated cost hygiene.
* **Phase 2: Modular Infrastructure as Code (Terraform)** *(In Progress)*
  * Declarative compute, network, and security configuration with remote state locking.
* **Phase 3: Containerization & CI/CD Pipelines**
  * Hardened Docker containers deployed via GitHub Actions using OIDC authentication.
* **Phase 4: Kubernetes & Observability (SRE)**
  * Helm packaging, GitOps deployment, Log Analytics (KQL) alerting, and disaster recovery drills.

---

## Environment Baseline

* **Cloud Provider:** Microsoft Azure
* **Target OS:** Ubuntu Linux 24.04 LTS
* **IaC & Tooling:** Bash, Terraform, Azure CLI, Docker, Git