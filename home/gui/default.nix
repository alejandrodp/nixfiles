{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.local.gui;
in
{
  options.local.gui = {
    enable = mkEnableOption "GUI settings and programs";
    desktop = mkEnableOption "i3 desktop envirorment";
  };

  imports = [
    ./autorandr.nix
    ./fonts.nix
    ./gtk.nix
    ./i3.nix
    ./polybar.nix
    ./startx.nix
  ];


  config = mkIf cfg.enable {

    local.gui = {
      fonts.enable = mkDefault true;
      gtk.enable = mkDefault true;

      autorandr.enable = mkDefault cfg.desktop;
      i3.enable = mkDefault cfg.desktop;
      polybar.enable = mkDefault cfg.desktop;
      startx.enable = mkDefault cfg.desktop;
    };

    services = mkIf cfg.desktop {
      picom = {
        enable = true;
      };

      dunst = {
        enable = true;
      };

      betterlockscreen = {
        enable = false;
      };

      playerctld.enable = true;
    };

    xdg.mimeApps.enable = true;
  };
}
