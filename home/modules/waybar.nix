# waybar.nix - Waybar configuration for Home Manager (Omarchy-inspired)
{ pkgs, ... }:

{
  # Install Waybar and dependencies
  home.packages = with pkgs; [
    waybar
    pavucontrol # For pulseaudio module clicks
    blueman # For bluetooth module clicks
    ghostty # Terminal for various on-click actions
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
        height = 30;
        margin-top = 5;
        margin-left = 5;
        margin-right = 5;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [
          "clock"
          "custom/weather"
        ];

        modules-right = [
          "group/tray-expander"
          "network"
          "pulseaudio"
          "cpu"
          "battery"
          "bluetooth"
        ];

        # Module configurations - Omarchy style
        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{name}";
          all-outputs = true;
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

        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };

        cpu = {
          interval = 5;
          format = "󰍛";
          on-click = "kitty -e btop";
        };

        clock = {
          format = "{:L%A %H:%M}";
          format-alt = "{:L%d %B %Y}";
          tooltip = false;
        };

        network = {
          format-icons = [
            "󰤯"
            "󰤟"
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

        battery = {
          format = "{capacity}% {icon}";
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

        "group/tray-expander" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 600;
            children-class = "tray-group-item";
          };
          modules = [
            "custom/expand-icon"
            "tray"
            "idle_inhibitor"
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
        background-color: @nord0;
        border: 3px solid rgba(94, 129, 172, 0.93);
      }

      * {
        background-color: transparent;
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 16px;
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
      }

      #workspaces button label {
        color: #81a1c1;
      }

      #workspaces button.empty {
        opacity: 0.5;
      }

      #workspaces button.empty label {
        color: #4c566a;
      }

      #workspaces button.active {
        background-color: transparent;
        font-weight: bold;
      }

      #workspaces button.active label {
        color: #ebcb8b;
      }

      #workspaces button:hover label {
        color: #88c0d0;
      }

      #window {
        margin-left: 14px;
        color: #a3be8c;
        font-weight: bold;
      }

      #clock {
        margin-left: 8.75px;
        color: @nord8;
        font-weight: bold;
      }

      #custom-weather {
        color: @nord13;
        font-weight: bold;
      }

      #cpu {
        color: @nord12;
      }

      #battery {
        color: @nord14;
      }

      #battery.charging {
        color: @nord14;
      }

      #battery.warning:not(.charging) {
        color: @nord13;
      }

      #battery.critical:not(.charging) {
        color: @nord11;
      }

      #network {
        color: @nord9;
      }

      #network.disconnected {
        color: @nord11;
      }

      #bluetooth {
        color: @nord10;
      }

      #bluetooth.disabled {
        color: @nord3;
      }

      #bluetooth.connected {
        color: @nord8;
      }

      #pulseaudio {
        color: @nord15;
      }

      #pulseaudio.muted {
        color: @nord3;
      }

      #idle_inhibitor {
        color: @nord7;
      }

      #idle_inhibitor.activated {
        color: @nord13;
      }

      #tray,
      #cpu,
      #battery,
      #idle_inhibitor,
      #power-profiles-daemon,
      #network,
      #bluetooth,
      #pulseaudio,
      #custom-weather {
        min-width: 12px;
        margin: 0 7.5px;
      }

      #custom-expand-icon {
        margin-right: 7px;
        color: @nord4;
      }

      tooltip {
        background-color: @nord1;
        border: 1px solid @nord3;
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
