# walker.nix - Walker launcher configuration with Nord theme
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ walker ];

  home.file = {
    ".config/walker/config.json" = {
      text = builtins.toJSON {
        theme = "nord";
        placeholder = "";
        fullscreen = false;
        width = 600;
        height = 400;
        position = "center";
        force_keyboard_focus = true;
        
        search = {
          delay = 50;
          placeholder = "";
          force_keyboard_focus = true;
        };

        ui = {
          fullscreen = false;
          anchors = {
            top = false;
            bottom = false;
            left = false;
            right = false;
          };
          margins = {
            top = 0;
            bottom = 0;
            left = 0;
            right = 0;
          };
        };

        list = {
          height = 320;
          always_show = true;
          hide_description = true;
        };

        modules = [
          {
            name = "applications";
            prefix = "";
            applications = {
              show_desktop = true;
              show_hidden = false;
              actions = true;
              terminal = "${pkgs.kitty}/bin/kitty";
              prioritize_new = false;
            };
          }
          {
            name = "runner";
            prefix = ">";
            runner = {
              include_binaries = true;
              terminal = "${pkgs.kitty}/bin/kitty";
              shell = "${pkgs.zsh}/bin/zsh";
            };
          }
          {
            name = "calc";
            prefix = "=";
            calc = {
              precision = 12;
            };
          }
          {
            name = "websearch";
            prefix = "?";
            websearch = {
              engines = [
                {
                  name = "Google";
                  url = "https://www.google.com/search?q=%s";
                  prefix = "g";
                }
                {
                  name = "DuckDuckGo";
                  url = "https://duckduckgo.com/?q=%s";
                  prefix = "ddg";
                }
                {
                  name = "GitHub";
                  url = "https://github.com/search?q=%s";
                  prefix = "gh";
                }
                {
                  name = "NixOS Packages";
                  url = "https://search.nixos.org/packages?query=%s";
                  prefix = "nix";
                }
              ];
              browser = "${pkgs.brave}/bin/brave";
            };
          }
        ];

        keybindings = {
          "Escape" = "close";
          "Return" = "activate";
          "Tab" = "complete";
          "Down" = "next";
          "Up" = "prev";
          "Page_Down" = "page_down";
          "Page_Up" = "page_up";
          "Home" = "first";
          "End" = "last";
          "ctrl+j" = "next";
          "ctrl+k" = "prev";
          "ctrl+c" = "close";
        };
      };
    };

    # Custom nord theme
    ".config/walker/themes/nord.css" = {
      text = ''
        /* Walker Nord Theme - Waybar Style */
        @define-color background #2e3440;
        @define-color foreground #eceff4;

        * {
          font-family: "JetBrainsMono Nerd Font", monospace !important;
        }

        #window {
          color: @foreground;
        }

        #box {
          border-radius: 8px;
          background: @background;
          padding: 8px;
          border: 3px solid #5e81ac;
          box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6);
        }

        #search {
          box-shadow: none;
          background: @background;
          padding: 6px 8px;
          border: none;
          border-radius: 0;
        }

        #input {
          background: none;
          color: @foreground;
          border: none;
          border-radius: 0;
          font-size: 12px;
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-weight: normal;
        }

        #input:focus {
          border: none;
          box-shadow: none;
          outline: none;
        }

        #input placeholder {
          color: #4c566a;
          opacity: 0.7;
        }

        #list {
          background: transparent;
          padding: 0;
        }

        child {
          background: transparent;
          color: @foreground;
          border-radius: 0;
          padding: 2px 8px;
          margin: 0;
          font-weight: normal;
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 12px;
          transition: all 0.1s ease;
        }

        child:hover {
          background: rgba(236, 239, 244, 0.05);
        }

        child:selected {
          background: rgba(129, 161, 193, 0.15);
          color: #81a1c1;
        }

        #icon {
          margin-right: 8px;
          min-width: 16px;
          min-height: 16px;
          opacity: 0.8;
        }

        #label {
          color: @foreground;
          font-weight: 500;
          font-size: 12px;
          font-family: "JetBrainsMono Nerd Font", monospace;
        }

        child:selected #label {
          color: #eceff4;
          font-weight: 600;
        }

        /* AGGRESSIVELY HIDE ALL DESCRIPTION/SUBTITLE ELEMENTS */
        #sub,
        .sub,
        .subtitle,
        .description,
        child #sub,
        child .sub,
        child .subtitle,
        child .description {
          display: none !important;
          opacity: 0 !important;
          height: 0 !important;
          width: 0 !important;
          margin: 0 !important;
          padding: 0 !important;
          font-size: 0 !important;
          visibility: hidden !important;
          position: absolute !important;
          left: -9999px !important;
          overflow: hidden !important;
        }

        /* Hide activation labels */
        #activationlabel {
          display: none !important;
        }

        /* Scrollbar */
        scrollbar {
          background: transparent;
          border: none;
        }

        scrollbar slider {
          background: #4c566a;
          border-radius: 2px;
          border: none;
        }

        scrollbar slider:hover {
          background: #81a1c1;
        }
      '';
    };

    ".local/share/applications/walker.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Walker
        Comment=Application launcher for Wayland
        Exec=${pkgs.walker}/bin/walker
        Icon=walker
        Type=Application
        Categories=Utility;
        Terminal=false
        StartupWMClass=walker
      '';
    };
  };

  home.sessionVariables = {
    WALKER_TERMINAL = "${pkgs.kitty}/bin/kitty";
  };
}