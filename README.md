# Accor Redemption: GitOps EKS Architecture

## Project Overview
This repository contains the Infrastructure-as-Code (IaC) and Kubernetes manifest files for the "Redemption" microservice. The architecture is designed for high availability, zero-downtime scaling, and secure multi-tier operations on AWS Elastic Kubernetes Service (EKS).

## Architecture
![Architecture Diagram](diagrams/architecture.png)

This architecture utilizes:
* **Terraform:** Layered state management (Network, Infrastructure, EKS, Database, Helm Add-ons).
* **ArgoCD:** GitOps-based reconciliation to ensure the cluster state matches this repository.
* **Karpenter & HPA:** Automated compute and pod-level scaling to handle 10x traffic flash sales.

## Prerequisites
Ensure the following tools are installed and configured:
- AWS CLI (with valid credentials)
- Terraform (v1.x)
- kubectl
- Helm
- ArgoCD CLI

## Deployment Procedure
To provision the infrastructure, apply the Terraform modules in the following order:

1. **Networking:** `terraform apply -chdir=00-network`
2. **Infrastructure:** `terraform apply -chdir=01-infra`
3. **EKS Cluster:** `terraform apply -chdir=02-eks`
4. **Database:** `terraform apply -chdir=03-database`
5. **Helm Add-ons:** `terraform apply -chdir=04-helm-addons`

## Validation & Testing
The system has been validated against the following operational criteria:
- **Scalability:** Confirmed HPA triggers at 60% CPU / 70% Memory utilization.
- **Reliability:** Confirmed PDB enforcement via `kubectl drain` simulation.
- **GitOps:** Confirmed ArgoCD auto-reconciliation of manual cluster changes.

*Evidence screenshots can be found in the `docs/images/` directory.*

## Teardown
To prevent incurring unnecessary AWS costs, destroy the infrastructure in reverse order:
1. `terraform destroy -chdir=04-helm-addons`
2. `terraform destroy -chdir=03-database`
3. `terraform destroy -chdir=02-eks`
4. `terraform destroy -chdir=01-infra`
5. `terraform destroy -chdir=00-network`