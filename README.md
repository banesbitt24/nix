# NixOS Configuration

Personal NixOS configuration for a Framework AMD AI-300 series laptop running Hyprland (Wayland compositor). Built with Nix Flakes and Home Manager for declarative system and user-level configuration management.

## 🖥️ System Information

- **Host**: `quicksilver`
- **Hardware**: Framework AMD AI-300 series laptop
- **Display**: 2256x1504 @ 1.175 scaling (eDP-1)
- **Window Manager**: Hyprland (Wayland)
- **Theme**: Nord color scheme
- **Shell**: Fish with Starship prompt
- **State Version**: 25.05

## 📁 Structure

```
.
├── flake.nix                 # Main flake configuration
├── nix/                      # System-level NixOS configuration
│   ├── configuration.nix     # Main system config
│   ├── hardware-configuration.nix
│   ├── modules/              # Modular system configurations
│   │   ├── bootloader.nix
│   │   ├── fonts.nix
│   │   ├── greetd.nix
│   │   ├── keymap.nix
│   │   ├── locale.nix
│   │   ├── network.nix
│   │   ├── nix-cleanup.nix
│   │   ├── power.nix
│   │   ├── print.nix
│   │   ├── scan.nix
│   │   ├── secrets.nix        # Sops-nix secrets configuration
│   │   ├── services.nix
│   │   ├── sound.nix
│   │   ├── time.nix
│   │   ├── users.nix
│   │   └── virt.nix
│   └── packages/             # Custom package definitions
│       └── newshosting-appimage.nix
├── home/                     # User-level Home Manager configuration
│   ├── home.nix              # Main home config
│   └── modules/              # User application configurations
│       ├── bibata-cursor.nix
│       ├── brave.nix
│       ├── btop.nix
│       ├── fish.nix
│       ├── git.nix
│       ├── gtk.nix
│       ├── helix.nix
│       ├── hypridle.nix
│       ├── hyprland.nix
│       ├── hyprlock.nix
│       ├── hyprpaper.nix
│       ├── hyprsunset.nix
│       ├── k9s.nix
│       ├── kitty.nix
│       ├── lazydocker.nix
│       ├── lazygit.nix
│       ├── mako.nix
│       ├── rofi.nix
│       ├── ssh.nix
│       ├── starship.nix
│       ├── waybar.nix
│       └── zellij.nix
├── scripts/
│   └── weather.py            # Weather script for waybar
├── secrets/
│   └── secrets.yaml          # Encrypted secrets (sops-nix)
└── .sops.yaml                # Sops configuration with age public keys
```

## 🚀 Quick Start

### System Rebuild
```bash
# Rebuild and switch system configuration
sudo nixos-rebuild switch --flake ~/.nix#quicksilver
# Or use the fish alias:
rebuild
```

### Update Flake Inputs
```bash
# Update all flake inputs
nix flake update ~/.nix
# Or use the fish alias:
update-flake
```

### Garbage Collection
```bash
# Clean up old generations
sudo nix-collect-garbage -d && nix-collect-garbage -d
# Or use the fish alias:
nix-gc
```

### Edit Configuration
```bash
# Opens ~/.nix in your editor
nixconf
```

## 🔧 Development Tools

### Available Commands
- `lg` - LazyGit (Git TUI)
- `ld` - LazyDocker (Docker TUI)
- `k` - kubectl alias
- `yazi` - Modern TUI file manager
- `ns` - Interactive nix package search (fzf + nix-search-tv)

### Flake Operations
```bash
# Check flake configuration
nix flake check ~/.nix

# Show flake outputs
nix flake show ~/.nix

# Test configuration without switching
sudo nixos-rebuild test --flake ~/.nix#quicksilver

# Build configuration without activating
sudo nixos-rebuild build --flake ~/.nix#quicksilver
```

## 🎨 Desktop Environment

### Hyprland Setup
- **Modifier Key**: ALT (not Super/Meta)
- **Status Bar**: Waybar with custom Nord theme, weather integration, and MPRIS media control
- **Launcher**: Rofi with Nord theme
- **Notifications**: Mako
- **Lock Screen**: Hyprlock
- **Idle Management**: Hypridle
- **Wallpaper**: Hyprpaper
- **Night Light**: Hyprsunset
- **Cursor**: Bibata Modern Ice

### Custom Scripts
Located in `~/.local/bin/`:
- `rofi-clipboard` - Clipboard history manager (cliphist)
- `rofi-screenshot` - Screenshot and recording menu
- `rofi-power-hypr` - Power management menu
- `weather.py` - Weather data for waybar (OpenWeatherAPI)

### Key Applications
- **Terminal**: Kitty
- **Editor**: Helix
- **Browser**: Brave
- **File Managers**: Thunar (GUI), Yazi (TUI)
- **Media**: MPV, Spotify (with MPRIS control in waybar)
- **Productivity**: Obsidian, LibreOffice, Proton Pass
- **Usenet**: Newshosting (custom AppImage package)
- **Development**: kubectl, helm, k9s, lazygit, lazydocker, nixd
- **Security**: SSH agent with automatic key loading, sops-nix for secrets

## 🎮 Gaming

Steam is configured with:
- Remote Play support
- Dedicated Server support
- Local Network Game Transfers
- 32-bit graphics support enabled

## 🔌 Hardware Features

- Framework AMD AI-300 series optimizations via nixos-hardware
- Fingerprint support (fprintd)
- Power management tuning
- Tailscale for networking
- Virtualization support (virt-manager)

## 🔐 Secrets Management

This configuration uses **sops-nix** for secure secrets management with age encryption:

- **Encrypted storage**: Secrets are stored encrypted in `secrets/secrets.yaml`
- **Age encryption**: Uses age public/private key pairs for encryption/decryption
- **SSH keys**: SSH private and public keys are managed through sops-nix
- **API keys**: Weather API and other sensitive keys stored securely
- **Safe to commit**: All encrypted files and `.sops.yaml` config are safe to version control

### Managed Secrets
- OpenWeather API key (for waybar weather module)
- SSH private/public key pair (deployed to `~/.ssh/`)

### SSH Configuration
- **SSH Agent**: Automatically starts with user session
- **Key Management**: SSH keys deployed via sops-nix to `~/.ssh/`
- **Auto-loading**: Keys automatically added to agent (`AddKeysToAgent yes`)
- **Secure Storage**: Private keys stored encrypted, never committed to git

## 🌐 Flake Inputs

- **nixpkgs**: nixos-unstable channel
- **home-manager**: User environment management
- **nixos-hardware**: Hardware-specific configurations
- **distro-grub-themes**: Custom GRUB themes
- **sops-nix**: Secrets management with age encryption

## 📦 Custom Packages

This configuration includes custom packages defined in `nix/packages/`:

### Newshosting
Newshosting Usenet client packaged as an AppImage wrapper.

**Update process when new version is released:**

1. Run the installer to download the new version:
   ```bash
   newshosting_installer
   ```

2. Copy the new AppImage to the package directory:
   ```bash
   cp ~/.local/share/Newshosting/<new-version>/Newshosting-x86_64.AppImage ~/.nix/nix/packages/
   ```

3. Update the version number in `nix/packages/newshosting-appimage.nix`:
   ```nix
   version = "X.Y.Z";  # New version number
   ```

4. Stage changes and rebuild:
   ```bash
   cd ~/.nix
   git add nix/packages/Newshosting-x86_64.AppImage nix/packages/newshosting-appimage.nix
   rebuild
   ```

## 📝 Notes

- Home Manager backups use `.hmb` extension
- Main user: `brandon` (wheel, docker, and essential groups)
- Experimental features enabled: `nix-command`, `flakes`
- Electron apps configured for native Wayland support
- Fractional scaling set to 1.175 for optimal display
- Secrets managed with sops-nix using age encryption
- SSH keys and API keys never stored in plaintext in git
- MPRIS integration for media control in waybar bottom bar
- OpenSSL 1.1 is permitted as insecure (required for some packages)

## 🤝 Contributing

This is a personal configuration, but feel free to use it as reference or inspiration for your own NixOS setup.

## 📄 License

Personal configuration - use at your own discretion.
