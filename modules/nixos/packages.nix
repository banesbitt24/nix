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
    libreoffice-qt6-still
    kdePackages.print-manager
    freetube
    spotify
  ];
}
