output "intune_compliance_rule_id" {
  value       = cloudflare_zero_trust_device_posture_rule.intune_compliance.id
  description = "The ID of the Intune compliance posture rule"
}

output "disk_encryption_rule_id" {
  value       = cloudflare_zero_trust_device_posture_rule.disk_encryption.id
  description = "The ID of the disk encryption posture rule"
}

output "os_version_rule_id" {
  value       = cloudflare_zero_trust_device_posture_rule.os_version_windows.id
  description = "The ID of the OS version posture rule"
}

output "firewall_rule_id" {
  value       = cloudflare_zero_trust_device_posture_rule.firewall_check.id
  description = "The ID of the firewall posture rule"
}