{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.local.gui.autorandr;
in
{
  options.local.gui.autorandr.enable = mkEnableOption "Autorandr";
  config = mkIf cfg.enable {
    programs.autorandr = {
      enable = true;
      profiles."${config.local.platform}" = config.local.display.autorandrProfile;
    };
  };
}
