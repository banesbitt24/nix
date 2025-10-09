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

  # Timer to update temperature every hour
  systemd.user.timers.hyprsunset = {
    Unit = {
      Description = "Update hyprsunset temperature hourly";
    };

    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1h";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.services.hyprsunset = {
    Unit = {
      Description = "Update hyprsunset temperature based on time";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "hyprsunset-update" ''
        # Kill existing hyprsunset instances
        ${pkgs.procps}/bin/pkill hyprsunset || true
        sleep 1

        # Run sunset-auto script
        hour=$(${pkgs.coreutils}/bin/date +%H)
        if [ $hour -ge 20 ] || [ $hour -le 6 ]; then
          ${pkgs.hyprsunset}/bin/hyprsunset -t 3000 &  # Very warm at night
        elif [ $hour -ge 18 ]; then
          ${pkgs.hyprsunset}/bin/hyprsunset -t 4000 &  # Warm in evening
        else
          ${pkgs.hyprsunset}/bin/hyprsunset -t 6500 &  # Normal during day
        fi
      ''}";
    };
  };

  # Or add to your Hyprland autostart instead
  # In your hyprland.nix extraConfig:
  # exec-once = ${pkgs.hyprsunset}/bin/hyprsunset -t 4000
}

