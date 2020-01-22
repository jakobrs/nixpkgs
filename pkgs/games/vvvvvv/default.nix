{ lib, stdenv, fetchurl, fetchFromGitHub, requireFile
, SDL2, SDL2_mixer, cmake, ninja
, fullGame ? false }:

let
  # if the user does not own the full game, build the Make and Play edition
  flags = if fullGame then [] else [ "-DMAKEANDPLAY" ];

in stdenv.mkDerivation rec {
  pname = "vvvvvv-bin";
  version = "unstable-2020-03-13";

  src = fetchFromGitHub {
    owner = "TerryCavanagh";
    repo = "VVVVVV";
    rev = "9175c087631a91d24f038fc95c18990a32bdd1b2";
    sha256 = "0khrwmqb1yp974nnc597pbhrjf3plvimxvlwx7jgg032xs896hhl";
  };

  CFLAGS = flags;
  CXXFLAGS = flags;

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ SDL2 SDL2_mixer ];

  sourceRoot = "source/desktop_version";

  installPhase = ''
    mkdir -p $out/bin
    cp VVVVVV $out/bin/VVVVVV
  '';

  passthru.fullGame = fullGame;

  meta = with lib; {
    description = "A retro-styled platform game";
    longDescription = ''
      VVVVVV is a platform game all about exploring one simple mechanical
      idea - what if you reversed gravity instead of jumping?
    '';
    homepage = "https://thelettervsixtim.es";
    license = licenses.unfreeRedistributable;
    maintainers = [ maintainers.dkudriavtsev ];
    platforms = platforms.linux;
  };
}
