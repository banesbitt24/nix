# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/bootloader.nix
    ./modules/fonts.nix
    ./modules/keymap.nix
    ./modules/locale.nix
    ./modules/network.nix
    ./modules/greetd.nix
    ./modules/print.nix
    ./modules/scan.nix
    ./modules/secrets.nix
    ./modules/services.nix
    ./modules/sound.nix
    ./modules/time.nix
    ./modules/users.nix
    ./modules/virt.nix
    ./modules/power.nix
    ./modules/nix-cleanup.nix
    ./modules/k3s.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  # Enable 32-bit support for gaming
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nix.extraOptions = ''
    warn-dirty = false
  '';

  # Environment variables for better Electron app rendering on Wayland
  environment.sessionVariables = {
    # Force Electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

    # Scaling environment variables for fractional scaling
    GDK_SCALE = "1.175";
    QT_SCALE_FACTOR = "1.175";
    XCURSOR_SIZE = "28"; # Scaled cursor size (24 * 1.175)
  };

  environment.systemPackages = with pkgs; [
    fprintd
    rar
    wget
    git
    curl
    tailscale
    figlet
    proton-pass
    protonmail-desktop
    obsidian
    gparted
    freetube
    spotify
    nextcloud-client
    kubectl
    kubernetes-helm
    libreoffice-qt6
    gimp3-with-plugins
    impression
    nixd
    nil
    nixfmt-rfc-style
    papirus-nord
    nordic
    claude-code
    rofi-power-menu
    rofi-screenshot
    waypaper
    hyprcursor
    adi1090x-plymouth-themes
    grim
    slurp
    wf-recorder
    wl-clipboard
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xarchiver
    gvfs
    yazi
    lazydocker
    lazygit
    cliphist
    mpv
    xfce.ristretto
    dropbox
    xfce.thunar-dropbox-plugin
    delta
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
      checkPhase = ""; # Disable shellcheck since the upstream script has warnings
    })
  ];

  programs.dconf.enable = true;
  programs.xfconf.enable = true;

  # Gaming support
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  system.stateVersion = "25.05"; # Did you read the comment?

}
