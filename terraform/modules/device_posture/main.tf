terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# 1. Define the Intune integration first
resource "cloudflare_zero_trust_device_posture_integration" "intune_integration" {
  account_id = var.account_id
  name       = "Microsoft Intune Integration"
  type       = "intune"
  interval   = "10m"
  
  config {
    client_id     = var.intune_client_id
    client_secret = var.intune_client_secret
    customer_id   = var.azure_tenant_id
  }
}

# 2. Define all the device posture rules
# OS Version Check
resource "cloudflare_zero_trust_device_posture_rule" "os_version_windows" {
  account_id  = var.account_id
  name        = "Windows OS Version Check"
  description = "Ensure Windows devices are running supported OS version"
  type        = "os_version"
  
  match {
    platform = "windows"
  }
  
  input {
    version = "10.15.7"  # Windows 10
  }
}

# Disk Encryption Check
resource "cloudflare_zero_trust_device_posture_rule" "disk_encryption" {
  account_id  = var.account_id
  name        = "Disk Encryption Check"
  description = "Ensure device disk is encrypted"
  type        = "disk_encryption"
  
  match {
    platform = "windows"
  }
}

# Windows Intune integration rule
resource "cloudflare_zero_trust_device_posture_rule" "intune_integration_windows" {
  account_id  = var.account_id
  name        = "Microsoft Intune Compliance - Windows"
  description = "Verify Windows device compliance with Intune policies"
  type        = "intune"
  
  match {
    platform = "windows"
  }
  
  input {
    id = cloudflare_zero_trust_device_posture_integration.intune_integration.id
    compliance_status = "compliant"
    # Remove os field
  }
}

# Mac Intune integration rule
resource "cloudflare_zero_trust_device_posture_rule" "intune_integration_mac" {
  account_id  = var.account_id
  name        = "Microsoft Intune Compliance - Mac"
  description = "Verify Mac device compliance with Intune policies"
  type        = "intune"
  
  match {
    platform = "mac"
  }
  
  input {
    id = cloudflare_zero_trust_device_posture_integration.intune_integration.id
    compliance_status = "compliant"
    # Remove os field
  }
}

resource "cloudflare_zero_trust_gateway_policy" "device_posture" {
  account_id  = var.account_id
  name        = "Device Posture Check"
  description = "Enforce device posture requirements"
  precedence  = 1
  action      = "isolate"
  filters     = ["http", "https"]
  
  # Use a valid traffic expression
  traffic     = "http.request.hostname matches '.*'"
  
  device_posture = jsonencode({
    integration_ids = [
      cloudflare_zero_trust_device_posture_rule.os_version_windows.id,
      cloudflare_zero_trust_device_posture_rule.disk_encryption.id,
      cloudflare_zero_trust_device_posture_rule.intune_integration_windows.id,
      cloudflare_zero_trust_device_posture_rule.intune_integration_mac.id
    ]
  })
}