variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "location_name" {
  description = "Gateway Location Name"
  type        = string
  default     = "Default Location"
}

variable "networks" {
  description = "List of networks for the gateway"
  type        = list(string)
  default     = []
}
