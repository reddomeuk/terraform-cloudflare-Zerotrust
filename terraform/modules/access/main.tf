# Access Module: Manages Cloudflare Zero Trust Access applications and policies for Red and Blue teams
# This module creates team-specific applications, access policies, and tunnels with proper security controls

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=4.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.0.0"
    }
  }
}

# Handle resource transitions
moved {
  from = cloudflare_zero_trust_access_application.red_team_app
  to   = cloudflare_zero_trust_access_application.red_team
}

moved {
  from = cloudflare_zero_trust_access_application.blue_team_app
  to   = cloudflare_zero_trust_access_application.blue_team
}

# Shared application (accessible by both teams)
resource "cloudflare_zero_trust_access_application" "app" {
  account_id           = var.account_id
  name                 = var.app_name
  domain               = "reddome.org"
  type                 = "self_hosted"
  session_duration     = "24h"
  app_launcher_visible = true
}

# Red Team Access Application
resource "cloudflare_zero_trust_access_application" "red_team" {
  account_id = var.account_id
  name       = "${var.red_team_name} Application"
  domain     = var.red_team_app_domain
  type       = "self_hosted"
  session_duration = "24h"
}

# Blue Team Access Application
resource "cloudflare_zero_trust_access_application" "blue_team" {
  account_id = var.account_id
  name       = "${var.blue_team_name} Application"
  domain     = var.blue_team_app_domain
  type       = "self_hosted"
  session_duration = "24h"
}

# Policy for email-based access to the shared app
resource "cloudflare_zero_trust_access_policy" "email_policy" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.app.id
  name           = "Email Access Policy"
  precedence     = 2
  decision       = "allow"

  include {
    email = var.allowed_emails
  }
}

# Red Team Access Policy
resource "cloudflare_zero_trust_access_policy" "red_team" {
  account_id = var.account_id
  name       = "${var.red_team_name} Access Policy"
  application_id = cloudflare_zero_trust_access_application.red_team.id
  decision   = "allow"
  precedence = 1

  include {
    group = [var.red_team_group_id]
  }

  require {
    device_posture = var.device_posture_rule_ids
  }
}

# Blue Team Access Policy
resource "cloudflare_zero_trust_access_policy" "blue_team" {
  account_id = var.account_id
  name       = "${var.blue_team_name} Access Policy"
  application_id = cloudflare_zero_trust_access_application.blue_team.id
  decision   = "allow"
  precedence = 2

  include {
    group = [var.blue_team_group_id]
  }

  require {
    device_posture = var.device_posture_rule_ids
  }
}

# TUNNELS ARE TEMPORARILY REMOVED - Uncomment when ready to use
# # Tunnel Secrets
# resource "random_id" "red_team_tunnel_secret" {
#   byte_length = 32
# }

# resource "random_id" "blue_team_tunnel_secret" {
#   byte_length = 32
# }

# # Red Team Tunnel
# resource "cloudflare_zero_trust_tunnel_cloudflared" "red_team" {
#   account_id = var.cloudflare_account_id
#   name       = "red-team-tunnel"
#   secret     = random_id.red_team_tunnel_secret.b64_std
# }

# resource "cloudflare_zero_trust_tunnel_cloudflared_config" "red_team" {
#   account_id = var.cloudflare_account_id
#   tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.red_team.id

#   config {
#     ingress_rule {
#       hostname = "red-team.${var.domain}"
#       service  = "http://localhost:8080"
#     }
#     ingress_rule {
#       service = "http_status:404"
#     }
#   }
# }

# # Blue Team Tunnel
# resource "cloudflare_zero_trust_tunnel_cloudflared" "blue_team" {
#   account_id = var.cloudflare_account_id
#   name       = "blue-team-tunnel"
#   secret     = random_id.blue_team_tunnel_secret.b64_std
# }

# resource "cloudflare_zero_trust_tunnel_cloudflared_config" "blue_team" {
#   account_id = var.cloudflare_account_id
#   tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.blue_team.id

#   config {
#     ingress_rule {
#       hostname = "blue-team.${var.domain}"
#       service  = "http://localhost:8080"
#     }
#     ingress_rule {
#       service = "http_status:404"
#     }
#   }
# }