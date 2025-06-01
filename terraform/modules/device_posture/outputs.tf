output "intune_compliance_rule_id" {
  description = "ID of the Windows Intune compliance posture rule"
  value       = cloudflare_zero_trust_device_posture_rule.intune_compliance.id
}

output "intune_compliance_rule_id_macos" {
  description = "ID of the macOS Intune compliance posture rule"
  value       = cloudflare_zero_trust_device_posture_rule.intune_compliance_macos.id
}

output "disk_encryption_rule_id" {
  description = "ID of the Windows disk encryption posture rule"
  value       = cloudflare_zero_trust_device_posture_rule.disk_encryption.id
}

output "disk_encryption_rule_id_macos" {
  description = "ID of the macOS disk encryption posture rule"
  value       = cloudflare_zero_trust_device_posture_rule.disk_encryption_macos.id
}

output "os_version_rule_id" {
  description = "ID of the Windows OS version posture rule"
  value       = cloudflare_zero_trust_device_posture_rule.os_version.id
}

output "os_version_rule_id_macos" {
  description = "ID of the macOS OS version posture rule"
  value       = cloudflare_zero_trust_device_posture_rule.os_version_macos.id
}

output "firewall_rule_id" {
  description = "ID of the Windows firewall posture rule"
  value       = cloudflare_zero_trust_device_posture_rule.firewall_check.id
}

output "firewall_rule_id_macos" {
  description = "ID of the macOS firewall posture rule"
  value       = cloudflare_zero_trust_device_posture_rule.firewall_check_macos.id
}

# Consolidated lists for easy consumption
output "all_posture_rule_ids" {
  description = "List of all device posture rule IDs"
  value = [
    cloudflare_zero_trust_device_posture_rule.disk_encryption.id,
    cloudflare_zero_trust_device_posture_rule.disk_encryption_macos.id,
    cloudflare_zero_trust_device_posture_rule.os_version.id,
    cloudflare_zero_trust_device_posture_rule.os_version_macos.id,
    cloudflare_zero_trust_device_posture_rule.intune_compliance.id,
    cloudflare_zero_trust_device_posture_rule.intune_compliance_macos.id,
    cloudflare_zero_trust_device_posture_rule.firewall_check.id,
    cloudflare_zero_trust_device_posture_rule.firewall_check_macos.id
  ]
}