{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    tailscale
    oh-my-zsh
    nextcloud-client
    papirus-folders
    libreoffice-qt6-still
    kdePackages.print-manager
    freetube
    spotify
  ];
}
