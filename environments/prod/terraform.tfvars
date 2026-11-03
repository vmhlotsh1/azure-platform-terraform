project     = "platform"
environment = "prod"
location    = "southafricanorth"

address_space = ["10.20.0.0/16"]

subnets = {
  app = {
    address_prefix    = "10.20.1.0/24"
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
    address_prefix = "10.20.2.0/24"
  }
}

# Prod keeps logs longer and has no ingestion cap, so nothing is dropped during an incident.
log_retention_days = 90
log_daily_quota_gb = -1
