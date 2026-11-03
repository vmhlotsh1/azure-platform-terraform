variable "name_prefix" {
  description = "Short prefix used in the vault name. The full name is capped at 24 characters."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group the vault lives in."
  type        = string
}

variable "soft_delete_retention_days" {
  description = "Days a deleted secret can still be recovered (7 to 90)."
  type        = number
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "public_network_access_enabled" {
  description = "Whether the vault accepts traffic from public networks at all. Network rules still apply when true."
  type        = bool
  default     = false
}

variable "allowed_ip_ranges" {
  description = "Public IP ranges (CIDR) allowed through the vault firewall."
  type        = list(string)
  default     = []
}

variable "allowed_subnet_ids" {
  description = "Subnet IDs allowed through the vault firewall. The subnets need the Microsoft.KeyVault service endpoint."
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "Workspace that receives the vault's audit logs. Leave null to skip diagnostics."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
