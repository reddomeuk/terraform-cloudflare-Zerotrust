# Gateway Module: Manages Cloudflare Zero Trust Gateway policies and network security rules
# This module creates gateway policies for content filtering, security controls, and network access

# Gateway Location for Network Traffic Control
resource "cloudflare_zero_trust_dns_location" "gateway" {
  account_id = var.account_id
  name       = var.location_name
  
  endpoints {
    ipv4 {
      enabled = true
    }
    ipv6 {
      enabled = false
    }
    doh {
      enabled = false
    }
    dot {
      enabled = false
    }
  }
  
  networks {
    network = "10.0.0.0/8"  # Using a standard private network range
  }
}

# Security Threat Blocking Policy
# Blocks access to known malicious domains and content
resource "cloudflare_zero_trust_gateway_policy" "security_blocks" {
  account_id = var.account_id
  name       = "Security Threat Blocks"
  precedence = 1
  action     = "block"
  enabled    = true
  description = "Blocks access to known malicious domains and content"

  filters = ["dns"]
  traffic = "any(dns.security_category[*] in {4 7 9 80})"  # Malware, phishing, botnets, etc.
}

# Security Tools Access Policy
# Allows access to approved security tools and resources
resource "cloudflare_zero_trust_gateway_policy" "security_tools" {
  account_id = var.account_id
  name       = "Security Tools Access"
  precedence = 2
  action     = "allow"
  enabled    = true
  description = "Allows access to approved security tools and resources"

  filters = ["dns"]
  traffic = "any(dns.domains[*] in {\"kali.org\" \"metasploit.com\" \"hackerone.com\" \"splunk.com\" \"elastic.co\" \"sentinelone.com\"})"
}

# DNS Filtering Policy
# Controls DNS resolution for security and compliance
resource "cloudflare_zero_trust_gateway_policy" "dns_filter" {
  account_id = var.account_id
  name       = "DNS Filtering"
  precedence = 3
  action     = "block"
  enabled    = true
  description = "Controls DNS resolution for security and compliance"

  filters = ["dns"]
  traffic = "any(dns.domains[*] matches \".*\")"
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Comment out the DNS location
# resource "cloudflare_zero_trust_dns_location" "gateway" {
#   account_id = var.account_id
#   name       = var.location_name
#   
#   endpoints {
#     ipv4 {
#       enabled = true
#     }
#     ipv6 {
#       enabled = false
#     }
#     doh {
#       enabled = false
#     }
#     dot {
#       enabled = false
#     }
#   }
#   
#   networks {
#     network = "100.64.0.0/24"
#   }
# }

# Comment out the gateway policy
# resource "cloudflare_zero_trust_gateway_policy" "gateway_policy" {
#   account_id  = var.account_id
#   name        = "Default Gateway Policy"
#   description = "Gateway default policy"
#   precedence  = 1
#   action      = "allow"
#   filters     = ["dns"]
#   traffic     = "dns.type in {'A' 'AAAA'}"
# }