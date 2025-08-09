{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    userSettings = {
      # Language server settings
      lsp = {
        nil = {
          initialization_options = {
            formatting = {
              command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
            };
          };
        };
        qmlls = {
          binary = {
            path = "${pkgs.qt6.qtdeclarative}/bin/qmlls";
          };
        };
      };

      # Language-specific settings
      languages = {
        Nix = {
          language_servers = [ "nil" ];
          formatter = {
            external = {
              command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
              arguments = [ ];
            };
          };
        };
      };

      # General editor settings
      format_on_save = "on";

      # Font settings
      buffer_font_family = "JetBrains Mono Nerd Font";
      ui_font_family = "JetBrains Mono Nerd Font";
      terminal_font_family = "JetBrains Mono Nerd Font";

      # Theme settings
      theme = "nord";
    };
  };
}
