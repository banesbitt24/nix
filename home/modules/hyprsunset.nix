# hyprsunset.nix or add to your home.nix
{ config, pkgs, ... }:

{
  # Install hyprsunset
  home.packages = with pkgs; [
    hyprsunset
    (writeShellScriptBin "sunset-auto" ''
      hour=$(date +%H)
      if [ $hour -ge 20 ] || [ $hour -le 6 ]; then
        ${hyprsunset}/bin/hyprsunset -t 3000  # Very warm at night
      elif [ $hour -ge 18 ]; then
        ${hyprsunset}/bin/hyprsunset -t 4000  # Warm in evening
      else
        ${hyprsunset}/bin/hyprsunset -t 6500  # Normal during day
      fi
    '')
  ];

  # Optional: Create systemd user service for automatic scheduling
  systemd.user.services.hyprsunset = {
    Unit = {
      Description = "Hyprsunset blue light filter";
      PartOf = [ "hyprland-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 4000"; # 4000K temperature
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };

  # Or add to your Hyprland autostart instead
  # In your hyprland.nix extraConfig:
  # exec-once = ${pkgs.hyprsunset}/bin/hyprsunset -t 4000
}
