# Device Posture Module: Manages Cloudflare Zero Trust device posture rules and Microsoft Intune integration
# This module creates device compliance rules and integrates with Microsoft Intune for device posture checks

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0" # Keep at version 4
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

# Disk Encryption Rule
# Ensures devices have disk encryption enabled for data protection
resource "cloudflare_zero_trust_device_posture_rule" "disk_encryption" {
  account_id = var.account_id
  name       = "Disk Encryption Check"
  type       = "disk_encryption"
  description = "Checks if disk encryption is enabled on the device"
  schedule   = "30m"
  match {
    platform = "windows"
  }
  input {
    check_disks = ["C:"]
    require_all = true
  }
}

# OS Version Rule
# Ensures devices are running supported and secure operating system versions
resource "cloudflare_zero_trust_device_posture_rule" "os_version" {
  account_id = var.account_id
  name       = "OS Version Check"
  type       = "os_version"
  description = "Checks if the device is running a supported OS version"
  schedule   = "30m"
  match {
    platform = "windows"
  }
  input {
    version = "10.0.19044"
    operator = ">="
  }
}

# Intune Compliance Rule
# Checks device compliance status through Microsoft Intune
resource "cloudflare_zero_trust_device_posture_rule" "intune_compliance" {
  account_id = var.account_id
  name       = "Intune Compliance Check"
  type       = "intune"
  description = "Checks device compliance through Microsoft Intune"
  schedule   = "30m"
  match {
    platform = "windows"
  }
  input {
    compliance_status = "compliant"
  }
}

# Using removed block to safely remove the domain_joined_check resource
removed {
  from = cloudflare_zero_trust_device_posture_rule.domain_joined_check
  lifecycle {
    destroy = false
  }
}

# Firewall Check - additional security
resource "cloudflare_zero_trust_device_posture_rule" "firewall_check" {
  account_id  = var.account_id
  name        = "Firewall Status Check"
  description = "Ensure device firewall is enabled"
  type        = "firewall"

  match {
    platform = "windows"
  }

  depends_on = [cloudflare_zero_trust_device_posture_integration.intune]
}