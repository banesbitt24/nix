{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;

    extraConfig = ''
      # Portal environment
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland

      # Monitor Config
      monitor = eDP-1,2256sx1504,auto,1.175

      # Autostart applications
      exec-once = hyprpanel
      exec-once = walker --gapplication-service
      exec-once = waybar
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = ${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1

      # Keybindings

      # SUPER Key
      $mainMod = ALT

      # Actions
      bind = $mainMod, Q, killactive
      bind = $mainMod, RETURN, exec, kitty
      bind = $mainMod, R, exec, ${pkgs.walker}/bin/walker
      bind = $mainMod, M, exit # Exit Hyprland

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l # Move focus left
      bind = $mainMod, right, movefocus, r # Move focus right
      bind = $mainMod, up, movefocus, u # Move focus up
      bind = $mainMod, down, movefocus, d # Move focus down

      general {
        gaps_in = 5
        gaps_out = 5
        border_size = 3
        col.active_border = rgba(5e81acee)
        col.inactive_border = rgba(4c566aaa)
        layout = dwindle
        resize_on_border = true
      }

      gestures {
        workspace_swipe = true
      }

      input {
        touchpad {
          natural_scroll = false
        }
      }

      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
      }

      decoration {
        rounding = 0
        blur {
          enabled = true
          size = 2
          passes = 1
        }
        shadow {
          enabled = false
          range = 4
          render_power = 3
          color = rgba(1a1a1aee)
        }
      }

      animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
      }
    '';
  };

}

