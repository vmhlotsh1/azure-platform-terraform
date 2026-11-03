output "resource_group_name" {
  description = "Resource group holding the platform."
  value       = azurerm_resource_group.platform.name
}

output "subnet_ids" {
  description = "Subnet IDs keyed by name."
  value       = module.network.subnet_ids
}

output "key_vault_uri" {
  description = "URI applications use to read secrets."
  value       = module.key_vault.uri
}

output "log_analytics_workspace_id" {
  description = "Workspace that collects platform logs."
  value       = module.monitoring.workspace_id
}
