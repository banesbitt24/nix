#!/usr/bin/env bash
# SSH Key Setup Script for NixOS
# This script generates SSH keys and helps you add them to your Nix configuration

set -euo pipefail

# Configuration
SSH_KEY_TYPE="ed25519"
SSH_KEY_PATH="$HOME/.ssh/id_$SSH_KEY_TYPE"
SSH_PUB_KEY_PATH="$SSH_KEY_PATH.pub"
BACKUP_DIR="$HOME/.ssh-backup-$(date +%Y%m%d-%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to get user email
get_user_email() {
    local email=""
    
    # Try to get email from git config
    if command -v git >/dev/null 2>&1; then
        email=$(git config --global user.email 2>/dev/null || echo "")
    fi
    
    # If no git email, prompt user
    if [[ -z "$email" ]]; then
        echo -n "Enter your email address: "
        read -r email
    else
        echo -n "Use email from git config ($email)? [Y/n]: "
        read -r response
        if [[ "$response" =~ ^[Nn]$ ]]; then
            echo -n "Enter your email address: "
            read -r email
        fi
    fi
    
    echo "$email"
}

# Function to backup existing SSH keys
backup_existing_keys() {
    if [[ -d "$HOME/.ssh" ]]; then
        print_info "Backing up existing SSH directory to $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        cp -r "$HOME/.ssh"/* "$BACKUP_DIR/" 2>/dev/null || true
        print_success "Backup completed"
    fi
}

# Function to generate SSH key
generate_ssh_key() {
    local email="$1"
    
    print_info "Generating SSH key pair..."
    
    # Create .ssh directory if it doesn't exist
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    
    # Generate the key
    ssh-keygen -t "$SSH_KEY_TYPE" -C "$email" -f "$SSH_KEY_PATH" -N ""
    
    # Set proper permissions
    chmod 600 "$SSH_KEY_PATH"
    chmod 644 "$SSH_PUB_KEY_PATH"
    
    print_success "SSH key pair generated successfully"
}

# Function to display the public key
show_public_key() {
    print_info "Your SSH public key:"
    echo ""
    echo "$(cat "$SSH_PUB_KEY_PATH")"
    echo ""
}

# Function to update Nix configuration
update_nix_config() {
    local pub_key="$(cat "$SSH_PUB_KEY_PATH")"
    local users_nix_file=".nix/modules/nixos/users.nix"
    
    if [[ -f "$users_nix_file" ]]; then
        print_info "Updating Nix configuration with your SSH public key..."
        
        # Create a temporary file with the updated configuration
        local temp_file=$(mktemp)
        
        # Read the file and replace the placeholder
        while IFS= read -r line; do
            if [[ "$line" == *"# Add your SSH public key here"* ]]; then
                echo "      \"$pub_key\""
            elif [[ "$line" == *"# Example: \"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbcd1234..."* ]] || \
                 [[ "$line" == *"# \"ssh-rsa AAAAB3NzaC1yc2EAAAA..."* ]]; then
                # Skip example lines
                continue
            else
                echo "$line"
            fi
        done < "$users_nix_file" > "$temp_file"
        
        # Replace the original file
        mv "$temp_file" "$users_nix_file"
        
        print_success "Nix configuration updated with your SSH public key"
    else
        print_warning "Could not find $users_nix_file - you'll need to manually add the key"
    fi
}

# Function to test SSH connection
test_ssh_connection() {
    local service="$1"
    local hostname="$2"
    
    print_info "Testing SSH connection to $service..."
    
    if ssh -T -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$hostname" 2>&1 | grep -q "successfully authenticated"; then
        print_success "SSH connection to $service working!"
    else
        print_warning "SSH connection test failed - you may need to add the key to $service"
    fi
}

# Function to show service-specific instructions
show_service_instructions() {
    echo ""
    print_info "To add your SSH key to various services:"
    echo ""
    echo "📱 GitHub:"
    echo "   1. Go to https://github.com/settings/keys"
    echo "   2. Click 'New SSH key'"
    echo "   3. Paste your public key above"
    echo ""
    echo "🦊 GitLab:"
    echo "   1. Go to https://gitlab.com/-/profile/keys"
    echo "   2. Click 'Add key'"
    echo "   3. Paste your public key above"
    echo ""
    echo "🌲 Codeberg:"
    echo "   1. Go to https://codeberg.org/user/settings/keys"
    echo "   2. Click 'Add Key'"
    echo "   3. Paste your public key above"
    echo ""
    echo "☁️  For other servers:"
    echo "   Use: ssh-copy-id user@hostname"
    echo ""
}

# Function to show next steps
show_next_steps() {
    echo ""
    print_info "Next steps:"
    echo ""
    echo "1. 📋 Copy your public key above and add it to your Git hosting service"
    echo "2. 🔄 Rebuild your NixOS configuration:"
    echo "   sudo nixos-rebuild switch --flake .nix#nixos-vm"
    echo "3. 🧪 Test your SSH connection:"
    echo "   ssh -T git@github.com"
    echo "   ssh -T git@gitlab.com"
    echo "   ssh -T git@codeberg.org"
    echo ""
    echo "4. 📁 Your keys are located at:"
    echo "   Private key: $SSH_KEY_PATH"
    echo "   Public key:  $SSH_PUB_KEY_PATH"
    echo ""
    if [[ -d "$BACKUP_DIR" ]]; then
        echo "5. 🗂️  Previous SSH config backed up to: $BACKUP_DIR"
        echo ""
    fi
}

# Main execution
main() {
    print_info "SSH Key Setup for NixOS"
    echo ""
    
    # Check if key already exists
    if [[ -f "$SSH_KEY_PATH" ]]; then
        echo -n "SSH key already exists. Regenerate? [y/N]: "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_info "Using existing SSH key"
            show_public_key
            show_service_instructions
            show_next_steps
            exit 0
        else
            backup_existing_keys
        fi
    fi
    
    # Get user email
    email=$(get_user_email)
    
    # Generate SSH key
    generate_ssh_key "$email"
    
    # Show the public key
    show_public_key
    
    # Update Nix configuration
    update_nix_config
    
    # Show instructions
    show_service_instructions
    show_next_steps
    
    print_success "SSH key setup completed successfully!"
}

# Run main function
main "$@"