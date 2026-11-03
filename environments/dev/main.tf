locals {
  name_prefix = "${var.project}-${var.environment}"

  tags = merge(var.extra_tags, {
    project     = var.project
    environment = var.environment
    managed_by  = "terraform"
  })
}

resource "azurerm_resource_group" "platform" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.platform.name
  retention_in_days   = var.log_retention_days
  daily_quota_gb      = var.log_daily_quota_gb
  tags                = local.tags
}

module "network" {
  source = "../../modules/network"

  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.platform.name
  address_space       = var.address_space
  subnets             = var.subnets
  tags                = local.tags
}

module "key_vault" {
  source = "../../modules/key-vault"

  name_prefix                = var.environment
  location                   = var.location
  resource_group_name        = azurerm_resource_group.platform.name
  allowed_ip_ranges          = var.key_vault_allowed_ip_ranges
  allowed_subnet_ids         = [module.network.subnet_ids["app"]]
  log_analytics_workspace_id = module.monitoring.workspace_id
  tags                       = local.tags
}
