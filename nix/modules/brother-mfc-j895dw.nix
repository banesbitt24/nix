{ pkgs, lib, ... }:

let
  mfcj895dwlpr = pkgs.stdenv.mkDerivation rec {
    pname = "brother-mfc-j895dw-lpr";
    version = "4.0.8";
    
    src = ../printer/brother-mfc-j895dw;
    
    nativeBuildInputs = with pkgs; [ makeWrapper ];
    
    installPhase = ''
      mkdir -p $out/opt/brother/Printers/mfcj895dw
      cp -r opt/brother/Printers/mfcj895dw/* $out/opt/brother/Printers/mfcj895dw/
      
      # Make binaries executable
      chmod +x $out/opt/brother/Printers/mfcj895dw/lpd/*
      chmod +x $out/opt/brother/Printers/mfcj895dw/cupswrapper/*
      
      # Create symlinks for the filters
      mkdir -p $out/lib/cups/filter
      ln -s $out/opt/brother/Printers/mfcj895dw/cupswrapper/brother_lpdwrapper_mfcj895dw $out/lib/cups/filter/
      
      # Install PPD file
      mkdir -p $out/share/cups/model/Brother
      cp $out/opt/brother/Printers/mfcj895dw/cupswrapper/brother_mfcj895dw_printer_en.ppd $out/share/cups/model/Brother/
    '';
    
    meta = with lib; {
      description = "Brother MFC-J895DW LPR driver";
      homepage = "https://www.brother.com/";
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  };
  
  mfcj895dwcupswrapper = pkgs.stdenv.mkDerivation rec {
    pname = "brother-mfc-j895dw-cupswrapper";
    version = "4.0.8";
    
    src = ../printer/brother-mfc-j895dw;
    
    nativeBuildInputs = with pkgs; [ makeWrapper ];
    buildInputs = [ mfcj895dwlpr ];
    
    installPhase = ''
      mkdir -p $out/lib/cups/filter
      mkdir -p $out/share/cups/model/Brother
      
      # Install cupswrapper
      cp opt/brother/Printers/mfcj895dw/cupswrapper/cupswrappermfcj895dw $out/lib/cups/filter/
      chmod +x $out/lib/cups/filter/cupswrappermfcj895dw
      
      # Install PPD
      cp opt/brother/Printers/mfcj895dw/cupswrapper/brother_mfcj895dw_printer_en.ppd $out/share/cups/model/Brother/
      
      # Wrap the cupswrapper to find the LPR driver
      wrapProgram $out/lib/cups/filter/cupswrappermfcj895dw \
        --prefix PATH : ${lib.makeBinPath [ pkgs.coreutils pkgs.gnused pkgs.gnugrep ]} \
        --set PRINTER_MODEL mfcj895dw \
        --set LPR_COMMAND ${mfcj895dwlpr}/opt/brother/Printers/mfcj895dw/lpd/filter_mfcj895dw
    '';
    
    meta = with lib; {
      description = "Brother MFC-J895DW CUPS wrapper";
      homepage = "https://www.brother.com/";
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  };
in
{
  # Export the packages for use in other modules
  environment.systemPackages = [ mfcj895dwlpr mfcj895dwcupswrapper ];
  
  # Make packages available as pkgs.mfcj895dwlpr and pkgs.mfcj895dwcupswrapper
  nixpkgs.overlays = [
    (final: prev: {
      mfcj895dwlpr = mfcj895dwlpr;
      mfcj895dwcupswrapper = mfcj895dwcupswrapper;
    })
  ];
}