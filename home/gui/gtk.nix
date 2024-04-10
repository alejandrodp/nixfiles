{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.local.gui.gtk;
in
{
  options.local.gui.gtk.enable = mkEnableOption "GTK related programs";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gruvbox-dark-icons-gtk
      libsForQt5.breeze-gtk
    ];
  };
}
