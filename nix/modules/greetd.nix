# greetd.nix
{ ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      # Autologin configuration - directly login without graphical greeter
      default_session = {
        command = "hyprland";
        user = "brandon";
      };
    };
  };

  # Enable GNOME keyring unlock on login
  security.pam.services.greetd.enableGnomeKeyring = true;
}
