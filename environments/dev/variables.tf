variable "subscription_id" {
  description = "Azure subscription to deploy into. Pass it with TF_VAR_subscription_id rather than committing it."
  type        = string
}

variable "project" {
  description = "Short project name used in resource names."
  type        = string
}

variable "environment" {
  description = "Environment name, for example dev or prod."
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be dev, test or prod."
  }
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "southafricanorth"
}

variable "address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
}

variable "subnets" {
  description = "Subnets and the inbound traffic each allows. Must include an \"app\" subnet."
  type = map(object({
    address_prefix    = string
    service_endpoints = optional(list(string), [])
    allowed_inbound = optional(list(object({
      name     = string
      priority = number
      protocol = string
      port     = string
      source   = string
    })), [])
  }))

  validation {
    condition     = contains(keys(var.subnets), "app")
    error_message = "subnets must include an \"app\" subnet; the Key Vault firewall allows it."
  }
}

variable "key_vault_allowed_ip_ranges" {
  description = "Public IP ranges (CIDR) allowed through the Key Vault firewall, for example a CI runner or office IP."
  type        = list(string)
  default     = []
}

variable "log_retention_days" {
  description = "How long logs are kept."
  type        = number
  default     = 30
}

variable "log_daily_quota_gb" {
  description = "Daily log ingestion cap in GB. Use -1 for no cap."
  type        = number
  default     = -1
}

variable "extra_tags" {
  description = "Additional tags, for example cost centre or owner."
  type        = map(string)
  default     = {}
}
