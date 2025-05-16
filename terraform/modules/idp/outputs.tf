output "entra_idp_id" {
  description = "ID of the Microsoft Entra ID identity provider"
  value       = cloudflare_zero_trust_access_identity_provider.entra_id.id
}

output "red_team_id" {
  description = "ID of the Red Team access group"
  value       = cloudflare_zero_trust_access_group.red_team.id
}

output "blue_team_id" {
  description = "ID of the Blue Team access group"
  value       = cloudflare_zero_trust_access_group.blue_team.id
}

output "secure_devices_id" {
  description = "ID of the secure devices access group"
  value       = cloudflare_zero_trust_access_group.secure_devices.id
}