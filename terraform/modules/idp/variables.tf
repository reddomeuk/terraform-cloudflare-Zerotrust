# terraform/modules/idp/variables.tf
variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "azure_client_id" {
  description = "Microsoft Entra ID Client ID"
  type        = string
}

variable "azure_client_secret" {
  description = "Microsoft Entra ID Client Secret"
  type        = string
  sensitive   = true
}

variable "azure_directory_id" {
  description = "Microsoft Entra ID Directory ID (Tenant ID)"
  type        = string
}

# Red team variable
variable "red_team_name" {
  description = "Name for the red team access group"
  type        = string
  default     = "Red Team"
}

variable "red_team_group_ids" {
  description = "List of Azure AD group IDs for red team members"
  type        = list(string)
  default     = []
}

# Blue team variable
variable "blue_team_name" {
  description = "Name for the blue team access group"
  type        = string
  default     = "Blue Team"
}

variable "blue_team_group_ids" {
  description = "List of Azure AD group IDs for blue team members"
  type        = list(string)
  default     = []
}