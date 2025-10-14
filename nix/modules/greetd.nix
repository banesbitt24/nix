# greetd.nix
{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      # Autologin configuration - directly login without graphical greeter
      default_session = {
        command = "hyprland > /dev/null 2>&1";
        user = "brandon";
      };
    };
  };

  # Enable GNOME keyring unlock on login
  security.pam.services.greetd.enableGnomeKeyring = true;

  # For autologin: unlock the default keyring automatically
  # This assumes you've set an empty password on the default keyring
  environment.systemPackages = with pkgs; [
    gnome-keyring
  ];
}
