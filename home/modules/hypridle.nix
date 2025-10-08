# hypridle.nix - Clean Hypridle configuration for Home Manager
{ config, pkgs, ... }:

{
  # Install hypridle and related packages
  home.packages = with pkgs; [
    hypridle
    hyprlock
    brightnessctl
    playerctl
  ];

  # Main hypridle service configuration
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        # Dim screen after 2.5 minutes
        {
          timeout = 150;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10%";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }

        # Turn off keyboard backlight after 2.5 minutes
        {
          timeout = 150;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd rgb:kbd_backlight";
        }

        # Lock screen after 5 minutes
        {
          timeout = 300;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }

        # Turn off displays after 6 minutes
        {
          timeout = 360;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }

        # Hibernate system after 10 minutes on battery, suspend on AC
        {
          timeout = 600;
          on-timeout = "${pkgs.systemd}/bin/systemctl hibernate";
        }
      ];
    };
  };
  # Session variables
  home.sessionVariables = {
    HYPRIDLE_INSTANCE = "main";
  };
}

