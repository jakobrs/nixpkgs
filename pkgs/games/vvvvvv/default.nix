{ stdenv, stdenvNoCC, fetchurl, fetchFromGitHub, requireFile
, SDL2, SDL2_mixer, cmake, ninja
, fullGame ? false }:

let
  # if the user does not own the full game, build the Make and Play edition
  flags = if fullGame then [] else [ "-DMAKEANDPLAY" ];

in stdenv.mkDerivation rec {
  pname = "vvvvvv-bin";
  version = "unstable-2020-02-02";

  src = fetchFromGitHub {
    owner = "TerryCavanagh";
    repo = "VVVVVV";
    rev = "4bc76416f551253452012d28e2bc049087e2be73";
    sha256 = "1sc64f7sxf063bdgnkg23vc170chq2ix25gs836hyswx98iyg5ly";
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

  meta = with stdenv.lib; {
    description = "A retro-styled platform game";
    longDescription = ''
      VVVVVV is a platform game all about exploring one simple mechanical
      idea - what if you reversed gravity instead of jumping?
    '';
    homepage = "https://thelettervsixtim.es";
    license = licenses.unfreeRedistributable;
    maintainers = [ maintainers.dkudriavtsev ];
    platforms = platforms.all;
  };
}
