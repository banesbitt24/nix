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
    ./modules/greetd.nix
    #./modules/print.nix
    ./modules/scan.nix
    ./modules/services.nix
    ./modules/sound.nix
    ./modules/time.nix
    ./modules/users.nix
    ./modules/virt.nix
    ./modules/power.nix
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
    nordic
    claude-code
    rofi-bluetooth
    rofi-power-menu
    rofi-screenshot
    waypaper
    hyprcursor
    adi1090x-plymouth-themes
    grim # Screenshot tool
    slurp # Area selection for screenshots
    wf-recorder # Screen recording
    wl-clipboard # Clipboard integration
    xfce.thunar
    xfce.thunar-volman # Lightweight GUI file manager
    xfce.thunar-archive-plugin
    xarchiver
    gvfs # Virtual filesystem support for trash, mounts, etc
    yazi # Modern TUI file manager
    lazydocker # Docker TUI management
    lazygit # Git TUI interface
    cliphist # Clipboard manager for Wayland
    mpv
  ];

  programs.dconf.enable = true;
  programs.xfconf.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
