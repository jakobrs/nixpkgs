{ stdenv, fetchurl, fetchFromGitHub, requireFile
, SDL2, SDL2_mixer, cmake, ninja
, fullGame ? false }:

let
  # if the user does not own the full game, build the Make and Play edition
  flags = if fullGame then [] else [ "-DMAKEANDPLAY" ];

in stdenv.mkDerivation rec {
  pname = "vvvvvv-bin";
  version = "unstable-2020-02-09";

  src = fetchFromGitHub {
    owner = "TerryCavanagh";
    repo = "VVVVVV";
    rev = "3273b4ab554c369311007212b4341ff8e3884b16";
    sha256 = "0hfnc31sbrixrqb24g1x8vgkkgz6wabmw35j0dqd7k97qwjcb3k8";
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
