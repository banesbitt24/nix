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

  extraInstallCommands = ''
    # Install desktop file and icon
    install -Dm444 ${appimageContents}/newshosting.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/newshosting.svg $out/share/icons/hicolor/scalable/apps/newshosting.svg
  '';

  meta = with lib; {
    description = "Newshosting Usenet client and downloader";
    homepage = "https://www.newshosting.com";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
