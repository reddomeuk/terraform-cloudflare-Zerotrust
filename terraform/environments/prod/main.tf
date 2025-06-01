// Cloudflare Zero Trust Terraform configuration for Red/Blue Team security framework
terraform {
  cloud {
    organization = "reddome"
    workspaces {
      name = "terraform-cloudflare-Zerotrust"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "= 4.52.0" # Pin to latest 4.x version for stability
    }
  }
}

# Configure the Cloudflare provider
provider "cloudflare" {
  api_token = var.api_token
  retries   = 3
}

# Global Zero Trust settings for the account
resource "cloudflare_zero_trust_gateway_settings" "zero_trust" {
  account_id = var.account_id
}

# Identity Provider (Microsoft Entra ID) and Access Groups
module "idp" {
  source              = "../../modules/idp"
  account_id          = var.account_id
  azure_client_id     = var.azure_client_id
  azure_client_secret = var.azure_client_secret
  azure_directory_id  = var.azure_directory_id
  red_team_name       = var.red_team_name
  red_team_group_ids  = var.red_team_group_ids
  blue_team_name      = var.blue_team_name
  blue_team_group_ids = var.blue_team_group_ids
  depends_on          = [cloudflare_zero_trust_gateway_settings.zero_trust]
}

# Device Posture integration with Microsoft Intune
module "device_posture" {
  source               = "../../modules/device_posture"
  account_id           = var.account_id
  intune_client_id     = var.intune_client_id
  intune_client_secret = var.intune_client_secret
  azure_tenant_id      = var.azure_directory_id
  depends_on           = [cloudflare_zero_trust_gateway_settings.zero_trust]
}

# WARP Client configuration for secure device connectivity
module "warp" {
  source                  = "../../modules/warp"
  account_id              = var.account_id
  warp_name               = "WARP-${terraform.workspace}"
  azure_ad_provider_id    = module.idp.entra_idp_id
  security_teams_id       = module.idp.red_team_id
  azure_group_ids         = concat(var.red_team_group_ids, var.blue_team_group_ids)
  red_team_name           = var.red_team_name
  blue_team_name          = var.blue_team_name
  red_team_group_ids      = var.red_team_group_ids
  blue_team_group_ids     = var.blue_team_group_ids
  enable_logs             = var.enable_logs
  azure_storage_account   = var.azure_storage_account
  azure_storage_container = var.azure_storage_container
  azure_sas_token         = var.azure_sas_token
  azure_client_id         = var.azure_client_id
  azure_client_secret     = var.azure_client_secret
  azure_directory_id      = var.azure_directory_id
  depends_on              = [cloudflare_zero_trust_gateway_settings.zero_trust, module.idp]
}

# Gateway module for network security policies
module "gateway" {
  source        = "../../modules/gateway"
  account_id    = var.account_id
  location_name = "Gateway-${terraform.workspace}"
  networks      = ["192.168.1.0/24"]
  depends_on    = [cloudflare_zero_trust_gateway_settings.zero_trust]
}

# Access module for application and policy management
module "access" {
  source               = "../../modules/access"
  account_id           = var.account_id
  cloudflare_account_id = var.account_id
  domain               = "reddome.org"
  app_name             = "reddome-${terraform.workspace}"
  allowed_emails       = ["user@reddome.org"]
  red_team_name        = var.red_team_name
  blue_team_name       = var.blue_team_name
  red_team_group_id    = module.idp.red_team_id
  blue_team_group_id   = module.idp.blue_team_id
  red_team_id          = module.idp.red_team_id
  blue_team_id         = module.idp.blue_team_id
  azure_ad_provider_id = module.idp.entra_idp_id
  device_posture_rule_ids = module.device_posture.all_posture_rule_ids
  depends_on = [cloudflare_zero_trust_gateway_settings.zero_trust, module.device_posture, module.idp]
}