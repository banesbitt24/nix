{ pkgs, ... }:

let
  background-package = pkgs.runCommand "background-image" {} ''
    cp ${../../wallpapers/mountain_jaws.jpg} $out
  '';
in
{
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    theme = "breeze";
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = false;
  
  # Enable Hyprland
  programs.hyprland.enable = true;
  services.displayManager.defaultSession = "hyprland";

  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background = ${background-package}
    '')
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    oxygen
    kate
    konsole
  ];
}
