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
        # Robust wake sequence: turn on display, reload hyprland, restore brightness
        after_sleep_cmd = "${pkgs.bash}/bin/bash -c '${pkgs.hyprland}/bin/hyprctl dispatch dpms on; sleep 0.5; ${pkgs.hyprland}/bin/hyprctl reload; ${pkgs.brightnessctl}/bin/brightnessctl -r'";
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
          on-timeout = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        }

        # Turn off displays after 6 minutes
        {
          timeout = 360;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          # Ensure display wakes reliably
          on-resume = "${pkgs.bash}/bin/bash -c '${pkgs.hyprland}/bin/hyprctl dispatch dpms on; ${pkgs.brightnessctl}/bin/brightnessctl -r'";
        }

        # Hibernate after 15 minutes on battery
        {
          timeout = 900;
          on-timeout = "[ $(cat /sys/class/power_supply/ADP*/online) -eq 0 ] && ${pkgs.systemd}/bin/systemctl hibernate";
        }

        # Suspend after 30 minutes on external power
        {
          timeout = 1800;
          on-timeout = "[ $(cat /sys/class/power_supply/ADP*/online) -eq 1 ] && ${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
  # Session variables
  home.sessionVariables = {
    HYPRIDLE_INSTANCE = "main";
  };
}

