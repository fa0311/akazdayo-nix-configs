# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular NixOS configuration using Flakes and Home Manager for user "akazdayo". The configuration is structured with a clear separation between system-level (`modules/`) and user-level (`home/`) settings.

## Common Commands

### Build and Apply Configuration
```bash
# Apply configuration and switch (most common)
sudo nixos-rebuild switch --flake .#nixos

# Test configuration without making it default boot option
sudo nixos-rebuild test --flake .#nixos

# Dry build to check for errors without applying
nixos-rebuild dry-build --flake .#nixos

# Check flake for issues
nix flake check
```

### Updating Dependencies
```bash
# Update all flake inputs
nix flake update

# Update specific input (e.g., nixpkgs or nixpkgs-unstable)
nix flake lock --update-input nixpkgs
nix flake lock --update-input nixpkgs-unstable
```

## Architecture

### Flake Structure
- Uses two nixpkgs inputs: `nixpkgs` (25.11 stable) and `nixpkgs-unstable`
- The flake passes `pkgs-unstable` as `specialArgs` to both NixOS modules and Home Manager
- Single host configuration named "nixos"
- `allowUnfree = true` is configured for unstable packages in the flake

### Module Organization
The configuration follows a modular pattern where:

1. **Entry Point**: `configuration.nix` imports `hosts/nixos/default.nix`
2. **Host Configuration**: `hosts/nixos/default.nix` imports all system modules from `modules/`
3. **System Modules** (`modules/`): Feature-based organization
   - `audio/` - PipeWire configuration
   - `boot/` - Bootloader settings
   - `desktop/` - Desktop environment configuration
   - `gaming/` - Steam, VR (WiVRn), and SlimeVR configurations
   - `hardware/` - NVIDIA drivers (open source), swap configuration
   - `locale/` - Locale, fonts, input methods
   - `networking/` - Network configuration
   - `users/` - User account definitions
   - `virtualization/` - Docker and container configurations

4. **Home Manager** (`home/`): User-specific settings for `akazdayo`
   - Configured via flake's `home-manager.nixosModules.home-manager`
   - Uses `useGlobalPkgs = true` and `useUserPackages = true`
   - `home/default.nix` imports programs from `home/programs/`
   - Programs: git, files, packages, hyprland
   - State version: 25.11

5. **Custom Packages** (`packages/default.nix`): Overlays for custom package builds
   - Contains commented WiVRn overlay (currently disabled)

### Multi-File Module Pattern
Some modules use a parent `default.nix` that imports sub-modules:
- `modules/gaming/default.nix` imports `steam.nix`, `wivrn.nix`, `slimevr.nix`
- `modules/virtualization/default.nix` imports `docker.nix`

## Adding New Modules

### System Module
1. Create `modules/new-feature/default.nix`
2. Add to imports in `hosts/nixos/default.nix`
3. Module receives `pkgs`, `pkgs-unstable`, and `self` as available arguments

### Home Manager Module
1. Create `home/programs/new-program.nix`
2. Add to imports in `home/default.nix`
3. Module receives `pkgs` and `pkgs-unstable` as available arguments

## Important Notes

- System state version: 25.05
- Home Manager state version: 25.11
- Experimental features enabled: `nix-command`, `flakes`
- `allowUnfree = true` is set in both `hosts/nixos/default.nix` and the flake (for unstable packages)
- User: `akazdayo`
- Architecture: `x86_64-linux`
- System packages: Firefox and nix-ld are enabled at the system level
