# Design decisions

Short records of why the starter is built the way it is.

## 1. One root configuration and state file per environment

**Decision:** `environments/dev` and `environments/prod` are separate root configurations that call the same modules, each with its own backend key.

**Why:** A bad apply in dev cannot corrupt prod state, and each environment can be planned, applied and permissioned on its own. Workspaces were considered, but they share one backend configuration and make it too easy to run a command against the wrong environment.

**Trade-off:** The root files are duplicated between environments. Differences live only in `terraform.tfvars`, which keeps the duplication easy to review.

## 2. Key Vault uses Azure RBAC, not access policies

**Decision:** `enable_rbac_authorization = true`, with access granted through role assignments.

**Why:** RBAC is managed the same way as every other Azure permission, can be scoped and audited centrally, and avoids the per-vault access policy lists that drift over time.

## 3. Deny by default on the network and on Key Vault

**Decision:** Every NSG ends with a deny-all inbound rule at priority 4096, and the Key Vault firewall defaults to `Deny`, with only the app subnet (via service endpoint) and named IP ranges allowed.

**Why:** Access should be something you add on purpose, not something you forget to remove. The network module validates that custom rules stay below priority 4096 so they can't shadow the deny rule.

## 4. Purge protection on, purge on destroy off

**Decision:** `purge_protection_enabled = true` in the module, and `purge_soft_delete_on_destroy = false` in the provider.

**Why:** Secrets are the hardest thing to recover after a mistake. A deleted vault stays recoverable for the retention period, even if someone runs `terraform destroy`.

## 5. Security scan reports, but does not block yet

**Decision:** Checkov runs on every change with `soft_fail: true`.

**Why:** Some findings are known and accepted for a starter. The main one is that Key Vault does not yet have a private endpoint (a service endpoint and firewall are used instead). Each accepted finding is listed in the roadmap, and the scan will be switched to blocking once they are addressed.

## 6. Log ingestion cap in dev

**Decision:** `daily_quota_gb = 1` in dev and no cap in prod.

**Why:** A chatty dev workload should not create a surprise bill, but production must never drop logs during an incident.
