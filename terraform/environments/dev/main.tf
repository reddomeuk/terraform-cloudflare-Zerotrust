terraform {
  cloud {
    organization = "reddome_academy"
    workspaces {
      name = "cloudflare-zerotrust-dev"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.api_token
}

# Create the Azure AD identity provider first
resource "cloudflare_zero_trust_access_identity_provider" "azure_ad" {
  account_id = var.account_id
  name       = "Azure AD"
  type       = "azureAD"
  config {
    client_id     = var.azure_client_id
    client_secret = var.azure_client_secret
    directory_id  = var.azure_directory_id
  }
}

# IDP Module - Must be defined first as it provides group IDs used by other modules
module "idp" {
  source = "../../modules/idp"

  account_id = var.account_id
  
  # Azure AD configuration
  azure_client_id     = var.azure_client_id
  azure_client_secret = var.azure_client_secret
  azure_directory_id  = var.azure_directory_id
  
  # Team group IDs
  red_team_group_ids  = var.red_team_group_ids
  blue_team_group_ids = var.blue_team_group_ids
}

# Create the WARP module which depends on the Azure AD provider
module "warp" {
  source               = "../../modules/warp"
  account_id           = var.account_id
  warp_name            = "Dev WARP Configuration"
  azure_ad_provider_id = cloudflare_zero_trust_access_identity_provider.azure_ad.id
}

# Access Module - Uses group IDs from IDP module
module "access" {
  source = "../../modules/access"

  account_id = var.account_id
  app_name   = var.app_name

  # Use the group IDs from the IDP module outputs
  red_team_group_id  = module.idp.red_team_id
  blue_team_group_id = module.idp.blue_team_id
  red_team_id        = module.idp.red_team_id
  blue_team_id       = module.idp.blue_team_id

  # Azure AD configuration
  azure_ad_provider_id = module.idp.entra_idp_id

  # App domains
  red_team_app_domain  = var.red_team_app_domain
  blue_team_app_domain = var.blue_team_app_domain

  # Email access
  allowed_emails = var.allowed_emails
}