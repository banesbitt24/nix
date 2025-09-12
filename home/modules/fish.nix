{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    
    interactiveShellInit = ''
      # Disable greeting
      set fish_greeting
      
      # Enable starship prompt
      starship init fish | source
    '';
    
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      
      # Nix-specific aliases
      rebuild = "sudo nixos-rebuild switch --flake ~/.nix#quicksilver";
      rebuild-home = "home-manager switch --flake ~/.nix#quicksilver";
      update-flake = "nix flake update ~/.nix";
      nix-gc = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
    };
    
    functions = {
      # Function to quickly edit nix configs
      nixconf = {
        description = "Edit NixOS configuration files";
        body = ''
          cd ~/.nix
          $EDITOR .
        '';
      };
    };
  };
}