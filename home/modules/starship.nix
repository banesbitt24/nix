{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    
    settings = {
      format = "$all$character";
      
      # Use the Nerd Font preset
      "$schema" = "https://starship.rs/config-schema.json";
      
      character = {
        success_symbol = "[](bold green)";
        error_symbol = "[](bold red)";
        vimcmd_symbol = "[](bold yellow)";
      };
      
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        read_only = " 󰌾";
      };
      
      git_branch = {
        symbol = " ";
        format = "[$symbol$branch]($style) ";
        style = "bold purple";
      };
      
      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        style = "bold red";
        conflicted = "";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?\${count}";
        stashed = " ";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
      };
      
      nix_shell = {
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = " ";
        style = "bold blue";
      };
      
      cmd_duration = {
        min_time = 2000;
        format = " [$duration]($style) ";
        style = "yellow bold";
      };
      
      kubernetes = {
        format = "[$symbol$context( \\($namespace\\))]($style) ";
        style = "cyan bold";
        symbol = "󱃾 ";
        disabled = false;
      };
      
      battery = {
        full_symbol = "󰁹 ";
        charging_symbol = "󰂄 ";
        discharging_symbol = "󰂃 ";
        
        display = [
          {
            threshold = 10;
            style = "bold red";
          }
          {
            threshold = 30;
            style = "bold yellow";
          }
        ];
      };
    };
  };
}