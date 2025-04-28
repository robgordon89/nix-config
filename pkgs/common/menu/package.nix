{ lib
, stdenv
, fetchFromGitHub
, bash
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "menu";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "iandennismiller";
    repo = "menu.sh";
    rev = "main";
    sha256 = "sha256-Ypq5dQMc2glVUnN7u7cv4UMNguZ+T4Nlfx/5ZMCxnvc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp menu.sh $out/bin/menu
    chmod +x $out/bin/menu
    wrapProgram $out/bin/menu \
      --prefix PATH : ${lib.makeBinPath [ bash ]}
  '';

  meta = with lib; {
    description = "Simple menu system for the command line";
    homepage = "https://github.com/iandennismiller/menu.sh";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
