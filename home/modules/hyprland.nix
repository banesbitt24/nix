{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;

    extraConfig = ''
      debug {
        disable_logs = false
      }
         
      # Portal environment
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = HYPRCURSOR_THEME,Bibata-Modern-Ice
      env = HYPRCURSOR_SIZE,24

      # Additional environment variables for Electron apps
      env = ELECTRON_OZONE_PLATFORM_HINT,wayland
      env = GDK_SCALE,1.175
      env = QT_SCALE_FACTOR,1.175

      # XWayland scaling configuration
      xwayland {
        force_zero_scaling = true
      }

      # Monitor Config
      monitor = eDP-1,2256sx1504,auto,1.175

      # Autostart applications
      exec-once = hyprpaper
      exec-once = hyprpanel
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      exec-once = ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets
      exec-once = hyprctl dispatch workspace 1
      exec-once = nextcloud --background
      exec-once = waybar
      exec-once = [workspace special:proton-pass silent] proton-pass

      # Keybindings

      # SUPER Key
      $mainMod = ALT

      # Actions
      bind = $mainMod, Q, killactive
      bind = $mainMod, RETURN, exec, kitty
      bind = $mainMod, R, exec, rofi -show drun
      bind = $mainMod shift, P, exec, ~/.local/bin/rofi-power-hypr
      bind = $mainMod, L, exec, pidof hyprlock || hyprlock # Lock screen
      bind = $mainMod, V, exec, ~/.local/bin/rofi-clipboard # Open clipboard manager
      bind = $mainMod, E, exec, thunar # Open file manager
      bind = $mainMod, P, togglespecialworkspace, proton-pass # Toggle proton-pass
      bind = $mainMod, M, exit # Exit Hyprland

      # Screenshots and Recording
      bind = , Print, exec, /home/brandon/.local/bin/rofi-screenshot # Rofi screenshot menu
      bind = SHIFT, Print, exec, grim ~/Nextcloud/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png && notify-send "Screenshot" "Full screen saved to ~/Nextcloud/Pictures/Screenshots/" # Full screenshot to file
      bind = CTRL, Print, exec, grim -g "$(slurp)" ~/Nextcloud/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png && notify-send "Screenshot" "Area saved to ~/Nextcloud/Pictures/Screenshots/" # Area screenshot to file
      bind = $mainMod, Print, exec, grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Area copied to clipboard" # Screenshot area to clipboard
      bind = $mainMod SHIFT, Print, exec, pkill wf-recorder && notify-send "Recording" "Recording stopped" || (wf-recorder -g "$(slurp)" -f ~/Nextcloud/Videos/Screenshots/recording-$(date +%Y%m%d-%H%M%S).mp4 & notify-send "Recording" "Recording started") # Toggle area recording

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

      # Move active window to workspace
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7

      # Brightness control
      bind = , XF86MonBrightnessUp, exec, brightnessctl set +10%
      bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-

      # Volume control
      bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      # Media playback control
      bind = , XF86AudioPlay, exec, playerctl play-pause
      bind = , XF86AudioPause, exec, playerctl play-pause
      bind = , XF86AudioNext, exec, playerctl next
      bind = , XF86AudioPrev, exec, playerctl previous

      # Waybar refresh
      bind = $mainMod SHIFT, W, exec, pkill waybar && waybar &

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
        gesture = 3, horizontal, workspace
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
        rounding = 4
        blur {
          enabled = true
          size = 2
          passes = 1
          ignore_opacity = true
          new_optimizations = true
        }
        shadow {
          enabled = false
          range = 4
          render_power = 3
          color = rgba(1a1a1aee)
        }
      }

      # Fix context menus and popups
      windowrulev2 = noblur, class:^()$, title:^()$
      windowrulev2 = noshadow, class:^()$, title:^()$

      # Move proton-pass to special workspace (scratchpad)
      windowrulev2 = workspace special:proton-pass, class:^(Proton Pass)$
      windowrulev2 = float, class:^(Proton Pass)$
      windowrulev2 = size 50% 50%, class:^(Proton Pass)$
      windowrulev2 = center, class:^(Proton Pass)$

      # Make pavucontrol and blueman-manager floating
      windowrulev2 = float, class:^(org.pulseaudio.pavucontrol)$
      windowrulev2 = float, class:^(.blueman-manager-wrapped)$
      windowrulev2 = float, class:^(nmtui)$
      windowrulev2 = size 50% 50%, class:^(nmtui)$
      windowrulev2 = center, class:^(nmtui)$

      animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 3, myBezier
        animation = windowsOut, 1, 3, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 3, default
        animation = fade, 1, 3, default
        animation = workspaces, 1, 3, default
      }
    '';
  };

}
