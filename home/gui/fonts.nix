{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.local.gui.fonts;
in
{
  options.local.gui.fonts.enable = mkEnableOption "Font management";
  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      jetbrains-mono
    ];
  };
}
