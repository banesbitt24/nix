{ pkgs, ... }:

{
  programs.bash = {
    enable = true;

    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];

    historyControl = [ "ignoredups" "ignorespace" ];
    historyFile = "\${HOME}/.bash_history";
    historyFileSize = 10000;
    historySize = 5000;

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      lg = "lazygit";
      ld = "lazydocker";
      k = "kubectl";

      # Nix-specific aliases
      rebuild = "sudo nixos-rebuild switch --flake ~/.nix#quicksilver";
      rebuild-home = "home-manager switch --flake ~/.nix#quicksilver";
      update-flake = "nix flake update ~/.nix";
      nix-gc = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
    };

    bashrcExtra = ''
      # Enable starship prompt
      eval "$(starship init bash)"

      # Better directory navigation
      shopt -s autocd 2>/dev/null

      # Terminal switcher function
      switch-term() {
        local term="''${1:-kitty}"
        case "$term" in
          kitty)
            export TERMINAL="kitty"
            echo "Switched default terminal to kitty"
            ;;
          foot)
            export TERMINAL="foot"
            echo "Switched default terminal to foot"
            ;;
          alacritty)
            export TERMINAL="alacritty"
            echo "Switched default terminal to alacritty"
            ;;
          *)
            echo "Unknown terminal: $term"
            echo "Available: kitty, foot, alacritty"
            return 1
            ;;
        esac
      }

      # nixconf function to quickly edit nix configs
      nixconf() {
        cd ~/.nix
        $EDITOR .
      }
    '';

    # Session variables
    sessionVariables = {
      EDITOR = "hx";
      TERMINAL = "kitty";
    };
  };
}
