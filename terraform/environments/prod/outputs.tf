output "teams_account_id" {
  value = module.warp.teams_account_id
}

output "shared_app_domain" {
  value       = module.access.shared_app_domain
  description = "Domain for the shared application"
}

output "red_team_app_domain" {
  value       = module.access.red_team_app_domain
  description = "Domain for the Red Team application"
}

output "blue_team_app_domain" {
  value       = module.access.blue_team_app_domain
  description = "Domain for the Blue Team application"
}

output "warp_enrollment_url" {
  value       = "https://${module.access.shared_app_domain}/warp"
  description = "URL for WARP client enrollment"
}