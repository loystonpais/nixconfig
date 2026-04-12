# Lunar Nix

<p align="center">
  <img src="assets/artwork/logo.svg" width="200" alt="Lunar Nix logo">
</p>

A personal NixOS configuration for a reliable, reproducible system across various devices. It uses the **dendritic pattern** (inspired by [vic/den](https://github.com/vic/den)) to manage multiple hosts with a declarative, aspect-oriented approach.

## 🌌 Overview

Lunar Nix is organized around **aspects**, which are independent feature modules that can be applied to both NixOS and Home Manager. This allows for a clean separation of concerns and easy sharing of configuration across different machines.

- **Reproducible**: Built on Nix flakes for consistent deployments.
- **Aspect-Oriented**: Features are encapsulated in "aspects" located in `modules/lunar/`.
- **Parametric Dispatch**: Configuration adapts automatically based on the context (host, user, etc.).

## 🖥️ Infrastructure

This configuration manages a mix of personal workstations and remote servers:

- **roglaptop** - Primary mobile workstation (ROG Laptop) with NVIDIA graphics, KDE Plasma 6, and development tools.
- **nixacle** - Cloud VPS (Oracle Always Free) running server-side services and workloads.
- **diviner** - Cloud VPS (Oracle Always Free) for additional services and testing.

## ✨ Key Features

### 🎨 Desktop & UI
- **KDE Plasma 6**: Modern desktop environment with customized themes (WhiteSur/Mac style).
- **Niri & Material Shell**: Alternative window management and UI experiences.
- **Fonts & Graphics**: Curated selection of fonts and optimized graphics drivers (NVIDIA/CUDA).

### 🎮 Gaming & Multimedia
- **Gaming Stack**: Steam, Heroic, PrismLauncher, MangoHUD, and GameMode.
- **Audio**: PipeWire with full compatibility for ALSA, PulseAudio, and JACK.
- **Streaming**: OBS Studio and multimedia production tools.

### 🛠️ Development & Tools
- **Languages & Frameworks**: Full support for various dev environments via `devenv`.
- **VSCode**: Pre-configured with 60+ extensions and AI enhancements.
- **Virtualization**: Libvirt/QEMU, KVMFR (Looking Glass), Podman, and Distrobox.
- **Shells**: `xonsh` (primary), `zsh`, and `bash` with Starship prompt.

### 🔐 Security & Operations
- **SOPS-nix**: Secrets managed with SOPS and age encryption.
- **Networking**: Tailscale for secure mesh networking and remote access.
- **CI/CD**: Cachix for binary caching to speed up builds.

## 📂 Repository Structure

```
/etc/nixos/
├── flake.nix           # Flake entry point
├── modules/
│   ├── defaults.nix    # Global default configurations
│   ├── hosts.nix       # Host definitions and metadata
│   ├── lunar/          # Feature aspects (Plasma, Gaming, Dev, etc.)
│   ├── hosts/          # Host-specific configurations
│   └── users/          # User-specific aspects
├── packages/           # Custom Nix packages
└── secrets/            # SOPS-encrypted secrets
```

## 🚀 Usage

To rebuild the system for the current host:

```bash
sudo nixos-rebuild switch --flake .#
```

To update dependencies:

```bash
nix flake update
```

## 📜 Credits

- **Dendritic Pattern**: Inspired by [vic/den](https://github.com/vic/den).
- **Artwork**: Custom logo and assets located in `assets/`.
