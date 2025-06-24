
# AKS Cluster Deployment using Terraform and GitHub Actions

This project provisions an Azure Kubernetes Service (AKS) cluster using **Terraform** and automates deployment through **GitHub Actions CI/CD pipeline**.

---

##  Architecture

- **AKS Cluster**: Azure-managed Kubernetes service.
- **Terraform Backend**: Stores remote state in Azure Blob Storage.
- **CI/CD**: GitHub Actions automates `terraform plan` and `terraform apply` on every push to main.

---

##  Project Structure

```
.
├── main.tf                  # Defines AKS and supporting resources
├── variables.tf             # Input variables
├── outputs.tf               # Outputs (like AKS kube_config)
├── terraform.tfvars         # Variable values (ignored by git)
├── backend.tf               # Remote backend config (Azure Storage)
├── .github/workflows/
│   └── terraform.yml        # CI/CD GitHub Actions Workflow
└── README.md                # Project documentation
```

---

##  Prerequisites

- Azure CLI installed and logged in (`az login`)
- Terraform v1.3.0+
- Azure subscription with required IAM roles
- GitHub repository with secrets configured:
  - `ARM_CLIENT_ID`
  - `ARM_CLIENT_SECRET`
  - `ARM_SUBSCRIPTION_ID`
  - `ARM_TENANT_ID`

---

##  Setup Instructions

### 1. Clone the Repo

```bash
git clone https://github.com/your-user/your-aks-repo.git
cd your-aks-repo
```

### 2. Configure Backend

Edit `backend.tf`:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "tfstate-rg"
    storage_account_name  = "yourstorageacct"
    container_name        = "tfstate"
    key                   = "aks/terraform.tfstate"
  }
}
```

Run:

```bash
terraform init
```

---

### 3. Apply Infrastructure

```bash
terraform plan
terraform apply
```

> AKS and related resources (resource group, VNet, subnet, NSG) will be created.

---

## CI/CD via GitHub Actions

- On push to `main`, GitHub Action:
  - Runs `terraform init`
  - Validates and plans the deployment
  - Applies automatically if approved

### Sample Workflow: `.github/workflows/terraform.yml`

```yaml
name: Terraform AKS Deployment

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: 1.3.0

    - name: Terraform Init
      run: terraform init

    - name: Terraform Plan
      run: terraform plan

    - name: Terraform Apply
      run: terraform apply -auto-approve
      env:
        ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
        ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
        ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
        ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
```

---

## Outputs

- `kube_config`: Use this to connect to your AKS cluster
  ```bash
  az aks get-credentials --resource-group <rg-name> --name <aks-name>
  kubectl get nodes
  ```

---

##  Cleanup

To destroy the cluster:

```bash
terraform destroy
```

---

##  Notes

- The `ContainerInsights` resource may block deletion — remove it manually or disable `prevent_deletion_if_contains_resources`.
- Use separate `.tfvars` files to manage different environments (dev/staging/prod).

---

