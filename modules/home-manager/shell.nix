{ ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
    settings = {
      theme = "nord";
      showHostname = true;
      showUsername = true;
      showCmdDuration = true;
      cmdDurationThreshold = 500;
      keybindings = {
        toggle = "ctrl-`";
      };
    };
  };

}
