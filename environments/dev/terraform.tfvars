project     = "platform"
environment = "dev"
location    = "southafricanorth"

address_space = ["10.10.0.0/16"]

subnets = {
  app = {
    address_prefix    = "10.10.1.0/24"
    service_endpoints = ["Microsoft.KeyVault"]
    allowed_inbound = [
      {
        name     = "allow-https-from-vnet"
        priority = 100
        protocol = "Tcp"
        port     = "443"
        source   = "VirtualNetwork"
      }
    ]
  }
  data = {
    address_prefix = "10.10.2.0/24"
  }
}

# Dev keeps logs briefly and caps ingestion to control cost.
log_retention_days = 30
log_daily_quota_gb = 1
