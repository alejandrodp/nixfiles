{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.local.apps;
in
{
  options.local.apps.enable = mkEnableOption "Applications and tools";
  imports = [
    ./library.nix
    ./steam
    ./terminal
  ];
}
