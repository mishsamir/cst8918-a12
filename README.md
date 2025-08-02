# CST8918 Lab 12: Terraform CI/CD on Azure with GitHub Actions

## Team Members
- **[Your Name Here]** - [@yourgithubusername](https://github.com/yourgithubusername) - College ID: your-college-id
- **[Partner Name Here]** - [@partnergithubusername](https://github.com/partnergithubusername) - College ID: partner-college-id

## Overview

This project demonstrates Infrastructure as Code (IaC) using Terraform and GitHub Actions for a containerized web application deployed to Azure Kubernetes Service (AKS). The project showcases automated infrastructure deployment workflows including static analysis, integration testing, deployment, and drift detection.

## Project Structure

```
cst8918-a12/
├── .github/
│   └── workflows/
│       ├── infra-ci-cd.yml              # Terraform plan on PR, apply on main
│       ├── infra-drift-detection.yml    # Daily drift detection
│       └── infra-static-tests.yml       # Static analysis (fmt + tflint)
├── app/
│   └── .gitkeep                         # Placeholder for containerized app
├── infra/
│   ├── az-federated-credential-params/  # Azure OIDC configurations
│   │   ├── branch-main.json
│   │   ├── production-deploy.json
│   │   └── pull-request.json
│   ├── tf-app/                          # Main application infrastructure
│   │   ├── .tflint.hcl                  # TFLint configuration
│   │   ├── main.tf                      # AKS, ACR, resource groups
│   │   ├── outputs.tf                   # Connection info outputs
│   │   ├── terraform.tf                 # Backend configuration
│   │   └── variables.tf                 # Configurable variables
│   └── tf-backend/                      # State storage infrastructure
│       └── main.tf                      # Storage account for state
├── docs/                                # Setup documentation
├── screenshots/                         # Workflow screenshots
├── .editorconfig
├── .gitignore
└── README.md
```

## Infrastructure Components

### Azure Resources Created

1. **Azure Kubernetes Service (AKS)**
   - Managed Kubernetes cluster
   - System-assigned managed identity
   - Log Analytics workspace integration

2. **Azure Container Registry (ACR)**
   - Private container registry
   - AKS integration with AcrPull permissions

3. **Supporting Resources**
   - Resource groups with consistent tagging
   - Log Analytics workspace for monitoring
   - Proper RBAC configurations

### Key Features

- **Scalable Architecture**: Configurable node count and VM sizes
- **Security Best Practices**: Managed identities, private networking
- **Monitoring**: Integrated Log Analytics workspace
- **Resource Management**: Consistent tagging and naming conventions

## GitHub Actions Workflows

### 1. Static Analysis (`infra-static-tests.yml`)
**Trigger**: Push or PR affecting `infra/**`
- Terraform format checking
- TFLint static analysis
- Terraform validation
- Runs on all branches

### 2. CI/CD Pipeline (`infra-ci-cd.yml`)
**Trigger**: PR to main or push to main affecting `infra/tf-app/**`
- **PR**: Terraform plan with output in comments
- **Main**: Terraform apply with auto-approval
- Azure OIDC authentication
- Secure state management

### 3. Drift Detection (`infra-drift-detection.yml`)
**Trigger**: Daily schedule + manual dispatch
- Detects infrastructure drift
- Creates GitHub issues on drift detection
- Automated monitoring of infrastructure changes

## Configuration

### Variables (terraform.tfvars)
```hcl
location            = "East US"
resource_group_name = "rg-aks-app"
aks_cluster_name    = "aks-cluster"
acr_name           = "acr"
node_count         = 2
node_vm_size       = "Standard_B2s"
kubernetes_version = "1.28.3"
environment        = "dev"
project_name       = "cst8918"
```

### Required GitHub Secrets
- `AZURE_CLIENT_ID`: Service principal client ID
- `AZURE_TENANT_ID`: Azure AD tenant ID  
- `AZURE_SUBSCRIPTION_ID`: Target subscription ID
- `TERRAFORM_STORAGE_ACCOUNT`: Backend storage account name
- `TERRAFORM_STORAGE_KEY`: Storage account access key

## Setup Instructions

### 1. Azure Backend Setup
```bash
cd infra/tf-backend
terraform init
terraform plan
terraform apply
```

### 2. Configure GitHub Secrets
Set up the required secrets in your GitHub repository settings.

### 3. Configure Azure OIDC
Use the JSON files in `infra/az-federated-credential-params/` to configure federated credentials.

### 4. Deploy Infrastructure
Push changes to trigger the CI/CD pipeline or manually run workflows.

## Key Outputs

After successful deployment, the following information is available:

- **AKS Cluster Name**: For kubectl configuration
- **ACR Login Server**: For container image operations  
- **Resource Group**: For Azure portal management
- **Kubeconfig**: For cluster access (sensitive)

## Best Practices Implemented

- **Infrastructure as Code**: All resources defined in Terraform
- **GitOps Workflow**: Infrastructure changes via Git
- **Automated Testing**: Static analysis and validation
- **Security**: OIDC authentication, managed identities
- **Monitoring**: Drift detection and alerting
- **Documentation**: Comprehensive outputs and tagging

## Troubleshooting

### Common Issues
1. **Backend Configuration**: Ensure storage account name is correct
2. **OIDC Setup**: Verify federated credential configuration
3. **Permissions**: Check service principal has required Azure permissions
4. **Resource Naming**: Ensure globally unique names for ACR

### Useful Commands
```bash
# Connect to AKS cluster
az aks get-credentials --resource-group <rg-name> --name <cluster-name>

# List ACR repositories
az acr repository list --name <acr-name>

# Check Terraform state
terraform state list
```

## Contributing

1. Create feature branch from `main`
2. Make infrastructure changes in `infra/tf-app/`
3. Commit and push changes
4. Create pull request to `main`
5. Review Terraform plan in PR comments
6. Merge to deploy to production

## License

This project is part of CST8918 coursework and is for educational purposes.
│   └── workflows
│       ├── infra-ci-cd.yml
│       ├── infra-drift-detection.yml
│       └── infra-static-tests.yml
├── app
│   └── .gitkeep
├── infra
│   ├── az-federated-credential-params
|   |   ├── branch-main.json
│   │   ├── production-deploy.json
|   |   └── pull-request.json
│   ├── tf-app
│   |   ├── .tflint.hcl
│   │   ├── main.tf
│   │   ├── outputs.tf
|   │   ├── terraform.tf
│   │   └── variables.tf
│   └── tf-backend
│       └── main.tf
├── screenshots
│   ├── pr-checks.png
│   └── pr-tf-plan.png
├── .editorconfig
├── .gitignore
└── README.md
```

## Instructions

This lab should be completed in teams of two. One team member will create the GitHub repository and invite the other as a collaborator. Most of the numbered steps should be completed by one of the team member committing and pushing the code on a dev branch, with the other team member reviewing and approving the pull request. Each team member should contribute equally to the codebase.

> [!IMPORTANT]
> Submissions with only one team member's contributions will incur 20% grade penalty for that team member, and the other team member will receive a grade of zero (0). Collaboration is required!

Full instructions for each step can be found in the [docs](docs) folder. Please complete each step in order.

1. Setup your GitHub repo with an environment and branch protection rules.
2. Configure Terraform to use Azure Blob Storage for remote state.
3. Create Azure access credentials for automation with GitHub Actions.
4. Add Azure identity values as _secrets_ in your GitHub repo.
5. Update the Terraform configuration to use the Azure identity values.
6. Create a GitHub Actions workflows to:  
   6.1 run Terraform static analysis.  
   6.2 run Terraform integration tests.  
   6.3 deploy the Terraform infrastructure.  
   6.4 detect drift between Terraform and Azure.  
7. Test the workflows by making changes to the Terraform configuration.

## Submission

1. Submit the URL of your GitHub repository.
2. Include in your submission a screenshot of the Pull Request showing the successful completion of the workflows - expand the "All checks have passed" section to show the steps.
3. Include in your submission a screenshot of the Pull Request showing the expanded results of the Terraform Plan step.
4. Embed the screenshots in your README.md file.
5. The README.md file should clearly identify the full name and GitHub username of each team member.

## Additional References

Based on the [GitHub Actions Workflows for Terraform](https://github.com/Azure-Samples/terraform-github-actions)

https://learn.microsoft.com/en-ca/azure/developer/github/connect-from-azure?tabs=azure-cli%2Clinux#use-the-azure-login-action-with-openid-connect
