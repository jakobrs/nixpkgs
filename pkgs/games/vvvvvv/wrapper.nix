{ lib, stdenvNoCC, vvvvvv-bin, fetchurl, requireFile }:

let
  fullGame = vvvvvv-bin.fullGame;
  dataZip = if fullGame then requireFile {
    # the data file for the full game
    name = "data.zip";
    sha256 = "1q2pzscrglmwfgdl8yj300wymwskh51iq66l4xcd0qk0q3g3rbkg";
    message = ''
      In order to install VVVVVV, you must first download the game's
      data file (data.zip) as it is not released freely.
      Once you have downloaded the file, place it in your current
      directory, use the following command and re-run the installation:
      nix-prefetch-url file://\$PWD/data.zip
    '';
  } else fetchurl {
    # the data file for the free Make and Play edition
    url = https://thelettervsixtim.es/makeandplay/data.zip;
    name = "mapdata.zip";
    sha256 = "1q2pzscrglmwfgdl8yj300wymwskh51iq66l4xcd0qk0q3g3rbkg";
  };

in stdenvNoCC.mkDerivation rec {
  pname = "vvvvvv";
  version = "unstable-2020-03-13";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/VVVVVV << EOF
    #!/bin/sh
    exec -a "\$0" ${vvvvvv-bin}/bin/VVVVVV -assets ${dataZip} "\$@"
    EOF
    chmod a+x $out/bin/VVVVVV
  '';

  meta = with lib; {
    description = "A retro-styled platform game";
    longDescription = ''
      VVVVVV is a platform game all about exploring one simple mechanical
      idea - what if you reversed gravity instead of jumping?
    '';
    homepage = "https://thelettervsixtim.es";
    license = if fullGame then licenses.unfree else licenses.unfreeRedistributable;
    maintainers = [ maintainers.dkudriavtsev ];
    platforms = platforms.linux;
  };
}
