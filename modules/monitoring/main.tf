resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days

  # Caps ingestion so a noisy dev environment can't run up a surprise bill.
  daily_quota_gb = var.daily_quota_gb

  tags = var.tags
}
