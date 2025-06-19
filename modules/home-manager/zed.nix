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
    };
  };
}