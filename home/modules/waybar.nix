# waybar.nix - Waybar configuration for Home Manager (Omarchy-inspired)
{ pkgs, ... }:

{
  # Install Waybar and dependencies
  home.packages = with pkgs; [
    waybar
    pavucontrol # For pulseaudio module clicks
    blueman # For bluetooth module clicks
  ];

  # Configure Waybar with Omarchy's clean setup
  programs.waybar = {
    enable = true;

    # Omarchy's configuration
    settings = [
      # Top bar
      {
        reload_style_on_change = true;
        layer = "top";
        position = "top";
        spacing = 0;
        height = 24;
        margin-top = 5;
        margin-left = 5;
        margin-right = 5;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "clock"
          "custom/weather"
        ];

        modules-right = [
          "group/tray-expander"
          "cpu"
          "idle_inhibitor"
          "bluetooth"
          "pulseaudio"
          "network"
          "battery"
        ];

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          all-outputs = true;
          sort-by-number = true;
          format-icons = {
            "1" = "WWW";
            "2" = "DEV";
            "3" = "MAIL";
            "4" = "MEDIA";
            "5" = "NOTES";
            "6" = "VIRT";
            "7" = "GAMES";
            "default" = "{name}";
          };
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
            "6" = [ ];
            "7" = [ ];
          };
        };

        cpu = {
          interval = 5;
          format = "󰍛";
          on-click = "kitty -e btop";
        };

        clock = {
          format = "  {:L%A %H:%M}";
          format-alt = "  {:L%d %B %Y}";
          tooltip = false;
        };

        network = {
          format-icons = [
            "󰤯"
            "󰤢"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰤮";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          spacing = 1;
          on-click = "kitty --class nmtui -e ${pkgs.networkmanager}/bin/nmtui";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };

        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "blueman-manager";
        };

        pulseaudio = {
          format = "{icon}";
          format-muted = "󰝟";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          tooltip-format = "Volume: {volume}%";
          scroll-step = 5;
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          states = {
            muted = 0;
          };
        };

        battery = {
          format = "{icon}";
          format-discharging = "{icon}";
          format-charging = "{icon}";
          format-plugged = "{icon}";
          format-icons = {
            charging = [
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
            default = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          format-full = "󰂅";
          tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
          tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
          interval = 5;
          states = {
            warning = 20;
            critical = 10;
          };
        };

        "group/tray-expander" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 600;
            children-class = "tray-group-item";
          };
          modules = [
            "custom/expand-icon"
            "tray"
          ];
        };

        "custom/expand-icon" = {
          format = "󰞗";
          tooltip = false;
        };

        tray = {
          icon-size = 16;
          spacing = 14;
        };

        "power-profiles-daemon" = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        "custom/weather" = {
          format = "{}";
          tooltip = true;
          exec = "$HOME/.local/bin/weather.py waybar";
          interval = 900;
          return-type = "json";
        };
      }
    ];

    # Nord-themed styling
    style = ''
      /* Nord Color Palette */
      @define-color nord0 #2e3440;
      @define-color nord1 #3b4252;
      @define-color nord2 #434c5e;
      @define-color nord3 #4c566a;
      @define-color nord4 #d8dee9;
      @define-color nord5 #e5e9f0;
      @define-color nord6 #eceff4;
      @define-color nord7 #8fbcbb;
      @define-color nord8 #88c0d0;
      @define-color nord9 #81a1c1;
      @define-color nord10 #5e81ac;
      @define-color nord11 #bf616a;
      @define-color nord12 #d08770;
      @define-color nord13 #ebcb8b;
      @define-color nord14 #a3be8c;
      @define-color nord15 #b48ead;

      window#waybar {
        background-color: transparent;
      }

      * {
        background-color: transparent;
        border: none;
        border-radius: 4px;
        min-height: 0;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 14px;
      }

      #workspaces {
        background-color: @nord3;
        border: 3px solid @nord10;
        border-radius: 4px;
        padding: 0px 1px;
        margin: 0 3px 0 2px;
      }

      #workspaces button {
        all: initial;
        padding: 0px 4px;
        margin: 0 1px;
        min-width: 0;
        background-color: transparent;
        border-radius: 3px;
      }

      #workspaces button label {
        color: @nord9;
      }

      #workspaces button.empty {
        opacity: 0.5;
      }

      #workspaces button.empty label {
        color: @nord4;
      }

      #workspaces button.active {
        background-color: transparent;
      }

      #workspaces button.active label {
        color: @nord6;
      }

      #workspaces button:hover {
        background-color: @nord2;
      }

      #workspaces button:hover label {
        color: @nord8;
      }

      #window {
        padding: 0;
        margin: 0;
        color: @nord6;
      }

      #window > * {
        background-color: @nord3;
        border: 3px solid @nord10;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 3px;
      }

      window#waybar.empty #window {
        background-color: transparent;
        opacity: 0.0;
      }

      #clock {
        background-color: @nord3;
        border: 3px solid @nord10;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 3px;
        color: @nord6;
      }

      #custom-weather {
        background-color: @nord3;
        border: 3px solid @nord10;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 3px;
        color: @nord6;
      }

      /* Style modules to look grouped together */
      #cpu {
        background-color: @nord3;
        border: 3px solid @nord10;
        border-right: 1px solid @nord3;
        border-radius: 4px 0 0 4px;
        padding: 0px 12px;
        margin: 0 0 0 2px;
        color: @nord6;
        font-size: 18px;
      }

      #idle_inhibitor {
        background-color: @nord3;
        border-top: 3px solid @nord10;
        border-bottom: 3px solid @nord10;
        border-left: none;
        border-right: 1px solid @nord3;
        border-radius: 0;
        padding: 0px 6px;
        margin: 0;
        color: @nord6;
        font-size: 16px;
      }

      #idle_inhibitor.activated {
        color: @nord12;
      }

      #bluetooth {
        background-color: @nord3;
        border-top: 3px solid @nord10;
        border-bottom: 3px solid @nord10;
        border-left: none;
        border-right: 1px solid @nord3;
        border-radius: 0;
        padding: 0px 8px;
        margin: 0;
        color: @nord6;
        font-size: 18px;
      }

      #bluetooth.disabled {
        color: @nord3;
      }

      #bluetooth.connected {
        color: @nord6;
      }

      #pulseaudio {
        background-color: @nord3;
        border-top: 3px solid @nord10;
        border-bottom: 3px solid @nord10;
        border-left: none;
        border-right: 1px solid @nord3;
        border-radius: 0;
        padding: 0px 8px;
        margin: 0;
        color: @nord6;
        font-size: 18px;
      }

      #pulseaudio.muted {
        color: @nord3;
      }

      #network {
        background-color: @nord3;
        border-top: 3px solid @nord10;
        border-bottom: 3px solid @nord10;
        border-left: none;
        border-right: 1px solid @nord3;
        border-radius: 0;
        padding: 0px 10px;
        margin: 0;
        color: @nord6;
        font-size: 18px;
      }

      #network.disconnected {
        color: @nord11;
      }

      #battery {
        background-color: @nord3;
        border: 3px solid @nord10;
        border-left: none;
        border-radius: 0 4px 4px 0;
        padding: 0px 10px;
        margin: 0 2px 0 0;
        color: @nord6;
        font-size: 18px;
      }

      #battery.charging {
        color: @nord6;
      }

      #battery.warning:not(.charging) {
        color: @nord13;
        border-color: @nord10;
      }

      #battery.critical:not(.charging) {
        color: @nord11;
        border-color: @nord10;
      }

      #custom-expand-icon {
        background-color: @nord3;
        border: 3px solid @nord10;
        border-radius: 4px;
        padding: 0px 10px;
        margin: 0 2px;
        color: @nord6;
      }

      #tray {
        background-color: @nord3;
        border: 3px solid @nord10;
        border-radius: 4px;
        padding: 0px 4px;
        margin: 0 2px;
      }

      tooltip {
        background-color: @nord1;
        border: 3px solid @nord1;
        padding: 2px;
      }

      tooltip label {
        color: @nord6;
      }

      .hidden {
        opacity: 0;
      }

      .tray-group-item {
        background-color: transparent;
        border: none;
        border-radius: 0;
        padding: 0;
      }
    '';
  };
}
