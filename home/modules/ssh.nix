{ ... }:

{
  # Enable SSH agent
  services.ssh-agent = {
    enable = true;
  };

  # SSH client configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Default settings for all hosts
    matchBlocks."*" = {
      extraOptions = {
        AddKeysToAgent = "yes";
      };
    };
  };
}
