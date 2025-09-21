# hyprlock.nix - Hyprlock configuration for Home Manager
{ config, pkgs, ... }:

let
  # Toggle this to enable/disable fingerprint authentication
  # To enable fingerprint authentication:
  # 1. Set enableFingerprint = true
  # 2. Uncomment PAM lines in nix/modules/services.nix
  # 3. Rebuild and enroll fingerprint with: fprintd-enroll
  enableFingerprint = false;
in
{
  # Create hyprlock config file
  home.file.".config/hypr/hyprlock.conf".text = ''
    general {
        disable_loading_bar = true
        grace = 300
        hide_cursor = true
        no_fade_in = false
    }

    background {
        monitor =
        path = /home/brandon/.nix/wallpapers/mountain_jaws.jpg
        blur_passes = 1
        blur_size = 5
    }

    input-field {
        monitor =
        size = 200, 50
        position = 0, -80
        dots_center = true
        fade_on_empty = false
        font_color = rgb(202, 211, 245)
        inner_color = rgb(91, 96, 120)
        outer_color = rgba(5e81acee)
        outline_thickness = 3
        rounding = 0
        placeholder_text = Password...
        shadow_passes = 0
    }

    label {
        monitor =
        text = cmd[update:1000] echo "$(date +"%H:%M")"
        color = rgb(202, 211, 245)
        font_size = 64
        font_family = JetBrainsMono Nerd Font Mono
        position = 0, 120
        halign = center
        valign = center
    }

    label {
        monitor =
        text = cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"
        color = rgb(202, 211, 245)
        font_size = 24
        font_family = JetBrainsMono Nerd Font Mono
        position = 0, 60
        halign = center
        valign = center
    }

    ${if enableFingerprint then ''
    # Fingerprint authentication
    fingerprint {
        monitor =
        ready_message = Place your finger on the scanner to unlock
        present_message = Scanning fingerprint...
        position = 0, -150
        halign = center
        valign = center
    }
    '' else ""}
  '';
}
