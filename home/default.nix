{ self, nixpkgs, unstable, hm-isolation, nixGL }:
{ config, pkgs, lib, ... }:
with lib;
{
  imports = [
    (hm-isolation.homeManagerModule)
    ./apps
    ./allowUnfreeWhitelist.nix
    ./gui
    ./isolation.nix
    ./options.nix
    ./cli.nix
    # ./zed.nix
  ];

  # programs.zed.enable = true;


  gtk = {
    enable = true;

    iconTheme = {
      name = "Breeze-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Breeze-Dark";
    };

    # gtk2.extraConfig = ''
    #   gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
    #   gtk-menu-images=1
    #   gtk-button-images=1
    # '';

    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = 1;
    # };
    # gtk4.extraConfig = {
    #   gtk-application-prefer-dark-theme = 1;
    # };
  };

  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = "gtk2";
  };



  nixpkgs.overlays = [ self.overlay nixGL.overlay ];

  home = {
    stateVersion = "23.11"; # No tocar esto
    username = "adp";
    homeDirectory = "/home/adp";
    sessionVariables = {
      "EDITOR" = "nano";
      "TERMINAL" = "xterm-256color";

      _JAVA_OPTIONS = concatStringsSep " " [
        "-Dawt.useSystemAAFontSettings=on"
        "-Dswing.aatext=true"
        "-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
        "-Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
      ];
    };
    keyboard = {
      layout = "us";
      variant = "altgr-intl";
    };
  };

  xdg.enable = true;

  xdg.configFile."home-manager" = mkIf (!config.home.isolation.active) {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix";
  };

  nix.registry = {
    "system".to = {
      type = "path";
      path = "/home/adp/nix";
    };

    "nixpkgs".flake = nixpkgs;
    "unstable".flake = unstable;
  };

  programs.home-manager.enable = true;

  local = {
    apps.enable = mkDefault (!config.home.isolation.active);

    gui = {
      enable = mkDefault true;
      desktop = mkDefault (!config.home.isolation.active);
    };
  };
}
