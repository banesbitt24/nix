{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.brandon = {
    isNormalUser = true;
    description = "Brandon";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    packages = with pkgs; [
      #ungoogled-chromium
      firefox
      papirus-nord
      git
      jetbrains-mono
      nixd
      nil
      nixfmt-rfc-style
      neovim
    ];
    # SSH public keys for this user
    openssh.authorizedKeys.keys = [
      # Add your SSH public key here
      # Example: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbcd1234... your-email@example.com"
      # "ssh-rsa AAAAB3NzaC1yc2EAAAA... your-email@example.com"
    ];
  };

  # Enable SSH daemon
  services.openssh = {
    enable = true;
    settings = {
      # Disable root login
      PermitRootLogin = "no";
      # Disable password authentication (only allow key-based auth)
      PasswordAuthentication = false;
      # Allow public key authentication
      PubkeyAuthentication = true;
    };
  };
}
