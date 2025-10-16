{ config, pkgs, ... }:

{
  # Configure sops-nix for secrets management
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age = {
      # Use the user's age key for decryption
      # This key is stored in the home directory and excluded from git
      keyFile = "/home/brandon/.config/sops/age/keys.txt";
    };

    # Define secrets to be decrypted
    secrets = {
      "openweather-api-key" = {
        # Make the secret readable by the brandon user
        owner = "brandon";
        mode = "0400";
      };

      "ssh-private-key" = {
        # SSH private key will be deployed to /run/secrets/ssh-private-key
        owner = "brandon";
        mode = "0600";
        path = "/home/brandon/.ssh/id_ed25519";
      };

      "ssh-public-key" = {
        # SSH public key will be deployed to /run/secrets/ssh-public-key
        owner = "brandon";
        mode = "0644";
        path = "/home/brandon/.ssh/id_ed25519.pub";
      };
    };
  };
}
