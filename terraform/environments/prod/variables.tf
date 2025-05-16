variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "azure_client_id" {
  description = "Azure AD client ID for authentication"
  type        = string
  sensitive   = true
}

variable "azure_client_secret" {
  description = "Azure AD client secret for authentication"
  type        = string
  sensitive   = true
}

variable "azure_directory_id" {
  description = "Azure AD directory ID"
  type        = string
}

variable "intune_client_id" {
  description = "Microsoft Intune client ID"
  type        = string
  sensitive   = true
}

variable "intune_client_secret" {
  description = "Microsoft Intune client secret"
  type        = string
  sensitive   = true
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
  description = "Enable logging to Azure Blob Storage"
  type        = bool
  default     = false
}

variable "azure_storage_account" {
  description = "Azure Storage account name for logs"
  type        = string
  default     = ""
}

variable "azure_storage_container" {
  description = "Azure Storage container name for logs"
  type        = string
  default     = ""
}

variable "azure_sas_token" {
  description = "Azure Storage SAS token for logs"
  type        = string
  sensitive   = true
  default     = ""
}