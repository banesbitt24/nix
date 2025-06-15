{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    fish
    starship
    tailscale
    papirus-folders
    papirus-icon-theme
    fastfetch
    figlet
  ];
}
