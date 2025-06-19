{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    fish
    starship
    papirus-folders
    papirus-nord
    papirus-icon-theme
    tailscale
    figlet
    helix
    zed-editor
    nixd
    nil
    nixfmt-rfc-style
    kdePackages.krohnkite
  ];
}
