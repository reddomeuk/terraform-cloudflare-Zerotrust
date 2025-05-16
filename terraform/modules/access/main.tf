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
resource "cloudflare_zero_trust_access_application" "red_team_app" {
  account_id = var.account_id
  name       = "Red Team App"
  domain     = var.red_team_app_domain
  type       = "self_hosted"
}

# Blue Team Access Application
resource "cloudflare_zero_trust_access_application" "blue_team_app" {
  account_id = var.account_id
  name       = "Blue Team App"
  domain     = var.blue_team_app_domain
  type       = "self_hosted"
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
resource "cloudflare_zero_trust_access_policy" "red_team_policy" {
  account_id = var.account_id
  name       = "Red Team Access"
  precedence = 1
  decision   = "allow"

  include {
    group = [var.red_team_group_id]
  }

  application_id = cloudflare_zero_trust_access_application.red_team_app.id
}

# Blue Team Access Policy
resource "cloudflare_zero_trust_access_policy" "blue_team_policy" {
  account_id = var.account_id
  name       = "Blue Team Access"
  precedence = 2
  decision   = "allow"

  include {
    group = [var.blue_team_group_id]
  }

  application_id = cloudflare_zero_trust_access_application.blue_team_app.id
}

# Red Team Tunnel
resource "cloudflare_tunnel" "red_team" {
  account_id = var.account_id
  name       = "red-team-tunnel"
  secret     = random_password.red_tunnel_secret.result
}

# Blue Team Tunnel
resource "cloudflare_tunnel" "blue_team" {
  account_id = var.account_id
  name       = "blue-team-tunnel"
  secret     = random_password.blue_tunnel_secret.result
}

# Red Team Tunnel Configuration
resource "cloudflare_tunnel_config" "red_team" {
  account_id = var.account_id
  tunnel_id  = cloudflare_tunnel.red_team.id

  config {
    ingress_rule {
      hostname = var.red_team_app_domain
      service  = "http://localhost:8000"
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# Blue Team Tunnel Configuration
resource "cloudflare_tunnel_config" "blue_team" {
  account_id = var.account_id
  tunnel_id  = cloudflare_tunnel.blue_team.id

  config {
    ingress_rule {
      hostname = var.blue_team_app_domain
      service  = "http://localhost:8001"
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# Generate random secrets for tunnels
resource "random_password" "red_tunnel_secret" {
  length  = 32
  special = false
}

resource "random_password" "blue_tunnel_secret" {
  length  = 32
  special = false
}