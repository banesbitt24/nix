{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    fish
    starship
    tailscale
    nextcloud-client
    papirus-folders
    papirus-icon-theme
    libreoffice-qt6-still
    kdePackages.print-manager
    kdePackages.isoimagewriter
    freetube
    fastfetch
    figlet
    spotify
    haruna
    icloudpd
    ktorrent
  ];
}
