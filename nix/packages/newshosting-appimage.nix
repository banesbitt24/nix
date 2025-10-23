{ lib
, appimageTools
}:

let
  pname = "newshosting";
  version = "3.8.9";

  src = ./Newshosting-x86_64.AppImage;

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    libsForQt5.qt5.qtwayland
  ];

  extraInstallCommands = ''
    # Rename the original binary
    mv $out/bin/${pname} $out/bin/.${pname}-wrapped

    # Create simple wrapper script with absolute path
    cat > $out/bin/${pname} <<EOF
#!/bin/sh
# Replace bad desktop file with symlink to our good one
mkdir -p ~/.local/share/applications
rm -f ~/.local/share/applications/newshosting.desktop
ln -sf $out/share/applications/newshosting.desktop ~/.local/share/applications/newshosting.desktop
# Set Qt platform and launch
export QT_QPA_PLATFORM=xcb
exec "$out/bin/.${pname}-wrapped" "\$@"
EOF
    chmod +x $out/bin/${pname}

    # Install desktop file and icon
    install -Dm644 ${appimageContents}/newshosting.desktop $out/share/applications/newshosting.desktop
    install -Dm644 ${appimageContents}/newshosting.svg $out/share/icons/hicolor/scalable/apps/newshosting.svg

    # Fix desktop file
    substituteInPlace $out/share/applications/newshosting.desktop \
      --replace 'Exec=newshosting' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Newshosting Usenet client and downloader";
    homepage = "https://www.newshosting.com";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
