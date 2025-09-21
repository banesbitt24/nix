{ pkgs, ... }:

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
      env = HYPRCURSOR_THEME,Bibata-Modern-Ice
      env = HYPRCURSOR_SIZE,24

      # Monitor Config
      monitor = eDP-1,2256sx1504,auto,1.175

      # Autostart applications
      exec-once = hyprpaper
      exec-once = hyprpanel
      exec-once = walker --gapplication-service
      exec-once = waybar
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      exec-once = hyprctl hyprpaper wallpaper ",~/.nix/wallpapers/mountain_jaws.jpg"

      # Keybindings

      # SUPER Key
      $mainMod = ALT

      # Actions
      bind = $mainMod, Q, killactive
      bind = $mainMod, RETURN, exec, ghostty
      bind = $mainMod, R, exec, ${pkgs.rofi}/bin/rofi -show drun
      bind = $mainMod shift, P, exec, ${pkgs.rofi}/bin/rofi -show power-menu -modi power-menu:rofi-power-menu
      bind = $mainMod, V, exec, ~/.local/bin/rofi-clipboard # Open clipboard manager
      bind = $mainMod, E, exec, thunar # Open file manager
      bind = $mainMod, M, exit # Exit Hyprland

      # Screenshots and Recording
      bind = , Print, exec, grim -g "$(slurp)" - | wl-copy # Screenshot area to clipboard
      bind = SHIFT, Print, exec, grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png # Full screenshot to file
      bind = CTRL, Print, exec, grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png # Area screenshot to file
      bind = ALT, Print, exec, ${pkgs.rofi}/bin/rofi -show screenshot -modi screenshot:rofi-screenshot # Rofi screenshot menu
      bind = $mainMod, Print, exec, pkill wf-recorder || wf-recorder -g "$(slurp)" -f ~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4 # Toggle area recording

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l # Move focus left
      bind = $mainMod, right, movefocus, r # Move focus right
      bind = $mainMod, up, movefocus, u # Move focus up
      bind = $mainMod, down, movefocus, d # Move focus down

      # Switch to workspace
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to workspace
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

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
