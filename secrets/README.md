# Secrets

This directory contains secrets encrypted with [sops](https://github.com/getsops/sops) and managed by [sops-nix](https://github.com/Mic92/sops-nix).

## Setup

### 1. Generate YubiKey age key

```bash
age-plugin-yubikey --generate --slot 1 --touch-policy always --name "primary"
```

### 2. Get your YubiKey recipient (public key)

```bash
age-plugin-yubikey --list-all
```

Copy the `age1yubikey1...` string and replace `age1replace-with-your-yubikey-recipient` in `.sops.yaml`.

### 3. Get host SSH-derived age recipients

On each host, run:

```bash
ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub
```

Replace the placeholders in `.sops.yaml` with the actual values.

### 4. Save YubiKey identity

```bash
mkdir -p ~/.config/sops/age
age-plugin-yubikey --identity >> ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

The system-level sops config looks for identities at `/var/lib/sops/keys.txt`. Copy your YubiKey identity there so system services can decrypt secrets:

```bash
sudo mkdir -p /var/lib/sops
sudo install -m 600 -o root -g root ~/.config/sops/age/keys.txt /var/lib/sops/keys.txt
```

As a fallback, system secrets can also decrypt using the host's SSH key (configured via `sops.age.sshKeyPaths`).

### 5. Create encrypted secrets

```bash
sops secrets/nixos/home.yaml
```

Example content:

```yaml
immich-api-key: your-actual-api-key-here
```

Save and exit - sops will encrypt automatically.

## Directory Structure

- `nixos/home.yaml` - Desktop home-manager secrets
- `server/system.yaml` - Server system secrets
- `common/` - Shared secrets accessible to all hosts
- `darwin/` - macOS home-manager secrets

Encrypted secret files must be tracked by git so they are included in the nix store during pure evaluation.

## Replacing the Dummy Secret

`secrets/nixos/home.yaml` currently contains a dummy `immich-api-key` encrypted to a temporary age key. You cannot edit it directly because you do not have the decryption key.

After setting up your YubiKey and updating `.sops.yaml`, recreate the file with your real secret:

```bash
rm secrets/nixos/home.yaml
sops secrets/nixos/home.yaml
# Add: immich-api-key: your-real-api-key
# Save and exit - sops will encrypt with your recipients
```

### Security Note on Host SSH Recipients

The `.sops.yaml` includes host SSH-derived age recipients as a fallback. This enables unattended system boot without requiring a YubiKey touch, but anyone with access to the host's SSH private key (`/etc/ssh/ssh_host_ed25519_key`) can decrypt those secrets. For maximum security, remove host SSH recipients from `.sops.yaml` after confirming YubiKey-only decryption works reliably on your setup.

## Adding a New Secret

1. Define it in the appropriate module:
   - Home-manager secrets: `home/programs/secrets.nix`
   - System secrets: `modules/secrets/desktop.nix` or `server.nix`
2. Add the secret value to the corresponding `.yaml` file via `sops <path>`
3. Rebuild: `sudo nixos-rebuild switch --flake .#nixos`

## Rotating Keys

After adding a new recipient to `.sops.yaml`:

```bash
sops updatekeys secrets/nixos/home.yaml
sops updatekeys secrets/server/system.yaml
```
