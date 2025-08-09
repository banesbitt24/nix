# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/bootloader.nix
    ./modules/fonts.nix
    ./modules/keymap.nix
    ./modules/locale.nix
    ./modules/network.nix
    ./modules/print.nix
    ./modules/regreet.nix
    ./modules/services.nix
    ./modules/sound.nix
    ./modules/time.nix
    ./modules/users.nix
    ./modules/virt.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  nix.extraOptions = ''
    warn-dirty = false
  '';

  environment.systemPackages = with pkgs; [
    vim
    acpi
    upower
    wget
    git
    curl
    tailscale
    power-profiles-daemon
    walker
    iwmenu
    bzmenu
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    kdePackages.polkit-kde-agent-1
    figlet # ASCII art tool
    proton-pass
    protonmail-desktop
    obsidian # Note-taking app
    freetube # Video streaming app
    spotify # Music streaming app
    nextcloud-client
    kubectl
    kubernetes-helm
    libreoffice-qt6
    gimp3-with-plugins
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = [
      "hyprland"
      "gtk"
    ];
  };

  programs.hyprland.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
