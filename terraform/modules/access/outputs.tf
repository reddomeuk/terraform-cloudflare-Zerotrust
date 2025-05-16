# Application Outputs
output "red_team_app_id" {
  description = "ID of the Red Team Access Application"
  value       = cloudflare_zero_trust_access_application.red_team_app.id
}

output "blue_team_app_id" {
  description = "ID of the Blue Team Access Application"
  value       = cloudflare_zero_trust_access_application.blue_team_app.id
}

output "red_team_app_domain" {
  description = "Domain of the Red Team Access Application"
  value       = cloudflare_zero_trust_access_application.red_team_app.domain
}

output "blue_team_app_domain" {
  description = "Domain of the Blue Team Access Application"
  value       = cloudflare_zero_trust_access_application.blue_team_app.domain
}

output "shared_app_domain" {
  description = "Domain of the shared application"
  value       = cloudflare_zero_trust_access_application.app.domain
}

# Tunnel Outputs
output "red_team_tunnel_id" {
  description = "ID of the Red Team tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.red_team.id
  sensitive   = true
}

output "blue_team_tunnel_id" {
  description = "ID of the Blue Team tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.blue_team.id
  sensitive   = true
}

output "red_team_tunnel_token" {
  description = "Token for the Red Team tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.red_team.tunnel_token
  sensitive   = true
}

output "blue_team_tunnel_token" {
  description = "Token for the Blue Team tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.blue_team.tunnel_token
  sensitive   = true
}

output "red_team_tunnel_secret" {
  description = "Secret for the Red Team tunnel"
  value       = random_password.red_tunnel_secret.result
  sensitive   = true
}

output "blue_team_tunnel_secret" {
  description = "Secret for the Blue Team tunnel"
  value       = random_password.blue_tunnel_secret.result
  sensitive   = true
}