# Cloudflare Zero Trust Red Team/Blue Team Security Framework

This repository contains Terraform code for implementing a comprehensive Cloudflare Zero Trust security framework designed specifically for security teams with separate Red Team and Blue Team functions.

## Overview

This infrastructure implements a Zero Trust security model using Cloudflare, Microsoft Entra ID (formerly Azure AD), and Microsoft Intune. The solution creates a security boundary where:

- Red Team members can access security testing tools and environments
- Blue Team members can access monitoring and defensive security tools
- Both teams can access shared resources
- All access requires authenticated and compliant devices
- Network traffic is filtered based on security policies

## Architecture

The infrastructure consists of the following components:

- **Identity Integration**: Microsoft Entra ID integration with SCIM provisioning
- **Device Posture**: Microsoft Intune integration for device compliance
- **Access Applications**: Team-specific protected applications (Red Team and Blue Team only)
- **Access Policies**: Role-based access controls
- **Gateway Policies**: Content and security filtering for network traffic
- **WARP Client**: Device enrollment and secure connectivity

## Prerequisites

- Cloudflare Zero Trust account
- Microsoft Entra ID tenant
- Microsoft Intune subscription
- Terraform Cloud account (optional, for state management)
- Terraform 1.0.0+

## Required Permissions

- **Cloudflare**: Admin access to Cloudflare Zero Trust
- **Microsoft Entra ID**: Application registration permissions
- **Microsoft Intune**: Admin access for device compliance integration

## Setup Instructions

### 1. Configure Variables

Copy the `example.tfvars` file to `terraform.tfvars` and update with your values:

```
account_id          = "your-cloudflare-account-id"
api_token           = "your-cloudflare-api-token"
azure_client_id     = "your-azure-client-id"
azure_client_secret = "your-azure-client-secret"
azure_directory_id  = "your-azure-directory-id"
intune_client_id    = "your-intune-client-id"
intune_client_secret = "your-intune-client-secret"

# Red team configuration
red_team_name = "Red Team"
red_team_group_ids = [""]

# Blue team configuration
blue_team_name = "Blue Team"
blue_team_group_ids = [""]
```

### 2. Initialize Terraform

```bash
cd terraform/environments/prod
terraform init
```

### 3. Plan and Apply

```bash
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

### 4. Set Up SCIM Provisioning

1. In the Cloudflare Zero Trust dashboard, navigate to Settings > Authentication
2. Configure SCIM with your Microsoft Entra ID tenant
3. Set up automatic user provisioning for the Red Team and Blue Team groups

## Environment Variables

The following environment variables can be used instead of `terraform.tfvars`:

- `TF_VAR_account_id` - Cloudflare Account ID
- `TF_VAR_api_token` - Cloudflare API Token
- `TF_VAR_azure_client_id` - Azure AD Client ID
- `TF_VAR_azure_client_secret` - Azure AD Client Secret
- `TF_VAR_azure_directory_id` - Azure AD Directory ID
- `TF_VAR_intune_client_id` - Microsoft Intune Client ID
- `TF_VAR_intune_client_secret` - Microsoft Intune Client Secret

## Resource Descriptions

### Identity Provider

```terraform
resource "cloudflare_zero_trust_access_identity_provider" "microsoft_entra_id" {
  # Configuration for Microsoft Entra ID integration
}
```

- Integrates with Microsoft Entra ID for authentication
- Enables group-based access controls
- Supports claims for email, profile, and group membership

### Access Groups

```terraform
resource "cloudflare_zero_trust_access_group" "red_team" {
  # Configuration for Red Team access group
}

resource "cloudflare_zero_trust_access_group" "blue_team" {
  # Configuration for Blue Team access group
}
```

- Maps Azure AD security groups to Cloudflare access groups
- Used for role-based access control
- Synchronized via SCIM provisioning

### Device Posture Rules

```terraform
resource "cloudflare_zero_trust_device_posture_rule" "disk_encryption" {
  # Disk encryption requirements
}

resource "cloudflare_zero_trust_device_posture_rule" "os_version_windows" {
  # OS version requirements
}

resource "cloudflare_zero_trust_device_posture_rule" "intune_compliance" {
  # Intune compliance check
}
```

- Enforces security requirements for devices
- Integrates with Microsoft Intune for compliance checks
- Blocks non-compliant devices from accessing resources

### Access Applications

```terraform
resource "cloudflare_zero_trust_access_application" "red_team_app" {
  # Red Team specific application
}

resource "cloudflare_zero_trust_access_application" "blue_team_app" {
  # Blue Team specific application
}
```

- Defines protected applications
- Configures authentication requirements
- Sets session duration and visibility

### Gateway Policies

```terraform
resource "cloudflare_zero_trust_gateway_policy" "consolidated_security_blocks" {
  # Security threat blocking
}

resource "cloudflare_zero_trust_gateway_policy" "security_tools_dns" {
  # Security tools access
}

resource "cloudflare_zero_trust_gateway_policy" "security_testing_domains" {
  # Red Team domains pattern matching
}

resource "cloudflare_zero_trust_gateway_policy" "monitoring_domains" {
  # Blue Team domains pattern matching
}
```

- Filters network traffic based on security categories
- Blocks malicious content and inappropriate websites
- Allows approved security tools based on team roles

## WARP Client Deployment

### Windows Deployment

```powershell
# PowerShell script for automated deployment
$warpInstallerUrl = "https://1.1.1.1/Cloudflare_WARP_Release-x64.msi"
$outFile = "$env:TEMP\Cloudflare_WARP.msi"
Invoke-WebRequest -Uri $warpInstallerUrl -OutFile $outFile
Start-Process msiexec.exe -ArgumentList "/i $outFile /quiet" -Wait
```

### macOS Deployment

```bash
# Bash script for automated deployment
curl -L https://1.1.1.1/Cloudflare_WARP.pkg -o /tmp/Cloudflare_WARP.pkg
sudo installer -pkg /tmp/Cloudflare_WARP.pkg -target /
```

### Linux Deployment

```bash
# For Ubuntu/Debian
curl -L https://pkg.cloudflareclient.com/cloudflare-warp-ubuntu.deb -o /tmp/cloudflare-warp.deb
sudo apt install /tmp/cloudflare-warp.deb

# For Red Hat/CentOS
curl -L https://pkg.cloudflareclient.com/cloudflare-warp-rhel.rpm -o /tmp/cloudflare-warp.rpm
sudo rpm -i /tmp/cloudflare-warp.rpm
```

## Testing

Refer to the testing section in the documentation for detailed instructions on validating the deployment.

## Logging and Monitoring

The configuration includes optional logging to Azure Blob Storage for audit and security analysis:

```terraform
resource "cloudflare_logpush_job" "gateway_logs" {
  # Log configuration
}
```

To enable logging, set the following variables:

```
enable_logs = true
azure_storage_account = "your-storage-account"
azure_storage_container = "gateway-logs"
azure_sas_token = "your-sas-token"
```

## Troubleshooting

Common issues and solutions:

1. **Policy Precedence Conflicts**: If you encounter errors about duplicate precedence, ensure each policy has a unique precedence value.

2. **DNS Filter Syntax Errors**: When creating gateway policies with DNS filters, use the proper `any()` syntax for array matching:
   ```
   traffic = "any(dns.domains[*] matches \".*\")"
   ```

3. **WARP Client Connection Issues**: Ensure the WARP client is properly enrolled and the user is in the appropriate Azure AD group.

## Security Considerations

- All traffic is filtered through Cloudflare Gateway
- Device posture checks enforce security compliance
- SCIM provisioning ensures access is removed when users leave groups
- Default-deny approach blocks all traffic not explicitly allowed

## Maintenance

- Regularly update the Terraform code to stay current with Cloudflare API changes
- Review and adjust policies as security requirements evolve
- Keep the WARP client updated on all devices

## License

MIT

## Contributors

- Your organization's security team

## Version History

- 1.0.0: Initial release
- 1.0.1: Fixed policy precedence conflicts
- 1.0.2: Added Microsoft Intune integration
- 1.1.0: Added SCIM provisioning

## Remote State Configuration (Recommended)

To enable safe collaboration and state management, use a remote backend. Example for Terraform Cloud:

```hcl
terraform {
  cloud {
    organization = "your-org"
    workspaces {
      name = "your-workspace"
    }
  }
}
```

Or for AWS S3:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-tf-state-bucket"
    key            = "path/to/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-tf-lock-table"
    encrypt        = true
  }
}
```

## Sensitive Variable Handling

Sensitive variables (API tokens, secrets) are marked as `sensitive = true` in the code. Use environment variables or a secrets manager to provide these values securely. Never commit secrets to version control.