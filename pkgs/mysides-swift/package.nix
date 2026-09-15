{
  lib,
  fetchFromGitHub,
  swift,
  swiftpm,
  swiftpm2nix,
  swiftPackages,
}:
let
  # Upstream pins swift-argument-parser 1.8.2, whose manifest needs
  # swift-tools-version 6.0; nixpkgs ships SwiftPM 5.10. The vendored pin file
  # holds 1.7.1 instead, which still satisfies the `from: "1.3.0"` constraint.
  generated = swiftpm2nix.helpers ./nix;
in
swiftPackages.stdenv.mkDerivation {
  pname = "mysides-swift";
  version = "2.0.0-unstable-2026-08-16";

  src = fetchFromGitHub {
    owner = "seakrebel";
    repo = "mysides-swift";
    rev = "c281bb6df06667dff5333ec58705d33730457a44";
    hash = "sha256-urmPTsOuazl2N6/hC92TYQ6ESnCIi8CSaSKKYT/12i0=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  configurePhase = generated.configure;

  installPhase = ''
    runHook preInstall

    install -Dm755 "$(swiftpmBinPath)/mysides" -t $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Manage macOS Finder sidebar favorites";
    homepage = "https://github.com/seakrebel/mysides-swift";
    license = lib.licenses.mit;
    mainProgram = "mysides";
    platforms = lib.platforms.darwin;
  };
}
