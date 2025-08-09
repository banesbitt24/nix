# regreet.nix - Minimal default ReGreet
{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Minimal greetd + ReGreet setup
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  # Absolute minimal ReGreet config
  programs.regreet = {
    enable = true;
  };

  # Session packages
  services.displayManager.sessionPackages = [ pkgs.hyprland ];
}
