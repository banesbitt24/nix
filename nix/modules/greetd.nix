# greetd.nix
{ pkgs, lib, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";
        user = "greeter";
      };
      # Autologin configuration
      initial_session = {
        command = "hyprland"; # or "plasma" if you prefer KDE Plasma
        user = "brandon";
      };
    };
  };

  # Ensure required packages are available
  environment.systemPackages = with pkgs; [
    cage
    regreet
  ];

  programs.regreet = {
    enable = true;
    settings = {
      appearance = {
        greeting_msg = "Welcome to quicksilver";
      };
    };
  };

  # Custom CSS styling for regreet to match Nord/Hyprland theme
  environment.etc."greetd/regreet.css".text = ''
    window {
      background-color: #2e3440;
    }

    .error-container {
      background-color: #bf616a;
      color: #eceff4;
      border-radius: 6px;
      padding: 8px;
      margin: 8px;
    }

    .error-text {
      color: #eceff4;
      font-size: 12px;
    }

    .clock-container {
      color: #eceff4;
      font-size: 24px;
      margin-bottom: 24px;
    }

    .greeting-container {
      color: #eceff4;
      font-size: 16px;
      margin-bottom: 16px;
    }

    .login-container {
      background-color: rgba(76, 86, 106, 0.3);
      border-radius: 8px;
      padding: 24px;
      margin: 16px;
    }

    .login-username entry,
    .login-password entry {
      background-color: #3b4252;
      border: 2px solid #4c566a;
      border-radius: 4px;
      color: #eceff4;
      padding: 8px;
      margin: 4px;
    }

    .login-username entry:focus,
    .login-password entry:focus {
      border-color: #5e81ac;
      outline: none;
    }

    .login-button {
      background-color: #5e81ac;
      border: none;
      border-radius: 4px;
      color: #eceff4;
      padding: 8px 16px;
      margin-top: 8px;
      font-weight: bold;
    }

    .login-button:hover {
      background-color: #81a1c1;
    }

    .session-container {
      background-color: rgba(76, 86, 106, 0.3);
      border-radius: 8px;
      margin: 8px;
    }

    .session-button {
      background-color: transparent;
      border: none;
      color: #eceff4;
      padding: 8px;
    }

    .session-button:hover {
      background-color: #5e81ac;
    }

    .power-container {
      margin: 16px;
    }

    .power-button {
      background-color: transparent;
      border: 2px solid #4c566a;
      border-radius: 4px;
      color: #eceff4;
      padding: 8px;
      margin: 4px;
    }

    .power-button:hover {
      border-color: #5e81ac;
      background-color: rgba(94, 129, 172, 0.2);
    }
  '';

  # Create Hyprland session desktop entry for regreet
  environment.etc."wayland-sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Comment=A dynamic tiling Wayland compositor
    Exec=hyprland
    Type=Application
  '';

  # Unlock GPG keyring on login
  security.pam.services.greetd.enableGnomeKeyring = true;
}
