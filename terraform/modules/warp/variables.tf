variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "warp_name" {
  description = "Name for the WARP configuration"
  type        = string
  default     = "Default WARP Configuration"
}

variable "azure_ad_provider_id" {
  description = "ID of the Azure AD identity provider created in Cloudflare"
  type        = string
}

variable "security_teams_id" {
  description = "ID of the security teams access group"
  type        = string
  default     = ""
}

variable "azure_group_ids" {
  description = "List of Azure AD Group IDs for security access"
  type        = list(string)
  default     = ["00000000-0000-0000-0000-000000000000"] # Default placeholder
}

variable "red_team_name" {
  description = "Name of the Red Team group"
  type        = string
  default     = "Red Team"
}

variable "blue_team_name" {
  description = "Name of the Blue Team group"
  type        = string
  default     = "Blue Team"
}

variable "red_team_group_ids" {
  description = "List of Azure AD group IDs for Red Team members"
  type        = list(string)
  default     = []
}

variable "blue_team_group_ids" {
  description = "List of Azure AD group IDs for Blue Team members"
  type        = list(string)
  default     = []
}

variable "enable_logs" {
  description = "Enable Gateway logs"
  type        = bool
  default     = false
}

# Azure Storage variables
variable "azure_storage_account" {
  description = "Azure Storage Account name"
  type        = string
  default     = ""
}

variable "azure_storage_container" {
  description = "Azure Storage Container name"
  type        = string
  default     = "gateway-logs"
}

variable "azure_sas_token" {
  description = "Azure SAS token for logging"
  type        = string
  default     = ""
  sensitive   = true
}
