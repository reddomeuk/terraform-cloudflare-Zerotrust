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

# Red Team specific application
resource "cloudflare_zero_trust_access_application" "red_team_app" {
  account_id           = var.account_id
  name                 = "RedTeam-Security-Group-App"
  domain               = "redteam.reddome.org"
  type                 = "self_hosted"
  session_duration     = "24h"
  app_launcher_visible = true
}

# Blue Team specific application
resource "cloudflare_zero_trust_access_application" "blue_team_app" {
  account_id           = var.account_id
  name                 = "BlueTeam-Security-Group-App"
  domain               = "blueteam.reddome.org"
  type                 = "self_hosted"
  session_duration     = "24h"
  app_launcher_visible = true
}

# Red team access policy
resource "cloudflare_zero_trust_access_policy" "red_team_policy" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.red_team_app.id
  name           = "RedTeam-Security-Group-Access"
  precedence     = 1
  decision       = "allow"

  include {
    gsuite {
      email = var.red_team_group_ids
      identity_provider_id = var.azure_ad_provider_id
    }
  }
  
  # Require device posture check for disk encryption
  require {
    device_posture = ["disk_encryption"]
  }
}

# Blue team access policy
resource "cloudflare_zero_trust_access_policy" "blue_team_policy" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.blue_team_app.id
  name           = "BlueTeam-Security-Group-Access"
  precedence     = 1
  decision       = "allow"

  include {
    gsuite {
      email = var.blue_team_group_ids
      identity_provider_id = var.azure_ad_provider_id
    }
  }
  
  # Require device posture check for disk encryption
  require {
    device_posture = ["disk_encryption"]
  }
}

# Red Team tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "red_team" {
  account_id = var.account_id
  name       = "RedTeam-Security-Group-Tunnel"
  secret     = base64encode(random_password.red_tunnel_secret.result)
}

resource "random_password" "red_tunnel_secret" {
  length  = 32
  special = true
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "red_team" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.red_team.id

  config {
    ingress_rule {
      hostname = "redteam.reddome.org"
      service  = "http://localhost:8080"
    }
    ingress_rule {
      hostname = "report.reddome.org"
      service  = "http://localhost:8000"
    }
    ingress_rule {
      hostname = "nessus.reddome.org"
      service  = "https://localhost:8834"
      origin_request {
        no_tls_verify = true
      }
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# Blue Team tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "blue_team" {
  account_id = var.account_id
  name       = "BlueTeam-Security-Group-Tunnel"
  secret     = base64encode(random_password.blue_tunnel_secret.result)
}

resource "random_password" "blue_tunnel_secret" {
  length      = 32
  special     = true
  min_special = 2
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "blue_team" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.blue_team.id

  config {
    ingress_rule {
      hostname = "blueteam.reddome.org"
      service  = "http://localhost:8081"
      # Add origin request settings
      origin_request {
        connect_timeout = "30s"
        no_tls_verify  = false
      }
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}