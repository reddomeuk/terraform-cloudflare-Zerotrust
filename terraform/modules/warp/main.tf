# WARP Module: Manages Cloudflare WARP client configuration and device enrollment
# This module configures WARP client settings, device enrollment, and logging for security teams

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Security blocks - using consolidated security categories
resource "cloudflare_zero_trust_gateway_policy" "consolidated_security_blocks" {
  account_id  = var.account_id
  name        = "Block All Security Threats"
  description = "Block all security threats and malware based on Cloudflare's threat intelligence"
  precedence  = 10
  action      = "block"
  filters     = ["dns"]
  traffic     = "any(dns.security_category[*] in {4 7 9 80})"
}

# Content filtering for DNS
resource "cloudflare_zero_trust_gateway_policy" "content_filtering_dns" {
  account_id  = var.account_id
  name        = "Content Filtering DNS Policy"
  description = "Block inappropriate content DNS requests"
  precedence  = 20
  action      = "block"
  filters     = ["dns"]
  traffic     = "any(dns.content_category[*] in {1 4 5 6 7})"
}

# Content filtering for HTTP 
resource "cloudflare_zero_trust_gateway_policy" "content_filtering_http" {
  account_id  = var.account_id
  name        = "Content Filtering HTTP Policy"
  description = "Block inappropriate content HTTP requests"
  precedence  = 21
  action      = "block"
  filters     = ["http"]
  traffic     = "any(http.request.uri.content_category[*] in {1 4 5 6 7})"
}

# Block streaming services
resource "cloudflare_zero_trust_gateway_policy" "block_streaming" {
  account_id  = var.account_id
  name        = "Block Streaming"
  description = "Block unauthorized streaming platforms"
  precedence  = 30
  action      = "block"
  filters     = ["http"]
  traffic     = "any(http.request.uri.content_category[*] in {96})"
}

# File upload blocking with exceptions for approved services
resource "cloudflare_zero_trust_gateway_policy" "block_file_uploads" {
  account_id  = var.account_id
  name        = "Block Unauthorized File Uploads"
  description = "Block file uploads to unauthorized services"
  precedence  = 40
  action      = "block"
  filters     = ["http"]
  traffic     = "http.request.method == \"POST\" and http.request.uri matches \".*upload.*\" and not(http.request.uri matches \".*(sharepoint|onedrive|teams).*\")"
}

# Security tools allowlist - DNS only with proper syntax for domains
resource "cloudflare_zero_trust_gateway_policy" "security_tools_dns" {
  account_id  = var.account_id
  name        = "Security Tools DNS Allow"
  description = "Allow security tools domains"
  precedence  = 5
  action      = "allow"
  filters     = ["dns"]
  traffic     = "any(dns.domains[*] in {\"kali.org\" \"metasploit.com\" \"hackerone.com\" \"splunk.com\" \"elastic.co\" \"sentinelone.com\"})"
}

# Security tools allowlist - HTTP
resource "cloudflare_zero_trust_gateway_policy" "security_tools_http" {
  account_id  = var.account_id
  name        = "Security Tools HTTP Allow"
  description = "Allow security tools URLs"
  precedence  = 6
  action      = "allow"
  filters     = ["http"]
  traffic     = "http.request.uri matches \".*security-tools.*\" or http.request.uri matches \".*security-monitor.*\""
}

# Allow access to essential categories (education, business, government)
resource "cloudflare_zero_trust_gateway_policy" "allow_essential_categories" {
  account_id  = var.account_id
  name        = "Allow Essential Categories"
  description = "Allow access to educational, business, and government sites"
  precedence  = 50
  action      = "allow"
  filters     = ["http"]
  traffic     = "any(http.request.uri.content_category[*] in {12 13 18})"
}

# Red Team special access - using domain patterns
resource "cloudflare_zero_trust_gateway_policy" "security_testing_domains" {
  account_id  = var.account_id
  name        = "Security Testing Domains"
  description = "Allow access to security testing domains"
  precedence  = 7
  action      = "allow"
  filters     = ["dns"]
  # Simplified to use just domain patterns without user identity
  traffic = "any(dns.domains[*] matches \".*security.*|.*pentest.*|.*hack.*\")"
}

# Blue Team special access - using domain patterns
resource "cloudflare_zero_trust_gateway_policy" "monitoring_domains" {
  account_id  = var.account_id
  name        = "Monitoring Tools Domains"
  description = "Allow access to monitoring tools domains"
  precedence  = 8
  action      = "allow"
  filters     = ["dns"]
  # Simplified to use just domain patterns without user identity
  traffic = "any(dns.domains[*] matches \".*monitor.*|.*analytics.*|.*siem.*\")"
}

# Default block rule with valid match pattern
resource "cloudflare_zero_trust_gateway_policy" "default_block" {
  account_id  = var.account_id
  name        = "Default Block Rule"
  description = "Block all other traffic"
  precedence  = 999
  action      = "block"
  filters     = ["dns"]
  # Fix the traffic filter syntax
  traffic = "any(dns.domains[*] matches \".*\")"
}

# WARP enrollment application
resource "cloudflare_zero_trust_access_application" "warp_enrollment_app" {
  account_id                = var.account_id
  session_duration          = "24h"
  name                      = "${var.warp_name} - Device Enrollment"
  allowed_idps              = [var.azure_ad_provider_id]
  auto_redirect_to_identity = true
  type                      = "warp"
  app_launcher_visible      = false

  lifecycle {
    create_before_destroy = true
  }
}

# Team-specific WARP enrollment policies
resource "cloudflare_zero_trust_access_policy" "red_team_warp_policy" {
  application_id = cloudflare_zero_trust_access_application.warp_enrollment_app.id
  account_id     = var.account_id
  name           = "Red Team WARP Access"
  decision       = "allow"
  precedence     = 1

  include {
    azure {
      id                   = var.red_team_group_ids
      identity_provider_id = var.azure_ad_provider_id
    }
  }
}

resource "cloudflare_zero_trust_access_policy" "blue_team_warp_policy" {
  application_id = cloudflare_zero_trust_access_application.warp_enrollment_app.id
  account_id     = var.account_id
  name           = "Blue Team WARP Access"
  decision       = "allow"
  precedence     = 2

  include {
    azure {
      id                   = var.blue_team_group_ids
      identity_provider_id = var.azure_ad_provider_id
    }
  }
}

# WARP Client Configuration
# Sets up the WARP client with team-specific settings and security requirements
resource "cloudflare_zero_trust_warp_client" "warp" {
  account_id = var.account_id
  name       = var.warp_name
  enabled    = true

  # Device enrollment settings
  device_enrollment {
    enabled = true
    require_all = true
    rules {
      platform = "windows"
      os_version {
        operator = ">="
        version  = "10.0.19044"
      }
    }
  }

  # Security settings
  security {
    tls_verify = true
    dns {
      servers = ["1.1.1.1", "1.0.0.1"]
    }
  }
}

# WARP Device Posture Integration
# Integrates WARP with device posture checks for enhanced security
resource "cloudflare_zero_trust_device_posture_integration" "warp" {
  account_id = var.account_id
  name       = "WARP Device Posture"
  type       = "warp"
  interval   = "30m"
  config {
    client_id     = var.azure_client_id
    client_secret = var.azure_client_secret
    customer_id   = var.azure_directory_id
  }
}

# WARP Logging Configuration
# Sets up logging to Azure Blob Storage for audit and security analysis
resource "cloudflare_logpush_job" "warp_logs" {
  account_id = var.account_id
  name       = "WARP Logs"
  destination_conf = "azure://${var.azure_storage_account}.blob.core.windows.net/${var.azure_storage_container}?${var.azure_sas_token}"
  dataset    = "warp"
  enabled    = var.enable_logs
  logpull_options = "fields=ClientIP,ClientRequestHost,ClientRequestMethod,ClientRequestURI,EdgeEndTimestamp,EdgeResponseBytes,EdgeResponseStatus,EdgeStartTimestamp,RayID,RequestHeaders,ResponseHeaders,UserAgent"
}