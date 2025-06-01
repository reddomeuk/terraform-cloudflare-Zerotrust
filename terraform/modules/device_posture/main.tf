# Device Posture Module: Manages Cloudflare Zero Trust device posture rules and Microsoft Intune integration
# This module creates device compliance rules and integrates with Microsoft Intune for device posture checks

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Microsoft Intune Integration for Device Posture
resource "cloudflare_zero_trust_device_posture_integration" "intune" {
  account_id = var.account_id
  name       = "Microsoft Intune"
  type       = "intune"
  interval   = "30m"
  config {
    client_id     = var.intune_client_id
    client_secret = var.intune_client_secret
    customer_id   = var.azure_tenant_id
  }
}

# Disk Encryption Rule - Windows
resource "cloudflare_zero_trust_device_posture_rule" "disk_encryption" {
  account_id = var.account_id
  name       = "Disk Encryption Check - Windows"
  type       = "disk_encryption"
  description = "Checks if disk encryption is enabled on Windows devices"
  schedule   = "30m"
  expiration = "30m"
  match {
    platform = "windows"
  }
  input {
    check_disks = ["C:"]
    require_all = true
  }
}

# Disk Encryption Rule - macOS
resource "cloudflare_zero_trust_device_posture_rule" "disk_encryption_macos" {
  account_id = var.account_id
  name       = "Disk Encryption Check - macOS"
  type       = "disk_encryption"
  description = "Checks if FileVault is enabled on macOS devices"
  schedule   = "30m"
  expiration = "30m"
  match {
    platform = "mac"
  }
  input {
    check_disks = ["/"]
    require_all = true
  }
}

# OS Version Rule - Windows
resource "cloudflare_zero_trust_device_posture_rule" "os_version" {
  account_id = var.account_id
  name       = "OS Version Check - Windows"
  type       = "os_version"
  description = "Checks if Windows device is running a supported OS version"
  schedule   = "30m"
  expiration = "30m"
  match {
    platform = "windows"
  }
  input {
    version = "10.0.19044"
    operator = ">="
  }
}

# OS Version Rule - macOS
resource "cloudflare_zero_trust_device_posture_rule" "os_version_macos" {
  account_id = var.account_id
  name       = "OS Version Check - macOS"
  type       = "os_version"
  description = "Checks if macOS device is running a supported OS version"
  schedule   = "30m"
  expiration = "30m"
  match {
    platform = "mac"
  }
  input {
    version = "12.0.0"
    operator = ">="
  }
}

# Intune Compliance Rule - Windows
resource "cloudflare_zero_trust_device_posture_rule" "intune_compliance" {
  account_id = var.account_id
  name       = "Intune Compliance Check - Windows"
  type       = "intune"
  description = "Checks Windows device compliance through Microsoft Intune"
  schedule   = "30m"
  expiration = "30m"
  match {
    platform = "windows"
  }
  input {
    compliance_status = "compliant"
  }
}

# Intune Compliance Rule - macOS
resource "cloudflare_zero_trust_device_posture_rule" "intune_compliance_macos" {
  account_id = var.account_id
  name       = "Intune Compliance Check - macOS"
  type       = "intune"
  description = "Checks macOS device compliance through Microsoft Intune"
  schedule   = "30m"
  expiration = "30m"
  match {
    platform = "mac"
  }
  input {
    compliance_status = "compliant"
  }
}

# Firewall Check - Windows
resource "cloudflare_zero_trust_device_posture_rule" "firewall_check" {
  account_id  = var.account_id
  name        = "Firewall Status Check - Windows"
  description = "Ensure Windows firewall is enabled"
  type        = "firewall"
  schedule    = "30m"
  expiration  = "30m"
  match {
    platform = "windows"
  }
  depends_on = [cloudflare_zero_trust_device_posture_integration.intune]
}

# Firewall Check - macOS
resource "cloudflare_zero_trust_device_posture_rule" "firewall_check_macos" {
  account_id  = var.account_id
  name        = "Firewall Status Check - macOS"
  description = "Ensure macOS firewall is enabled"
  type        = "firewall"
  schedule    = "30m"
  expiration  = "30m"
  match {
    platform = "mac"
  }
  depends_on = [cloudflare_zero_trust_device_posture_integration.intune]
}

# Using removed block to safely remove the domain_joined_check resource
removed {
  from = cloudflare_zero_trust_device_posture_rule.domain_joined_check
  lifecycle {
    destroy = false
  }
}