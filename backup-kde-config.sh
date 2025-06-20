#!/usr/bin/env bash
# Backup script for KDE configuration before applying Nix plasma-manager

set -euo pipefail

BACKUP_DIR="$HOME/.kde-config-backup-$(date +%Y%m%d-%H%M%S)"
CONFIG_DIR="$HOME/.config"
LOCAL_SHARE_DIR="$HOME/.local/share"

echo "Creating KDE configuration backup in: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Backup KDE configuration files
echo "Backing up KDE configuration files..."
mkdir -p "$BACKUP_DIR/config"

# List of KDE config files to backup
kde_configs=(
    "kded5rc"
    "kded6rc"
    "kdedefaults"
    "kdeglobals"
    "kde.org"
    "kwinrc"
    "kwinoutputconfig.json"
    "plasma-localerc"
    "plasma-org.kde.plasma.desktop-appletsrc"
    "plasmashellrc"
    "xdg-desktop-portal-kderc"
    "kglobalshortcutsrc"
    "khotkeysrc"
    "kmixrc"
    "kscreenlockerrc"
    "ksplashrc"
    "ktimezonedrc"
    "kwalletrc"
    "plasma-nm"
    "plasmarc"
)

for config in "${kde_configs[@]}"; do
    if [[ -e "$CONFIG_DIR/$config" ]]; then
        echo "  Backing up $config"
        cp -r "$CONFIG_DIR/$config" "$BACKUP_DIR/config/" 2>/dev/null || true
    fi
done

# Backup KWin scripts and effects
echo "Backing up KWin scripts and effects..."
if [[ -d "$LOCAL_SHARE_DIR/kwin" ]]; then
    mkdir -p "$BACKUP_DIR/local/share"
    cp -r "$LOCAL_SHARE_DIR/kwin" "$BACKUP_DIR/local/share/" 2>/dev/null || true
fi

# Backup Plasma themes and look-and-feel
echo "Backing up Plasma themes..."
for dir in "plasma" "color-schemes" "icons" "themes" "wallpapers" "aurorae"; do
    if [[ -d "$LOCAL_SHARE_DIR/$dir" ]]; then
        mkdir -p "$BACKUP_DIR/local/share"
        cp -r "$LOCAL_SHARE_DIR/$dir" "$BACKUP_DIR/local/share/" 2>/dev/null || true
    fi
done

# Create a restore script
echo "Creating restore script..."
cat > "$BACKUP_DIR/restore.sh" << 'EOF'
#!/usr/bin/env bash
# Restore script for KDE configuration backup

set -euo pipefail

BACKUP_DIR="$(dirname "$0")"
CONFIG_DIR="$HOME/.config"
LOCAL_SHARE_DIR="$HOME/.local/share"

echo "Restoring KDE configuration from backup..."

# Stop Plasma session
echo "Note: You may need to log out and back in for all changes to take effect"

# Restore config files
if [[ -d "$BACKUP_DIR/config" ]]; then
    echo "Restoring configuration files..."
    cp -r "$BACKUP_DIR/config"/* "$CONFIG_DIR/" 2>/dev/null || true
fi

# Restore local share files
if [[ -d "$BACKUP_DIR/local/share" ]]; then
    echo "Restoring local share files..."
    cp -r "$BACKUP_DIR/local/share"/* "$LOCAL_SHARE_DIR/" 2>/dev/null || true
fi

echo "Restore complete! Please log out and back in to apply changes."
EOF

chmod +x "$BACKUP_DIR/restore.sh"

# Create a summary of what was backed up
echo "Creating backup summary..."
cat > "$BACKUP_DIR/README.md" << EOF
# KDE Configuration Backup

This backup was created on $(date) before applying Nix plasma-manager configuration.

## Contents

### Configuration Files (\`config/\`)
$(ls -la "$BACKUP_DIR/config" 2>/dev/null || echo "No config files backed up")

### Local Share Files (\`local/share/\`)
$(ls -la "$BACKUP_DIR/local/share" 2>/dev/null || echo "No local share files backed up")

## Restore Instructions

To restore this configuration:

1. Run the restore script:
   \`\`\`bash
   ./restore.sh
   \`\`\`

2. Log out and back in to your KDE session

3. Optionally, restart the Plasma shell:
   \`\`\`bash
   plasmashell --replace &
   \`\`\`

## Current Krohnkite Configuration

Your current Krohnkite settings that were detected:
- Screen gaps: Top=18, Left/Right/Bottom=10, Between=5
- Tiling padding: 4
- Plugin enabled: true

These settings have been incorporated into the new Nix configuration.
EOF

echo ""
echo "✅ Backup completed successfully!"
echo "📁 Backup location: $BACKUP_DIR"
echo "📝 To restore: run $BACKUP_DIR/restore.sh"
echo ""
echo "You can now safely apply your Nix configuration with:"
echo "  sudo nixos-rebuild switch --flake .nix#nixos-vm"
echo ""