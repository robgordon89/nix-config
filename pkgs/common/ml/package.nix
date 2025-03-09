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
    rev = "6cd1a9d071bd7dd7da7a5198ac373d86fc366b8a";
    # hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  subPackages = [ "./cmd" ];

  vendorHash = "sha256-aCmQTXD8JkO2Jd/wVakBYTMKe6AZGEeJBCbV66en6pI=";

  # Disable caching
  preferLocalBuild = true;
  allowSubstitutes = false;

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mv $out/bin/cmd $out/bin/ml
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
