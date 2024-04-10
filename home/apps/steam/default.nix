{ pkgs, lib, config, ... }:
with lib; let
  cfg = config.local.apps.steam;
in
{
  options.local.apps.steam.enable = mkEnableOption "Steam";
  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.callPackage ./package.nix { })
      pkgs.protonup
      pkgs.winetricks
      pkgs.protontricks
    ];
  };
} 
