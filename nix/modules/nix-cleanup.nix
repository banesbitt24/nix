{ ... }:

{
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Automatic store optimization (deduplication)
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # Additional Nix settings for better disk management
  nix.settings = {
    # Keep only the last 5 generations
    max-free = 1073741824; # 1GB - minimum free space to maintain
    min-free = 536870912;  # 512MB - trigger cleanup when below this

    # Auto-optimize store after each build
    auto-optimise-store = true;
  };
}
