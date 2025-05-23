{ inputs, ... }:
final: prev: {
  nix4vscode = (inputs.nix4vscode.overlays.forVscode final prev).nix4vscode;
}
