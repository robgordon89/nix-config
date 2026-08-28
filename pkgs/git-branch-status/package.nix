{
  lib,
  writeShellApplication,
  coreutils,
  findutils,
  git,
}:
writeShellApplication {
  name = "git-branch-status";

  # The script deliberately runs without errexit: nearly every git query is
  # used as a predicate and a non-zero exit is expected control flow.
  bashOptions = [
    "nounset"
    "pipefail"
  ];

  runtimeInputs = [
    coreutils
    findutils
    git
  ];

  text = builtins.readFile ./git-branch-status.sh;

  meta = {
    description = "Show which branch each git repo is on compared to its default branch";
    mainProgram = "git-branch-status";
    platforms = lib.platforms.unix;
  };
}
