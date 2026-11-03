variable "name_prefix" {
  description = "Prefix used in resource names, for example \"platform-dev\"."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group the network lives in."
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
}

variable "subnets" {
  description = "Subnets keyed by name, each with an address prefix and the inbound traffic it allows."
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
    condition = alltrue(flatten([
      for s in values(var.subnets) : [
        for r in s.allowed_inbound : r.priority >= 100 && r.priority < 4096
      ]
    ]))
    error_message = "Rule priorities must be between 100 and 4095. Priority 4096 is reserved for deny-all-inbound."
  }
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
