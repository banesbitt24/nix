# waybar.nix - Waybar configuration for Home Manager
{ config, pkgs, ... }:

{
  # Install Waybar and dependencies
  home.packages = with pkgs; [
    waybar
    pavucontrol    # For pulseaudio module clicks
    blueman        # For bluetooth module clicks
    networkmanagerapplet  # For network module clicks
    wlogout        # For exit module
    
    # Additional tools your config might need
    ghostty        # Terminal referenced in your config
    nautilus       # File manager
  ];

  # Configure Waybar
  programs.waybar = {
    enable = true;
    
    # Your main config (dual bar setup)
    settings = [
      {
        # Top bar
        layer = "top";
        position = "top";
        margin-bottom = 0;
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;
        spacing = 0;

        # Load modules from separate config
        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "clock"
          "custom/weather"
        ];

        modules-right = [
          "pulseaudio"
          "backlight"
          "network"
          "tray"
          "custom/exit"
        ];

        # Module configurations
        "hyprland/workspaces" = {
          on-click = "activate";
          active-only = false;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "WWW";
            "2" = "DEV";
            "3" = "MEDIA";
            "4" = "NOTES";
            "5" = "MAIL";
            "6" = "VIRT";
          };
          persistent-workspaces = {
            "*" = 6;
          };
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };

        clock = {
          format = "{:%A, %B %d - %H:%M}";
          # on-click = "ags -t calendar";  # Comment out if you don't have ags
          tooltip = false;
        };

        cpu = {
          interval = 10;
          format = "  CPU: {}% ";
          max-length = 20;
        };

        memory = {
          interval = 30;
          format = "  MEM: {used:0.1f}G ";
          max-length = 20;
        };

        disk = {
          interval = 30;
          format = "󰋊  SSD: {free} free";
          unit = "GB";
          path = "/";
        };

        network = {
          format = "{ifname}";
          format-wifi = "  {signalStrength}%";
          format-ethernet = "  {ipaddr}";
          format-disconnected = "Not connected";
          tooltip-format = " {ifname} via {gwaddri}";
          tooltip-format-wifi = "   {essid} ({signalStrength}%)";
          tooltip-format-ethernet = "  {ifname} ({ipaddr}/{cidr})";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          on-click = "${pkgs.kitty}/bin/kitty -e nmtui";  # Use kitty instead of ghostty
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "  {capacity}%";
          format-plugged = "  {capacity}%";
          format-alt = "{icon}  {time}";
          format-icons = [" " " " " " " " " "];
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}%  {icon}   {format_source}";
          format-bluetooth-muted = "  {icon}   {format_source}";
          format-muted = "  {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" " " " "];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        tray = {
          spacing = 10;
        };

        "custom/exit" = {
          format = "";
          on-click = "${pkgs.wlogout}/bin/wlogout";
          tooltip = false;
        };

        "custom/weather" = {
          format = "{}";
          tooltip = true;
          # exec = "~/.config/scripts/weather.sh";  # You'll need to create this script
          exec = "echo '☀️ 22°C'";  # Placeholder
          interval = 900;
          return-type = "json";
        };

        "custom/updates" = {
          format = "  {}";
          tooltip-format = "{}";
          escape = true;
          return-type = "json";
          # exec = "~/.config/scripts/updates.sh";  # You'll need to create this script
          exec = "echo '{\"text\":\"0\", \"tooltip\":\"No updates\"}'";  # Placeholder
          restart-interval = 60;
          on-click = "${pkgs.kitty}/bin/kitty -e sudo nixos-rebuild switch";
          tooltip = false;
        };
      }
      {
        # Bottom bar
        layer = "top";
        position = "bottom";
        margin-bottom = 0;
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;
        spacing = 0;

        modules-left = [
          "custom/updates"
          "cpu"
          "memory"
          "disk"
        ];

        modules-center = [
          "hyprland/window"
        ];

        modules-right = [
          "mpris"
          "battery"
        ];

        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          enable-bar-scroll = true;
          separate-outputs = true;
        };

        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          max-length = 50;
          player-icons = {
            default = "▶";
            mpv = "🎵";
          };
          status-icons = {
            paused = "⏸";
          };
        };
      }
    ];

    # Your CSS styling with Nord colors
    style = ''
      /* Nord color definitions */
      @define-color backgroundcolor #2e3440;
      @define-color foregroundcolor #eceff4;
      @define-color workspacesbackground1 #EEEEEE;
      @define-color workspacesbackground2 #FFFFFF;
      @define-color bordercolor #5e81ac;
      @define-color textcolor1 #eceff4;
      @define-color textcolor2 #d8dee9;
      @define-color textcolor3 #81a1c1;
      @define-color iconcolor #88c0d0;

      /* General */
      * {
          font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
          font-size: 12px;
          font-weight: bold;
          border: none;
          border-radius: 0px;
      }

      window#waybar {
          background-color: transparent;
          transition-property: background-color;
          transition-duration: 0.5s;
          opacity: 0.8;
      }

      /* Workspaces */
      #workspaces {
          margin: 5px 1px 6px 1px;
          padding: 0px 1px;
          border-radius: 5px;
          border: 0px;
          font-style: normal;
          font-size: 12px;
      }

      #workspaces button {
          padding: 0px 2px;
          margin: 4px 3px;
          border-radius: 5px;
          border: 0px;
          transition: all 0.3s ease-in-out;
          color: @foregroundcolor;
      }

      #workspaces button.active {
          color: @foregroundcolor;
          background: @backgroundcolor;
          border-radius: 5px;
          min-width: 40px;
          transition: all 0.3s ease-in-out;
          opacity: 0.9;
      }

      #workspaces button:hover {
          background: @backgroundcolor;
          color: @foregroundcolor;
          border-radius: 5px;
          min-width: 40px;
      }

      /* Window */
      #window {
          background: @backgroundcolor;
          margin: 10px 15px 10px 0px;
          padding: 4px 10px 4px 10px;
          border-radius: 5px;
          color: @foregroundcolor;
          font-size: 12px;
          font-weight: bold;
      }

      window#waybar.empty #window {
          background-color: transparent;
      }

      /* Modules */
      #custom-exit {
          padding: 5px 15px 5px 10px;
          margin: 10px 15px 10px 0px;
          background-color: @backgroundcolor;
          border-radius: 5px;
          border: 0px;
          color: @foregroundcolor;
      }

      #custom-weather {
          padding: 5px 10px 5px 10px;
          margin: 10px 15px 10px 0px;
          background-color: @backgroundcolor;
          border-radius: 5px;
          border: 0px;
          color: @foregroundcolor;
      }

      #custom-updates {
          background-color: @backgroundcolor;
          background: @backgroundcolor;
          font-size: 12px;
          border-radius: 5px;
          padding: 5px 10px 5px 10px;
          margin: 10px 15px 10px 10px;
          color: @foregroundcolor;
      }

      #disk, #memory, #cpu {
          padding: 5px 10px 5px 10px;
          margin: 10px 15px 10px 0px;
          background-color: @backgroundcolor;
          border-radius: 5px;
          border: 0px;
          color: @foregroundcolor;
      }

      #clock {
          background-color: @backgroundcolor;
          font-size: 12px;
          border-radius: 5px;
          padding: 5px 10px 5px 10px;
          margin: 10px 15px 10px 0px;
          color: @foregroundcolor;
      }

      #backlight {
          background-color: @backgroundcolor;
          font-size: 12px;
          border-radius: 5px;
          padding: 5px 10px 5px 10px;
          margin: 10px 15px 10px 0px;
          color: @foregroundcolor;
      }

      #pulseaudio {
          background-color: @backgroundcolor;
          font-size: 12px;
          border-radius: 5px;
          padding: 5px 10px 5px 10px;
          margin: 10px 15px 10px 0px;
          color: @foregroundcolor;
      }

      #network {
          background-color: @backgroundcolor;
          font-size: 12px;
          border-radius: 5px;
          padding: 5px 10px 5px 10px;
          margin: 10px 15px 10px 0px;
          color: @foregroundcolor;
      }

      #battery {
          background-color: @backgroundcolor;
          font-size: 12px;
          border-radius: 5px;
          padding: 5px 15px 5px 10px;
          margin: 10px 15px 10px 0px;
          color: @foregroundcolor;
      }

      #battery.critical:not(.charging) {
          background-color: #bf616a;
          color: @foregroundcolor;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      @keyframes blink {
          to {
              background-color: @backgroundcolor;
          }
      }

      #mpris {
          background-color: @backgroundcolor;
          font-size: 12px;
          border-radius: 5px;
          padding: 5px 15px 5px 10px;
          margin: 10px 15px 10px 0px;
          color: @foregroundcolor;
      }

      #tray {
          padding: 5px 10px 5px 10px;
          margin: 10px 15px 10px 0px;
          background-color: @backgroundcolor;
          border-radius: 5px;
          border: 0px;
          color: @foregroundcolor;
      }

      tooltip {
          border-radius: 10px;
          background-color: @backgroundcolor;
          color: @foregroundcolor;
          opacity: 0.8;
          padding: 20px;
          margin: 0px;
      }

      tooltip label {
          color: #eceff4;
      }
    '';
  };
