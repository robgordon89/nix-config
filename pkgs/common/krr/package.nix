# This is broken dont use
{ pkgs
, lib
, fetchFromGitHub
, testers
, krr
,
}:

pkgs.python312Packages.buildPythonPackage rec {
  pname = "krr";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "krr";
    tag = "v${version}";
    hash = "sha256-Bc1Ql3z/UmOXE2RJYC5/sE4a3MFdE06I3HwKY+SdSlk=";
  };

  postPatch = ''
    substituteInPlace robusta_krr/__init__.py \
      --replace-warn '1.7.0-dev' '${version}'

    substituteInPlace pyproject.toml \
      --replace-warn '1.7.0-dev' '${version}' \
      --replace-fail 'aiostream = "^0.4.5"' 'aiostream = "*"' \
      --replace-fail 'kubernetes = "^26.1.0"' 'kubernetes = "*"' \
      --replace-fail 'pydantic = "1.10.7"' 'pydantic = "*"' \
      --replace-fail 'typer = { extras = ["all"], version = "^0.7.0" }' 'typer = { extras = ["all"], version = "*" }'
  '';

  propagatedBuildInputs = with pkgs.python312Packages; [
    aiostream
    alive-progress
    kubernetes
    numpy
    poetry-core
    prometheus-api-client
    prometrix
    pydantic_1
    slack-sdk
    typer
  ];

  nativeCheckInputs = with pkgs.python312Packages; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "robusta_krr"
  ];

  passthru.tests.version = testers.testVersion {
    package = krr;
    command = "krr version";
  };

  meta = with lib; {
    description = "Prometheus-based Kubernetes resource recommendations";
    longDescription = ''
      Robusta KRR (Kubernetes Resource Recommender) is a CLI tool for optimizing
      resource allocation in Kubernetes clusters. It gathers Pod usage data from
      Prometheus and recommends requests and limits for CPU and memory. This
      reduces costs and improves performance.
    '';
    homepage = "https://github.com/robusta-dev/krr";
    changelog = "https://github.com/robusta-dev/krr/releases/tag/v${src.rev}";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ azahi ];
    mainProgram = "krr";
  };
}
