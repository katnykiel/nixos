# NixOS Configuration Repository

This repository contains NixOS system configurations for managing multiple machines (laptop and desktop) with shared common settings and machine-specific customizations.

## Purpose

This repo provides a declarative, version-controlled approach to NixOS system configuration. It allows you to:
- Share common configuration across multiple machines (`common.nix`)
- Maintain machine-specific settings (`laptop.nix`, `desktop.nix`)
- Version control system state for reproducibility
- Easily synchronize configuration changes across multiple systems

## Repository Structure

```
.
├── common.nix           # Shared configuration for all machines
├── laptop.nix           # Laptop-specific configuration
├── desktop.nix          # Desktop-specific configuration
├── hardware/
│   ├── laptop.nix       # Laptop hardware configuration
│   ├── desktop.nix      # Desktop hardware configuration
└── README.md            # This file
```

## Getting Started

### Initial Setup

Your NixOS system should have a `/etc/nixos/configuration.nix` file. Replace its contents with a configuration that imports the appropriate machine profile:

**i.e. for laptop:**
```nix
{ config, pkgs, ... }:

{
  imports = [ ./laptop.nix ];
}
```

### Updating Configuration

To make changes to your system configuration:

1. **Clone the repository** (if not already present at `/etc/nixos/`):
   ```bash
   sudo git clone <repository-url> /etc/nixos
   ```

2. **Edit the appropriate configuration file**:
   ```bash
   cd /etc/nixos
   sudo vi common.nix      # For shared settings
   # or
   sudo vi laptop.nix      # For laptop-specific settings
   # or
   sudo vi desktop.nix     # For desktop-specific settings
   ```

3. **Rebuild and switch to the new configuration**:
   ```bash
   sudo nixos-rebuild switch
   ```

4. **Commit and push changes**:
   ```bash
   cd /etc/nixos
   git add .
   git commit -m "Update: describe your changes"
   git push
   ```

5. **Update on other machines**:
   ```bash
   cd /etc/nixos
   git pull
   sudo nixos-rebuild switch
   ```
