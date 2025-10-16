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
    };
  };
}
