{ pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "brandon";
  home.homeDirectory = "/home/brandon";

  imports = [
    ./modules/bibata-cursor.nix
    ./modules/brave.nix
    ./modules/btop.nix
    ./modules/gtk.nix
    ./modules/hypridle.nix
    ./modules/hyprland.nix
    ./modules/hyprlock.nix
    ./modules/hyprpaper.nix
    ./modules/hyprsunset.nix
    ./modules/fish.nix
    ./modules/helix.nix
    ./modules/k9s.nix
    ./modules/kitty.nix
    ./modules/lazydocker.nix
    ./modules/lazygit.nix
    ./modules/mako.nix
    ./modules/rofi.nix
    ./modules/ssh.nix
    ./modules/starship.nix
    ./modules/zellij.nix
    ./modules/waybar.nix
  ];

  home.sessionVariables = {
    #EDITOR = "vim";
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

  # Clipboard manager configuration
  home.file.".local/bin/rofi-clipboard" = {
    text = ''
      #!/usr/bin/env bash

      # Show clipboard history with rofi and copy selection
      selection=$(cliphist list | rofi -dmenu -i -p " Clipboard" -theme ~/.config/rofi/nord.rasi)

      if [ -n "$selection" ]; then
        # Decode and copy the selected item
        echo "$selection" | cliphist decode | wl-copy
      fi
    '';
    executable = true;
  };

  # Weather script with Python wrapper
  home.file.".local/bin/weather.py" = {
    text = ''
      #!${pkgs.python3.withPackages (ps: with ps; [ requests ])}/bin/python3
      ${builtins.replaceStrings [ "#!/usr/bin/env python3" ] [ "" ] (
        builtins.readFile ../scripts/weather.py
      )}
    '';
    executable = true;
  };

  # Screenshot menu with rofi
  home.file.".local/bin/rofi-screenshot" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Screenshot menu options
      options="Area Clipboard\nArea File\nFull File\nRecord Toggle"

      # Show menu and get selection
      chosen=$(echo -e "$options" | rofi -dmenu -i -p "Screenshot")

      case $chosen in
          "Area Clipboard")
              area=$(slurp) && grim -g "$area" - | wl-copy && notify-send "Screenshot" "Area copied to clipboard"
              ;;
          "Area File")
              area=$(slurp) && grim -g "$area" ~/Nextcloud/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png && notify-send "Screenshot" "Area saved to ~/Nextcloud/Pictures/Screenshots/"
              ;;
          "Full File")
              grim ~/Nextcloud/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png && notify-send "Screenshot" "Full screen saved to ~/Nextcloud/Pictures/Screenshots/"
              ;;
          "Record Toggle")
              if pgrep wf-recorder; then
                  pkill wf-recorder && notify-send "Recording" "Recording stopped"
              else
                  area=$(slurp) && wf-recorder -g "$area" -f ~/Nextcloud/Videos/Screenshots/recording-$(date +%Y%m%d-%H%M%S).mp4 & notify-send "Recording" "Recording started"
              fi
              ;;
      esac
    '';
  };

  # Custom power menu with hyprlock
  home.file.".local/bin/rofi-power-hypr" = {
    text = ''
      #!/usr/bin/env bash

      # Power menu options
      options=" Lock\n󰍃 Logout\n󰒲 Suspend\n⏾ Hibernate\n󰜉 Reboot\n⏻ Shutdown"

      # Show menu and get selection
      chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme ~/.config/rofi/nord.rasi)

      case $chosen in
          " Lock")
              ${pkgs.hyprlock}/bin/hyprlock
              ;;
          "󰍃 Logout")
              hyprctl dispatch exit
              ;;
          "󰒲 Suspend")
              systemctl suspend
              ;;
          "⏾ Hibernate")
              systemctl hibernate
              ;;
          "󰜉 Reboot")
              systemctl reboot
              ;;
          "⏻ Shutdown")
              systemctl poweroff
              ;;
      esac
    '';
    executable = true;
  };
  # Clip history user service
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Clipboard history daemon";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  news.display = "silent";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  #home.packages = with pkgs; [
  #];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  #home.file = {
  # # Building this configuration will create a copy of 'dotfiles/screenrc' in
  # # the Nix store. Activating the configuration will then make '~/.screenrc' a
  # # symlink to the Nix store copy.
  # ".screenrc".source = dotfiles/screenrc;

  # # You can also set the file content immediately.
  # ".gradle/gradle.properties".text = ''
  #   org.gradle.console=verbose
  #   org.gradle.daemon.idletimeout=3600000
  # '';
  #};

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/brandon/etc/profile.d/hm-session-vars.sh
  #

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
