# Application Outputs
output "red_team_app_id" {
  description = "ID of the Red Team application"
  value       = cloudflare_zero_trust_access_application.red_team.id
}

output "blue_team_app_id" {
  description = "ID of the Blue Team application"
  value       = cloudflare_zero_trust_access_application.blue_team.id
}

output "red_team_app_domain" {
  description = "Domain of the Red Team application"
  value       = cloudflare_zero_trust_access_application.red_team.domain
}

output "blue_team_app_domain" {
  description = "Domain of the Blue Team application"
  value       = cloudflare_zero_trust_access_application.blue_team.domain
}

<<<<<<< HEAD
output "shared_app_domain" {
  description = "Domain of the shared application"
  value       = cloudflare_zero_trust_access_application.app.domain
}

# TUNNEL OUTPUTS ARE TEMPORARILY REMOVED - Uncomment when tunnels are re-enabled
# # Tunnel Outputs
# output "red_team_tunnel_id" {
#   description = "ID of the Red Team tunnel"
#   value       = cloudflare_zero_trust_tunnel_cloudflared.red_team.id
# }

# output "blue_team_tunnel_id" {
#   description = "ID of the Blue Team tunnel"
#   value       = cloudflare_zero_trust_tunnel_cloudflared.blue_team.id
# }
=======
# Tunnel Outputs
output "red_team_tunnel_id" {
  description = "ID of the Red Team tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.red_team.id
}

output "blue_team_tunnel_id" {
  description = "ID of the Blue Team tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.blue_team.id
}
>>>>>>> parent of 448b4ad (rls13)

# output "red_team_tunnel_secret" {
#   description = "Secret for the Red Team tunnel"
#   value       = random_id.red_team_tunnel_secret.b64_std
#   sensitive   = true
# }

# output "blue_team_tunnel_secret" {
#   description = "Secret for the Blue Team tunnel"
#   value       = random_id.blue_team_tunnel_secret.b64_std
#   sensitive   = true
# }

# output "red_team_tunnel_cname" {
#   description = "CNAME value for the Red Team tunnel"
#   value       = "${cloudflare_zero_trust_tunnel_cloudflared.red_team.id}.cfargotunnel.com"
# }

# output "blue_team_tunnel_cname" {
#   description = "CNAME value for the Blue Team tunnel"
#   value       = "${cloudflare_zero_trust_tunnel_cloudflared.blue_team.id}.cfargotunnel.com"
# }