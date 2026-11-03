# azure-platform-terraform
Modular Terraform for an Azure platform foundation (network, Key Vault, logging) with separate dev/prod state and fmt, validate, lint and security checks in GitHub Actions.

![terraform-ci](https://github.com/vmhlotsh1/azure-platform-terraform/actions/workflows/terraform-ci.yml/badge.svg)

A small, opinionated Terraform starter for an Azure platform foundation: a network with locked-down subnets, a Key Vault that uses RBAC and a firewall, and central logging. It is split into reusable modules with one root configuration per environment, and every change is checked in CI.

It is the kind of foundation I built and automated professionally with Terraform and Azure DevOps. This version is written from scratch for GitHub Actions so anyone can read and reuse it.

## What it builds

| Module | Creates | Secure defaults |
| --- | --- | --- |
| `modules/network` | VNet, subnets, one NSG per subnet | Every NSG ends in an explicit deny-all inbound rule; traffic is allowed only where a rule says so. Optional service endpoints per subnet. |
| `modules/key-vault` | Key Vault, role assignment, audit-log diagnostics | Azure RBAC instead of access policies, purge protection on, public network access off by default, firewall default-deny with only the app subnet allowed. |
| `modules/monitoring` | Log Analytics workspace | Configurable retention and a daily ingestion cap so dev cannot run up a surprise bill. |

```
environments/
  dev/    # small address space, 30-day logs, 1 GB/day cap
  prod/   # separate address space, 90-day logs, no cap
modules/
  network/
  key-vault/
  monitoring/
```

Each environment is its own root configuration with its own state file, so a mistake in dev can never touch prod state.

## Usage

Prerequisites: Terraform 1.6+, Azure CLI, and a storage account for remote state.

```bash
az login
export TF_VAR_subscription_id="<your-subscription-id>"

cd environments/dev
cp backend.hcl.example backend.hcl   # point it at your state storage account
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

State is stored in Azure Storage using Azure AD authentication rather than account keys.

## CI

`.github/workflows/terraform-ci.yml` runs on every pull request and on pushes to `main`:

1. **Format**: `terraform fmt -check -recursive`
2. **Validate**: `terraform init -backend=false` and `terraform validate` for dev and prod
3. **Lint**: TFLint with the recommended Terraform ruleset
4. **Security scan**: Checkov, with findings reported on every run

No cloud credentials are needed for these checks. Adding a `plan` job with GitHub OIDC federation to Azure is the next step on the roadmap.

## Design decisions

The reasoning behind the main choices, and the trade-offs I accepted, are in [docs/decisions.md](docs/decisions.md).

## Roadmap

- `plan` on pull requests using OIDC workload identity federation (no stored secrets)
- Private endpoint and private DNS zone for Key Vault in prod
- NSG flow logs into the Log Analytics workspace

## License

MIT
