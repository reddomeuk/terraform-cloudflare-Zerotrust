output "intune_compliance_rule_id" {
  description = "ID of the Intune compliance posture rule"
  value       = cloudflare_zero_trust_device_posture_rule.intune_compliance.id
}

output "disk_encryption_rule_id" {
  description = "ID of the disk encryption posture rule"
  value       = cloudflare_zero_trust_device_posture_rule.disk_encryption.id
}

output "os_version_rule_id" {
  description = "ID of the OS version posture rule"
  value       = cloudflare_zero_trust_device_posture_rule.os_version.id
}

output "firewall_rule_id" {
  description = "ID of the firewall posture rule"
  value       = cloudflare_zero_trust_device_posture_rule.firewall_check.id
}