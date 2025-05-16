# Access Module: Manages Cloudflare Zero Trust Access applications and policies for Red and Blue teams
# This module creates team-specific applications, access policies, and tunnels with proper security controls

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
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
  name       = "${var.red_team_name}-Security-Group-App"
  domain     = "redteam.reddome.org"
  type       = "self_hosted"
  session_duration = "24h"
  cors_headers {
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]
    allowed_origins = ["https://*.reddome.org"]
    allow_credentials = true
  }
}

# Blue Team Access Application
resource "cloudflare_zero_trust_access_application" "blue_team_app" {
  account_id = var.account_id
  name       = "${var.blue_team_name}-Security-Group-App"
  domain     = "blueteam.reddome.org"
  type       = "self_hosted"
  session_duration = "24h"
  cors_headers {
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]
    allowed_origins = ["https://*.reddome.org"]
    allow_credentials = true
  }
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
  name       = "${var.red_team_name}-Security-Group-Policy"
  decision   = "allow"
  precedence = 1

  include {
    group = [var.red_team_id]
  }

  require {
    device_posture = var.device_posture_rule_ids
  }

  purpose_justification_required = true
  purpose_justification_prompt   = "Please provide a business justification for accessing this application."
}

# Blue Team Access Policy
resource "cloudflare_zero_trust_access_policy" "blue_team_policy" {
  account_id = var.account_id
  name       = "${var.blue_team_name}-Security-Group-Policy"
  decision   = "allow"
  precedence = 2

  include {
    group = [var.blue_team_id]
  }

  require {
    device_posture = var.device_posture_rule_ids
  }

  purpose_justification_required = true
  purpose_justification_prompt   = "Please provide a business justification for accessing this application."
}

# Red Team Tunnel Configuration
resource "cloudflare_zero_trust_tunnel_cloudflared" "red_team" {
  account_id = var.account_id
  name       = "${var.red_team_name}-Security-Group-Tunnel"
  secret     = random_password.red_tunnel_secret.result
}

# Red Team Tunnel Ingress Rules
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "red_team" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.red_team.id

  config {
    ingress_rule {
      hostname = "report.reddome.org"
      service  = "http://localhost:8080"
      origin_request {
        connect_timeout = "30s"
        no_tls_verify   = false
      }
    }

    ingress_rule {
      hostname = "nessus.reddome.org"
      service  = "http://localhost:8834"
      origin_request {
        connect_timeout = "30s"
        no_tls_verify   = false
      }
    }
  }
}

# Blue Team Tunnel Configuration
resource "cloudflare_zero_trust_tunnel_cloudflared" "blue_team" {
  account_id = var.account_id
  name       = "${var.blue_team_name}-Security-Group-Tunnel"
  secret     = random_password.blue_tunnel_secret.result
}

# Blue Team Tunnel Ingress Rules
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "blue_team" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.blue_team.id

  config {
    ingress_rule {
      hostname = "monitoring.reddome.org"
      service  = "http://localhost:3000"
      origin_request {
        connect_timeout = "30s"
        no_tls_verify   = false
      }
    }
  }
}

# Random password for Red Team tunnel with enhanced security
resource "random_password" "red_tunnel_secret" {
  length           = 32
  special          = true
  override_special = "!@#$%^&*()_+"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}

# Random password for Blue Team tunnel with enhanced security
resource "random_password" "blue_tunnel_secret" {
  length           = 32
  special          = true
  override_special = "!@#$%^&*()_+"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}