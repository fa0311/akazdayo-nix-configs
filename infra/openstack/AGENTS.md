# infra/openstack

**Generated:** 2026-05-22 | **Commit:** 951517d
Parent: [root AGENTS.md](../../AGENTS.md)

## OVERVIEW
OpenTofu/Terraform IaC for provisioning NixOS VMs on OpenStack. Bootstraps via cloud-init (amazon-init) running `nixos-rebuild boot` from the flake.

## STRUCTURE
```
infra/openstack/
├── main.tf                  # Compute instance, networking, floating IP, security group
├── variables.tf             # Input variables (instance name, flavor, image, network, keypair)
├── outputs.tf               # instance_id, fixed_ip, floating_ip, ssh_host
├── providers.tf             # OpenStack provider (auth from env, NOT tracked)
├── versions.tf              # OpenTofu >= 1.6.0, openstack provider ~> 3.4
├── cloud-init.yaml.tftpl    # Bootstrap template: amazon-init runs nixos-rebuild boot
├── terraform.tfvars.example # Example variable values
├── .terraform.lock.hcl      # Lock file — TRACKED in git
├── README.md                # Full provisioning guide
└── AGENTS.md                # This file
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Change instance config | `main.tf` | Compute, network, security group, floating IP |
| Add/change input vars | `variables.tf` | New vars need `terraform.tfvars.example` entry |
| Change bootstrap script | `cloud-init.yaml.tftpl` | Shell script injected via config-drive |
| Debug bootstrap | `README.md` | amazon-init status, manual bootstrap steps |
| Validate offline | `README.md` | `tofu validate` without credentials |

## CONVENTIONS
- **Auth from env, never tracked**: `openrc.sh` sources `OS_*` env vars. No credentials in tracked files. Provider config uses env vars + `OS_CLOUD` fallback.
- **State gitignored, lockfile tracked**: `*.tfstate` and `*.tfvars` are in `.gitignore`. `.terraform.lock.hcl` IS tracked.
- **Keypair preference**: Always use an existing `keypair_name` — avoids generating private keys in Terraform state.
- **CIDR rules**: Never `0.0.0.0/0`. Always explicit CIDR blocks for SSH access.
- **`config_ref` pinning**: Use branch during dev, pin to tag/commit for production. Must match a ref where `nixosConfigurations.openstack` exists in the flake.

## COMMANDS
```bash
# Authentication
source ../../openrc.sh                     # or set OS_* env vars

# From repo root
nix develop                                # provides opentofu
tofu -chdir=infra/openstack init
tofu -chdir=infra/openstack plan -var-file=terraform.tfvars
tofu -chdir=infra/openstack apply -var-file=terraform.tfvars
tofu -chdir=infra/openstack output ssh_host

# Offline validation (no credentials)
nix develop -c tofu -chdir=infra/openstack fmt -check
nix develop -c tofu -chdir=infra/openstack init -backend=false
nix develop -c tofu -chdir=infra/openstack validate -var-file=terraform.tfvars.example
```

## ANTI-PATTERNS
- Committing `terraform.tfvars` (contains real values, must remain gitignored).
- Committing auth credentials (API keys, tokens, `clouds.yaml` secrets).
- Using `0.0.0.0/0` for `ssh_allowed_cidrs` — always restrict to your IP range.
- Running `tofu apply` before `tofu plan` — review changes first.
- Changing `image_id`, `config_drive`, or `key_pair` on a live instance — destroys and recreates the VM.

## NOTES
- Bootstrap uses **amazon-init** (NixOS built-in), not cloud-init. Script logs to `/var/log/nixos-bootstrap.log`.
- First-boot SSH goes to `root` (OpenStack keypair injection), not the configured user. After bootstrap reboot, user config takes over.
- The `openstack` host is NOT in `deploy.nodes` — provisioning + bootstrap replaces deploy-rs for this host.
- The VM is considered **ephemeral** — most resource changes destroy and recreate the instance.
- `terraform.tfvars.example` serves as both documentation and offline validation input.
