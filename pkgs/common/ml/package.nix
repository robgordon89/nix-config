{ lib
, stdenv
, buildGoModule
, installShellFiles
,
}:

buildGoModule rec {
  pname = "ml";
  version = "1.0.0";

  src = builtins.fetchGit {
    url = "ssh://git@github.com/mailerlite/cli.git";
    # tag = "v${version}";
    rev = "ba72622a399cbd2176624c20c5b76b3942a30696";
    # hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  subPackages = [ "./cmd/ml" ];

  vendorHash = "sha256-tdp8jCt6/eJW+MBmf8AfxHoTyFkJMy72/x7BrPcUxio=";

  # Disable caching
  preferLocalBuild = true;
  allowSubstitutes = false;

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ml \
      --bash <($out/bin/ml completion bash) \
      --fish <($out/bin/ml completion fish) \
      --zsh <($out/bin/ml completion zsh)
  '';

  meta = with lib; {
    description = "MailerLite CLI tool";
    homepage = "https://github.com/mailerlite/cli";
    changelog = "https://github.com/mailerlite/cli/releases/tag/v${version}";
    license = licenses.unfree;
    # This prevents the package from being cached publicly
    hydraPlatforms = [ ];
  };
}
