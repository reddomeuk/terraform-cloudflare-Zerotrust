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

# Create the IDP module which depends on the Azure AD provider
module "idp" {
  source = "../../modules/idp"
  account_id = var.account_id
  azure_client_id = var.azure_client_id
  azure_client_secret = var.azure_client_secret
  azure_directory_id = var.azure_directory_id
}

# Create the WARP module which depends on the Azure AD provider
module "warp" {
  source = "../../modules/warp"
  account_id = var.account_id
  warp_name  = "Dev WARP Configuration"
  azure_ad_provider_id = cloudflare_zero_trust_access_identity_provider.azure_ad.id
}

# Create the access module which depends on the IDP module
module "access" {
  source = "../../modules/access"
  account_id = var.account_id
  app_name = "RedDome App"
  app_domain = "reddome.org"
  allowed_emails = []
  red_team_id = module.idp.red_team_id
  blue_team_id = module.idp.blue_team_id
}