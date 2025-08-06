{ pkgs, config, lib, ... }:
with lib;
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "anydesk"
    "discord"
    "pycharm-professional"
    "rar"
    "slack"
    "steam"
    "steam-original"
    "steam-run"
    "teams"
    "vscode-extension-ms-vscode-cpptools"
    "zoom"
  ];
}
