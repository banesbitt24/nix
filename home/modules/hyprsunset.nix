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
  systemd.user.timers.hyprsunset-update = {
    Unit = {
      Description = "Update hyprsunset temperature hourly";
    };

    Timer = {
      OnBootSec = "1min";
      OnCalendar = "hourly";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  # Main hyprsunset service that runs continuously
  systemd.user.services.hyprsunset = {
    Unit = {
      Description = "Hyprsunset color temperature daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.writeShellScript "hyprsunset-daemon" ''
        # Determine color temperature based on current hour
        hour=$(${pkgs.coreutils}/bin/date +%H)
        if [ $hour -ge 20 ] || [ $hour -le 6 ]; then
          temp=3000  # Very warm at night
        elif [ $hour -ge 18 ]; then
          temp=4000  # Warm in evening
        else
          temp=6500  # Normal during day
        fi

        # Run hyprsunset in foreground
        exec ${pkgs.hyprsunset}/bin/hyprsunset -t $temp
      ''}";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };

  # Oneshot service triggered by timer to restart hyprsunset with new temperature
  systemd.user.services.hyprsunset-update = {
    Unit = {
      Description = "Update hyprsunset color temperature";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.systemd}/bin/systemctl --user restart hyprsunset.service'";
    };
  };

  # Or add to your Hyprland autostart instead
  # In your hyprland.nix extraConfig:
  # exec-once = ${pkgs.hyprsunset}/bin/hyprsunset -t 4000
}

