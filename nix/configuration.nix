# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/bootloader.nix
    ./modules/fonts.nix
    ./modules/keymap.nix
    ./modules/locale.nix
    ./modules/network.nix
    ./modules/plasma.nix
    ./modules/print.nix
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
    fprintd
    wget
    git
    curl
    tailscale
    figlet # ASCII art tool
    haruna
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
    nixd
    nil
    nixfmt-rfc-style
    papirus-nord
    kdePackages.kdenlive
    kdePackages.ktorrent
    kdePackages.kcalc
    claude-code
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

}
