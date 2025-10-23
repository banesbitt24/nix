{ lib
, appimageTools
, fetchurl
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
    # Install desktop file and icon
    install -Dm644 ${appimageContents}/newshosting.desktop $out/share/applications/newshosting.desktop
    install -Dm644 ${appimageContents}/newshosting.svg $out/share/icons/hicolor/scalable/apps/newshosting.svg

    # Fix desktop file to set Qt platform and use full path
    substituteInPlace $out/share/applications/newshosting.desktop \
      --replace 'Exec=newshosting' 'Exec=env QT_QPA_PLATFORM=xcb ${pname}'
  '';

  meta = with lib; {
    description = "Newshosting Usenet client and downloader";
    homepage = "https://www.newshosting.com";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
