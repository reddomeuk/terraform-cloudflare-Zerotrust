variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "app_name" {
  description = "Name of the shared application"
  type        = string
  default     = "RedDome Shared App"
}

variable "red_team_app_domain" {
  description = "Domain for the Red Team application"
  type        = string
  default     = "redteam.reddome.org"
}

variable "blue_team_app_domain" {
  description = "Domain for the Blue Team application"
  type        = string
  default     = "blueteam.reddome.org"
}

variable "allowed_emails" {
  description = "List of allowed email addresses for shared app access"
  type        = list(string)
  default     = []
} 