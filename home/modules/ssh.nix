{ ... }:

{
  # Enable SSH agent
  services.ssh-agent = {
    enable = true;
  };

  # SSH client configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = true;

    # SSH config settings
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
