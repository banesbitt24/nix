{ pkgs, config, ... }:

{
  # Create backup directory
  systemd.tmpfiles.rules = [
    "d /mnt/storage/backups 0700 root root -"
    "d /mnt/storage/backups/home 0700 root root -"
  ];

  # Install restic and backup utilities

  # Restic backup service
  systemd.services.restic-home-backup = {
    description = "Restic backup of home directory";
    after = [ "network.target" "mnt-storage.mount" ];
    requires = [ "mnt-storage.mount" ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Nice = 19;
      IOSchedulingClass = "idle";
    };

    environment = {
      RESTIC_REPOSITORY = "/mnt/storage/backups/home";
      RESTIC_PASSWORD_FILE = "/etc/nixos/secrets/restic-password";
    };

    script = ''
      set -e

      # Check if repository exists, initialize if not
      if ! ${pkgs.restic}/bin/restic snapshots &>/dev/null; then
        echo "Initializing restic repository..."
        ${pkgs.restic}/bin/restic init
      fi

      # Run backup
      echo "Starting backup of /home/brandon..."
      ${pkgs.restic}/bin/restic backup /home/brandon \
        --exclude='/home/brandon/.cache' \
        --exclude='/home/brandon/.local/share/Trash' \
        --exclude='/home/brandon/.local/share/Steam' \
        --exclude='/home/brandon/.nix/result*' \
        --exclude='/home/brandon/Downloads' \
        --exclude='/home/brandon/**/node_modules' \
        --exclude='/home/brandon/**/.git' \
        --exclude='/home/brandon/**/target' \
        --exclude='/home/brandon/**/build' \
        --exclude='/home/brandon/**/__pycache__' \
        --exclude='/home/brandon/**/.venv' \
        --exclude='/home/brandon/.dropbox' \
        --exclude='/home/brandon/.dropbox-dist' \
        --exclude='**/.direnv' \
        --exclude='**/dist' \
        --exclude='**/tmp' \
        --tag automated \
        --verbose

      # Cleanup old snapshots
      echo "Pruning old snapshots..."
      ${pkgs.restic}/bin/restic forget \
        --keep-daily 7 \
        --keep-weekly 4 \
        --keep-monthly 12 \
        --prune \
        --verbose

      # Check repository integrity (monthly)
      if [ "$(date +%d)" = "01" ]; then
        echo "Running repository check..."
        ${pkgs.restic}/bin/restic check
      fi

      echo "Backup completed successfully!"
    '';

    onFailure = [
      "restic-backup-failure@%n.service"
    ];
  };

  # Timer for automated backups (daily at 2 AM)
  systemd.timers.restic-home-backup = {
    description = "Timer for restic home backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 02:00:00";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
  };

  # Failure notification service (logs to journal)
  systemd.services."restic-backup-failure@" = {
    description = "Restic backup failure notification";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo \"Backup failed for %i\" | ${pkgs.systemd}/bin/systemd-cat -t restic-backup -p emerg'";
    };
  };

  # Helper scripts for manual backup management
  environment.systemPackages = with pkgs; [
    restic

    (writeShellScriptBin "backup-now" ''
      echo "Running manual backup..."
      sudo systemctl start restic-home-backup.service
      echo "Backup started! Check status with: sudo systemctl status restic-home-backup"
    '')

    (writeShellScriptBin "backup-status" ''
      echo "=== Backup Service Status ==="
      sudo systemctl status restic-home-backup.service --no-pager || true
      echo ""
      echo "=== Recent Backups ==="
      if [ -f "/etc/nixos/secrets/restic-password" ]; then
        sudo RESTIC_REPOSITORY="/mnt/storage/backups/home" RESTIC_PASSWORD_FILE="/etc/nixos/secrets/restic-password" ${restic}/bin/restic snapshots --compact
      else
        echo "Password file not found. Run: backup-init"
      fi
    '')

    (writeShellScriptBin "backup-restore" ''
      if [ -z "$1" ]; then
        echo "Available snapshots:"
        sudo RESTIC_REPOSITORY="/mnt/storage/backups/home" RESTIC_PASSWORD_FILE="/etc/nixos/secrets/restic-password" ${restic}/bin/restic snapshots
        echo ""
        echo "Usage: backup-restore <snapshot-id> [target-dir]"
        echo "Example: backup-restore latest ~/restore"
        exit 1
      fi

      TARGET="''${2:-.}"
      echo "Restoring snapshot $1 to $TARGET..."
      sudo RESTIC_REPOSITORY="/mnt/storage/backups/home" RESTIC_PASSWORD_FILE="/etc/nixos/secrets/restic-password" ${restic}/bin/restic restore "$1" --target "$TARGET"
      echo "Restore complete!"
    '')

    (writeShellScriptBin "backup-init" ''
      echo "Initializing backup system..."

      # Create password file
      if [ ! -f /etc/nixos/secrets/restic-password ]; then
        echo "Creating restic password file..."
        sudo mkdir -p /etc/nixos/secrets
        sudo bash -c "tr -dc A-Za-z0-9 </dev/urandom | head -c 32 > /etc/nixos/secrets/restic-password"
        sudo chmod 600 /etc/nixos/secrets/restic-password
        echo "✓ Password file created at /etc/nixos/secrets/restic-password"
      else
        echo "✓ Password file already exists"
      fi

      # Initialize repository
      if ! sudo RESTIC_REPOSITORY="/mnt/storage/backups/home" RESTIC_PASSWORD_FILE="/etc/nixos/secrets/restic-password" ${restic}/bin/restic snapshots &>/dev/null; then
        echo "Initializing restic repository..."
        sudo RESTIC_REPOSITORY="/mnt/storage/backups/home" RESTIC_PASSWORD_FILE="/etc/nixos/secrets/restic-password" ${restic}/bin/restic init
        echo "✓ Repository initialized"
      else
        echo "✓ Repository already initialized"
      fi

      echo ""
      echo "Backup system ready! You can now:"
      echo "  backup-now       - Run a backup immediately"
      echo "  backup-status    - Check backup status and snapshots"
      echo "  backup-restore   - Restore files from a backup"
      echo ""
      echo "Automatic backups will run daily at 2 AM"
    '')
  ];
}
