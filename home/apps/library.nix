{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.local.apps.defaultApps;
in
{
  options.local.apps.defaultApps.enable = mkEnableOption "Default app library";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      chromium
      darktable
      deluge
      discord
      firefox
      gperftools
      gwenview
      helix
      lutris
      mpv
      neovim
      obs-studio
      pavucontrol
      pdfarranger
      prismlauncher
      qpdfview
      tdesktop
      vlc
      vscodium-fhs
      zola
      zoom-us
    ];

    xdg.mimeApps.defaultApplications = {
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "application/pdf" = [ "qpdfview.desktop" ];
    };
  };
}
