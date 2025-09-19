# walker.nix - Walker launcher configuration with Nord theme
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ walker ];

  home.file = {
    ".config/walker/config.json" = {
      text = builtins.toJSON {
        placeholder = "";
        fullscreen = false;
        width = 680;
        height = 560;
        position = "center";

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
          height = 480;
          always_show = true;
          hide_description = false;
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

    ".config/walker/style.css" = {
      text = ''
        /* Walker Nord Theme - High Contrast */

        #window {
          background: #2e3440;  /* Solid Nord0 background */
          border: 2px solid #5e81ac;  /* Nord10 border for definition */
          border-radius: 16px;
          box-shadow: 0 20px 60px rgba(0, 0, 0, 0.8);  /* Stronger shadow */
        }

        #input {
          background: #3b4252;  /* Solid Nord1 background */
          color: #eceff4;  /* Nord6 text */
          border: 1px solid #434c5e;  /* Nord2 border */
          border-radius: 12px;
          padding: 20px 24px;
          font-size: 18px;
          font-family: "CaskaydiaMono Nerd Font", "FiraCode Nerd Font", monospace;
        }

        #input:focus {
          border-color: #81a1c1;  /* Nord9 focus border */
          box-shadow: 0 0 0 2px rgba(129, 161, 193, 0.5);
          outline: none;
        }

        #input::placeholder {
          color: #4c566a;  /* Nord3 */
        }

        #list {
          background: transparent;
          padding: 0 16px 16px 16px;
        }

        .item {
          background: transparent;
          color: #eceff4;  /* Nord6 - bright white text */
          border-radius: 10px;
          padding: 14px 20px;
          margin: 2px 0;
          font-weight: 500;  /* Slightly bolder text */
          transition: all 0.15s ease;
        }

        .item:hover {
          background: #434c5e;  /* Solid Nord2 hover */
        }

        .item:selected {
          background: #5e81ac;  /* Solid Nord10 selection */
          color: #eceff4;  /* Ensure white text on selection */
        }

        .item .icon {
          margin-right: 16px;
          min-width: 32px;
          min-height: 32px;
          opacity: 1;  /* Full opacity for icons */
        }

        .item .title {
          color: #eceff4;  /* Bright white for titles */
          font-weight: 600;
          font-size: 15px;
        }

        .item .subtitle {
          color: #d8dee9;  /* Nord4 for subtitles */
          opacity: 1;  /* Remove transparency */
          font-size: 13px;
          margin-top: 2px;
        }

        /* Module-specific colors for selected items */
        .applications .item:selected .title {
          color: #88c0d0;  /* Nord8 - light blue */
        }

        .runner .item:selected .title {
          color: #a3be8c;  /* Nord14 - green */
        }

        .calc .item:selected .title {
          color: #ebcb8b;  /* Nord13 - yellow */
        }

        .websearch .item:selected .title {
          color: #d08770;  /* Nord12 - orange */
        }

        /* Scrollbar */
        scrollbar {
          background: transparent;
          width: 6px;
        }

        scrollbar slider {
          background: #4c566a;  /* Nord3 */
          border-radius: 3px;
        }

        scrollbar slider:hover {
          background: #5e81ac;  /* Nord10 */
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

