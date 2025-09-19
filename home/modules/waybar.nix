# waybar.nix - Waybar configuration for Home Manager (Omarchy-inspired)
{ config, pkgs, ... }:

{
  # Install Waybar and dependencies
  home.packages = with pkgs; [
    waybar
    pavucontrol    # For pulseaudio module clicks
    blueman        # For bluetooth module clicks
    btop           # System monitor for CPU module
    ghostty        # Terminal for various on-click actions
    wttrbar        # Weather bar for custom weather module
  ];

  # Configure Waybar with Omarchy's clean setup
  programs.waybar = {
    enable = true;
    
    # Omarchy's configuration
    settings = [
      {
        reload_style_on_change = true;
        layer = "top";
        position = "top";
        spacing = 0;
        height = 26;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "clock"
          "custom/weather"
        ];

        modules-right = [
          "group/tray-expander"
          "bluetooth"
          "network"
          "pulseaudio"
          "cpu"
          "battery"
        ];

        # Module configurations - Omarchy style
        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{name}";
          all-outputs = true;
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
            "6" = [];
          };
        };

        cpu = {
          interval = 5;
          format = "󰍛";
          on-click = "${pkgs.ghostty}/bin/ghostty -e btop";
        };

        clock = {
          format = "{:L%A %H:%M}";
          format-alt = "{:L%d %B %Y}";
          tooltip = false;
        };

        network = {
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰤮";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          spacing = 1;
          on-click = "${pkgs.ghostty}/bin/ghostty -e nmtui";
        };

        battery = {
          format = "{capacity}% {icon}";
          format-discharging = "{icon}";
          format-charging = "{icon}";
          format-plugged = "";
          format-icons = {
            charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
            default = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
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

        bluetooth = {
          format = "";
          format-disabled = "󰂲";
          format-connected = "";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "${pkgs.blueman}/bin/blueman-manager";
        };

        pulseaudio = {
          format = "{icon}";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          tooltip-format = "Playing at {volume}%";
          scroll-step = 5;
          format-muted = "";
          format-icons = {
            default = ["" "" ""];
          };
        };

        "group/tray-expander" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 600;
            children-class = "tray-group-item";
          };
          modules = ["custom/expand-icon" "tray"];
        };

        "custom/expand-icon" = {
          format = "󰞗 ";
          tooltip = false;
        };

        tray = {
          icon-size = 12;
          spacing = 12;
        };

        "custom/weather" = {
          format = "{}";
          tooltip = true;
          exec = "wttrbar --fahrenheit --mph --location Highlands_Ranch --custom-indicator '{ICON} {temp_F}°'"; 
          interval = 900;
          return-type = "json";
        };
      }
    ];

    # Omarchy's clean minimal styling
    style = ''
      @define-color background #2e3440;
      @define-color foreground #eceff4;

      * {
        background-color: @background;
        color: @foreground;
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 12px;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 1.5px;
        min-width: 9px;
        background-color: transparent;
        color: @foreground;
      }

      #workspaces button.empty {
        opacity: 0.5;
      }

      #workspaces button.active {
        background-color: transparent;
        color: #81a1c1;
        font-weight: bold;
      }

      #tray, 
      #cpu, 
      #battery, 
      #network, 
      #bluetooth, 
      #pulseaudio,
      #custom-weather {
        min-width: 12px;
        margin: 0 7.5px;
      }

      #custom-expand-icon {
        margin-right: 7px;
      }

      tooltip {
        padding: 2px;
      }

      #clock {
        margin-left: 8.75px;
      }

      .hidden {
        opacity: 0;
      }

      #battery.critical:not(.charging) {
        color: #bf616a;
      }

      .tray-group-item {
        background-color: @background;
        border: none;
        border-radius: 0;
        padding: 0;
      }
    '';
  };
}

