{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.local.apps.defaultApps;
in
{
  options.local.apps.defaultApps.enable = mkEnableOption "Default app library";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [

      anydesk

      # (anydesk.overrideAttrs {
      #   version = "6.3.2";
      #   src = pkgs.fetchurl {
      #     url = "https://download.anydesk.com/linux/anydesk-6.3.2-amd64.tar.gz";
      #     sha256 = "sha256-nSY4qHRsEvQk4M3JDHalAk3C6Y21WlfDQ2Gpp6/jjMs=";
      #   };
      # })

      ((gajim.override {
        enableSecrets = true;
        enableJingle = true;
        enableSpelling = true;
        enableUPnP = true;
        enableAppIndicator = true;
        enableE2E = true;
        enableRST = true;
      }).overrideAttrs (super: { buildInputs = super.buildInputs ++ [ pkgs.gsound alsa-lib farstream ]; }))


      chromium
      darktable
      deluge
      discord
      element-desktop
      firefox
      gperftools
      kdePackages.gwenview
      helix
      jetbrains.pycharm-professional
      libreoffice
      lutris
      maim
      mpv
      neovim
      obs-studio
      pavucontrol
      pdfarranger
      prismlauncher
      qpdfview
      remmina
      slack
      tdesktop
      vlc
      vscodium-fhs
      xclip
      xdg-utils
      xorg.xmodmap
      yubikey-manager
      zola
      zoom-us
    ];

    programs.gpg = {
      enable = true;
    };

    services.gpg-agent = {
      enable = true;

      enableZshIntegration = true;
      enableBashIntegration = true;

      enableExtraSocket = true;
      enableSshSupport = true;

      defaultCacheTtl = 3600 * 3;
      defaultCacheTtlSsh = 3600 * 3;

      maxCacheTtl = 3600 * 6;
      maxCacheTtlSsh = 3600 * 6;

      pinentry.package = pkgs.pinentry-emacs;
    };


    xdg = {
      enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "application/octet-stream" = [ "firefox.desktop" ];
          "binary/octet-stream" = [ "codium.desktop" ];
          "text/x-csrc" = [ "codium.desktop" ];
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
          "application/msword" = [ "libreoffice.desktop" ];
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "libreoffice.desktop" ];
        };
      };
      # portal = {
      #   enable = true;
      #   xdgOpenUsePortal = true;
      #   wlr.enable = true;
      #   extraPortals = [ pkgs.xdg-desktop-portal-xapp ];
      #   config.common.default = "*";
      # };
    };
  };
}
