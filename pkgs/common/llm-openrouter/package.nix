{ pkgs }:
pkgs.python313Packages.buildPythonPackage rec {
  pname = "llm-openrouter";
  version = "0.3";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "simonw";
    repo = "llm-openrouter";
    rev = version;
    sha256 = "sha256-mf+kZz1vyTjkNB3qjJkf6DAFjqESQxIhINLJ7BBAdkk=";
  };

  propagatedBuildInputs = with pkgs.python313Packages; [ llm ];
}
