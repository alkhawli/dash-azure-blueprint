# 🚀 Dash Azure Blueprint: Terraform, ACR, GitHub Actions

This project contains:
- A Dash app in Python
- Docker-based deployment to Azure
- **Manual Infrastructure as Code with Terraform**
- **Automated Docker image builds and ACR deployment via GitHub Actions**

---

## 📁 Project Structure

```
dash-azure-blueprint/
├── source/               # Dash app code and Dockerfile
│   ├── app.py
│   ├── Dockerfile
│   ├── requirements.txt
│   └── .env              # (not committed)
│
├── infra/                # Terraform scripts for Azure (run manually)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars  # (not committed)
│
└── .github/workflows/
    └── docker-build.yml  # GitHub Actions for CI/CD
```

---

## 🌐 Prerequisites

- Azure CLI
- Docker Desktop
- Terraform
- GitHub account

---

## 🚀 Deployment Steps

### ✅ 1. Clone the Repo

```bash
git clone https://github.com/alkhawli/dash-azure-blueprint.git
cd dash-azure-blueprint
```

---

### ✅ 2. Terraform Deployment (Manual)

1. Set your values in `infra/terraform.tfvars`:

```hcl
tenant_id        = "your-azure-tenant-id"
subscription_id  = "your-subscription-id"
docker_image     = "dash-app:v1"
```

2. Run Terraform locally:

```bash
cd infra
terraform init
terraform apply -var-file="terraform.tfvars"
```

Terraform will create:
- Resource Group
- App Service Plan
- Web App
- ACR (Azure Container Registry)

---

### ✅ 3. Push Docker Image to ACR (Manual or via GitHub Actions)

```bash
az acr login --name <your-acr-name>
docker buildx build --platform linux/amd64 -t <acr-login-server>/dash-app:v1 --push ./source
```

Example:
```bash
docker buildx build --platform linux/amd64 -t dashdockerappacr.azurecr.io/dash-app:v1 --push ./source
```

---

### ✅ 4. GitHub Actions Setup

#### 🔐 Add Secrets

In your GitHub repo settings:

- `AZURE_CREDENTIALS`: Output of:
  ```bash
  az ad sp create-for-rbac --name "github-action-deployer" --role contributor \
       --scopes /subscriptions/<your-subscription-id> --sdk-auth
  ```

- `ACR_NAME`: e.g., `dashdockerappacr`
- `ACR_LOGIN_SERVER`: e.g., `dashdockerappacr.azurecr.io`

#### 📄 `.github/workflows/docker-build.yml`

```yaml
name: Build and Push to ACR

on:
  push:
    paths:
      - 'source/**'
      - '.github/workflows/**'
    branches:
      - main

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Log in to Azure
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Log in to ACR
      run: az acr login --name ${{ secrets.ACR_NAME }}

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Build and push image
      run: |
        docker buildx build \
          --platform linux/amd64 \
          --tag ${{ secrets.ACR_LOGIN_SERVER }}/dash-app:v1 \
          --push ./source
```

---

## ✅ Next Steps

- ✅ Customize your Dash app
- ✅ Add HTTPS and custom domain to your Azure Web App
- 🔁 Optional: Automate Terraform via GitHub Actions later