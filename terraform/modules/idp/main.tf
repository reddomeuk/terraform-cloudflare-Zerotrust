# IDP Module: Manages Cloudflare Zero Trust Identity Provider integration with Microsoft Entra ID
# This module configures Microsoft Entra ID as the identity provider and creates access groups for Red and Blue teams

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=4.40.0" # Keep compatible with version 4
    }
  }
}

# Handle resource transitions
moved {
  from = cloudflare_zero_trust_access_identity_provider.microsoft_entra_id
  to   = cloudflare_zero_trust_access_identity_provider.entra_id
}

# Azure AD Identity Provider
resource "cloudflare_zero_trust_access_identity_provider" "entra_id" {
  account_id = var.account_id
  name       = "Azure AD"
  type       = "azureAD"
  config {
    client_id     = var.azure_client_id
    client_secret = var.azure_client_secret
    directory_id  = var.azure_directory_id
  }
}

# Red Team Access Group
# Creates an access group for Red Team members based on Microsoft Entra ID security groups
resource "cloudflare_zero_trust_access_group" "red_team" {
  account_id = var.account_id
  name       = var.red_team_name
  include {
    azure {
      id                   = var.red_team_group_ids
      identity_provider_id = cloudflare_zero_trust_access_identity_provider.entra_id.id
    }
  }
}

# Blue Team Access Group
# Creates an access group for Blue Team members based on Microsoft Entra ID security groups
resource "cloudflare_zero_trust_access_group" "blue_team" {
  account_id = var.account_id
  name       = var.blue_team_name
  include {
    azure {
      id                   = var.blue_team_group_ids
      identity_provider_id = cloudflare_zero_trust_access_identity_provider.entra_id.id
    }
  }
}

# Additional Access Group - Device Requirements
resource "cloudflare_zero_trust_access_group" "secure_devices" {
  account_id = var.account_id
  name       = "Secure Devices"

  # Add an include block with everyone = true to meet requirement
  include {
    everyone = true
  }

  require {
    device_posture = ["disk_encryption", "os_version"]
  }
}