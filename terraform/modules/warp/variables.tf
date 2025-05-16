variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "warp_name" {
  description = "Name of the WARP client configuration"
  type        = string
}

variable "azure_client_id" {
  description = "Azure AD client ID for WARP integration"
  type        = string
  sensitive   = true
}

variable "azure_client_secret" {
  description = "Azure AD client secret for WARP integration"
  type        = string
  sensitive   = true
}

variable "azure_directory_id" {
  description = "Azure AD directory ID for WARP integration"
  type        = string
}

variable "enable_logs" {
  description = "Enable WARP logging to Azure Blob Storage"
  type        = bool
  default     = false
}

variable "azure_storage_account" {
  description = "Azure Storage account name for WARP logs"
  type        = string
  default     = ""
}

variable "azure_storage_container" {
  description = "Azure Storage container name for WARP logs"
  type        = string
  default     = ""
}

variable "azure_sas_token" {
  description = "Azure Storage SAS token for WARP logs"
  type        = string
  sensitive   = true
  default     = ""
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
