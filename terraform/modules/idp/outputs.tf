output "entra_idp_id" {
  value       = cloudflare_zero_trust_access_identity_provider.microsoft_entra_id.id
  description = "ID of the Azure AD (Entra ID) identity provider"
}

output "red_team_id" {
  value       = cloudflare_zero_trust_access_group.red_team.id
  description = "ID of the Red Team access group"
}

output "blue_team_id" {
  value       = cloudflare_zero_trust_access_group.blue_team.id
  description = "ID of the Blue Team access group"
}

output "secure_devices_id" {
  value       = cloudflare_zero_trust_access_group.secure_devices.id
  description = "ID of the Secure Devices access group"
}