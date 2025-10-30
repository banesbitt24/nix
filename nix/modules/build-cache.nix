{ pkgs, ... }:

{
  # Create directories for build caching
  systemd.tmpfiles.rules = [
    "d /mnt/storage/nix-cache 0755 root root -"
    "d /mnt/storage/projects 0755 brandon users -"
  ];

  # Nix build cache settings
  nix.settings = {
    # Enable local binary cache
    extra-substituters = [
      "file:///mnt/storage/nix-cache"
    ];

    # Trust the local cache
    trusted-substituters = [
      "file:///mnt/storage/nix-cache"
    ];

    # Keep more build results for faster rebuilds
    keep-outputs = true;
    keep-derivations = true;

    # Increase build cores for faster compilation
    # Uses all cores except 2 for system responsiveness
    cores = 10;
    max-jobs = 12;

    # More aggressive build parallelism
    builders-use-substitutes = true;
  };

  # Script to populate local binary cache
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "nix-cache-build" ''
      # Copy build outputs to local cache
      if [ -z "$1" ]; then
        echo "Usage: nix-cache-build <store-path>"
        echo "Example: nix-cache-build /nix/store/..."
        exit 1
      fi

      echo "Copying $1 to local cache..."
      ${pkgs.nix}/bin/nix copy --to file:///mnt/storage/nix-cache "$1"
      echo "Done! Cached at /mnt/storage/nix-cache"
    '')
  ];

  # Docker BuildKit optimizations (already using /mnt/storage/docker)
  virtualisation.docker.daemon.settings = {
    # Enable BuildKit for better caching
    features = {
      buildkit = true;
    };
  };
}
