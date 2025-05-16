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

# Azure AD Configuration
variable "azure_client_id" {
  description = "Azure AD application client ID"
  type        = string
  sensitive   = true
}

variable "azure_client_secret" {
  description = "Azure AD application client secret"
  type        = string
  sensitive   = true
}

variable "azure_directory_id" {
  description = "Azure AD directory (tenant) ID"
  type        = string
}

# Team Group IDs
variable "red_team_group_ids" {
  description = "List of Azure AD group IDs for red team members"
  type        = list(string)
  default     = []
}

variable "blue_team_group_ids" {
  description = "List of Azure AD group IDs for blue team members"
  type        = list(string)
  default     = []
} 