variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "azure_client_id" {
  description = "Azure AD client ID"
  type        = string
  sensitive   = true
}

variable "azure_client_secret" {
  description = "Azure AD client secret"
  type        = string
  sensitive   = true
}

variable "azure_directory_id" {
  description = "Azure AD directory ID"
  type        = string
}

variable "red_team_group_ids" {
  description = "List of Azure AD group IDs for Red Team"
  type        = list(string)
}

variable "blue_team_group_ids" {
  description = "List of Azure AD group IDs for Blue Team"
  type        = list(string)
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "RedDome App"
}

variable "red_team_app_domain" {
  description = "Domain for Red Team application"
  type        = string
  default     = "red.reddome.org"
}

variable "blue_team_app_domain" {
  description = "Domain for Blue Team application"
  type        = string
  default     = "blue.reddome.org"
}

variable "allowed_emails" {
  description = "List of allowed email addresses"
  type        = list(string)
  default     = []
}