# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.extraOptions = ''
    warn-dirty = false
  '';

  # Optional: configure fish to use starship
  environment.shells = [ pkgs.fish ];

  programs.fish = {
    enable = true;
    shellInit = ''
      set -Ux ZED_ALLOW_EMULATED_GPU  1
    '';
  };

  users.users.brandon.shell = pkgs.fish;

  # Ensure the fish config file includes the Starship initialization line
  environment.etc."fish/config.fish".text = ''
    starship init fish | source
  '';

  #boot.initrd.luks.devices."luks-3235e4dd-286d-4123-bb8b-56442aeef650".device =
  #  "/dev/disk/by-uuid/3235e4dd-286d-4123-bb8b-56442aeef650";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot`

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "brandon" = import ./brandon.nix;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
