variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "app_name" {
  description = "Access Application Name"
  type        = string
}

variable "app_domain" {
  description = "Application Domain"
  type        = string
}

variable "allowed_emails" {
  description = "List of allowed email addresses"
  type        = list(string)
  default     = []
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

variable "red_team_id" {
  description = "ID of the Red Team rule group"
  type        = string
}

variable "blue_team_id" {
  description = "ID of the Blue Team rule group"
  type        = string
}

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

variable "device_posture_rule_ids" {
  description = "List of device posture rule IDs to require"
  type        = list(string)
  default     = []
}