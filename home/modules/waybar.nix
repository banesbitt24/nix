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
          "bluetooth"
          "network"
          "pulseaudio"
        ];

        # Module configurations - Omarchy style
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
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format = "{icon}  {essid}: {signalStrength}%";
          format-wifi = "{icon}  {essid}: {signalStrength}%";
          format-ethernet = "󰀂 Wired Connection";
          format-disconnected = "󰤮 Disconnected";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          spacing = 1;
          on-click = "kitty --class nmtui -e ${pkgs.networkmanager}/bin/nmtui";
        };

        idle_inhibitor = {
          format = "{icon} Idle: {status}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };

        bluetooth = {
          format = "󰂯 Bluetooth: {status}";
          format-disabled = "󰂲 Bluetooth: {status}";
          format-connected = "󰂱 Bluetooth {device_alias}";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "blueman-manager";
        };

        pulseaudio = {
          format = "{icon} Volume: {volume}%";
          format-muted = "󰝟 Volume: {volume}%";
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

      # Bottom bar
      {
        reload_style_on_change = true;
        layer = "top";
        position = "bottom";
        spacing = 0;
        height = 24;
        margin-bottom = 5;
        margin-left = 5;
        margin-right = 5;

        modules-left = [
          "cpu#bottom"
          "memory"
          "disk"
        ];

        modules-center = [
          "hyprland/window"
        ];

        modules-right = [
          "custom/mpris"
          "idle_inhibitor"
          "battery"
        ];

        idle_inhibitor = {
          format = "{icon} Idle: {status}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };

        battery = {
          format = "{icon} Battery: {capacity}%";
          format-discharging = "{icon} Battery: {capacity}%";
          format-charging = "{icon} Battery: {capacity}%";
          format-plugged = "{icon} Battery: {capacity}%";
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

        # Bottom bar module configurations
        "cpu#bottom" = {
          interval = 5;
          format = "󰍛 CPU: {usage}%";
          on-click = "kitty -e btop";
        };

        memory = {
          interval = 5;
          format = "  MEM: {used}G";
          tooltip-format = "{used:0.1f}G / {total:0.1f}G used";
          on-click = "kitty -e btop";
        };

        disk = {
          interval = 30;
          format = "󰋊 SSD: {free}";
          path = "/";
          tooltip-format = "{used} / {total} used ({percentage_used}%)";
          on-click = "kitty -e btop";
        };

        "hyprland/window" = {
          format = "<span>{title}</span>";
          rewrite = {
            "(.*)" = "$1";
          };
          max-length = 50;
          separate-outputs = true;
        };

        "custom/mpris" = {
          exec = "playerctl metadata --format '{{title}} - {{artist}}' 2>/dev/null";
          interval = 1;
          on-click = "playerctl play-pause";
          max-length = 50;
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "rofi-power-hypr";
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
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 1px;
        margin: 0 2px;
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
        font-weight: bold;
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
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #window > * {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
      }

      window#waybar.empty #window {
        background-color: transparent;
        opacity: 0.0;
      }

      #clock {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #custom-weather {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #cpu.bottom {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #cpu {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
      }

      #battery {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #battery.charging {
        color: @nord6;
      }

      #battery.warning:not(.charging) {
        color: @nord13;
        border-color: @nord1;
      }

      #battery.critical:not(.charging) {
        color: @nord11;
        border-color: @nord1;
      }

      #network {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #network.disconnected {
        color: @nord11;
        border-color: @nord1;
      }

      #bluetooth {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #bluetooth.disabled {
        color: @nord3;
      }

      #bluetooth.connected {
        color: @nord6;
      }

      #pulseaudio {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #pulseaudio.muted {
        color: @nord3;
      }

      #idle_inhibitor {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #idle_inhibitor.activated {
        color: @nord12;
        border-color: @nord1;
      }

      #custom-expand-icon {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #tray {
        background-color: @nord3;
        border: 3px solid @nord1;
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

      /* Bottom bar styling */

      #memory {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #disk {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #custom-mpris {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord6;
        font-weight: bold;
      }

      #custom-mpris.empty {
        background: transparent;
        border: none;
        min-width: 0;
        min-height: 0;
        padding: 0;
        margin: 0;
      }

      #custom-power {
        background-color: @nord3;
        border: 3px solid @nord1;
        border-radius: 4px;
        padding: 0px 6px;
        margin: 0 2px;
        color: @nord11;
        font-size: 16px;
        font-weight: bold;
      }

      #custom-power:hover {
        color: @nord13;
        border-color: @nord1;
      }
    '';
  };
}
